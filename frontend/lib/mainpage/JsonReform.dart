import 'package:practice_01/mainpage/APIResponse.dart';
import 'package:practice_01/mainpage/LineCodeToName.dart';
import 'package:practice_01/mainpage/TrainInfo.dart';

TrainInfo jsonReform(List<APITrain> res) {
  List<Train> list = []; // 추가해줄 빈 리스트
  String stationName = "";

  int l = res.length;
  print(l);

  for (int i = 0; i < l; i++) {
    APITrain item = res[i];

    print("JsonReform, subwayId : " + item.subwayId);
    String line = lineCodeName(item.subwayId);
    print("JsonReform, line : " + line);
    int direction = int.parse(item.updnLine);
    String? trainNo = item.btrainNo;
    int remainTime = int.parse(item.barvlDt);
    String? detail = item.trainLineNm;
    String? arvlMsg2 = item.arvlMsg2;
    String? arvlMsg3 = item.arvlMsg3;

    String? statnNm = item.statnNm;
    if (stationName == "" && statnNm.isNotEmpty) stationName = statnNm;

    // 첫번째 이후의 데이터일 때
    print("current length : ${list.length}");
    if (i != 0) {
      // 바로 직전 데이터를 확인해서 line이 같다면
      Train before = list.last;
      if (before.line == line) {
        // direction도 체크하고 이때도 같으면 스킵
        // (orderkey 순서로 정렬이 되어있기 때문에 나중에 도착하는 열차임)
        if (before.direction == direction) continue;
        // else 호선은 같고, 방향이 다른 열차
      }
      // else 호선이 다른 열차
    }

    Train t = Train(
        line: line,
        direction: direction,
        trainNo: trainNo,
        remainTime: remainTime,
        detail: detail,
        arvlMsg2: arvlMsg2,
        arvlMsg3: arvlMsg3);

    list.add(t);
    print("$i 번째 추가");
  }

  TrainInfo ti = TrainInfo(stationName: stationName, trainList: list);

  return ti;
}
