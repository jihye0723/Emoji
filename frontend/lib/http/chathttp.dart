import 'package:http/http.dart' as http;
import 'dart:convert';

//기본 url
var url = 'http://10.0.2.2:8101';
var url2 = 'http://10.0.2.2:8082';
var server = 'http://k7a6022.p.ssafy.io';

class chatroom {
  Future getPort(String mytoken, String train) async {
    Map data = {"name": "trainId", "data": train};
    var body = json.encode(data);

    final response = await http.post(Uri.parse('$url/chat/in'),
        headers: {
          "Content-type": "application/json",
          "token": mytoken,
          //"Authorization": "Bearer $accessToken",
        },
        body: body);
    print(response.body);
    if (response.statusCode == 200) {
      final responseBody = jsonDecode(response.body)['data'];
      return responseBody;
    }
  }

  // 자리양도 참가
  Future attend(String mytoken, String myid, String ownerid) async {
    Map data = {"attend_id": myid, "userId": ownerid};
    var body = json.encode(data);

    final response = await http.post(Uri.parse('$url2/seat/attend'),
        headers: {
          "Content-type": "application/json",
          "token": mytoken,
          // "Authorization": "Bearer $accessToken",
        },
        body: body);

    if (response.statusCode == 200) {
      const responseBody = "OK";
      return responseBody;
    }
  }

  //자리양도 종료
  Future finish(String mytoken, String ownerid, String content) async {
    Map data = {"userId": ownerid, "content": content};
    var body = json.encode(data);

    final response = await http.post(Uri.parse('$url2/seat/finish'),
        headers: {
          "Content-type": "application/json",
          "token": mytoken,
          // "Authorization": "Bearer $accessToken",
        },
        body: body);

    if (response.statusCode == 200) {
      const responseBody = "OK";
      return responseBody;
    }
  }

  //사용자 신고
  Future report(String mytoken, String userid) async {
    Map data = {"userId": userid};
    var body = json.encode(data);

    final response = await http.post(Uri.parse('$url2/user'),
        headers: {
          "Content-type": "application/json",
          "token": mytoken,
          // "Authorization": "Bearer $accessToken",
        },
        body: body);
    print(response.statusCode);
    if (response.statusCode == 200) {
      const responseBody = "OK";
      return responseBody;
    }
  }
}
