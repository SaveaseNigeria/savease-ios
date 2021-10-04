import 'dart:convert';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:keyboard_actions/keyboard_actions.dart';
import 'package:keyboard_visibility/keyboard_visibility.dart';
import 'package:location/location.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:savease/Activities/Upgrade.dart';
import 'package:savease/Auth/Login.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:xml2json/xml2json.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:toast/toast.dart';

class Company {
  var title;

  Company( this.title);

  static List<Company> getCompanies() {
    return <Company>[
      Company('Relationship with Kin'),
      Company( 'Father'),
      Company( 'Mother'),
      Company( 'Sister'),
      Company( 'Brother'),
      Company( 'Wife'),
      Company( 'Husband'),
      Company( 'Son'),
      Company( 'Daughter'),
      Company( 'Other'),


    ];
  }
}

class UpgradeStat extends StatefulWidget {
  @override
  _VerifycreenState createState() => new _VerifycreenState();
}

class _VerifycreenState extends State<UpgradeStat> {
  Xml2Json xml2json = new Xml2Json();
  ProgressDialog pr;
  String _pin;
  OverlayEntry overlayEntry;
  FocusNode phoneNumberFocusNode = new FocusNode();
  String busAdd;
  String busState;
  String busTown;
  String homeAdd;
  String homeState;
  String homeTown;
  bool checked = false;
  String accountNum = "";



  void getData() async{
    final prefs = await SharedPreferences.getInstance();

    String  fname = prefs.getString('fname') ?? '';
    String  lname = prefs.getString('lname') ?? '';
    String  type = prefs.getString('userType') ?? '';
    String user = prefs.getString('saveaseid') ?? '';


    if(fname != null || fname != ""){

      setState(() {
        accountNum = user;
      });

    }else{


    }


  }



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
    getData();

    super.initState();

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

        child:SingleChildScrollView(
          physics: AlwaysScrollableScrollPhysics(),
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            decoration: BoxDecoration(

              image: DecorationImage(
                image: AssetImage("assets/image/bne.png"),
                fit: BoxFit.cover,
              ),
            ),
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
                  child: Padding(
                    padding: const EdgeInsets.only(top: 70.0,right: 10,left: 44),
                    child: Container(
                        width: 150.0,
                        child: Image.asset("assets/image/logo.png",width: 150,height: 50,)),),
                ),


                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 10,left: 44,right: 44),
                    child: Text("Please, provide the information below to help us create a Savease Business Account for you.", style: new TextStyle(fontSize: 14.0, fontWeight: FontWeight.bold, fontFamily: "sfprodisplaylight",),),
                  ),
                ),


                Expanded(
                  child: ListView(
                    children: <Widget>[
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 44.0, top: 25.0,right: 30.0),
                          child: Theme(
                            data: Theme.of(context).copyWith(splashColor: Colors.transparent),
                            child: TextField(
                              onChanged: (text) {

                                setState(() {
                                  busAdd = text;
                                });

                              },
                              autofocus: false,
                              style: TextStyle(fontSize: 13.0, color: Colors.black),
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Color(0xFF7E768CA5),
                                hintText: 'Business Address',
                                contentPadding:
                                const EdgeInsets.only(left: 14.0, bottom: 12.0, top: 12.0),
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
                                  busTown = text;
                                });

                              },
                              keyboardType: TextInputType.text,
                              obscureText: false,
                              autofocus: false,
                              style: TextStyle(fontSize: 13.0, color: Colors.black),
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Color(0xFF7E768CA5),
                                hintText: 'Business Town',
                                contentPadding:
                                const EdgeInsets.only(left: 14.0, bottom: 12.0, top: 12.0),
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
                                  busState = text;
                                });

                              },
                              keyboardType: TextInputType.text,
                              obscureText: false,
                              autofocus: false,
                              style: TextStyle(fontSize: 13.0, color: Colors.black),
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Color(0xFF7E768CA5),
                                hintText: 'Business State',
                                contentPadding:
                                const EdgeInsets.only(left: 14.0, bottom: 12.0, top: 12.0),
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
                                  homeAdd = text;
                                });

                              },
                              autofocus: false,
                              style: TextStyle(fontSize: 13.0, color: Colors.black),
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Color(0xFF7E768CA5),
                                hintText: 'Home Address',
                                contentPadding:
                                const EdgeInsets.only(left: 14.0, bottom: 12.0, top: 12.0),
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
                                  homeState = text;
                                });

                              },
                              keyboardType: TextInputType.text,
                              obscureText: false,
                              autofocus: false,
                              style: TextStyle(fontSize: 13.0, color: Colors.black),
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Color(0xFF7E768CA5),
                                hintText: 'Home State',
                                contentPadding:
                                const EdgeInsets.only(left: 14.0, bottom: 12.0, top: 12.0),
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
                                  homeTown = text;
                                });

                              },
                              keyboardType: TextInputType.text,
                              obscureText: false,
                              autofocus: false,
                              style: TextStyle(fontSize: 13.0, color: Colors.black),
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Color(0xFF7E768CA5),
                                hintText: 'Home Town',
                                contentPadding:
                                const EdgeInsets.only(left: 14.0, bottom: 12.0, top: 12.0),
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
                        alignment: Alignment.center,
                        child: Padding(
                          padding: EdgeInsets.only(left: 44.0, top: 20.0,right: 30.0,bottom: MediaQuery.of(context).viewInsets.bottom,),
                          child: Container(
                            width: 150.0,
                            child: ButtonTheme(
                              minWidth: 100.0,
                              height: 50.0,

                              child :  RaisedButton(
                                  onPressed: () {
                                    Map<String, String> data = new Map();
                                    data["busTown"] = busTown;
                                    data["busState"] = busState;
                                    data["busAdd"] = busAdd;
                                    data["homeAdd"] = homeAdd;
                                    data["homeTown"] = homeTown;
                                    data["homeState"] = homeState;
                                    var route = new MaterialPageRoute(
                                        builder: (BuildContext context) => new Upgrade(
                                          data: data,
                                        ));
                                    Navigator.of(context).push(route);
                                  },
                                  textColor: Colors.white,
                                  color:  Color(
                                      0xff212435),
                                  child: const Text('Continue',style: TextStyle(fontFamily: "sfprodisplaybold")),
                                  shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(10.0))
                              ),
                            ),
                          ),
                        ),
                      ),

                    ],
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