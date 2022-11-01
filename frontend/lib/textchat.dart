import 'dart:typed_data';
import 'dart:io';
import 'package:flutter/material.dart';
import 'data/Transfer.pb.dart';
import 'data/station.dart' as stationData;

// 273,274 ip,포트 설정가능

// 기본틀 238에서 나머지 정보들 다 가져오기
// 채팅 스크린   528 init에서 ip,port 가져오기

//열차번호로 몇호선인지 알아내기

var _color;
String ip = "";
int port = 0;
String text = "";

// 유저정보.
String userId = "";
String mynickName = "";

//목적지 설정을 위한 데이터
List<String> rain = [];

//테스트용..
List<int> test = [
  10,
  3,
  109,
  115,
  103,
  18,
  4,
  116,
  101,
  115,
  116,
  26,
  10,
  103,
  107,
  115,
  119,
  111,
  116,
  109,
  100,
  57,
  54,
  34,
  29,
  236,
  182,
  156,
  234,
  183,
  188,
  237,
  149,
  152,
  234,
  184,
  176,
  32,
  236,
  139,
  171,
  236,
  157,
  128,
  32,
  237,
  152,
  184,
  235,
  158,
  145,
  236,
  157,
  180,
  42,
  19,
  235,
  132,
  136,
  235,
  138,
  148,
  32,
  235,
  136,
  132,
  234,
  181,
  172,
  236,
  157,
  184,
  234,
  176,
  128
];

/* protobuf 사용을 위한 메소드 설정*/
Transfer testMethod(String line, String userId, String nickName) {
  Transfer text = Transfer();

  text.type = "msg";
  text.content = line;
  text.userId = userId;
  text.nickName = nickName;
  text.sendAt = "너는 누구인가";

  return text;
}

// 기본 채팅 틀
class TextChat extends StatefulWidget {
  final String train;
  final String station;

  TextChat({super.key, required this.train, required this.station});

  //도착지 검새바를 위한 리스트
  final List<String> list = ["역삼역"];

  late String _info = "";
  late String _destination = "역삼역";

  @override
  State<TextChat> createState() => _TextChatState();
}

//.//////////////목적지선택 검색을 위한 메소드 모음
class Search extends SearchDelegate {
  late String selectedResult;

  @override
  List<Widget>? buildActions(BuildContext context) {
    // TODO: implement buildActions
    throw UnimplementedError();
  }

  @override
  Widget? buildLeading(BuildContext context) {
    // TODO: implement buildLeading
    throw UnimplementedError();
  }

  final List<String> listExample;
  Search(this.listExample);

  @override
  Widget buildResults(BuildContext context) {
    return Center(
      child: Text(selectedResult),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // TODO: implement buildSuggestions
    throw UnimplementedError();
  }
}

////// 채팅
class _TextChatState extends State<TextChat> {
  ////// 몇호선, 색깔 선정
  find() {
    switch (widget.train[0]) {
      case "1":
        _color = Colors.blue;
        rain = stationData.one;
        break;
      case "2":
        _color = Colors.green;
        rain = stationData.two;
        break;
      case "3":
        _color = Colors.orange;
        rain = stationData.three;
        break;
      default:
        break;
    }
  }

  //시작..
  @override
  void initState() {
    super.initState();
    widget._info = widget.station;
    find();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: _color,
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              print(mynickName);
              //showSearch(context: context, delegate: Search(widget.list));
              //Navigator.pop(context);
            },
            icon: const Icon(Icons.arrow_back_ios),
            padding: const EdgeInsets.only(left: 10)),
        centerTitle: true,
        elevation: 0,
        title: Container(
          width: width * 0.35,
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: MyStatefulWidget(text: widget._info, color: _color),
        ),
        backgroundColor: _color,
        actions: <Widget>[
          IconButton(
            onPressed: () {
              //경로선택 dialog
              showDialog(
                  context: context,
                  builder: (BuildContext ctx) {
                    return AlertDialog(
                      title: Column(
                        children: [
                          Text(
                            "목적지 선택",
                            textAlign: TextAlign.center,
                          ),
                          Image.asset(
                            "assets/images/map.png",
                            height: height * 0.1,
                          ),
                        ],
                      ),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(widget._destination),
                          TextField(),
                          // ListView.builder(
                          //     itemCount: widget.list.length,
                          //     itemBuilder: (context, index) => ListTile(
                          //           title: Text(widget.list[index]),
                          //         ))
                        ],
                      ),
                      actionsPadding: const EdgeInsets.only(bottom: 30),
                      actionsAlignment: MainAxisAlignment.center,
                      actions: [
                        TextButton(
                          style: TextButton.styleFrom(
                            foregroundColor: Colors.white, // 텍스트 색 바꾸기
                            backgroundColor: _color, // 백그라운드로 컬러 설정

                            textStyle: const TextStyle(fontSize: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                          ),
                          onPressed: () {
                            Navigator.of(ctx).pop();
                          },
                          child: const Text("선택하기"),
                        )
                      ],
                    );
                  });
            },
            icon: const Icon(Icons.pin_drop),
            padding: const EdgeInsets.only(right: 20),
          )
        ],
      ),
      body: Center(
        child: ChatScreen(),
      ),
    );
  }
}

