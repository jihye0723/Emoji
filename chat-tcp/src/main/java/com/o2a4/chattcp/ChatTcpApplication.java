package com.o2a4.chattcp;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.web.reactive.config.EnableWebFlux;

@SpringBootApplication
//@EnableWebFlux
public class ChatTcpApplication {

	public static void main(String[] args) {
		SpringApplication.run(ChatTcpApplication.class, args);
	}

}
