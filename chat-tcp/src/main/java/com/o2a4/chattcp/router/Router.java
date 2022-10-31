package com.o2a4.chattcp.router;

import com.o2a4.chattcp.handler.RestHandler;
import lombok.RequiredArgsConstructor;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.reactive.function.server.RequestPredicates;
import org.springframework.web.reactive.function.server.RouterFunction;
import org.springframework.web.reactive.function.server.RouterFunctions;
import org.springframework.web.reactive.function.server.ServerResponse;

@RequiredArgsConstructor
@Configuration
public class Router {

    private final RestHandler handler;

    @Bean
    public RouterFunction<?> restRouter() {
        return RouterFunctions.route()
                .GET("/chat/in", handler::roomIn)
                .POST("/chat/out", handler::roomOut)
                .build();
    }
}
