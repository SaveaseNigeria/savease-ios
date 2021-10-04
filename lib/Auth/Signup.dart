
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';
import 'package:xml2json/xml2json.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:http/http.dart' as http;
import 'package:savease/Auth/Login.dart';
import 'AuthWelcome.dart';

String smsPrivateKey = '9Pc1XtdCYg43wdJ6AlbCSCyTlLqc2voEFpl9DvmUq0zcKJTDbdE4aOYOPtzz';
class Signup extends StatefulWidget {

  Map<String,String> data = new Map();

  Signup({Key key, this.data}) : super(key: key);
  @override
  _LoginScreenState createState() => new _LoginScreenState();
}

class _LoginScreenState extends State<Signup> {
  Xml2Json xml2json = new Xml2Json();
  ProgressDialog pr;
  String firstname;
  String lastname;
  String email;


  void _back() {
    Navigator.pop(context);
  }

  checkEmail() async {
    pr = new ProgressDialog(context, ProgressDialogType.Normal);
    pr.setMessage("Verifying..");
    pr.show();
    String soap = '''<?xml version="1.0" encoding="utf-8"?>
<soap:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">
  <soap:Body>
    <ExistEmail xmlns="http://savease.ng/">
      <email>${email}</email>
    </ExistEmail>
  </soap:Body>
</soap:Envelope>''';

    http.Response response = await http.post(
      'http://savease.ng/webservice1.asmx?op=ExistEmail',
      headers: {
        "SOAPAction": "http://savease.ng/ExistEmail",
        "Content-Type": "text/xml;charset=UTF-8",
        "cache-control": "no-cache",
      },
      body: utf8.encode(soap),
    );
    print(response.body);
    print(response.statusCode);
    xml2json.parse(response.body);
    var json = xml2json
        .toParker(); // the only method that worked for my XML type.
    var responses = jsonDecode(json);
    String code = responses['soap:Envelope']['soap:Body']['ExistEmailResponse']['ExistEmailResult'];
    print(code);
    if (code == "1") {
      pr.hide();
      getlogin();
    } else {
      pr.hide();
      Alert(
          context: context,
          title: "Failed",
          desc: "Email already in use.. try another",
          image: Image.asset("assets/image/sad.png"),
          buttons: [
            DialogButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                "Ok",
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
            )
          ]
      ).show();
    }
  }

  getlogin() async {
    if (email.isEmpty  || firstname.isEmpty || lastname.isEmpty || email == "" || firstname == "" || lastname =="" ){
      Toast.show("Please fill all requested field to sign up", context, duration: Toast.LENGTH_LONG, gravity:  Toast.BOTTOM);
    }else {
      final prefs = await SharedPreferences.getInstance();
      pr = new ProgressDialog(context, ProgressDialogType.Normal);
      pr.setMessage("Signing up..");
      pr.show();
      String soap = '''<?xml version="1.0" encoding="utf-8"?>
<soap:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">
  <soap:Body>
    <RegisterUser xmlns="http://savease.ng/">
      <fname>${firstname}</fname>
      <lname>${lastname}</lname>
      <phone>${widget.data["phone"]}</phone>
      <email>${email}</email>
      <username>${widget.data["userid"]}</username>
      <password>${widget.data["password"]}</password>
      <transPIN>${widget.data["pin"]}</transPIN>
    </RegisterUser>
  </soap:Body>
</soap:Envelope>''';

      http.Response response = await http.post(
        'http://savease.ng/webservice1.asmx?op=RegisterUser',
        headers: {
          "SOAPAction": "http://savease.ng/RegisterUser",
          "Content-Type": "text/xml;charset=UTF-8",
          "cache-control": "no-cache",
        },
        body: utf8.encode(soap),
      );
      print(response.body);
      print(response.statusCode);
      xml2json.parse(response.body);
      var json = xml2json
          .toParker(); // the only method that worked for my XML type.
      var responses = jsonDecode(json);
      String code = responses['soap:Envelope']['soap:Body']['RegisterUserResponse']['RegisterUserResult'];
      print(code);
      if (code == "1") {
        sendSms();
        pr.hide();
        prefs.setString('username',widget.data["userid"]);
        prefs.setString('bvnstatus', "false");
        Alert(
            context: context,
            title: "Success",
            desc: "We have sent a confirmation email, verify and login again..",
            image: Image.asset("assets/image/smiley.png"),
            buttons: [
              DialogButton(
                onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => LoginScreen())),
                child: Text(
                  "Ok",
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
              )
            ]
        ).show();

      } else if (code == "2") {
        pr.hide();
        Alert(
            context: context,
            title: "Failed",
            desc: "Phone number already in use..",
            image: Image.asset("assets/image/sad.png"),
            buttons: [
              DialogButton(
                onPressed: () => Navigator.pop(context),
                child: Text(
                  "Ok",
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
              )
            ]
        ).show();
      }else {
        Alert(
            context: context,
            title: "Failed",
            desc: "Their was an error signing up..please try again",
            image: Image.asset("assets/image/sad.png"),
            buttons: [
              DialogButton(
                onPressed: () => Navigator.pop(context),
                child: Text(
                  "Ok",
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
              )
            ]
        ).show();
      }
    }

  }
  @override
  void initState() {
    print(widget.data["pin"]);
    print(widget.data["password"]);
    print(widget.data["userid"]);
    super.initState();

  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Container(
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/image/bne.png"),
              fit: BoxFit.cover,
            ),
          ),

          child: Container(
            child: Column(
              children: <Widget>[
                GestureDetector(
                  onTap: _back,
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 50.0,left: 20.0),
                      child: Icon(Icons.arrow_back_ios,),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    width: 150.0,
                    child: Padding(
                        padding: const EdgeInsets.only(left: 44.0, top: 25.0,),
                        child: Image.asset("assets/image/logo.png")
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 44.0, top: 25.0,right: 30.0),
                    child: Text("Personal Information", style: TextStyle(fontSize: 17.0,fontFamily: "sfprodisplayheavy",color: Colors.black)),
                  ),
                ),


                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 44.0, top: 25.0,right: 30.0),
                    child: Theme(
                      data: Theme.of(context).copyWith(splashColor: Colors.transparent),
                      child: TextField(
                        onChanged: (text) {
                          setState(() {
                            firstname= text;
                          });
                        },
                        autofocus: false,
                        style: TextStyle(fontSize: 13.0, color: Colors.black),
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Color(0xFF7E768CA5),
                          hintText: 'First Name',
                          contentPadding:
                          const EdgeInsets.only(left: 14.0, bottom: 9.0, top: 8.0),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Color(0xFF7E768CA5)),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Color(0xFF7E768CA5)),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 44.0, top: 25.0,right: 30.0),
                    child: Theme(
                      data: Theme.of(context).copyWith(splashColor: Colors.transparent),
                      child: TextField(
                        onChanged: (text) {
                          setState(() {
                            lastname= text;
                          });
                        },
                        autofocus: false,
                        style: TextStyle(fontSize: 13.0, color: Colors.black),
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Color(0xFF7E768CA5),
                          hintText: 'Last Name',
                          contentPadding:
                          const EdgeInsets.only(left: 14.0, bottom: 9.0, top: 8.0),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Color(0xFF7E768CA5)),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Color(0xFF7E768CA5)),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),



                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 44.0, top: 20.0,right: 30.0),
                    child: Theme(
                      data: Theme.of(context).copyWith(splashColor: Colors.transparent),
                      child: TextField(
                        onChanged: (text) {
                          setState(() {
                            email= text;
                          });
                        },
                        keyboardType: TextInputType.emailAddress,
                        autofocus: false,
                        style: TextStyle(fontSize: 13.0, color: Colors.black),
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Color(0xFF7E768CA5),
                          hintText: 'Email',
                          contentPadding:
                          const EdgeInsets.only(left: 14.0, bottom: 9.0, top: 8.0),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Color(0xFF7E768CA5)),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Color(0xFF7E768CA5)),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),



                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 44.0, top: 25.0,right: 30.0),
                    child: Container(
                      width: 80.0,
                      child: ButtonTheme(
                        minWidth: 70.0,
                        height: 40.0,

                        child :  RaisedButton(
                            onPressed: () {
                              checkEmail();
                              // Navigator.push(context, MaterialPageRoute(builder: (context) => LoginScreen()));
                            },
                            textColor: Colors.white,
                            color: Color(0xffFA9928),
                            child: const Text('Register',style: TextStyle(fontFamily: "sfprodisplaybold",fontSize: 11)),
                            shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(10.0))
                        ),
                      ),
                    ),
                  ),
                ),


              ],
            ),
          ),

        ),
      ),

    );
  }
  sendSms() async {


      final response =
    await http.get('https://www.bulksmsnigeria.com/api/v1/sms/create?api_token=${smsPrivateKey}&from=SAVEASE&to=${widget.data["phone"]}&body=Welcome to Africa Deposit Gateway. Your account has been activated and you can now make financial transactions with ease. Please do not disclose your password and PIN to anyone as Savease will at no time request for this information.&dnd=2');

    if (response.statusCode == 200) {
      // If server returns an OK response, parse the JSON.
      if (response.body != null){
        print(response.body);


      }else{
        Toast.show("There was a trouble recieve sms alert now", context, duration: Toast.LENGTH_LONG, gravity:  Toast.BOTTOM);

      }

    } else {
      // If that response was not OK, throw an error.
      throw Exception('Failed to load post');
    }
  }
}