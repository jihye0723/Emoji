import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import 'package:practice_01/login/social_login.dart';
import 'package:http/http.dart' as http;
/*
* 토큰이 있다면, 로그인 페이지를 띄워주지 않아도 됨.
* 토큰이 없다면, 로그인 페이지를 띄워주어 로그인 할 수 있도록 함.
*/
class KakaoLogin implements SocialLogin {

  // url:8081/oauth/kakao-login?access-token=
  _postRequest(String tkn) async {
    // String baseUrl = 'http://localhost:8081/oauth/kakao-login?';
    // baseUrl += 'access-token=$tkn';

    // 안드로이드 에뮬레이터가 localhost대신 10.0.2.2를 사용하므로.
    var uri = Uri.http('10.0.2.2:8081', '/oauth/kakao-login', { 'access-token' : tkn });

    var res = await http.post(uri);
    return res;
  }

  @override
  Future login() async {

    // 카카오톡이 설치되어 있는지를 true, false로 받아온다.
    bool isInstalled = await isKakaoTalkInstalled();
    // 설치되어있는지 확인하고 그에 맞는 로그인 절차 진행
    if (isInstalled) {
      try {
        OAuthToken token = await UserApi.instance.loginWithKakaoTalk();
        print('카카오톡으로 로그인(인증) 성공 ${token.accessToken}');
        return _postRequest(token.accessToken);
      } catch (error) {
        print('카카오톡으로 로그인(인증) 실패 $error');
        return null;
      }
    }
    // 카카오톡이 설치되어 있지 않다면,
    else {
      try {
        // 카카오 계정으로 로그인 유도
        OAuthToken token = await UserApi.instance.loginWithKakaoAccount();
        print('카카오 계정으로 로그인(인증) 성공 ${token.accessToken}');
        return _postRequest(token.accessToken);
      }
      catch (error) {
        print('카카오 계정으로 로그인(인증) 실패 $error');
        return null;
      }
    }
  }
}