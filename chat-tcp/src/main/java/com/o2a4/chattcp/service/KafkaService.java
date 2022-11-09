package com.o2a4.chattcp.service;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.apache.kafka.clients.producer.ProducerRecord;
import org.reactivestreams.Publisher;
import org.springframework.stereotype.Service;
import reactor.core.publisher.Flux;
import reactor.core.publisher.Mono;
import reactor.kafka.sender.KafkaSender;
import reactor.kafka.sender.SenderRecord;
import reactor.kafka.sender.SenderResult;

@Slf4j
@Service
@RequiredArgsConstructor
public class KafkaService {

    private final KafkaSender<String, Object> kafkaSender;

//    public void send(String message){
//        Flux<SenderRecord<String, Object, Integer>> outboundFlux =
//                Flux.range(1,1)
//                        .map(i -> SenderRecord.create(new ProducerRecord<>("chats", null , "kafkaTesting"),i) );
//
//        kafkaSender.send(outboundFlux).subscribe();
//    }

    public void send(String message){
        Flux<SenderRecord<String, Object, Integer>> outboundFlux =
                Flux.range(1,1)
                        .map(i -> SenderRecord.create(new ProducerRecord<>("chats", null , message),i) );

        kafkaSender.send(outboundFlux).subscribe();
    }

}
