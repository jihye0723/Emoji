import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:tcp_socket_connection/tcp_socket_connection.dart';
import 'data/Transfer.pb.dart';

Transfer testMethod() {
  Transfer test1 = Transfer();

  test1.type = "안녕";
  test1.content = "오오옹오ㅗ옹";
  test1.sendAt = "hihi";

  return test1;
}

void main() {
  runApp(tcpchat());
}

class tcpchat extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({super.key, required this.title});
  final String title;
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  //Instantiating the class with the Ip and the PortNumber
  TcpSocketConnection socketConnection =
      TcpSocketConnection("172.21.240.1", 7000);
  final TextEditingController _controller = TextEditingController();

  String message = testMethod().toBuilder().toString();

  @override
  void initState() {
    super.initState();
    startConnection();
    print("hi");
  }

  @override
  void dispose() {
    socketConnection.disconnect();
    super.dispose();
  }

  //receiving and sending back a custom message
  void messageReceived(String msg) {
    setState(() {
      //message = msg;
    });
  }

  //starting the connection and listening to the socket asynchronously
  void startConnection() async {
    socketConnection.enableConsolePrint(
        true); //use this to see in the console what's happening
    if (await socketConnection.canConnect(5000, attempts: 3)) {
      //check if it's possible to connect to the endpoint
      await socketConnection.connect(5000, messageReceived, attempts: 3);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            TextButton(
                onPressed: () {
                  socketConnection.disconnect();
                },
                child: const Text("서버아웃!")),
            Form(
              child: TextFormField(
                controller: _controller,
                decoration: InputDecoration(labelText: 'Send a message'),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _sendMessage,
        tooltip: 'Send message',
        child: Icon(Icons.send),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  void _sendMessage() {
    if (_controller.text.isNotEmpty) {
      socketConnection.sendMessage(message);
      //print(message);
    }
  }
}
