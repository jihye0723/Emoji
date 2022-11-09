package com.o2a4.chattcp.controller;


import com.o2a4.chattcp.model.ChatsMessage;
import com.o2a4.chattcp.service.KafkaService;
import lombok.AllArgsConstructor;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/mongoTest")
@AllArgsConstructor
public class TestController {

    @Autowired
    private KafkaService kafkaService;
//
//    @GetMapping
//    public void MongoTest(){
//        chatsService.mongoTest();
//   }

   @GetMapping("/{message}")
    public void KafkaTest(@PathVariable String message){
//        ChatsMessage chatsMessage = ChatsMessage.builder().
//                userId("ssafy").content("뭐하는 친구야 너 ? ")
//                .send_at("20221109-15:50").build();
        kafkaService.send(message);
    }

    @GetMapping("/consume")
    public void KafkaConsumeTest(){

    }

}
