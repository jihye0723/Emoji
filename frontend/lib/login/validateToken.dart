import 'package:jwt_decode/jwt_decode.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

validateToken(String tkn) {
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
  // 2-4. (jwt) 토큰 검증

  // --------------------------------------------------

  // API 요청 및 채팅방 입장 시
  // 액세스 토큰을 저렇게 실어서 넘겨줄것
  // headers: {
  //   "Content-type": "application/json",
  // "Authorization": "Bearer $accessToken",
  // }

  Uri uri = Uri.http("k7a6022.p.ssafy.io", "/");

  http.post(uri, body: {'token': tkn}).then((value) {
    // 토큰 검증 결과를 가지고 어쩌고 저쩌고
  });

  // api 요청
  //
  // 200
}
