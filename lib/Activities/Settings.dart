import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:keyboard_visibility/keyboard_visibility.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:provider/provider.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:savease/Activities/ChangePassword.dart';
import 'package:savease/Activities/Profile.dart';
import 'package:savease/Activities/UpgradeStat.dart';
import 'package:savease/Auth/Login.dart';
import 'package:savease/Utils/ZoomScaffoldActivites.dart';
import 'package:savease/Utils/menu_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';
import 'package:http/http.dart' as http;
import 'package:xml2json/xml2json.dart';


class Settings extends StatefulWidget {
  @override
  _HoomeState createState() => new _HoomeState();
}



class _HoomeState extends State<Settings> with TickerProviderStateMixin {

  ProgressDialog pr;

  Xml2Json xml2json = new Xml2Json();
  MenuController menuController;
  String accountName = "";
  String userType = "";
  String firstName;

  bool _isVisible = false;
  var scr= new GlobalKey();
  bool _value2 = false;
  bool checked = false;

  void _value2Changed(bool value) => setState(() => checked = value);

  void _onChanged2(bool value){

    setState(() {
      _value2 = value;
      showAlertDialog(context);
    });

  }

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




  void getData() async{
    final prefs = await SharedPreferences.getInstance();

    String  fname = prefs.getString('fname') ?? '';
    String  lname = prefs.getString('lname') ?? '';
    String  type = prefs.getString('userType') ?? '';
    String user = prefs.getString('saveaseid') ?? '';


    if(fname != null || fname != ""){

      setState(() {
        accountName = fname +" "+ lname;
        userType = type;
        firstName = fname;


        if(userType == "1"){
          _isVisible = true;
        }else{
          _isVisible = false;
        }

      });

    }else{
      accountName = "";
      userType = "";

    }


  }

