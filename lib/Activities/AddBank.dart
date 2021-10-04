import 'dart:convert';
import 'dart:io';
import 'package:device_info/device_info.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:keyboard_visibility/keyboard_visibility.dart';
import 'package:pinput/pin_put/pin_put.dart';
import 'package:provider/provider.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:savease/Activities/AccountOfficer.dart';
import 'package:savease/Activities/Banks.dart';
import 'package:savease/Activities/Home.dart';
import 'package:savease/Utils/API.dart';
import 'package:savease/Utils/ZoomScaffoldActivites.dart';
import 'package:savease/Utils/fintnessAppTheme.dart';
import 'package:savease/Utils/menu_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:xml2json/xml2json.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:toast/toast.dart';


String smsPrivateKey = '9Pc1XtdCYg43wdJ6AlbCSCyTlLqc2voEFpl9DvmUq0zcKJTDbdE4aOYOPtzz';
String apiKey = 'Bearer sk_live_0dc08582961f9c1d0785245c36bc4a65658ce187';

class AddBank extends StatefulWidget {
  @override
  _HoomeState createState() => new _HoomeState();
}

class _HoomeState extends State<AddBank> with TickerProviderStateMixin {


  Xml2Json xml2json = new Xml2Json();
  ProgressDialog pr;
  String bankcode = "";
  String bankaccountname = "Bank Account Name";
  String balance = "";
  String userRef = "";
  var qty;
  var bal;

  bool _isVisiblesavease = true;

  String pinCode = "";
  String narration = "";
  String email = "";
  String accountNumer = "";
  String accountName = "";
  String cardName = "";
  String userAccountNumber = "";
  String cardNumber = "";
  String username = "";
  String cardPin = "";
  String userId;
  String cvc = "";
  String bankname = "Select bank";
  String amount = "";
  String accountNam = "";
  String bvn = "";
  String type = "";
  String cardSerial = "";
  var list = [];
  var lists = [];
  var balan;
  var year;
  var month ;


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
    String bvnStat = prefs.getString('bvnstatus') ?? '';
    String userType = prefs.getString('userType') ?? '';


    String balanc = bala.toStringAsFixed(2);
    balan = double.parse(balanc);

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
        userId = usernam;
        bal = bala;
        bvn =  bvnStat;
        _getUsers();



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
      pr.setMessage("Saving..please wait");
      pr.show();
      String soap = '''<?xml version="1.0" encoding="utf-8"?>
<soap:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">
  <soap:Body>
    <InsertBankDetails xmlns="http://savease.ng/">
      <accountname>${bankaccountname}</accountname>
      <accountno>${userAccountNumber}</accountno>
      <bankname>${bankname}</bankname>
      <saveaseid>${username}</saveaseid>
      <bankcode>${bankcode}</bankcode>
    </InsertBankDetails>
  </soap:Body>
</soap:Envelope>''';

