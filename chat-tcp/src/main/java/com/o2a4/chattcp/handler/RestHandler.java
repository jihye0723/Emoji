package com.o2a4.chattcp.handler;

import com.o2a4.chattcp.decoder.JwtDecoder;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
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

    private static String prefix = "chat:";

    private final ReactiveRedisTemplate<String, String> redisTemplate;

    private final JwtDecoder jwtDecoder;

    public Mono<ServerResponse> roomIn(ServerRequest req) {
        /* 방 입장 요청
         1. 유효한 사용자인지 확인 - jwt 토큰
         2. Redis - 열차 번호 확인해서 방 만들거나 방에 추가
           2-1 서버 UserCnt 증가
           2-a 방 만들면 : TrainCG 추가, UserCG 추가, CGUser 추가, 서버 Train 추가
           2-b 방 있으면 : UserCG 추가, CGUser 추가
         3. return TCP 포트번호 */

        // TODO 생성하는 모든 데이터에 대해서 expire 설정?
        // TODO 인증 서버에 보내고, token에서 id 디코딩
        // 1. 유효한 사용자 확인
        String token = req.headers().firstHeader("token");
        Mono<String> train = req.bodyToMono(String.class);

        // 인증서버 보낸 결과가 유효하지 않은 사용자라면
        if (false) {
            return ServerResponse.badRequest().body(Mono.just("권한이 없는 유저"), String.class);
        }

        String userId = jwtDecoder.decode(token);

        train.subscribe(
                trainId -> {
                    // 2 열차 확인
                    log.info("열차 채팅방 확인");
                    redisTemplate.opsForHash().get(prefix + "train:" + trainId, "channelGroup")
                            .map(v -> {
                                if (v != null) {
                                    // TODO 방이 있을 때 나머지 로직 구현
                                    redisTemplate.opsForHash().put(prefix + userId, "channelGroup", trainId);
                                }
                                return null;
                            })
                            // 방이 없는 경우
                            .switchIfEmpty(Mono.defer(() -> {
                                return null;
                            }));
                }
        );


        Flux<String> temp = Flux.just("Room", "In!");
        log.info("ROOM IN : {}", temp);
        return ServerResponse.ok().body(temp, String.class);
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
