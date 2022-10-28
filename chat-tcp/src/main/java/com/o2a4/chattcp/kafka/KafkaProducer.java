package com.o2a4.chattcp.kafka;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.kafka.core.KafkaTemplate;

@Service
public class KafkaProducer {
    private static final String TOPIC = "chat";
    private final KafkaTemplate<String, String> kafkaTemplate;

    @Autowired
    public KafkaProducer(KafkaTemplate kafkaTemplate){
        this.kafkaTemplate = kafkaTemplate;
    }
    public void sendMessage(String message){
        System.out.println(String.format("Produce message : %s", message));
        this.kafkaTemplate.send(TOPIC, message);
    }
}
