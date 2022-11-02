package com.o2a4.chattcp.config;


import lombok.RequiredArgsConstructor;
import org.apache.kafka.clients.producer.ProducerConfig;
import org.apache.kafka.common.serialization.StringSerializer;
import org.springframework.boot.autoconfigure.kafka.KafkaProperties;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import reactor.core.scheduler.Schedulers;
import reactor.kafka.sender.KafkaSender;
import reactor.kafka.sender.SenderOptions;

import java.time.Duration;
import java.util.HashMap;
import java.util.Map;

@Configuration
@RequiredArgsConstructor
public class KafkaConfig {
    private final KafkaProperties properties;


    //기본 설정들로 구성
    @Bean("kafkaSender")
    public KafkaSender<String, Object> kafkaSender(){
        SenderOptions<String, Object> senderOptions = SenderOptions.create(getProducerProps());
        senderOptions.scheduler(Schedulers.parallel());
        senderOptions.closeTimeout(Duration.ofSeconds(5));
        return KafkaSender.create(senderOptions);
    }

    //producer 옵션
    private Map<String, Object> getProducerProps() {
        return new HashMap<String, Object>() {{
            put(ProducerConfig.BOOTSTRAP_SERVERS_CONFIG, properties.getBootstrapServers());
            put(ProducerConfig.KEY_SERIALIZER_CLASS_CONFIG, StringSerializer.class);
            put(ProducerConfig.VALUE_SERIALIZER_CLASS_CONFIG, StringSerializer.class);
            put(ProducerConfig.MAX_BLOCK_MS_CONFIG, 1000); // 전송 시간 제한을 1000ms로 설정
        }};
    }

//    Map<String, Object> producerProps = new HashMap<>();



}
