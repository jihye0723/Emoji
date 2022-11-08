import 'package:flutter/material.dart';

class ChatWindowBottom extends StatefulWidget {
  const ChatWindowBottom({Key? key}) : super(key: key);

  @override
  State<ChatWindowBottom> createState() => _ChatWindowBottomState();
}

class _ChatWindowBottomState extends State<ChatWindowBottom> {
  // 추가 메뉴 버튼에 대한 변수 및 함수 선언
  bool _visibility = false;
  var _myIcon = Icon(Icons.add);

  void _show() {
    setState(() {
      _visibility = true;
      _myIcon = Icon(Icons.close_sharp);
    });
  }
  void _hide() {
    setState(() {
      _visibility = false;
      _myIcon = Icon(Icons.add);
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


  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: BottomAppBar(
        child: SizedBox(

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

              // 채팅창 하단 고정 버튼들 (플러스 버튼, 채팅 input 창, 전송 버튼)
              Row(
                // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [

                  // 플러스 버튼
                  IconButton(
                    icon: _myIcon,
                    onPressed:() => {_visibility ? _hide() : _show()},
                  ),

                  // 채팅 input 창 + 전송 버튼
                  /*
                  * 채팅창 부분 디자인 만질 때 다시 만져야 함. 다만, 입력창 과 버튼을 묶은 건 '카카오톡'에서도 그렇게 하고 있기에 같이 묶어 봄.
                  */
                  Expanded(
                    child: Container(
                      height: 50,
                      margin: EdgeInsets.fromLTRB(0, 5, 0, 5),
                      decoration: BoxDecoration(
                        color: Color(0xffE6E6E6),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        children: [
                          Flexible(
                            child: Container(
                              padding: EdgeInsets.fromLTRB(20, 0, 0, 0),
                              child: TextField(
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                ),
                              )
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.symmetric(horizontal: 4.0),
                            child: IconButton(
                                icon: Icon(Icons.arrow_circle_up_rounded),
                                onPressed: () => {}
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
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
