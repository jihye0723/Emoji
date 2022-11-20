package com.o2a4.chattcp.handler;

import com.auth0.jwt.JWT;
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
import reactor.util.function.Tuple2;

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

    @Value("${server.port}")
    private String port;

    @Value("${server.netty.transfer.port}")
    private String chatPort;

    private final ServerBootstrap serverBootstrap;

    private final ReactiveRedisTemplate<String, String> redisTemplate;
    private final RoomService roomService;

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

        // 1. 유효한 사용자 확인
        String token = req.headers().firstHeader("Authorization").split("Bearer")[1].trim();
        String userId = JWT.decode(token).getClaim("sub").asString();
//        String userId = "ssafy"; // 로컬 테스트용

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
                                // 빈 열차 만들기
                                Map<String, String> map = new HashMap<>();
                                map.put("server", port);
                                map.put("villain", "0");

                                return Mono.zip(redisTemplate.opsForHash().putAll(tPrefix + trainId, map),
                                        redisTemplate.expire(tPrefix + trainId, Duration.ofHours(3)));
                            }))
                            .flatMap(portRes -> {
                                Map<String, String> uMap = new HashMap<>();

                                // 만약에 지금 서버가 아닌 다른 서버에서 만들었던 열차라면
                                // 다른 서버의 포트로 유저를 저장해야 채팅방을 맞게 찾아감
                                if (portRes.getClass() == Tuple2.class) uMap.put("server", port);
                                else {
                                    String pRes = portRes.toString();
                                    if (pRes.equals(port)) uMap.put("server", port);
                                    else uMap.put("server", pRes);
                                }

                                log.info("ADD USER {} TO SERVER", userId);
                                // 유저 정보 만들어서 저장
                                uMap.put("channelGroup", trainId);
                                uMap.put("token", token);

                                return Mono.zip(redisTemplate.opsForHash().putAll(uPrefix + userId, uMap),
                                                redisTemplate.expire(uPrefix + userId, Duration.ofHours(3)))
                                        .flatMap(i -> Mono.just(uMap.get("server")));
                            });
                })
                .map(i -> {
                    log.info("BRIDGE");
                    Bridge res = new Bridge();

                    res.setName("port");
                    res.setData(i.substring(0, 3) + "2");

                    return res;
                });

        return ServerResponse.ok().contentType(MediaType.APPLICATION_JSON).body(train, Bridge.class);
    }

    /*
     * 자리양도 완료 처리 */
    public Mono<ServerResponse> finishSeat(ServerRequest request) {
        try {
            Mono<Seats> req = request.bodyToMono(Seats.class);

            return req.flatMap(data -> {
                roomService.seatEnd(data);

                return ServerResponse.accepted().build();
            });
        } catch (Exception e) {
            e.printStackTrace();

            return ServerResponse.status(500).build();
        }
    }
}
