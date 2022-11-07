package com.o2a4.chattcp.Controller;


import com.o2a4.chattcp.data.Chats;
import com.o2a4.chattcp.data.ChatsRepository;
import com.o2a4.chattcp.service.ChatsService;
import lombok.AllArgsConstructor;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.mongodb.core.MongoTemplate;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/mongoTest")
@AllArgsConstructor
public class MongoTestController {

    @Autowired
    private ChatsService chatsService;

    @GetMapping
    public void MongoTest(){
        chatsService.mongoTest();


    }


}
