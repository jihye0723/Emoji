package com.o2a4.chattcp.kafka;


import lombok.Data;
import org.springframework.boot.context.properties.ConfigurationProperties;
import org.springframework.boot.context.properties.EnableConfigurationProperties;
import org.springframework.stereotype.Component;

import javax.swing.text.html.Option;
import java.util.HashMap;
import java.util.Map;
import java.util.Optional;

@Data
@Component
@EnableConfigurationProperties
@ConfigurationProperties("kafka")
public class KafkaProperties {

    //kafka 호스트
    private String hosts;

    //receiver 프로퍼티 맵
    private Map<String, KafkaReceiverProperty> receiver= new HashMap<>();

    public void setReceiver(Map<String, KafkaReceiverProperty> receivers){
        this.receiver = receivers;
    }

    public Optional<Map.Entry<String, KafkaReceiverProperty>> getProperty(String key){
        return this.receiver.entrySet()
                .stream().filter(entry -> entry.getValue().getName().equals(key))
                .findFirst();
    }

}
