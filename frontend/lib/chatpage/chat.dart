import 'package:flutter/material.dart';
import '../data/station.dart' as station;
// import 'additional_features.dart';

var Station = station.two;
const String _name = "코딩하기 싫은 기린";
const _color = Colors.green;
const String _station = "역삼역";

//목적지 설정은 한번하면 앱 자체에서 계속 데이터를 들고있게 하는게 좋겠음.

//유저 프로필사진
Widget getAvatar(name) {
  String lastname =
      name[name.length - 3] + name[name.length - 2] + name[name.length - 1];
  String animal = lastname.trim();
  switch (animal) {
    case '호랑이':
      return Image.asset("images/tiger.png");
    case '기린':
      return Image.asset("images/giraffe.png");
    default:
      return Image.asset("images/bear.png");
  }
}

//가장 큰 틀
class TextChat extends StatelessWidget {
  const TextChat({super.key, required this.one, required this.name});

  final int one;
  final String name;

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: _color,
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              print(name);
              Navigator.pop(context);
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
          child: const MyStatefulWidget(text: _station, color: _color),
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
                    title: Image.asset(
                      "images/map.png",
                      height: height * 0.1,
                    ),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: const [
                        Text(
                          "목적지 선택",
                          textAlign: TextAlign.center,
                        ),
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
                }
              );
            },
            icon: const Icon(Icons.pin_drop),
            padding: const EdgeInsets.only(right: 20),
          )
        ],
      ),
      body: Center(
        child: ChatScreen(name: name),
      ),
    );
  }
}

// 전광판 지나가는 거
class MyStatefulWidget extends StatefulWidget {
  const MyStatefulWidget({super.key, required this.text, this.color});
  final String text;
  final color;

  @override
  State<MyStatefulWidget> createState() => _MyStatefulWidgetState();
}

