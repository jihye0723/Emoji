import 'package:flutter/material.dart';

const String _name = "코딩하기 싫은 호랑이";
const _color = Colors.indigo;
const String _station = "고독한 대화방";

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
class ImageChat extends StatelessWidget {
  const ImageChat({super.key, required this.one, required this.name});

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
                  });
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
    duration: const Duration(seconds: 3),
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
  //채팅창화면
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
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Row(
          children: <Widget>[
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
    );
  }

  // 메시지 전송 버튼이 클릭될 때 호출
  void _handleSubmitted(String text) {
    // 텍스트 필드의 내용 삭제
    _textController.clear();
    FocusScope.of(context).requestFocus(chatNode);
    // _isComposing을 false로 설정
    setState(() {
      _isComposing = false;
    });
    // 입력받은 텍스트를 이용해서 리스트에 추가할 메시지 생성
    ChatMessage message = ChatMessage(
      text: text,
      // animationController 항목에 애니메이션 효과 설정
      // ChatMessage은 UI를 가지는 위젯으로 새로운 message가 리스트뷰에 추가될 때
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
    // 메시지가 생성될 때마다 animationController가 생성/부여 되었으므로 모든 메시지로부터 animationController 해제
    for (ChatMessage message in _message) {
      message.animationController?.dispose();
    }
    chatNode.dispose();
    super.dispose();
  }
}

// 리스브뷰에 추가될 메시지 위젯
class ChatMessage extends StatelessWidget {
  final String text; // 출력할 메시지
  final AnimationController animationController; // 리스트뷰에 등록될 때 보여질 효과

  const ChatMessage(
      {super.key, required this.text, required this.animationController});

  @override
  Widget build(BuildContext context) {
    // 위젯에 애니메이션을 발생하기 위해 SizeTransition을 추가
    return SizeTransition(
      sizeFactor:
          // 사용할 애니메이션 효과 설정
          CurvedAnimation(parent: animationController!, curve: Curves.easeOut),
      axisAlignment: 0.0,
      child: Message(context, _name, text),
    );
  }
}

// 내채팅 니채팅 확인, type은 내채팅인지 확인하기 위해만들어둠, 추후에 작업이 필요 현재는 단순 아이디 비교
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
