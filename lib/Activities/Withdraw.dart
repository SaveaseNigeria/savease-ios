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
class Company {
  var title;

  Company( this.title);

  static List<Company> getCompanies() {
    return <Company>[
      Company('Select Type'),
      Company( 'Own account'),
      Company( 'Third party account'),



    ];
  }
}


class Withdraw extends StatefulWidget {
  @override
  _HoomeState createState() => new _HoomeState();
}

class _HoomeState extends State<Withdraw> with TickerProviderStateMixin {

  List<Company> _companies = Company.getCompanies();
  List<DropdownMenuItem<Company>> _dropdownMenuItems;
  Company _selectedCompany;
  Xml2Json xml2json = new Xml2Json();
  ProgressDialog pr;
  String bankcode = "";
  String bankaccountname = "Bank Account Name";
  String balance = "";
  String userRef = "";
  var qty;
  var bal;
  bool _isVisible = false;
  bool _isVisiblesavease = false;
  bool _isVisibledefalut = false;
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
  var amt;
  var year;
  var month ;
  bool _value2 = false;
  int selectedindex;
  int count = 0;
  void _value2Changed(bool value) => setState(() => _value2 = value);

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


  getaccounts() async {
    final prefs = await SharedPreferences.getInstance();
    String soap = '''<?xml version="1.0" encoding="utf-8"?>
<soap:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">
  <soap:Body>
    <getBankDetails xmlns="http://savease.ng/">
      <saveaseid>${username}</saveaseid>
    </getBankDetails>
  </soap:Body>
</soap:Envelope>''';

    http.Response response = await http.post(
      'http://savease.ng/webservice1.asmx?op=getBankDetails',
      headers: {
        "SOAPAction": "http://savease.ng/getBankDetails",
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
    final code  = responses['soap:Envelope']['soap:Body']['getBankDetailsResponse']['getBankDetailsResult'];
    print(code);
    setState(() {
      lists = jsonDecode(code);
      print(lists.length);
      print(lists[0]);



    });

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
        getaccounts();



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


      if(selectedCompany.title == "Select Type"){
        _isVisible = false;
        _isVisiblesavease = false;

      }else if(selectedCompany.title == "Own account"){
        _isVisiblesavease = false;
        _isVisible = true;

      }else if(selectedCompany.title == "Third party account"){
        _isVisiblesavease = true;
        _isVisible = false;

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
      pr.setMessage("withdrawing..please wait");
      pr.show();
      String soap = '''<?xml version="1.0" encoding="utf-8"?>
<soap:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">
  <soap:Body>
    <updateBalance xmlns="http://savease.ng/">
      <inuser>${userId}</inuser>
      <App_amt>${amount}</App_amt>
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
     getBalance();
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
                                            child: Text("Withdraw Funds ", style: TextStyle(fontSize: 17.0,fontFamily: "sfprodisplayheavy",color: Colors.black)),
                                          ),
                                        ),

                                        Align(
                                          alignment: Alignment.centerLeft,
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                right: 20.0, left: 20.0,top: 5),
                                            child: Text(
                                              "You must have a minimun balance of 1200 ( one thousand, two hundred naira) in your savease account to withdraw funds to any other bank ",
                                              style: TextStyle(fontSize: 14.0,fontFamily: "sfprodisplaylight",color: Colors.black),textAlign: TextAlign.center,),
                                          ),
                                        ),

                                        Padding(
                                          padding: const EdgeInsets.only(top: 10),
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
                                        padding: EdgeInsets.only(top: 20),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [

                                            Padding(
                                              padding: const EdgeInsets.only(top: 5),
                                              child: Visibility(
                                                  visible: _isVisible,
                                                  child: Container(
                                                      height: 300,
                                                      child: Flex(
                                                        direction: Axis.vertical,
                                                        children: <Widget>[
                                                          Expanded(
                                                              child: (lists == null)
                                                                  ? Container(
                                                                child: Padding(
                                                                  padding: const EdgeInsets.only(right: 30,left: 30,top: 10),
                                                                  child: Text("No saved accounts, go to your profile to add an account",textAlign: TextAlign.center,),
                                                                ),

                                                              ) :ListView.builder(
                                                                  scrollDirection: Axis.vertical,
                                                                  itemCount: lists.length,
                                                                  itemBuilder: (BuildContext ctxt, int index){

                                                                    return  (selectedindex == null)
                                                                        ?Padding(
                                                                      padding: const EdgeInsets.only(right: 30,left: 30),
                                                                      child: GestureDetector(
                                                                        onTap: (){
                                                                          showDialog(
                                                                            context: context,
                                                                            builder: (BuildContext context) {
                                                                              // return object of type Dialog
                                                                              return AlertDialog(
                                                                                content: new Text("Do you want to transfer to this account?"),
                                                                                actions: <Widget>[
                                                                                  // usually buttons at the bottom of the dialog
                                                                                  new FlatButton(
                                                                                    child: new Text("No"),
                                                                                    onPressed: () {
                                                                                      Navigator.of(context).pop();
                                                                                    },
                                                                                  ),

                                                                                  new FlatButton(
                                                                                    child: new Text("Yes"),
                                                                                    onPressed: () {
                                                                                      setState(() {
                                                                                        _isVisibledefalut = true;
                                                                                        selectedindex = index;
                                                                                        bankname = lists[index]["BankName"];
                                                                                        bankcode = lists[index]["bankCode"];
                                                                                        userAccountNumber = lists[index]["AccountNumber"];
                                                                                      });
                                                                                      Navigator.of(context).pop();
                                                                                    },
                                                                                  ),
                                                                                ],
                                                                              );
                                                                            },
                                                                          );

                                                                        },
                                                                        child: Container(
                                                                          child: Card(
                                                                            elevation: 9.0,
                                                                            child: Padding(
                                                                              padding: const EdgeInsets.all(8.0),
                                                                              child: Column(
                                                                                children: <Widget>[

                                                                                  Row(
                                                                                    children: <Widget>[
                                                                                      Align(
                                                                                        alignment: Alignment.centerLeft,
                                                                                        child: Text(
                                                                                            lists[index]["AccountNumber"],
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

                                                                                      Padding(
                                                                                        padding: const EdgeInsets.only(left: 20),
                                                                                        child: Align(
                                                                                          alignment: Alignment.centerRight,
                                                                                          child: Text(
                                                                                              lists[index]["BankName"],
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


                                                                                    ],
                                                                                  )



                                                                                ],
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ): (selectedindex == index )?
                                                                    Padding(
                                                                      padding: const EdgeInsets.only(right: 30,left: 30),
                                                                      child: GestureDetector(
                                                                        onTap: (){
                                                                          showDialog(
                                                                            context: context,
                                                                            builder: (BuildContext context) {
                                                                              // return object of type Dialog
                                                                              return AlertDialog(
                                                                                content: new Text("Do you want to transfer to this account?"),
                                                                                actions: <Widget>[
                                                                                  // usually buttons at the bottom of the dialog
                                                                                  new FlatButton(
                                                                                    child: new Text("No"),
                                                                                    onPressed: () {
                                                                                      selectedindex = null;
                                                                                      Navigator.of(context).pop();
                                                                                    },
                                                                                  ),

                                                                                  new FlatButton(
                                                                                    child: new Text("Yes"),
                                                                                    onPressed: () {
                                                                                      setState(() {
                                                                                        _isVisibledefalut = true;
                                                                                        selectedindex = index;
                                                                                        bankname = lists[selectedindex]["BankName"];
                                                                                        bankcode = lists[selectedindex]["bankCode"];
                                                                                        userAccountNumber = lists[selectedindex]["AccountNumber"];
                                                                                      });
                                                                                      Navigator.of(context).pop();
                                                                                    },
                                                                                  ),
                                                                                ],
                                                                              );
                                                                            },
                                                                          );

                                                                        },
                                                                        child: Container(
                                                                          child: Card(
                                                                            elevation: 9.0,
                                                                            child: Padding(
                                                                              padding: const EdgeInsets.all(8.0),
                                                                              child: Column(
                                                                                children: <Widget>[

                                                                                  Row(
                                                                                    children: <Widget>[
                                                                                      Align(
                                                                                        alignment: Alignment.centerLeft,
                                                                                        child: Text(
                                                                                            lists[selectedindex]["AccountNumber"],
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

                                                                                      Padding(
                                                                                        padding: const EdgeInsets.only(left: 20),
                                                                                        child: Align(
                                                                                          alignment: Alignment.centerRight,
                                                                                          child: Text(
                                                                                              lists[selectedindex]["BankName"],
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

                                                                                      Spacer(),
                                                                                      Visibility(
                                                                                        visible: _isVisibledefalut,
                                                                                        child: Padding(
                                                                                          padding: const EdgeInsets.only(left: 10),
                                                                                          child: Icon(Icons.done,color: Colors.green,),
                                                                                        ),
                                                                                      )

                                                                                    ],
                                                                                  )



                                                                                ],
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ):
                                                                    Padding(
                                                                      padding: const EdgeInsets.only(right: 30,left: 30),
                                                                      child: GestureDetector(
                                                                        onTap: (){
                                                                          showDialog(
                                                                            context: context,
                                                                            builder: (BuildContext context) {
                                                                              // return object of type Dialog
                                                                              return AlertDialog(
                                                                                content: new Text("Do you want to transfer to this account?"),
                                                                                actions: <Widget>[
                                                                                  // usually buttons at the bottom of the dialog
                                                                                  new FlatButton(
                                                                                    child: new Text("No"),
                                                                                    onPressed: () {
                                                                                      selectedindex = null;
                                                                                      Navigator.of(context).pop();
                                                                                    },
                                                                                  ),

                                                                                  new FlatButton(
                                                                                    child: new Text("Yes"),
                                                                                    onPressed: () {
                                                                                      setState(() {
                                                                                        _isVisibledefalut = true;
                                                                                        selectedindex = index;
                                                                                        bankname = lists[selectedindex]["BankName"];
                                                                                        bankcode = lists[selectedindex]["bankCode"];
                                                                                        userAccountNumber = lists[selectedindex]["AccountNumber"];
                                                                                      });
                                                                                      Navigator.of(context).pop();
                                                                                    },
                                                                                  ),
                                                                                ],
                                                                              );
                                                                            },
                                                                          );

                                                                        },
                                                                        child: Container(
                                                                          child: Card(
                                                                            elevation: 9.0,
                                                                            child: Padding(
                                                                              padding: const EdgeInsets.all(8.0),
                                                                              child: Column(
                                                                                children: <Widget>[

                                                                                  Row(
                                                                                    children: <Widget>[
                                                                                      Align(
                                                                                        alignment: Alignment.centerLeft,
                                                                                        child: Text(
                                                                                            lists[selectedindex]["AccountNumber"],
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

                                                                                      Padding(
                                                                                        padding: const EdgeInsets.only(left: 20),
                                                                                        child: Align(
                                                                                          alignment: Alignment.centerRight,
                                                                                          child: Text(
                                                                                              lists[selectedindex]["BankName"],
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



                                                                                    ],
                                                                                  )



                                                                                ],
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    );
                                                                  })

                                                          ),

                                                          Padding(
                                                            padding: const EdgeInsets.only(left: 44.0, top: 10.0),
                                                            child: Container(
                                                              child: Row(
                                                                children: <Widget>[

                                                                  Padding(
                                                                    padding: const EdgeInsets.only(right: 10),
                                                                    child: Text("Amount:",style: TextStyle(fontSize: 12.0,color: Colors.black),),
                                                                  ),

                                                                  Container(
                                                                    width: 250,
                                                                    child: Padding(
                                                                      padding: const EdgeInsets.only(right: 5,left: 10),
                                                                      child: Theme(
                                                                        data: Theme.of(context).copyWith(splashColor: Colors.transparent),
                                                                        child: TextField(
                                                                          keyboardType: TextInputType.number,
                                                                          focusNode: phoneNumberFocusNode,
                                                                          onChanged: (text) {

                                                                            setState(() {
                                                                              amt = double.parse(text);
                                                                              amount = text;
                                                                            });

                                                                          },
                                                                          autofocus: false,
                                                                          style: TextStyle(fontSize: 13.0, color: Colors.black),
                                                                          decoration: InputDecoration(
                                                                            filled: true,
                                                                            fillColor: Color(0xFF7E768CA5),
                                                                            hintText: 'Enter Amount ',
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
                                                                    child: Text("Narration:",style: TextStyle(fontSize: 12.0,color: Colors.black),),
                                                                  ),

                                                                  Container(
                                                                    width: 240,
                                                                    child: Padding(
                                                                      padding: const EdgeInsets.only(right: 5),
                                                                      child: Theme(
                                                                        data: Theme.of(context).copyWith(splashColor: Colors.transparent),
                                                                        child: TextField(
                                                                          keyboardType: TextInputType.text,

                                                                          onChanged: (text) {
                                                                            setState(() {
                                                                              narration = text;
                                                                            });
                                                                          },
                                                                          autofocus: false,
                                                                          style: TextStyle(fontSize: 13.0, color: Colors.black),
                                                                          decoration: InputDecoration(
                                                                            filled: true,
                                                                            fillColor: Color(0xFF7E768CA5),
                                                                            hintText: 'Enter narration',
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
                                                                ],
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
                                                                    width: 230,
                                                                    height: 50,
                                                                    child: Padding(
                                                                      padding: const EdgeInsets.only(left: 10),
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
                                                                        if (amt < 1000){
                                                                          Alert(
                                                                              context: context,
                                                                              title: "Failed",
                                                                              desc: "You can not withdraw less than 1000 ",
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
                                                                          if (balan < 1200){
                                                                            Alert(
                                                                                context: context,
                                                                                title: "Insuffiecient Balance",
                                                                                desc: "To withdraw, you must have a minimum of 1200 in your savease account",
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

                                                                            if(bankname == "Select bank" && bankcode.isEmpty){
                                                                              setState(() {
                                                                                bankname = lists[0]["BankName"];
                                                                                bankaccountname = lists[0]["BankName"];
                                                                                bankcode = lists[0]["bankCode"];
                                                                                userAccountNumber = lists[0]["AccountNumber"];
                                                                              });
                                                                              getTransferPin();

                                                                              print(bankcode);
                                                                            }else{
                                                                              print(bankname);
                                                                              getTransferPin();
                                                                            }
                                                                            // getTransferPin();
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


                                                      )

                                                  ),
                                              ),
                                            ),

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

                                                      Padding(
                                                        padding: const EdgeInsets.only(left: 44.0, top: 10.0),
                                                        child: Container(
                                                          child: Row(
                                                            children: <Widget>[

                                                              Padding(
                                                                padding: const EdgeInsets.only(right: 10),
                                                                child: Text("Amount:",style: TextStyle(fontSize: 12.0,color: Colors.black),),
                                                              ),

                                                              Container(
                                                                width: 250,
                                                                child: Padding(
                                                                  padding: const EdgeInsets.only(right: 5,left: 10),
                                                                  child: Theme(
                                                                    data: Theme.of(context).copyWith(splashColor: Colors.transparent),
                                                                    child: TextField(
                                                                      keyboardType: TextInputType.number,
                                                                      focusNode: phoneNumberFocusNode,
                                                                      onChanged: (text) {

                                                                        setState(() {
                                                                          amt = double.parse(text);
                                                                          amount = text;
                                                                        });

                                                                      },
                                                                      autofocus: false,
                                                                      style: TextStyle(fontSize: 13.0, color: Colors.black),
                                                                      decoration: InputDecoration(
                                                                        filled: true,
                                                                        fillColor: Color(0xFF7E768CA5),
                                                                        hintText: 'Enter Amount ',
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
                                                                child: Text("Narration:",style: TextStyle(fontSize: 12.0,color: Colors.black),),
                                                              ),

                                                              Container(
                                                                width: 240,
                                                                child: Padding(
                                                                  padding: const EdgeInsets.only(right: 5),
                                                                  child: Theme(
                                                                    data: Theme.of(context).copyWith(splashColor: Colors.transparent),
                                                                    child: TextField(
                                                                      keyboardType: TextInputType.text,

                                                                      onChanged: (text) {
                                                                        setState(() {
                                                                          narration = text;
                                                                        });
                                                                      },
                                                                      autofocus: false,
                                                                      style: TextStyle(fontSize: 13.0, color: Colors.black),
                                                                      decoration: InputDecoration(
                                                                        filled: true,
                                                                        fillColor: Color(0xFF7E768CA5),
                                                                        hintText: 'Enter narration',
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
                                                            ],
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
                                                                width: 230,
                                                                height: 50,
                                                                child: Padding(
                                                                  padding: const EdgeInsets.only(left: 10),
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
                                                                    if (amt < 1000){
                                                                      Alert(
                                                                          context: context,
                                                                          title: "Failed",
                                                                          desc: "You can not withdraw less than 1000 ",
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
                                                                      if (balan < 1200){
                                                                        Alert(
                                                                            context: context,
                                                                            title: "Insuffiecient Balance",
                                                                            desc: "To withdraw, you must have a minimum of 1200 in your savease account",
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

                                                                        if(bankname == "Select bank" && bankcode.isEmpty){
                                                                          setState(() {
                                                                            bankname = lists[0]["BankName"];
                                                                            bankaccountname = lists[0]["BankName"];
                                                                            bankcode = lists[0]["bankCode"];
                                                                            userAccountNumber = lists[0]["AccountNumber"];
                                                                          });
                                                                          getTransferPin();

                                                                          print(bankcode);
                                                                        }else{
                                                                          print(bankname);
                                                                          getTransferPin();
                                                                        }
                                                                        // getTransferPin();
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
      sendSmsme();
    });


  }

  _getUsers() {

    API.getUsers().then((response) {
      setState(() {

        final responseJson = json.decode(response.body);

        setState(() {
          list = responseJson["data"];
        });


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

  _DoTransfer() async {
    var one = int.parse(amount);
    var two = one * 100;

    pr = new ProgressDialog(context, ProgressDialogType.Normal);
    pr.setMessage("Transferring...");
    pr.show();
    // set up POST request arguments
    String url = 'https://api.paystack.co/transfer';
    Map<String, String> headers = {"Content-type": "application/json","authorization":"${apiKey}"};
    String jsonString = '{"source": "balance", "reason": "${narration}", "amount": ${two},"recipient": "${userRef}"}';
    // make POST request
    Response response = await post(url, headers: headers, body: jsonString);
    // check the status code for the result

    // this API passes back the id of the new item added to the body
    final responseJson = json.decode(response.body);
    pr.hide();
    print(responseJson);

    if(responseJson["message"] == "Transfer has been queued"){
      pr.hide();
      getlogin();


    }else{
      pr.hide();
      Alert(
          context: context,
          title: "Failed",
          desc: "There was an issue with transferring the funds, please try again",
          image: Image.asset("assets/image/sad.png"),
          buttons: [
            DialogButton(
              color: Color(0xff212435),
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(
                "Ok",
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
            )
          ]
      ).show();

    }

  }

  _creatRef() async {
    // set up POST request arguments
    String url = 'https://api.paystack.co/transferrecipient';
    Map<String, String> headers = {"Content-type": "application/json","authorization":"${apiKey}"};
    String jsonString = '{"type": "nuban", "name": "${bankaccountname}", "description": "Creating transfer rep","account_number": "${userAccountNumber}","bank_code": "${bankcode}","currency": "NGN"}';
    // make POST request
    Response response = await post(url, headers: headers, body: jsonString);
    // check the status code for the result

    // this API passes back the id of the new item added to the body
    final responseJson = json.decode(response.body);


    if(responseJson != null){
      setState(() {

          userRef = responseJson["data"]["recipient_code"];

        showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                content: SingleChildScrollView(
                  physics: AlwaysScrollableScrollPhysics(),
                  child: Container(

                    height : MediaQuery.of(context).size.height,
                    child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[

                          Align(
                            alignment: Alignment.center,
                              child: Text("From",style: TextStyle(fontSize: 15.0,color: Colors.black),)),
                          Padding(
                            padding: const EdgeInsets.only(left: 40,right: 40,bottom: 15),
                            child: Container(
                              height: 150,
                              width: 150,
                              child: Card(
                                elevation: 6.0,
                                child: Padding(
                                  padding: const EdgeInsets.only(bottom: 3),
                                  child: Column(
                                    children: <Widget>[
                                      Container(
                                        color: Color(0xff212435),
                                        width: MediaQuery.of(context).size.width,
                                        height: 20,
                                          child: Align(
                                            alignment: Alignment.center,
                                              child: Text("Savease",style: TextStyle(fontSize: 15.0,color: Colors.white),))),

                                      Padding(
                                        padding: const EdgeInsets.only(top: 15),
                                        child: Container(

                                            width: MediaQuery.of(context).size.width,
                                            height: 20,
                                            child: Align(
                                              alignment: Alignment.center,
                                                child: Text("Savease Account",style: TextStyle(fontSize: 15.0, color: Color(0xff212435),),))),
                                      ),

                                      Padding(
                                        padding: const EdgeInsets.only(top: 15),
                                        child: Container(

                                            width: MediaQuery.of(context).size.width,
                                            height: 20,
                                            child: Align(
                                              alignment: Alignment.center,
                                                child: Text(username,style: TextStyle(fontSize: 15.0, color: Color(0xff212435),),))),
                                      ),



                                      Padding(
                                        padding: const EdgeInsets.only(top: 25),
                                        child: Container(

                                            width: MediaQuery.of(context).size.width,
                                            height: 20,
                                            child: Align(
                                                alignment: Alignment.center,
                                                child: Text("N${balance}",style: TextStyle(fontSize: 15.0, color: Color(0xff212435),),))),
                                      ),

                                      ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 15),
                            child: Align(
                                alignment: Alignment.center,
                                child: Icon(
                                  Icons.arrow_downward,color: Colors.black,size: 30,),
                            ),
                          ),


                          Padding(
                            padding: const EdgeInsets.only(top: 15),
                            child: Align(
                                alignment: Alignment.center,
                                child: Text("To",style: TextStyle(fontSize: 15.0,color: Colors.black),)),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 40,right: 40,bottom: 15),
                            child: Container(
                              height: 150,
                              width: 200,
                              child: Card(
                                elevation: 6.0,
                                child: Padding(
                                  padding: const EdgeInsets.only(bottom: 3),
                                  child: Column(
                                    children: <Widget>[
                                      Container(
                                          color: Color(0xff212435),
                                          width: MediaQuery.of(context).size.width,
                                          height: 20,
                                          child: Align(
                                              alignment: Alignment.center,
                                              child: Text(bankname,style: TextStyle(fontSize: 15.0,color: Colors.white),))),

                                      Padding(
                                        padding: const EdgeInsets.only(top: 15),
                                        child: Container(

                                            width: MediaQuery.of(context).size.width,
                                            height: 20,
                                            child: Align(
                                                alignment: Alignment.center,
                                                child: Text(userAccountNumber,style: TextStyle(fontSize: 15.0, color: Color(0xff212435),),))),
                                      ),

                                      Padding(
                                        padding: const EdgeInsets.only(top: 15),
                                        child: Container(

                                            width: MediaQuery.of(context).size.width,
                                            child: Align(
                                                alignment: Alignment.center,
                                                child: Text(bankaccountname,style: TextStyle(fontSize: 13.0, color: Color(0xff212435),),textAlign: TextAlign.center,))),
                                      ),



                                      Padding(
                                        padding: const EdgeInsets.only(top: 15),
                                        child: Container(

                                            width: MediaQuery.of(context).size.width,
                                            height: 20,
                                            child: Align(
                                                alignment: Alignment.center,
                                                child: Text("---",style: TextStyle(fontSize: 15.0, color: Color(0xff212435),),))),
                                      ),



                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),

                          Padding(
                            padding: const EdgeInsets.only( top: 20.0),
                            child: Container(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: <Widget>[

                                  Padding(
                                    padding: const EdgeInsets.only(right: 10),
                                    child: Text("Amount :",style: TextStyle(fontSize: 14.0,color: Colors.black,fontFamily:"sfprodisplaybold", ),),
                                  ),

                                  Container(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(amount,style: TextStyle(fontSize: 14.0,color: Colors.black,fontFamily:"sfprodisplaybold",)),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),

                          Align(
                            alignment: Alignment.center,
                            child: Padding(
                              padding: const EdgeInsets.only(left: 34.0, top: 15.0,right: 30.0, bottom: 20),
                              child: Container(
                                width: 90.0,
                                child: ButtonTheme(
                                  minWidth: 60.0,
                                  height: 30.0,

                                  child :  RaisedButton(
                                      onPressed: () {
                                          _DoTransfer();
                                        // Navigator.push(context, MaterialPageRoute(builder: (context) => LoginScreen()));
                                      },
                                      textColor: Colors.white,
                                      color: Color(0xffFA9928),
                                      child: const Text('Transfer',style: TextStyle(fontFamily: "sfprodisplaylight",fontSize: 11)),
                                      shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(10.0))
                                  ),
                                ),
                              ),
                            ),
                          ),

                        ]
                    ),
                  ),
                ),
              );

            });
      });
    }else{
      pr.hide();

    }






  }

  getTransferPin() async {
    if (pinCode.isEmpty || pinCode == ""  ){
      Toast.show("Please enter your pin code", context, duration: Toast.LENGTH_LONG, gravity:  Toast.BOTTOM);
    }else {

      if (amount.isNotEmpty || amount != ""){
        if( narration.isEmpty || narration == ""){
          Toast.show("Please enter your narration for the transfer", context, duration: Toast.LENGTH_LONG, gravity:  Toast.BOTTOM);

        }else{
          final prefs = await SharedPreferences.getInstance();
          pr = new ProgressDialog(context, ProgressDialogType.Normal);
          pr.setMessage("Verifying pin..");
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
            _creatRef();
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
      }else{
        Toast.show("Please specify amount to withdraw", context, duration: Toast.LENGTH_LONG, gravity:  Toast.BOTTOM);
      }

    }
  }

  sendSmsme() async {
    var now = new DateTime.now();
    var a = double.parse(amount);
    String newString = username.substring(0, 3) + "XXXX" + username.substring(3+4);
    var e = bal - a;
    String b = e.toStringAsFixed(2);

    String time = new DateFormat("dd-MM-yyyy").format(now);

    final response =
    await http.get('https://www.bulksmsnigeria.com/api/v1/sms/create?api_token=${smsPrivateKey}&from=SAVEASE&to=0${accountNumer}&body=Your Acct ${newString} Has Been Debited with NGN ${amount} On ${time} By TRANSFER - (Transaction Ref) Bal: +NGN${b}DB,  Kindly dial *384*3358# to use our USSD platform&dnd=2');

    if (response.statusCode == 200) {
      // If server returns an OK response, parse the JSON.
      if (response.body != null){

        Alert(
            context: context,
            title: "Success",
            desc: "your withrawal has been queued",
            image: Image.asset("assets/image/smiley.png"),
            buttons: [
              DialogButton(
                color: Color(0xff212435),
                onPressed: () {
                  print(response.body);
                  Navigator.push(context, MaterialPageRoute(builder: (context) => Home()));


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