class _MyStatefulWidgetState extends State<MyStatefulWidget>
    with SingleTickerProviderStateMixin {
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

//채팅
class ChatScreen extends StatefulWidget {
  final String name;
  const ChatScreen({super.key, required this.name});

  @override
  ChatScreenState createState() => ChatScreenState();
}

// 화면 구성용 상태 위젯. 애니메이션 효과를 위해 TickerProviderStateMixin를 가짐
class ChatScreenState extends State<ChatScreen> with TickerProviderStateMixin {
  // 입력한 메시지를 저장하는 리스트
  final List<ChatMessage> _message = <ChatMessage>[];
  late FocusNode chatNode;

  // 텍스트필드 제어용 컨트롤러
  final TextEditingController _textController = TextEditingController();

  // 텍스트필드에 입력된 데이터의 존재 여부
  bool _isComposing = false;

  // 추가 기능 메뉴 버튼에 대한 변수 및 함수 선언
  bool _visibility = false;
  var _featureIcon = Icon(Icons.add);
  void _show() {
    setState(() {
      _visibility = true;
      _featureIcon = Icon(Icons.close_sharp);
    });
  }
  void _hide() {
    setState(() {
      _visibility = false;
      _featureIcon = Icon(Icons.add);
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
    assert(onSaved != null);
    assert(validator != null);

    return Container(
        margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
        child:(
            TextFormField(
              onSaved: onSaved,
              validator: validator,
              keyboardType: TextInputType.multiline,

              maxLines: 4,
              decoration: InputDecoration(
                filled: true,
                fillColor: Color(0xfff8f8f8),
                hintText: "예) 저는 파란색 외투를 입고 있고, 빨간색 신발을 신고 있어요. 역삼역에서 내릴게요~",
                border: OutlineInputBorder(),
              ),
            )
        )
    );
  }

  //채팅창 화면
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
              child: _buildTextComposer(widget.name),
            )
          ],
        ),
      ),
    );
  }

  // 채팅 입력부분
  Widget _buildTextComposer(String name) {
    return IconTheme(
      data: const IconThemeData(color: _color),
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
              decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                        color: Color.fromRGBO(0, 0, 0, 0.25),
                        blurRadius: 4,
                        offset : Offset(0, -4)
                    )
                  ]
              ),
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
                  onPressed:() => {_visibility ? _hide() : _show()},
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

  // 메시지 전송 버튼이 클릭될 때 호출
  void _handleSubmitted(String text) {
    // 텍스트 필드의 내용 삭제
    _textController.clear();
    FocusScope.of(context).requestFocus(chatNode);
    // _isComposing 을 false 로 설정
    setState(() {
      _isComposing = false;
    });
    // 입력받은 텍스트를 이용해서 리스트에 추가할 메시지 생성
    ChatMessage message = ChatMessage(
      text: text,
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
    message.animationController?.forward();
  }

  @override
  void initState() {
    super.initState();

    chatNode = FocusNode();
  }

  @override
  void dispose() {
    // 메시지가 생성될 때마다 animationController 가 생성/부여 되었으므로 모든 메시지로부터 animationController 해제
    for (ChatMessage message in _message) {
      message.animationController?.dispose();
    }
    chatNode.dispose();
    super.dispose();
  }

  // 각 기능을 이용하고 난 뒤에 스낵바를 띄워 안내해주는 설정 더하였습니다. (추후 개선 및 디자인 가능)
  void showSnackBar(BuildContext context, String snackBarText) {
    final snackBar = SnackBar(
      content: Text(snackBarText),
      backgroundColor: Color(0xff32a1c8),
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
        padding: EdgeInsets.fromLTRB(0, 10, 0, 5),
        child: Column(
          children: [
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
              double height = MediaQuery
                  .of(ctx)
                  .size
                  .height;
              double width = MediaQuery
                  .of(ctx)
                  .size
                  .width;
              return AlertDialog(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular((32.0)))
                ),
                actionsAlignment: MainAxisAlignment.center,
                // borderRadius: BorderRadius.circular(20),
                title: Column(
                  children: [
                    Container(
                      alignment: Alignment.centerRight,
                      child: IconButton(
                          onPressed: (){
                            Navigator.of(ctx).pop();
                          },
                          icon: Icon(
                              Icons.close_rounded
                          )
                      ),
                    ),

                    Image.asset(
                      "assets/images/seat-icon.png",
                      width: width * 0.1,
                      height: width * 0.1,
                    ),
                    Text('자리 양도', style: TextStyle(fontSize: 24,fontWeight: FontWeight.w800))
                  ],
                ),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
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
                        if(val.length < 1) {
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
                          margin: EdgeInsets.fromLTRB(0, 0, 0, 10),
                          child: Text('앉아계신게 맞나요? 아닐 경우 불이익이 있을 수 있습니다.')
                      ),
                      TextButton(
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.fromLTRB(30, 0, 30, 0),
                          foregroundColor: Colors.white,
                          backgroundColor: Color(0xff747f00), // 백그라운드로 컬러 설정
                          textStyle: const TextStyle(fontSize: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                        onPressed: () {
                          Navigator.of(ctx).pop();
                          showSnackBar(context, '자리 양도를 개최하였습니다.');
                        },
                        child: SizedBox(
                            child: const Text("시작하기")
                        ),
                      ),
                    ],
                  )
                ],
              );
            }
        );
      },
    );
  }

  // 빌런 제보 버튼
  Widget reportVillain() {
    return GestureDetector(
      child: Container(
        padding: EdgeInsets.fromLTRB(0, 10, 0, 5),
        child: Column(
          children: [
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
              double height = MediaQuery
                  .of(ctx)
                  .size
                  .height;
              double width = MediaQuery
                  .of(ctx)
                  .size
                  .width;
              return AlertDialog(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular((32.0)))
                ),
                actionsAlignment: MainAxisAlignment.center,
                // borderRadius: BorderRadius.circular(20),
                title: Column(
                  children: [
                    Container(
                      alignment: Alignment.centerRight,
                      child: IconButton(
                          onPressed: (){
                            Navigator.of(ctx).pop();
                          },
                          icon: Icon(
                              Icons.close_rounded
                          )
                      ),
                    ),

                    Image.asset(
                      "assets/images/villain-icon.png",
                      width: width * 0.1,
                      height: width * 0.1,
                    ),
                    Text('빌런 제보', style: TextStyle(fontSize: 24,fontWeight: FontWeight.w800))
                  ],
                ),

                /*
                * 빌런이 몇 명 있는지 데이터 받아와야 한다. 일단 임의로 틀만 만들어 보았다.
                */
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
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
                          padding: EdgeInsets.fromLTRB(30, 0, 30, 0),
                          foregroundColor: Colors.white,
                          backgroundColor: Color(0xffff5f5f),
                          textStyle: const TextStyle(fontSize: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                        onPressed: () {
                          Navigator.of(ctx).pop();
                          showSnackBar(context, '접수가 완료 되었습니다.');
                        },
                        child: SizedBox(
                            child: const Text("😫 또 나타났어요!")
                        ),
                      ),
                      TextButton(
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.fromLTRB(30, 0, 30, 0),
                          foregroundColor: Colors.white,
                          backgroundColor: Color(0xff5abaff),
                          textStyle: const TextStyle(fontSize: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                        onPressed: () {
                          Navigator.of(ctx).pop();
                          showSnackBar(context, '접수가 완료 되었습니다.');
                        },
                        child: SizedBox(
                            child: const Text("😄 사라졌어요!")
                        ),
                      ),
                    ],
                  )
                ],
              );
            }
        );
      },
    );
  }

}

