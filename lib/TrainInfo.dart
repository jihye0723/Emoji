import 'dart:convert';

class JsonData {
/*
 * 샘플 데이터 json 구조
 *
 * "station" : "사당",
 * "trainList" : [
 *   {
 *    "line" : "2호선",
 *    "direction" : 1 (외선),
 *    "trainNo" : "2147",
 *    "remainTime" : 7777 },
 *   {
 *    "line" : "4호선",
 *    "direction" : 0 (상행),
 *    "trainNo" : "4642",
 *    "remainTime" : 125 },
 *   {
 *    "line" : "4호선",
 *    "direction" : 1 (하행),
 *    "trainNo" : "4129",
 *    "remainTime" : 374 },
 *   {
 *    "line" : "2호선",
 *    "direction" : 0 (내선),
 *    "trainNo" : "2156",
 *    "remainTime" : 111 },
 * ]
 */

  final String stationName;
  final List<Train> trainList;

  JsonData({required this.stationName, required this.trainList});

  factory JsonData.fromJson(Map<String, dynamic> parsedJson) {
    var list = parsedJson['trainList'] as List;
    List<Train> trainList = list.map((i) => Train.fromJson(i)).toList();

    return JsonData(
        stationName: parsedJson['stationName'], trainList: trainList);
  }
}

class Train {
  final String line;
  final int direction;
  final String trainNo;
  final int remainTime;

  Train(
      {required this.line,
      required this.direction,
      required this.trainNo,
      required this.remainTime});

  factory Train.fromJson(Map<String, dynamic> parsedJson) {
    return Train(
        line: parsedJson['line'],
        direction: parsedJson['direction'],
        trainNo: parsedJson['trainNo'],
        remainTime: parsedJson['remainTime']);
  }
}
