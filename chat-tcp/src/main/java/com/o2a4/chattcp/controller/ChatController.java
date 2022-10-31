package com.o2a4.chattcp.controller;

import lombok.extern.slf4j.Slf4j;
import org.springframework.web.bind.annotation.*;
import reactor.core.publisher.Flux;
import reactor.core.publisher.Mono;

//@Slf4j
//@RestController
//public class ChatController {
//    @GetMapping("/chat/in")
//    public Flux<String> roomIn() {
//        return Flux.just("Hello", "World!");
//    }
//    @PostMapping("/chat/out")
//    public Mono<String> roomOut(@RequestBody Mono<String> body) {
//        return body.map(String::toUpperCase);
//    }
//}
