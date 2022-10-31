package com.o2a4.chattcp.handler;

import lombok.extern.slf4j.Slf4j;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Component;
import org.springframework.web.reactive.function.server.*;
import reactor.core.publisher.Flux;
import reactor.core.publisher.Mono;

@Slf4j
@Component
public class RestHandler {

    public Mono<ServerResponse> roomIn(ServerRequest req) {
        Flux<String> temp = Flux.just("Room", "In!");
        log.info("ROOM IN : {}", temp);
        return ServerResponse.ok().body(temp, String.class);
    }

    public Mono<ServerResponse> roomOut(ServerRequest req) {
        Mono<String> body = req.bodyToMono(String.class).map(String::toUpperCase);
        Mono<String> temp = body.flatMap(Mono::just);
        log.info("ROOM OUT & UPPER : {}", temp);
        return ServerResponse.ok().body(body, String.class);
    }

//    public Mono<ServerResponse> stream(ServerRequest req) {
//        Stream<Integer> stream = Stream.iterate(0, i -> i + 1);
//        Flux<Map<String, Integer>> flux = Flux.fromStream(stream)
//                .map(i -> Collections.singletonMap("value", i));
//        return ok().contentType(MediaType.APPLICATION_NDJSON)
//                .body(fromPublisher(flux, new ParameterizedTypeReference<Map<String, Integer>>(){}));
//    }
}
