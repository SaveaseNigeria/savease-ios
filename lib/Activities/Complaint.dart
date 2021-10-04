import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mailer/flutter_mailer.dart';
import 'package:provider/provider.dart';
import 'package:savease/Utils/ZoomScaffoldActivites.dart';
import 'package:savease/Utils/menu_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';

class Complaint extends StatefulWidget {
  @override
  _HoomeState createState() => new _HoomeState();
}

class _HoomeState extends State<Complaint> with TickerProviderStateMixin {
  MenuController menuController;
  String accountName = "";
  String title = "";
  String message = "";

  void getData() async {
    final prefs = await SharedPreferences.getInstance();

    String fname = prefs.getString('fname') ?? '';
    String lname = prefs.getString('lname') ?? '';

    if (fname != null || fname != "") {
      setState(() {
        accountName = fname + " " + lname;
      });
    } else {
      accountName = "";
    }
  }

  sendEmail() async {

    if(message.isEmpty || message == "" || title.isEmpty || title == ""){
      Toast.show("Please fill required field to continue", context, duration: Toast.LENGTH_LONG, gravity:  Toast.BOTTOM);

    }else{

      final MailOptions mailOptions = MailOptions(
        body: '${message}',
        subject: '${title}',
        recipients: ['compliant@savease.ng'],
        isHTML: true,
        ccRecipients: ['escalate@savease.ng'],

      );

      await FlutterMailer.send(mailOptions);
  }
  }

