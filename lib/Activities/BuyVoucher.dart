import 'dart:convert';
import 'package:device_info/device_info.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:keyboard_visibility/keyboard_visibility.dart';
import 'package:pinput/pin_put/pin_put.dart';
import 'package:provider/provider.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:savease/Activities/Home.dart';
import 'package:savease/Activities/VendorHome.dart';
import 'package:savease/Utils/ZoomScaffoldActivites.dart';
import 'package:savease/Utils/fintnessAppTheme.dart';
import 'package:savease/Utils/menu_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:xml2json/xml2json.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:toast/toast.dart';
import 'package:savease/Activities/AccountOfficer.dart';

String smsPrivateKey =
    '9Pc1XtdCYg43wdJ6AlbCSCyTlLqc2voEFpl9DvmUq0zcKJTDbdE4aOYOPtzz';

class BuyVoucher extends StatefulWidget {
  @override
  _HoomeState createState() => new _HoomeState();
}

class Company {
  var imageUrl;
  var title;

  Company(this.imageUrl, this.title);

  static List<Company> getCompanies() {
    return <Company>[
      Company("", 'Voucher'),
      Company("assets/image/onehundred.jpg", '100'),
      Company("assets/image/twohundred.png", '200'),
      Company("assets/image/cardfive.png", '500'),
      Company("assets/image/cardonethousand.png", '1000'),
      Company("assets/image/twothousand.png", '2000'),
      Company("assets/image/fivethousand.png", '5000'),
      Company("assets/image/tenthousand.png", '10000'),
    ];
  }
}

class _HoomeState extends State<BuyVoucher> with TickerProviderStateMixin {
  List<Company> _companies = Company.getCompanies();
  List<DropdownMenuItem<Company>> _dropdownMenuItems;
  TextEditingController _textFieldController = TextEditingController();
  Company _selectedCompany;
  Xml2Json xml2json = new Xml2Json();
  ProgressDialog pr;
  String cardamount = "";
  String balance = "";
  var scr = new GlobalKey();
  var qty;
  var bal;
  bool checked = false;
  var totalPrice, commision, voucherMoney, ttl, tt;
  String email = "";
  String accountNumer = "";
  String accountName = "";
  String cardName = "";
  String type = "";
  String cardNumber = "";
  String username = "";
  String userId;
  String cvc = "";
  String amountForApi = "";
  var amount;
  var year;
  var month;

  String _picked = "";
  int indx;
  String pinCode;
  bool _value2 = false;
  String _maritalStatus = "0.5";
  int _currValue = 0;

  void _value2Changed(bool value) => setState(() => _value2 = value);

  String rect = "assets/image/rect.png";

