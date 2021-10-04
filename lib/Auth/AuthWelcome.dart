import 'package:flutter/material.dart';
import 'package:savease/Auth/Login.dart';
import 'package:savease/Auth/VerifyPin.dart';
import 'package:savease/Auth/Registration.dart';
import 'package:savease/Auth/welcome.dart';

class AuthWelcomeScreen extends StatefulWidget {
  @override
  _AuthWelcomeScreenState createState() => new _AuthWelcomeScreenState();
}

class _AuthWelcomeScreenState extends State<AuthWelcomeScreen> {



  @override
  void initState() {
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
        child: Column(
          children: <Widget>[
            Align(
              alignment: Alignment.centerRight,
              child: Padding(
                padding: const EdgeInsets.only(top: 80.0,right: 70.0),
                child: OutlineButton(
                    borderSide: BorderSide(color: Colors.black),
                    child: new Text("Verify Pin",style: TextStyle(fontSize: 14.0,fontFamily: "sfprodisplaylight",color: Colors.black)),
                    onPressed: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context) => VerifyScreen()));
                    },
                    shape: StadiumBorder(),
                ),
              ),
            ),

            Align(
              alignment: Alignment.center,
              child: Container(
                width: 250.0,
                child: Padding(
                    padding: const EdgeInsets.only(left: 34.0, top: 150.0,right: 20.0),
                    child: Image.asset("assets/image/logo.png")
                ),
              ),
            ),

            Align(
              alignment: Alignment.center,
              child: Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Text("Save Easily, Pay Easily",style: TextStyle(fontSize: 12.0,fontFamily: "sfprodisplaylight",color: Colors.black)),
              ),
            ),

            Expanded(
              flex: 2,
              child: Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Padding(padding: EdgeInsets.only(bottom: 20.0),),
                    Container(
                      width: 180.0,
                      child: ButtonTheme(
                        minWidth: 280.0,
                        height: 40.0,

                        child :  RaisedButton(
                            onPressed: () {
                              Navigator.push(context, MaterialPageRoute(builder: (context) => LoginScreen()));
                            },
                            textColor: Colors.white,
                            color: Color(0xffFA9928),
                            child: const Text('Login',style: TextStyle(fontFamily: "sfprodisplaybold")),
                            shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(10.0))
                        ),
                      ),
                    ),


                    Container(
                      width: 180.0,
                      child: ButtonTheme(
                        minWidth: 280.0,
                        height: 40.0,

                        child :  RaisedButton(
                            onPressed: () {
                              Navigator.push(context, MaterialPageRoute(builder: (context) => Welcome()));
                            },
                            textColor: Colors.white,
                            color: Color(0xff212435),
                            child: const Text('Register',style: TextStyle(fontFamily: "sfprodisplaybold")),
                            shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(10.0))
                        ),
                      ),
                    ),

                    Align(
                      alignment: Alignment.center,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 50),
                        child: Text("Version 2.5.2",style: TextStyle(fontSize: 12.0,fontFamily: "sfprodisplaylight",color: Colors.black)),
                      ),
                    ),

                  ],
                ),
              ),
            )
          ],
        )
      ),
    );
  }
}