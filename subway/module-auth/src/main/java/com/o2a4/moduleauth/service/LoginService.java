package com.o2a4.moduleauth.service;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.o2a4.moduleauth.api.LoginAPIClient;
import com.o2a4.moduleauth.document.Member;
import com.o2a4.moduleauth.dto.TokenInfo;
import com.o2a4.moduleauth.repository.MemberRepository;
import com.o2a4.moduleauth.security.JwtTokenProvider;
import lombok.AllArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.config.annotation.authentication.builders.AuthenticationManagerBuilder;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Component;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.UUID;

@Slf4j
@Component
@AllArgsConstructor
@Service
public class LoginService {
    private final MemberRepository memberRepository;
    private final AuthenticationManagerBuilder authenticationManagerBuilder;
    private final JwtTokenProvider jwtTokenProvider;
    private final LoginAPIClient loginAPIClient;


    @Transactional
    public TokenInfo kakaoLogin(String accessToken) throws JsonProcessingException {
        // 사용자 정보 읽어오기
        Member memberInfo = loginAPIClient.getUserInfo(accessToken);

        // test
//        Member memberInfo = new Member();
//        memberInfo.setKakaoId("ssafy");
//        memberInfo.setEmail("ssafy@google.com");
//        memberInfo.setUuid("a5dedf83-a737-4482-80d4-f04ce346440d");

        log.info("1");
        UsernamePasswordAuthenticationToken authenticationToken = new UsernamePasswordAuthenticationToken(memberInfo.getEmail(), memberInfo.getUuid());

        // 2. 실제 검증 (사용자 비밀번호 체크)이 이루어지는 부분
        // authenticate 매서드가 실행될 때 CustomUserDetailsService 에서 만든 loadUserByUsername 메서드가 실행
        Authentication authentication = authenticationManagerBuilder.getObject().authenticate(authenticationToken);

        log.info("2");
        // 3. 인증 정보를 기반으로 JWT 토큰 생성
        TokenInfo tokenInfo = jwtTokenProvider.generateToken(authentication);

        log.info("3");

        return tokenInfo;
    }

}


