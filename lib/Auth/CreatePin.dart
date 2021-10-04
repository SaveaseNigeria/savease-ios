import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pinput/pin_put/pin_put.dart';
import 'package:pinput/pin_put/pin_put_bloc.dart';
import 'package:pinput/pin_put/pin_put_state.dart';
import 'package:xml2json/xml2json.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:toast/toast.dart';
import 'package:savease/Auth/Signup.dart';
import 'package:savease/Auth/Login.dart';
import 'AuthWelcome.dart';

class CreatePin extends StatefulWidget {
  Map<String, String> data = new Map();

  CreatePin({Key key, this.data}) : super(key: key);

  @override
  _LoginScreenState createState() => new _LoginScreenState();
}

class _LoginScreenState extends State<CreatePin> {
  Xml2Json xml2json = new Xml2Json();
  ProgressDialog pr;
  String _pin;
  String _confirmpin;

  void _openinputCode() {
    if (_pin != _confirmpin) {
      Toast.show("Pin does not match", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
    } else {
      Map<String, String> data = new Map();
      data["pin"] = _pin;
      data["password"] = widget.data["password"];
      data["userid"] = widget.data["userid"];
      data["phone"] = widget.data["phone"];
      var route = new MaterialPageRoute(
          builder: (BuildContext context) => new Signup(
                data: data,
              ));
      Navigator.of(context).push(route);
    }
  }

  void _back() {
    Navigator.pop(context);
  }

  @override
  void initState() {
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
                  alignment: Alignment.center,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 50.0),
                    child: Icon(
                      Icons.lock_outline,
                      size: 40,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Align(
                      alignment: Alignment.center,
                      child: Text("Set up Pin",
                          style: TextStyle(
                              fontSize: 17.0,
                              fontFamily: "sfprodisplaylight",
                              color: Colors.black))),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10, left: 20, right: 20),
                  child: Align(
                      alignment: Alignment.center,
                      child: Text(
                        "For your security, Pin is required for every transaction made on your Savease wallet up Pin",
                        style: TextStyle(
                          fontSize: 17.0,
                          fontFamily: "sfprodisplaylight",
                          color: Colors.black,
                        ),
                        textAlign: TextAlign.center,
                      )),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 30),
                  child: Align(
                      alignment: Alignment.center,
                      child: Text("Set up Pin",
                          style: TextStyle(
                              fontSize: 17.0,
                              fontFamily: "sfprodisplayheavy",
                              color: Colors.black))),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10, left: 50, right: 50),
                  child: Align(
                    alignment: Alignment.center,
                    child: Container(
                      height: 50,
                      child: PinPut(
                        keyboardType: TextInputType.number,
                        isTextObscure: true,
                        keyboardAction: TextInputAction.done,
                        actionButtonsEnabled: false,
                        fieldsCount: 4,
                        onSubmit: (String pin) {
                          setState(() {
                            _pin = pin;
                          });
                        },
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 30),
                  child: Align(
                      alignment: Alignment.center,
                      child: Text("Re-enter Pin",
                          style: TextStyle(
                              fontSize: 17.0,
                              fontFamily: "sfprodisplayheavy",
                              color: Colors.black))),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10, left: 50, right: 50),
                  child: Align(
                    alignment: Alignment.center,
                    child: Container(
                      height: 50,
                      child: PinPut(
                        keyboardType: TextInputType.number,
                        isTextObscure: true,
                        keyboardAction: TextInputAction.done,
                        actionButtonsEnabled: false,
                        fieldsCount: 4,
                        onSubmit: (String pin) {
                          setState(() {
                            _confirmpin = pin;
                          });
                        },
                      ),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.center,
                  child: Padding(
                    padding: const EdgeInsets.only(
                        left: 44.0, top: 25.0, right: 30.0),
                    child: Container(
                      width: 70.0,
                      child: ButtonTheme(
                        minWidth: 70.0,
                        height: 40.0,
                        child: RaisedButton(
                            onPressed: () {
                              _openinputCode();
                              // Navigator.push(context, MaterialPageRoute(builder: (context) => Signup()));
                            },
                            textColor: Colors.white,
                            color: Color(0xffFA9928),
                            child: const Text('Next',
                                style:
                                    TextStyle(fontFamily: "sfprodisplaybold")),
                            shape: new RoundedRectangleBorder(
                                borderRadius: new BorderRadius.circular(10.0))),
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
}
