package com.o2a4.moduleauth.api;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.DeserializationFeature;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.o2a4.moduleauth.document.Member;
import com.o2a4.moduleauth.dto.KakaoDto;
import com.o2a4.moduleauth.repository.MemberRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.http.*;
import org.springframework.stereotype.Component;
import org.springframework.stereotype.Service;
import org.springframework.web.client.RestTemplate;

import java.util.*;

@Component
@RequiredArgsConstructor
@Service
public class LoginAPIClient {
    private final RestTemplate restTemplate;
    private final MemberRepository memberRepository;
    private final String kakaoApiKey = "8a7db866db69e1fddae07d133a157361";  // REST API KEy

    /*
        GET/POST /v2/user/me HTTP/1.1
        Host: kapi.kakao.com
        Authorization: Bearer ${ACCESS_TOKEN}/KakaoAK ${APP_ADMIN_KEY}
        Content-type: application/x-www-form-urlencoded;charset=utf-8
     */
    public Member getUserInfo (String accessToken) throws JsonProcessingException {
        Member member = new Member();
        Map<String, Object> userInfo = new HashMap<>();
        String url = "https://kapi.kakao.com/v2/user/me";

        HttpHeaders headers = new HttpHeaders();
        headers.set("Authorization", "bearer " + accessToken);
//        headers.set("KakaoAK", kakaoApiKey);  // ?

        HttpEntity<?> entity = new HttpEntity<>(headers);
        ResponseEntity<Map> resultMap = restTemplate.exchange(url, HttpMethod.POST, entity, Map.class);

        if(resultMap.getStatusCode().equals(HttpStatus.OK)) {
            ObjectMapper objectMapper = new ObjectMapper();
            objectMapper.configure(DeserializationFeature.FAIL_ON_UNKNOWN_PROPERTIES, false);   //선언한 필드만 매핑

            String kakaoId = objectMapper.writeValueAsString(resultMap.getBody().get("id"));
            if(!memberRepository.existsByKakaoId(kakaoId))    {
                String jsonSting = objectMapper.writeValueAsString(resultMap.getBody().get("kakao_account"));
                KakaoDto kakaoDto = objectMapper.readValue(jsonSting, KakaoDto.class); //Event[].class);

                member.setEmail(kakaoDto.getEmail());
                member.setKakaoId(kakaoId);
                member.setUuid(UUID.randomUUID().toString());
                memberRepository.save(member);
            }
            else {
                member = memberRepository.findByKakaoId(kakaoId);
            }

        }

        return member;
    }
}
