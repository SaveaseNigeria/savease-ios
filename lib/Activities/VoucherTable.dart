import 'dart:convert';
import 'dart:io';
import 'dart:ui';
import 'package:device_info/device_info.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:savease/Activities/AccountOfficer.dart';
import 'package:savease/Activities/PrintPage.dart';
import 'package:savease/Utils/ZoomScaffoldActivites.dart';
import 'package:savease/Utils/fintnessAppTheme.dart';
import 'package:savease/Utils/menu_page.dart';
import 'package:share_extend/share_extend.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:xml2json/xml2json.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io' as io;


String smsPrivateKey = '9Pc1XtdCYg43wdJ6AlbCSCyTlLqc2voEFpl9DvmUq0zcKJTDbdE4aOYOPtzz';
class VOucherTable extends StatefulWidget {
  @override
  _HoomeState createState() => new _HoomeState();
}

class Company {
  var title;

  Company(this.title);

  static List<Company> getCompanies() {
    return <Company>[
      Company( 'Select Criteria'),
      Company( 'Used Voucher'),
      Company( 'Unused Voucher'),

    ];
  }
}

class _HoomeState extends State<VOucherTable> with TickerProviderStateMixin {
  List<Company> _companies = Company.getCompanies();
  List<DropdownMenuItem<Company>> _dropdownMenuItems;
  bool _isVisible = false;
  bool _isVisiblesavease = false;
  var scr= new GlobalKey();
  final key = new GlobalKey<ScaffoldState>();
  Company _selectedCompany;
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
  String cardAmount;
  String cardPin;
  String cardSerial;
  String cardBatch;
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
                  child: Text(company.title,style: TextStyle(fontSize: 16.0,color: Colors.white),),
                ),
              ],
            ),
          ),
        ),
      );
    }
    return items;
  }

  takescrshot() async {
    var now = new DateTime.now();
    String time = new DateFormat("dd-MM-yyyy").format(now);
    String directory = (await getApplicationDocumentsDirectory()).path;
    if (await io.Directory(directory + "/savease").exists() != true) {
      print("Directory not exist");
      new io.Directory(directory + "/savease").createSync(recursive: true);
      RenderRepaintBoundary boundary = scr.currentContext.findRenderObject();
      var image = await boundary.toImage();
      var byteData = await image.toByteData(format: ImageByteFormat.png);
      var pngBytes = byteData.buffer.asUint8List();
      final File newImage = new File('$directory/savease/$time.png');
      await newImage.writeAsBytes(pngBytes);
      print(newImage.path);
      print(pngBytes);
      ShareExtend.share(newImage.path, "image");

    } else {
      print("Directoryexist");
      RenderRepaintBoundary boundary = scr.currentContext.findRenderObject();
      var image = await boundary.toImage();
      var byteData = await image.toByteData(format: ImageByteFormat.png);
      var pngBytes = byteData.buffer.asUint8List();
      final File newImage = new File('$directory/savease/$time.png');
      await newImage.writeAsBytes(pngBytes);
      print(newImage.path);
      print(pngBytes);

      ShareExtend.share(newImage.path, "image");


     

    }

  }

  takescrshotAndPrint() async {
    var now = new DateTime.now();
    String time = new DateFormat("dd-MM-yyyy").format(now);
    String directory = (await getApplicationDocumentsDirectory()).path;
    if (await io.Directory(directory + "/savease").exists() != true) {
      print("Directory not exist");
      new io.Directory(directory + "/savease").createSync(recursive: true);
      RenderRepaintBoundary boundary = scr.currentContext.findRenderObject();
      var image = await boundary.toImage();
      var byteData = await image.toByteData(format: ImageByteFormat.png);
      var pngBytes = byteData.buffer.asUint8List();
      final File newImage = new File('$directory/savease/$time.png');
      await newImage.writeAsBytes(pngBytes);
      print(newImage.path);
      ShareExtend.share(newImage.path, "image");

    } else {
      print("Directoryexist");
      RenderRepaintBoundary boundary = scr.currentContext.findRenderObject();
      var image = await boundary.toImage();
      var byteData = await image.toByteData(format: ImageByteFormat.png);
      var pngBytes = byteData.buffer.asUint8List();
      final File newImage = new File('$directory/savease/$time.png');
      await newImage.writeAsBytes(pngBytes);
      print(newImage.path);
      ShareExtend.share(newImage.path, "image");




    }

  }

  _onTapImage(BuildContext context) {
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
               border: Border.all(color:  Color(0xff212435),style: BorderStyle.solid,width: 5 ),
               image: DecorationImage(
                 image: AssetImage("assets/image/white.png"),
                 fit: BoxFit.cover,
               ),
             ),
             child: Column(
               children: <Widget>[
                 Padding(
                   padding: const EdgeInsets.only(top: 20,left: 10,right: 10,bottom: 8),
                   child: Row(
                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                     children: <Widget>[
                       Text(
                           "Voucher amount :",
                           style: TextStyle(
                               decoration: TextDecoration.none,
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

                           cardamount,
                           style: TextStyle(
                             decoration: TextDecoration.none,
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
                 ),
                 Padding(
                   padding: const EdgeInsets.only(left: 10,right: 10,bottom: 4),
                   child: Row(
                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                     children: <Widget>[
                       Text(
                           "Voucher pin :",
                           style: TextStyle(
                               decoration: TextDecoration.none,
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
                           cardPin,
                           style: TextStyle(
                               decoration: TextDecoration.none,
                               fontFamily:
                               "sfprodisplaylight",
                               fontSize:
                               13.0,
                               fontWeight:
                               FontWeight
                                   .bold,
                               color: Color(
                                   0xff212435) )),

                     ],
                   ),
                 ),
                 Padding(
                   padding: const EdgeInsets.only(left: 10,right: 10,bottom: 4),
                   child: Row(
                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                     children: <Widget>[
                       Text(
                           "Voucher serial :",
                           style: TextStyle(
                               decoration: TextDecoration.none,
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
                           cardSerial,
                           style: TextStyle(
                               decoration: TextDecoration.none,
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
                 ),
                 Padding(
                   padding: const EdgeInsets.only(left: 10,right: 10,bottom: 4),
                   child: Row(
                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                     children: <Widget>[
                       Text(
                           "Batch number :",
                           style: TextStyle(
                               decoration: TextDecoration.none,
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
                           cardBatch,
                           style: TextStyle(
                               decoration: TextDecoration.none,
                               fontFamily:
                               "sfprodisplaylight",
                               fontSize:
                               13.0,
                               fontWeight:
                               FontWeight
                                   .bold,
                               color: Color(
                                   0xff212435) )),




                     ],
                   ),
                 ),

                 Align(
                   alignment: Alignment.centerRight,
                   child: Padding(
                     padding: const EdgeInsets.only(top: 10.0,right: 10),
                     child: Container(
                         width: 90.0,
                         child: Image.asset("assets/image/logo.png")),),
                 )

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

                      takescrshot();
                      // Navigator.push(context, MaterialPageRoute(builder: (context) => LoginScreen()));
                    },
                    textColor: Colors.white,
                    color: Color(0xffFA9928),
                    child: const Text('Share',style: TextStyle(fontFamily: "sfprodisplaybold")),
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
  }

  _onTapPdf(BuildContext context) {
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
                border: Border.all(color:  Color(0xff212435),style: BorderStyle.solid,width: 5 ),
                image: DecorationImage(
                  image: AssetImage("assets/image/white.png"),
                  fit: BoxFit.cover,
                ),
              ),
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(top: 20,left: 10,right: 10,bottom: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                            "Voucher amount :",
                            style: TextStyle(
                                decoration: TextDecoration.none,
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

                            cardamount,
                            style: TextStyle(
                                decoration: TextDecoration.none,
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
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 10,right: 10,bottom: 4),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                            "Voucher pin :",
                            style: TextStyle(
                                decoration: TextDecoration.none,
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
                            cardPin,
                            style: TextStyle(
                                decoration: TextDecoration.none,
                                fontFamily:
                                "sfprodisplaylight",
                                fontSize:
                                13.0,
                                fontWeight:
                                FontWeight
                                    .bold,
                                color: Color(
                                    0xff212435) )),

                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 10,right: 10,bottom: 4),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                            "Voucher serial :",
                            style: TextStyle(
                                decoration: TextDecoration.none,
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
                            cardSerial,
                            style: TextStyle(
                                decoration: TextDecoration.none,
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
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 10,right: 10,bottom: 4),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                            "Batch number :",
                            style: TextStyle(
                                decoration: TextDecoration.none,
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
                            cardBatch,
                            style: TextStyle(
                                decoration: TextDecoration.none,
                                fontFamily:
                                "sfprodisplaylight",
                                fontSize:
                                13.0,
                                fontWeight:
                                FontWeight
                                    .bold,
                                color: Color(
                                    0xff212435) )),




                      ],
                    ),
                  ),

                  Align(
                    alignment: Alignment.centerRight,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 10.0,right: 10),
                      child: Container(
                          width: 90.0,
                          child: Image.asset("assets/image/logo.png")),),
                  )

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
                     // takescrshotAndPrint();
                      // Navigator.push(context, MaterialPageRoute(builder: (context) => LoginScreen()));
                    },
                    textColor: Colors.white,
                    color: Color(0xffFA9928),
                    child: const Text('Print',style: TextStyle(fontFamily: "sfprodisplaybold")),
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
  }

  onChangeDropdownItem(Company selectedCompany) {
    setState(() {
      _selectedCompany = selectedCompany;
      cardamount = selectedCompany.title;
      if(selectedCompany.title == "Select Criteria"){
        list = [];
      }else if(selectedCompany.title == "Used Voucher"){
        setState(() {
          _isVisiblesavease = true;
          _isVisible = false;
          getUsed();
        });


      }else if(selectedCompany.title == "Unused Voucher"){
        setState(() {
          _isVisiblesavease = false;
          _isVisible = true;
          getUnused();
        });


      }

    });
  }

  @override
  void dispose() {
    menuController.dispose();
    super.dispose();
  }

  getUnused() async {
    list = [];
    print(userId);
    String soap = '''<?xml version="1.0" encoding="utf-8"?>
<soap:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">
  <soap:Body>
    <displayTblUnused xmlns="http://savease.ng/">
      <uname>${userId}</uname>
    </displayTblUnused>
  </soap:Body>
</soap:Envelope>''';

    http.Response response = await http.post(
      'http://savease.ng/webservice1.asmx?op=displayTblUnused',
      headers: {
        "SOAPAction": "http://savease.ng/displayTblUnused",
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
    final lists = responses['soap:Envelope']['soap:Body']['displayTblUnusedResponse']['displayTblUnusedResult'];

    setState(() {
      list = jsonDecode(lists);
    });

    print(list[0]);

  }

  getUsed() async {
    list = [];
    print(userId);
    String soap = '''<?xml version="1.0" encoding="utf-8"?>
<soap:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">
  <soap:Body>
    <displayTblUsed xmlns="http://savease.ng/">
      <uname>${userId}</uname>
    </displayTblUsed>
  </soap:Body>
</soap:Envelope>''';

    http.Response response = await http.post(
      'http://savease.ng/webservice1.asmx?op=displayTblUsed',
      headers: {
        "SOAPAction": "http://savease.ng/displayTblUsed",
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
    final lists = responses['soap:Envelope']['soap:Body']['displayTblUsedResponse']['displayTblUsedResult'];
    setState(() {
      list = jsonDecode(lists);

    });

    print(list[0]);

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset : false,
        resizeToAvoidBottomPadding: false,
        key: key,
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
                      child:Container(
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
                                  padding: const EdgeInsets.only(bottom: 0),
                                  child: SingleChildScrollView(
                                    physics: AlwaysScrollableScrollPhysics(),
                                    child: Container(
                                      child: Column(
                                        mainAxisSize: MainAxisSize.max,
                                        children: <Widget>[

                                          Align(
                                            alignment: Alignment.center,
                                            child: Padding(
                                              padding: const EdgeInsets.only(left: 44.0, top: 5.0,right: 30.0),
                                              child: Text("Voucher Table", style: TextStyle(fontSize: 17.0,fontFamily: "sfprodisplayheavy",color: Colors.black)),
                                            ),
                                          ),

                                          Align(
                                            alignment: Alignment.center,
                                            child: Padding(
                                              padding: const EdgeInsets.only(left: 44.0, top: 5.0,right: 30.0),
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
                                                    padding: const EdgeInsets.only(left: 30,right: 40),
                                                    child: Container(
                                                      width: MediaQuery.of(context).size.width ,
                                                      height: 40,
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

                                           Column(
                                             children: <Widget>[
                                               Padding(
                                                 padding: const EdgeInsets.only(left: 10,right: 10,bottom: 10),
                                                 child: Container(
                                                   child: Container(
                                                     margin: EdgeInsets.symmetric(

                                                     ),
                                                     height: MediaQuery.of(context).size.height/2.5,
                                                     child: ListView.builder(
                                                       shrinkWrap: true,
                                                         scrollDirection: Axis.vertical,
                                                         itemCount: list.length,
                                                         itemBuilder: (BuildContext ctxt, int index){
                                                           List<String> option = <String>[
                                                             "Share",
                                                             "Print"
                                                           ];
                                                           String amount = list[index]["Amount"].toStringAsFixed(2);
                                                           String used = "";
                                                           String usedDate = "";
                                                           if(list[index]["UsedBy"] == null){
                                                             used = "";
                                                           }else {
                                                             used = list[index]["UsedBy"];
                                                           }

                                                           if(list[index]["UsedDate"] == null){
                                                             usedDate = "";
                                                           }else {
                                                             usedDate = list[index]["UsedDate"];
                                                           }
                                                           return Column(
                                                             children: <Widget>[
                                                               Visibility(
                                                                 visible: _isVisible,
                                                                 child: Container(
                                                                   child: Card(
                                                                     elevation: 9.0,
                                                                     child: Padding(
                                                                       padding: const EdgeInsets.all(8.0),
                                                                       child: Column(
                                                                         children: <Widget>[

                                                                           Padding(
                                                                             padding: const EdgeInsets.only(top: 6,left: 4,right: 4,bottom: 6),
                                                                             child: Row(
                                                                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                               children: <Widget>[
                                                                                 Text(
                                                                                     "Voucher Status :",
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
                                                                                 Row(
                                                                                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                   children: <Widget>[

                                                                                     Align(
                                                                                       alignment: Alignment.centerRight,
                                                                                       child: Text(
                                                                                           list[index]["VoucherStatus"],
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
                                                                                     PopupMenuButton<String>(
                                                                                         onSelected: ( value){
                                                                                           if(value == "Share"){
                                                                                             setState(() {
                                                                                               cardamount = amount;
                                                                                               cardPin = list[index]["VoucherPin"];
                                                                                               cardSerial =list[index]["SerialNumber"];
                                                                                               cardBatch = list[index]["BatchNo"];
                                                                                             });
                                                                                             showDialog(
                                                                                               context: context,
                                                                                               builder: (_) => _onTapImage(context),
                                                                                             );
                                                                                           }else{
                                                                                             setState(() {
                                                                                               cardamount = amount;
                                                                                               cardPin = list[index]["VoucherPin"];
                                                                                               cardSerial =list[index]["SerialNumber"];
                                                                                               cardBatch = list[index]["BatchNo"];
                                                                                             });
                                                                                             showDialog(
                                                                                               context: context,
                                                                                               builder: (_) => _onTapPdf(context),
                                                                                             );
                                                                                           }
                                                                                         },
                                                                                         itemBuilder: (context) {
                                                                                           return option.map((String choice){
                                                                                             return PopupMenuItem<String>(
                                                                                               value: choice,
                                                                                               child: Text(choice),
                                                                                             );
                                                                                           }).toList();

                                                                                         },
                                                                                         child: Icon(Icons.more_vert, color: Colors.black,size: 20)),

                                                                                   ],
                                                                                 ),

                                                                               ],
                                                                             ),
                                                                           ),
                                                                           Padding(
                                                                             padding: const EdgeInsets.only(left: 4,right: 4,bottom: 2),
                                                                             child: Row(
                                                                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                               children: <Widget>[
                                                                                 Text(
                                                                                     "Voucher Amount :",
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
                                                                                     amount,
                                                                                     style: TextStyle(
                                                                                         fontFamily:
                                                                                         "sfprodisplaylight",
                                                                                         fontSize:
                                                                                         13.0,
                                                                                         fontWeight:
                                                                                         FontWeight
                                                                                             .bold,
                                                                                         color: Color(
                                                                                             0xff212435) )),

                                                                               ],
                                                                             ),
                                                                           ),
                                                                           GestureDetector(
                                                                             onLongPress: (){
                                                                               Clipboard.setData(new ClipboardData(text: list[index]["VoucherPin"]));
                                                                               key.currentState.showSnackBar(
                                                                                   new SnackBar(content: new Text("Copied to Clipboard"),));
                                                                             },
                                                                             child: Padding(
                                                                               padding: const EdgeInsets.only(left: 4,right: 4,bottom: 2),
                                                                               child: Row(
                                                                                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                 children: <Widget>[
                                                                                   Text(
                                                                                       "Voucher Pin :",
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
                                                                                       list[index]["VoucherPin"],
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
                                                                             ),
                                                                           ),
                                                                           Padding(
                                                                             padding: const EdgeInsets.only(left: 4,right: 4,bottom: 2),
                                                                             child: Row(
                                                                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                               children: <Widget>[
                                                                                 Text(
                                                                                     "Serial No. :",
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
                                                                                     list[index]["SerialNumber"],
                                                                                     style: TextStyle(
                                                                                         fontFamily:
                                                                                         "sfprodisplaylight",
                                                                                         fontSize:
                                                                                         13.0,
                                                                                         fontWeight:
                                                                                         FontWeight
                                                                                             .bold,
                                                                                         color: Color(
                                                                                             0xff212435) )),

                                                                               ],
                                                                             ),
                                                                           ),
                                                                           Padding(
                                                                             padding: const EdgeInsets.only(left: 4,right: 4,bottom: 2),
                                                                             child: Row(
                                                                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                               children: <Widget>[
                                                                                 Text(
                                                                                     "Batch No. :",
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
                                                                                     list[index]["BatchNo"],
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
                                                                           ),
                                                                           Padding(
                                                                             padding: const EdgeInsets.only(left: 4,right: 4,bottom: 2),
                                                                             child: Row(
                                                                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                               children: <Widget>[
                                                                                 Text(
                                                                                     "UsedBy :",
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
                                                                                     used,
                                                                                     style: TextStyle(
                                                                                         fontFamily:
                                                                                         "sfprodisplaylight",
                                                                                         fontSize:
                                                                                         13.0,
                                                                                         fontWeight:
                                                                                         FontWeight
                                                                                             .bold,
                                                                                         color: Color(
                                                                                             0xff212435) )),

                                                                               ],
                                                                             ),
                                                                           ),
                                                                           Padding(
                                                                             padding: const EdgeInsets.only(left: 4,right: 4,bottom: 2),
                                                                             child: Row(
                                                                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                               children: <Widget>[
                                                                                 Text(
                                                                                     "UsedDate :",
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
                                                                                     usedDate,
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
                                                                           ),

                                                                         ],
                                                                       ),
                                                                     ),
                                                                   ),
                                                                 ),
                                                               ),
                                                               Visibility(
                                                                 visible: _isVisiblesavease,
                                                                 child: Container(
                                                                   child: Card(
                                                                     elevation: 9.0,
                                                                     child: Padding(
                                                                       padding: const EdgeInsets.all(8.0),
                                                                       child: Column(
                                                                         children: <Widget>[

                                                                           Padding(
                                                                             padding: const EdgeInsets.only(top: 6,left: 4,right: 4,bottom: 6),
                                                                             child: Row(
                                                                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                               children: <Widget>[
                                                                                 Text(
                                                                                     "Voucher Status :",
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
                                                                                 Row(
                                                                                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                   children: <Widget>[

                                                                                     Align(
                                                                                       alignment: Alignment.centerRight,
                                                                                       child: Text(
                                                                                           list[index]["VoucherStatus"],
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


                                                                                   ],
                                                                                 ),

                                                                               ],
                                                                             ),
                                                                           ),
                                                                           Padding(
                                                                             padding: const EdgeInsets.only(left: 4,right: 4,bottom: 2),
                                                                             child: Row(
                                                                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                               children: <Widget>[
                                                                                 Text(
                                                                                     "Voucher Amount :",
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
                                                                                     amount,
                                                                                     style: TextStyle(
                                                                                         fontFamily:
                                                                                         "sfprodisplaylight",
                                                                                         fontSize:
                                                                                         13.0,
                                                                                         fontWeight:
                                                                                         FontWeight
                                                                                             .bold,
                                                                                         color: Color(
                                                                                             0xff212435) )),

                                                                               ],
                                                                             ),
                                                                           ),
                                                                           Padding(
                                                                             padding: const EdgeInsets.only(left: 4,right: 4,bottom: 2),
                                                                             child: Row(
                                                                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                               children: <Widget>[
                                                                                 Text(
                                                                                     "Voucher Pin :",
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
                                                                                     list[index]["VoucherPin"],
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
                                                                           ),
                                                                           Padding(
                                                                             padding: const EdgeInsets.only(left: 4,right: 4,bottom: 2),
                                                                             child: Row(
                                                                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                               children: <Widget>[
                                                                                 Text(
                                                                                     "Serial No. :",
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
                                                                                     list[index]["SerialNumber"],
                                                                                     style: TextStyle(
                                                                                         fontFamily:
                                                                                         "sfprodisplaylight",
                                                                                         fontSize:
                                                                                         13.0,
                                                                                         fontWeight:
                                                                                         FontWeight
                                                                                             .bold,
                                                                                         color: Color(
                                                                                             0xff212435) )),

                                                                               ],
                                                                             ),
                                                                           ),
                                                                           Padding(
                                                                             padding: const EdgeInsets.only(left: 4,right: 4,bottom: 2),
                                                                             child: Row(
                                                                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                               children: <Widget>[
                                                                                 Text(
                                                                                     "Batch No. :",
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
                                                                                     list[index]["BatchNo"],
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
                                                                           ),
                                                                           Padding(
                                                                             padding: const EdgeInsets.only(left: 4,right: 4,bottom: 2),
                                                                             child: Row(
                                                                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                               children: <Widget>[
                                                                                 Text(
                                                                                     "UsedBy :",
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
                                                                                     used,
                                                                                     style: TextStyle(
                                                                                         fontFamily:
                                                                                         "sfprodisplaylight",
                                                                                         fontSize:
                                                                                         13.0,
                                                                                         fontWeight:
                                                                                         FontWeight
                                                                                             .bold,
                                                                                         color: Color(
                                                                                             0xff212435) )),

                                                                               ],
                                                                             ),
                                                                           ),
                                                                           Padding(
                                                                             padding: const EdgeInsets.only(left: 4,right: 4,bottom: 2),
                                                                             child: Row(
                                                                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                               children: <Widget>[
                                                                                 Text(
                                                                                     "UsedDate :",
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
                                                                                     usedDate,
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
                                                                           ),

                                                                         ],
                                                                       ),
                                                                     ),
                                                                   ),
                                                                 ),
                                                               ),
                                                             ],
                                                           );
                                                         }),

                                                   ),
                                                 ),
                                               ),
                                             ],
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
        ));
  }


}
