import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

import '../data/chat.dart';
import '../data/db.dart' as dbhelper;
import '/data/Transfer.pb.dart';
import '/http/chathttp.dart' as http;
import '/utils/snackbar.dart' as snackbar;

import 'make_message.dart' as message;
import 'alarm.dart' as alarm;

/*----------------------------채팅창--------------------*/

/* protobuf 사용을 위한 메소드 설정*/
Transfer testMethod(
    String sendType, String line, String userId, String nickName, String date) {
  Transfer text = Transfer();

  text.type = sendType;
  text.content = line;
  text.userId = userId;
  text.nickName = nickName;
  text.sendAt = date;

  return text;
}

//사용자 아이디
late String myuserId;

class ChatScreen extends StatefulWidget {
  const ChatScreen(
      {super.key,
      required this.myId,
      required this.myName,
      required this.color,
      required this.room});

  final String myId;
  final String myName;
  final color;
  final String room;

  @override
  ChatScreenState createState() => ChatScreenState();
}

// 화면 구성용 상태 위젯. 애니메이션 효과를 위해 TickerProviderStateMixin를 가짐
class ChatScreenState extends State<ChatScreen> with TickerProviderStateMixin {
  // 입력한 메시지를 저장하는 리스트
  final List<ChatMessage> _message = <ChatMessage>[];
  late FocusNode chatNode;

  //TCP서버용
  late Socket socket;
  //String ip = "10.0.2.2";
  String ip = 'k7a6021.p.ssafy.io';
  int port = 0;

  //빌런 상태 확인
  late int villaincount = 0;
  //채팅방 사람수 확인
  late int peoplecount = 0;

  //자리양도 신청 리스트
  late List<String> attendlist = [];

  // http 통신용
  late Future<dynamic> seatresult;
  late Future<dynamic> portname;
  late Future<dynamic> attendseat;

  ///             initState    채팅부분 포트랑,ip 가져오기
  @override
  void initState() {
    super.initState();

    //내아이디 전역으로 사용
    myuserId = widget.myId;

    chatNode = FocusNode();

    //알아낸 주소로 입장 설정 -> 소켓까지 연결
    findroom();
  }

  void findroom() async {
    // 아이디와 열차정보로 포트주소 알아내기
    //portname = http.enterRoom(widget.myId, widget.room);

    portname = http.chatroom().getPort(widget.myId, widget.room);
    var temp = await portname;

    //받아온 포트 적용
    if (temp != null) {
      port = int.parse(temp);
      create();
    }
  }

  /*----------------------나갈 때----------------------------*/
  @override
  void dispose() {
    // 메시지가 생성될 때마다 animationController 가 생성/부여 되었으므로 모든 메시지로부터 animationController 해제
    for (ChatMessage message in _message) {
      message.animationController.dispose();
    }
    chatNode.dispose();

    //소켓 연결되어있는 상태일때만
    if (port != 0) {
      //서버에 나간다고 알려주고 나가기
      tcpsend("room-out", "", widget.myId, widget.myName);
      socket.close();
    }

    print("disconnected");
    super.dispose();
  }

