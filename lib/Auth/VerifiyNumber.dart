import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pinput/pin_put/pin_put.dart';
import 'package:pinput/pin_put/pin_put_bloc.dart';
import 'package:pinput/pin_put/pin_put_state.dart';
import 'package:savease/Auth/CreatePin.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:xml2json/xml2json.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:toast/toast.dart';
import 'package:savease/Auth/Signup.dart';
import 'package:savease/Auth/Login.dart';
import 'AuthWelcome.dart';

String smsPrivateKey = '9Pc1XtdCYg43wdJ6AlbCSCyTlLqc2voEFpl9DvmUq0zcKJTDbdE4aOYOPtzz';

class VerifyNumber extends StatefulWidget {
  Map<String, String> data = new Map();

  VerifyNumber({Key key, this.data}) : super(key: key);

  @override
  _LoginScreenState createState() => new _LoginScreenState();
}

class _LoginScreenState extends State<VerifyNumber> {
  Xml2Json xml2json = new Xml2Json();
  ProgressDialog pr;
  String _pin;

  final FirebaseAuth _auth = FirebaseAuth.instance;



  String _message = '';
  String _verificationId;


  void _verifyPhoneNumber() async {
    int min = 100000; //min and max values act as your 6 digit range
    int max = 999999;
    var randomizer = new Random();
    var rNum = min + randomizer.nextInt(max - min);

    final response =
    await http.get('https://www.bulksmsnigeria.com/api/v1/sms/create?api_token=${smsPrivateKey}&from=SAVEASE&to=${widget.data["phone"]}&body=Your Savease ID verification code is .. ${rNum}&dnd=2');

    if (response.statusCode == 200) {
      // If server returns an OK response, parse the JSON.
      if (response.body != null){
        print(response.body);
        final prefs = await SharedPreferences.getInstance();
        prefs.setString('otp', rNum.toString());


      }else{
        Toast.show("There was a trouble recieve sms alert now", context, duration: Toast.LENGTH_LONG, gravity:  Toast.BOTTOM);

      }

    } else {
      // If that response was not OK, throw an error.
      throw Exception('Failed to load post');
    }
  }


  void _openinputCode() {
      Map<String, String> data = new Map();
      data["phone"] = widget.data["phone"];
      data["password"] = widget.data["password"];
      data["userid"] = widget.data["userid"];
      var route = new MaterialPageRoute(
          builder: (BuildContext context) => new CreatePin(
            data: data,
          ));
      Navigator.of(context).push(route);

  }



  void _back() {
    Navigator.pop(context);
  }

  @override
  void initState() {
    _verifyPhoneNumber();
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
                      padding: const EdgeInsets.only(top: 50.0, left: 20.0),
                      child: Icon(
                        Icons.arrow_back_ios,
                      ),
                    ),
                  ),
                ),

                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 30.0,right: 10,left: 44),
                    child: Container(
                        width: 120.0,
                        child: Image.asset("assets/image/logo.png")),),
                ),

                Padding(
                  padding: const EdgeInsets.only(top: 40),
                  child: Align(
                      alignment: Alignment.center,
                      child: Text("Verify your phone number",
                          style: TextStyle(
                              fontSize: 18.0,
                              fontFamily: "sfprodisplayheavy",
                              color: Colors.black))),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 40, left: 20, right: 20),
                  child: Align(
                      alignment: Alignment.center,
                      child: Text(
                        "We have sent an OTP to your number",
                        style: TextStyle(
                          fontSize: 17.0,
                          fontFamily: "sfprodisplaylight",
                          color: Colors.black,
                        ),
                        textAlign: TextAlign.center,
                      )),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 60, left: 30, right: 30),
                  child: Align(
                    alignment: Alignment.center,
                    child: Container(
                      height: 50,
                      child: PinPut(
                        keyboardType: TextInputType.number,
                        isTextObscure: true,
                        keyboardAction: TextInputAction.done,
                        actionButtonsEnabled: false,
                        fieldsCount: 6,
                        onSubmit: (String pin) {
                          setState(() {
                            _pin = pin;
                            verifyPin();

                          });
                        },
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

  void _showSnackBar(String pin, BuildContext context) {
    final snackBar = SnackBar(
      duration: Duration(seconds: 5),
      content: Container(
          height: 80.0,
          child: Center(
            child: Text(
              'Pin Submitted. Value: $pin',
              style: TextStyle(fontSize: 25.0),
            ),
          )),
      backgroundColor: Colors.greenAccent,
    );
    Scaffold.of(context).showSnackBar(snackBar);
  }

   verifyPin() async {
     pr = new ProgressDialog(context, ProgressDialogType.Normal);
     pr.setMessage("Verifying number..");
     pr.show();
    final prefs = await SharedPreferences.getInstance();
    String otp = prefs.getString('otp') ?? '';

    var _duration = new Duration(seconds: 4);
    return new Timer(_duration, (){
      if(otp != null){
        if (otp == _pin){
          pr.hide();
          Toast.show("Phone number verified successfully", context, duration: Toast.LENGTH_LONG, gravity:  Toast.BOTTOM);
          _openinputCode();

        }else{
          pr.hide();
          Toast.show("Phone number verification unsuccessfully", context, duration: Toast.LENGTH_LONG, gravity:  Toast.BOTTOM);
        }
      }
    });


  }
}
