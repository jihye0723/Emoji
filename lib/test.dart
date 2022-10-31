import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

//이름 필요
const String _name = "코딩하기 싫은 호랑이";

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

class ImagePage extends StatefulWidget {
  const ImagePage({super.key, required this.title});
  final String title;

  @override
  _ImagePageState createState() => _ImagePageState();
}

class _ImagePageState extends State<ImagePage> {
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.arrow_back_ios),
            padding: const EdgeInsets.only(left: 10)),
        centerTitle: true,
        elevation: 0,
        title: Text(widget.title),
        backgroundColor: Colors.deepOrangeAccent,
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
                            backgroundColor: Colors.indigo, // 백그라운드로 컬러 설정

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
        child: ChatScreen(name: _name),
      ),
    );
  }
}

//채팅
class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key, required this.name});
  final String name;

  @override
  ChatScreenState createState() => ChatScreenState();
}

//화면구성용 상태위젯, 애니메이션 효과
class ChatScreenState extends State<ChatScreen> with TickerProviderStateMixin {
  // 메시지 저장하는 리스트
  final List<ChatMessage> _message = <ChatMessage>[];

  // 텍스트필드에 입력된 데이터의 존재 여부
  bool _isComposing = false;

  //이미지
  final ImagePicker _picker = ImagePicker();
  XFile? _image;
  late File target;

  Future _getImage() async {
    XFile? image = await _picker.pickImage(
        source: ImageSource.gallery, maxWidth: 220, maxHeight: 220);
    if (image != null) {
      setState(() {
        _image = image!;
        _isComposing = true;
      });
    }
  }

//채팅창 화면
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.deepOrangeAccent,
      body: Container(
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(30.0)),
            color: Theme.of(context).cardColor,
          ),
          child: Column(children: <Widget>[
            Flexible(
              child: ListView.builder(
                padding: const EdgeInsets.all(8.0),
                reverse: true,
                itemCount: _message.length,
                itemBuilder: (_, index) => _message[index],
              ),
            ),
            //구분선
            const Divider(height: 1.0),
            //메세지 입력부분
            Container(
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
              ),
              child: _buildTextComposer(widget.name),
            )
          ])),
    );
  }

  // 채팅 입력부분
  Widget _buildTextComposer(String name) {
    return IconTheme(
      data: const IconThemeData(color: Colors.deepOrangeAccent),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8.0) +
            const EdgeInsets.only(top: 10, bottom: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 4.0),
              // 플랫폼 종류에 따라 적당한 버튼 추가
              child: IconButton(
                // 아이콘 버튼에 전송 아이콘 추가
                icon: const Icon(Icons.image),
                // 입력된 텍스트가 존재할 경우에만 _handleSubmitted 호출
                onPressed: _getImage,
              ),
            ),

            // 텍스트 입력 필드
            (_image == null)
                ? Container()
                : Flexible(
                    child: Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                          image: DecorationImage(
                        fit: BoxFit.cover,
                        image: FileImage(File(_image!.path)),
                        filterQuality: FilterQuality.low,
                      )),
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
                onPressed:
                    _isComposing ? () => _handleSubmitted(_image!) : null,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 메시지 전송 버튼이 클릭될 때 호출/ 이미지 전송
  void _handleSubmitted(XFile image) {
    // 텍스트 필드의 내용 삭제
    _image = XFile("");

    // _isComposing을 false로 설정
    setState(() {
      _isComposing = false;
    });
    // 입력받은 텍스트를 이용해서 리스트에 추가할 메시지 생성
    ChatMessage message = ChatMessage(
      image: image,
      // animationController 항목에 애니메이션 효과 설정
      // ChatMessage은 UI를 가지는 위젯으로 새로운 message가 리스트뷰에 추가될 때
      // 발생할 애니메이션 효과를 위젯에 직접 부여함
      animationController: AnimationController(
        duration: const Duration(milliseconds: 00),
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
  }

  @override
  void dispose() {
    // 메시지가 생성될 때마다 animationController가 생성/부여 되었으므로 모든 메시지로부터 animationController 해제
    for (ChatMessage message in _message) {
      message.animationController?.dispose();
    }
    super.dispose();
  }
}

// 리스브뷰에 추가될 메시지 위젯
class ChatMessage extends StatefulWidget {
  // 출력할 메시지
  final AnimationController animationController; // 리스트뷰에 등록될 때 보여질 효과
  final XFile image;

  const ChatMessage(
      {super.key, required this.animationController, required this.image});

  @override
  State<ChatMessage> createState() => _ChatMessageState();
}

class _ChatMessageState extends State<ChatMessage> {
  @override
  Widget build(BuildContext context) {
    // 위젯에 애니메이션을 발생하기 위해 SizeTransition을 추가
    return SizeTransition(
      sizeFactor:
          // 사용할 애니메이션 효과 설정
          CurvedAnimation(
              parent: widget.animationController!, curve: Curves.ease),
      axisAlignment: 0.0,
      child: Message(context, _name, widget.image),
    );
  }
}

// 내채팅 니채팅 확인, type은 내채팅인지 확인하기 위해만들어둠, 추후에 작업이 필요 현재는 단순 아이디 비교
Widget Message(BuildContext context, String type, XFile image) {
  if (type == "코딩하기 싫은 호랑이") {
    return
        // 리스트뷰에 추가될 컨테이너 위젯
        Container(
      margin: const EdgeInsets.symmetric(vertical: 10.0) +
          const EdgeInsets.only(right: 10.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Container(
            margin: const EdgeInsets.only(right: 16.0),
            child: CircleAvatar(child: getAvatar(_name)),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              // 사용자명을 subhead 테마로 출력
              Text(_name, style: Theme.of(context).textTheme.bodySmall),
              const Padding(padding: EdgeInsets.only(bottom: 5)),
              // 입력받은 메시지 출력
              Image(fit: BoxFit.contain, image: FileImage(File(image!.path))),
            ],
          )
        ],
      ),
    );
  } else {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10.0) +
          const EdgeInsets.only(left: 10.0),
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
              child: CircleAvatar(child: getAvatar(_name)),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              // 사용자명을 subhead 테마로 출력
              Text(_name, style: Theme.of(context).textTheme.bodySmall),
              const Padding(padding: EdgeInsets.only(bottom: 5)),

              // 서버에서 받은 주소 연결하면 될듯
              Image.network(
                'https://picsum.photos/250?image=9',
                width: MediaQuery.of(context).size.width * 0.4,
                fit: BoxFit.contain,
              ),
            ],
          )
        ],
      ),
    );
  }
}
