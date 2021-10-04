import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:xml2json/xml2json.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:toast/toast.dart';
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
  String _confirmpassword;

  void _back() {
    Navigator.push(context, MaterialPageRoute(builder: (context) => AuthWelcomeScreen()));
  }

  void _openinputCode() async {

    if(_password != _confirmpassword ){
      Toast.show("Password does not match", context, duration: Toast.LENGTH_LONG, gravity:  Toast.BOTTOM);

    }else {
      if (_password.isEmpty || _confirmpassword.isEmpty || _password == "" ||
          _confirmpassword == "" || _userid == "" || _userid.isEmpty) {
        Toast.show("All fields must be filled ", context, duration: Toast.LENGTH_LONG, gravity:  Toast.BOTTOM);
      } else {

        pr = new ProgressDialog(context, ProgressDialogType.Normal);
        pr.setMessage("Changing..please wait");
        pr.show();
        String soap = '''<?xml version="1.0" encoding="utf-8"?>
<soap:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">
  <soap:Body>
    <changepass xmlns="http://savease.ng/">
      <in_username>${_userid}</in_username>
      <in_oldpwd>${_password}</in_oldpwd>
      <in_newpwd>${_confirmpassword}</in_newpwd>
    </changepass>
  </soap:Body>
</soap:Envelope>''';

        http.Response response = await http.post(
          'http://savease.ng/webservice1.asmx?op=changepass',
          headers: {
            "SOAPAction": "http://savease.ng/changepass",
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
        String code = responses['soap:Envelope']['soap:Body']['changepassResponse']['changepassResult'];

        if (code.contains("1")) {
          pr.hide();

        }else {
          Toast.show("Changing of password failed, try again", context, duration: Toast.LENGTH_LONG, gravity:  Toast.BOTTOM);
          pr.hide();
        }

      }
    }


  }

  void _forgot() {
    Navigator.push(context, MaterialPageRoute(builder: (context) => LoginScreen()));
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
                    child: Text("Change Password", style: TextStyle(fontSize: 17.0,fontFamily: "sfprodisplayheavy",color: Colors.black)),
                  ),
                ),

                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 44.0, top: 10.0,right: 30.0),
                    child: Text("To change your password, input your old and new password in the text field below and click on the button. ", style: TextStyle(fontSize: 14.0,fontFamily: "sfprodisplaylight",color: Colors.black)),
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
                            _userid = text;
                          });

                        },
                        autofocus: false,
                        style: TextStyle(fontSize: 13.0, color: Colors.black),
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Color(0xFF7E768CA5),
                          hintText: 'User Id',
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
                          hintText: 'Old Password',
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
                          hintText: 'New Password',
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
                              _openinputCode();
                            },
                            textColor: Colors.white,
                            color: Color(0xffFA9928),
                            child: const Text('Change',style: TextStyle(fontFamily: "sfprodisplaybold")),
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
                      child: Text("Already have an account? Login Here", style: TextStyle(fontSize: 10.0,fontFamily: "sfprodisplaylight",color: Colors.black,fontWeight: FontWeight.bold)),
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