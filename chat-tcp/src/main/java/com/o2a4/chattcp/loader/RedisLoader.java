package com.o2a4.chattcp.loader;

import lombok.RequiredArgsConstructor;
import org.springframework.data.redis.connection.ReactiveRedisConnectionFactory;
import org.springframework.stereotype.Component;

import javax.annotation.PostConstruct;

@RequiredArgsConstructor
@Component
public class RedisLoader {

    private final ReactiveRedisConnectionFactory factory;

    @PostConstruct
    public void loadData() {
        // TODO chat: 으로 시작하는 키 모두 삭제하고, 서버 - 인원수 0으로 초기화
        // Just fill our Redis with some predefined data
//        factory.getReactiveConnection().serverCommands().flushAll().thenMany(
//                        Flux.just("Jet Black Redis", "Darth Redis", "Black Alert Redis")
//                                .map(name -> new Coffee(UUID.randomUUID().toString(), name))
//                                .flatMap(coffee -> coffeeOps.opsForValue().set(coffee.getId(), coffee)))
//                .thenMany(coffeeOps.keys("*")
//                        .flatMap(coffeeOps.opsForValue()::get))
//                .subscribe(System.out::println);
    }
}
