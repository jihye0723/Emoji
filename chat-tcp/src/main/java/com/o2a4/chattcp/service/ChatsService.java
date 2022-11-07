package com.o2a4.chattcp.service;

import com.o2a4.chattcp.data.Chats;
import com.o2a4.chattcp.data.ChatsRepository;
import lombok.AllArgsConstructor;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.mongodb.core.MongoTemplate;
import org.springframework.data.mongodb.repository.config.EnableMongoRepositories;
import org.springframework.stereotype.Component;
import org.springframework.stereotype.Service;

@Service
@AllArgsConstructor
@EnableMongoRepositories(basePackages = "com.o2a4.chattcp.data")

public class ChatsService {

    @Autowired
    private ChatsRepository chatsRepository;

    public void mongoTest(){
        Chats chats= Chats.builder().userid("ssafy1").content("안녕하세요").build();

        chatsRepository.save(chats);
    }

//    @Autowired
//    private MongoTemplate mongoTemplate;
//
//    public void mongoTest() {
//        Chats chats= Chats.builder().userid("ssafy").content("안녕하세요 ! ").build();
//
//        mongoTemplate.save(chats);
//    }

}
