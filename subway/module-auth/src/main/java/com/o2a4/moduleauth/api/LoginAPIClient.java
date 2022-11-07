package com.o2a4.moduleauth.api;

import com.fasterxml.jackson.databind.DeserializationFeature;
import com.fasterxml.jackson.databind.ObjectMapper;
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
    private final String kakaoApiKey = "8a7db866db69e1fddae07d133a157361";  // REST API KEy

    public Map<String, Object> getUserInfo (String accessToken) {
        Map<String, Object> userInfo = new HashMap<>();
        String url = "https://kapi.kakao.com/v2/user/me";


        HttpHeaders headers = new HttpHeaders();
        headers.set("Authorization", "bearer " + accessToken);
        headers.set("KakaoAK", kakaoApiKey);

        HttpEntity<?> entity = new HttpEntity<>(headers);
        ResponseEntity<Map> resultMap = restTemplate.exchange(url, HttpMethod.POST, entity, Map.class);

        if(resultMap.getStatusCode().equals(HttpStatus.OK)) {
            ObjectMapper objectMapper = new ObjectMapper();
            objectMapper.configure(DeserializationFeature.FAIL_ON_UNKNOWN_PROPERTIES, false);   //선언한 필드만 매핑

//            String jsonSting = objectMapper.writeValueAsString(resultMap.getBody().get("realtimeArrivalList"));
//            stationDtos = objectMapper.readValue(jsonSting, new TypeReference<List<StationDto>>() {});//Event[].class);
            System.out.println(resultMap.getBody());
            System.out.println(resultMap.getBody().getClass().getName());

        }

        return userInfo;
    }
}
