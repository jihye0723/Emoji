package com.o2a4.moduleauth.document;

import lombok.Getter;
import lombok.Setter;
import org.springframework.data.annotation.Id;
import org.springframework.data.mongodb.core.mapping.Document;

import java.util.UUID;

//@Data
@Getter
@Setter
@Document(collection = "users")
public class Member {
    @Id
    private String _id;
    private String kakaoId;
    private String uuid;
    private String email;

}
