package com.o2a4.chattcp.Repository;

import com.o2a4.chattcp.Entity.Chats;
import org.springframework.data.mongodb.repository.MongoRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface ChatsRepository extends MongoRepository<Chats, Integer> {

}
