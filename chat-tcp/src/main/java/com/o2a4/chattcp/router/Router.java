package com.o2a4.chattcp.router;

import com.o2a4.chattcp.handler.RestHandler;
import lombok.RequiredArgsConstructor;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.reactive.function.server.RouterFunction;
import org.springframework.web.reactive.function.server.RouterFunctions;
import org.springframework.web.reactive.function.server.ServerResponse;

@RequiredArgsConstructor
@Configuration
public class Router {

    private final RestHandler handler;

    @Bean
    public RouterFunction<ServerResponse> restRouter() {
        return RouterFunctions.route()
                .path("/chat", builder -> builder
                        .POST("/in", handler::roomIn))
//                        .DELETE("/out", handler::roomOut))
                .path("/seat", builder -> builder
                        .POST("/finish", handler::finishSeat))
                .build();
    }
}
