import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:savease/Activities/VendorHome.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:xml2json/xml2json.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:toast/toast.dart';
import 'package:savease/Auth/ForgotPasswoord.dart';
import 'package:savease/Auth/Registration.dart';
import 'package:savease/Auth/AuthWelcome.dart';
import 'package:savease/Activities/Home.dart';


class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => new _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  Xml2Json xml2json = new Xml2Json();
  ProgressDialog pr;
  String _userid;
  String _password;

  void _back() {
    Navigator.push(context, MaterialPageRoute(builder: (context) => AuthWelcomeScreen()));
  }

  void _forgot() {
    Navigator.push(context, MaterialPageRoute(builder: (context) => ForgotPassword()));
  }

  void _register() {
    Navigator.push(context, MaterialPageRoute(builder: (context) => Registration()));
  }
  @override
  void initState() {
    super.initState();

  }

  getloginType() async {
    final prefs = await SharedPreferences.getInstance();
      String soap = '''<?xml version="1.0" encoding="utf-8"?>
<soap:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">
  <soap:Body>
    <getBalance xmlns="http://savease.ng/">
      <straccountNo>${_userid}</straccountNo>
    </getBalance>
  </soap:Body>
</soap:Envelope>''';

      http.Response response = await http.post(
        'http://savease.ng/webservice1.asmx?op=getBalance',
        headers: {
          "SOAPAction": "http://savease.ng/getBalance",
          "Content-Type": "text/xml;charset=UTF-8",
          "cache-control": "no-cache",
        },
        body: utf8.encode(soap),
      );
      print(response.body);
      print(response.statusCode);
      xml2json.parse(response.body);
      var json =
      xml2json.toParker(); // the only method that worked for my XML type.
      var responses = jsonDecode(json);
      final list = responses['soap:Envelope']['soap:Body']['getBalanceResponse']
      ['getBalanceResult'];
      List code = jsonDecode(list);
      print(code[0]['balance']);
      prefs.setDouble('balance', code[0]['balance']);
      prefs.setString('fname', code[0]['fname']);
      prefs.setString('lname', code[0]['lname']);
      prefs.setString('phone', code[0]['phone']);
      prefs.setString('email', code[0]['email']);
      prefs.setString('saveaseid', code[0]['saveaseID']);
      prefs.setString('userType', code[0]['accountType'].toString());

      setState(() {

        if(code[0]['accountType'].toString() == "1"){
          Toast.show("User", context, duration: Toast.LENGTH_LONG, gravity:  Toast.BOTTOM);
          pr.hide();
          prefs.setString('username',_userid);
          Navigator.push(context, MaterialPageRoute(builder: (context) => Home()));

        }else{
          Toast.show("Vendor", context, duration: Toast.LENGTH_LONG, gravity:  Toast.BOTTOM);
          pr.hide();
          prefs.setString('username',_userid);
          Navigator.push(context, MaterialPageRoute(builder: (context) => VendorHome()));
        }

      });

  }

  getlogin() async {
    final prefs = await SharedPreferences.getInstance();
    if(_userid.isEmpty ||_userid == ""  || _password.isEmpty ||_password == ""){
      Toast.show("Please enter a value to continue", context, duration: Toast.LENGTH_LONG, gravity:  Toast.BOTTOM);
    }else {
      pr = new ProgressDialog(context, ProgressDialogType.Normal);
      pr.setMessage("Login..please wait");
      pr.show();
      String soap = '''<?xml version="1.0" encoding="utf-8"?>
<soap:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">
  <soap:Body>
    <getlogin2 xmlns="http://savease.ng/">
      <uname>${_userid}</uname>
      <pword>${_password}</pword>
    </getlogin2>
  </soap:Body>
</soap:Envelope>''';

      http.Response response = await http.post(
        'http://savease.ng/webservice1.asmx?op=getlogin2',
        headers: {
          "SOAPAction": "http://savease.ng/getlogin2",
          "Content-Type": "text/xml;charset=UTF-8",
          "Authorization": "Basic bWVzdHJlOnRvdHZz",
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
      String code = responses['soap:Envelope']['soap:Body']['getlogin2Response']['getlogin2Result'];

      if(code.contains("100")){
        pr.hide();
        Toast.show("oops something went wrong, try again", context, duration: Toast.LENGTH_LONG, gravity:  Toast.BOTTOM);

      }else  if (code.contains("1")) {
        getloginType();
      }else if(code.contains("2")){
        getloginType();
      }else{
        Toast.show("Login Failed, try again", context, duration: Toast.LENGTH_LONG, gravity:  Toast.BOTTOM);
        pr.hide();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset : false,
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
                    child: Text("We are helping millions of people ", style: TextStyle(fontSize: 17.0,fontFamily: "sfprodisplayheavy",color: Colors.black)),
                  ),
                ),

                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 44.0, ),
                    child: Text("save their money.", style: TextStyle(fontSize: 17.0,fontFamily: "sfprodisplayheavy",color: Colors.black)),
                  ),
                ),

                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 44.0, top: 10.0,right: 30.0),
                    child: Text("We have solved the banking hitch of distance, time and structure. You can now make deposit into distinctive bank accounts without the need to walk into a banking hall.  ", style: TextStyle(fontSize: 14.0,fontFamily: "sfprodisplaylight",color: Colors.black)),
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
                            _userid = text;
                        },
                        autofocus: false,
                        style: TextStyle(fontSize: 13.0, color: Colors.black),
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Color(0xFF7E768CA5),
                          hintText: 'User ID',
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
                          _password = text;
                        },
                        keyboardType: TextInputType.text,
                        obscureText: true,
                        autofocus: false,
                        style: TextStyle(fontSize: 13.0, color: Colors.black),
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Color(0xFF7E768CA5),
                          hintText: 'Password',
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
                      width: 70.0,
                      child: ButtonTheme(
                        minWidth: 70.0,
                        height: 40.0,

                        child :  RaisedButton(
                            onPressed: () {
                              getlogin();
                             // Navigator.push(context, MaterialPageRoute(builder: (context) => LoginScreen()));
                            },
                            textColor: Colors.white,
                            color: Color(0xffFA9928),
                            child: const Text('Login',style: TextStyle(fontFamily: "sfprodisplaybold")),
                            shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(10.0))
                        ),
                      ),
                    ),
                  ),
                ),

                GestureDetector(
                  onTap: _forgot,
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 44.0, top: 13.0),
                      child: Text("Forgot Password?.", style: TextStyle(fontSize: 10.0,fontFamily: "sfprodisplaylight",color: Colors.black,fontWeight: FontWeight.bold)),
                    ),
                  ),
                ),

                GestureDetector(
                  onTap: _register,
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 44.0, top: 35.0),
                      child: Text("New to Savease? Register Here", style: TextStyle(fontSize: 12.0,fontFamily: "sfprodisplaylight",color: Colors.black,fontWeight: FontWeight.bold)),
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
}