import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:savease/Activities/About.dart';
import 'package:savease/Activities/Complaint.dart';
import 'package:savease/Activities/Settings.dart';
import 'package:savease/Activities/UserGuide.dart';
import 'package:savease/Auth/AuthWelcome.dart';
import 'package:savease/Utils/ZoomScaffold.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:savease/Activities/VerifyHome.dart';
import 'package:savease/Activities/Deposit.dart';
import 'package:savease/Activities/Transfer.dart';
import 'package:savease/Activities/VerifyHome.dart';

class MenuScreen extends StatelessWidget {

  final List<MenuItem> options = [
    MenuItem("assets/image/verify.png", 'Verify'),
    MenuItem("assets/image/Group.png", 'Transfer'),
    MenuItem("assets/image/guide.png", 'User Guide'),
    MenuItem("assets/image/complain.png", 'Complaint'),
    MenuItem("assets/image/about.png", 'About'),
    MenuItem("assets/image/settings.png", 'Settings'),
    MenuItem("assets/image/power.png", 'Logout'),
  ];

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanUpdate: (details) {
        //on swiping left
        if (details.delta.dx < -6) {
          Provider.of<MenuController>(context, listen: true).toggle();
        }
      },
      child: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/image/bne.png"),
            fit: BoxFit.cover,
          ),
        ),

        child: Padding(
          padding: EdgeInsets.only(
              top: 62,
              left: 15,
              bottom: 8,
              right: MediaQuery.of(context).size.width / 2.9),
          child: Column(
            children: <Widget>[
              Container(
                color: Color(0xff212435),
                child: Padding(
                  padding: const EdgeInsets.only(top: 10.0),
                  child: Container(
                      width: MediaQuery.of(context).size.width,
                      child: Image.asset("assets/image/log.png")),
                ),
              ),
              Column(
                children: options.map((item) {
                  return ListTile(
                    onTap: (){
                      switch(item.title) {
                        case  "Verify": {
                          // statements;
                          Navigator.push(context, MaterialPageRoute(builder: (context) => VerifyHome()));

                        }
                        break;


                        case "Transfer": {
                          //statements;
                          Navigator.push(context, MaterialPageRoute(builder: (context) => Transfer()));
                        }
                        break;

                        case "User Guide": {
                          //statements;
                          Navigator.push(context, MaterialPageRoute(builder: (context) => UserGuide()));
                        }
                        break;

                        case "Complaint": {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => Complaint()));
                          //statements;
                        }
                        break;

                        case "About": {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => About()));
                          //statements;
                        }
                        break;

                        case "Settings": {
                          //statements;
                          Navigator.push(context, MaterialPageRoute(builder: (context) => Settings()));
                        }
                        break;

                        case "Logout": {

                          Alert(
                              context: context,
                              title: "Logout",
                              desc:
                              "Click the YES button to logout",
                              image:
                              Image.asset("assets/image/danger.png"),
                              buttons: [
                                DialogButton(
                                  color: Color(0xff212435),
                                  onPressed: () {
                                    Navigator.push(context, MaterialPageRoute(builder: (context) => AuthWelcomeScreen()));
                                  },
                                  child: Text(
                                    "Yes",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 20),
                                  ),
                                ),
                                DialogButton(
                                  color: Color(0xff212435),
                                  onPressed: () =>
                                      Navigator.pop(context),
                                  child: Text(
                                    "No",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 20),
                                  ),
                                )
                              ]).show();

                          //statements;
                        }
                        break;

                        default: {
                          //statements;
                        }
                        break;
                      }
                    },
                    leading:GestureDetector(
                      onTap: (){
                        switch(item.title) {
                          case  "Verify": {
                            // statements;
                            Navigator.push(context, MaterialPageRoute(builder: (context) => VerifyHome()));

                          }
                          break;

                          case "Deposit": {
                            //statements;
                          }
                          break;

                          case "Transfer": {
                            //statements;
                          }
                          break;

                          case "User Guide": {
                            //statements;
                          }
                          break;

                          case "Complaint": {
                            //statements;
                          }
                          break;

                          case "About": {
                            //statements;
                          }
                          break;

                          case "Settings": {
                            //statements;
                          }
                          break;

                          case "Logout": {
                            //statements;
                          }
                          break;

                          default: {
                            //statements;
                          }
                          break;
                        }
                      },
                      child: Container(
                        width: 17.0,
                          child: Image.asset(item.imageUrl)),
                    ),
                    title: Text(
                      item.title,
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.black),
                    ),
                  );
                }).toList(),
              ),

            ],
          ),
        ),
      ),
    );
  }
}

class MenuItem {
  String title;
  var imageUrl;

  MenuItem(this.imageUrl, this.title);
}
