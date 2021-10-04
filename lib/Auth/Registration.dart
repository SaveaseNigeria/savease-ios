import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:savease/Auth/VerifiyNumber.dart';
import 'package:xml2json/xml2json.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:toast/toast.dart';
import 'package:savease/Auth/CreatePin.dart';
import 'package:savease/Auth/Login.dart';

import 'AuthWelcome.dart';


class Registration extends StatefulWidget {
  @override
  _LoginScreenState createState() => new _LoginScreenState();
}

class _LoginScreenState extends State<Registration> {
  Xml2Json xml2json = new Xml2Json();
  ProgressDialog pr;
  String _userid;
  String _password;
  String _phone;
  String _confirmpassword;

  void _back() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => AuthWelcomeScreen()));
  }

  void _openinputCode() {
    if (_password != _confirmpassword) {
      Toast.show(
          "Password does not match", context, duration: Toast.LENGTH_LONG,
          gravity: Toast.BOTTOM);
    } else {
      if (_password.isEmpty || _confirmpassword.isEmpty || _password == "" ||
          _confirmpassword == "" || _userid == "" || _userid.isEmpty) {
        Toast.show(
            "All fields must be filled ", context, duration: Toast.LENGTH_LONG,
            gravity: Toast.BOTTOM);
      } else {
       checkPhone();
      }
    }
  }

  checkPhone() async {
    pr = new ProgressDialog(context, ProgressDialogType.Normal);
    pr.setMessage("Verifying..");
    pr.show();
    String soap = '''<?xml version="1.0" encoding="utf-8"?>
<soap:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">
  <soap:Body>
    <Existphone xmlns="http://savease.ng/">
      <phone>${_phone}</phone>
    </Existphone>
  </soap:Body>
</soap:Envelope>''';

    http.Response response = await http.post(
      'http://savease.ng/webservice1.asmx?op=Existphone',
      headers: {
        "SOAPAction": "http://savease.ng/Existphone",
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
    String code = responses['soap:Envelope']['soap:Body']['ExistphoneResponse']['ExistphoneResult'];
    print(code);
    if (code == "1") {
      checkUsername();
    } else {
      pr.hide();
      Alert(
          context: context,
          title: "Failed",
          desc: "Phone number already in use..try another",
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
  checkUsername() async {
    String soap = '''<?xml version="1.0" encoding="utf-8"?>
<soap:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">
  <soap:Body>
    <ExistUname xmlns="http://savease.ng/">
      <username>${_userid}</username>
    </ExistUname>
  </soap:Body>
</soap:Envelope>''';

    http.Response response = await http.post(
      'http://savease.ng/webservice1.asmx?op=ExistUname',
      headers: {
        "SOAPAction": "http://savease.ng/ExistUname",
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
    String code = responses['soap:Envelope']['soap:Body']['ExistUnameResponse']['ExistUnameResult'];
    print(code);
    if (code == "1") {
      pr.hide();
      Map<String, String> data = new Map();
      data["userid"] = _userid;
      data["password"] = _password;
      data["phone"] = _phone;
      var route = new MaterialPageRoute(
          builder: (BuildContext context) =>
          new VerifyNumber(
            data: data,
          ));
      Navigator.of(context).push(route);

    } else {
      pr.hide();
      Alert(
          context: context,
          title: "Failed",
          desc: "Username already in use.. try another",
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

  void _forgot() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => LoginScreen()));
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
          height: MediaQuery
              .of(context)
              .size
              .height,
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
                    padding: const EdgeInsets.only(
                        left: 44.0, top: 25.0, right: 30.0),
                    child: Text("Register", style: TextStyle(fontSize: 17.0,
                        fontFamily: "sfprodisplayheavy",
                        color: Colors.black)),
                  ),
                ),


                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.only(
                        left: 44.0, top: 25.0, right: 30.0),
                    child: Theme(
                      data: Theme.of(context).copyWith(
                          splashColor: Colors.transparent),
                      child: TextField(
                        onChanged: (text) {
                          setState(() {
                            _userid = text;
                          });
                        },
                        autofocus: false,
                        style: TextStyle(fontSize: 13.0, color: Colors.black),
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Color(0xFF7E768CA5),
                          hintText: 'User ID',
                          contentPadding:
                          const EdgeInsets.only(
                              left: 14.0, bottom: 9.0, top: 8.0),
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
                    padding: const EdgeInsets.only(
                        left: 44.0, top: 20.0, right: 30.0),
                    child: Theme(
                      data: Theme.of(context).copyWith(
                          splashColor: Colors.transparent),
                      child: TextField(
                        onChanged: (text) {
                          setState(() {
                            _password = text;
                          });
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
                          const EdgeInsets.only(
                              left: 14.0, bottom: 9.0, top: 8.0),
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
                    padding: const EdgeInsets.only(
                        left: 44.0, top: 20.0, right: 30.0),
                    child: Theme(
                      data: Theme.of(context).copyWith(
                          splashColor: Colors.transparent),
                      child: TextField(
                        onChanged: (text) {
                          setState(() {
                            _confirmpassword = text;
                          });
                        },
                        keyboardType: TextInputType.text,
                        obscureText: true,
                        autofocus: false,
                        style: TextStyle(fontSize: 13.0, color: Colors.black),
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Color(0xFF7E768CA5),
                          hintText: 'Confirm Password',
                          contentPadding:
                          const EdgeInsets.only(
                              left: 14.0, bottom: 9.0, top: 8.0),
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
                    padding: const EdgeInsets.only(
                        left: 44.0, top: 20.0, right: 30.0),
                    child: Theme(
                      data: Theme.of(context).copyWith(
                          splashColor: Colors.transparent),
                      child: TextField(
                        onChanged: (text) {
                          setState(() {
                            _phone = text;
                          });
                        },
                        keyboardType: TextInputType.phone,
                        obscureText: false,
                        autofocus: false,
                        style: TextStyle(fontSize: 13.0, color: Colors.black),
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Color(0xFF7E768CA5),
                          hintText: 'Phone Number',
                          contentPadding:
                          const EdgeInsets.only(
                              left: 14.0, bottom: 9.0, top: 8.0),
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
                            },
                            textColor: Colors.white,
                            color: Color(0xffFA9928),
                            child: const Text('Next', style: TextStyle(
                                fontFamily: "sfprodisplaybold")),
                            shape: new RoundedRectangleBorder(
                                borderRadius: new BorderRadius.circular(10.0))
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
                      child: Text("Already have an account? Login Here",
                          style: TextStyle(fontSize: 10.0,
                              fontFamily: "sfprodisplaylight",
                              color: Colors.black,
                              fontWeight: FontWeight.bold)),
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
