import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

bool validateToken(dynamic tkn) {
  // 앱 실행 (스플래시 화면동안)
  // 0. secure storage 에 isLogin 체크
  // isLogin? 토큰검증 : 로그인페이지

  // 토큰 검증
  // 1. 서버로 토큰 검증 요청 (OK / FAIL)
  // AT (accessToken) 유효하면 -> OK
  // AT 만료된 경우 -> RT 이용해 재발급 -> OK
  // RT 만료된 경우 -> FAIL
  // 토큰 위변조(비정상) 경우 -> FAIL

  // 토큰 검증 성공(OK)
  // 메인페이지로 이동

  // 재 로그인
  // 2-1. (토큰 검증 결과가 FAIL 인 경우) secure storage 토큰정보 삭제하고 로그인 페이지로 이동
  // 2-2. kakao API 이용해서 인증토큰 발급
  // 2-3. 인증토큰 서버로 전달해 jwt 토큰 발급

  // --------------------------------------------------

  // API 요청 및 채팅방 입장 시
  // 액세스 토큰을 저렇게 실어서 넘겨줄것
  // headers: {
  //   "Content-type": "application/json",
  // "Authorization": "Bearer $accessToken",
  // }

  final storage = FlutterSecureStorage();

  // 토큰 검증 요청할 url
  Uri uri = Uri.http("k7a6022.p.ssafy.io", "/oauth/validation");

  String at = json.decode(tkn)['accessToken'];
  String rt = json.decode(tkn)['refreshToken'];

  http.post(uri, body: {'accessToken': at, 'refreshToken': rt}).then((value) {
    int resultCode = value.statusCode;
    print("statusCode = $resultCode");
    if (resultCode == 200) {
      // 정상 토큰
      // secureStorage 토큰 갱신
      print("저장된 토큰 갱신");
      storage.write(
          key: "accessToken", value: json.decode(value.body)['accessToken']);
      storage.write(
          key: "refreshToken", value: json.decode(value.body)['refreshToken']);

      // 메인페이지로 이동
      return true;
    } else {
      // secureStorage 토큰 삭제
      print("저장된 토큰 삭제");
      storage.delete(key: "accessToken");
      storage.delete(key: "refreshToken");

      // 로그인 페이지로 이동
      return false;
    }
  });

  return false;
  // return true;
}
