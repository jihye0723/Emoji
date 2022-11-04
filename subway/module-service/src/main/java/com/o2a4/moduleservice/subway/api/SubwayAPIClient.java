package com.o2a4.moduleservice.subway.api;

import lombok.AllArgsConstructor;
import lombok.RequiredArgsConstructor;
import org.springframework.http.*;
import org.springframework.stereotype.Component;
import org.springframework.stereotype.Service;
import org.springframework.web.client.RestTemplate;

import java.net.URLEncoder;
import java.util.Map;

@Component
@RequiredArgsConstructor
@Service
public class SubwayAPIClient {
    private final RestTemplate restTemplate;     // RequiredArgsConstructor은 final로 선언된 필드에 생성자 만드는데, 이 경우 에러남

    public void realtimeStationArrivalInfo(String station) throws Exception {
        StringBuilder urlBuilder = new StringBuilder("http://swopenAPI.seoul.go.kr/api/subway");       // URL*/
        urlBuilder.append("/" + URLEncoder.encode("4e6a745a69706a7736304550596e44","UTF-8") );  // 인증키 (sample사용시에는 호출시 제한됩니다.)*/
        urlBuilder.append("/" + URLEncoder.encode("json","UTF-8") );                            // 요청파일타입 (xml,xmlf,xls,json) */
        urlBuilder.append("/" + URLEncoder.encode("realtimeStationArrival","UTF-8"));           // 서비스명 (대소문자 구분 필수입니다.)*/
        urlBuilder.append("/" + URLEncoder.encode("1","UTF-8"));                 // 요청시작위치  */
        urlBuilder.append("/" + URLEncoder.encode("20","UTF-8"));                // 요청끝위치  */
        urlBuilder.append("/" + station);                                               // 역명  //URLEncoder.encode(station,"UTF-8"));

        System.out.println(station);
        System.out.println(urlBuilder.toString());

        HttpEntity<?> entity = new HttpEntity<>(new HttpHeaders());
        ResponseEntity<Map> resultMap = restTemplate.exchange(urlBuilder.toString(), HttpMethod.GET, entity, Map.class);

        if(resultMap.getStatusCode().equals(HttpStatus.OK)) {
            System.out.println(resultMap.getBody());
//            System.out.println(resultMap.getBody().getClass().getName());
        }
    }
}