// 리스트뷰에 추가될 메시지 위젯
class ChatMessage extends StatelessWidget {
  final String text; // 출력할 메시지
  final AnimationController animationController; // 리스트뷰에 등록될 때 보여질 효과

  const ChatMessage(
      {super.key, required this.text, required this.animationController});

  @override
  Widget build(BuildContext context) {
    // 위젯에 애니메이션을 발생하기 위해 SizeTransition 을 추가
    return SizeTransition(
      sizeFactor:
          // 사용할 애니메이션 효과 설정
          CurvedAnimation(parent: animationController!, curve: Curves.easeOut),
      axisAlignment: 0.0,
      child: Message(context, _name, text),
    );
  }
}

// 내채팅 니채팅 확인, type 은 내채팅인지 확인하기 위해 만들어 둠, 추후에 작업이 필요 현재는 단순 아이디 비교
Widget Message(BuildContext context, String type, String text) {
  if (type == "코딩하기 싫은 호랑이") {
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
            child: CircleAvatar(child: getAvatar(_name)),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              // 사용자명을 subhead 테마로 출력
              Text(_name, style: Theme.of(context).textTheme.bodySmall),
              // 입력받은 메시지 출력
              Container(
                decoration: BoxDecoration(
                  color: Colors.black12,
                  borderRadius: BorderRadius.circular(10.0),
                ),
                margin: const EdgeInsets.only(top: 5.0),
                padding: const EdgeInsets.all(8),
                constraints: BoxConstraints(
                  minWidth: _name.length.toDouble() * 10 > 300
                      ? 300
                      : _name.length.toDouble() * 10,
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
              print(type);
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
                        "images/warning.png",
                        width: width * 0.1,
                        height: height * 0.1,
                      ),
                      content: const Text(
                        "$_name\n신고하시겠어요?",
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
              child: CircleAvatar(child: getAvatar(_name)),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              // 사용자명을 subhead 테마로 출력
              Text(_name, style: Theme.of(context).textTheme.bodySmall),
              // 입력받은 메시지 출력
              Container(
                decoration: BoxDecoration(
                  color: Colors.black12,
                  borderRadius: BorderRadius.circular(10.0),
                ),
                margin: const EdgeInsets.only(top: 5.0),
                padding: const EdgeInsets.all(8),
                constraints: BoxConstraints(
                  minWidth: _name.length.toDouble() * 10 > 300
                      ? 300
                      : _name.length.toDouble() * 10,
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