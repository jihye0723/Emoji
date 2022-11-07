package com.o2a4.chattcp.data;

import lombok.Builder;
import lombok.Data;
import org.springframework.data.annotation.Id;
import org.springframework.data.annotation.Transient;
import org.springframework.data.annotation.TypeAlias;
import org.springframework.data.mongodb.core.mapping.Document;

@Data
@Document(collection = "chats")
@TypeAlias("chats")
public class Chats {
    @Id
    private String _id;

    private String userid;
    private String content;

    //시간

//    public void setId(Long id ){
//        this.id = id ;
//    }

    @Builder
    public Chats(String userid, String content){
        this.userid = userid;
        this.content = content;
    }
}
