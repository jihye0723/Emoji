package com.o2a4.chattcp.handler;

import com.o2a4.chattcp.decoder.JwtDecoder;
import com.o2a4.chattcp.repository.TrainChannelGroupRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.data.redis.core.ReactiveRedisTemplate;
import org.springframework.stereotype.Component;
import org.springframework.web.reactive.function.server.ServerRequest;
import org.springframework.web.reactive.function.server.ServerResponse;
import reactor.core.publisher.Flux;
import reactor.core.publisher.Mono;

@Slf4j
@RequiredArgsConstructor
@Component
public class RestHandler {

    @Value("${server.port}")
    private String port;

    private final ReactiveRedisTemplate<String, String> redisTemplate;

    private final JwtDecoder jwtDecoder;

    private final TrainChannelGroupRepository tcgRepo;

    public Mono<ServerResponse> roomIn(ServerRequest req) {
        /* 방 입장 요청
         1. 유효한 사용자인지 확인 - jwt 토큰
         2. Redis - 열차 번호 확인해서 방 만들거나 방에 추가
           2-a 방 만들면 : UserCG 추가, User서버 추가, Train-서버 추가 + 나중에 채널 생성 시 유저-채널ID 추가
           2-b 방 있으면 : UserCG 추가, CGUser 추가 + 나중에 채널 생성 시 유저-채널ID 추가
           2-1 서버 UserCnt 증가
         3. return TCP 포트번호 */

        // TODO 생성하는 모든 데이터에 대해서 expire 설정?
        // TODO 인증 서버에 보내고, token에서 id 디코딩
        // FIXME Body를 JSON으로 받아야하는데
        // 1. 유효한 사용자 확인
//        String token = req.headers().firstHeader("token");
//        Mono<String> train = req.bodyToMono(String.class);
        String token = "token";
        Mono<String> train = Mono.just("S2101-1");


        // 인증서버 보낸 결과가 유효하지 않은 사용자라면
        if (false) {
            return ServerResponse.badRequest().body(Mono.just("권한이 없는 유저"), String.class);
        }

        String userId = jwtDecoder.decode(token);
        // FIXME 사람살려
        train.doOnSubscribe(trainId -> {
                    // 2 열차 확인
                    log.info("CHECK TRAIN");
                    redisTemplate.opsForHash().get("train:" + trainId, "server").flatMap(portRes -> {
                        log.info("ADD USER {} TO SERVER", userId);
                        redisTemplate.opsForHash().put("user:"+ userId, "channelGroup", trainId).subscribe();
                        redisTemplate.opsForHash().put("user:"+ userId, "server", port).subscribe();

                        if (portRes == null) {
                            log.info("TRAIN {} DOES NOT EXIST", trainId);
                            // 방이 없을 때 추가로 서버에 방을 할당
                            redisTemplate.opsForHash().put("train:"+ trainId, "server", port).subscribe();
                        }

                        return Mono.just("ADD USER DONE");
                    }).subscribe();
                }).map(i -> {
            redisTemplate.opsForValue().increment("server:" + port).subscribe();
            return port;
        });
            /*.flatMap(trainId -> {
                // 2 열차 확인
                log.info("CHECK TRAIN");
                return redisTemplate.opsForHash().get("train:" + trainId, "server").flatMap(portRes -> {
                    log.info("ADD USER {} TO SERVER", userId);
                    redisTemplate.opsForHash().put("user:"+ userId, "channelGroup", trainId).subscribe();
                    redisTemplate.opsForHash().put("user:"+ userId, "server", port).subscribe();

                    if (portRes == null) {
                        log.info("TRAIN {} DOES NOT EXIST", trainId);
                        // 방이 없을 때 추가로 서버에 방을 할당
                        redisTemplate.opsForHash().put("train:"+ trainId, "server", port).subscribe();
                    }

                    return Mono.just("ADD USER DONE");
                });
            })
            .map(i -> {
                redisTemplate.opsForValue().increment("server:" + port).subscribe();
                return port;
            });*/



        /*trainId -> {
            // 2 열차 확인
            log.info("CHECK TRAIN");
            redisTemplate.opsForHash().get("train:" + trainId, "server")
                    .map(v -> {
                        log.info("TRAIN EXISTS");
                        // 방이 있을 때
                        redisTemplate.opsForHash().put("user:"+ userId, "channelGroup", trainId).subscribe();
                        redisTemplate.opsForHash().put("user:"+ userId, "server", port).subscribe();

                        return v;
                    }).switchIfEmpty(Mono.defer(() -> {
                        log.info("TRAIN {} DOES NOT EXIST", trainId);
                        // 방이 없을 때 추가로 서버에 방을 할당
                        redisTemplate.opsForHash().put("user:"+ userId, "channelGroup", trainId).subscribe();
                        redisTemplate.opsForHash().put("user:"+ userId, "server", port).subscribe();
                        redisTemplate.opsForHash().put("train:"+ trainId, "server", port).subscribe();

                        return Mono.just("ok");
                    })).map(i -> {
                        redisTemplate.opsForValue().increment("server:" + port).subscribe();
                        return port;
                    });
        }*/

        return ServerResponse.ok().body(train, String.class);
    }

    public Mono<ServerResponse> roomOut(ServerRequest req) {
        /* 방 퇴장 요청
         ? 1. 유효한 사용자인지 확인 - jwt 토큰
         2. Redis - 유저 ID 확인해서 방에서 퇴장
           2-1 서버 UserCnt 감소
           2-2 UserCG 제거, CGUser 제거
           2-b CG에 남은 사람이 없다면 : TrainCG 제거, 서버 Train 제거
         3. return 성공, 실패 */

        return ServerResponse.ok().body("OUT!!", String.class);
    }

//    public Mono<ServerResponse> stream(ServerRequest req) {
//        Stream<Integer> stream = Stream.iterate(0, i -> i + 1);
//        Flux<Map<String, Integer>> flux = Flux.fromStream(stream)
//                .map(i -> Collections.singletonMap("value", i));
//        return ok().contentType(MediaType.APPLICATION_NDJSON)
//                .body(fromPublisher(flux, new ParameterizedTypeReference<Map<String, Integer>>(){}));
//    }
}
