import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:keyboard_actions/keyboard_actions.dart';
import 'package:keyboard_visibility/keyboard_visibility.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:xml2json/xml2json.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:toast/toast.dart';


class VerifyScreen extends StatefulWidget {
  @override
  _VerifycreenState createState() => new _VerifycreenState();
}

class _VerifycreenState extends State<VerifyScreen> {
  Xml2Json xml2json = new Xml2Json();
  ProgressDialog pr;
  String _pin;
  OverlayEntry overlayEntry;
  FocusNode phoneNumberFocusNode = new FocusNode();

  showOverlay(BuildContext context) {
    if (overlayEntry != null) return;
    OverlayState overlayState = Overlay.of(context);
    overlayEntry = OverlayEntry(builder: (context) {
      return Positioned(
          bottom: MediaQuery.of(context).viewInsets.bottom,
          right: 0.0,
          left: 0.0,
          child: InputDoneView());
    });

    overlayState.insert(overlayEntry);
  }

  removeOverlay() {
    if (overlayEntry != null) {
      overlayEntry.remove();
      overlayEntry = null;
    }
  }

  void _back() {
    Navigator.pop(context);
  }
  @override
  void initState() {

    KeyboardVisibilityNotification().addNewListener(
      onShow: (){
        showOverlay(context);
       },
      onHide: () {
        removeOverlay();
      },
    );
    phoneNumberFocusNode.addListener(() {

      bool hasFocus = phoneNumberFocusNode.hasFocus;
      if (hasFocus)
        showOverlay(context);
      else
        removeOverlay();
    });
    super.initState();

  }

  getlogin() async {
    if(_pin.isEmpty ||_pin == ""  || _pin.length < 12 ){
      Toast.show("Please enter a valid voucher pin to verify", context, duration: Toast.LENGTH_LONG, gravity:  Toast.BOTTOM);
    }else {
      pr = new ProgressDialog(context, ProgressDialogType.Normal);
      pr.setMessage("verifying..please wait");
      pr.show();
      String soap = '''<?xml version="1.0" encoding="utf-8"?>
<soap:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">
  <soap:Body>
    <VerifyPin xmlns="http://savease.ng/">
      <inputParame>${_pin}</inputParame>
    </VerifyPin>
  </soap:Body>
</soap:Envelope>''';

      http.Response response = await http.post(
        'http://savease.ng/webservice1.asmx?op=VerifyPin',
        headers: {
          "SOAPAction": "http://savease.ng/VerifyPin",
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
      String code = responses['soap:Envelope']['soap:Body']['VerifyPinResponse']['VerifyPinResult'];
      print(code);

      if(code.contains("Invalid")){
        pr.hide();
        Alert(
          context: context,
          title: "Failed",
          desc: code,
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
      }else if(code.contains("Voucher")){
        pr.hide();
        Alert(
          context: context,
          title: "Failed",
          desc: code,
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
      }else{
        pr.hide();
        Alert(
          context: context,
          title: "Success",
          desc: code,
          image: Image.asset("assets/image/smiley.png"),
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
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/image/bne.png"),
            fit: BoxFit.cover,
          ),
        ),

        child: SingleChildScrollView(
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
                    padding:  EdgeInsets.only(left: 44.0, top: 25.0,right: 30.0,),
                    child: Text("Verify Pin ", style: TextStyle(fontSize: 17.0,fontFamily: "sfprodisplayheavy",color: Colors.black)),
                  ),
                ),



                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 44.0, top: 10.0,right: 30.0),
                    child: Text("Insert the voucher pin below and tap the verify button to check the validity of your voucher. ", style: TextStyle(fontSize: 14.0,fontFamily: "sfprodisplaylight",color: Colors.black)),
                  ),
                ),

                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding:  EdgeInsets.only(left: 44.0, top: 25.0,right: 30.0,),
                    child: Theme(
                      data: Theme.of(context).copyWith(splashColor: Colors.transparent),
                      child: TextField(
                        keyboardType: TextInputType.number,
                        focusNode: phoneNumberFocusNode,
                        onChanged: (text) {
                          _pin = text;
                        },
                        autofocus: false,
                        style: TextStyle(fontSize: 13.0, color: Colors.black),
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Color(0xFF7E768CA5),
                          hintText: 'Enter Voucher Pin',
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
                    padding:  EdgeInsets.only(left: 44.0, top: 25.0,right: 30.0,bottom: MediaQuery.of(context).viewInsets.bottom,),
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
                            child: const Text('Verify',style: TextStyle(fontFamily: "sfprodisplaybold")),
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

class InputDoneView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: Colors.grey,
      child: Align(
        alignment: Alignment.topRight,
        child: Padding(
          padding: const EdgeInsets.only(top: 4.0, bottom: 4.0),
          child: CupertinoButton(
            padding: EdgeInsets.only(right: 24.0, top: 8.0, bottom: 8.0),
            onPressed: () {
              FocusScope.of(context).requestFocus(new FocusNode());
            },
            child: Text(
                "Done",
                style: TextStyle(color: Colors.indigo,fontWeight: FontWeight.bold)
            ),
          ),
        ),
      ),
    );
  }
}