  @override
  void initState() {
    getData();
    super.initState();
    menuController = new MenuController(
      vsync: this,
    )..addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    menuController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset : false,
        body: GestureDetector(
          onTap: () {
            FocusScope.of(context).requestFocus(new FocusNode());
          },
          child: ChangeNotifierProvider(
      builder: (context) => menuController,
      child: ZoomScaffoldActivities(
          menuScreen: MenuScreen(),
          contentScreen: Layout(
              contentBuilder: (cc) => Stack(
                    children: <Widget>[
                      Column(
                        children: <Widget>[
                          Container(
                            child: Container(
                              color: Color(0xff212435),
                              width: MediaQuery.of(context).size.width,
                              height: 50.0,
                              child: Center(
                                  child: Text(
                                "Complaint",
                                style: new TextStyle(
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.bold,
                                    fontStyle: FontStyle.normal,
                                    color: Colors.white),
                                textAlign: TextAlign.center,
                              )),
                            ),
                          ),
                          Expanded(
                            child: SingleChildScrollView(
                              physics: AlwaysScrollableScrollPhysics(),
                              child: Container(
                                color: Colors.white,
                                height: MediaQuery.of(context).size.height,
                                width: MediaQuery.of(context).size.width,
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Column(
                                    mainAxisSize: MainAxisSize.max,
                                    children: <Widget>[
                                      Flexible(
                                        child: SingleChildScrollView(
                                          physics:
                                              AlwaysScrollableScrollPhysics(),
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                top: 20, left: 25, right: 25),
                                            child: Text(
                                              "Do you have any complain you would like us to resolve with you? Kindly provide your compliant information in the field provided below.",
                                              style: new TextStyle(
                                                fontSize: 13.0,
                                                fontWeight: FontWeight.bold,
                                                fontFamily: "sfprodisplaylight",
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Flexible(
                                        child: SingleChildScrollView(
                                          physics:
                                              AlwaysScrollableScrollPhysics(),
                                          child: Align(
                                            alignment: Alignment.centerLeft,
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 15, left: 25, right: 25),
                                              child: Text(
                                                "Title",
                                                style: new TextStyle(
                                                  fontSize: 13.0,
                                                  fontWeight: FontWeight.bold,
                                                  fontFamily: "sfprodisplayheavy",
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            top: 10, left: 25, right: 25),
                                        child: TextField(
                                          keyboardType: TextInputType.text,
                                          onChanged: (text){
                                            setState(() {
                                              title = text;
                                            });
                                          },
                                          decoration: InputDecoration(
                                            hintText: "Enter Title",
                                          ),
                                        ),
                                      ),
                                      Flexible(
                                        child: SingleChildScrollView(
                                          physics:
                                              AlwaysScrollableScrollPhysics(),
                                          child: Align(
                                            alignment: Alignment.centerLeft,
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 25, left: 25, right: 25),
                                              child: Text(
                                                "Feedback",
                                                style: new TextStyle(
                                                  fontSize: 13.0,
                                                  fontWeight: FontWeight.bold,
                                                  fontFamily: "sfprodisplayheavy",
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Align(
                                        alignment: Alignment.centerLeft,
                                        child: SizedBox(
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                left: 25.0,
                                                top: 25.0,
                                                right: 25.0),
                                            child: Theme(
                                              data: Theme.of(context).copyWith(
                                                  splashColor:
                                                      Colors.transparent),
                                              child: TextField(
                                                keyboardType:
                                                    TextInputType.multiline,
                                                maxLines: 3,
                                                onChanged: (text) {
                                                  setState(() {
                                                      message = text;
                                                  });
                                                },
                                                autofocus: false,
                                                style: TextStyle(
                                                    fontSize: 13.0,
                                                    color: Colors.black),
                                                decoration: InputDecoration(
                                                  filled: true,
                                                  fillColor: Color(0xFF7E768CA5),
                                                  hintText: 'Enter Message',
                                                  contentPadding:
                                                      const EdgeInsets.only(
                                                          left: 10.0,
                                                          bottom: 25.0,
                                                          top: 25.0,
                                                          right: 10),
                                                  focusedBorder:
                                                      OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                        color:
                                                            Color(0xFF7E768CA5)),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10.0),
                                                  ),
                                                  enabledBorder:
                                                      UnderlineInputBorder(
                                                    borderSide: BorderSide(
                                                        color:
                                                            Color(0xFF7E768CA5)),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10.0),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Align(
                                        alignment: Alignment.center,
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                              left: 34.0,
                                              top: 25.0,
                                              right: 30.0,
                                              bottom: 20),
                                          child: Container(
                                            width: 100.0,
                                            child: ButtonTheme(
                                              minWidth: 60.0,
                                              height: 40.0,
                                              child: RaisedButton(
                                                  onPressed: () {
                                                    sendEmail();
                                                  },
                                                  textColor: Colors.white,
                                                  color: Color(0xffFA9928),
                                                  child: const Text('send',
                                                      style: TextStyle(fontFamily: "sfprodisplaybold")),
                                                  shape:
                                                      new RoundedRectangleBorder(
                                                          borderRadius:
                                                              new BorderRadius
                                                                      .circular(
                                                                  10.0))),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Positioned(
                        bottom: 52.0,
                        child: Align(
                          alignment: Alignment.center,
                          child: Container(
                            color: Colors.white,
                            width: MediaQuery.of(context).size.width,
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  top: 20, left: 35, right: 15),
                              child: Text(
                                "You may also contact us through the options below: \nTelephone: 09064214402, 09064215137\nEmail: compliant@savease.ng,support@savease.ng\n            care@savease.ng,enquiry@savease.ng.",
                                style: new TextStyle(
                                  fontSize: 13.0,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: "sfprodisplaylight",
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 0.0,
                        child: Container(
                            child: Container(
                          width: MediaQuery.of(context).size.width,
                          color: Color(0xff212435),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: <Widget>[
                              //your elements here
                              Align(
                                  alignment: Alignment.bottomCenter,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                        'Copyrights © 2016 All Rights Reserved. Powered by Savease Nigeria Limited, a sub-class of Savease Africa.',
                                        style: TextStyle(
                                            fontFamily: "sfprodisplaybold",
                                            fontSize: 11.0,
                                            color: Colors.white)),
                                  )),
                            ],
                          ),
                        )),
                      )
                    ],
                  )),
      ),
    ),
        ));
  }
}
