package com.o2a4.chattcp.handler;

import com.o2a4.chattcp.decoder.JwtDecoder;
import com.o2a4.chattcp.model.Bridge;
import com.o2a4.chattcp.repository.ChannelIdChannelRepository;
import com.o2a4.chattcp.repository.TrainChannelGroupRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.data.redis.core.ReactiveRedisTemplate;
import org.springframework.http.MediaType;
import org.springframework.stereotype.Component;
import org.springframework.web.reactive.function.server.ServerRequest;
import org.springframework.web.reactive.function.server.ServerResponse;
import reactor.core.publisher.Flux;
import reactor.core.publisher.Mono;

import java.util.Map;

@Slf4j
@RequiredArgsConstructor
@Component
public class RestHandler {

    @Value("${server.port}")
    private String port;

    private final ReactiveRedisTemplate<String,String> redisTemplate;

    private final JwtDecoder jwtDecoder;

    private final TrainChannelGroupRepository tcgRepo;
    private final ChannelIdChannelRepository cidcRepo;

    public Mono<ServerResponse> roomIn(ServerRequest req) {
        /* 방 입장 요청
         1. 유효한 사용자인지 확인 - jwt 토큰
         2. Redis - 열차 번호 확인해서 방 만들거나 방에 추가
           2-a 방 만들면 : UserCG 추가, User서버 추가, Train-서버 추가 + 나중에 채널 생성 시 유저-채널ID 추가
           2-b 방 있으면 : UserCG 추가, User서버 추가 + 나중에 채널 생성 시 유저-채널ID 추가
           2-1 서버 UserCnt 증가
         3. return TCP 포트번호 */

        // TODO 생성하는 모든 데이터에 대해서 expire 설정?
        // TODO 인증 서버에 보내고
        // TODO token에서 id 디코딩
        // 1. 유효한 사용자 확인
        String token = req.headers().firstHeader("token");
        String userId = jwtDecoder.decode(token);

        // 인증서버 보낸 결과가 유효하지 않은 사용자라면
        if (false) {
            return ServerResponse.badRequest().body(Mono.just("권한이 없는 유저"), String.class);
        }

        Mono<Bridge> train = req.bodyToMono(Bridge.class)
                .switchIfEmpty(Mono.error(new IllegalStateException("user required")))
                .flatMap(data -> {
                    // 2 열차 확인
                    log.info("CHECK TRAIN");
                    String trainId = data.getData();

                    return redisTemplate.opsForHash().get("train:" + trainId, "server")
                            .switchIfEmpty(Mono.defer(() -> {
                                log.info("TRAIN {} DOES NOT EXIST", trainId);
                                return redisTemplate.opsForHash().put("train:" + trainId, "server", port)
                                        .flatMap(portRes -> {
                                            log.info("ADD USER {} TO SERVER", userId);
                                            log.info("ADD USER CG START");
                                            redisTemplate.opsForHash().put("user:" + userId, "channelGroup", trainId).subscribe(i -> {
                                                log.info("ADD USER CG END");
                                            });
                                            log.info("ADD USER SERVER START");
                                            redisTemplate.opsForHash().put("user:" + userId, "server", port).subscribe(i -> {
                                                log.info("ADD USER SERVER END");
                                            });

                                            return Mono.just("ADD USER DONE");
                                        });
                            }));
                })
                .flatMap(i -> {
                    log.info("INCREASE USER COUNT");
                    return redisTemplate.opsForValue().increment("server:" + port);
                }).map(i -> {
                    Bridge res = new Bridge();

                    res.setName("port");
                    res.setData(port);

                    return res;
                });

        return ServerResponse.ok().contentType(MediaType.APPLICATION_JSON).body(train, Bridge.class);
    }

    public Mono<ServerResponse> roomOut(ServerRequest req) {
        /* 방 퇴장 요청
         ? 1. 유효한 사용자인지 확인 - jwt 토큰
         2. Redis - 유저 ID 확인해서 방에서 퇴장
           2-1 서버 UserCnt 감소
           2-2 User (Hash) 제거
           2-a CG에 남은 사람이 없다면 : Train 서버 제거, Train CG 제거
         3. return 성공, 실패 */

        // TODO 인증 서버에 보내고
        // TODO token에서 id 디코딩

        // 1. 유효한 사용자 확인
        String token = req.headers().firstHeader("token");
        String userId = jwtDecoder.decode(token);

        // 인증서버 보낸 결과가 유효하지 않은 사용자라면
        if (false) {
            return ServerResponse.badRequest().body(Mono.just("권한이 없는 유저"), String.class);
        }

        log.info("GET USER CHANNELGROUP");
        // TODO 여러개 가져온 필드에 대해서 각각 처리해주기
        Mono<Bridge> result = redisTemplate.opsForHash().entries("user:" + userId)
                .collectMap(x-> x.getKey(), x->x.getValue())
                .flatMap(map -> {
                    log.info("REMOVE USER {}", userId);
                    log.info("MAP VALUES : {}", map.values());

                    String channelId = (String) map.get("channel");
                    String channelGroup = (String) map.get("channelGroup");

                    // channelId가 null인 경우는 아직 TCP 소켓이 연결 안된 상태
                    if (channelId != null) {
                        // 서버에서 클라이언트의 채널 닫음
                        cidcRepo.getChannelIdChannelMap().get(channelId).close();
                    }
                    // FIXME 로직을 tcp 쪽으로 다 넘길지 여기서 할 지 생각을 해봐야할듯
                    // 채널그룹이 있는데 사람이 tcp 연결전에 나간 경우 / 채널그룹을 새로 만들었는데 tcp 연결전에 나간경우
                    // 그냥 열차에 맵핑만 시키고 tcp 연결되면 redis에?

                    // 채팅방에 사람이 남았는지 확인하고 없다면 redis에서 제거
                    if (tcgRepo.getTrainChannelGroupMap().get(channelGroup).size() == 0) {
                        log.info("REMOVE TRAIN {} SERVER", channelGroup);
                        // 메모리에서 채널그룹 제거
                        tcgRepo.getTrainChannelGroupMap().remove(channelGroup);
                        // Redis에서 열차 서버 매핑정보 제거
                        redisTemplate.opsForHash().delete("train:"+channelGroup).subscribe(i -> { log.info("REMOVE REDIS TRAIN {}", channelGroup); });
                    }

                    return redisTemplate.opsForHash().delete("user:" + userId).doOnSubscribe(i -> {log.info("REMOVE USER {} REDIS", userId);});
                }).flatMap(i -> {
                    if (i.equals(true)) {
                        redisTemplate.opsForValue().decrement("server:" + port).subscribe(a -> {log.info("DECREASE USER COUNT");});
                    }
                    return Mono.just("pass");
                }).map(i -> {
                    log.info("MAKE BRIDGE");
                    Bridge res = new Bridge();
                    res.setName("result");
                    res.setData("DONE");
                    return res;
                });

        return ServerResponse.ok().body(result, Bridge.class);
    }
}
