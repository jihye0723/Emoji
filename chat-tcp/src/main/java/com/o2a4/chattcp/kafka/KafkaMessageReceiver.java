package com.o2a4.chattcp.kafka;


import com.o2a4.chattcp.model.Chats;
import com.o2a4.chattcp.repository.ChatsRepository;
import lombok.extern.slf4j.Slf4j;
import lombok.val;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.json.simple.parser.ParseException;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.kafka.annotation.KafkaListener;
import org.springframework.stereotype.Component;
import reactor.kafka.receiver.KafkaReceiver;

import java.util.List;

@Slf4j
@Component
public class KafkaMessageReceiver {

    @Autowired
    private ChatsRepository chatsRepository;

    /* KafkaMessageReceiver 가 생성될 때 Kafka Receiver 시작 */
    public KafkaMessageReceiver(List<KafkaReceiver<Integer,String>> kafkaReceivers){
        for(KafkaReceiver<Integer,String> receiver : kafkaReceivers){
            this.start(receiver);
        }
    }

//    @KafkaListener(topics = "chats", groupId = "foo")
    public void start(KafkaReceiver<Integer,String> receiver){
        receiver.receive().subscribe(record ->{
//            log.info("Kafka Receiver result : Topic >> [{}], message >> [{}], Offset >> [{}]", record.topic(), record.value(), record.receiverOffset());
            JSONParser jsonParser = new JSONParser();
            try {
                // 객체에 담기 ( mongodb로 보낼 )
                JSONObject jsonObject = (JSONObject) jsonParser.parse(record.value());
                String userid = jsonObject.get("userid").toString();
                String content= jsonObject.get("content").toString();
                String send_at= jsonObject.get("send_at").toString();


                Chats chats=  Chats.builder().userid(userid).content(content).sendTime(send_at).build();
                chatsRepository.save(chats);


            } catch (ParseException e) {
                log.info(e.getMessage());
            }
        });
    }




}
