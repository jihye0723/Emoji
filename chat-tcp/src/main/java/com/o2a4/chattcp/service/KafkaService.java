package com.o2a4.chattcp.service;

import lombok.AllArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.apache.kafka.clients.producer.ProducerRecord;
import org.json.simple.JSONObject;
import org.springframework.stereotype.Service;
import reactor.core.publisher.Flux;
import reactor.kafka.sender.KafkaSender;
import reactor.kafka.sender.SenderRecord;


@Slf4j
@Service
@AllArgsConstructor
public class KafkaService {

    private final KafkaSender<String, Object> kafkaSender;

//    public void send(String msg){
////        JSONObject message = new JSONObject();
////        message.put("userid", "ssafy");
////        message.put("content", "시끄러워용");
////        message.put("send_at" , "20221110-11:10:12");
//        Flux<SenderRecord<String, Object, Integer>> outboundFlux =
//                Flux.range(1,1)
//                        .map(i -> SenderRecord.create(new ProducerRecord<>("chats", null , msg),i) );
//
//        kafkaSender.send(outboundFlux).subscribe();
//
//
//    }

    public void send(String msg){
        Flux<SenderRecord<String, Object, Integer>> outboundFlux =
                Flux.range(1,1)
                        .map(i -> SenderRecord.create(new ProducerRecord<>("chats", null , msg),i) );

        kafkaSender.send(outboundFlux).subscribe();


    }
//    private final KafkaTemplate<String, ChatsMessage> kafkaTemplate;
//
//    @Autowired
//    public KafkaService(KafkaTemplate<String, ChatsMessage> kafkaTemplate) {
//        this.kafkaTemplate = kafkaTemplate;
//    }
//    public void send(ChatsMessage chatsMessage){
//        kafkaTemplate.send("chats", chatsMessage);
//    }

}