  showAlertDialog(BuildContext context) {
    // set up the buttons
    Widget cancelButton = FlatButton(
      child: Text("No"),
      onPressed:  () {
        setState(() {
          _value2 = false;
          Navigator.pop(context);
        });
      },
    );
    Widget continueButton = FlatButton(
      child: Text("Ok"),
      onPressed:  () {
        showDialog(
          context: context,
          builder: (_) => _showVerifyBvn(context),
        );
      },
    );
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Upgrade to Savease Business"),
      content: Text("Are you sure you want to upgrade your account to become a vendor?"),
      actions: [
        cancelButton,
        continueButton,
      ],
    );
    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }


  _showVerifyBvn(BuildContext context) {
    return Scaffold(
      body: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          RepaintBoundary(
            key: scr,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: SingleChildScrollView(
                physics: AlwaysScrollableScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height/1.5,
                    decoration: BoxDecoration(

                      image: DecorationImage(
                        image: AssetImage("assets/image/bne.png"),
                        fit: BoxFit.cover,
                      ),
                    ),
                    child: Column(
                      children: <Widget>[
                        GestureDetector(
                          onTap:() => Navigator.pop(context),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Padding(
                              padding: const EdgeInsets.only(top: 70.0,left: 20.0),
                              child: Icon(Icons.arrow_back_ios,),
                            ),
                          ),
                        ),

                        Align(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding: const EdgeInsets.only(top: 20.0,right: 10,left: 44),
                            child: Container(
                                width: 150.0,
                                child: Image.asset("assets/image/logo.png",width: 150,height: 30,)),),
                        ),

                        Align(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding: const EdgeInsets.only(top: 20,left: 44),
                            child: Text("Dear ${firstName},", style: new TextStyle(fontSize: 14.0, fontWeight: FontWeight.bold,fontFamily: "sfprodisplaylight", ),),
                          ),
                        ),

                        Align(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding: const EdgeInsets.only(top: 10,left: 44,right: 44),
                            child: Text("You have made a good decision to become one of the millions of agents across africa helping to solve the banking hitch of distance, space,structure and time", style: new TextStyle(fontSize: 14.0, fontWeight: FontWeight.bold, fontFamily: "sfprodisplaylight",),),
                          ),
                        ),

                        Align(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding: const EdgeInsets.only(top: 20,left: 44,right: 44),
                            child: Text("As a Savease Business Agent, you will be given an elevated session to buy Savease Vouchers and sell to users with a commission charge for you.", style: new TextStyle(fontSize: 14.0, fontWeight: FontWeight.bold, fontFamily: "sfprodisplaylight",),),
                          ),
                        ),

                        Align(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding: const EdgeInsets.only(top: 20,left: 44,right: 44),
                            child: Text("Make sure to apply for Savease Business Kit and establish your presence in your neighborhood..", style: new TextStyle(fontSize: 14.0, fontWeight: FontWeight.bold, fontFamily: "sfprodisplaylight",),),
                          ),
                        ),

                        Padding(
                          padding: const EdgeInsets.only(left: 20,right: 5,bottom: 4,top: 15),
                          child: Row(
                            children: <Widget>[
                              CheckboxListTile(
                                value: checked,
                                onChanged: _value2Changed,
                                title: new Text('Terms and Condition'),
                                controlAffinity: ListTileControlAffinity.leading,
                                activeColor: Color(0xff212435),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 10),
                                child: Text(
                                    "Read",
                                    style: TextStyle(
                                        decoration: TextDecoration.none,
                                        fontFamily:
                                        "sfprodisplaylight",
                                        fontSize:
                                        11.0,
                                        fontWeight:
                                        FontWeight
                                            .bold,
                                        color: Colors.blue )),
                              ),

                            ],
                          ),
                        ),



                        Align(
                          alignment: Alignment.center,
                          child: Padding(
                            padding: EdgeInsets.only(left: 44.0, top: 25.0,right: 30.0,bottom: MediaQuery.of(context).viewInsets.bottom,),
                            child: Container(
                              width: 200.0,
                              child: ButtonTheme(
                                minWidth: 100.0,
                                height: 40.0,

                                child :  RaisedButton(
                                    onPressed: () {
                                      if(checked){
                                        Navigator.push(context, MaterialPageRoute(builder: (context) => UpgradeStat()));
                                      }else{
                                        Toast.show("Please agree to the terms and conditions", context, duration: Toast.LENGTH_LONG, gravity:  Toast.BOTTOM);
                                      }



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
                ),
              ),
            ),
          ),//
          // Show your Image

        ],
      ),
    );
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
    menuController = new MenuController(
      vsync: this,
    )..addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    menuController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: ChangeNotifierProvider(
          builder: (context) => menuController,
          child: ZoomScaffoldActivities(
            menuScreen: MenuScreen(),
            contentScreen: Layout(
                contentBuilder: (cc) => Stack(
                  children: <Widget>[
                    Column(
                      children: <Widget>[
                        Container(
                          child: Container(
                            color: Color(0xff212435),
                            width: MediaQuery.of(context).size.width,
                            height: 50.0,
                            child: Center(
                                child: Text(
                                  "Settings",
                                  style: new TextStyle(
                                      fontSize: 20.0,
                                      fontWeight: FontWeight.bold,
                                      fontStyle: FontStyle.normal,
                                      color: Colors.white),
                                  textAlign: TextAlign.center,
                                )),
                          ),
                        ),

                        Expanded(
                          child: SingleChildScrollView(
                            physics: AlwaysScrollableScrollPhysics(),
                            child: Container(
                              color: Colors.white,
                              height: MediaQuery.of(context).size.height,
                              width: MediaQuery.of(context).size.width,

                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Column(
                                  mainAxisSize: MainAxisSize.max,
                                  children: <Widget>[

                                    GestureDetector(
                                      onTap: () {
                                        Navigator.push(context, MaterialPageRoute(builder: (context) => ChangePassword()));
                                      },
                                      child: Align(
                                        alignment: Alignment.centerLeft,
                                        child: Container(
                                          height: 40,
                                          child: Padding(
                                            padding: const EdgeInsets.only(left: 10,top: 15),
                                            child: Text(
                                              "Change Password",
                                              style: new TextStyle(
                                                  fontSize: 15.0,
                                                  fontWeight: FontWeight.bold,
                                                  fontStyle: FontStyle.normal,
                                                  color: Color(0xff212435)),
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Divider(
                                      color: Color(0xff212435),
                                    ),

                                    GestureDetector(
                                      onTap: () {
                                        Navigator.push(context, MaterialPageRoute(builder: (context) => Profile()));
                                      },
                                      child: Align(
                                        alignment: Alignment.centerLeft,
                                        child: Container(
                                          height: 40,
                                          child: Padding(
                                            padding: const EdgeInsets.only(left: 10,top: 15),
                                            child: Text(
                                              "Profile",
                                              style: new TextStyle(
                                                  fontSize: 15.0,
                                                  fontWeight: FontWeight.bold,
                                                  fontStyle: FontStyle.normal,
                                                  color: Color(0xff212435)),
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Divider(
                                      color: Color(0xff212435),
                                    ),

                                    Padding(
                                      padding: const EdgeInsets.only(top: 1),
                                      child: Visibility(
                                          visible: _isVisible,
                                          child: Container(
                                            child: SwitchListTile(
                                              value: _value2,
                                              onChanged: _onChanged2,
                                              title: new Text('Upgrade to Savease Business', style: new TextStyle(fontSize: 15.0,fontWeight: FontWeight.bold, color: Color(0xff212435))),
                                            ),

                                          )
                                      ),
                                    ),



                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),

                      ],
                    ),
                    Positioned(
                      bottom: 0.0,
                      child: Container(
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            color: Color(0xff212435),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: <Widget>[
                                //your elements here
                                Align(
                                    alignment: Alignment.bottomCenter,
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                          'Copyrights © 2016 All Rights Reserved. Powered by Savease Nigeria Limited, a sub-class of Savease Africa.',
                                          style: TextStyle(
                                              fontFamily: "sfprodisplaybold",
                                              fontSize: 11.0,
                                              color: Colors.white)),
                                    )),
                              ],
                            ),
                          )),
                    )
                  ],
                )),
          ),
        ));
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
