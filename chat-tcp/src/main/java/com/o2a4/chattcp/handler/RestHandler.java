package com.o2a4.chattcp.handler;

import com.o2a4.chattcp.decoder.JwtDecoder;
import com.o2a4.chattcp.model.Bridge;
import com.o2a4.chattcp.model.Seats;
import com.o2a4.chattcp.repository.ChannelIdChannelRepository;
import com.o2a4.chattcp.repository.TrainChannelGroupRepository;
import com.o2a4.chattcp.service.AuthService;
import com.o2a4.chattcp.service.RoomService;
import io.netty.bootstrap.ServerBootstrap;
import io.netty.channel.group.DefaultChannelGroup;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.data.redis.core.ReactiveRedisTemplate;
import org.springframework.http.MediaType;
import org.springframework.stereotype.Component;
import org.springframework.web.reactive.function.server.ServerRequest;
import org.springframework.web.reactive.function.server.ServerResponse;
import reactor.core.publisher.Mono;

import java.time.Duration;
import java.util.HashMap;
import java.util.Map;

@Slf4j
@RequiredArgsConstructor
@Component
public class RestHandler {
    static String uPrefix = "user:";
    static String tPrefix = "train:";
    static String sPrefix = "server:";

    @Value("${server.netty.transfer.port}")
    private String port;

    private final ServerBootstrap serverBootstrap;

    private final ReactiveRedisTemplate<String, String> redisTemplate;
    private final RoomService roomService;

    private final JwtDecoder jwtDecoder;

    private final TrainChannelGroupRepository tcgRepo;
    private final ChannelIdChannelRepository cidcRepo;
    private final AuthService authService;

    public Mono<ServerResponse> roomIn(ServerRequest req) {
        /* 방 입장 요청
         1. 유효한 사용자인지 확인 - jwt 토큰
         2. Redis - 열차 번호 확인해서 방 만들거나 방에 추가
           2-a 방 만들면 : UserCG 추가, User서버 추가, Train-서버 추가 + 나중에 채널 생성 시 유저-채널ID 추가
           2-b 방 있으면 : UserCG 추가, User서버 추가 + 나중에 채널 생성 시 유저-채널ID 추가
           2-1 서버 UserCnt 증가
         3. return TCP 포트번호 */

        // TODO token에서 id 디코딩
        // 1. 유효한 사용자 확인
        String token = req.headers().firstHeader("token");
        String userId = jwtDecoder.decode(token);

        // TODO Error Gracefully,,,,
        Mono<Bridge> train = redisTemplate.opsForHash().get(uPrefix + userId, "server")
                // 없었다면 body를 사용
                .switchIfEmpty(req.bodyToMono(Bridge.class))
                // body가 없으면
                .switchIfEmpty(Mono.error(new IllegalStateException("No User Info in Request")))
                // 서버에서 찾을 수 없어서 request body로 변환된 경우에만 통과
                .flatMap(i -> {
                    if (i instanceof Bridge) return Mono.just(i);
                    else return Mono.empty();
                })
                .switchIfEmpty(Mono.error(new IllegalArgumentException("중복된 유저입니다")))
                // 정상적으로 body에서 데이터를 불러왔다면
                .flatMap(data -> {
                    // 2 열차 확인
                    log.info("CHECK TRAIN");
                    String trainId = ((Bridge) data).getData();

                    return redisTemplate.opsForHash().get(tPrefix + trainId, "server")
                            .switchIfEmpty(Mono.defer(() -> {
                                log.info("TRAIN {} DOES NOT EXIST", trainId);
                                // 채널그룹 맵에 추가
                                tcgRepo.getTrainChannelGroupMap().put(trainId, new DefaultChannelGroup(serverBootstrap.config().childGroup().next()));

                                Map<String, String> map = new HashMap<>();
                                map.put("server", port);
                                map.put("villain", "0");

                                return Mono.zip(redisTemplate.opsForHash().putAll(tPrefix + trainId, map),
                                        redisTemplate.expire(tPrefix + trainId, Duration.ofHours(3)));
                            }))
                            .flatMap(portRes -> {
                                log.info("ADD USER {} TO SERVER", userId);

                                Map<String, String> uMap = new HashMap<>();
                                uMap.put("channelGroup", trainId);
                                uMap.put("server", port);

                                return Mono.zip(redisTemplate.opsForHash().putAll(uPrefix + userId, uMap),
                                        redisTemplate.expire(uPrefix + userId, Duration.ofHours(3)));
                            });
                })
//                .flatMap(i -> {
//                    log.info("INCREASE USER COUNT");
//                    return redisTemplate.opsForValue().increment(sPrefix + port);
//                })
                .map(i -> {
                    log.info("BRIDGE");
                    Bridge res = new Bridge();

                    res.setName("port");
                    res.setData(port);

                    return res;
                });

        return ServerResponse.ok().contentType(MediaType.APPLICATION_JSON).body(train, Bridge.class);
    }

