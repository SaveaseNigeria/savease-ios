import 'dart:convert';
import 'package:device_info/device_info.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mailer/flutter_mailer.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:savease/Utils/ZoomScaffoldActivites.dart';
import 'package:savease/Utils/fintnessAppTheme.dart';
import 'package:savease/Utils/menu_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:xml2json/xml2json.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:toast/toast.dart';



String smsPrivateKey = '9Pc1XtdCYg43wdJ6AlbCSCyTlLqc2voEFpl9DvmUq0zcKJTDbdE4aOYOPtzz';
class AccountOfficer extends StatefulWidget {
  @override
  _HoomeState createState() => new _HoomeState();
}

class _HoomeState extends State<AccountOfficer> with TickerProviderStateMixin {

  Xml2Json xml2json = new Xml2Json();
  ProgressDialog pr;
  String cardamount = "";
  String balance = "";
  var qty;
  var bal;
  String email = "";
  String accountNumer = "";
  String accountName = "";
  String message = "";
  String accountOfficerEmail = "Email";
  String accountOfficerNumber = "Phone number";
  String accountOfficerName = "Name";
  String cardName = "";
  String cardNumber = "";
  String username = "";
  String userId;
  String cvc = "";
  String amountForApi = "";
  var amount;
  var year;
  String type = "";
  var month ;
  List code = [];
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
  sendEmail() async {

    if(message.isEmpty || message == "" ){
      Toast.show("Please fill required field to continue", context, duration: Toast.LENGTH_LONG, gravity:  Toast.BOTTOM);

    }else{

      final MailOptions mailOptions = MailOptions(
        body: '${message}',
        subject: 'Inquiry',
        recipients: ['${accountOfficerEmail}'],
        isHTML: true,
        ccRecipients: ['escalate@savease.ng'],

      );

      await FlutterMailer.send(mailOptions);
    }
  }
  sendEmailToOfficer() async {
      final MailOptions mailOptions = MailOptions(
        body: '',
        subject: 'Inquiry',
        recipients: ['${accountOfficerEmail}'],
        isHTML: true,
        ccRecipients: ['escalate@savease.ng'],

      );

      await FlutterMailer.send(mailOptions);

  }
  void getData() async{
    final prefs = await SharedPreferences.getInstance();
    double bala = prefs.getDouble('balance') ?? '';
    String  fname = prefs.getString('fname') ?? '';
    String  lname = prefs.getString('lname') ?? '';
    String  em = prefs.getString('email') ?? '';
    String phone = prefs.getString('phone') ?? '';
    String user = prefs.getString('saveaseid') ?? '';
    String usernam = prefs.getString('username') ?? '';

    String balanc = bala.toStringAsFixed(2);
    String userType = prefs.getString('userType') ?? '';

    if(balanc != null || balanc != ""){


      setState(() {
        balance = balanc;
        accountNumer = user;
        accountName = fname +" "+ lname;
        email = em;
        username = user;
        userId = usernam;
        bal = bala;
        if (userType == "2"){
          type = "Vendor";
        }else{
          type = "User";
        }

        getlogin();
      });

    }else{
      balance = "";
      accountName = "";
      accountNumer = "";
    }


  }

  void whatsAppOpen() async {
    var whatsappUrl ="whatsapp://send?phone=$accountOfficerNumber";
    await canLaunch(whatsappUrl)? launch(whatsappUrl):print("open whatsapp app link or do a snackbar with notification that there is no whatsapp installed");
  }
  @override
  void initState() {
    isIpad();
    getData();
    super.initState();
    menuController = new MenuController(
      vsync: this,
    )..addListener(() => setState(() {}));
  }




