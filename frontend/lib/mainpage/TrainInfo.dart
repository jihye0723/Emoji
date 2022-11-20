import 'dart:convert';

class TrainInfo {
// sample data json 구조

  final String stationName;
  final List<Train> trainList;

  TrainInfo({required this.stationName, required this.trainList});

  factory TrainInfo.fromJson(Map<String, dynamic> parsedJson) {
    var list = parsedJson['trainList'] as List;
    var name = parsedJson['stationName'];
    List<Train> trainList = list.map((i) => Train.fromJson(i)).toList();

    return TrainInfo(
        stationName: name != null ? name : "null인데유?", trainList: trainList);
  }
}

class Train {
  final String line;
  final int direction;
  final String trainNo;
  final int remainTime;
  final String detail;
  final String arvlMsg2;
  final String arvlMsg3;

  Train(
      {required this.line,
      required this.direction,
      required this.trainNo,
      required this.remainTime,
      required this.detail,
      required this.arvlMsg2,
      required this.arvlMsg3});

  factory Train.fromJson(Map<String, dynamic> parsedJson) {
    return Train(
        line: parsedJson['line'],
        direction: parsedJson['direction'],
        trainNo: parsedJson['trainNo'],
        remainTime: parsedJson['remainTime'],
        detail: parsedJson['detail'],
        arvlMsg2: parsedJson['arvlMsg2'],
        arvlMsg3: parsedJson['arvlMsg3']);
  }

  @override
  String toString() {
    return 'Train{line: $line, direction: $direction, trainNo: $trainNo, remainTime: $remainTime, detail: $detail, arvlMsg2: $arvlMsg2, arvlMsg3: $arvlMsg3}';
  }
}
