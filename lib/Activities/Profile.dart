import 'package:device_info/device_info.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:savease/Activities/Banks.dart';
import 'package:savease/Utils/ZoomScaffoldActivites.dart';
import 'package:savease/Utils/fintnessAppTheme.dart';
import 'package:savease/Utils/menu_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:xml2json/xml2json.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:savease/Activities/AccountOfficer.dart';

class Profile extends StatefulWidget {
  @override
  _HoomeState createState() => new _HoomeState();
}

class _HoomeState extends State<Profile> with TickerProviderStateMixin {
  Xml2Json xml2json = new Xml2Json();
  ProgressDialog pr;
  String _pin = "abcd";
  String balance = "";
  String accountNumer = "";
  String accountName = "";
  String frstName = "";
  String lstName = "";
  String email = "";
  String phne = "";
  String type = "";
  String bvn = "";

  MenuController menuController;

  String rect = "assets/image/rect.png";

  isIpad() async{
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    IosDeviceInfo info = await deviceInfo.iosInfo;
    if (info.name.toLowerCase().contains("ipad")) {
      setState(() {
        rect = "assets/image/recttwo.png";
      });

    }else {
      setState(() {
        rect = "assets/image/rect.png";
      });
    }

  }

  void getData() async{
    final prefs = await SharedPreferences.getInstance();
    double bala = prefs.getDouble('balance') ?? '';
    String  fname = prefs.getString('fname') ?? '';
    String  lname = prefs.getString('lname') ?? '';
    String phone = prefs.getString('saveaseid') ?? '';
    String phoneNum = prefs.getString('phone') ?? '';
    String emil = prefs.getString('email') ?? '';
    String Bvn = prefs.getString('bvn') ?? '';

    String userType = prefs.getString('userType') ?? '';
    String balanc = bala.toStringAsFixed(2);

    if(balanc != null || balanc != ""){

      setState(() {
        balance = balanc;
        accountNumer = phone;
        accountName = fname +" "+ lname;
        frstName = fname;
        lstName = lname;
        phne = phoneNum;
        email = emil;
        bvn = Bvn;
        if (userType == "2"){
          type = "Vendor";
        }else{
          type = "User";
        }
      });

    }else{
      balance = "";
      accountName = "";
      accountNumer = "";
      frstName = "";
      lstName = "";
      phne = "";
      email = "";
      bvn = "";
    }


  }
  @override
  void initState() {
isIpad();
    getData();
    super.initState();
    menuController = new MenuController(
      vsync: this,
    );
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset : false,
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(new FocusNode());
        },
        child: ChangeNotifierProvider(
          builder: (context) => menuController,
          child: ZoomScaffoldActivities(
            menuScreen: MenuScreen(),
            contentScreen: Layout(
                contentBuilder: (cc) => Stack(
                  children: <Widget>[
                    Container(
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
                            Stack(
                              children: <Widget>[
                                Container(
                                  width: MediaQuery.of(context).size.width,
                                  height: 150,
                                  child:
                                  Image.asset(rect,fit: BoxFit.cover,),
                                ),
                                Container(

                                  child: Padding (
                                    padding: const EdgeInsets.only(
                                        left: 15, right: 15, top: 18, bottom: 2),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: FintnessAppTheme.white,
                                        borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(8.0),
                                            bottomLeft: Radius.circular(8.0),
                                            bottomRight: Radius.circular(8.0),
                                            topRight: Radius.circular(68.0)),
                                        boxShadow: <BoxShadow>[
                                          BoxShadow(
                                              color: FintnessAppTheme.grey.withOpacity(0.2),
                                              offset: Offset(1.1, 1.1),
                                              blurRadius: 10.0),
                                        ],
                                      ),
                                      child: Column(
                                        children: <Widget>[

                                          Padding(
                                            padding:
                                            const EdgeInsets.only(top: 8, left: 16, right: 24),
                                            child: Column(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: <Widget>[
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,

                                                  children: <Widget>[
                                                    Row(
                                                      mainAxisAlignment: MainAxisAlignment.center,

                                                      children: <Widget>[
                                                        Padding(
                                                          padding: const EdgeInsets.only(
                                                              left: 4, bottom: 3),
                                                          child: Text(
                                                            "N "+balance,
                                                            textAlign: TextAlign.center,
                                                            style: TextStyle(
                                                              fontFamily: FintnessAppTheme.fontName,
                                                              fontWeight:
                                                              FontWeight.bold,
                                                              fontSize: 16,
                                                              color: Color(
                                                                  0xff212435),
                                                            ),
                                                          ),
                                                        ),

                                                      ],
                                                    ),
                                                    Padding(
                                                      padding:
                                                      const EdgeInsets
                                                          .only(

                                                          right:
                                                          10.0),
                                                      child:
                                                      new Container(
                                                        width: 110.0,
                                                        child:
                                                        ButtonTheme(
                                                          height: 28.0,
                                                          child:
                                                          RaisedButton(
                                                              onPressed:
                                                                  () {
                                                                Navigator.push(
                                                                    context,
                                                                    MaterialPageRoute(builder: (context) => AccountOfficer()));
                                                                // Navigator.push(context, MaterialPageRoute(builder: (context) => LoginScreen()));
                                                              },
                                                              textColor:
                                                              Colors
                                                                  .white,
                                                              color:  Color(
                                                                  0xff212435),
                                                              child: const Text(
                                                                  'Account Officer',
                                                                  style:
                                                                  TextStyle(fontFamily: "sfprodisplaylight", fontSize: 12.0)),
                                                              shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(5.0))),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                )
                                              ],
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 24, right: 24, bottom: 4),
                                            child: Container(
                                              height: 2,
                                              decoration: BoxDecoration(
                                                color: FintnessAppTheme.background,
                                                borderRadius: BorderRadius.all(Radius.circular(4.0)),
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 15, right: 24, bottom: 10,top: 10),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                              children: <Widget>[
                                                Expanded(

                                                  child: Column(
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: <Widget>[
                                                      Text(
                                                        accountName,
                                                        textAlign: TextAlign.center,
                                                        style: TextStyle(
                                                          fontFamily: FintnessAppTheme.fontName,
                                                          fontWeight: FontWeight.w500,
                                                          fontSize: 13,
                                                          letterSpacing: -0.2,
                                                          color: FintnessAppTheme.darkText,
                                                        ),
                                                      ),
                                                      Padding(
                                                        padding: const EdgeInsets.only(top: 3),
                                                        child: Text(
                                                          'Account Name',
                                                          textAlign: TextAlign.center,
                                                          style: TextStyle(
                                                            fontFamily: FintnessAppTheme.fontName,
                                                            fontWeight: FontWeight.w600,
                                                            fontSize: 12,
                                                            color: FintnessAppTheme.grey
                                                                .withOpacity(0.5),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Expanded(

                                                  child: Row(
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    crossAxisAlignment: CrossAxisAlignment.center,
                                                    children: <Widget>[
                                                      Column(
                                                        mainAxisAlignment: MainAxisAlignment.center,
                                                        crossAxisAlignment: CrossAxisAlignment.center,
                                                        children: <Widget>[
                                                          Text(
                                                            accountNumer,
                                                            textAlign: TextAlign.center,
                                                            style: TextStyle(
                                                              fontFamily: FintnessAppTheme.fontName,
                                                              fontWeight: FontWeight.w500,
                                                              fontSize: 13,
                                                              letterSpacing: -0.2,
                                                              color: FintnessAppTheme.darkText,
                                                            ),
                                                          ),
                                                          Padding(
                                                            padding: const EdgeInsets.only(top: 3),
                                                            child: Text(
                                                              'Account Number',
                                                              textAlign: TextAlign.center,
                                                              style: TextStyle(
                                                                fontFamily: FintnessAppTheme.fontName,
                                                                fontWeight: FontWeight.w600,
                                                                fontSize: 12,
                                                                color: FintnessAppTheme.grey
                                                                    .withOpacity(0.5),
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Expanded(
                                                  child: Row(
                                                    mainAxisAlignment: MainAxisAlignment.end,
                                                    crossAxisAlignment: CrossAxisAlignment.center,
                                                    children: <Widget>[
                                                      Column(
                                                        mainAxisAlignment: MainAxisAlignment.center,
                                                        crossAxisAlignment: CrossAxisAlignment.end,
                                                        children: <Widget>[
                                                          Text(
                                                            type,
                                                            style: TextStyle(
                                                              fontFamily: FintnessAppTheme.fontName,
                                                              fontWeight: FontWeight.w500,
                                                              fontSize: 13,
                                                              letterSpacing: -0.2,
                                                              color: FintnessAppTheme.darkText,
                                                            ),
                                                          ),
                                                          Padding(
                                                            padding: const EdgeInsets.only(top: 3),
                                                            child: Text(
                                                              'Account Type',
                                                              textAlign: TextAlign.center,
                                                              style: TextStyle(
                                                                fontFamily: FintnessAppTheme.fontName,
                                                                fontWeight: FontWeight.w600,
                                                                fontSize: 12,
                                                                color: FintnessAppTheme.grey
                                                                    .withOpacity(0.5),
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                )
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SingleChildScrollView(
                              physics: AlwaysScrollableScrollPhysics(),
                              child: Padding(
                                padding:  EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom,),
                                child: Container(
                                  child: Column(
                                    children: <Widget>[

                                      Align(
                                        alignment: Alignment.center,
                                        child: Padding(
                                          padding: const EdgeInsets.only(left: 20.0, top: 25.0,right: 30.0),
                                          child: Text("Profile", style: TextStyle(fontSize: 17.0,fontFamily: "sfprodisplayheavy",color: Colors.black)),
                                        ),
                                      ),

                                      Padding(
                                        padding: const EdgeInsets.only(left: 20.0, top: 5.0),
                                        child: Container(
                                          child: Row(
                                            children: <Widget>[

                                              Padding(
                                                padding: const EdgeInsets.only(right: 10),
                                                child: Text("First Name:",style: TextStyle(fontSize: 12.0,color: Colors.black,fontFamily: "sfprodisplayheavy"),),
                                              ),

                                              Padding(
                                                padding: const EdgeInsets.only(left: 30),
                                                child: Container(
                                                  width: 230,
                                                  child: Padding(
                                                    padding: const EdgeInsets.all(8.0),
                                                    child: Text(frstName,style: TextStyle(fontSize: 12.0,color: Colors.black),),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),

                                      Padding(
                                        padding: const EdgeInsets.only(left: 20.0, top: 5.0),
                                        child: Container(
                                          child: Row(
                                            children: <Widget>[

                                              Padding(
                                                padding: const EdgeInsets.only(right: 10),
                                                child: Text("Last Name:",style: TextStyle(fontSize: 12.0,color: Colors.black,fontFamily: "sfprodisplayheavy"),),
                                              ),

                                              Padding(
                                                padding: const EdgeInsets.only(left: 30),
                                                child: Container(

                                                  width: 230,
                                                  child: Padding(
                                                    padding: const EdgeInsets.all(8.0),
                                                    child: Text(lstName,style: TextStyle(fontSize: 12.0,color: Colors.black),),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),

                                      Padding(
                                        padding: const EdgeInsets.only(left: 20.0, top: 5.0),
                                        child: Container(
                                          child: Row(
                                            children: <Widget>[

                                              Padding(
                                                padding: const EdgeInsets.only(right: 10),
                                                child: Text("Phone Number:",style: TextStyle(fontSize: 12.0,color: Colors.black,fontFamily: "sfprodisplayheavy"),),
                                              ),

                                              Padding(
                                                padding: const EdgeInsets.only(left: 5),
                                                child: Container(

                                                  width: 230,
                                                  child: Padding(
                                                    padding: const EdgeInsets.all(8.0),
                                                    child: Text(phne,style: TextStyle(fontSize: 12.0,color: Colors.black),),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),

                                      Padding(
                                        padding: const EdgeInsets.only(left: 20.0, top: 5.0),
                                        child: Container(
                                          child: Row(
                                            children: <Widget>[

                                              Padding(
                                                padding: const EdgeInsets.only(right: 10),
                                                child: Text("Email:",style: TextStyle(fontSize: 12.0,color: Colors.black,fontFamily: "sfprodisplayheavy"),),
                                              ),

                                              Padding(
                                                padding: const EdgeInsets.only(left: 60),
                                                child: Container(

                                                  width: 230,
                                                  child: Padding(
                                                    padding: const EdgeInsets.all(8.0),
                                                    child: Text(email,style: TextStyle(fontSize: 12.0,color: Colors.black),),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),


                                      Padding(
                                        padding: const EdgeInsets.only(left: 20.0, top: 5.0),
                                        child: Container(
                                          child: Row(
                                            children: <Widget>[

                                              Padding(
                                                padding: const EdgeInsets.only(right: 10),
                                                child: Text("Savease Id:",style: TextStyle(fontSize: 12.0,color: Colors.black,fontFamily: "sfprodisplayheavy"),),
                                              ),

                                              Padding(
                                                padding: const EdgeInsets.only(left: 30),
                                                child: Container(

                                                  width: 230,
                                                  child: Padding(
                                                    padding: const EdgeInsets.all(8.0),
                                                    child: Text(accountNumer,style: TextStyle(fontSize: 12.0,color: Colors.black),),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),



                                      Padding(
                                        padding: const EdgeInsets.only(left: 20.0, top: 5.0),
                                        child: Container(
                                          child: Row(
                                            children: <Widget>[

                                              Padding(
                                                padding: const EdgeInsets.only(right: 10),
                                                child: Text("Bvn Number:",style: TextStyle(fontSize: 12.0,color: Colors.black,fontFamily: "sfprodisplayheavy"),),
                                              ),

                                              Padding(
                                                padding: const EdgeInsets.only(left: 20),
                                                child: Container(

                                                  width: 230,
                                                  child: Padding(
                                                    padding: const EdgeInsets.all(8.0),
                                                    child: Text(bvn,style: TextStyle(fontSize: 12.0,color: Colors.black),),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),

                                      GestureDetector(
                                        onTap: (){
                                          Navigator.push(context, MaterialPageRoute(builder: (context) => Banks()));
                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.only(left: 20.0, top: 5.0),
                                          child: Container(
                                            width: MediaQuery.of(context).size.width,
                                            child: Row(
                                              children: <Widget>[

                                                Padding(
                                                  padding: const EdgeInsets.only(right: 10),
                                                  child: Text("Bank Account",style: TextStyle(fontSize: 12.0,color: Colors.black,fontFamily: "sfprodisplayheavy"),),
                                                ),

                                                Padding(
                                                  padding:
                                                  const EdgeInsets
                                                      .only(
                                                      right:
                                                      10.0,left: 20),
                                                  child:
                                                  new Container(
                                                    width: 110.0,
                                                    child:
                                                    ButtonTheme(
                                                      height: 28.0,
                                                      child:
                                                      RaisedButton(
                                                          onPressed:
                                                              () {
                                                            Navigator.push(
                                                                context,
                                                               new MaterialPageRoute(builder: (context) => Banks()));
                                                            // Navigator.push(context, MaterialPageRoute(builder: (context) => LoginScreen()));
                                                          },
                                                          textColor:
                                                          Colors
                                                              .white,
                                                          color:  Color(
                                                              0xff212435),
                                                          child: const Text(
                                                              'Click Here',
                                                              style:
                                                              TextStyle(fontFamily: "sfprodisplaylight", fontSize: 12.0)),
                                                          shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(5.0))),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),


                                    ],
                                  ),
                                ),
                              ),
                            ),

                          ],
                        ),
                      ),
                    ),


                    Positioned(
                      bottom: 20.0,
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
        ),
      ),
    );
  }
}