  //--------------------tcp 서버연결부분------------------------------------
  ////// 서버 연결되면 들어왔다고 알려주는 메시지 전송하고, 연결이 성공적으로 되면 채팅이 가능하도록 채팅창을 막던지. 로딩창을 유지하던지 하자.
  void create() async {
    print(ip);
    print(port);

    try {
      socket = await Socket.connect(ip, port).timeout(Duration(seconds: 10));
      print('connected');

      //소켓 연결하고 들어왔다 알려주기-----------------------------------------
      //채팅방 입장할때 알려줌 - 채팅창에 뜨는 것.
      makeMessage("채팅방에 입장하셨습니다.", "alert", "Manager");
      print("connected2");
      /*
      * 입장과 동시에 villaincount 값을 초기화시켜주어야 함.
      */

      //서버에 전송
      tcpsend("room-in", "", widget.myId, widget.myName);
      print("connected3");
    } catch (e) {
      makeMessage("서버 연결에 실패하였습니다....", "alert", "Manager");
      //뒤로가기?
    }

    /*------------------------------------------------------------------*/

    // 서버에서 채팅날아오면 받기
    socket.listen((
      Uint8List data,
    ) {
      var serverdata = data.getRange(2, data.length);
      print(data);
      // print(data[1]);
      // print(data.length-2);
      // print(data.length);
      var last = data[1];
      if(data[0] == 0){
        last = data[1];
      }else {
        last = data[0]*256 + data[1];
      }


      var testdata = data.getRange(2, last+2);
      List<int> nowlist2 = testdata.toList();
      Transfer receive = Transfer.fromBuffer(nowlist2);
      print(receive);


      // List<int> nowlist = serverdata.toList();
      // Transfer receive = Transfer.fromBuffer(nowlist);

      //print(receive);

      if (receive.userId != widget.myId) {
        if (receive.type == "room-in") {
          makeMessage("${receive.nickName}님이 입장하셨습니다", "alert", "Manager");

          String str = receive.content;
          setState(() {
            peoplecount = int.parse(str.split(",")[0]);
          });
        }

        if (receive.type == "room-out") {
          makeMessage("${receive.nickName}님이 퇴장하셨습니다", "alert", "Manager");

          setState(() {
            peoplecount = peoplecount - 1;
          });
        }

        if (receive.type == "msg") {
          var chatmsg = Chat(
            userid: receive.userId,
            content: receive.content,
            datetime: receive.sendAt,
          );
          save(chatmsg);
          //showResult();
          makeMessage(receive.content, receive.nickName, receive.userId);
        }

        if (receive.type == "seat-start") {
          //자리양도 이벤트 받았을 때 띄워주기
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text("자리 양도 이벤트가 발생하였습니다"),
            duration: Duration(seconds: 5),
            backgroundColor: Color(0xff32A1C8),
            behavior: SnackBarBehavior.floating,
            action: SnackBarAction(
              label: '참가!',
              disabledTextColor: Colors.white,
              textColor: Colors.white,
              onPressed: () {
                //누르면 http통신
                attend(context, receive.userId);
              },
            ),
          ));
        }
        if (receive.type == "seat-win") {
          for (int i = 0; i < attendlist.length; i++) {
            if (attendlist.elementAt(i) == receive.userId) {
              attendlist.removeAt(i);
            }
          }
          showResult(receive.content, true);
        }
        if (receive.type == "seat-end") {
          Timer(Duration(seconds: 1), () {
            if (attendlist.isNotEmpty) {
              for (int i = 0; i < attendlist.length; i++) {
                if (attendlist.elementAt(i) == receive.userId) {
                  attendlist.removeAt(i);
                  showResult("당첨되지 않았습니다", false);
                }
              }
            }
          });
        }
        if (receive.type == "villain-on") {
          //빌런 탑승
          snackbar.showSnackBar(context, '새로운 빌런이 나타났어요!', 'villain');

          setState(() {
            villaincount = int.parse(receive.content);
          });
        }

        if (receive.type == "villain-off") {
          //빌런 하차
          snackbar.showSnackBar(context, '빌런이 사라졌어요!', 'villain');

          setState(() {
            villaincount = int.parse(receive.content);
          });
        }
      } else if (receive.userId == widget.myId) {
        if (receive.type == "room-in") {
          String str = receive.content;
          setState(() {
            peoplecount = int.parse(str.split(",")[0]);
            villaincount = int.parse(str.split(",")[1]);
          });
        }

        if (receive.type == "villain-on") {
          //빌런 탑승
          if (int.parse(receive.content) == -1) {
            snackbar.showSnackBar(
                context, "최근 빌런이 신고되었어요. 잠시후 시도해 주세요", "villain");
          } else {
            setState(() {
              villaincount = int.parse(receive.content);
            });
            snackbar.showSnackBar(context, '접수가 완료 되었습니다!', 'common');
          }
        }

        if (receive.type == "villain-off") {
          //빌런 하차
          setState(() {
            villaincount = int.parse(receive.content);
          });
        }
      }
    }, onError: (error) {
      print(error);
    }, onDone: () {
      socket.destroy();
    }, cancelOnError: false);
  }

  // 텍스트필드 제어용 컨트롤러
  final TextEditingController _textController = TextEditingController();

