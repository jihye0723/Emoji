class TrainInfo {
  final String currentStation;
  final int lineNo;
  final String beforeStation;
  final String beforeTrainCode;
  final int beforeRemainTime;
  final String nextStation;
  final String nextTrainCode;
  final int nextRemainTime;

  TrainInfo({
      required this.currentStation,
      required this.lineNo,
      required this.beforeStation,
      required this.beforeTrainCode,
      required this.beforeRemainTime,
      required this.nextStation,
      required this.nextTrainCode,
      required this.nextRemainTime});

  factory TrainInfo.fromJson(Map<String, dynamic> jsonData){
    return TrainInfo(
        currentStation: jsonData['currentStation'],
        lineNo: jsonData['lineNo'],
        beforeStation: jsonData['before']['stationName'],
        beforeTrainCode: jsonData['before']['trainCode'],
        beforeRemainTime: jsonData['before']['remainTime'],
        nextStation: jsonData['before']['stationName'],
        nextTrainCode: jsonData['before']['trainCode'],
        nextRemainTime: jsonData['before']['remainTime']);
  }

  // TrainInfo.fromJson(Map<String, dynamic> json)
  //   : currentStation = json['currentStation'],
  //       lineNo = json['lineNo'],
  //       beforeStation = json['before'].stationName,
  //       beforeTrainCode = json['before'].trainCode,
  //       beforeRemainTime = json['before'].remainTime,
  //       nextStation = json['next'].stationName,
  //       nextTrainCode = json['next'].trainCode,
  //       nextRemainTime = json['next'].remainTime;

  Map<String, dynamic> ToJson() => {
    'currentStation' : currentStation,
    'lineNo' : lineNo,
    'before' : {
      'stationName' : beforeStation,
      'trainCode' : beforeTrainCode,
      'remainTime' : beforeRemainTime
    },
    'next' : {
      'stationName' : nextStation,
      'trainCode' : nextTrainCode,
      'remainTime' : nextRemainTime
    }
  };
}
