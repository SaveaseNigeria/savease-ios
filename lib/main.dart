import 'dart:async';
import 'dart:io';
import 'package:dropdown_banner/dropdown_banner.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:savease/Auth/AuthWelcome.dart';
import 'package:savease/Utils/OnboardingScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);


  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool _seen;
  var prefs;
  final navigatorKey = GlobalKey<NavigatorState>();
  FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  void checkFirstSeen() async {
    prefs = await SharedPreferences.getInstance();
    _seen = (prefs.getBool('seen') ?? false);
    print(_seen);

  }

  startTime() async {
    var _duration = new Duration(seconds: 3);
    return new Timer(_duration, (){
      if (_seen) {
        Navigator.of(context).pushReplacement(
            new MaterialPageRoute(builder: (context) => new AuthWelcomeScreen()));
      } else {
        prefs.setBool('seen', true);
        Navigator.of(context).pushReplacement(
            new MaterialPageRoute(builder: (context) => new OnboardingScreen()));
      }
    });
  }


  @override
  void initState() {
    firebaseCloudMessaging_Listeners();
    checkFirstSeen();
    startTime();
    super.initState();

  }

  void firebaseCloudMessaging_Listeners() {
    if (Platform.isIOS) iOS_Permission();

    _firebaseMessaging.getToken().then((token){
      print(token);
    });

    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        print('on message $message');
        print(message["aps"]["alert"]);
        doSomethingThenFail(message["aps"]["alert"]["body"]);
      },
      onResume: (Map<String, dynamic> message) async {
        print('on resume $message');
        print(message["aps"]["alert"]);
        doSomethingThenFail(message["aps"]["alert"]["body"]);
      },
      onLaunch: (Map<String, dynamic> message) async {
        print('on launch $message');
        print(message["aps"]["alert"]);
        doSomethingThenFail(message["aps"]["alert"]["body"]);
      },
    );

    _firebaseMessaging.subscribeToTopic("news").then((value) {
      print("subed");
    });
  }

  void iOS_Permission() {

    _firebaseMessaging.requestNotificationPermissions(
        IosNotificationSettings(sound: true, badge: true, alert: true)
    );
    _firebaseMessaging.onIosSettingsRegistered
        .listen((IosNotificationSettings settings)
    {
      print("Settings registered: $settings");
    });
  }




  @override
  Widget build(BuildContext context) {

    return DropdownBanner(
      navigatorKey: navigatorKey,
      child: Scaffold(
        body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/image/bne.png"),
              fit: BoxFit.cover,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(60.0),
            child: Center(
              child :Image.asset("assets/image/logo.png")
            ),
          ) /* add child content here */,
        ),
      ),
    );
  }

  void doSomethingThenFail(String text) {
    DropdownBanner.showBanner(
      text: text,
      color: Color(0xff212435),
      textStyle: TextStyle(color: Colors.white),
    );
  }

}