  isIpad() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    IosDeviceInfo info = await deviceInfo.iosInfo;
    if (info.name.toLowerCase().contains("ipad")) {
      setState(() {
        rect = "assets/image/recttwo.png";
      });
    } else {
      setState(() {
        rect = "assets/image/rect.png";
      });
    }
  }

  getTransferPin() async {
    if (pinCode.isEmpty || pinCode == "") {
      Toast.show("Please enter your pin code", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
    } else {
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
      var json =
          xml2json.toParker(); // the only method that worked for my XML type.
      var responses = jsonDecode(json);
      String code = responses['soap:Envelope']['soap:Body']
          ['existTransPINResponse']['existTransPINResult'];
      print(code);
      if (code == "1") {
        pr.hide();

        showDialog(
          context:
          context,
          builder: (_) =>
              _onTapImage(
                  context),
        );

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
            ]).show();
      }
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
  _onTapImage(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0x00000000) ,
      body: StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return Stack(
              alignment: Alignment.center,
              children: <Widget>[
                RepaintBoundary(
                  key: scr,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      width: 300,
                      height: 200,
                      decoration: BoxDecoration(

                        image: DecorationImage(
                          image: AssetImage("assets/image/white.png"),
                          fit: BoxFit.cover,
                        ),
                      ),
                      child: Column(
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(
                                top: 20, left: 10, right: 10, bottom: 8),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text("Sub Total :",
                                    style: TextStyle(
                                        decoration: TextDecoration.none,
                                        fontFamily: "sfprodisplaylight",
                                        fontSize: 11.0,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xff212435))),
                                Text(tt,
                                    style: TextStyle(
                                        decoration: TextDecoration.none,
                                        fontFamily: "sfprodisplaylight",
                                        fontSize: 11.0,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xff212435))),
                              ],
                            ),
                          ),
                          Padding(
                            padding:
                            const EdgeInsets.only(left: 10, right: 10, bottom: 8),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text("Commision :",
                                    style: TextStyle(
                                        decoration: TextDecoration.none,
                                        fontFamily: "sfprodisplaylight",
                                        fontSize: 11.0,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xff212435))),
                                Text(_picked,
                                    style: TextStyle(
                                        decoration: TextDecoration.none,
                                        fontFamily: "sfprodisplaylight",
                                        fontSize: 11.0,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xff212435))),
                              ],
                            ),
                          ),
                          Padding(
                            padding:
                            const EdgeInsets.only(left: 10, right: 10, bottom: 8),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text("Order Total :",
                                    style: TextStyle(
                                        decoration: TextDecoration.none,
                                        fontFamily: "sfprodisplaylight",
                                        fontSize: 11.0,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xff212435))),
                                Text(voucherMoney.toString(),
                                    style: TextStyle(
                                        decoration: TextDecoration.none,
                                        fontFamily: "sfprodisplaylight",
                                        fontSize: 11.0,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xff212435))),
                              ],
                            ),
                          ),
                          Padding(
                            padding:
                            const EdgeInsets.only(left: 10, right: 5, bottom: 4),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Flexible(
                                  child: CheckboxListTile(
                                    value: _value2,
                                    onChanged: (bool value) {
                          setState(() => _value2 = value);
                          },
                                    title:
                                    new Text('I agree with the terms and condition', style: TextStyle(
                                        decoration: TextDecoration.none,
                                        fontFamily: "sfprodisplaylight",
                                        fontSize: 11.0,
                                        fontWeight: FontWeight.bold,
                                        )),
                                    controlAffinity: ListTileControlAffinity.leading,
                                    activeColor: Color(0xff212435),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 4),
                                  child: Text("Read",
                                      style: TextStyle(
                                          decoration: TextDecoration.none,
                                          fontFamily: "sfprodisplaylight",
                                          fontSize: 11.0,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.blue)),
                                ),
                              ],
                            ),
                          ),

                        ],
                      ),
                    ),
                  ),
                ),//
                Align(
                  alignment: Alignment.center,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 44.0, top: 100.0,right: 30.0),
                    child: Container(
                      width: 70.0,
                      child: ButtonTheme(
                        minWidth: 70.0,
                        height: 30.0,

                        child :  RaisedButton(
                            onPressed: () {
                              getlogin();
                              // takescrshot();
                              // Navigator.push(context, MaterialPageRoute(builder: (context) => LoginScreen()));
                            },
                            textColor: Colors.white,
                            color: Color(0xffFA9928),
                            child: const Text('Buy',style: TextStyle(fontFamily: "sfprodisplaybold")),
                            shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(10.0))
                        ),
                      ),
                    ),
                  ),
                ),// Show your Image
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
            );
          }),
    );
  }
