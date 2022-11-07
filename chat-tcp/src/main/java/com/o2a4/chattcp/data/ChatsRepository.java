package com.o2a4.chattcp.data;

import lombok.AllArgsConstructor;
import org.springframework.data.mongodb.repository.MongoRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface ChatsRepository extends MongoRepository<Chats, Integer> {
}
