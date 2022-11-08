package com.o2a4.chattcp.service;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.apache.kafka.clients.producer.ProducerRecord;
import org.springframework.stereotype.Service;
import reactor.core.publisher.Mono;
import reactor.kafka.sender.KafkaSender;

@Slf4j
@Service
@RequiredArgsConstructor
public class KafkaService {

    private final KafkaSender<String, Object> producer;

    public Mono<String> send(String message){
        return producer.createOutbound()
                // 지정된 토픽으로 메시지 전송
                .send(Mono.just(new ProducerRecord<>("chats", null, message)))
                .then()
                // 에러 없이 전송이 완료 되었을 경우
                .thenReturn("message send success")
                // 에러가 발생했을 경우//
                .onErrorResume(e -> Mono.just(e.getMessage()));
    }
}
