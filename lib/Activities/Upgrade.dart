import 'dart:convert';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:keyboard_actions/keyboard_actions.dart';
import 'package:keyboard_visibility/keyboard_visibility.dart';
import 'package:location/location.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:savease/Auth/Login.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:xml2json/xml2json.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:toast/toast.dart';

class Company {
  var title;

  Company( this.title);

  static List<Company> getCompanies() {
    return <Company>[
      Company('Relationship with Kin'),
      Company( 'Father'),
      Company( 'Mother'),
      Company( 'Sister'),
      Company( 'Brother'),
      Company( 'Wife'),
      Company( 'Husband'),
      Company( 'Son'),
      Company( 'Daughter'),
      Company( 'Other'),


    ];
  }
}
String smsPrivateKey = '9Pc1XtdCYg43wdJ6AlbCSCyTlLqc2voEFpl9DvmUq0zcKJTDbdE4aOYOPtzz';
class Upgrade extends StatefulWidget {

  Map<String,String> data = new Map();

  Upgrade({Key key, this.data}) : super(key: key);
  @override
  _VerifycreenState createState() => new _VerifycreenState();
}

class _VerifycreenState extends State<Upgrade> {
  Xml2Json xml2json = new Xml2Json();
  ProgressDialog pr;
  String _pin;
  OverlayEntry overlayEntry;
  FocusNode phoneNumberFocusNode = new FocusNode();
  List<Company> _companies = Company.getCompanies();
  List<DropdownMenuItem<Company>> _dropdownMenuItems;
  Company _selectedCompany;
  String busAdd;
  String busState;
  String busTown;
  String homeAdd;
  String homeState;
  String homeTown;
  String nextKin;
  String nextKinPhone;
  String nextKinRelationship;
  bool checked = false;
  String accountNum = "";
  String name = "";
  String phone = "";
  var databaseRef;
  var location = Location();

  void updateLocation() async{
    final prefs = await SharedPreferences.getInstance();

    try {
      var userLocation = await location.getLocation();
      databaseRef.child("Vendors").child(accountNum).update({
        'status': 'Not Available',
        'longitude': userLocation.longitude,
        'latitude': userLocation.latitude,
        'vendorAddress': busAdd,
        'vendorName': name,
        'vendorNumber': phone
      });
      prefs.setString('sta','false');
    } on Exception catch (e) {
      print('Could not get location: ${e.toString()}');
    }


  }


