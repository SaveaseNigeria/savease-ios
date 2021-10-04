import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:xml2json/xml2json.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:toast/toast.dart';


class ForgotPassword extends StatefulWidget {
  @override
  _VerifycreenState createState() => new _VerifycreenState();
}

class _VerifycreenState extends State<ForgotPassword> {
  Xml2Json xml2json = new Xml2Json();
  ProgressDialog pr;
  String _pin;


  void _back() {
    Navigator.pop(context);
  }
  @override
  void initState() {
    super.initState();

  }

  getlogin() async {
    if(_pin.isEmpty ||_pin == "" ){
      Toast.show("Please enter a valid email to reset password", context, duration: Toast.LENGTH_LONG, gravity:  Toast.BOTTOM);
    }else {
      pr = new ProgressDialog(context, ProgressDialogType.Normal);
      pr.setMessage("Resetting..please wait");
      pr.show();
      String soap = '''<?xml version="1.0" encoding="utf-8"?>
<soap:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">
  <soap:Body>
    <resetPassword xmlns="http://savease.ng/">
      <in_email>${_pin}</in_email>
    </resetPassword>
  </soap:Body>
</soap:Envelope>''';

      http.Response response = await http.post(
        'http://savease.ng/webservice1.asmx?op=resetPassword',
        headers: {
          "SOAPAction": "http://savease.ng/resetPassword",
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
      String code = responses['soap:Envelope']['soap:Body']['resetPasswordResponse']['resetPasswordResult'];
      print(code);
      pr.hide();

      Alert(
          context: context,
          title: "Reset Password",
          desc: code,
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
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
                  child: Text("Forgot Password ", style: TextStyle(fontSize: 17.0,fontFamily: "sfprodisplayheavy",color: Colors.black)),
                ),
              ),



              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.only(left: 44.0, top: 10.0,right: 30.0),
                  child: Text("Do not worry! Kindly type in your registered email address in the field below, and we will send you a link to reset and change your password. ", style: TextStyle(fontSize: 14.0,fontFamily: "sfprodisplaylight",color: Colors.black)),
                ),
              ),

              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.only(left: 44.0, top: 25.0,right: 30.0),
                  child: Theme(
                    data: Theme.of(context).copyWith(splashColor: Colors.transparent),
                    child: TextField(
                      keyboardType: TextInputType.emailAddress,
                      onChanged: (text) {
                        _pin = text;
                      },
                      autofocus: false,
                      style: TextStyle(fontSize: 13.0, color: Colors.black),
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Color(0xFF7E768CA5),
                        hintText: 'Enter Email Address',
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
                    width: 120.0,
                    child: ButtonTheme(
                      minWidth: 120.0,
                      height: 40.0,

                      child :  RaisedButton(
                          onPressed: () {
                            getlogin();
                            // Navigator.push(context, MaterialPageRoute(builder: (context) => LoginScreen()));
                          },
                          textColor: Colors.white,
                          color: Color(0xffFA9928),
                          child: const Text('Reset password',style: TextStyle(fontFamily: "sfprodisplaybold",fontSize: 11.0)),
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
    );
  }
}