// ////////////////////////전광판 지나가는 거
class MyStatefulWidget extends StatefulWidget {
  const MyStatefulWidget({super.key, required this.text, this.color});
  final String text;
  final color;

  @override
  State<MyStatefulWidget> createState() => _MyStatefulWidgetState();
}

class _MyStatefulWidgetState extends State<MyStatefulWidget>
    with SingleTickerProviderStateMixin {
  //채팅용 변수

  //애니메이션 용ㅎ
  late final AnimationController _controller = AnimationController(
    duration: const Duration(seconds: 2),
    vsync: this,
  )..repeat(reverse: false);
  late final Animation<Offset> _offsetAnimation = Tween<Offset>(
    begin: const Offset(-0.5, 0),
    end: const Offset(1.0, 0),
  ).animate(CurvedAnimation(
    parent: _controller,
    curve: Curves.linear,
  ));

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _offsetAnimation,
      child: Padding(
        padding: const EdgeInsets.all(6.0),
        child: Text(
          widget.text,
          style: TextStyle(color: widget.color),
        ),
      ),
    );
  }
}
/////////////////전광판 끝

/*----------------------------채팅 시작--------------------*/

class ChatScreen extends StatefulWidget {
  //final String name;
  const ChatScreen({super.key});

  @override
  ChatScreenState createState() => ChatScreenState();
}

// 화면 구성용 상태 위젯. 애니메이션 효과를 위해 TickerProviderStateMixin를 가짐
class ChatScreenState extends State<ChatScreen> with TickerProviderStateMixin {
  // 입력한 메시지를 저장하는 리스트
  final List<ChatMessage> _message = <ChatMessage>[];
  late FocusNode chatNode;

  //채팅
  late Socket socket;
  String ip = "";
  int port = 0;

  //////////////////////////tcp 서버연결부분

