package com.o2a4.moduleauth.service;

import com.o2a4.moduleauth.api.LoginAPIClient;
import com.o2a4.moduleauth.repository.UserRepository;
import lombok.AllArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Component;
import org.springframework.stereotype.Service;

import java.io.IOException;
import java.util.List;
import java.util.Map;

@Slf4j
@Component
@AllArgsConstructor
@Service
public class LoginService {
    private final UserRepository userRepository;
    private final LoginAPIClient loginAPIClient;

    public String kakaoLogin(String accessToken)  {
        // 사용자 정보 읽어오기
        Map<String, Object> userInfo = loginAPIClient.getUserInfo(accessToken);



        return null;
    }

}


