package com.o2a4.chattcp;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.data.mongodb.repository.config.EnableMongoRepositories;

@SpringBootApplication
public class ChatTcpApplication {

	public static void main(String[] args) {
		SpringApplication.run(ChatTcpApplication.class, args);
	}

}
