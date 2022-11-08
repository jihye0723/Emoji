package com.o2a4.chattcp.kafka;


import lombok.extern.slf4j.Slf4j;
import lombok.val;
import org.springframework.kafka.annotation.KafkaListener;
import org.springframework.stereotype.Component;
import reactor.kafka.receiver.KafkaReceiver;

import java.util.List;

@Slf4j
@Component
public class KafkaMessageReceiver {

    /* KafkaMessageReceiver 가 생성될 때 Kafka Receiver 시작 */
    public KafkaMessageReceiver(List<KafkaReceiver<Integer,String>> kafkaReceivers){
        for(KafkaReceiver<Integer,String> receiver : kafkaReceivers){
            this.start(receiver);
        }
    }

//    @KafkaListener(topics = "chats", groupId = "foo")
    public void start(KafkaReceiver<Integer,String> receiver){
        receiver.receive().subscribe(record ->{
            log.info("Kafka Receiver result : Topic >> [{}], message >> [{}], Offset >> [{}]", record.topic(), record.value(), record.receiverOffset());
        });
    }


}
