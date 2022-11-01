package com.o2a4.moduleservice.subway.document;

import lombok.Data;
import org.springframework.data.annotation.Id;
import org.springframework.data.mongodb.core.mapping.Document;

@Data
@Document(collection = "station")
public class Station {

    @Id
    private String _id;

    // 지하철역 코드
    private String stationCode;

    // 지하철역 이름
    private String stationName;

    // 호선
    private String subwayLine;

    // 위도
    private double latitude;
    
    // 경도
    private double longtitude;
}
