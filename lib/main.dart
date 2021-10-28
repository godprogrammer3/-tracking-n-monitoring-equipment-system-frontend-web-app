import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
  FirebaseMessaging.instance.getToken().then(print);
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo test',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool isGettingToken = false;
  String token = '';
  List<String> notiList = <String>[];
  @override
  void initState() {
    super.initState();
    this.firebaseMessage();
  }

  void firebaseMessage() {
    FirebaseMessaging.onMessage.listen((message) {
      this.appendNoti(
          'title: ${message.notification?.title}, body: ${message.notification?.body}');
    });
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      this.appendNoti(
          'title: ${message.notification?.title}, body: ${message.notification?.body}');
    });
    FirebaseMessaging.onBackgroundMessage((message) async {
      this.appendNoti(
          'title: ${message.notification?.title}, body: ${message.notification?.body}');
    });
  }

  void appendNoti(String message) {
    this.setState(() {
      this.notiList.add(message);
    });
  }

  Future<void> getFCMToken() async {
    setState(() {
      this.isGettingToken = true;
    });
    String? token = await FirebaseMessaging.instance.getToken();
    setState(() {
      this.isGettingToken = false;
    });
    if (token != null) {
      setState(() {
        this.token = token;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SelectableText('token : ${this.token}'),
            (this.isGettingToken)
                ? CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: this.getFCMToken, child: Text('get token')),
            Text('Notification'),
            Container(
              width: 500,
              height: 800,
              child: ListView.builder(
                itemCount: this.notiList.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(this.notiList[index]),
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