      http.Response response = await http.post(
        'http://savease.ng/webservice1.asmx?op=InsertBankDetails',
        headers: {
          "SOAPAction": "http://savease.ng/InsertBankDetails",
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
      final code = responses['soap:Envelope']['soap:Body']['InsertBankDetailsResponse']['InsertBankDetailsResult'];
      if (code == "1") {
        pr.hide();
        Alert(
            context: context,
            title: "Success",
            desc: "Successfully added account ",
            image: Image.asset("assets/image/smiley.png"),
            buttons: [
              DialogButton(
                color: Color(0xff212435),
                onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => Banks())),
                child: Text(
                  "Ok",
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
              )
            ]
        ).show();

      } else {
        pr.hide();
        Alert(
            context: context,
            title: "Failed",
            desc: "Adding account failed",
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
                                height:  MediaQuery.of(context).size.height/2,
                                child: SingleChildScrollView(
                                  physics: AlwaysScrollableScrollPhysics(),
                                  child: Container(
                                    child: Column(
                                      children: <Widget>[



                                        Align(
                                          alignment: Alignment.center,
                                          child: Padding(
                                            padding: const EdgeInsets.only(left: 44.0, top: 15.0,right: 30.0),
                                            child: Text("Add Bank Details ", style: TextStyle(fontSize: 17.0,fontFamily: "sfprodisplayheavy",color: Colors.black)),
                                          ),
                                        ),

                                      Padding(
                                        padding: EdgeInsets.only(top: 10),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [



                                            Visibility(
                                                visible: _isVisiblesavease,
                                                child: Container(
                                                  child: Column(
                                                    children: <Widget>[
                                                      Padding(
                                                        padding: const EdgeInsets.only(left: 44.0, top: 10.0),
                                                        child: Container(
                                                          child: Row(
                                                            children: <Widget>[


                                                              Padding(
                                                                padding: const EdgeInsets.only(right: 10),
                                                                child: Text("Bank :",style: TextStyle(fontSize: 12.0,color: Colors.black),),
                                                              ),

                                                              GestureDetector(
                                                                onTap: (){
                                                                  //  _getUsers();
                                                                  showDialog(
                                                                      context: context,
                                                                      builder: (BuildContext context) {
                                                                        return AlertDialog(
                                                                          content: Container(
                                                                            color: Colors.white,
                                                                            width : MediaQuery.of(context).size.width,
                                                                            height : MediaQuery.of(context).size.height,
                                                                            child: Column(
                                                                                mainAxisSize: MainAxisSize.min,
                                                                                children: <Widget>[
                                                                                  Expanded(
                                                                                      child: ListView.builder(
                                                                                          scrollDirection: Axis.vertical,
                                                                                          itemCount: list.length,
                                                                                          shrinkWrap: true,
                                                                                          itemBuilder: (BuildContext ctxt, int index){
                                                                                            return GestureDetector(
                                                                                              onTap: (){
                                                                                                setState(() {
                                                                                                  bankcode = list[index]["code"];
                                                                                                  bankname = list[index]["name"];
                                                                                                  Navigator.pop(context);
                                                                                                });
                                                                                              },
                                                                                              child: Container(
                                                                                                child: Card(
                                                                                                  elevation: 2.0,
                                                                                                  child: Padding(
                                                                                                    padding: const EdgeInsets.only(bottom: 3),
                                                                                                    child: Column(
                                                                                                      children: <Widget>[
                                                                                                        Text(list[index]["name"],style: TextStyle(fontSize: 15.0,color: Colors.black),),

                                                                                                      ],
                                                                                                    ),
                                                                                                  ),
                                                                                                ),
                                                                                              ),
                                                                                            );
                                                                                          }
                                                                                      )
                                                                                  )
                                                                                ]
                                                                            ),
                                                                          ),
                                                                        );

                                                                      });



                                                                },
                                                                child: Align(
                                                                  alignment: Alignment.centerRight,
                                                                  child: Padding(
                                                                    padding: const EdgeInsets.only(left: 25),
                                                                    child: Container(
                                                                      decoration: BoxDecoration(
                                                                        color: Color(0xFF7E768CA5),
                                                                        border: Border.all(
                                                                            width: 3.0,
                                                                            color: Color(0xFF7E768CA5)
                                                                        ),
                                                                        borderRadius: BorderRadius.all(Radius.circular(10.0) //         <--- border radius here
                                                                        ),
                                                                      ),
                                                                      width: 235,
                                                                      child: Padding(
                                                                        padding: const EdgeInsets.all(8.0),
                                                                        child: Text(bankname,style: TextStyle(fontSize: 12.0,color: Colors.black),),
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
                                                        padding: const EdgeInsets.only(left: 44.0, top: 5.0),
                                                        child: Container(
                                                          child: Row(
                                                            children: <Widget>[

                                                              Padding(
                                                                padding: const EdgeInsets.only(right: 10),
                                                                child: Text("Account :",style: TextStyle(fontSize: 12.0,color: Colors.black),),
                                                              ),

                                                              Align(
                                                                alignment: Alignment.centerRight,
                                                                child: Container(
                                                                  width: 238,
                                                                  child: Padding(
                                                                    padding: const EdgeInsets.only(right: 5,left: 8),
                                                                    child: Theme(
                                                                      data: Theme.of(context).copyWith(splashColor: Colors.transparent),
                                                                      child: TextField(
                                                                        keyboardType: TextInputType.number,
                                                                        focusNode: phoneNumberFocusNode,
                                                                        onChanged: (text) {

                                                                          if(text.length == 10){
                                                                            print("there yet");
                                                                            setState(() {
                                                                              userAccountNumber = text;
                                                                              getAccount();
                                                                            });


                                                                          }else{
                                                                            print("not there yet");
                                                                          }

                                                                        },
                                                                        autofocus: false,
                                                                        style: TextStyle(fontSize: 13.0, color: Colors.black),
                                                                        decoration: InputDecoration(
                                                                          filled: true,
                                                                          fillColor: Color(0xFF7E768CA5),
                                                                          hintText: 'Enter account number',
                                                                          hintStyle: TextStyle(fontSize: 12.0,color: Colors.black,),
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
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                      Padding(
                                                        padding: const EdgeInsets.only(left: 44.0, top: 5.0),
                                                        child: Container(
                                                          child: Row(
                                                            children: <Widget>[

                                                              Padding(
                                                                padding: const EdgeInsets.only(right: 10),
                                                                child: Text("Name:",style: TextStyle(fontSize: 12.0,color: Colors.black),),
                                                              ),

                                                              Padding(
                                                                padding: const EdgeInsets.only(left: 20),
                                                                child: Container(
                                                                  decoration: BoxDecoration(
                                                                    color: Color(0xFF7E768CA5),
                                                                    border: Border.all(
                                                                        width: 3.0,
                                                                        color: Color(0xFF7E768CA5)
                                                                    ),
                                                                    borderRadius: BorderRadius.all(Radius.circular(10.0) //         <--- border radius here
                                                                    ),
                                                                  ),
                                                                  width: 235,
                                                                  child: Padding(
                                                                    padding: const EdgeInsets.all(8.0),
                                                                    child: Text(bankaccountname,style: TextStyle(fontSize: 12.0,color: Colors.black),),
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),


                                                      Align(
                                                        alignment: Alignment.center,
                                                        child: Padding(
                                                          padding:  EdgeInsets.only(left: 34.0, top: 25.0,right: 30.0,bottom: MediaQuery.of(context).viewInsets.bottom,),
                                                          child: Container(
                                                            width: 90.0,
                                                            child: ButtonTheme(
                                                              minWidth: 60.0,
                                                              height: 30.0,

                                                              child :  RaisedButton(
                                                                  onPressed: () {
                                                                    getlogin();
                                                                    // Navigator.push(context, MaterialPageRoute(builder: (context) => LoginScreen()));
                                                                  },
                                                                  textColor: Colors.white,
                                                                  color: Color(0xffFA9928),
                                                                  child: const Text('Add',style: TextStyle(fontFamily: "sfprodisplaylight",fontSize: 11)),
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
                                          ],
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





  _getUsers() {

    API.getUsers().then((response) {
      setState(() {

        final responseJson = json.decode(response.body);

        list = responseJson["data"];

       // list = json.decode(response.body);
        print(list[0]["name"]);


      });
    });


  }

   Future getAccount() {

     pr = new ProgressDialog(context, ProgressDialogType.Normal);
     pr.setMessage("Verifying account ");
     pr.show();
    var url = "https://api.paystack.co/bank/resolve?account_number=${userAccountNumber}&bank_code=${bankcode}";
    return http.get(url,
      headers: {HttpHeaders.authorizationHeader: "Bearer sk_live_0dc08582961f9c1d0785245c36bc4a65658ce187"},
    ).then((response){

      setState(() {
        pr.hide();
        final responseJson = json.decode(response.body);

        print(responseJson["data"]["account_name"]);

        bankaccountname = responseJson["data"]["account_name"];

      });

    });


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
