package com.o2a4.moduleservice.subway.service;

import com.o2a4.moduleservice.subway.api.SubwayAPIClient;
import com.o2a4.moduleservice.subway.document.Station;
import com.o2a4.moduleservice.subway.dto.StationDto;
import com.o2a4.moduleservice.subway.repository.StationRepository;
import lombok.AllArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Component;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

@Slf4j
@Component
@AllArgsConstructor
@Service
public class SubwayService {
    private final StationRepository stationRepository;
    private final SubwayAPIClient subwayAPIClient;

    public List<StationDto> findStation(double latitude, double longtitude) throws Exception {
        Station data = new Station();
        List<Station> list =  stationRepository.findAll();

        // 미터(Meter) 단위
//        System.out.println("Lat : " + latitude + ",    Lon : " + longtitude);
//        System.out.println("Lat : " + list.get(1).getLatitude() + ",    Lon : " + list.get(1).getLongitude());

        for (Station s:list) {
            double distanceMeter = distance(latitude, longtitude, s.getLatitude(), s.getLongitude(), "meter");

            if(distanceMeter <= 100) {
                data = s;
                break;
            }
        }

//        Station a = stationRepository.findByStationCodeEquals(data.getStationName());
//        boolean b = stationRepository.existsByStationCode(data.getStationCode());
//        boolean c = stationRepository.existsByStationCode("ASDFASDF");
//        System.out.println("test b : " + b);
//        System.out.println("test c : " + c);
        List<StationDto> result = new ArrayList<>() ;
        if(data.getStationName() != null) {
            result = subwayAPIClient.realtimeStationArrivalInfo(data.getStationName());
            Collections.sort(result);
        }
        else
            result = null;
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
