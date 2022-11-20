import 'dart:convert';

class APIResponse {
// sample data json 구조

  final List<APITrain> realtimeArrivalList;

  APIResponse({required this.realtimeArrivalList});
}

class APITrain {
  final String ordkey; // 도착예정열차순번
  final String arvlCd; // 도착코드
  final String updnLine; // 상행, 하행
  final String subwayId; // 지하철 호선 ID

  final String statnNm; // 지하철 역 이름
  final String trainLineNm; // 도착지 방면 (성수행 - 구로디지털단지방면)
  final String btrainSttus; // 열차종류 (급행, ITX)
  final String recptnDt; // 도착정보 생성 시각

  final String barvlDt; // 열차도착 예정시간
  final String btrainNo; // 열차 번호
  final String arvlMsg2, arvlMsg3; // 도착 메세지

  APITrain(
      this.ordkey,
      this.arvlCd,
      this.updnLine,
      this.subwayId,
      this.statnNm,
      this.trainLineNm,
      this.btrainSttus,
      this.recptnDt,
      this.barvlDt,
      this.btrainNo,
      this.arvlMsg2,
      this.arvlMsg3);

  factory APITrain.fromJson(Map<String, dynamic> parsedJson) {
    return APITrain(
        parsedJson["ordkey"] ?? "",
        parsedJson["arvlCd"] ?? "",
        parsedJson["updnLine"] ?? "",
        parsedJson["subwayId"] ?? "",
        parsedJson["statnNm"] ?? "",
        parsedJson["trainLineNm"] ?? "",
        parsedJson["btrainSttus"] ?? "",
        parsedJson["recptnDt"] ?? "",
        parsedJson["barvlDt"] ?? "",
        parsedJson["btrainNo"] ?? "",
        parsedJson["arvlMsg2"] ?? "",
        parsedJson["arvlMsg3"] ?? "");
  }
}
