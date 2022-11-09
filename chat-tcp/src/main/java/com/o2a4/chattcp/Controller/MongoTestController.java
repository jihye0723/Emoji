package com.o2a4.chattcp.Controller;


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
public class MongoTestController {

//    @Autowired
//    private ChatsService chatsService;
//
    @Autowired
    private KafkaService kafkaService;
//
//    @GetMapping
//    public void MongoTest(){
//        chatsService.mongoTest();
//   }


   @GetMapping("/{message}")
    public void KafkaTest(@PathVariable String message){
       kafkaService.send(message);

//       System.out.println(result);
   }

   @GetMapping("/consume")
    public void KafkaConsumeTest(){

   }

}
