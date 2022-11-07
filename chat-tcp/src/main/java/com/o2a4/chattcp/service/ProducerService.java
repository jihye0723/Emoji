package com.o2a4.chattcp.service;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import reactor.core.publisher.Mono;

@Slf4j
@Service
@RequiredArgsConstructor
/*
* produce 서비스
* kafka 에 produce 하기 전의 로직 처리 */
public class ProducerService {
   private final KafkaService kafkaService;
   
   public Mono<String> produceMessage(String message){
      log.info("Kafka Sender result : Topic >> [{}], message >> [{}]", "chat", message );
      return kafkaService.send(message);

   }
}