  getlogin() async {
      print(username);
      String soap = '''<?xml version="1.0" encoding="utf-8"?>
<soap:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">
  <soap:Body>
    <getAcctOfficer xmlns="http://savease.ng/">
      <saveaseID>${username}</saveaseID>
    </getAcctOfficer>
  </soap:Body>
</soap:Envelope>''';

      http.Response response = await http.post(
        'http://savease.ng/webservice1.asmx?op=getAcctOfficer',
        headers: {
          "SOAPAction": "http://savease.ng/getAcctOfficer",
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
      final list = responses['soap:Envelope']['soap:Body']['getAcctOfficerResponse']['getAcctOfficerResult'];
      code = jsonDecode(list);
      print(code[0]['phone']);
      setState(() {
       accountOfficerEmail = code[0]['emailID'];
       accountOfficerName = code[0]['firstName'] +" "+ code[0]['surName'];
       accountOfficerNumber = code[0]['Phone'];
      });

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
                                    child:  Stack(
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
                                                                    username,
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
                                  ),
                                ],
                              ),
                              SingleChildScrollView(
                                child: SizedBox(
                                  width: MediaQuery.of(context).size.width,
                                  height: MediaQuery.of(context).size.height/1.8,
                                  child: Padding(
                                    padding: const EdgeInsets.only(bottom: 40),
                                    child: SingleChildScrollView(
                                      physics: AlwaysScrollableScrollPhysics(),
                                      child: Container(
                                        child: Column(
                                          children: <Widget>[

                                            Align(
                                              alignment: Alignment.center,
                                              child: Padding(
                                                padding: const EdgeInsets.only(left: 44.0, top: 15.0,right: 30.0),
                                                child: Text("Account Officer ", style: TextStyle(fontSize: 17.0,fontFamily: "sfprodisplayheavy",color: Colors.black)),
                                              ),
                                            ),


                                            Align(
                                              alignment: Alignment.centerRight,
                                              child: Padding(
                                                padding: const EdgeInsets.only(right: 10,top: 20),
                                                child: Text(
                                                    accountOfficerName,
                                                    style: TextStyle(
                                                        fontFamily:
                                                        "sfprodisplaylight",
                                                        fontSize:
                                                        13.0,
                                                        fontWeight:
                                                        FontWeight
                                                            .bold,
                                                        color: Color(
                                                            0xff212435))),
                                              ),
                                            ),



                                            GestureDetector(
                                              onTap: () {
                                                launch("tel://${accountOfficerNumber}");
                                              },
                                              child: Padding(
                                                padding: const EdgeInsets.only(top: 15,left: 20),
                                                child: Container(
                                                  width: MediaQuery.of(context).size.width,
                                                  child: Row(
                                                    mainAxisSize: MainAxisSize.min,
                                                    children: <Widget>[
                                                    Icon(
                                                    Icons.phone,color: Colors.black,size:25,),
                                                      Padding(
                                                        padding: const EdgeInsets.only(left: 10),
                                                        child: Text(accountOfficerNumber, style: TextStyle(fontSize: 15.0,fontFamily: "sfprodisplaylight",color: Colors.black)),
                                                      ),

                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                            GestureDetector(
                                              onTap: () {
                                                whatsAppOpen();
                                              },
                                              child: Padding(
                                                padding: const EdgeInsets.only(top: 15,left: 20),
                                                child: Container(
                                                  width: MediaQuery.of(context).size.width,
                                                  child: Row(
                                                    mainAxisSize: MainAxisSize.min,
                                                    children: <Widget>[
                                                      Container(
                                                        width: 25,
                                                        height: 25,
                                                        child: Image.asset(
                                                            "assets/image/whatsapp.png"),
                                                      ),
                                                      Padding(
                                                        padding: const EdgeInsets.only(left: 10),
                                                        child: Text(accountOfficerNumber, style: TextStyle(fontSize: 15.0,fontFamily: "sfprodisplaylight",color: Colors.black)),
                                                      ),

                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                            GestureDetector(
                                              onTap: () {
                                                sendEmailToOfficer();
                                              },
                                              child: Padding(
                                                padding: const EdgeInsets.only(top: 15,left: 20),
                                                child: Container(
                                                  width: MediaQuery.of(context).size.width,
                                                  child: Row(
                                                    mainAxisSize: MainAxisSize.min,
                                                    children: <Widget>[
                                                      Icon(
                                                        Icons.mail_outline,color: Colors.black,size:25,),
                                                      Padding(
                                                        padding: const EdgeInsets.only(left: 10),
                                                        child: Text(accountOfficerEmail, style: TextStyle(fontSize: 15.0,fontFamily: "sfprodisplaylight",color: Colors.black)),
                                                      ),

                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Align(
                                              alignment: Alignment.centerLeft,
                                              child: Padding(
                                                padding: const EdgeInsets.only(left: 25,top: 30),
                                                child: Text(
                                                    accountName,
                                                    style: TextStyle(
                                                        fontFamily:
                                                        "sfprodisplaylight",
                                                        fontSize:
                                                        14.0,
                                                        fontWeight:
                                                        FontWeight
                                                            .bold,
                                                        color: Color(
                                                            0xff212435))),
                                              ),
                                            ),

                                            Align(
                                              alignment: Alignment.centerLeft,
                                              child: Padding(
                                                padding: const EdgeInsets.only(left: 25,top: 10,right: 25),
                                                child: Text(
                                                    "Kindly drop a message in the box below and I will contact back, you could call or have a live chat with the number above.",
                                                    style: TextStyle(
                                                        fontFamily:
                                                        "sfprodisplaylight",
                                                        fontSize:
                                                        14.0,
                                                        fontWeight:
                                                        FontWeight
                                                            .bold,
                                                        color: Color(
                                                            0xff212435))),
                                              ),
                                            ),

                                            Align(
                                              alignment: Alignment.centerLeft,
                                              child: SizedBox(
                                                child: Padding(
                                                  padding: const EdgeInsets.only(
                                                      left: 25.0,
                                                      top: 10.0,
                                                      right: 25.0),
                                                  child: Theme(
                                                    data: Theme.of(context).copyWith(
                                                        splashColor:
                                                        Colors.transparent),
                                                    child: TextField(
                                                      keyboardType:
                                                      TextInputType.multiline,
                                                      maxLines: 3,
                                                      onChanged: (text) {
                                                        setState(() {
                                                          message = text;
                                                        });
                                                      },
                                                      autofocus: false,
                                                      style: TextStyle(
                                                          fontSize: 13.0,
                                                          color: Colors.black),
                                                      decoration: InputDecoration(
                                                        filled: true,
                                                        fillColor: Color(0xFF7E768CA5),
                                                        hintText: 'Enter Message',
                                                        contentPadding:
                                                        const EdgeInsets.only(
                                                            left: 10.0,
                                                            bottom: 20.0,
                                                            top: 25.0,
                                                            right: 10),
                                                        focusedBorder:
                                                        OutlineInputBorder(
                                                          borderSide: BorderSide(
                                                              color:
                                                              Color(0xFF7E768CA5)),
                                                          borderRadius:
                                                          BorderRadius.circular(
                                                              10.0),
                                                        ),
                                                        enabledBorder:
                                                        UnderlineInputBorder(
                                                          borderSide: BorderSide(
                                                              color:
                                                              Color(0xFF7E768CA5)),
                                                          borderRadius:
                                                          BorderRadius.circular(
                                                              10.0),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),


                                            Align(
                                              alignment: Alignment.center,
                                              child: Padding(
                                                padding: const EdgeInsets.only(left: 44.0, top: 20.0,right: 30.0),
                                                child: Container(
                                                  width: 100.0,
                                                  child: ButtonTheme(
                                                    minWidth: 100.0,
                                                    height: 40.0,

                                                    child :  RaisedButton(
                                                        onPressed: () {
                                                          sendEmail();
                                                          // Navigator.push(context, MaterialPageRoute(builder: (context) => LoginScreen()));
                                                        },
                                                        textColor: Colors.white,
                                                        color: Color(0xffFA9928),
                                                        child: const Text('Send',style: TextStyle(fontFamily: "sfprodisplaybold")),
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
                              ),

                            ],
                          ),
                        ),
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
          ),
        ));
  }


}
