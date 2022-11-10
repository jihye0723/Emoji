package com.o2a4.chattcp.config;
import lombok.RequiredArgsConstructor;
import org.apache.kafka.clients.consumer.ConsumerConfig;
import org.apache.kafka.clients.producer.ProducerConfig;
import org.apache.kafka.common.serialization.IntegerDeserializer;
import org.apache.kafka.common.serialization.StringDeserializer;
import org.apache.kafka.common.serialization.StringSerializer;
import org.springframework.boot.autoconfigure.kafka.KafkaProperties;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.kafka.annotation.EnableKafka;

import reactor.core.scheduler.Schedulers;
import reactor.kafka.receiver.KafkaReceiver;
import reactor.kafka.receiver.ReceiverOptions;
import reactor.kafka.sender.KafkaSender;
import reactor.kafka.sender.SenderOptions;

import java.time.Duration;
import java.util.Collections;
import java.util.HashMap;
import java.util.Map;

@EnableKafka
@Configuration
@RequiredArgsConstructor
public class KafkaConfiguration {
    private final KafkaProperties properties;

    @Bean("kafkaSender")
    public KafkaSender<String, Object> kafkaSender() {
        SenderOptions<String, Object> senderOptions = SenderOptions.create(getProducerProps());
        senderOptions.scheduler(Schedulers.parallel());
        senderOptions.closeTimeout(Duration.ofSeconds(5));
        return KafkaSender.create(senderOptions);
    }

    // producer 옵션
    private Map<String, Object> getProducerProps() {
        return new HashMap<String, Object>(){{
            put(ProducerConfig.BOOTSTRAP_SERVERS_CONFIG, "52.79.215.19:8892");
            put(ProducerConfig.KEY_SERIALIZER_CLASS_CONFIG, StringSerializer.class);
            put(ProducerConfig.VALUE_SERIALIZER_CLASS_CONFIG, StringSerializer.class);
//            put(ProducerConfig.VALUE_SERIALIZER_CLASS_CONFIG, JsonSerializer.class);
            put(ProducerConfig.MAX_BLOCK_MS_CONFIG, 1000); // 전송 시간 제한 : 1000ms
        }};
    }


    @Bean("kafkaReceiver")
    public KafkaReceiver<Integer, String> kafkaReceiver() throws Exception{
        ReceiverOptions<Integer, String> receiverOptions =
                ReceiverOptions.<Integer,String>create(getConsumerProps())
                        .subscription(Collections.singleton("chats"));
        return KafkaReceiver.create(receiverOptions);
    }

    // consumer 옵션
    private Map<String, Object> getConsumerProps(){
        return new HashMap<String, Object>(){{
            put(ConsumerConfig.BOOTSTRAP_SERVERS_CONFIG, "52.79.215.19:8892");
            put(ConsumerConfig.GROUP_ID_CONFIG, "foo");
            put(ConsumerConfig.KEY_DESERIALIZER_CLASS_CONFIG, IntegerDeserializer.class);
            put(ConsumerConfig.VALUE_DESERIALIZER_CLASS_CONFIG, StringDeserializer.class);
            put(ProducerConfig.MAX_BLOCK_MS_CONFIG, 1000);
        }};
    }


//    @Bean
//    public ProducerFactory<String, ChatsMessage> producerFactory(){
//        Map<String, Object> config= new HashMap<>();
//        config.put(ProducerConfig.BOOTSTRAP_SERVERS_CONFIG,  "52.79.215.19:8892");
//        config.put(ProducerConfig.KEY_SERIALIZER_CLASS_CONFIG, StringSerializer.class);
//        config.put(ProducerConfig.VALUE_SERIALIZER_CLASS_CONFIG, JsonSerializer.class);
//        return new DefaultKafkaProducerFactory<>(config);
//    }
//
//    @Bean
//    public KafkaTemplate<String, ChatsMessage> kafkaTemplate(){
//        return new KafkaTemplate<>(producerFactory());
//    }
//
//    @Bean
//    public ConsumerFactory<String, ChatsMessage> consumerFactory(){
//        Map<String, Object> config= new HashMap<>();
//        config.put(ConsumerConfig.BOOTSTRAP_SERVERS_CONFIG, "52.79.215.19:8892");
//        config.put(ConsumerConfig.GROUP_ID_CONFIG, "foo");
//
//        return new DefaultKafkaConsumerFactory<>(config, new StringDeserializer(), new JsonDeserializer<>(com.o2a4.chattcp.model.ChatsMessage.class));
//
//    }
//
//    @Bean
//    public ConcurrentKafkaListenerContainerFactory<String, ChatsMessage> kafkaListener(){
//        ConcurrentKafkaListenerContainerFactory<String, ChatsMessage> factory
//                = new ConcurrentKafkaListenerContainerFactory<>();
//        factory.setConsumerFactory(consumerFactory());
//        return factory;
//
//    }
}
