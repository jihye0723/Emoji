package com.o2a4.moduleservice.subway.dto;

import com.o2a4.moduleservice.subway.document.Station;
import lombok.Data;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.ToString;

@Data
@Getter
@ToString
@NoArgsConstructor
public class StationDto implements Comparable<StationDto> {
    /* ordkey는 다음과 같이 구성되어 있습니다.
    - 상하행 코드: 숫자 1자리
    - 순번 코드: 숫자 1자리
    - 첫번째 도착예정 정류장-현재 정류장 코드: 숫자 3자리
    - 목적지 정류장: 문자열
    - 급행여부 코드: 숫자 1자리
     */
    private String ordkey;      // 도착예정열차순번
    private String arvlCd;      // 도착코드 (0:진입, 1:도착, 2:출발, 3:전역출발, 4:전역진입, 5:전역도착, 99:운행중)
    private String updnLine;    // 상, 하행
    private String subwayId;    // 지하철 호선 ID
//    private String statnId;     // 지하철역 ID
    private String statnNm;     // 지하철역 명
//    private String statnFid;    // 이전 지하철역 ID
//    private String statnFnm;    // 이전 지하철역 명
//    private String statnTid;    // 다음 지하철역 ID
//    private String statnTnm;    // 다음 지하철역 명
    private String trainLineNm; // 도착지 방면 (성수행 - 구로디지털단지방면)
    private String btrainSttus; // 열차종류 (급행,ITX)
    private String recptnDt;    // 열차도착정보를 생성한 시각
    private String barvlDt;     // 열차도착예정시간
    private String btrainNo;    // 열차번호
    private String arvlMsg2;    // 첫번째 도착 메세지 (전역 진입, 전역 도착 등)
    private String arvlMsg3;    // 두번째 도착 메세지 (종합운동장 도착, 12분 후 (광명사거리) 등)

    @Override
    public int compareTo(StationDto stationDto) {
        int compareSubwayId = this.subwayId.compareTo(stationDto.getSubwayId());
        int compareUpdnLine = stationDto.getUpdnLine().compareTo(this.updnLine);
        int compareOrdkey = this.ordkey.compareTo(stationDto.getOrdkey());

        if(compareSubwayId == 0)    {
            if(compareUpdnLine == 0)    {
                return compareOrdkey;
            }
            else return compareUpdnLine;
        }
        return compareSubwayId;
    }


//        "rowNum": 3,
//        "selectedCount": 2466,
//        "subwayId": "1065",
//
//        "updnLine": "상행",
//        "trainLineNm": "검암행 - 검암방면",
//  
//        "statnFid": "1065006507",
//        "statnTid": "1065006505",
//        "statnId": "1065006506",
//        "statnNm": "계양",
//     
//        "ordkey": "01000검암0",
//        
//        
//        "btrainSttus": null,
//        "barvlDt": "0",
//        "btrainNo": "A3071",
//
//  
//  
//        "recptnDt": "2022-11-02 17:03:22.0",
//        "arvlMsg2": "계양 출발",
//        "arvlMsg3": "계양",
//        "arvlCd": "2"     // (0:진입, 1:도착, 2:출발, 3:전역출발, 4:전역진입, 5:전역도착, 99:운행중)

}
