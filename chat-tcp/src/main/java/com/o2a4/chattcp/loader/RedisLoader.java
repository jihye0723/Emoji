package com.o2a4.chattcp.loader;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.data.redis.connection.ReactiveRedisConnectionFactory;
import org.springframework.data.redis.core.ReactiveRedisTemplate;
import org.springframework.stereotype.Component;
import reactor.core.publisher.Mono;

import javax.annotation.PostConstruct;

@Component
public class RedisLoader {
    @Value("${server.netty.transfer.port}")
    private int port;

        private final ReactiveRedisConnectionFactory reactiveRedisConnectionFactory;
    private final ReactiveRedisTemplate<String, String> redisTemplate;

    public RedisLoader(ReactiveRedisConnectionFactory reactiveRedisConnectionFactory,
                       ReactiveRedisTemplate<String, String> reactiveRedisTemplate) {
        this.reactiveRedisConnectionFactory = reactiveRedisConnectionFactory;
        this.redisTemplate = reactiveRedisTemplate;
    }

    @PostConstruct
    public void loadData() {
        // redis DB를 0번으로 사용하기 때문에 0번을 flush
        String tempKey = "server:" + port;

        reactiveRedisConnectionFactory.getReactiveConnection().serverCommands().flushDb().then(Mono.just(tempKey))
                .subscribe(key -> redisTemplate.opsForValue().set(key, "0")
                        .then(redisTemplate.opsForValue().get(tempKey))
                        .subscribe());
    }
}
