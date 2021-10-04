import 'dart:convert';
import 'package:barcode_scan/barcode_scan.dart';
import 'package:device_info/device_info.dart';
import 'package:dropdown_banner/dropdown_banner.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:keyboard_visibility/keyboard_visibility.dart';
import 'package:location/location.dart';
import 'package:pinput/pin_put/pin_put.dart';
import 'package:provider/provider.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:savease/Activities/About.dart';
import 'package:savease/Activities/BuyVoucher.dart';
import 'package:savease/Activities/Complaint.dart';
import 'package:savease/Activities/GenerateScreen.dart';
import 'package:savease/Activities/Home.dart';
import 'package:savease/Activities/Profile.dart';
import 'package:savease/Activities/Transfer.dart';
import 'package:savease/Activities/VendorsAround.dart';
import 'package:savease/Activities/Withdraw.dart';
import 'package:savease/Model/UserLocation.dart';
import 'package:savease/Utils/ZoomScaffold.dart';
import 'package:savease/Utils/fintnessAppTheme.dart';
import 'package:savease/Utils/menu_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:xml2json/xml2json.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:savease/Activities/VerifyHome.dart';
import 'package:savease/Activities/FundAccount.dart';
import 'package:toast/toast.dart';
import 'package:savease/Activities/AccountOfficer.dart';
import 'package:savease/Activities/TransactionStatement.dart';
import 'package:savease/Activities/VoucherTable.dart';
import 'package:savease/Activities/FAQ.dart';
import 'package:savease/Activities/UserGuide.dart';
import 'package:savease/Auth/AuthWelcome.dart';
import 'package:savease/Utils/SlideRightRoute.dart';
String smsPrivateKey = '9Pc1XtdCYg43wdJ6AlbCSCyTlLqc2voEFpl9DvmUq0zcKJTDbdE4aOYOPtzz';
class VendorHome extends StatefulWidget {
  @override
  _HoomeState createState() => new _HoomeState();
}

class _HoomeState extends State<VendorHome> with TickerProviderStateMixin {
  String barcode = "";
  var info = [];

  var scr= new GlobalKey();
  var databaseRef;

  String cardamount = "";
  String balance = "";
  bool _isVisible = false;
  bool _isVisiblesavease = true;
  bool _isVisibledefalut = false;
  String bvnNumber;
  var qty;
  var bal;
  String email = "";
  String accountNumer = "";
  String accountName = "";
  String cardName = "";
  String userAccountNumber = "";
  String cardNumber = "";
  String username = "";
  String cardPin = "";
  String narration = "";
  String userId;
  String cvc = "";
  String amountForApi = "";
  String amount = "";
  String accountType ;
  String accountNam = "";
  String bvn = "";
  String pinCode = "";
  String firstName;
  String lastName;
  String type = "";
  String phoneNum;
  String transRef;
  var year;
  var month ;
  Xml2Json xml2json = new Xml2Json();
  ProgressDialog pr;
  String _pin = "abcd";
  String rect = "assets/image/rect.png";
  String userid;
  MenuController menuController;
  var _scaffoldKey = new GlobalKey<ScaffoldState>();


  UserLocation _currentLocation;
  var location = Location();


  bool _value2 = false;
  FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  final navigatorKey = GlobalKey<NavigatorState>();

  void _onChanged2(bool value){
    setState(() {
      _value2 = value;

     updateLocation();

    });

  }
  OverlayEntry overlayEntry;
  FocusNode phoneNumberFocusNode = new FocusNode();
  FocusNode phoneNumberFocusNodeTwo = new FocusNode();
  FocusNode phoneNumberFocusNodeThree = new FocusNode();

  FocusNode accountNumberFocusNode = new FocusNode();
  FocusNode amountFocusNode = new FocusNode();

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
    //  databaseRef = FirebaseDatabase.instance.reference();
    final prefs = await SharedPreferences.getInstance();
    double bala = prefs.getDouble('balance') ?? '';
    String  fname = prefs.getString('fname') ?? '';
    String  lname = prefs.getString('lname') ?? '';
    String  em = prefs.getString('email') ?? '';
    String phone = prefs.getString('phone') ?? '';

    String user = prefs.getString('saveaseid') ?? '';
    String usernam = prefs.getString('username') ?? '';
    String bvnStat = prefs.getString('bvnstatus') ?? '';
    String userType = prefs.getString('userType') ?? '';


    String balanc = bala.toStringAsFixed(2);