  void create() async {
    //print("hi");
    socket = await Socket.connect(ip, port);
    print('connected');

    // 서버에서 채팅날아오면 받기
    socket.listen((List<int> event) {
      //print(utf8.decode(event));
      Transfer testmessage = Transfer.fromBuffer(test);
      //print(testmessage);

      // 채팅을 위한것이면 채팅에 저장하기
      if (testmessage.type == "msg") {
        ChatMessage message = ChatMessage(
          text: testmessage.content,
          nickName: testmessage.nickName,
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
    });
  }

  // 텍스트필드 제어용 컨트롤러
  final TextEditingController _textController = TextEditingController();

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

  // 자리 양도 기능에서, 개최자의 자리 소개 시에 key 값을 지정함으로써 폼 내부의 TextFormField 값을 저장하고 validation 을 진행하는데 사용한다.
  final formKey = GlobalKey<FormState>();

  // 자리 양도 기능에서, 개최자의 자리 소개말 변수 선언
  String introduce = "";

  // 자리 양도 기능에서, 개최자의 자리 소개말 함수 선언
  Widget renderTextFormField({
    required FormFieldSetter onSaved,
    required FormFieldValidator validator,
  }) {
    assert(validator != null);

    return Container(
        margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
        child: (TextFormField(
          onSaved: onSaved,
          validator: validator,
          keyboardType: TextInputType.multiline,
          maxLines: 4,
          decoration: const InputDecoration(
            filled: true,
            fillColor: Color(0xfff8f8f8),
            hintText: "예) 저는 파란색 외투를 입고 있고, 빨간색 신발을 신고 있어요. 역삼역에서 내릴게요~",
            border: OutlineInputBorder(),
          ),
        )));
  }

  ////////////////////////////////채팅창 화면
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _color,
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

  //////////////////////////////////////// 채팅 입력부분
  Widget _buildTextComposer() {
    return IconTheme(
      data: IconThemeData(color: _color),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // 추가 메뉴 버튼들 (자리 양도, 빌런 제보)
          /*
          * 마우스 호버 시에 커서가 변경 되지 않는 것은 '앱'이므로 고치지 않았습니다.
          * 아이콘 이미지는 디자인 기간에 변경하는 것이 좋을 것 같습니다.
          */
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
            margin: const EdgeInsets.symmetric(horizontal: 8.0),
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
                  margin: const EdgeInsets.symmetric(horizontal: 4.0),
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

  ///////////////////////////////////// 메시지 전송 버튼이 클릭될 때 호출
  void _handleSubmitted(String text) {
    // 텍스트 필드의 내용 삭제
    _textController.clear();

    Uint8List tcpmessage = testMethod(text, userId, mynickName).writeToBuffer();
    socket.add(tcpmessage);
    //Transfer exam = Transfer.fromBuffer(tcpmessage);

    //print(tcpmessage);

    FocusScope.of(context).requestFocus(chatNode);
    // _isComposing 을 false 로 설정
    setState(() {
      _isComposing = false;
    });
    // 입력받은 텍스트를 이용해서 리스트에 추가할 메시지 생성
    ChatMessage message = ChatMessage(
      text: text,
      nickName: mynickName,
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

  ///             initState    채팅부분 포트랑,ip 가져오기
  @override
  void initState() {
    super.initState();
    setting();
    create();
    chatNode = FocusNode();
  }

  void setting() {
    ip = "172.27.160.1";
    port = 70;
    userId = "gkswotmd96";
    mynickName = "출근하기 싫은 기린";
  }

  ///             dispose
  @override
  void dispose() {
    // 메시지가 생성될 때마다 animationController 가 생성/부여 되었으므로 모든 메시지로부터 animationController 해제
    for (ChatMessage message in _message) {
      message.animationController.dispose();
    }
    chatNode.dispose();
    super.dispose();
  }

  // 각 기능을 이용하고 난 뒤에 스낵바를 띄워 안내해주는 설정 더하였습니다. (추후 개선 및 디자인 가능)
  void showSnackBar(BuildContext context, String snackBarText) {
    final snackBar = SnackBar(
      content: Text(snackBarText),
      backgroundColor: const Color(0xff32a1c8),
      behavior: SnackBarBehavior.floating,
      action: SnackBarAction(
        label: '확인',
        disabledTextColor: Colors.white,
        textColor: Colors.yellow,
        onPressed: () {
          //Do whatever you want
        },
      ),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  // 자리 양도 버튼
  Widget seatHandoverButton() {
    return GestureDetector(
      child: Container(
        padding: const EdgeInsets.fromLTRB(0, 10, 0, 5),
        child: Column(
          children: const [
            Image(
              image: AssetImage('assets/images/seat-icon.png'),
              width: 35,
              height: 35,
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
                      "assets/images/seat-icon.png",
                      width: width * 0.1,
                      height: width * 0.1,
                    ),
                    const Text('자리 양도',
                        style: TextStyle(
                            fontSize: 24, fontWeight: FontWeight.w800))
                  ],
                ),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      "자리의 위치를 간단하게 설명해주세요!",
                      textAlign: TextAlign.center,
                    ),
                    renderTextFormField(
                      onSaved: (val) {
                        setState(() {
                          introduce = val;
                        });
                      },
                      validator: (val) {
                        if (val.length < 1) {
                          return '간단한 자리 소개를 해주세요!';
                        }
                        return null;
                      },
                    ),
                  ],
                ),
                actionsPadding: EdgeInsets.only(bottom: height * 0.03),
                actions: [
                  Column(
                    children: [
                      Container(
                          margin: const EdgeInsets.fromLTRB(0, 0, 0, 10),
                          child:
                              const Text('앉아계신게 맞나요? 아닐 경우 불이익이 있을 수 있습니다.')),
                      TextButton(
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.fromLTRB(30, 0, 30, 0),
                          foregroundColor: Colors.white,
                          backgroundColor: const Color(0xff747f00),
                          // 백그라운드로 컬러 설정
                          textStyle: const TextStyle(fontSize: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                        onPressed: () {
                          Navigator.of(ctx).pop();
                          showSnackBar(context, '자리 양도를 개최하였습니다.');
                        },
                        child: const SizedBox(child: Text("시작하기")),
                      ),
                    ],
                  )
                ],
              );
            });
      },
    );
  }

  // 빌런 제보 버튼
  Widget reportVillain() {
    return GestureDetector(
      child: Container(
        padding: const EdgeInsets.fromLTRB(0, 10, 0, 5),
        child: Column(
          children: const [
            Image(
              image: AssetImage('assets/images/villain-icon.png'),
              width: 35,
              height: 35,
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
                      width: width * 0.1,
                      height: width * 0.1,
                    ),
                    const Text('빌런 제보',
                        style: TextStyle(
                            fontSize: 24, fontWeight: FontWeight.w800))
                  ],
                ),

                /*
                * 빌런이 몇 명 있는지 데이터 받아와야 한다. 일단 임의로 틀만 만들어 보았다.
                */
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Text(
                      "지금 열차에 1명의 빌런이 있습니다!",
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
                actionsPadding: EdgeInsets.only(bottom: height * 0.03),
                actions: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton(
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.fromLTRB(30, 0, 30, 0),
                          foregroundColor: Colors.white,
                          backgroundColor: const Color(0xffff5f5f),
                          textStyle: const TextStyle(fontSize: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                        onPressed: () {
                          Navigator.of(ctx).pop();
                          showSnackBar(context, '접수가 완료 되었습니다.');
                        },
                        child: const SizedBox(child: Text("😫 또 나타났어요!")),
                      ),
                      TextButton(
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.fromLTRB(30, 0, 30, 0),
                          foregroundColor: Colors.white,
                          backgroundColor: const Color(0xff5abaff),
                          textStyle: const TextStyle(fontSize: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                        onPressed: () {
                          Navigator.of(ctx).pop();
                          showSnackBar(context, '접수가 완료 되었습니다.');
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
}

// 리스트뷰에 추가될 메시지 위젯
class ChatMessage extends StatelessWidget {
  final String text; // 출력할 메시지
  final AnimationController animationController;
  final String nickName; // 리스트뷰에 등록될 때 보여질 효과

  const ChatMessage(
      {super.key,
      required this.text,
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
      child: message(context, nickName, text),
    );
  }
}

// 내채팅 니채팅 확인, type 은 내채팅인지 확인하기 위해 만들어 둠, 추후에 작업이 필요 현재는 단순 아이디 비교
Widget message(BuildContext context, String nick, String text) {
  if (nick == mynickName) {
    return
        // 리스트뷰에 추가될 컨테이너 위젯
        Container(
      margin: const EdgeInsets.symmetric(vertical: 10.0) +
          const EdgeInsets.only(right: 5.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          //사진 클릭 이벤트
          Container(
            margin: const EdgeInsets.only(right: 16.0),
            // 사용자명의 첫번째 글자를 서클 아바타로 표시
            child: CircleAvatar(child: getAvatar(mynickName)),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              // 사용자명을 subhead 테마로 출력
              Text(mynickName, style: Theme.of(context).textTheme.bodySmall),
              // 입력받은 메시지 출력
              Container(
                decoration: BoxDecoration(
                  color: Colors.black12,
                  borderRadius: BorderRadius.circular(10.0),
                ),
                margin: const EdgeInsets.only(top: 5.0),
                padding: const EdgeInsets.all(8),
                constraints: BoxConstraints(
                  minWidth: mynickName.length.toDouble() * 10 > 300
                      ? 300
                      : mynickName.length.toDouble() * 10,
                  maxWidth: 300,
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
                        width: width * 0.1,
                        height: height * 0.1,
                      ),
                      content: Text(
                        "$nick\n신고하시겠어요?",
                        textAlign: TextAlign.center,
                      ),
                      actionsPadding: EdgeInsets.only(bottom: height * 0.03),
                      actions: [
                        TextButton(
                          style: TextButton.styleFrom(
                            foregroundColor: Colors.white, // 텍스트 색 바꾸기
                            backgroundColor: Colors.red, // 백그라운드로 컬러 설정
                            textStyle: const TextStyle(fontSize: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                          ),
                          onPressed: () {
                            Navigator.of(ctx).pop();
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
              child: CircleAvatar(child: getAvatar(nick)),
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
                  minWidth: nick.length.toDouble() * 10 > 300
                      ? 300
                      : nick.length.toDouble() * 10,
                  maxWidth: 300,
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

///////// 유저 프로필사진만들기위한 것
Widget getAvatar(name) {
  String lastname =
      name[name.length - 3] + name[name.length - 2] + name[name.length - 1];
  String animal = lastname.trim();
  switch (animal) {
    case '호랑이':
      return Image.asset("assets/images/tiger.png");
    case '기린':
      return Image.asset("assets/images/giraffe.png");
    default:
      return Image.asset("assets/images/bear.png");
  }
}
