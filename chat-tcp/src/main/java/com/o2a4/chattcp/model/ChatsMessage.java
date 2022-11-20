package com.o2a4.chattcp.model;

import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

/* kafka 에 저장되는 데이터 ( json ) */
@Data
public class ChatsMessage {

    String userId;
    String content;
    String send_at;

    @Builder
    public ChatsMessage(String userId, String content, String send_at){
        this.userId = userId;
        this.content= content;
        this.send_at = send_at;
    }


}
