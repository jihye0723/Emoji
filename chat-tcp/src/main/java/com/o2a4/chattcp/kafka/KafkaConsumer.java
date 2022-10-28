package com.o2a4.chattcp.kafka;

import org.springframework.kafka.annotation.KafkaListener;
import org.springframework.stereotype.Service;

import java.io.IOException;

@Service
public class KafkaConsumer {

    @KafkaListener(topics = "chat", groupId = "foo")
    public void consume(String message) throws IOException {
        // mongoDB 에 저장하는 코드
    }
}