//자리양도 컨트롤러
  final TextEditingController _seatController = TextEditingController();

  // 텍스트필드에 입력된 데이터의 존재 여부
  bool _isComposing = false;

  // 추가 기능 메뉴 버튼에 대한 변수 및 함수 선언
  bool _visibility = false;
  var _featureIcon = const Icon(Icons.add);

  void _show() {
    setState(() {
      _visibility = true;
      _featureIcon = const Icon(Icons.close_sharp);
    });
  }

  void _hide() {
    setState(() {
      _visibility = false;
      _featureIcon = const Icon(Icons.add);
    });
  }

  //채팅 만들어주는 메소드
  void makeMessage(String myText, String myName, String id) {
    ChatMessage message = ChatMessage(
      text: myText,
      nickName: myName,
      userId: id,
      animationController: AnimationController(
        duration: const Duration(milliseconds: 700),
        vsync: this,
      ),
    );

    // 리스트에 메시지 추가
    setState(() {
      _message.insert(0, message);
    });

    // 위젯의 애니메이션 효과 발생
    message.animationController.forward();
  }

  /*------------------채팅창 화면-------------------*/

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: widget.color,
      body: Column(
        children: <Widget>[
          Container(
            height: 40,
            color: widget.color,
            padding: EdgeInsets.only(bottom: 10.h),
            //child: Text("인원 수 : $peoplecount   빌런 : $villaincount"),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset("assets/images/hi.png", width: 30.w),
                Text(
                  "   $peoplecount       ",
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.white),
                ),
                Image.asset("assets/images/devil.png", width: 30.w),
                Text("   $villaincount",
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.white)),
              ],
            ),
          ),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(30.0)),
                color: Theme.of(context).cardColor,
              ),
              child: Column(
                children: <Widget>[
                  // 리스트뷰를 Flexible로 추가.
                  Flexible(
                    // 리스트뷰 추가
                    child: ListView.builder(
                      padding: const EdgeInsets.all(8.0),
                      // 리스트뷰의 스크롤 방향을 반대로 변경. 최신 메시지가 하단에 추가됨
                      reverse: true,
                      itemCount: _message.length,
                      itemBuilder: (_, index) => _message[index],
                    ),
                  ),
                  // 구분선
                  const Divider(height: 1.0),
                  // 메시지 입력을 받은 위젯(_buildTextCompose)추가
                  Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                    ),
                    child: _buildTextComposer(),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /*-------------------------채팅 입력 textfield------------------------------*/
  Widget _buildTextComposer() {
    return IconTheme(
      data: IconThemeData(color: widget.color),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Visibility(
            visible: _visibility,
            child: Container(
              decoration: const BoxDecoration(color: Colors.white, boxShadow: [
                BoxShadow(
                    color: Color.fromRGBO(0, 0, 0, 0.25),
                    blurRadius: 4,
                    offset: Offset(0, -4))
              ]),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  // 자리 양도 버튼
                  seatHandoverButton(),
                  // 빌런 제보 버튼
                  reportVillain(),
                ],
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 8.h),
            child: Row(
              children: <Widget>[
                // 플러스 버튼
                IconButton(
                  icon: _featureIcon,
                  onPressed: () => {_visibility ? _hide() : _show()},
                ),

                // 텍스트 입력 필드
                Flexible(
                  child: TextField(
                    controller: _textController,
                    // 입력된 텍스트에 변화가 있을 때 마다
                    onChanged: (text) {
                      setState(() {
                        _isComposing = text.isNotEmpty;
                      });
                    },
                    // 키보드상에서 확인을 누를 경우. 입력값이 있을 때에만 _handleSubmitted 호출
                    onSubmitted: _isComposing ? _handleSubmitted : null,
                    // 텍스트 필드에 힌트 텍스트 추가
                    decoration:
                        const InputDecoration.collapsed(hintText: "채팅을 입력하세요"),
                    focusNode: chatNode,
                  ),
                ),
                // 전송 버튼
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 4.h),
                  // 플랫폼 종류에 따라 적당한 버튼 추가
                  child: IconButton(
                    // 아이콘 버튼에 전송 아이콘 추가
                    icon: const Icon(Icons.send),
                    // 입력된 텍스트가 존재할 경우에만 _handleSubmitted 호출
                    onPressed: _isComposing
                        ? () => _handleSubmitted(_textController.text)
                        : null,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /*----------------------전송 버튼 눌렀을때 메소드----------------------------*/

  void _handleSubmitted(String text) {
    // 텍스트 필드의 내용 삭제
    _textController.clear();
    print(text);
    //tcpsend("msg", text, widget.myId, widget.myName);
    //테스트용
    tcpsend("msg", text, widget.myId, widget.myName);

    FocusScope.of(context).requestFocus(chatNode);

    // _isComposing 을 false 로 설정
    setState(() {
      _isComposing = false;
    });

    // 입력받은 텍스트를 이용해서 리스트에 추가할 메시지 생성
    ChatMessage message = ChatMessage(
      text: text,
      nickName: widget.myName,
      userId: widget.myId,
      // animationController 항목에 애니메이션 효과 설정
      // ChatMessage 은 UI를 가지는 위젯으로 새로운 message 가 리스트뷰에 추가될 때
      // 발생할 애니메이션 효과를 위젯에 직접 부여함
      animationController: AnimationController(
        duration: const Duration(milliseconds: 700),
        vsync: this,
      ),
    );

    // 리스트에 메시지 추가
    setState(() {
      _message.insert(0, message);
    });

    // 위젯의 애니메이션 효과 발생
    message.animationController.forward();
  }

// 자리 양도 기능에서, 개최자의 자리 소개말 변수 선언
  String introduce = "";

  // 자리 양도 버튼
  Widget seatHandoverButton() {
    return GestureDetector(
      child: Container(
        padding: EdgeInsets.fromLTRB(0, 20.h, 0, 20.h),
        child: Column(
          children: [
            Image(
              image: AssetImage('assets/images/seat-icon.png'),
              width: 35.w,
              height: 35.h,
            ),
            Text('자리 양도')
          ],
        ),
      ),
      onTap: () {
        showDialog(
            context: context,
            builder: (BuildContext ctx) {
              double height = MediaQuery.of(ctx).size.height;
              double width = MediaQuery.of(ctx).size.width;
              return SingleChildScrollView(
                child: AlertDialog(
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular((32.0)))),
                  actionsAlignment: MainAxisAlignment.center,
                  // borderRadius: BorderRadius.circular(20),
                  title: Column(
                    children: [
                      Container(
                        alignment: Alignment.centerRight,
                        child: IconButton(
                            onPressed: () {
                              Navigator.of(ctx).pop();
                            },
                            icon: const Icon(Icons.close_rounded)),
                      ),
                      Image.asset(
                        "assets/images/seat-icon.png",
                        width: (width * 0.1).w,
                        height: (width * 0.1).h,
                      ),
                      Text('자리 양도',
                          style: TextStyle(
                              fontSize: 24.sp, fontWeight: FontWeight.w800))
                    ],
                  ),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        "자리의 위치를 간단하게 설명해주세요!",
                        textAlign: TextAlign.center,
                      ),
                      Padding(padding: EdgeInsets.only(top: 20.h)),
                      TextField(
                        controller: _seatController,
                        keyboardType: TextInputType.multiline,
                        maxLines: 4,
                        autofocus: true,
                        decoration: const InputDecoration(
                          filled: true,
                          fillColor: Color(0xfff8f8f8),
                          hintText:
                              "예) 저는 파란색 외투를 입고 있고, 빨간색 신발을 신고 있어요. 역삼역에서 내릴게요~",
                          border: OutlineInputBorder(),
                        ),
                      )
                    ],
                  ),
                  actionsPadding: EdgeInsets.only(bottom: (height * 0.03).h),
                  actions: [
                    Column(
                      children: [
                        Container(
                          margin: EdgeInsets.fromLTRB(0, 0, 0, 10.h),
                          child: const Text(
                            '앉아계신게 맞나요? \n아닐 경우 불이익이 있을 수 있습니다.',
                            textAlign: TextAlign.center,
                          ),
                        ),
                        TextButton(
                          style: TextButton.styleFrom(
                            padding: EdgeInsets.fromLTRB(30.w, 0, 30.w, 0),
                            foregroundColor: Colors.white,
                            backgroundColor: widget.color,
                            // 백그라운드로 컬러 설정
                            textStyle: TextStyle(fontSize: 16.sp),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                          ),
                          onPressed: () {
                            Navigator.of(ctx).pop();
                            setState(() {
                              introduce = _seatController.text;
                            });
                            print(introduce);
                            //자리양도 시작했다고 소켓 보내
                            makeseat(context, introduce);
                            snackbar.showSnackBar(
                                context, '자리 양도를 개최하였습니다.', 'common');
                          },
                          child: const SizedBox(child: Text("시작하기")),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            });
      },
    );
  }

  //자리양도 참석
  void attend(BuildContext context, String id) async {
    //리스트에 추가
    attendlist.add(id);

    attendseat = http.chatroom().attend(widget.myId, widget.myId, id);

    var temp = await attendseat;

    Timer(Duration(seconds: 2), () async {
      if (temp == "OK") snackbar.showSnackBar(context, '신청 완료!!', 'common');
    });
  }

  //자리양도 만들기
  void makeseat(BuildContext context, String text) {
    // tcp서버에 시작한다고 알려주고
    print("start");
    tcpsend("seat-start", "", widget.myId, widget.myName);
    var temp;


    //10초 딜레이후에 rest보내
    Timer(Duration(seconds: 11), () async {
      //http 통신으로 끝났다고 알려줌
      print("seat");

      seatresult = http.chatroom().finish(widget.myId, widget.myId, text);
      temp = await seatresult;

    });


    Timer(Duration(seconds: 13), () async {
      if (temp == "OK") {
        snackbar.showSnackBar(context, '자리양도가 완료되었습니다!', 'common');
      }
    });
    _seatController.clear();
  }

  //자리양도결과
  void showResult(String detail, bool result) {
    showDialog(
        context: context,
        //barrierDismissible - Dialog를 제외한 다른 화면 터치 x
        barrierDismissible: false,
        builder: (BuildContext context) {
          return SingleChildScrollView(
            child: AlertDialog(
              // RoundedRectangleBorder - Dialog 화면 모서리 둥글게 조절
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0)),
              //Dialog Main Title
              title: Column(
                children: <Widget>[
                  (result == true)
                      ? Text(
                          "당첨!",
                          style: TextStyle(fontSize: 25.sp),
                        )
                      : Text(
                          "다음기회에..",
                          style: TextStyle(fontSize: 25.sp),
                        )
                ],
              ),
              //
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  (result == true)
                      ? Container(
                          padding: EdgeInsets.only(top: 10.h, bottom: 10.h),
                          height: 300.h,
                          width: 300.w,
                          child: Image.asset("assets/images/celebrating.png"),
                        )
                      : Container(
                          padding: EdgeInsets.only(top: 10.h, bottom: 10.h),
                          height: 300.h,
                          width: 300.w,
                          child: Image.asset("assets/images/lose.png"),
                        ),
                  Padding(padding: EdgeInsets.all(10.0)),
                  Text(
                    detail,
                    style: TextStyle(
                      fontSize: 18.sp,
                    ),
                  ),
                ],
              ),
              actions: <Widget>[
                TextButton(
                  child: const Text("확인"),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          );
        });
  }

  // 빌런 제보 버튼
  Widget reportVillain() {
    return GestureDetector(
      child: Container(
        padding: EdgeInsets.fromLTRB(0, 10.h, 0, 5.h),
        child: Column(
          children: [
            Image(
              image: AssetImage('assets/images/villain-icon.png'),
              width: 35.w,
              height: 35.h,
            ),
            Text("빌런 제보")
          ],
        ),
      ),
      onTap: () {
        showDialog(
            context: context,
            builder: (BuildContext ctx) {
              double height = MediaQuery.of(ctx).size.height;
              double width = MediaQuery.of(ctx).size.width;
              return SingleChildScrollView(
                child: AlertDialog(
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular((32.0)))),
                  actionsAlignment: MainAxisAlignment.center,
                  // borderRadius: BorderRadius.circular(20),
                  title: Column(
                    children: [
                      Container(
                        alignment: Alignment.centerRight,
                        child: IconButton(
                            onPressed: () {
                              Navigator.of(ctx).pop();
                            },
                            icon: const Icon(Icons.close_rounded)),
                      ),
                      Image.asset(
                        "assets/images/villain-icon.png",
                        width: (width * 0.1).w,
                        height: (width * 0.1).h,
                      ),
                      Text('빌런 제보',
                          style: TextStyle(
                              fontSize: 24.sp, fontWeight: FontWeight.w800))
                    ],
                  ),

                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "지금 열차에 $villaincount 명의 빌런이 있습니다!",
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                  actionsPadding: EdgeInsets.only(bottom: (height * 0.03).h),
                  actions: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextButton(
                          style: TextButton.styleFrom(
                            padding: EdgeInsets.fromLTRB(30.w, 0, 30.w, 0),
                            foregroundColor: Colors.white,
                            backgroundColor: const Color(0xffff5f5f),
                            textStyle: TextStyle(fontSize: 16.sp),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                          ),
                          onPressed: () {
                            Navigator.of(ctx).pop();
                            //소켓통신
                            tcpsend(
                                "villain-on", "", widget.myId, widget.myName);
                          },
                          child: const SizedBox(child: Text("😫 나타났어요!")),
                        ),
                        TextButton(
                          style: TextButton.styleFrom(
                            padding: EdgeInsets.fromLTRB(30.w, 0, 30.w, 0),
                            foregroundColor: Colors.white,
                            backgroundColor: const Color(0xff5abaff),
                            textStyle: TextStyle(fontSize: 16.sp),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                          ),
                          onPressed: () {
                            Navigator.of(ctx).pop();
                            snackbar.showSnackBar(
                                context, '접수가 완료 되었습니다.', 'common');
                            //소켓통신
                            tcpsend(
                                "villain-off", "", widget.myId, widget.myName);
                          },
                          child: const SizedBox(child: Text("😄 사라졌어요!")),
                        ),
                      ],
                    )
                  ],
                ),
              );
            });
      },
    );
  }

  //TCP서버에 메시지 보내는 메소드
  void tcpsend(String type, String text, String id, String nick) async {
    final date =
        DateFormat('yyy-MM-dd HH:mm:ss').format(DateTime.now()).toString();

    var chatmsg = Chat(userid: id, content: text, datetime: date);
    save(chatmsg);

    Uint8List message = testMethod(type, text, id, nick, date).writeToBuffer();

    int leng = message.length;
    int msgByteLen = 2;
    var header = ByteData(msgByteLen);
    header.setUint16(0, leng);

    var sendmessage = header.buffer.asUint8List() + message;

    socket.add(sendmessage);
    //socket.add(message);
    //await socket.flush();
  }
}

// 메시지 local db 에 저장
void save(Chat chat) async {
  await dbhelper.DBHelper.insertChat(chat);
  print("메시지 저장");
  //print(await dbhelper.DBHelper.getChat());
}

/*----------------------메세지 만드는 클래스----------------------------*/
class ChatMessage extends StatelessWidget {
  final String text; // 출력할 메시지
  final AnimationController animationController;
  final String nickName; // 리스트뷰에 등록될 때 보여질 효과
  final String userId;

  const ChatMessage(
      {super.key,
      required this.text,
      required this.userId,
      required this.animationController,
      required this.nickName});

  @override
  Widget build(BuildContext context) {
    // 위젯에 애니메이션을 발생하기 위해 SizeTransition 을 추가
    return SizeTransition(
      sizeFactor:
          // 사용할 애니메이션 효과 설정
          CurvedAnimation(parent: animationController, curve: Curves.easeOut),
      axisAlignment: 0.0,
      child: (nickName == "alert")
          ? alarm.alarm(context, nickName, text)
          : message.message(context, nickName, text, userId, myuserId),
    );
  }
}
