package com.o2a4.chattcp.loader;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.data.redis.connection.ReactiveRedisConnectionFactory;
import org.springframework.data.redis.core.ReactiveRedisTemplate;
import org.springframework.stereotype.Component;
import reactor.core.publisher.Mono;

import javax.annotation.PostConstruct;

@Component
public class RedisLoader {

    private static String prefix = "chat:";
    @Value("${server.port}")
    private int port;

    //    private final ReactiveRedisConnectionFactory reactiveRedisConnectionFactory;
    private final ReactiveRedisTemplate<String, String> redisTemplate;

    public RedisLoader(ReactiveRedisConnectionFactory reactiveRedisConnectionFactory,
                       ReactiveRedisTemplate<String, String> reactiveRedisTemplate) {
//        this.reactiveRedisConnectionFactory = reactiveRedisConnectionFactory;
        this.redisTemplate = reactiveRedisTemplate;
    }

    @PostConstruct
    public void loadData() {
        // FIXME 시간 좀 걸릴수도? flush하는 좋은 방법을 모르겠음
        //  => 채팅서버용 redis를 따로 파면 flushAll로 다 날릴 수 있는데
        // FIXME 0이 어떻게 찍히는거지..
        String tempKey = prefix + "server:" + port;

        redisTemplate.delete("chat:*")
                .then(Mono.just(tempKey))
                .map(key -> redisTemplate.opsForValue().set(key, "0")
                        .then(redisTemplate.opsForValue().get(tempKey))
                        .subscribe(System.out::println)
                ).subscribe();
    }
}
