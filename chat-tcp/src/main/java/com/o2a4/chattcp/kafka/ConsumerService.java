package com.o2a4.chattcp.kafka;

import lombok.extern.slf4j.Slf4j;
import org.apache.kafka.clients.consumer.ConsumerConfig;
import org.apache.kafka.common.serialization.IntegerDeserializer;
import org.apache.kafka.common.serialization.StringDeserializer;
import reactor.core.Disposable;
import reactor.core.publisher.Flux;
import reactor.kafka.receiver.KafkaReceiver;
import reactor.kafka.receiver.ReceiverOffset;
import reactor.kafka.receiver.ReceiverOptions;
import reactor.kafka.receiver.ReceiverRecord;

import java.time.Instant;
import java.time.format.DateTimeFormatter;
import java.util.Collections;
import java.util.HashMap;
import java.util.Map;
import java.util.concurrent.CountDownLatch;
import java.util.concurrent.TimeUnit;
import java.util.function.Consumer;

@Slf4j
public class ConsumerService {
    private static final String BOOTSTRAP_SERVERS = "52.79.215.19:9092";
    private static final String TOPIC = "chats";

    private final ReceiverOptions<Integer, String> receiverOptions;
    private final DateTimeFormatter dateFormat;

    public ConsumerService(String bootstrapServers){

        Map<String, Object> props = new HashMap<>();
        props.put(ConsumerConfig.BOOTSTRAP_SERVERS_CONFIG, bootstrapServers);
        props.put(ConsumerConfig.GROUP_ID_CONFIG, "foo");
        props.put(ConsumerConfig.KEY_DESERIALIZER_CLASS_CONFIG, IntegerDeserializer.class);
        props.put(ConsumerConfig.VALUE_DESERIALIZER_CLASS_CONFIG, StringDeserializer.class);
        props.put(ConsumerConfig.AUTO_OFFSET_RESET_CONFIG, "earliest");
        receiverOptions = ReceiverOptions.create(props);
        dateFormat = DateTimeFormatter.ofPattern("HH:mm:ss:SSS z dd MMM yyyy");

    }

    public Disposable consumeMessages(String topic, CountDownLatch latch){

        ReceiverOptions<Integer, String> options = receiverOptions.subscription(Collections.singleton(topic))
                .addAssignListener(partitions -> log.debug("onPartitionsAssigned {}", partitions))
                .addRevokeListener(partitions -> log.debug("onPartitionsRevoked {}", partitions));
        Flux<ReceiverRecord<Integer,String>> kafkaFlux = KafkaReceiver.create(options).receive();
        return kafkaFlux.subscribe(record -> {
            ReceiverOffset offset = record.receiverOffset();
            Instant timestamp = Instant.ofEpochMilli(record.timestamp());
            System.out.printf("Received message: topic-partition=%s offset=%d timestamp=%s key=%d value=%s\n",
                    offset.topicPartition(),
                    offset.offset(),
                    dateFormat.format(timestamp),
                    record.key(),
                    record.value());
            offset.acknowledge();
            latch.countDown();
        });
    }

    public static void main(String[] args) throws Exception{
        int count=20;
        CountDownLatch latch = new CountDownLatch(count);
        ConsumerService consumer = new ConsumerService(BOOTSTRAP_SERVERS);
        Disposable disposable = consumer.consumeMessages(TOPIC, latch);
        latch.await(10, TimeUnit.SECONDS);
        disposable.dispose();
    }

}
