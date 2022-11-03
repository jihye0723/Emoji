package com.o2a4.chattcp.kafka;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.apache.kafka.clients.producer.ProducerConfig;
import org.apache.kafka.clients.producer.ProducerRecord;
import org.apache.kafka.clients.producer.RecordMetadata;
import org.apache.kafka.common.serialization.IntegerSerializer;
import org.apache.kafka.common.serialization.StringSerializer;
import org.slf4j.LoggerFactory;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.stereotype.Service;
import reactor.core.publisher.Flux;
import reactor.kafka.sender.KafkaSender;
import reactor.kafka.sender.SenderOptions;
import reactor.kafka.sender.SenderRecord;

import java.time.Instant;
import java.time.format.DateTimeFormatter;
import java.util.HashMap;
import java.util.Map;
import java.util.concurrent.CountDownLatch;
import java.util.concurrent.TimeUnit;

@Slf4j
public class ProducerService {
    private static final String BOOTSTRAP_SERVERS = "52.79.215.19:9092"; // kafka server
    private static final String TOPIC = "chats"; // topic

    //KafkaSender: 메시지 보내는 Reactor Kafka API
    private final KafkaSender<Integer, String> sender; //Kafka 로 보낼 키-값
    private final DateTimeFormatter dateFormat;

    public ProducerService(String bootstrapServers){
        //Sender 설정 옵션
        Map<String, Object> props = new HashMap<>();
        props.put(ProducerConfig.BOOTSTRAP_SERVERS_CONFIG, bootstrapServers);
        props.put(ProducerConfig.ACKS_CONFIG, "all");
        props.put(ProducerConfig.KEY_SERIALIZER_CLASS_CONFIG, IntegerSerializer.class);
        props.put(ProducerConfig.VALUE_SERIALIZER_CLASS_CONFIG, StringSerializer.class);

        SenderOptions<Integer,String> senderOptions = SenderOptions.create(props);

        sender  = KafkaSender.create(senderOptions);
        dateFormat = DateTimeFormatter.ofPattern("HH:mm:ss:SSS z dd MMM yyyy");

    }

    //ProducerRecord: Kafka로 보낼 키-값 쌍 + 메시지 topic 명
    public void sendMessages(String topic, int count, CountDownLatch latch) throws InterruptedException {
        sender.<Integer>send(Flux.range(1, count)
                .map(i -> SenderRecord.create(new ProducerRecord<>(topic, i , "Message _"+i), i))) //1개의 데이터를 1 -> 1로 변환
                .doOnError(e -> log.error("Send failed", e))
                .subscribe(r -> {
                    RecordMetadata metadata = r.recordMetadata();
                    Instant timestamp = Instant.ofEpochMilli(metadata.timestamp());
                    System.out.printf("Message %d sent successfully, topic-partition=%s-%d offset=%d timestamp=%s\n",
                            r.correlationMetadata(),
                            metadata.topic(),
                            metadata.partition(),
                            metadata.offset(),
                            dateFormat.format(timestamp));
                    latch.countDown();
                });
    }
    public void close() {
        sender.close();
    }
    public static void main(String[] args) throws Exception {
        int count = 20;
        CountDownLatch latch = new CountDownLatch(count);
        ProducerService producer = new ProducerService(BOOTSTRAP_SERVERS);
        producer.sendMessages(TOPIC, count, latch);
        latch.await(10, TimeUnit.SECONDS);
        producer.close();
    }
}
