import 'dart:convert';
import 'package:device_info/device_info.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:savease/Activities/AccountOfficer.dart';
import 'package:savease/Utils/ZoomScaffoldActivites.dart';
import 'package:savease/Utils/fintnessAppTheme.dart';
import 'package:savease/Utils/menu_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:xml2json/xml2json.dart';
import 'package:progress_dialog/progress_dialog.dart';




String smsPrivateKey = '9Pc1XtdCYg43wdJ6AlbCSCyTlLqc2voEFpl9DvmUq0zcKJTDbdE4aOYOPtzz';
class TransactionStatement extends StatefulWidget {
  @override
  _HoomeState createState() => new _HoomeState();
}



class _HoomeState extends State<TransactionStatement> with TickerProviderStateMixin {
  Xml2Json xml2json = new Xml2Json();
  ProgressDialog pr;
  String cardamount = "";
  String balance = "";
  var qty;
  var bal;
  String email = "";
  String accountNumer = "";
  String accountName = "";
  String cardName = "";
  String cardNumber = "";
  String username = "";
  String userId;
  String cvc = "";
  String amountForApi = "";
  var amount;
  var year;
  var month ;
  var list = [];
  String type = "";

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

  MenuController menuController;


  void getData() async{
    final prefs = await SharedPreferences.getInstance();
    double bala = prefs.getDouble('balance') ?? '';
    String  fname = prefs.getString('fname') ?? '';
    String  lname = prefs.getString('lname') ?? '';
    String  em = prefs.getString('email') ?? '';
    String phone = prefs.getString('phone') ?? '';
    String user = prefs.getString('saveaseid') ?? '';
    String usernam = prefs.getString('username') ?? '';
    String userType = prefs.getString('userType') ?? '';

    String balanc = bala.toStringAsFixed(2);

    if(balanc != null || balanc != ""){
      setState(() {
        balance = balanc;
        accountNumer = phone;
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
  @override
  void initState() {
    isIpad();
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

  getlogin() async {
    print(userId);
    String soap = '''<?xml version="1.0" encoding="utf-8"?>
<soap:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">
  <soap:Body>
    <getTransactionUsers xmlns="http://savease.ng/">
      <uname>${userId}</uname>
    </getTransactionUsers>
  </soap:Body>
</soap:Envelope>''';

    http.Response response = await http.post(
      'http://savease.ng/webservice1.asmx?op=getTransactionUsers',
      headers: {
        "SOAPAction": "http://savease.ng/getTransactionUsers",
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
    final lists = responses['soap:Envelope']['soap:Body']['getTransactionUsersResponse']['getTransactionUsersResult'];

    setState(() {
      list = jsonDecode(lists);
      print(list[0]);

    });

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset : false,
        body: ChangeNotifierProvider(
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
                            Container(
                              child: Flexible(

                                child: ListView.builder(
                                    scrollDirection: Axis.vertical,
                                    itemCount: list.length,
                                    itemBuilder: (BuildContext ctxt, int index){
                                      var type = "";
                                      var my_color_variable = Colors.redAccent;

                                      if(list[index]["credit"] == "0"){
                                        type = list[index]["debit"];
                                        my_color_variable = Colors.redAccent;
                                      }else if(list[index]["debit"] == "0"){
                                        type = list[index]["credit"];
                                        my_color_variable = Colors.greenAccent;
                                      }
                                      return Container(
                                        child: Card(
                                          elevation: 9.0,
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Column(
                                              children: <Widget>[
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: <Widget>[
                                                    Text(
                                                        list[index]["TransactionDate"],
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
                                                    Text(
                                                        list[index]["AccountNo"],
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
                                                  ],
                                                ),
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: <Widget>[
                                                    Text(
                                                        list[index]["TransactionType"],
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
                                                    Text(
                                                        type,
                                                        style: TextStyle(
                                                            fontFamily:
                                                            "sfprodisplaylight",
                                                            fontSize:
                                                            13.0,
                                                            fontWeight:
                                                            FontWeight
                                                                .bold,
                                                            color: my_color_variable)),

                                                  ],
                                                ),
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: <Widget>[
                                                    Text(
                                                        list[index]["SenderName"],
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
                                                    Text(
                                                       "Ref: ${list[index]["RefNumber"]}",
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
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      );
                                    }),
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
        ));
  }


}
