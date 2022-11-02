package com.o2a4.moduleservice.subway.service;

import com.o2a4.moduleservice.subway.document.Station;
import com.o2a4.moduleservice.subway.dto.StationDto;
import com.o2a4.moduleservice.subway.repository.StationRepository;
import lombok.AllArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.*;
import org.springframework.stereotype.Component;
import org.springframework.stereotype.Service;
import org.springframework.web.client.RestTemplate;

import java.io.UnsupportedEncodingException;
import java.net.HttpURLConnection;
import java.net.URL;
import java.net.URLEncoder;
import java.util.List;
import java.util.Map;

//@Slf4j
@Component
@AllArgsConstructor
@Service
public class SubwayService {
    private final StationRepository stationRepository;

    public void realtimeStationArrivalInfo() throws Exception {
        StringBuilder urlBuilder = new StringBuilder("http://swopenAPI.seoul.go.kr/api/subway"); /*URL*/
        urlBuilder.append("/" +  URLEncoder.encode("4e6a745a69706a7736304550596e44","UTF-8") ); /*인증키 (sample사용시에는 호출시 제한됩니다.)*/
        urlBuilder.append("/" +  URLEncoder.encode("json","UTF-8") ); /*요청파일타입 (xml,xmlf,xls,json) */
        urlBuilder.append("/" + URLEncoder.encode("realtimeStationArrival","UTF-8")); /*서비스명 (대소문자 구분 필수입니다.)*/
        urlBuilder.append("/" + URLEncoder.encode("ALL","UTF-8")); /*요청시작위치 (sample인증키 사용시 5이내 숫자)*/

        RestTemplate restTemplate = new RestTemplate();
        HttpEntity<?> entity = new HttpEntity<>(new HttpHeaders());
        ResponseEntity<Map> resultMap = restTemplate.exchange(urlBuilder.toString(), HttpMethod.GET, entity, Map.class);

        if(resultMap.getStatusCode().equals(HttpStatus.OK)) {
            System.out.println(resultMap.getBody());
        }


    }
    public Station findStation(double latitude, double longtitude) throws Exception {
        Station result = new Station();
        List<Station> list =  stationRepository.findAll();

        // 미터(Meter) 단위
        System.out.println("Lat : " + latitude + ",    Lon : " + longtitude);
        System.out.println("Lat : " + list.get(1).getLatitude() + ",    Lon : " + list.get(1).getLongitude());
        for (Station s:list) {
            double distanceMeter =
                    distance(latitude, longtitude, s.getLatitude(), s.getLongitude(), "meter");

            System.out.println("역 : " + s.getStationName() + " |   거리 : " + distanceMeter);
            if(distanceMeter <= 20) {
                result = s;
                break;
            }
        }

        realtimeStationArrivalInfo();
        return result;
    }

    /**
     * 두 지점간의 거리 계산
     *
     * @param lat1 지점 1 위도
     * @param lon1 지점 1 경도
     * @param lat2 지점 2 위도
     * @param lon2 지점 2 경도
     * @param unit 거리 표출단위
     * @return
     */
    private static double distance(double lat1, double lon1, double lat2, double lon2, String unit) {

        double theta = lon1 - lon2;
        double dist = Math.sin(deg2rad(lat1)) * Math.sin(deg2rad(lat2)) + Math.cos(deg2rad(lat1)) * Math.cos(deg2rad(lat2)) * Math.cos(deg2rad(theta));

        dist = Math.acos(dist);
        dist = rad2deg(dist);
        dist = dist * 60 * 1.1515;

        if (unit.equals("kilometer")) {
            dist = dist * 1.609344;
        } else if(unit.equals("meter")){
            dist = dist * 1609.344;
        }

        return (dist);
    }

    // This function converts decimal degrees to radians
    private static double deg2rad(double deg) {
        return (deg * Math.PI / 180.0);
    }

    // This function converts radians to decimal degrees
    private static double rad2deg(double rad) {
        return (rad * 180 / Math.PI);
    }
}
