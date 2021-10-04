import 'dart:convert';
import 'dart:io';
import 'package:device_info/device_info.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_paystack/flutter_paystack.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:keyboard_visibility/keyboard_visibility.dart';
import 'package:provider/provider.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:savease/Utils/ZoomScaffoldActivites.dart';
import 'package:savease/Utils/fintnessAppTheme.dart';
import 'package:savease/Utils/menu_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:xml2json/xml2json.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:toast/toast.dart';
import 'package:savease/Activities/AccountOfficer.dart';

import 'Home.dart';


String paystackPublicKey = 'pk_live_95c487e82efab6003e54cbeaa7bcf9bfda683f0f';
String smsPrivateKey = '9Pc1XtdCYg43wdJ6AlbCSCyTlLqc2voEFpl9DvmUq0zcKJTDbdE4aOYOPtzz';
class FundAccount extends StatefulWidget {
  @override
  _HoomeState createState() => new _HoomeState();
}

class _HoomeState extends State<FundAccount> with TickerProviderStateMixin {
  Xml2Json xml2json = new Xml2Json();
  ProgressDialog pr;
  String _pin = "abcd";
  String balance = "";
  var bal;
  String email = "";
  String accountNumer = "";
  String accountName = "";
  String userId = "";
  String cardName = "";
  String cardNumber = "";
  String username = "";
  String cvc = "";
  String amountForApi = "";
  var amount;
  String year;
  String type = "";
  String month ;
  OverlayEntry overlayEntry;
  FocusNode phoneNumberFocusNode = new FocusNode();
  FocusNode amountFocusNode = new FocusNode();
  FocusNode cvcFocusNode = new FocusNode();
  FocusNode mmFocusNode = new FocusNode();
  FocusNode yyFocusNode = new FocusNode();
  FocusNode cardFocusNode = new FocusNode();

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

  MenuController menuController;


