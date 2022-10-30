import 'package:flutter/material.dart';

/*
* 아직 연동되지 않은 위젯들(양도받기 위젯, 당첨 위젯, 탈락 위젯 등)을 모아놓았습니다.
* 추후 연동할 것입니다.
*/
class WidgetsToBeLinked extends StatefulWidget {
  const WidgetsToBeLinked({Key? key}) : super(key: key);

  @override
  State<WidgetsToBeLinked> createState() => _WidgetsToBeLinkedState();
}

class _WidgetsToBeLinkedState extends State<WidgetsToBeLinked> {

  // 부모 widget 에 있는 스낵바 보여주는 함수 들고 옴.(테스트 용)
  void _showSnackBar(BuildContext context, String snackBarText) {
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
        child: Column(
            children: [
              wannaGetSeatButton(),
              winTheGameWidget(),
              loseTheGameWidget(),
              isCorrectWidget(),
            ]
        )
    );
  }

  // 자리 받기 버튼
  Widget wannaGetSeatButton() {
    return Container(
      padding: EdgeInsets.fromLTRB(0, 10, 0, 5),
      child: Container(
        padding: EdgeInsets.fromLTRB(20, 5, 20, 5),
        decoration: BoxDecoration(
          color: Color(0xffd3e5f2),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          children: [
            Text("자리 양도가 개최되었어요.\n30초간 신청이 가능합니다.\n서 계시다면 신청해볼까요?"),
            TextButton(
                style: TextButton.styleFrom(
                  backgroundColor: Color(0xfff2d9f1),
                  padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                ),
                child: Text("신청하기", style: TextStyle(color: Colors.black),),
                onPressed: () {
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
                              borderRadius: BorderRadius.all(
                                  Radius.circular((32.0)))
                          ),
                          actionsAlignment: MainAxisAlignment.center,
                          title: Column(
                            children: [
                              Container(
                                alignment: Alignment.centerRight,
                                child: IconButton(
                                    onPressed: () {
                                      Navigator.of(ctx).pop();
                                    },
                                    icon: Icon(
                                        Icons.close_rounded
                                    )
                                ),
                              ),
                              Image.asset(
                                "assets/seat-icon.png",
                                width: width * 0.1,
                                height: width * 0.1,
                              ),
                              Text("자리 받기", style: TextStyle(
                                  fontSize: 24, fontWeight: FontWeight.w800))
                            ],
                          ),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                "오늘은 앉아서 가고 싶어!",
                                textAlign: TextAlign.center,
                              ),
                              Container(
                                  width: 200,
                                  padding: EdgeInsets.fromLTRB(0, 20, 0, 20),
                                  decoration: BoxDecoration(
                                    color: Color(0xfff8f8f8),
                                  ),
                                  // 추후 변수 받아서 몇 명 참가 중인지 띄워줘야 함.
                                  child: Text(
                                      "5명 참가 중!",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(color: Colors.blueGrey)
                                  )
                              )
                            ],
                          ),
                          actionsPadding: EdgeInsets.only(bottom: height * 0.03),
                          actions: [
                            TextButton(
                              style: TextButton.styleFrom(
                                padding: EdgeInsets.fromLTRB(30, 0, 30, 0),
                                foregroundColor: Colors.white,
                                backgroundColor: Color(0xff747f00),
                                textStyle: const TextStyle(fontSize: 16),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                              ),
                              onPressed: () {
                                _showSnackBar(context, '자리 양도에 참가하였습니다.');
                              },
                              child: SizedBox(
                                child: const Text("신청하기")
                              ),
                            ),
                          ],
                        );
                      }
                  );
                }
            )
          ],
        ),
      ),
    );
  }

  // 자리 당첨 알림 버튼
  Widget winTheGameWidget() {
    return Container(
      padding: EdgeInsets.fromLTRB(0, 10, 0, 5),
      child: SizedBox(
        child: TextButton(
          style: TextButton.styleFrom(
            padding: EdgeInsets.fromLTRB(30, 0, 30, 0),
            foregroundColor: Colors.white,
            backgroundColor: Color(0xff747f00),
            textStyle: const TextStyle(fontSize: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
          ),
          onPressed: () {
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
                    borderRadius: BorderRadius.all(
                      Radius.circular((32.0)))
                  ),
                  actionsAlignment: MainAxisAlignment.center,
                  title: Column(
                    children: [
                      Container(
                        alignment: Alignment.centerRight,
                        child: IconButton(
                            onPressed: () {
                              Navigator.of(ctx).pop();
                            },
                            icon: Icon(
                                Icons.close_rounded
                            )
                        ),
                      ),
                      Text("당첨!", style: TextStyle(
                        fontSize: 24, fontWeight: FontWeight.w800
                      )
                      ),
                      Image.asset(
                        "win-the-game-icon.png",
                        width: width * 0.2,
                        height: width * 0.2,
                      ),
                    ],
                  ),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                          width: 250,
                          padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
                          decoration: BoxDecoration(
                            color: Color(0xfff8f8f8),
                          ),
                          // 추후 변수 받아서 몇 명 참가 중인지 띄워줘야 함.
                          child: Text(
                              "저는 파란색 외투를 입고 있고, 빨간색 신발을 신고 있어요. 역삼역에서 내릴게요~",
                              textAlign: TextAlign.center,
                              style: TextStyle(color: Colors.blueGrey)
                          )
                      )
                    ],
                  ),
                  actionsPadding: EdgeInsets.only(bottom: height * 0.03),
                  actions: [
                    Column(
                      children: [
                        Container(
                            margin: EdgeInsets.fromLTRB(0, 0, 0, 10),
                            child: Text("설명을 참고해 자리를 찾아가세요!")
                        ),
                        TextButton(
                          style: TextButton.styleFrom(
                            padding: EdgeInsets.fromLTRB(30, 0, 30, 0),
                            foregroundColor: Colors.white,
                            backgroundColor: Color(0xff747f00),
                            // 백그라운드로 컬러 설정
                            textStyle: const TextStyle(fontSize: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                          ),
                          onPressed: () {
                            Navigator.of(ctx).pop();
                          },
                          child: SizedBox(
                              child: const Text("확인")
                          ),
                        ),
                      ],
                    )
                  ],
                );
              }
            );
          },
          child: SizedBox(
              child: const Text("결과 보기")
          ),
        ),
      )
    );
  }

  // 자리 탈락 알림 버튼
  Widget loseTheGameWidget() {
    return Container(
        padding: EdgeInsets.fromLTRB(0, 10, 0, 5),
        child: SizedBox(
          child: TextButton(
            style: TextButton.styleFrom(
              padding: EdgeInsets.fromLTRB(30, 0, 30, 0),
              foregroundColor: Colors.white,
              backgroundColor: Color(0xff747f00),
              textStyle: const TextStyle(fontSize: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
            ),
            onPressed: () {
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
                          borderRadius: BorderRadius.all(
                              Radius.circular((32.0)))
                      ),
                      actionsAlignment: MainAxisAlignment.center,
                      title: Column(
                        children: [
                          Container(
                            alignment: Alignment.centerRight,
                            child: IconButton(
                                onPressed: () {
                                  Navigator.of(ctx).pop();
                                },
                                icon: Icon(
                                    Icons.close_rounded
                                )
                            ),
                          ),
                          Text("다음 기회에..", style: TextStyle(
                              fontSize: 24, fontWeight: FontWeight.w800
                          )
                          ),
                          Image.asset(
                            "lose-the-game-icon.png",
                            width: width * 0.2,
                            height: width * 0.2,
                          ),
                        ],
                      ),
                      actionsPadding: EdgeInsets.only(bottom: height * 0.03),
                      actions: [
                        TextButton(
                          style: TextButton.styleFrom(
                            padding: EdgeInsets.fromLTRB(30, 0, 30, 0),
                            foregroundColor: Colors.white,
                            backgroundColor: Color(0xff747f00),
                            // 백그라운드로 컬러 설정
                            textStyle: const TextStyle(fontSize: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                          ),
                          onPressed: () {
                            Navigator.of(ctx).pop();
                          },
                          child: SizedBox(
                              child: const Text("확인")
                          ),
                        ),
                      ],
                    );
                  }
              );
            },
            child: SizedBox(
                child: const Text("결과 보기")
            ),
          ),
        )
    );
  }

  // 자리가 올바르게 제공됐는지 물어보는 알림 위젯
  /*
  * 반드시 투표할 수 있게, 창이 종료되지 않도록 간단하게 방지하였음.
  */
  Widget isCorrectWidget() {
    return Container(
        padding: EdgeInsets.fromLTRB(0, 10, 0, 5),
        child: SizedBox(
          child: TextButton(
            style: TextButton.styleFrom(
              padding: EdgeInsets.fromLTRB(30, 0, 30, 0),
              foregroundColor: Colors.white,
              backgroundColor: Color(0xff747f00),
              textStyle: const TextStyle(fontSize: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
            ),
            onPressed: () {
              showDialog(
                barrierDismissible: false,
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
                        borderRadius: BorderRadius.all(
                            Radius.circular((32.0)))
                    ),
                    actionsAlignment: MainAxisAlignment.center,
                    title: Column(
                      children: [
                        Text("혹시..", style: TextStyle(
                            fontSize: 24, fontWeight: FontWeight.w800
                        )
                        ),
                        Image.asset(
                          "research-icon.png",
                          width: width * 0.2,
                          height: width * 0.2,
                        ),
                      ],
                    ),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                            width: 250,
                            padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
                            decoration: BoxDecoration(
                              color: Color(0xfff8f8f8),
                            ),
                            // 추후 변수 받아서 몇 명 참가 중인지 띄워줘야 함.
                            child: Text(
                                "양도자가 올바른 정보를 제공했나요?",
                                textAlign: TextAlign.center,
                                style: TextStyle(color: Colors.blueGrey)
                            )
                        )
                      ],
                    ),
                    actionsPadding: EdgeInsets.only(bottom: height * 0.03),
                    actions: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
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
                              _showSnackBar(context, '접수가 완료 되었습니다.');
                            },
                            child: SizedBox(
                                child: const Text("네")
                            ),
                          ),
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
                              _showSnackBar(context, '접수가 완료 되었습니다.');
                            },
                            child: SizedBox(
                                child: const Text("아니오")
                            ),
                          ),
                        ],
                      )
                    ],
                  );
                }
              );
            },
            child: SizedBox(
                child: const Text("조사")
            ),
          ),
        )
    );
  }
}