    if(balanc != null || balanc != ""){

      setState(() {
        balance = balanc;
        accountNumer = user;
        accountName = fname +" "+ lname;
        email = em;
        username = user;
        userId = usernam;
        bal = bala;
        bvn =  bvnStat;
        phoneNum = phone;
        firstName = fname;
        lastName = lname;
        if (userType == "2"){
          type = "Vendor";
        }else{
          type = "User";
        }
        //  print(bvnStat);

      });

    }else{
      balance = "";
      accountName = "";
      accountNumer = "";
    }


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
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  decoration: BoxDecoration(

                    image: DecorationImage(
                      image: AssetImage("assets/image/bne.png"),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(top: 100),
                    child: Visibility(
                        visible: _isVisiblesavease,
                        child: Container(
                          child: Column(
                            children: <Widget>[

                              Padding(
                                padding: const EdgeInsets.only(left: 44.0, top: 10.0),
                                child: Container(
                                  child: Row(
                                    children: <Widget>[

                                      Text("Account Number :",style: TextStyle(fontSize: 12.0,color: Colors.black),),

                                      Padding(
                                        padding: const EdgeInsets.only(left: 10),
                                        child: Text(info[2]??' ',style: TextStyle(fontSize: 12.0,color: Colors.black),),
                                      ),
                                    ],
                                  ),
                                ),
                              ),

                              Padding(
                                padding: const EdgeInsets.only(left: 44.0, top: 10.0),
                                child: Container(
                                  child: Row(
                                    children: <Widget>[

                                      Text("Account Name :",style: TextStyle(fontSize: 12.0,color: Colors.black),),

                                      Padding(
                                        padding: const EdgeInsets.only(left: 10),
                                        child: Text(info[1]??' ',style: TextStyle(fontSize: 12.0,color: Colors.black),),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 34.0, top: 25.0,right: 30.0),
                                  child: Theme(
                                    data: Theme.of(context).copyWith(splashColor: Colors.transparent),
                                    child: TextField(
                                      keyboardType: TextInputType.number,
                                      focusNode: amountFocusNode,
                                      onChanged: (text) {

                                        if(text.isEmpty || text == ""){

                                        }else{
                                          setState(() {
                                            amount = text;
                                            amountForApi = text;
                                          });
                                        }
                                      },
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

                              Align(
                                alignment: Alignment.centerLeft,
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 34.0, top: 20.0,right: 30.0),
                                  child: Theme(
                                    data: Theme.of(context).copyWith(splashColor: Colors.transparent),
                                    child: TextField(
                                      onChanged: (text) {

                                        if(text.isEmpty || text == ""){


                                        }else{
                                          setState(() {
                                            narration = text;
                                          });
                                        }

                                      },
                                      keyboardType: TextInputType.text,
                                      autofocus: false,
                                      style: TextStyle(fontSize: 13.0, color: Colors.black),
                                      decoration: InputDecoration(
                                        filled: true,
                                        fillColor: Color(0xFF7E768CA5),
                                        hintText: 'Narration',
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

                              Padding(
                                padding: const EdgeInsets.only(left: 44.0, top: 10.0,right: 10),
                                child: Container(
                                  child: Row(
                                    children: <Widget>[

                                      Text("Pin Code : ",style: TextStyle(fontSize: 12.0,color: Colors.black),),

                                      SizedBox(
                                        width: 200,
                                        height: 50,
                                        child: Padding(
                                          padding: const EdgeInsets.only(),
                                          child: PinPut(
                                            autoFocus: false,
                                            keyboardType: TextInputType.number,
                                            isTextObscure: true,
                                            actionButtonsEnabled: false,
                                            fieldsCount: 4,
                                            onSubmit: (String pin) {
                                              setState(() {
                                                pinCode = pin;
                                              });
                                            },
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),

                              Padding(
                                padding: const EdgeInsets.only(left: 34.0, bottom: 9.0, top: 8.0),
                                child: Text("*Please, do not disclosure your secret pin to anyone ",style: TextStyle(fontSize: 12.0,color: Colors.black),),
                              ),
                              Align(
                                alignment: Alignment.center,
                                child: Padding(
                                  padding:  EdgeInsets.only(left: 34.0, top: 25.0,right: 30.0,bottom: MediaQuery.of(context).viewInsets.bottom,),
                                  child: Container(
                                    width: 100.0,
                                    child: ButtonTheme(
                                      minWidth: 60.0,
                                      height: 40.0,

                                      child :  RaisedButton(
                                          onPressed: () {
                                            if(bvn == "false"){
                                              showDialog(
                                                context: context,
                                                builder: (_) => _showVerifyBvn(context),
                                              );

                                            }else{

                                              if(userAccountNumber == username){

                                                Alert(
                                                    context: context,
                                                    title: "Failed",
                                                    desc: "Can not transfer to yourself",
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

                                              }else{
                                                if (amount.isEmpty){
                                                  Toast.show("Please enter amount to make transfer", context, duration: Toast.LENGTH_LONG, gravity:  Toast.BOTTOM);
                                                }else{
                                                  var one = int.parse(amount);
                                                  if(bal < one ){
                                                    Alert(
                                                        context: context,
                                                        title: "Failed",
                                                        desc: "Insufficient funds",
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
                                                  }else {
                                                    getTransferPin();
                                                  }
                                                }

                                              }

                                            }

                                            // Navigator.push(context, MaterialPageRoute(builder: (context) => LoginScreen()));
                                          },
                                          textColor: Colors.white,
                                          color: Color(0xffFA9928),
                                          child: const Text('Continue',style: TextStyle(fontFamily: "sfprodisplaylight",fontSize: 11)),
                                          shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(10.0))
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                    ),
                  ),
                ),
              ),
            ),
          ),//
          // Show your Image
          Align(
            alignment: Alignment.topRight,
            child: RaisedButton.icon(
                color: Theme.of(context).accentColor,
                textColor: Colors.white,
                onPressed: () => Navigator.pop(context),
                icon: Icon(
                  Icons.close,
                  color: Colors.white,
                ),
                label: Text('Close')),
          ),
        ],
      ),
    );
  }
  void showInSnackBar(String value) {
    Toast.show(value, context, duration: Toast.LENGTH_LONG, gravity:  Toast.BOTTOM);
  }

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

    phoneNumberFocusNodeTwo.addListener(() {

      bool hasFocus = phoneNumberFocusNodeTwo.hasFocus;
      if (hasFocus)
        showOverlay(context);
      else
        removeOverlay();
    });

    accountNumberFocusNode.addListener(() {

      bool hasFocus = accountNumberFocusNode.hasFocus;
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

    phoneNumberFocusNodeThree.addListener(() {

      bool hasFocus = phoneNumberFocusNodeThree.hasFocus;
      if (hasFocus)
        showOverlay(context);
      else
        removeOverlay();
    });


    firebaseCloudMessaging_Listeners();
    isIpad();
    databaseRef = FirebaseDatabase.instance.reference();
    getData();
    super.initState();
    menuController = new MenuController(
      vsync: this,

    );
  }

  @override
  void dispose() {
    menuController.dispose();
    super.dispose();
  }

  getlogin() async {
    final prefs = await SharedPreferences.getInstance();
    if (_pin.isEmpty || _pin == "") {
      Toast.show("Please enter a valid voucher pin to verify", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
    } else {
      SpinKitPulse(
          color: Colors.white);
    showInSnackBar("Refreshing Details... please wait");
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
      var json =
          xml2json.toParker(); // the only method that worked for my XML type.
      var responses = jsonDecode(json);
      final list = responses['soap:Envelope']['soap:Body']['getBalanceResponse']
          ['getBalanceResult'];
      List code = jsonDecode(list);
      print(code[0]['balance']);
      prefs.setDouble('balance', code[0]['balance']);
      prefs.setString('fname', code[0]['fname']);
      prefs.setString('lname', code[0]['lname']);
      prefs.setString('phone', code[0]['phone']);
      prefs.setString('email', code[0]['email']);
      prefs.setString('saveaseid', code[0]['saveaseID']);

      setState(() {
        balance = code[0]['balance'].toStringAsFixed(2);
        accountName = code[0]['fname'] + " " + code[0]['lname'];
        accountNumer = code[0]['saveaseID'];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return DropdownBanner(
      navigatorKey: navigatorKey,
      child: WillPopScope(
        onWillPop: ()async {
          if (Navigator.of(context).userGestureInProgress)
            return false;
          else
            return true;
        },
        child: Scaffold(
            resizeToAvoidBottomInset : false,
            key: _scaffoldKey,
            body: ChangeNotifierProvider(
          builder: (context) => menuController,
          child: ZoomScaffold(
            menuScreen: MenuScreen(),
            contentScreen: Layout(
                contentBuilder: (cc) => Stack(
                      children: <Widget>[
                        Container(
                          width: MediaQuery.of(context).size.width,
                            height: MediaQuery.of(context).size.height,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: AssetImage("assets/image/bne.png"),
                                fit: BoxFit.cover,
                              ),
                            ),
                            child: Container(
                              width:MediaQuery.of(context).size.width,
                              child: Column(
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
                                  ),
                                  SingleChildScrollView(
                                    child: SizedBox(
                                      width: MediaQuery.of(context).size.width,
                                      height: MediaQuery.of(context).size.height,
                                      child: Padding(
                                        padding: const EdgeInsets.only(bottom: 40),
                                        child: SingleChildScrollView(
                                          physics:
                                              const AlwaysScrollableScrollPhysics(),
                                          child: Column(
                                            children: <Widget>[
                                              Padding(
                                                padding: const EdgeInsets.only(top: 10,right: 20,left: 0),
                                                child: Container(
                                                  child: SwitchListTile(
                                                    value: _value2,
                                                    onChanged: _onChanged2,
                                                    title: new Text('Available for business', style: new TextStyle(fontSize: 13.0,fontWeight: FontWeight.bold, color: Color(0xff212435))),
                                                  ),

                                                ),
                                              ),
                                              Align(
                                                alignment: Alignment.centerLeft,
                                                child: Padding(
                                                  padding: const EdgeInsets.only(
                                                      top: 5.0,
                                                      right: 20.0,
                                                      left: 20.0),
                                                  child: Text("Welcome,",
                                                      style: TextStyle(
                                                          fontFamily:
                                                              "sfprodisplaymedium",
                                                          fontSize: 17.0,
                                                          fontWeight: FontWeight.bold,
                                                          color: Color(0xff212435))),
                                                ),
                                              ),
                                              Align(
                                                alignment: Alignment.centerLeft,
                                                child: Padding(
                                                  padding: const EdgeInsets.only(
                                                      right: 20.0, left: 20.0),
                                                  child: Text(
                                                      "Here are an array of functions you can currently perform from this dashboard.",
                                                      style: TextStyle(
                                                          fontFamily:
                                                              "sfprodisplaylight",
                                                          fontSize: 13.0,
                                                          fontWeight: FontWeight.bold,
                                                          color: Color(0xff212435))),
                                                ),
                                              ),
                                              GestureDetector(
                                                onTap: () {
                                                    Navigator.push(context, SlideRightRoute(page: VerifyHome()));
                                                },
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.only(top: 20.0),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.spaceBetween,
                                                    children: <Widget>[
                                                      Padding(
                                                        padding: const EdgeInsets.only(left: 55),
                                                        child: Container(
                                                          width: 50.0,
                                                          height: 50.0,
                                                          child: Card(
                                                            color: Colors.white,
                                                            elevation: 7.0,
                                                            child: Padding(
                                                              padding:
                                                                  const EdgeInsets.only(
                                                                      top: 5),
                                                              child: Image.asset(
                                                                  "assets/image/verify.png"),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      Padding(
                                                        padding: const EdgeInsets.all(8.0),
                                                        child: GestureDetector(
                                                          onTap: () {
                                                            Navigator.push(
                                                                context,
                                                                MaterialPageRoute(
                                                                    builder: (context) =>
                                                                        Transfer()));
                                                          },
                                                          child: Container(
                                                            width: 50.0,
                                                            height: 50.0,
                                                            child: Card(
                                                              color: Colors.white,
                                                              elevation: 7.0,
                                                              child: Padding(
                                                                padding:
                                                                    const EdgeInsets.only(
                                                                        top: 5),
                                                                child: Padding(
                                                                  padding:
                                                                      const EdgeInsets
                                                                          .all(8.0),
                                                                  child: Container(
                                                                      width: 20.0,
                                                                      child: Image.asset(
                                                                          "assets/image/Group.png")),
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      GestureDetector(
                                                        onTap: () {
                                                          Navigator.push(
                                                              context,
                                                              MaterialPageRoute(
                                                                  builder: (context) =>
                                                                      Withdraw()));
                                                        },
                                                        child: Padding(
                                                          padding: const EdgeInsets.only(right: 55),
                                                          child: Container(
                                                            width: 50.0,
                                                            height: 50.0,
                                                            child: Card(
                                                              color: Colors.white,
                                                              elevation: 7.0,
                                                              child: Padding(
                                                                padding:
                                                                const EdgeInsets.only(
                                                                    top: 5),
                                                                child: Padding(
                                                                  padding:
                                                                  const EdgeInsets.all(
                                                                      8.0),
                                                                  child: Image.asset(
                                                                      "assets/image/Withdraw.png"),
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
                                              Padding(
                                                padding:
                                                    const EdgeInsets.only(top: 0.0),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.spaceBetween,
                                                  children: <Widget>[
                                                    Padding(
                                                      padding: const EdgeInsets.only(left: 65),
                                                      child: new Text("Verify",
                                                          style: TextStyle(
                                                              fontFamily:
                                                                  "sfprodisplaylight",
                                                              fontSize: 12.0,
                                                              fontWeight: FontWeight.bold,
                                                              color: Color(0xff212435))),
                                                    ),

                                                    Padding(
                                                      padding: const EdgeInsets.only(
                                                          left:5),
                                                      child: new Text("Transfer",
                                                          style: TextStyle(
                                                              fontFamily:
                                                                  "sfprodisplaylight",
                                                              fontSize: 12.0,
                                                              fontWeight:
                                                                  FontWeight.bold,
                                                              color:
                                                                  Color(0xff212435))),
                                                    ),
                                                    Padding(
                                                      padding: const EdgeInsets.only(
                                                          right: 57.0),
                                                      child: new Text("Withdraw",
                                                          style: TextStyle(
                                                              fontFamily:
                                                              "sfprodisplaylight",
                                                              fontSize: 12.0,
                                                              fontWeight:
                                                              FontWeight.bold,
                                                              color:
                                                              Color(0xff212435))),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              GestureDetector(
                                                onTap: () {
                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              Withdraw()));
                                                },
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.only(top: 10.0),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.spaceBetween,
                                                    children: <Widget>[


                                                      GestureDetector(
                                                        onTap: () {
                                                          Navigator.push(
                                                              context,
                                                              MaterialPageRoute(
                                                                  builder: (context) =>
                                                                      BuyVoucher()));
                                                        },
                                                        child: Padding(
                                                          padding: const EdgeInsets.only(left: 55),
                                                          child: Container(
                                                            width: 50.0,
                                                            height: 50.0,
                                                            child: Card(
                                                              color: Colors.white,
                                                              elevation: 7.0,
                                                              child: Padding(
                                                                padding:
                                                                const EdgeInsets.only(
                                                                    top: 5),
                                                                child: Padding(
                                                                  padding:
                                                                  const EdgeInsets
                                                                      .all(8.0),
                                                                  child: Image.asset(
                                                                      "assets/image/voucher.png"),
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      GestureDetector(
                                                        onTap: () {
                                                          Navigator.push(
                                                              context,
                                                              MaterialPageRoute(
                                                                  builder: (context) =>
                                                                      VOucherTable()));
                                                        },
                                                        child: Padding(
                                                          padding: const EdgeInsets.only(top:  5),
                                                          child: Container(
                                                            width: 50.0,
                                                            height: 50.0,
                                                            child: Card(
                                                              color: Colors.white,
                                                              elevation: 7.0,
                                                              child: Padding(
                                                                padding:
                                                                    const EdgeInsets.only(
                                                                        top: 5),
                                                                child: Padding(
                                                                  padding:
                                                                      const EdgeInsets
                                                                          .all(8.0),
                                                                  child: Image.asset(
                                                                      "assets/image/document.png"),
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      GestureDetector(
                                                        onTap: () {
                                                          Navigator.push(
                                                              context,
                                                              MaterialPageRoute(
                                                                  builder: (context) =>
                                                                      FundAccount()));
                                                        },
                                                        child: Padding(
                                                          padding: const EdgeInsets.only(top: 10,right: 55),
                                                          child: Container(
                                                            width: 50.0,
                                                            height: 50.0,
                                                            child: Card(
                                                              color: Colors.white,
                                                              elevation: 7.0,
                                                              child: Padding(
                                                                padding:
                                                                const EdgeInsets
                                                                    .all(8.0,),
                                                                child: Image.asset(
                                                                    "assets/image/fund.png"),

                                                              ),
                                                            ),
                                                          ),
                                                        ),

                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.only(top: 0.0),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.spaceBetween,
                                                  children: <Widget>[

                                                    Padding(
                                                      padding: const EdgeInsets.only(
                                                          left: 50.0),
                                                      child: new Text("Buy Voucher",
                                                          style: TextStyle(
                                                              fontFamily:
                                                                  "sfprodisplaylight",
                                                              fontSize: 12.0,
                                                              fontWeight:
                                                                  FontWeight.bold,
                                                              color:
                                                                  Color(0xff212435))),
                                                    ),
                                                    Padding(
                                                      padding: const EdgeInsets.only(left: 0),
                                                      child: new Text("Voucher Table",
                                                          style: TextStyle(
                                                              fontFamily:
                                                                  "sfprodisplaylight",
                                                              fontSize: 12.0,
                                                              fontWeight:
                                                                  FontWeight.bold,
                                                              color:
                                                                  Color(0xff212435))),
                                                    ),

                                                    Padding(
                                                      padding: const EdgeInsets.only(right: 45),
                                                      child: new Text("Fund Account",
                                                          style: TextStyle(
                                                              fontFamily:
                                                              "sfprodisplaylight",
                                                              fontSize: 12.0,
                                                              fontWeight:
                                                              FontWeight.bold,
                                                              color:
                                                              Color(0xff212435))),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.only(bottom: 5,top: 10),
                                                child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.spaceBetween,
                                                    children: [
                                                      Padding(
                                                        padding: const EdgeInsets.only(left: 55),
                                                        child: Column(
                                                          children: <Widget>[


                                                            GestureDetector(
                                                              onTap: () {
                                                                Navigator.push(
                                                                    context,
                                                                    MaterialPageRoute(
                                                                        builder: (context) =>
                                                                            TransactionStatement()));
                                                              },
                                                              child: Padding(
                                                                padding:
                                                                    const EdgeInsets.only(
                                                                        top: 0.0,
                                                                        right: 0.0),
                                                                child: Container(
                                                                  width: 50.0,
                                                                  height: 50.0,
                                                                  child: Card(
                                                                    color: Colors.white,
                                                                    elevation: 7.0,
                                                                    child: Padding(
                                                                      padding:
                                                                          const EdgeInsets
                                                                                  .only(
                                                                              top: 5),
                                                                      child: Padding(
                                                                        padding:
                                                                            const EdgeInsets
                                                                                .all(8.0),
                                                                        child: Image.asset(
                                                                            "assets/image/report.png"),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets.only(
                                                                      right: 0),
                                                              child: Text("Statement",
                                                                  style: TextStyle(
                                                                      fontFamily:
                                                                          "sfprodisplaylight",
                                                                      fontSize: 12.0,
                                                                      fontWeight:
                                                                          FontWeight.bold,
                                                                      color: Color(
                                                                          0xff212435))),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      Padding(
                                                        padding: const EdgeInsets.only(left: 0),
                                                        child: Column(
                                                          children: <Widget>[

                                                            GestureDetector(
                                                              onTap: () {
                                                                Navigator.push(
                                                                    context,
                                                                    MaterialPageRoute(
                                                                        builder: (context) =>
                                                                            GenerateScreen()));
                                                              },
                                                              child: Padding(
                                                                padding: const EdgeInsets.only(left: 0),
                                                                child: Container(
                                                                  width: 50.0,
                                                                  height: 50.0,
                                                                  child: Card(
                                                                    color: Color(
                                                                        0xff212435),
                                                                    elevation: 7.0,
                                                                    child: Padding(
                                                                      padding:
                                                                      const EdgeInsets.only(
                                                                          top: 5),
                                                                      child: Padding(
                                                                        padding:
                                                                        const EdgeInsets
                                                                            .all(8.0),
                                                                        child: Image.asset(
                                                                            "assets/image/myqr.png"),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                            ),

                                                            Padding(
                                                              padding:
                                                              const EdgeInsets.only(
                                                                  right: 0),
                                                              child: Text("QR Code",
                                                                  style: TextStyle(
                                                                      fontFamily:
                                                                      "sfprodisplaylight",
                                                                      fontSize: 12.0,
                                                                      fontWeight:
                                                                      FontWeight.bold,
                                                                      color: Color(
                                                                          0xff212435))),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      Padding(
                                                        padding: const EdgeInsets.only(right: 55),
                                                        child: Column(
                                                          children: <Widget>[

                                                            GestureDetector(
                                                              onTap: () {
                                                                scan();
                                                              },
                                                              child: Padding(
                                                                padding: const EdgeInsets.only(left: 0),
                                                                child: Container(
                                                                  width: 50.0,
                                                                  height: 50.0,
                                                                  child: Card(
                                                                    color: Color(
                                                                        0xff212435),
                                                                    elevation: 7.0,
                                                                    child: Padding(
                                                                      padding:
                                                                      const EdgeInsets.only(
                                                                          top: 5),
                                                                      child: Padding(
                                                                        padding:
                                                                        const EdgeInsets
                                                                            .all(8.0),
                                                                        child: Image.asset(
                                                                            "assets/image/scanqr.png"),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                            ),

                                                            Padding(
                                                              padding:
                                                              const EdgeInsets.only(
                                                                  right: 0),
                                                              child: Text("Scan To Pay",
                                                                  style: TextStyle(
                                                                      fontFamily:
                                                                      "sfprodisplaylight",
                                                                      fontSize: 12.0,
                                                                      fontWeight:
                                                                      FontWeight.bold,
                                                                      color: Color(
                                                                          0xff212435))),
                                                            ),
                                                          ],
                                                        ),
                                                      ),

                                                    ]),
                                              ),


                                              Align(
                                                  alignment:  Alignment.centerRight,
                                                child: Padding(
                                                  padding: const EdgeInsets.only(
                                                      top: 20.0,right: 45),
                                                  child: Container(
                                                    width: 170.0,
                                                    child: Column(
                                                      children: <Widget>[
                                                        Text(
                                                            "Set a savings goal today, and we would help you achieve this goal. Our aim is to assist you build your money through savings into capital. We are passionate about this, because we understand that money habits are difficult to cultivate. Trust us to help you.",
                                                            style: TextStyle(
                                                                fontFamily:
                                                                "sfprodisplaylight",
                                                                fontSize: 11.0,
                                                                fontWeight:
                                                                FontWeight
                                                                    .bold,
                                                                color: Color(
                                                                    0xff212435))),
                                                        Padding(
                                                          padding:
                                                          const EdgeInsets
                                                              .only(
                                                              right: 10.0),
                                                          child: new Container(
                                                            width: 170.0,
                                                            child: ButtonTheme(
                                                              minWidth: 90.0,
                                                              height: 28.0,
                                                              child: RaisedButton(
                                                                  onPressed: () {

                                                                  },
                                                                  textColor:
                                                                  Colors
                                                                      .white,
                                                                  color: Color(
                                                                      0xff212435),
                                                                  child: const Text(
                                                                      'Set Goal',
                                                                      style: TextStyle(
                                                                          fontFamily:
                                                                          "sfprodisplaylight",
                                                                          fontSize:
                                                                          11.0)),
                                                                  shape: new RoundedRectangleBorder(
                                                                      borderRadius:
                                                                      new BorderRadius.circular(
                                                                          5.0))),
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ),


                                              Padding(
                                                padding: const EdgeInsets.only(left: 15,right: 15,bottom: 10),
                                                child: Container(
                                                  width: MediaQuery.of(context).size.width,
                                                  height: 150,
                                                  child: Card(
                                                    child: Image.asset("assets/image/bthree.jpeg",fit: BoxFit.cover,),
                                                  ),
                                                ),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(left: 15,right: 15,bottom: 10),
                                                child: Container(
                                                  width: MediaQuery.of(context).size.width,
                                                  height: 150,
                                                  child: Card(
                                                    child: Image.asset("assets/image/bfour.jpeg",fit: BoxFit.cover,),
                                                  ),
                                                ),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(left: 15,right: 15,bottom: 25),
                                                child: Container(
                                                  width: MediaQuery.of(context).size.width,
                                                  height: 150,
                                                  child: Card(
                                                    child: Image.asset("assets/image/bfive.jpeg",fit: BoxFit.cover,),
                                                  ),
                                                ),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(left: 15,right: 15,bottom: 25),
                                                child: Container(
                                                  width: MediaQuery.of(context).size.width,
                                                  height: 150,
                                                  child: Card(
                                                    child: Image.asset("assets/image/bsix.jpeg",fit: BoxFit.cover,),
                                                  ),
                                                ),
                                              ),

                                              Padding(
                                                padding: const EdgeInsets.only(left: 15,right: 15,bottom: 10),
                                                child: Container(

                                                  width: MediaQuery.of(context).size.width,
                                                  height: 150,
                                                  child: Card(
                                                    child: Image.asset("assets/image/bone.jpeg",fit: BoxFit.cover,),
                                                  ),
                                                ),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(left: 15,right: 15,bottom: 10),
                                                child: Container(
                                                  width: MediaQuery.of(context).size.width,
                                                  height: 150,
                                                  child: Card(
                                                    child: Image.asset("assets/image/btwo.jpeg",fit: BoxFit.cover,),
                                                  ),
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
                            ),
                          ),

                        Positioned(
                          bottom: 40.0,
                          child: Container(
                            color: Colors.white,
                            width: MediaQuery.of(context).size.width,
                            child: Container(
                              height: 70.0,
                              child: ListView(

                                scrollDirection: Axis.horizontal,
                                children: <Widget>[
                                  GestureDetector(
                                    onTap: () {
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
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.only(right: 5),
                                      child: Container(
                                        width: 65.0,
                                        height: 60.0,
                                        child: Card(
                                            color: Colors.white,

                                            child: Column(
                                              children: <Widget>[
                                                Padding(
                                                  padding: const EdgeInsets.only(
                                                      left: 15, right: 15, top: 15),
                                                  child: Image.asset(
                                                      "assets/image/power.png"),
                                                ),
                                                Padding(
                                                  padding: const EdgeInsets.only(
                                                      left: 5, right: 5),
                                                  child: Text("logout",
                                                      style: TextStyle(
                                                          fontFamily:
                                                              "sfprodisplaylight",
                                                          fontSize: 8.0,
                                                          fontWeight: FontWeight.bold,
                                                          color: Color(0xff212435))),
                                                ),
                                              ],
                                            )),
                                      ),
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => Profile()));
                                    },
                                    child: Container(
                                      width: 65.0,
                                      height: 60.0,
                                      child: Padding(
                                        padding: const EdgeInsets.only(right: 5),
                                        child: Card(
                                            color: Colors.white,
                                            child: Column(
                                              children: <Widget>[
                                                Padding(
                                                  padding:
                                                  const EdgeInsets.only(top: 15),
                                                  child: Image.asset(
                                                      "assets/image/user.png",height: 30,width: 30,),
                                                ),
                                                Text("Profile",
                                                    style: TextStyle(
                                                        fontFamily:
                                                        "sfprodisplaylight",
                                                        fontSize: 8.0,
                                                        fontWeight: FontWeight.bold,
                                                        color: Color(0xff212435))),
                                              ],
                                            )),
                                      ),
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => Complaint()));
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.only(right: 5),
                                      child: Container(
                                        width: 65.0,
                                        height: 60.0,
                                        child: Card(
                                            color: Colors.white,
                                            child: Column(
                                              children: <Widget>[
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(top: 15),
                                                  child: Image.asset(
                                                      "assets/image/complain.png"),
                                                ),
                                                Text("Complaint",
                                                    style: TextStyle(
                                                        fontFamily:
                                                            "sfprodisplaylight",
                                                        fontSize: 8.0,
                                                        fontWeight: FontWeight.bold,
                                                        color: Color(0xff212435))),
                                              ],
                                            )),
                                      ),
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => UserGuide()));
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.only(right: 5),
                                      child: Container(
                                        width: 65.0,
                                        height: 60.0,
                                        child: Card(
                                            color: Colors.white,
                                            child: Column(
                                              children: <Widget>[
                                                Padding(
                                                  padding: const EdgeInsets.only(
                                                      left: 15, right: 15, top: 15),
                                                  child: Image.asset(
                                                      "assets/image/guide.png"),
                                                ),
                                                Padding(
                                                  padding: const EdgeInsets.only(
                                                      left: 5, right: 5),
                                                  child: Text("User Guide",
                                                      style: TextStyle(
                                                          fontFamily:
                                                              "sfprodisplaylight",
                                                          fontSize: 8.0,
                                                          fontWeight: FontWeight.bold,
                                                          color: Color(0xff212435))),
                                                ),
                                              ],
                                            )),
                                      ),
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => Faq()));
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.only(right: 5),
                                      child: Container(
                                        width: 65.0,
                                        height: 60.0,
                                        child: Card(
                                            color: Colors.white,
                                            child: Column(
                                              children: <Widget>[
                                                Padding(
                                                  padding: const EdgeInsets.only(
                                                      left: 10, right: 10, top: 18),
                                                  child: Image.asset(
                                                      "assets/image/business.png"),
                                                ),
                                                Padding(
                                                  padding: const EdgeInsets.only(
                                                      left: 5, right: 5),
                                                  child: Text("FAQ",
                                                      style: TextStyle(
                                                          fontFamily:
                                                              "sfprodisplaylight",
                                                          fontSize: 8.0,
                                                          fontWeight: FontWeight.bold,
                                                          color: Color(0xff212435))),
                                                ),
                                              ],
                                            )),
                                      ),
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => About()));
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.only(right: 5),
                                      child: Container(
                                        width: 65.0,
                                        height: 60.0,
                                        child: Card(
                                            color: Colors.white,
                                            child: Column(
                                              children: <Widget>[
                                                Padding(
                                                  padding: const EdgeInsets.only(
                                                      left: 10, right: 10, top: 15),
                                                  child: Image.asset(
                                                      "assets/image/about.png"),
                                                ),
                                                Padding(
                                                  padding: const EdgeInsets.only(
                                                      left: 5, right: 5),
                                                  child: Text("About us",
                                                      style: TextStyle(
                                                          fontFamily:
                                                              "sfprodisplaylight",
                                                          fontSize: 8.0,
                                                          fontWeight: FontWeight.bold,
                                                          color: Color(0xff212435))),
                                                ),
                                              ],
                                            )),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
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
        )),
      ),
    );
  }

  void getBvnSttus() async{
    final prefs = await SharedPreferences.getInstance();
    databaseRef.child("Bvn").child(userid).once().then((DataSnapshot snapshot) {
      if(snapshot.value == null){
        prefs.setString('bvnstatus', "false");
        print("not availabe");

      }else{
        print('Data : ${snapshot.value['bvnNumber']}');
        print('Data : ${snapshot.value}');
        prefs.setString('bvnstatus', "true");
        prefs.setString('bvn', snapshot.value['bvnNumber']);
      }

    });
  }
  void firebaseCloudMessaging_Listeners() {

    _firebaseMessaging.getToken().then((token){
      print(token);
    });

    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        print('on message $message');
        print(message["aps"]["alert"]);

        doSomethingThenFail(message["aps"]["alert"]["body"]);
      },
      onResume: (Map<String, dynamic> message) async {
        print('on resume $message');
        doSomethingThenFail(message["aps"]["alert"]["body"]);
      },
      onLaunch: (Map<String, dynamic> message) async {
        print('on launch $message');
        doSomethingThenFail(message["aps"]["alert"]["body"]);
      },
    );

    _firebaseMessaging.subscribeToTopic("news").then((value) {
      print("subed : ");
    });
  }

  void iOS_Permission() {
    _firebaseMessaging.requestNotificationPermissions(
        IosNotificationSettings(sound: true, badge: true, alert: true)
    );
    _firebaseMessaging.onIosSettingsRegistered
        .listen((IosNotificationSettings settings)
    {
      print("Settings registered: $settings");
    });
  }

  void doSomethingThenFail(String text) {
    DropdownBanner.showBanner(
      text: text,
      color: Color(0xff212435),
      textStyle: TextStyle(color: Colors.white),
    );
  }

  void updateLocation() async{
    final prefs = await SharedPreferences.getInstance();

    if(_value2 == false){
      try {
        databaseRef.child("Vendors").child(userid).update({
          'status': 'Not Available'
        });

        prefs.setString('sta','false');
      } on Exception catch (e) {
        print('Could not get location: ${e.toString()}');
      }

    }else{
      try {
        var userLocation = await location.getLocation();

        databaseRef.child("Vendors").child(userid).update({
          'status': 'Available',
          'longitude': userLocation.longitude,
          'latitude': userLocation.latitude
        });
        prefs.setString('sta','true');
      } on Exception catch (e) {
        print('Could not get location: ${e.toString()}');
      }
    }



  }



  getloginTran() async {
    final prefs = await SharedPreferences.getInstance();
    pr = new ProgressDialog(context, ProgressDialogType.Normal);
    pr.setMessage("Transferring..please wait");
    pr.show();
    String soap = '''<?xml version="1.0" encoding="utf-8"?>
<soap:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">
  <soap:Body>
    <transferFund xmlns="http://savease.ng/">
      <amountTransfered>${amount}</amountTransfered>
      <balance>${balance}</balance>
      <beneficiaryAccount>${info[2]}</beneficiaryAccount>
      <saveaseid>${username}</saveaseid>
      <transferedBy>${userId}</transferedBy>
      <in_naration>${narration}</in_naration>
      <username>${userId}</username>
    </transferFund>
  </soap:Body>
</soap:Envelope>''';

    http.Response response = await http.post(
      'http://savease.ng/webservice1.asmx?op=transferFund',
      headers: {
        "SOAPAction": "http://savease.ng/transferFund",
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
    final list = responses['soap:Envelope']['soap:Body']['transferFundResponse']['transferFundResult'];
    List code = jsonDecode(list);
    print(code);
    if (code[0]['TransStatus'] == "1") {
      setState(() {
        transRef = code[0]['TransRef'];
        print(transRef);
      });
      pr.hide();
      sendSms();


    } else {
      pr.hide();
      Alert(
          context: context,
          title: "Failed",
          desc: "Transfer failed",
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

  getTransferPin() async {
    if (pinCode.isEmpty || pinCode == "" ){
      Toast.show("Please enter your pin code", context, duration: Toast.LENGTH_LONG, gravity:  Toast.BOTTOM);
    }else {
      final prefs = await SharedPreferences.getInstance();
      pr = new ProgressDialog(context, ProgressDialogType.Normal);
      pr.setMessage("Verifying..please wait");
      pr.show();
      String soap = '''<?xml version="1.0" encoding="utf-8"?>
<soap:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">
  <soap:Body>
    <existTransPIN xmlns="http://savease.ng/">
      <in_username>${userId}</in_username>
      <transPIN>${pinCode}</transPIN>
    </existTransPIN>
  </soap:Body>
</soap:Envelope>''';

      http.Response response = await http.post(
        'http://savease.ng/webservice1.asmx?op=existTransPIN',
        headers: {
          "SOAPAction": "http://savease.ng/existTransPIN",
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
      String code = responses['soap:Envelope']['soap:Body']['existTransPINResponse']['existTransPINResult'];
      print(code);
      if (code == "1") {
        pr.hide();

        if(accountType == "2"){
          Alert(
              context: context,
              title: "Failed",
              desc: "Unable to transfer funds to a vendor account",
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
        }else {
          getloginTran();
        }
      } else {
        pr.hide();
        Alert(
            context: context,
            title: "Failed",
            desc: "Pin Code not correct, plase try again",
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
      }
    }
  }

  sendSms() async {
    var now = new DateTime.now();

    String newString = info[2].substring(0, 3) + "XXXX" + info[2].substring(3+4);


    String time = new DateFormat("dd-MM-yyyy").format(now);

    final response =
    await http.get('https://www.bulksmsnigeria.com/api/v1/sms/create?api_token=${smsPrivateKey}&from=SAVEASE&to=0${info[2]}&body=Your Acct ${newString} Has Been Credited with NGN ${amount} On ${time} By SAVEASE TRANSFER - (Transaction Ref: ${transRef})CR Kindly dial *384*3358# to use our USSD platform&dnd=2');

    if (response.statusCode == 200) {
      // If server returns an OK response, parse the JSON.
      if (response.body != null){
        print(response.body);
        sendSmsme();

      }else{
        Toast.show("There was a trouble recieve sms alert now", context, duration: Toast.LENGTH_LONG, gravity:  Toast.BOTTOM);

      }

    } else {
      // If that response was not OK, throw an error.
      throw Exception('Failed to load post');
    }
  }

  sendSmsme() async {
    var now = new DateTime.now();
    var a = double.parse(amountForApi);
    String newString = username.substring(0, 3) + "XXXX" + username.substring(3+4);
    var e = bal - a;
    String b = e.toStringAsFixed(2);

    String time = new DateFormat("dd-MM-yyyy").format(now);

    final response =
    await http.get('https://www.bulksmsnigeria.com/api/v1/sms/create?api_token=${smsPrivateKey}&from=SAVEASE&to=0${accountNumer}&body=Your Acct ${newString} Has Been Debited with NGN" ${amount} On ${time} By SAVEASE TRANSFER - (Transaction Ref: ${transRef}) Bal: +NGN${b}DB, Kindly dial *384*3358# to use our USSD platform&dnd=2');

    if (response.statusCode == 200) {
      // If server returns an OK response, parse the JSON.
      if (response.body != null){

        Alert(
            context: context,
            title: "Success",
            desc: "your transfer has been succesful",
            image: Image.asset("assets/image/smiley.png"),
            buttons: [
              DialogButton(
                color: Color(0xff212435),
                onPressed: () {
                  print(response.body);

                  if(accountType == "2"){
                    Navigator.push(context, MaterialPageRoute(builder: (context) => VendorHome()));
                  }else{
                    Navigator.push(context, MaterialPageRoute(builder: (context) => Home()));
                  }



                },
                child: Text(
                  "Ok",
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
              )
            ]
        ).show();


      }else{
        Toast.show("There was a trouble recieve sms alert now", context, duration: Toast.LENGTH_LONG, gravity:  Toast.BOTTOM);

      }

    } else {
      // If that response was not OK, throw an error.
      throw Exception('Failed to load post');
    }
  }

  Future scan() async {
    try {
      String barcode = await BarcodeScanner.scan();
      setState(() {
        info = barcode.split(",");
        this.barcode = info[0];
      });

      showDialog(
        context: context,
        builder: (_) => _showVerifyBvn(context),
      );

    } on PlatformException catch (e) {
      if (e.code == BarcodeScanner.CameraAccessDenied) {
        setState(() {
          this.barcode = 'The user did not grant the camera permission!';
        });
      } else {
        setState(() => this.barcode = 'Unknown error: $e');
      }
    } on FormatException{
      setState(() => this.barcode = 'null (User returned using the "back"-button before scanning anything. Result)');
    } catch (e) {
      setState(() => this.barcode = 'Unknown error: $e');
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