import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:xml2json/xml2json.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:toast/toast.dart';
import 'package:savease/Auth/CreatePin.dart';
import 'package:savease/Auth/Login.dart';



class ChangePassword extends StatefulWidget {
  @override
  _LoginScreenState createState() => new _LoginScreenState();
}

class _LoginScreenState extends State<ChangePassword> {
  Xml2Json xml2json = new Xml2Json();
  ProgressDialog pr;
  String _userid;
  String _password;
  String _confirmpassword;
  String oldPassword;

  void _back() {
    Navigator.pop(context);
  }


  void getData() async{

    final prefs = await SharedPreferences.getInstance();
    String usernam = prefs.getString('username') ?? '';



    if(usernam != null || usernam != ""){

      setState(() {
        _userid = usernam;

      });

    }else{
      _userid = "";
    }


  }

   _openinputCode() async {

    if(_password != _confirmpassword ){
      Toast.show("Password does not match", context, duration: Toast.LENGTH_LONG, gravity:  Toast.BOTTOM);

    }else {
      if (_password.isEmpty || _confirmpassword.isEmpty || _password == "" ||
          _confirmpassword == "" || _userid == "" || _userid.isEmpty) {
        Toast.show("All fields must be filled ", context, duration: Toast.LENGTH_LONG, gravity:  Toast.BOTTOM);
      } else {
        final prefs = await SharedPreferences.getInstance();
        pr = new ProgressDialog(context, ProgressDialogType.Normal);
        pr.setMessage("Buying voucher(s)..please wait");
        pr.show();
        String soap = '''<?xml version="1.0" encoding="utf-8"?>
<soap:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">
  <soap:Body>
    <changepass xmlns="http://savease.ng/">
      <in_username>${_userid}</in_username>
      <in_oldpwd>${oldPassword}</in_oldpwd>
      <in_newpwd>${_password}</in_newpwd>
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
        int code = responses['soap:Envelope']['soap:Body']['changepassResponse']['changepassResult'];
        print(code);
        if (code == 1) {
          pr.hide();
          Alert(
              context: context,
              title: "Success",
              desc: "Password change successful",
              image: Image.asset("assets/image/smiley.png"),
              buttons: [
                DialogButton(
                  color: Color(0xff212435),
                  onPressed: () => Navigator.pop(context),
                  child: Text(
                    "Ok",
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                )
              ]
          ).show();

        } else {
          pr.hide();
          Alert(
              context: context,
              title: "Failed",
              desc: "Funding account failed",
              image: Image.asset("assets/image/sad.png"),
              buttons: [
                DialogButton(
                  color: Color(0xff212435),
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


  }


  @override
  void initState() {
    getData();
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
                child: Text("To change your password, input your old and new password in the text field below and click on the button.", style: TextStyle(fontSize: 11.0,fontFamily: "sfprodisplayheavy",color: Colors.black)),
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
                            oldPassword = text;
                          });

                        },
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
                          hintText: 'Confirm New Password',
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
                      width: 150.0,
                      child: ButtonTheme(
                        minWidth: 150.0,
                        height: 40.0,

                        child :  RaisedButton(
                            onPressed: () {
                              _openinputCode();
                            },
                            textColor: Colors.white,
                            color: Color(0xffFA9928),
                            child: const Text('Change Password',style: TextStyle(fontFamily: "sfprodisplaybold")),
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
}