    /*
    * 자리양도 완료 처리 */
    public Mono<ServerResponse> finishSeat(ServerRequest request) {
        try {
            request.bodyToMono(Seats.class).subscribe(data -> roomService.seatEnd(data));

            return ServerResponse.accepted().build();
        } catch (Exception e) {
            e.printStackTrace();

            return ServerResponse.status(500).build();
        }
    }

//    public Mono<ServerResponse> roomOut(ServerRequest req) {
//        /* 방 퇴장 요청
//         ? 1. 유효한 사용자인지 확인 - jwt 토큰
//         2. Redis - 유저 ID 확인해서 방에서 퇴장
//           2-1 서버 UserCnt 감소
//           2-2 User (Hash) 제거
//           2-a CG에 남은 사람이 없다면 : Train 서버 제거, Train CG 제거
//         3. return 성공, 실패 */
//
//
//        // 1. 유효한 사용자 확인
//        String token = req.headers().firstHeader("token");
//        String userId = jwtDecoder.decode(token);
//
//        // 인증서버 보낸 결과가 유효하지 않은 사용자라면
//        if (false) {
//            return ServerResponse.badRequest().body(Mono.just("권한이 없는 유저"), String.class);
//        }
//
//        log.info("GET USER CHANNELGROUP");
//        Mono<Bridge> result = redisTemplate.opsForHash().entries(uPrefix + userId)
//                .collectMap(x -> x.getKey(), x -> x.getValue())
//                .flatMap(map -> {
//                    log.info("REMOVE USER {}", userId);
//                    log.info("MAP VALUES : {}", map.values());
//
//                    String channelId = (String) map.get("channel");
//                    String channelGroup = (String) map.get("channelGroup");
//
//                    // channelId가 null인 경우는 아직 TCP 소켓이 연결 안된 상태
//                    if (channelId != null) {
//                        // 서버에서 클라이언트의 채널 닫음
//                        cidcRepo.getChannelIdChannelMap().get(channelId).close();
//                    }
//
//                    // TODO 확인필요
//                    // 채팅방에 사람이 남았는지 확인하고 없다면 redis에서 제거 - channel이 close됐을 때 group이 비면 자동으로 사라지는듯
////                    ChannelGroup cg = tcgRepo.getTrainChannelGroupMap().get(channelGroup);
////                    if (cg != null && cg.size() == 0) {
////                        log.info("REMOVE TRAIN {} SERVER", channelGroup);
////                        // 메모리에서 채널그룹 제거
////                        tcgRepo.getTrainChannelGroupMap().remove(channelGroup);
////                    }
//
//                    return Mono.zip(
//                            // Redis에서 유저 정보 제거
//                            redisTemplate.opsForHash().delete(uPrefix + userId).doOnSubscribe(i -> {
//                                log.info("REMOVE USER {} REDIS", userId);
//                            }),
//                            // Redis에서 열차 서버 매핑정보 제거
//                            redisTemplate.opsForHash().delete(tPrefix + channelGroup).doOnSubscribe(i -> {
//                                log.info("REMOVE TRAIN {} REDIS", channelGroup);
//                            }));
//                }).flatMap(i -> {
//                    if (i.getT1() && i.getT2()) {
//                        redisTemplate.opsForValue().decrement(sPrefix + port).subscribe(a -> {
//                            log.info("DECREASE USER COUNT");
//                        });
//                    }
//                    return Mono.just("pass");
//                }).map(i -> {
//                    log.info("MAKE BRIDGE");
//                    Bridge res = new Bridge();
//                    res.setName("result");
//                    res.setData("DONE");
//                    return res;
//                });
//
//        return ServerResponse.ok().body(result, Bridge.class);
//    }
}
