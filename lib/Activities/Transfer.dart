import 'dart:convert';
import 'package:device_info/device_info.dart';
import 'package:firebase_database/firebase_database.dart';
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
import 'package:savease/Activities/Home.dart';
import 'package:savease/Activities/VendorHome.dart';
import 'package:savease/Utils/ZoomScaffoldActivites.dart';
import 'package:savease/Utils/fintnessAppTheme.dart';
import 'package:savease/Utils/menu_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:xml2json/xml2json.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:toast/toast.dart';

String smsPrivateKey = '9Pc1XtdCYg43wdJ6AlbCSCyTlLqc2voEFpl9DvmUq0zcKJTDbdE4aOYOPtzz';
String apiKey = 'Bearer sk_live_0dc08582961f9c1d0785245c36bc4a65658ce187';
class Transfer extends StatefulWidget {
  @override
  _HoomeState createState() => new _HoomeState();
}

class Company {
  var title;

  Company( this.title);

  static List<Company> getCompanies() {
    return <Company>[
      Company('Transfer Type'),
      Company( 'Savease Wallet'),



    ];
  }
}

class _HoomeState extends State<Transfer> with TickerProviderStateMixin {
  List<Company> _companies = Company.getCompanies();
  List<DropdownMenuItem<Company>> _dropdownMenuItems;
  ProgressDialog pr;
  Company _selectedCompany;
  Xml2Json xml2json = new Xml2Json();
  var scr= new GlobalKey();
  var databaseRef;