  void getData() async{
    final prefs = await SharedPreferences.getInstance();

    String  fname = prefs.getString('fname') ?? '';
    String  lname = prefs.getString('lname') ?? '';
    String  type = prefs.getString('userType') ?? '';
    String user = prefs.getString('saveaseid') ?? '';


    if(fname != null || fname != ""){

      setState(() {
        accountNum = user;
        name = fname + " "+ lname;
        phone = "0"+user;
      });

    }else{


    }


  }
  getlogin() async {
    final prefs = await SharedPreferences.getInstance();
    pr = new ProgressDialog(context, ProgressDialogType.Normal);
    pr.setMessage("Saving..please wait");
    pr.show();
    String soap = '''<?xml version="1.0" encoding="utf-8"?>
<soap:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">
  <soap:Body>
    <updatesaveaseBusiness xmlns="http://savease.ng/">
      <saveaseId>string</saveaseId>
      <BusinessAddress>${widget.data["busAdd"]}</BusinessAddress>
      <BusinessAddress_Town>${widget.data["busTown"]}</BusinessAddress_Town>
      <BusinessAddress_State>${widget.data["busState"]}</BusinessAddress_State>
      <HomeAddress>${widget.data["homeAdd"]}</HomeAddress>
      <HomeAddress_town>${widget.data["homeTown"]}</HomeAddress_town>
      <HomeAddress_State>${widget.data["homeState"]}</HomeAddress_State>
      <NextOfKin>${nextKin}</NextOfKin>
      <NextOfkin_Phone>${nextKinPhone}</NextOfkin_Phone>
      <Relationship_With_Kin>${nextKinRelationship}</Relationship_With_Kin>
    </updatesaveaseBusiness>
  </soap:Body>
</soap:Envelope>''';

    http.Response response = await http.post(
      'http://savease.ng/webservice1.asmx?op=updatesaveaseBusiness',
      headers: {
        "SOAPAction": "http://savease.ng/updatesaveaseBusiness",
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
    var code = responses['soap:Envelope']['soap:Body']['updatesaveaseBusinessResponse']['updatesaveaseBusinessResult'];
    print(code);
    if (code == "1") {
      pr.hide();
      // getBalance();
      upgradeAccount();

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

  upgradeAccount() async {
    final prefs = await SharedPreferences.getInstance();
    pr = new ProgressDialog(context, ProgressDialogType.Normal);
    pr.setMessage("Upgrading..please wait");
    pr.show();
    String soap = '''<?xml version="1.0" encoding="utf-8"?>
<soap:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">
  <soap:Body>
    <updateUlevel xmlns="http://savease.ng/">
      <saveaseid>${accountNum}</saveaseid>
    </updateUlevel>
  </soap:Body>
</soap:Envelope>''';

    http.Response response = await http.post(
      'http://savease.ng/webservice1.asmx?op=updateUlevel',
      headers: {
        "SOAPAction": "http://savease.ng/updateUlevel",
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
    var code = responses['soap:Envelope']['soap:Body']['updateUlevelResponse']['updateUlevelResult'];
    print(code);
    if (code == "1") {
      pr.hide();
      // getBalance();
      updateLocation();
      sendSmsme();
      showAlertDialogSuccess(context);

    } else {
      pr.hide();
      Alert(
          context: context,
          title: "Failed",
          desc: "Upgrade failed",
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
  showAlertDialogSuccess(BuildContext context) {
    // set up the buttons

    Widget continueButton = FlatButton(
      child: Text("Ok"),
      onPressed:  () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => LoginScreen()));
      },
    );
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Upgraded to Savease Business"),
      content: Text("Welcome to Savease Business.\n You are now a Savease Agent/Vendor, start selling and start getting commissions."),
      actions: [
        continueButton,
      ],
    );
    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
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
      nextKinRelationship = _selectedCompany.title;

    });
  }

  void _back() {
    Navigator.pop(context);
  }
  @override
  void initState() {
    databaseRef = FirebaseDatabase.instance.reference();
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
    getData();
    _dropdownMenuItems = buildDropdownMenuItems(_companies);
    _selectedCompany = _dropdownMenuItems[0].value;
    super.initState();

  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/image/bne.png"),
            fit: BoxFit.cover,
          ),
        ),

        child:SingleChildScrollView(
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
                GestureDetector(
                  onTap: _back,
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 50.0,left: 20.0),
                      child: Icon(Icons.arrow_back_ios,),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 70.0,right: 10,left: 44),
                    child: Container(
                        width: 150.0,
                        child: Image.asset("assets/image/logo.png",width: 150,height: 50,)),),
                ),


                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 10,left: 44,right: 44),
                    child: Text("THanks for sticking around, to complete the upgrade, provide the details of your next of kin.", style: new TextStyle(fontSize: 14.0, fontWeight: FontWeight.bold, fontFamily: "sfprodisplaylight",),),
                  ),
                ),


                Expanded(
                  child: ListView(
                    children: <Widget>[

                      Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 44.0, top: 25.0,right: 30.0),
                          child: Theme(
                            data: Theme.of(context).copyWith(splashColor: Colors.transparent),
                            child: TextField(
                              onChanged: (text) {

                                setState(() {
                                  nextKin = text;
                                });

                              },
                              autofocus: false,
                              style: TextStyle(fontSize: 13.0, color: Colors.black),
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Color(0xFF7E768CA5),
                                hintText: 'Next of Kin',
                                contentPadding:
                                const EdgeInsets.only(left: 14.0, bottom: 12.0, top: 12.0),
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
                          padding: const EdgeInsets.only(left: 44.0, top: 20.0,right: 30.0),
                          child: Theme(
                            data: Theme.of(context).copyWith(splashColor: Colors.transparent),
                            child: TextField(
                              onChanged: (text) {
                                setState(() {
                                  nextKinPhone = text;
                                });

                              },
                              keyboardType: TextInputType.phone,
                              focusNode: phoneNumberFocusNode,
                              obscureText: false,
                              autofocus: false,
                              style: TextStyle(fontSize: 13.0, color: Colors.black),
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Color(0xFF7E768CA5),
                                hintText: 'Next of Kin Telephone',
                                contentPadding:
                                const EdgeInsets.only(left: 14.0, bottom: 12.0, top: 12.0),
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
                          padding: const EdgeInsets.only(top: 20,left: 44.0,right: 44),
                          child: Column(
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.only(top: 2),
                                child: Container(
                                  width: MediaQuery.of(context).size.width,
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


                            ],
                          ),
                        ),
                      ),

                      Align(
                        alignment: Alignment.center,
                        child: Padding(
                          padding: EdgeInsets.only(left: 44.0, top: 20.0,right: 30.0,bottom: MediaQuery.of(context).viewInsets.bottom,),
                          child: Container(
                            width: 150.0,
                            child: ButtonTheme(
                              minWidth: 100.0,
                              height: 50.0,

                              child :  RaisedButton(
                                  onPressed: () {
                                      getlogin();
                                  },
                                  textColor: Colors.white,
                                  color:  Color(
                                      0xff212435),
                                  child: const Text('Upgrade',style: TextStyle(fontFamily: "sfprodisplaybold")),
                                  shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(10.0))
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
        ),

      ),
    );
  }

  sendSmsme() async {
    var now = new DateTime.now();
    String time = new DateFormat("dd-MM-yyyy").format(now);

    final response =
    await http.get('https://www.bulksmsnigeria.com/api/v1/sms/create?api_token=${smsPrivateKey}&from=SAVEASE&to=0${accountNum}&body=Welcome to Savease Business. You are now a Savease Agent/Vendor which was in effect stating from ${time}&dnd=2');

    if (response.statusCode == 200) {
      // If server returns an OK response, parse the JSON.
      if (response.body != null){

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