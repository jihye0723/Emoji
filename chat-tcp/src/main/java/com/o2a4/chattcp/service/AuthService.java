package com.o2a4.chattcp.service;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.web.reactive.function.client.WebClient;

@Slf4j
@Service
@RequiredArgsConstructor
public class AuthService {

    public boolean getAuth(String token) {
        // 로그인 인증 과정
        WebClient client = WebClient.create("127.0.0.1:8081");

        return true;
    }
}