  void getData() async{
    final prefs = await SharedPreferences.getInstance();
    double bala = prefs.getDouble('balance') ?? '';
    String  fname = prefs.getString('fname') ?? '';
    String  lname = prefs.getString('lname') ?? '';
    String  em = prefs.getString('email') ?? '';
    String phone = prefs.getString('phone') ?? '';
    String user = prefs.getString('saveaseid') ?? '';
    String userType = prefs.getString('userType') ?? '';
    String usernam = prefs.getString('username') ?? '';


    String balanc = bala.toStringAsFixed(2);

    if(balanc != null || balanc != ""){

        setState(() {
          balance = balanc;
          accountNumer = phone;
          accountName = fname +" "+ lname;
          email = em;
          if (userType == "2"){
            type = "Vendor";
          }else{
            type = "User";
          }
          username = user;
          bal = bala;
          userId = usernam;
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

    amountFocusNode.addListener(() {

      bool hasFocus = amountFocusNode.hasFocus;
      if (hasFocus)
        showOverlay(context);
      else
        removeOverlay();
    });

    cvcFocusNode.addListener(() {

      bool hasFocus = cvcFocusNode.hasFocus;
      if (hasFocus)
        showOverlay(context);
      else
        removeOverlay();
    });

    mmFocusNode.addListener(() {

      bool hasFocus = mmFocusNode.hasFocus;
      if (hasFocus)
        showOverlay(context);
      else
        removeOverlay();
    });

    yyFocusNode.addListener(() {

      bool hasFocus = yyFocusNode.hasFocus;
      if (hasFocus)
        showOverlay(context);
      else
        removeOverlay();
    });

    cardFocusNode.addListener(() {

      bool hasFocus = cardFocusNode.hasFocus;
      if (hasFocus)
        showOverlay(context);
      else
        removeOverlay();
    });
    PaystackPlugin.initialize(publicKey: paystackPublicKey);
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
    final prefs = await SharedPreferences.getInstance();
      pr = new ProgressDialog(context, ProgressDialogType.Normal);
      pr.setMessage("Funding Amount..please wait");
      pr.show();
      String soap = '''<?xml version="1.0" encoding="utf-8"?>
<soap:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">
  <soap:Body>
    <FundAcct xmlns="http://savease.ng/">
      <inuser>${userId}</inuser>
      <App_amt>${amountForApi}</App_amt>
    </FundAcct>
  </soap:Body>
</soap:Envelope>''';

      http.Response response = await http.post(
        'http://savease.ng/webservice1.asmx?op=FundAcct',
        headers: {
          "SOAPAction": "http://savease.ng/FundAcct",
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
      String code = responses['soap:Envelope']['soap:Body']['FundAcctResponse']['FundAcctResult'];
      print(code);

      if(code == "1"){
        pr.hide();
        getBalance();
        sendSms();

      }else {
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

                              SizedBox(
                                    width: MediaQuery.of(context).size.width,
                                    height: MediaQuery.of(context).size.height/1.8,
                                    child: SingleChildScrollView(
                                      physics: AlwaysScrollableScrollPhysics(),
                                      child: Container(
                                        child: Column(
                                          children: <Widget>[

                                            Align(
                                              alignment: Alignment.center,
                                              child: Padding(
                                                padding: const EdgeInsets.only(left: 44.0, top: 5.0,right: 30.0),
                                                child: Text("Fund Account ", style: TextStyle(fontSize: 17.0,fontFamily: "sfprodisplayheavy",color: Colors.black)),
                                              ),
                                            ),
                                            Align(
                                              alignment: Alignment.centerLeft,
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                    right: 20.0, left: 20.0,top: 5),
                                                child: Text(
                                                    "To fund your savease account, kindly provide a valid atm card details and follow the on-screen information",
                                                    style: TextStyle(fontSize: 14.0,fontFamily: "sfprodisplaylight",color: Colors.black),textAlign: TextAlign.center,),
                                              ),
                                            ),


                                            Align(
                                              alignment: Alignment.centerLeft,
                                              child: Padding(
                                                padding: const EdgeInsets.only(left: 44.0,top: 10),
                                                child: Wrap(
                                                  direction: Axis.horizontal,
                                                  children: <Widget>[

                                                    Container(
                                                      width: 30,
                                                      height: 30,

                                                      child: Image.asset("assets/image/bt_ic_amex.png"),
                                                    ),
                                                Container(
                                                width: 30,
                                                height: 30,

                                                child: Image.asset("assets/image/bt_ic_diners_club.png"),
                                              ),
                                                    Container(
                                                      width: 30,
                                                      height: 30,

                                                      child: Image.asset("assets/image/bt_ic_discover.png"),
                                                    ),
                                                    Container(
                                                      width: 30,
                                                      height: 30,

                                                      child: Image.asset("assets/image/bt_ic_hiper.png"),
                                                    ),
                                                    Container(
                                                      width: 30,
                                                      height: 30,

                                                      child: Image.asset("assets/image/bt_ic_hipercard.png"),
                                                    ),
                                                    Container(
                                                      width: 30,
                                                      height: 30,

                                                      child: Image.asset("assets/image/bt_ic_jcb.png"),
                                                    ),
                                                    Container(
                                                      width: 30,
                                                      height: 30,

                                                      child: Image.asset("assets/image/bt_ic_maestro.png"),
                                                    ),
                                                    Container(
                                                      width: 30,
                                                      height: 30,

                                                      child: Image.asset("assets/image/bt_ic_mastercard.png"),
                                                    ),
                                                    Container(
                                                      width: 30,
                                                      height: 30,

                                                      child: Image.asset("assets/image/bt_ic_unionpay.png"),
                                                    ),
                                                    Container(
                                                      width: 30,
                                                      height: 30,

                                                      child: Image.asset("assets/image/bt_ic_visa.png"),
                                                    ),

                                                  ],
                                                ),
                                              ),
                                            ),

                                            Align(
                                              alignment: Alignment.centerLeft,
                                              child: Padding(
                                                padding: const EdgeInsets.only(left: 44.0, top: 15.0,right: 30.0),
                                                child: Text("Card Number", style: TextStyle(fontSize: 14.0,fontFamily: "sfprodisplaylight",color: Colors.black)),
                                              ),
                                            ),

                                            Padding(
                                              padding: const EdgeInsets.only(top: 0),
                                              child: Align(
                                                alignment: Alignment.centerLeft,
                                                child: Padding(
                                                  padding: const EdgeInsets.only(left: 44.0, top: 5.0,right: 30.0),
                                                  child: Theme(
                                                    data: Theme.of(context).copyWith(splashColor: Colors.transparent),
                                                    child: TextField(
                                                      onChanged: (text) {

                                                        setState(() {
                                                           cardNumber = text;
                                                        });
                                                      },
                                                      keyboardType: TextInputType.number,
                                                      focusNode: cardFocusNode,
                                                      autofocus: false,
                                                      style: TextStyle(fontSize: 13.0, color: Colors.black),
                                                      decoration: InputDecoration(
                                                        filled: true,
                                                        fillColor: Color(0xFF7E768CA5),
                                                        hintText: 'Card Number',
                                                        contentPadding:
                                                        const EdgeInsets.only(left: 14.0, bottom: 9.0, top: 10.0),
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
                                            ),


                                           Center(
                                             child: Row(
                                               children: <Widget>[

                                                 Padding(
                                                   padding: const EdgeInsets.only(top: 0),
                                                   child: Column(
                                                   children: <Widget>[
                                                     Align(
                                                       alignment: Alignment.centerLeft,
                                                       child: Padding(
                                                         padding: const EdgeInsets.only(left: 40, top: 10.0,right: 30.0),
                                                         child: Text("Expiry Date", style: TextStyle(fontSize: 14.0,fontFamily: "sfprodisplaylight",color: Colors.black)),
                                                       ),
                                                     ),

                                                     Padding(
                                                       padding: const EdgeInsets.only(top: 0),
                                                       child: Align(
                                                         alignment: Alignment.centerLeft,
                                                         child: Container(
                                                           width: 150,
                                                           child: Padding(
                                                             padding: const EdgeInsets.only(left: 44.0, top: 0.0,right: 30.0),
                                                             child: Theme(
                                                               data: Theme.of(context).copyWith(splashColor: Colors.transparent),
                                                               child: TextField(
                                                                 onChanged: (text) {

                                                                    setState(() {
                                                                      month = text;

                                                                    });

                                                                 },
                                                                 keyboardType: TextInputType.number,
                                                                 focusNode: mmFocusNode,
                                                                 autofocus: false,
                                                                 style: TextStyle(fontSize: 13.0, color: Colors.black),
                                                                 decoration: InputDecoration(
                                                                   filled: true,
                                                                   fillColor: Color(0xFF7E768CA5),
                                                                   hintText: 'MM',
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
                                                       ),
                                                     ),
                                                   ],
                                                   ),
                                                 ),

                                                 Padding(
                                                   padding: const EdgeInsets.only(top: 0),
                                                   child: Column(
                                                     children: <Widget>[
                                                       Align(
                                                         child: Padding(
                                                           padding: const EdgeInsets.only( top: 10.0,right: 30.0),
                                                           child: Text("", style: TextStyle(fontSize: 14.0,fontFamily: "sfprodisplaylight",color: Colors.black)),
                                                         ),
                                                       ),

                                                       Padding(
                                                         padding: const EdgeInsets.only(top: 0),
                                                         child: Align(
                                                           alignment: Alignment.centerLeft,
                                                           child: Container(
                                                             width: 150,
                                                             child: Padding(
                                                               padding: const EdgeInsets.only(left: 44.0, top: 0.0,right: 30.0),
                                                               child: Theme(
                                                                 data: Theme.of(context).copyWith(splashColor: Colors.transparent),
                                                                 child: TextField(
                                                                   onChanged: (text) {
                                                                     setState(() {

                                                                       year = text;

                                                                     });


                                                                   },
                                                                   keyboardType: TextInputType.number,
                                                                   focusNode: yyFocusNode,
                                                                   autofocus: false,
                                                                   style: TextStyle(fontSize: 13.0, color: Colors.black),
                                                                   decoration: InputDecoration(
                                                                     filled: true,
                                                                     fillColor: Color(0xFF7E768CA5),
                                                                     hintText: 'YY',
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
                                                         ),
                                                       ),
                                                     ],
                                                   ),
                                                 ),

                                               ],
                                             ),
                                           ),


                                            Align(
                                              alignment: Alignment.centerLeft,
                                              child: Padding(
                                                padding: const EdgeInsets.only(left: 44.0, top: 10.0,right: 30.0),
                                                child: Text("CVC", style: TextStyle(fontSize: 14.0,fontFamily: "sfprodisplaylight",color: Colors.black)),
                                              ),
                                            ),

                                            Padding(
                                              padding: const EdgeInsets.only(top: 0),
                                              child: Align(
                                                alignment: Alignment.centerLeft,
                                                child: Padding(
                                                  padding: const EdgeInsets.only(left: 44.0, top: 0.0,right: 30.0),
                                                  child: Theme(
                                                    data: Theme.of(context).copyWith(splashColor: Colors.transparent),
                                                    child: TextField(
                                                      onChanged: (text) {
                                                        setState(() {
                                                          cvc = text;
                                                        });

                                                      },
                                                      keyboardType: TextInputType.number,
                                                      focusNode: cvcFocusNode,
                                                      autofocus: false,
                                                      obscureText: true,
                                                      style: TextStyle(fontSize: 13.0, color: Colors.black),
                                                      decoration: InputDecoration(
                                                        filled: true,
                                                        fillColor: Color(0xFF7E768CA5),
                                                        hintText: 'CVC',
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
                                            ),


                                            Padding(
                                              padding: const EdgeInsets.only(top: 0),
                                              child: Align(
                                                alignment: Alignment.centerLeft,
                                                child: Padding(
                                                  padding: const EdgeInsets.only(left: 44.0, top: 15.0,right: 30.0),
                                                  child: Theme(
                                                    data: Theme.of(context).copyWith(splashColor: Colors.transparent),
                                                    child: TextField(
                                                      onChanged: (text) {

                                                        var amounts = int.parse(text);
                                                        var newAmount = amounts * 100;

                                                        setState(() {
                                                          amount = newAmount;
                                                          amountForApi = text;
                                                        });
                                                      },
                                                      keyboardType: TextInputType.number,
                                                      focusNode: amountFocusNode,
                                                      autofocus: false,
                                                      style: TextStyle(fontSize: 13.0, color: Colors.black),
                                                      decoration: InputDecoration(
                                                        filled: true,
                                                        fillColor: Color(0xFF7E768CA5),
                                                        hintText: 'Amount',
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
                                            ),

                                            Align(
                                              alignment: Alignment.center,
                                              child: Padding(
                                                padding:  EdgeInsets.only(left: 44.0, top: 25.0,right: 30.0,bottom: MediaQuery.of(context).viewInsets.bottom,),
                                                child: Container(
                                                  width: 70.0,
                                                  child: ButtonTheme(
                                                    minWidth: 70.0,
                                                    height: 40.0,

                                                    child :  RaisedButton(
                                                        onPressed: () {
                                                          fundAccount();
                                                          // Navigator.push(context, MaterialPageRoute(builder: (context) => LoginScreen()));
                                                        },
                                                        textColor: Colors.white,
                                                        color: Color(0xffFA9928),
                                                        child: const Text('Fund',style: TextStyle(fontFamily: "sfprodisplaybold")),
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

  void fundAccount() {

    if(cardNumber.isEmpty || cvc.isEmpty || cvc == "" || amountForApi.isEmpty || amountForApi == ""|| year.isEmpty || month.isEmpty){
      Toast.show("card not found, please enter card details", context, duration: Toast.LENGTH_LONG, gravity:  Toast.BOTTOM);
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => Home()));
    }else {
      pr = new ProgressDialog(context, ProgressDialogType.Normal);
      pr.setMessage("Funding Account..please wait");
      pr.show();
      Charge charge = Charge();

      var yr = int.parse(year);
      var mn = int.parse(month);
      charge
        ..card = PaymentCard(number: cardNumber, cvc: cvc, expiryMonth: mn, expiryYear: yr)
        ..amount = amount
        ..email = email
        ..reference = _getReference()
        ..putCustomField('Charged From', 'Savease');

      PaystackPlugin.chargeCard(context,
          charge: charge,
          beforeValidate: (transaction) {

          },
          onSuccess: (transaction) {

            if(transaction.message == "success"){
              pr.hide();
              getlogin();
            }else{

              pr.hide();
              getlogin();
            }

          },
          onError: (error, transaction) {
            if (error is AuthenticationException) {
              pr.hide();
              getlogin();
              Alert(
                  context: context,
                  title: "Failed",
                  desc: "Failed to authenticate your card please, try again",
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
              return;
            } else if (error is InvalidAmountException) {
              pr.hide();
              Alert(
                  context: context,
                  title: "Failed",
                  desc: "Invalid amount enter please enter a valid amount and try again",
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
              return;
            } else if (error is InvalidEmailException) {
              pr.hide();
              Alert(
                  context: context,
                  title: "Failed",
                  desc: "Invalid email entered please try again",
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
              return;
            } else if (error is CardException) {
              pr.hide();
              Alert(
                  context: context,
                  title: "Failed",
                  desc: "Card not valid, try again",
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
              return;
            } else if (error is ChargeException) {
              pr.hide();
              Alert(
                  context: context,
                  title: "Failed",
                  desc: "Failed to charge card, please try again",
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
              return;
            } else if (error is PaystackException) {
              pr.hide();
              Alert(
                  context: context,
                  title: "Failed",
                  desc: "Paystack is currently not available, please try again",
                  image: Image.asset("assets/image/sad.png"),
                  buttons: [
                    DialogButton(
                      onPressed: () =>
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) => Home())),
                      child: Text(
                        "Ok",
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                    )
                  ]
              ).show();

            } else if (error is PaystackSdkNotInitializedException) {
              pr.hide();
              Alert(
                  context: context,
                  title: "Failed",
                  desc: "paystack not initialized, try again",
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
              return;
            }else if (error is ProcessException){
              pr.hide();
              Alert(
                  context: context,
                  title: "Failed",
                  desc: "A transaction is currently processing, please wait till it concludes before attempting a new charge.",
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

              return;
            }
          });
    }

  }

  String _getReference() {
    String platform;
    if (Platform.isIOS) {
      platform = 'iOS';
    } else {
      platform = 'Android';
    }

    return 'ChargedFrom${platform}_${DateTime.now().millisecondsSinceEpoch}';
  }


  getBalance() async {
    final prefs = await SharedPreferences.getInstance();
      String soap = '''<?xml version="1.0" encoding="utf-8"?>
<soap:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">
  <soap:Body>
    <getBalance xmlns="http://savease.ng/">
      <straccountNo>${username}</straccountNo>
    </getBalance>
  </soap:Body>
</soap:Envelope>''';

      http.Response response = await http.post(
        'http://savease.ng/webservice1.asmx?op=getBalance',
        headers: {
          "SOAPAction": "http://savease.ng/getBalance",
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
      final list = responses['soap:Envelope']['soap:Body']['getBalanceResponse']['getBalanceResult'];
      List code = jsonDecode(list);
      print(code[0]['balance']);
      prefs.setDouble('balance',code[0]['balance']);
      prefs.setString('fname',code[0]['fname']);
      prefs.setString('lname',code[0]['lname']);
      prefs.setString('phone',code[0]['phone']);
      prefs.setString('email',code[0]['email']);
      prefs.setString('saveaseid',code[0]['saveaseID']);

      setState(() {
        balance = code[0]['balance'].toStringAsFixed(2);
        accountName = code[0]['fname'] +" "+ code[0]['lname'];
        accountNumer = code[0]['phone'];
      });




  }

  sendSms() async {
    var now = new DateTime.now();
    var a = double.parse(amountForApi);
    String newString = username.substring(0, 3) + "XXXX" + username.substring(3+4);
    var e = bal - a;
    String b = e.toStringAsFixed(2);

    String time = new DateFormat("dd-MM-yyyy").format(now);

    final response =
    await http.get('https://www.bulksmsnigeria.com/api/v1/sms/create?api_token=${smsPrivateKey}&from=SAVEASE&to=0${accountNumer}&body=Your Acct ${newString} Has Been Credited with NGN"${amountForApi} On ${time} By SAVEASE FUNDACCOUNT - (Transaction Ref) Bal: +NGN${b}CR&dnd=2');

    if (response.statusCode == 200) {
      // If server returns an OK response, parse the JSON.
      if (response.body != null){

        print(response.body);
        Navigator.push(context, MaterialPageRoute(builder: (context) => Home()));

      }else{
        Toast.show("There was a trouble recieve sms alert now", context, duration: Toast.LENGTH_LONG, gravity:  Toast.BOTTOM);

      }

    } else {
      // If that response was not OK, throw an error.
      throw Exception('Failed to load post');
    }
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
