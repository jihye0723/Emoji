package com.o2a4.chattcp.model;

import lombok.Builder;
import lombok.Data;
import org.springframework.data.annotation.Id;
import org.springframework.data.annotation.Transient;
import org.springframework.data.annotation.TypeAlias;
import org.springframework.data.mongodb.core.mapping.Document;


/*
* kafka 에서 consume > mongodb 로 저장 */
@Data
@Document(collection = "chats")
@TypeAlias("chats")
public class Chats {
    @Id
    private String _id;

    // 메시지 전송 유저 아이디
    private String userid;
    // 메시지 전송 내용
    private String content;
    // 메시지 전송 시간
    private String sendTime;

//    public void setId(Long id ){
//        this.id = id ;
//    }

    @Builder
    public Chats(String userid, String content, String sendTime){
        this.userid = userid;
        this.content = content;
        this.sendTime = sendTime;
    }
}