  String cardamount = "";
  String balance = "";
  bool _isVisible = false;
  bool _isVisiblesavease = false;
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
                  child: Column(
                    children: <Widget>[
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: const EdgeInsets.only(top: 70.0,right: 10,left: 44),
                          child: Container(
                              width: 90.0,
                              child: Image.asset("assets/image/logo.png")),),
                      ),

                      Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: const EdgeInsets.only(top: 20,left: 44),
                          child: Text("Dear User,", style: new TextStyle(fontSize: 14.0, fontWeight: FontWeight.bold,fontFamily: "sfprodisplaylight", ),),
                        ),
                      ),

                      Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: const EdgeInsets.only(top: 10,left: 44,right: 44),
                          child: Text("Seems that you have not completely activated your account, this can be done by verifying your BVN below.", style: new TextStyle(fontSize: 14.0, fontWeight: FontWeight.bold, fontFamily: "sfprodisplaylight",),),
                        ),
                      ),

                      Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: const EdgeInsets.only(top: 20,left: 44,right: 44),
                          child: Text("A sum of N10 is charged for the verification purpose so please ensure that your information like first name and last name are the same as your BVN ,else contact your account officer.", style: new TextStyle(fontSize: 14.0, fontWeight: FontWeight.bold, fontFamily: "sfprodisplaylight",),),
                        ),
                      ),


                      Align(
                        alignment: Alignment.center,
                        child: Padding(
                          padding: const EdgeInsets.only(top: 20,),
                          child: Text("Verify BVN", style: new TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold,fontFamily: "sfprodisplayheavy", ),),
                        ),
                      ),


                      Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 34.0, top: 20.0,right: 30.0),
                          child: Theme(
                            data: Theme.of(context).copyWith(splashColor: Colors.transparent),
                            child: TextField(
                              keyboardType: TextInputType.number,
                              focusNode: phoneNumberFocusNode,
                              onChanged: (text) {
                                if(text.length == 10){
                                  print("there yet");
                                  setState(() {
                                    bvnNumber = text;
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
                                hintText: 'BVN',
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
                        alignment: Alignment.center,
                        child: Padding(
                          padding: EdgeInsets.only(left: 44.0, top: 25.0,right: 30.0,bottom: MediaQuery.of(context).viewInsets.bottom,),
                          child: Container(
                            width: 100.0,
                            child: ButtonTheme(
                              minWidth: 100.0,
                              height: 30.0,

                              child :  RaisedButton(
                                  onPressed: () {

                                    startBvnVerify();

                                  },
                                  textColor: Colors.white,
                                  color:  Color(
                                      0xff212435),
                                  child: const Text('Verify Bvn',style: TextStyle(fontFamily: "sfprodisplaybold")),
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

  MenuController menuController;

  void getData() async{
    databaseRef = FirebaseDatabase.instance.reference();
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
        accountNumer = phone;
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
        print(bvnStat);

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
                  padding: const EdgeInsets.only(left: 20.0),
                  child: Text(company.title,style: TextStyle(fontSize: 12.0,color: Colors.white),),
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

     if(selectedCompany.title == "Savease Wallet"){
        _isVisible = false;
        _isVisiblesavease = true;

      }else if(selectedCompany.title == "Transfer Type"){
        _isVisiblesavease = false;
        _isVisibledefalut = true;

      }

    });
  }

  @override
  void dispose() {
    menuController.dispose();
    super.dispose();
  }

  getlogin() async {
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
      <beneficiaryAccount>${userAccountNumber}</beneficiaryAccount>
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
        getBalance();

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
          getlogin();
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

  getAccountName() async {
    String soap = '''<?xml version="1.0" encoding="utf-8"?>
<soap:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">
  <soap:Body>
    <getNameOnDeposit xmlns="http://savease.ng/">
      <in_saveaseid>${userAccountNumber}</in_saveaseid>
    </getNameOnDeposit>
  </soap:Body>
</soap:Envelope>''';

    http.Response response = await http.post(
      'http://savease.ng/webservice1.asmx?op=getNameOnDeposit',
      headers: {
        "SOAPAction": "http://savease.ng/getNameOnDeposit",
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
    final list = responses['soap:Envelope']['soap:Body']['getNameOnDepositResponse']['getNameOnDepositResult'];
    List code = jsonDecode(list);
    print(code);
    if (code == null) {

    } else {

      setState(() {
        accountNam = code[0]['dname'];
        accountType = code[0]['accountType'].toString();
      });

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
                                                padding: const EdgeInsets.only(left: 34.0, top: 25.0,right: 30.0),
                                                child: Text("Transfer", style: TextStyle(fontSize: 17.0,fontFamily: "sfprodisplayheavy",color: Colors.black)),
                                              ),
                                            ),

                                            Align(
                                              alignment: Alignment.center,
                                              child: Padding(
                                                padding: const EdgeInsets.only(left: 34.0, top: 10.0,right: 30.0),
                                                child: Text("To make a deposit transaction, Kindly click on the dropdown tab to select the appropriate wallet type.", style: TextStyle(fontSize: 14.0,fontFamily: "sfprodisplaylight",color: Colors.black),textAlign: TextAlign.center,),
                                              ),
                                            ),

                                            Align(
                                              alignment: Alignment.center,
                                              child: Padding(
                                                padding: const EdgeInsets.only(top: 20),
                                                child: Column(
                                                  children: <Widget>[
                                                    Padding(
                                                      padding: const EdgeInsets.only(top: 2),
                                                      child: Container(
                                                        width: MediaQuery.of(context).size.width * 0.65,
                                                        height: 45,
                                                        color: Color(0xff212435),
                                                        child: Padding(
                                                          padding: const EdgeInsets.only(right: 4,top: 4,bottom: 4),
                                                          child: Theme(
                                                            data: Theme.of(context).copyWith(
                                                              canvasColor: Colors.blueGrey,
                                                            ),
                                                            child: DropdownButtonHideUnderline(
                                                              child: DropdownButton(

                                                                isExpanded: true,
                                                                value: _selectedCompany,
                                                                items: _dropdownMenuItems,
                                                                onChanged: onChangeDropdownItem,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),

                                                    Padding(
                                                      padding: EdgeInsets.all(15.0),
                                                      child: Column(
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [

                                                          Visibility(
                                                              visible: _isVisibledefalut,
                                                              child: Container(

                                                              )
                                                          ),

                                                          Visibility(
                                                              visible: _isVisiblesavease,
                                                              child: Container(
                                                                child: Column(
                                                                  children: <Widget>[

                                                                    Align(
                                                                      alignment: Alignment.centerLeft,
                                                                      child: Padding(
                                                                        padding: const EdgeInsets.only(left: 34.0, top: 10.0,right: 30.0),
                                                                        child: Theme(
                                                                          data: Theme.of(context).copyWith(splashColor: Colors.transparent),
                                                                          child: TextField(
                                                                            keyboardType: TextInputType.number,
                                                                            focusNode: accountNumberFocusNode,
                                                                            onChanged: (text) {
                                                                              if(text.length == 10){
                                                                                print("there yet");
                                                                                setState(() {
                                                                                  userAccountNumber = text;
                                                                                  getAccountName();
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
                                                                              hintText: 'Account Number',
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
                                                                      padding: const EdgeInsets.only(left: 44.0, top: 10.0),
                                                                      child: Container(
                                                                        child: Row(
                                                                          children: <Widget>[

                                                                            Text("Account Name :",style: TextStyle(fontSize: 12.0,color: Colors.black),),

                                                                            Padding(
                                                                              padding: const EdgeInsets.only(left: 10),
                                                                              child: Text(accountNam??' ',style: TextStyle(fontSize: 12.0,color: Colors.black),),
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
                                                        ],
                                                      ),
                                                    )
                                                  ],
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
      ),
    );
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
      sendSms();
    });


  }

  sendSms() async {
    var now = new DateTime.now();

    String newString = userAccountNumber.substring(0, 3) + "XXXX" + userAccountNumber.substring(3+4);


    String time = new DateFormat("dd-MM-yyyy").format(now);

    final response =
    await http.get('https://www.bulksmsnigeria.com/api/v1/sms/create?api_token=${smsPrivateKey}&from=SAVEASE&to=0${userAccountNumber}&body=Your Acct ${newString} Has Been Credited with NGN ${amount} On ${time} By SAVEASE TRANSFER - (Transaction Ref: ${transRef})CR Kindly dial *384*3358# to use our USSD platform&dnd=2');

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

  updateAmount() async {

    String soap = '''<?xml version="1.0" encoding="utf-8"?>
<soap:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">
  <soap:Body>
    <updateBalance xmlns="http://savease.ng/">
      <inuser>${userId}</inuser>
      <App_amt>10</App_amt>
    </updateBalance>
  </soap:Body>
</soap:Envelope>''';

    http.Response response = await http.post(
      'http://savease.ng/webservice1.asmx?op=updateBalance',
      headers: {
        "SOAPAction": "http://savease.ng/updateBalance",
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


  }

    updateBvnStatus() async {

      String soap = '''<?xml version="1.0" encoding="utf-8"?>
<soap:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">
  <soap:Body>
    <updateBVNStatus xmlns="http://savease.ng/">
      <in_username>${userId}</in_username>
    </updateBVNStatus>
  </soap:Body>
</soap:Envelope>''';

      http.Response response = await http.post(
        'http://savease.ng/webservice1.asmx?op=updateBalance',
        headers: {
          "SOAPAction": "http://savease.ng/updateBalance",
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
      var code = responses['soap:Envelope']['soap:Body']['updateBVNStatusResponse']['updateBVNStatusResult'];

      if (code == 1){
        pr.hide();
        databaseRef.child("Bvn").child(username).set({
          'bvn': 'true',
          'bvnNumber': '${bvnNumber}'
        });


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
          getTransferPin();
        }


      }else{
        pr.hide();
        Alert(
            context: context,
            title: "Failed",
            desc: "Failed to update bvn status",
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

  void startBvnVerify() async{

    if (bvnNumber.length == 11){
      pr = new ProgressDialog(context, ProgressDialogType.Normal);
      pr.setMessage("verifying your bvn..please wait");
      pr.show();
      String url = 'https://api.paystack.co/bank/resolve_bvn/${bvnNumber}';
      Map<String, String> headers = {"Content-type": "application/json","authorization":"${apiKey}"};
      //  String jsonString = '{"type": "nuban", "name": "${bankaccountname}", "description": "Creating transfer rep","account_number": "${userAccountNumber}","bank_code": "${bankcode}","currency": "NGN"}';
      // make POST request
      Response response = await post(url, headers: headers);
      // check the status code for the result

      // this API passes back the id of the new item added to the body
      final responseJson = json.decode(response.body);

      if (responseJson["data"] != null){
        String firstNameBvn = responseJson["data"]["first_name"];
        String lastNameBvn = responseJson["data"]["last_name"];
        String mobileBvn = responseJson["data"]["mobile"];

        if(firstName.toLowerCase() == firstNameBvn || lastName.toLowerCase() == lastNameBvn ){

          if(phoneNum.toLowerCase() == mobileBvn){
            updateAmount();
            updateBvnStatus();


          }else{
            pr.hide();
            updateAmount();
            Alert(
                context: context,
                title: "Failed",
                desc: "Phone number does not match with the one one the bvn",
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

        }else{
          updateAmount();
          Alert(
              context: context,
              title: "Failed",
              desc: "Please enter a valid bvn number",
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

      }else{
        pr.hide();
        updateAmount();
        Alert(
            context: context,
            title: "Failed",
            desc: "Your Bvn number is not correct, please rectify the issue and try again",
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



    }else {
      Alert(
          context: context,
          title: "Failed",
          desc: "Please enter a valid bvn number",
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
