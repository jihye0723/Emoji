import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

import '../models/chat.dart';
import '../models/db.dart' as dbhelper;
import '/models/Transfer.pb.dart';
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
  late Socket socket;

  //빌런 상태 확인
  late int villaincount;

  //TCP서버용
  late Future<dynamic> portname;
  String ip = "10.0.2.2";
  int port = 0;

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
    port = int.parse(temp);
    if (port == -1) {
      //중복된 사용자 에러 처리... 어찌할지
      print("error");
    } else {
      //채팅 생성
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
    if (port != -1) {
      //서버에 나간다고 알려주고 나가기
      print("hi");
      tcpsend("room-out", "나갑니다", widget.myId, widget.myName);
      socket.close();
    }

    print("disconnected");
    super.dispose();
  }

  //--------------------tcp 서버연결부분------------------------------------
  ////// 서버 연결되면 들어왔다고 알려주는 메시지 전송하고, 연결이 성공적으로 되면 채팅이 가능하도록 채팅창을 막던지. 로딩창을 유지하던지 하자.
  void create() async {
    print(port);

    try {
      socket = await Socket.connect(ip, port).timeout(Duration(seconds: 10));
      print('connected');

      //소켓 연결하고 들어왔다 알려주기-----------------------------------------
      //채팅방 입장할때 알려줌 - 채팅창에 뜨는 것.
      makeMessage("채팅방에 입장하셨습니다.", "alert", "Manager");

      //서버에 전송
      //tcpsend("room-in", "들어갑니다.", widget.myId, widget.myName);
    } catch (e) {
      makeMessage("서버 연결에 실패하였습니다....", "alert", "Manager");
      //뒤로가기?
    }

    /*------------------------------------------------------------------*/

    // 서버에서 채팅날아오면 받기
    socket.listen((Uint8List data,) {
      var serverdata = data.getRange(1, data.length);

      List<int> nowlist = serverdata.toList();
      Transfer receive = Transfer.fromBuffer(nowlist);

      if (receive.userId == widget.myId) {
        if (receive.type == "room-in") {
          
          makeMessage("${receive.nickName}님이 입장하셨습니다", "alert", "Manager");
          
          //빌런값 초기 설정
          setState(() {
            villaincount = int.parse(receive.content);
          });
        }

        if (receive.type == "room-out") {
          makeMessage("${receive.nickName}님이 퇴장하셨습니다", "alert", "Manager");
        }

        if (receive.type == "msg") {
          //showResult();
          makeMessage(receive.content, receive.nickName, receive.userId);
        }

        if (receive.type == "seat-start") {
          //자리양도 이벤트 받았을대 띄워주기
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text("자리 양도 이벤트가 발생하였습니다"),
            duration: Duration(seconds: 5),
            backgroundColor: widget.color,
            behavior: SnackBarBehavior.floating,
            action: SnackBarAction(
              label: '참가!',
              disabledTextColor: Colors.white,
              textColor: Colors.white,
              onPressed: () {

                //누르면 http통신
                print(receive.userId);

              },
            ),
          ));

          //당첨일때
          //showResult(receive.userId, receive.content);

          //당첨아닐때
          /*
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text("다음 기회에 도전하세요"),
            duration: Duration(seconds: 1),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
            action: SnackBarAction(
              label: '닫기',
              disabledTextColor: Colors.white,
              textColor: Colors.white,
              onPressed: () {
              },
            ),
          ));
          */

        }

        if (receive.type == "villain-on") {
          //빌런 탑승
          makeMessage(receive.content, receive.nickName, receive.userId);
        }

        if (receive.type == "villain-off") {
          //빌런 하차
          makeMessage(receive.content, receive.nickName, receive.userId);
        }
      }
    },
    onError: (error){print(error);},
      onDone: (){
        socket.destroy();
      },
      cancelOnError: false
    );
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
      body: Container(
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
    tcpsend("room-in", text, widget.myId, widget.myName);

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
                            backgroundColor: const Color(0xff747f00),
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
                            makeseat(introduce);
                            snackbar.showSnackBar(context, '자리 양도를 개최하였습니다.');
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

  void makeseat(String text){
    tcpsend("seat-start", text, widget.myId,
        widget.myName);
    _seatController.clear();

    //10초 딜레이후에 rest보내
    Timer(Duration( seconds: 10), () {
      //http 통신하면됨

    });
  }

  //자리양도결과
  void showResult(String id, String detail) {
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
                      Text(
                          "당첨!",
                          style: TextStyle(fontSize: 25.sp),
                        )                      
                ],
              ),
              //
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.only(top: 10.h, bottom: 10.h),
                    height: 300.h,
                    width: 300.w,
                    child: Image.asset("assets/images/celebrating.png"),
                  ),
                  Text(
                    detail,
                    style: TextStyle(fontSize: 18.sp),
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
              return AlertDialog(
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

                /*
                * 빌런이 몇 명 있는지 데이터 받아와야 한다. 일단 임의로 틀만 만들어 보았다.
                */
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
                          snackbar.showSnackBar(context, '접수가 완료 되었습니다.');
                          //소켓통신
                          // tcpsend("valian-on","등장",widget.myId,widget.myName);
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
                          snackbar.showSnackBar(context, '접수가 완료 되었습니다.');
                          //소켓통신
                          //tcpsend("valian-off","퇴장",widget.myId,widget.myName);  412341234
                        },
                        child: const SizedBox(child: Text("😄 사라졌어요!")),
                      ),
                    ],
                  )
                ],
              );
            });
      },
    );
  }

  //TCP서버에 메시지 보내는 메소드
  void tcpsend(String type, String text, String id, String nick) {
    final date =
        DateFormat('yyy-MM-dd HH:mm:ss').format(DateTime.now()).toString();

    Uint8List message = testMethod(type, text, id, nick, date).writeToBuffer();

    var chatmsg = Chat(
      id : 0,
      userid : id,
      content : text,
      datetime: date
    );

    dbhelper.DBHelper.insertChat(chatmsg);

    int leng = message.length;
    int msgByteLen = 1;
    var header = ByteData(msgByteLen);
    header.setUint8(0, leng);

    var sendmessage =
        header.buffer.asUint8List() + message.buffer.asUint8List();

    print(sendmessage.length);
    print(sendmessage);
    socket.add(sendmessage);
    socket.flush();
  }
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
