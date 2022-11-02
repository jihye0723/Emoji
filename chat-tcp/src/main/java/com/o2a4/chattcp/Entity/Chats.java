package com.o2a4.chattcp.Entity;

import lombok.Builder;
import lombok.Data;
import org.springframework.data.annotation.Id;
import org.springframework.data.mongodb.core.mapping.Document;

@Document(collection="chats")
@Data
public class Chats {
    @Id
    private int chatsNo;
    private String nickname;
    private String message;
    private String datetime;

    @Override
    public String toString(){
        return "chatsNo: "+ chatsNo + ", " + "nickname: "+
        nickname + ", "+ "message: " + message +", " + "datetime: "+
        datetime;
    }
    @Builder
    public Chats(String nickname, String message, String datetime){
        this.nickname = nickname;
        this.message = message;
        this.datetime = datetime;
    }


}
