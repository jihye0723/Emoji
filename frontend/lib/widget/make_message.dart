import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'make_nick.dart' as makeNick;
import '../http/chathttp.dart' as http;
import '/utils/snackbar.dart' as snackbar;

// nick - 채팅보낸사람 닉네임, text-문자, id-채팅보낸사람 아이디, myid- 내 아이디
// 내채팅 니채팅 확인, type 은 내채팅인지 확인하기 위해 만들어 둠, 추후에 작업이 필요 현재는 단순 아이디 비교
Widget message(
    BuildContext context, String nick, String text, String id, String myid) {
  if (id == myid) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10.0) +
          const EdgeInsets.only(right: 5.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          //사진 클릭 이벤트
          Container(
            margin: EdgeInsets.only(right: 16.0.w),
            // 사용자명의 첫번째 글자를 서클 아바타로 표시
            child: CircleAvatar(child: makeNick.getAvatar(nick)),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              // 사용자명을 subhead 테마로 출력
              Text(nick, style: Theme.of(context).textTheme.bodySmall),
              // 입력받은 메시지 출력
              Container(
                decoration: BoxDecoration(
                  color: Colors.black12,
                  borderRadius: BorderRadius.circular(10.0),
                ),
                margin: EdgeInsets.only(top: 5.h),
                padding: const EdgeInsets.all(8),
                constraints: BoxConstraints(
                  minWidth: nick.length.toDouble() * 10 > 280
                      ? 280
                      : (nick.length.toDouble() * 10),
                  maxWidth: 280,
                ),
                child: Text(text, softWrap: true),
              ),
            ],
          )
        ],
      ),
    );
  } else {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10.0) +
          const EdgeInsets.only(left: 5.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          //사진 클릭 이벤트
          GestureDetector(
            onTap: () {
              showDialog(
                  context: context,
                  barrierDismissible:
                      true, // Whether you can dismiss this route by tapping the modal barrier (default : true)
                  builder: (BuildContext ctx) {
                    double height = MediaQuery.of(ctx).size.height;
                    double width = MediaQuery.of(ctx).size.width;
                    return AlertDialog(
                      actionsAlignment: MainAxisAlignment.center,
                      title: Image.asset(
                        "assets/images/warning.png",
                        width: (width * 0.1).w,
                        height: (height * 0.1).h,
                      ),
                      content: Text(
                        "$nick\n신고하시겠어요?",
                        textAlign: TextAlign.center,
                      ),
                      actionsPadding:
                          EdgeInsets.only(bottom: (height * 0.03).h),
                      actions: [
                        TextButton(
                          style: TextButton.styleFrom(
                            foregroundColor: Colors.white, // 텍스트 색 바꾸기
                            backgroundColor: Colors.red, // 백그라운드로 컬러 설정
                            textStyle: TextStyle(fontSize: 16.sp),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                          ),
                          onPressed: () {
                            print(id);
                            // 토큰 얻어와야함.
                            //userreport(context, mytoken, id);
                            Navigator.of(ctx).pop();
                            snackbar.showSnackBar(context, "신고 완료!", "villain");
                          },
                          child: const Text("신고하기"),
                        )
                      ],
                    );
                  });
            },
            child: Container(
              margin: const EdgeInsets.only(right: 16.0),
              // 사용자명의 첫번째 글자를 서클 아바타로 표시
              child: CircleAvatar(child: makeNick.getAvatar(nick)),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              // 사용자명을 subhead 테마로 출력
              Text(nick, style: Theme.of(context).textTheme.bodySmall),
              // 입력받은 메시지 출력
              Container(
                decoration: BoxDecoration(
                  color: Colors.black12,
                  borderRadius: BorderRadius.circular(10.0),
                ),
                margin: const EdgeInsets.only(top: 5.0),
                padding: const EdgeInsets.all(8),
                constraints: BoxConstraints(
                  minWidth: nick.length.toDouble() * 10 > 280
                      ? 280
                      : nick.length.toDouble() * 10,
                  maxWidth: 280,
                ),
                child: Text(text, softWrap: true),
              ),
            ],
          )
        ],
      ),
    );
  }
}

late Future<dynamic> userReport;

void userreport(BuildContext context, String mytoken, String userid) async {
  userReport = http.chatroom().report(mytoken, userid);

  var temp = await userReport;

  if (temp == "OK") {
    snackbar.showSnackBar(context, '접수 완료!', 'common');
  } else {
    snackbar.showSnackBar(context, '접수 실패!', 'common');
  }
}
