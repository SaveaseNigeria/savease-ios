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


class Welcome extends StatefulWidget {
  @override
  _LoginScreenState createState() => new _LoginScreenState();
}

class _LoginScreenState extends State<Welcome> {


  void _back() {
    Navigator.push(context, MaterialPageRoute(builder: (context) => AuthWelcomeScreen()));
  }



  void _register() {
    Navigator.push(context, MaterialPageRoute(builder: (context) => Registration()));
  }
  @override
  void initState() {
    super.initState();

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
                        padding: const EdgeInsets.only(left: 30.0, top: 25.0,),
                        child: Image.asset("assets/image/logo.png")
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 30.0, top: 30.0,right: 30.0),
                    child: Text("Welcome to Savease,", style: TextStyle(fontSize: 14.0,fontFamily: "sfprodisplaylight",color: Colors.black)),
                  ),
                ),

                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 30.0,top: 30,right: 30 ),
                    child: Text("Now that you are about registering to the Savease Network, please ensure to use the appropriate information as it appears on your BVN (Bank Verification Number). We mean: Firstname, Lastname and Telephone number must be exactly as available on your BVN.", style: TextStyle(fontSize: 14.0,fontFamily: "sfprodisplaylight",color: Colors.black)),
                  ),
                ),

                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 30.0, top: 25.0,right: 30.0),
                    child: Text("This is an important criteria to successfully activating your Savease.You will not be able to perform certain transactions if your account is not verified and linked to a BVN.", style: TextStyle(fontSize: 14.0,fontFamily: "sfprodisplaylight",color: Colors.black)),
                  ),
                ),



                Align(
                  alignment: Alignment.center,
                  child: Padding(
                    padding: const EdgeInsets.only( top: 45.0),
                    child: Container(
                      width: 100.0,
                      child: ButtonTheme(
                        minWidth: 100.0,
                        height: 40.0,

                        child :  RaisedButton(
                            onPressed: () {
                              _register();
                             // Navigator.push(context, MaterialPageRoute(builder: (context) => LoginScreen()));
                            },
                            textColor: Colors.white,
                            color: Color(0xff212435),
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
    );
  }
}