package com.o2a4.moduleauth.document;

import lombok.Getter;
import org.springframework.data.annotation.Id;
import org.springframework.data.mongodb.core.mapping.Document;

//@Data
@Getter
@Document(collection = "users")
public class User {

    @Id
    private String _id;

}