//  _onTapImage(BuildContext context) {
//    return Scaffold(
//      body: Stack(
//        alignment: Alignment.center,
//        children: <Widget>[
//          RepaintBoundary(
//            key: scr,
//            child: Padding(
//              padding: const EdgeInsets.all(8.0),
//              child: Container(
//                width: 300,
//                height: 200,
//                child: Column(
//                  children: <Widget>[
//                    Padding(
//                      padding: const EdgeInsets.only(
//                          top: 20, left: 10, right: 10, bottom: 8),
//                      child: Row(
//                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                        children: <Widget>[
//                          Text("Sub Total :",
//                              style: TextStyle(
//                                  decoration: TextDecoration.none,
//                                  fontFamily: "sfprodisplaylight",
//                                  fontSize: 11.0,
//                                  fontWeight: FontWeight.bold,
//                                  color: Color(0xff212435))),
//                          Text(tt,
//                              style: TextStyle(
//                                  decoration: TextDecoration.none,
//                                  fontFamily: "sfprodisplaylight",
//                                  fontSize: 11.0,
//                                  fontWeight: FontWeight.bold,
//                                  color: Color(0xff212435))),
//                        ],
//                      ),
//                    ),
//                    Padding(
//                      padding:
//                          const EdgeInsets.only(left: 10, right: 10, bottom: 8),
//                      child: Row(
//                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                        children: <Widget>[
//                          Text("Commision :",
//                              style: TextStyle(
//                                  decoration: TextDecoration.none,
//                                  fontFamily: "sfprodisplaylight",
//                                  fontSize: 11.0,
//                                  fontWeight: FontWeight.bold,
//                                  color: Color(0xff212435))),
//                          Text(_picked,
//                              style: TextStyle(
//                                  decoration: TextDecoration.none,
//                                  fontFamily: "sfprodisplaylight",
//                                  fontSize: 11.0,
//                                  fontWeight: FontWeight.bold,
//                                  color: Color(0xff212435))),
//                        ],
//                      ),
//                    ),
//                    Padding(
//                      padding:
//                          const EdgeInsets.only(left: 10, right: 10, bottom: 8),
//                      child: Row(
//                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                        children: <Widget>[
//                          Text("Order Total :",
//                              style: TextStyle(
//                                  decoration: TextDecoration.none,
//                                  fontFamily: "sfprodisplaylight",
//                                  fontSize: 11.0,
//                                  fontWeight: FontWeight.bold,
//                                  color: Color(0xff212435))),
//                          Text(voucherMoney.toString(),
//                              style: TextStyle(
//                                  decoration: TextDecoration.none,
//                                  fontFamily: "sfprodisplaylight",
//                                  fontSize: 11.0,
//                                  fontWeight: FontWeight.bold,
//                                  color: Color(0xff212435))),
//                        ],
//                      ),
//                    ),
////                    Padding(
////                      padding:
////                          const EdgeInsets.only(left: 10, right: 5, bottom: 4),
////                      child: Row(
////                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
////                        children: <Widget>[
////                          CheckboxListTile(
////                            value: _value2,
////                            onChanged: _value2Changed,
////                            title:
////                                new Text('I agree with the terms and condition'),
////                            controlAffinity: ListTileControlAffinity.leading,
////                            activeColor: Color(0xff212435),
////                          ),
////                          Padding(
////                            padding: const EdgeInsets.only(left: 4),
////                            child: Text("Read",
////                                style: TextStyle(
////                                    decoration: TextDecoration.none,
////                                    fontFamily: "sfprodisplaylight",
////                                    fontSize: 11.0,
////                                    fontWeight: FontWeight.bold,
////                                    color: Colors.blue)),
////                          ),
////                        ],
////                      ),
////                    ),
//                  ],
//                ),
//              ),
//            ),
//          ), //
//          Align(
//            alignment: Alignment.center,
//            child: Padding(
//              padding: const EdgeInsets.only(left: 44.0, top: 100.0, right: 30.0),
//              child: Container(
//                width: 70.0,
//                child: ButtonTheme(
//                  minWidth: 70.0,
//                  height: 30.0,
//                  child: RaisedButton(
//                      onPressed: () {
//                        getlogin();
//
//                      },
//                      textColor: Colors.white,
//                      color: Color(0xffFA9928),
//                      child: const Text('Ok',
//                          style: TextStyle(fontFamily: "sfprodisplaybold")),
//                      shape: new RoundedRectangleBorder(
//                          borderRadius: new BorderRadius.circular(10.0))),
//                ),
//              ),
//            ),
//          ), // Show your Image
//          Align(
//            alignment: Alignment.topRight,
//            child: RaisedButton.icon(
//                color: Theme.of(context).accentColor,
//                textColor: Colors.white,
//                onPressed: () => Navigator.pop(context),
//                icon: Icon(
//                  Icons.close,
//                  color: Colors.white,
//                ),
//                label: Text('Close')),
//          ),
//        ],
//      ),
//    );
//  }

  void getData() async {
    final prefs = await SharedPreferences.getInstance();
    double bala = prefs.getDouble('balance') ?? '';
    String fname = prefs.getString('fname') ?? '';
    String lname = prefs.getString('lname') ?? '';
    String em = prefs.getString('email') ?? '';
    String phone = prefs.getString('phone') ?? '';
    String user = prefs.getString('saveaseid') ?? '';
    String usernam = prefs.getString('username') ?? '';
    String userType = prefs.getString('userType') ?? '';

    String balanc = bala.toStringAsFixed(2);

    if (balanc != null || balanc != "") {
      setState(() {
        balance = balanc;
        accountNumer = phone;
        accountName = fname + " " + lname;
        email = em;
        username = user;
        userId = usernam;
        bal = bala;
        if (userType == "2"){
          type = "Vendor";
        }else{
          type = "User";
        }
      });
    } else {
      balance = "";
      accountName = "";
      accountNumer = "";
    }
  }

  @override
  void initState() {
    isIpad();
    KeyboardVisibilityNotification().addNewListener(
      onShow: () {
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
    _dropdownMenuItems = buildDropdownMenuItems(_companies);
    _selectedCompany = _dropdownMenuItems[0].value;
    super.initState();
    menuController = new MenuController(
      vsync: this,
    )..addListener(() => setState(() {}));
  }

  List<DropdownMenuItem<Company>> buildDropdownMenuItems(List companies) {
    List<DropdownMenuItem<Company>> items = List();
    for (Company company in companies) {
      items.add(
        DropdownMenuItem(
          value: company,
          child: Container(
            child: Row(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(left: 8),
                  child: Container(
                      width: 30.0,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 6),
                        child: Image.asset(company.imageUrl),
                      )),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20.0),
                  child: Text(
                    company.title,
                    style: TextStyle(fontSize: 16.0, color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }
    return items;
  }

  onChangeDropdownItem(Company selectedCompany) {
    setState(() {
      _selectedCompany = selectedCompany;
      cardamount = selectedCompany.title;
      totalPrice = int.parse(selectedCompany.title);
    });
  }

  @override
  void dispose() {
    menuController.dispose();
    super.dispose();
  }

  getlogin() async {
    if (qty < 0) {
      Toast.show("Please enter the number of voucher pin to purchase", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
    } else {
      final prefs = await SharedPreferences.getInstance();
      pr = new ProgressDialog(context, ProgressDialogType.Normal);
      pr.setMessage("Purchasing..please wait");
      pr.show();
      String soap = '''<?xml version="1.0" encoding="utf-8"?>
<soap:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">
  <soap:Body>
    <saveOrder2 xmlns="http://savease.ng/">
      <saveaseIDz>${username}</saveaseIDz>
      <in_cardType>${cardamount}</in_cardType>
      <in_cardAmount>${cardamount}</in_cardAmount>
      <in_orderby>${userId}</in_orderby>
      <percentage>${_picked}</percentage>
      <qty>${qty}</qty>
      <lblBa>${balance}</lblBa>
    </saveOrder2>
  </soap:Body>
</soap:Envelope>''';

      http.Response response = await http.post(
        'http://savease.ng/webservice1.asmx?op=FundAcct',
        headers: {
          "SOAPAction": "http://savease.ng/saveOrder2",
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
      String code = responses['soap:Envelope']['soap:Body']
          ['saveOrder2Response']['saveOrder2Result'];
      print(code);
      if (code == "1") {
        pr.hide();
        Toast.show("Purchase Successful", context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
        getBalance();
      } else {
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
            ]).show();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
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
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 30),
                                  child: SizedBox(
                                    width: MediaQuery.of(context).size.width,
                                    height:
                                        MediaQuery.of(context).size.height / 2,
                                    child: SingleChildScrollView(
                                      physics: AlwaysScrollableScrollPhysics(),
                                      child: Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 0),
                                        child: Container(
                                          child: Column(
                                            children: <Widget>[
                                              Align(
                                                alignment: Alignment.center,
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 44.0,
                                                          top: 5.0,
                                                          right: 30.0),
                                                  child: Text("Buy Voucher ",
                                                      style: TextStyle(
                                                          fontSize: 17.0,
                                                          fontFamily:
                                                              "sfprodisplayheavy",
                                                          color: Colors.black)),
                                                ),
                                              ),
                                              Align(
                                                alignment: Alignment.centerLeft,
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          right: 20.0,
                                                          left: 20.0,
                                                          top: 5),
                                                  child: Text(
                                                    "To buy voucher, kindly select a voucher denomination and provide the quantity in the fields provided below ",
                                                    style: TextStyle(
                                                        fontSize: 14.0,
                                                        fontFamily:
                                                            "sfprodisplaylight",
                                                        color: Colors.black),
                                                    textAlign: TextAlign.center,
                                                  ),
                                                ),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 10),
                                                child: Row(
                                                  children: <Widget>[
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              left: 30),
                                                      child: Container(
                                                        width: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width *
                                                            0.65,
                                                        height: 40,
                                                        color:
                                                            Color(0xff212435),
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .only(
                                                                  right: 4,
                                                                  top: 4,
                                                                  bottom: 4),
                                                          child: Theme(
                                                            data: Theme.of(
                                                                    context)
                                                                .copyWith(
                                                              canvasColor:
                                                                  Colors
                                                                      .blueGrey,
                                                            ),
                                                            child:
                                                                DropdownButtonHideUnderline(
                                                              child:
                                                                  DropdownButton(
                                                                isExpanded:
                                                                    true,
                                                                value:
                                                                    _selectedCompany,
                                                                items:
                                                                    _dropdownMenuItems,
                                                                onChanged:
                                                                    onChangeDropdownItem,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              left: 15),
                                                      child: Container(
                                                        width: 70,
                                                        height: 40,
                                                        child: TextField(
                                                          keyboardType:
                                                              TextInputType
                                                                  .number,
                                                          autofocus: false,
                                                          onChanged: (text) {
                                                            setState(() {
                                                              qty = int.parse(
                                                                  text);
                                                            });
                                                          },
                                                          style: TextStyle(
                                                              fontSize: 14.0,
                                                              color:
                                                                  Colors.black),
                                                          controller:
                                                              _textFieldController,
                                                          decoration:
                                                              InputDecoration(
                                                            //Add th Hint text here.
                                                            hintText: "QTY",
                                                            border:
                                                                OutlineInputBorder(),
                                                          ),
                                                        ),
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 15, top: 5),
                                                child: SingleChildScrollView(
                                                  physics:
                                                      AlwaysScrollableScrollPhysics(),
                                                  child: Container(
                                                      child: Column(
                                                    children: <Widget>[
                                                      Row(
                                                        children: <Widget>[
                                                          Radio(
                                                            groupValue:
                                                                _currValue,
                                                            onChanged: (int i) {
                                                              setState(() {
                                                                _currValue = i;
                                                                _picked = "0.5";
                                                              });
                                                            },
                                                            value: 1,
                                                          ),
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .only(
                                                                    left: 4),
                                                            child: Text(
                                                                "Charge 0.5% commission",
                                                                style: TextStyle(
                                                                    decoration:
                                                                        TextDecoration
                                                                            .none,
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
                                                        ],
                                                      ),
                                                      Row(
                                                        children: <Widget>[
                                                          Radio(
                                                            groupValue:
                                                                _currValue,
                                                            onChanged: (int i) {
                                                              setState(() {
                                                                _currValue = i;
                                                                _picked = "1";
                                                              });
                                                            },
                                                            value: 2,
                                                          ),
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .only(
                                                                    left: 4),
                                                            child: Text(
                                                                "Charge 1% commission",
                                                                style: TextStyle(
                                                                    decoration:
                                                                        TextDecoration
                                                                            .none,
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
                                                        ],
                                                      ),
                                                      Row(
                                                        children: <Widget>[
                                                          Radio(
                                                            groupValue:
                                                                _currValue,
                                                            onChanged: (int i) {
                                                              setState(() {
                                                                _currValue = i;
                                                                _picked = "1.5";
                                                              });
                                                            },
                                                            value: 3,
                                                          ),
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .only(
                                                                    left: 4),
                                                            child: Text(
                                                                "Charge 1.5% commission",
                                                                style: TextStyle(
                                                                    decoration:
                                                                        TextDecoration
                                                                            .none,
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
                                                        ],
                                                      ),
                                                      Row(
                                                        children: <Widget>[
                                                          Radio(
                                                            groupValue:
                                                                _currValue,
                                                            onChanged: (int i) {
                                                              setState(() {
                                                                _currValue = i;
                                                                _picked = "2";
                                                              });
                                                            },
                                                            value: 4,
                                                          ),
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .only(
                                                                    left: 4),
                                                            child: Text(
                                                                "Charge 2% commission",
                                                                style: TextStyle(
                                                                    decoration:
                                                                        TextDecoration
                                                                            .none,
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
                                                        ],
                                                      ),
                                                    ],
                                                  )),
                                                ),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 44.0,
                                                    top: 10.0,
                                                    right: 10),
                                                child: Container(
                                                  child: Row(
                                                    children: <Widget>[
                                                      Text(
                                                        "Pin Code : ",
                                                        style: TextStyle(
                                                            fontSize: 12.0,
                                                            color:
                                                                Colors.black),
                                                      ),
                                                      SizedBox(
                                                        width: 200,
                                                        height: 50,
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .only(),
                                                          child: PinPut(
                                                            autoFocus: false,
                                                            keyboardType:
                                                                TextInputType
                                                                    .number,
                                                            isTextObscure: true,
                                                            actionButtonsEnabled:
                                                                false,
                                                            fieldsCount: 4,
                                                            onSubmit:
                                                                (String pin) {
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
                                                padding: const EdgeInsets.only(
                                                    left: 34.0,
                                                    bottom: 9.0,
                                                    top: 8.0),
                                                child: Text(
                                                  "*Please, do not disclosure your secret pin to anyone ",
                                                  style: TextStyle(
                                                      fontSize: 12.0,
                                                      color: Colors.black),
                                                ),
                                              ),
                                              Align(
                                                alignment: Alignment.center,
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 44.0,
                                                          top: 10.0,
                                                          right: 30.0),
                                                  child: Container(
                                                    width: 100.0,
                                                    child: ButtonTheme(
                                                      minWidth: 100.0,
                                                      height: 40.0,
                                                      child: RaisedButton(
                                                          onPressed: () {
                                                            if (_picked == "") {
                                                              Toast.show(
                                                                  "Please enter a commision to charge",
                                                                  context,
                                                                  duration: Toast
                                                                      .LENGTH_LONG,
                                                                  gravity: Toast
                                                                      .BOTTOM);
                                                            } else {
                                                              if (qty == null) {
                                                                Toast.show(
                                                                    "Please enter the quantiy you want to purchase",
                                                                    context,
                                                                    duration: Toast
                                                                        .LENGTH_LONG,
                                                                    gravity: Toast
                                                                        .BOTTOM);
                                                              } else {
                                                                if (cardamount ==
                                                                    "") {
                                                                  Toast.show(
                                                                      "Please enter a voucher type",
                                                                      context,
                                                                      duration:
                                                                          Toast
                                                                              .LENGTH_LONG,
                                                                      gravity: Toast
                                                                          .BOTTOM);
                                                                } else {
                                                                  commision =
                                                                      totalPrice *
                                                                          qty;
                                                                  tt = commision
                                                                      .toString();
                                                                  var p = double
                                                                      .parse(
                                                                          _picked);
                                                                  double c =
                                                                      p / 100;
                                                                  double e = c *
                                                                      commision;
                                                                  ttl =
                                                                      commision -
                                                                          e;
                                                                  voucherMoney =
                                                                      ttl.toString();
                                                                  print(ttl);

                                                                 getTransferPin();
                                                                }
                                                              }
                                                            }
                                                          },
                                                          textColor:
                                                              Colors.white,
                                                          color:
                                                              Color(0xffFA9928),
                                                          child: const Text(
                                                              'Buy Card',
                                                              style: TextStyle(
                                                                  fontFamily:
                                                                      "sfprodisplaybold")),
                                                          shape: new RoundedRectangleBorder(
                                                              borderRadius:
                                                                  new BorderRadius
                                                                          .circular(
                                                                      10.0))),
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
      ),
    );
  }

  getBalance() async {
    final prefs = await SharedPreferences.getInstance();
    String soap = '''<?xml version="1.0" encoding="utf-8"?>
<soap:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">
  <soap:Body>
    <getBalance xmlns="http://savease.ng/">
      <straccountNo>8037286489</straccountNo>
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
      accountNumer = code[0]['phone'];
    });

    Navigator.push(context, MaterialPageRoute(builder: (context) => VendorHome()));
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
            child: Text("Done",
                style: TextStyle(
                    color: Colors.indigo, fontWeight: FontWeight.bold)),
          ),
        ),
      ),
    );
  }
}
