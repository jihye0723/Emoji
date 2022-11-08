import 'dart:convert';

class APIResponse {
// sample data json 구조

  final ErrorMessage errorMessage;
  final List<Train> realtimeArrivalList;

  APIResponse({required this.errorMessage, required this.realtimeArrivalList});

  factory APIResponse.fromJson(Map<String, dynamic> parsedJson) {
    var list = parsedJson['realtimeArrivalList'] as List;

    List<Train> rtaList = list.map((i) => Train.fromJson(i)).toList();

    return APIResponse(
        errorMessage: parsedJson['errorMessage'], realtimeArrivalList: rtaList);
  }
}

class ErrorMessage {
  final String code;
  final String developerMessage;
  final String link;
  final String message;
  final int status;
  final int total;

  ErrorMessage(this.code, this.developerMessage, this.link, this.message,
      this.status, this.total);

  factory ErrorMessage.fromJson(Map<String, dynamic> parsedJson) {
    return ErrorMessage(
        parsedJson["code"],
        parsedJson["developerMessage"],
        parsedJson["link"],
        parsedJson["message"],
        parsedJson["status"],
        parsedJson["total"]);
  }
}

class Train {
  final String ordkey; // 도착예정열차순번
  final String arvlCd; // 도착코드
  final String updnLine; // 상행, 하행
  final String subwayId; // 지하철 호선 ID

  final String statnId, statnNm; // 현재 지하철역 ID, 이름
  final String statnFid, statnFnm; // 이전 지하철역 ID, 이름
  final String statnTid, statnTnm; // 다음 지하철역 ID, 이름

  final String trainLineNm; // 도착지 방면 (성수행 - 구로디지털단지방면)
  final String btrainSttus; // 열차종류 (급행, ITX)
  final String recptnDt; // 도착정보 생성 시각

  final String barvlDt; // 열차도착 예정시간
  final String btrainNo; // 열차 번호
  final String arvlMsg2, arvlMsg3; // 도착 메세지

  Train(
      this.ordkey,
      this.arvlCd,
      this.updnLine,
      this.subwayId,
      this.statnId,
      this.statnNm,
      this.statnFid,
      this.statnFnm,
      this.statnTid,
      this.statnTnm,
      this.trainLineNm,
      this.btrainSttus,
      this.recptnDt,
      this.barvlDt,
      this.btrainNo,
      this.arvlMsg2,
      this.arvlMsg3);

  factory Train.fromJson(Map<String, dynamic> parsedJson) {
    return Train(
        parsedJson["ordkey"],
        parsedJson["arvlCd"],
        parsedJson["updnLine"],
        parsedJson["subwayId"],
        parsedJson["statnId"],
        parsedJson["statnNm"],
        parsedJson["statnFid"],
        parsedJson["statnFnm"],
        parsedJson["statnTid"],
        parsedJson["statnTnm"],
        parsedJson["trainLineN"],
        parsedJson["btrainSttus"],
        parsedJson["recptnDt"],
        parsedJson["barvlDt"],
        parsedJson["btrainNo"],
        parsedJson["arvlMsg2"],
        parsedJson["arvlMsg3"]);
  }
}
