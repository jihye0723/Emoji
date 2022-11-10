import 'package:http/http.dart' as http;
import 'dart:convert';

//기본 url
var url = 'http://10.0.2.2:8101';

//입장을 위한 통신 , 내 토큰이랑 기차 칸 보내준다.
enterRoom(String mytoken, String train) async {
  Map data = {"name": "trainId", "data": train};
  var body = json.encode(data);

  final response = await http.post(Uri.parse('$url/chat/in'),
      headers: {
        "Content-type": "application/json",
        "token": mytoken,
      },
      body: body);

  var receivedata = jsonDecode(response.body)['data'];
  //print(receivedata);

  //오류처리를 위한 분기
  if (receivedata != null) {
  } else {
    receivedata = "-1";
  }
  return receivedata;
}

  //print("hi");
  //print(json.decode(response.body));
  //print(jsonDecode(response.body)['data']);

  // return Info.fromJson(json.decode(response.body));

// class Info {
//   final String name;
//   final String data;

//   Info({required this.name, required this.data});

//   factory Info.fromJson(Map<String, dynamic> json) {
//     return Info(name: json["name"], data: json["data"]);
//   }

