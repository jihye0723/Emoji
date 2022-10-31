package com.o2a4.chattcp.router;

import com.o2a4.chattcp.handler.RestHandler;
import lombok.RequiredArgsConstructor;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.reactive.function.server.RouterFunction;
import org.springframework.web.reactive.function.server.RouterFunctions;

@RequiredArgsConstructor
@Configuration
public class Router {

    private final RestHandler handler;

    @Bean
    public RouterFunction<?> restRouter() {
        return RouterFunctions.route()
                .path("/chat", builder -> builder
                        .GET("/in", handler::roomIn)
                        .POST("/out", handler::roomOut))
                .build();
    }
}
