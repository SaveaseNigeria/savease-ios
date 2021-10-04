import 'package:device_info/device_info.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'dart:typed_data';
import 'dart:ui';
import 'dart:io';
import 'package:flutter/rendering.dart';
import 'package:path_provider/path_provider.dart';
import 'package:savease/Activities/AccountOfficer.dart';
import 'package:savease/Utils/ZoomScaffoldActivites.dart';
import 'package:savease/Utils/fintnessAppTheme.dart';
import 'package:savease/Utils/menu_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GenerateScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => GenerateScreenState();
}

class GenerateScreenState extends State<GenerateScreen>
    with TickerProviderStateMixin {
  String accountNumer = "";
  static const double _topSectionTopPadding = 50.0;
  static const double _topSectionBottomPadding = 20.0;
  static const double _topSectionHeight = 50.0;

  GlobalKey globalKey = new GlobalKey();
  String _dataString = "Hello from this QR";
  String _inputErrorText;
  final TextEditingController _textController = TextEditingController();
  String accountName = "";
  String type = "";
  String cardamount = "";
  String balance = "";
  String email = "";
  String cardName = "";
  String cardNumber = "";
  String username = "";
  String userId;
  String cvc = "";
  String amountForApi = "";
  var qty;
  var bal;

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

  MenuController menuController;

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
        if (userType == "2") {
          type = "Vendor";

          _dataString =
              balance + "," + accountName + "," + username + "," + type;
        } else {
          type = "User";
          _dataString =
              balance + "," + accountName + "," + username + "," + type;
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

  @override
  Widget build(BuildContext context) {
    final bodyHeight = MediaQuery.of(context).size.height -
        MediaQuery.of(context).viewInsets.bottom;
    return Scaffold(
        resizeToAvoidBottomInset: false,
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
                                      child: Image.asset(
                                        rect,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    Container(
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            left: 15,
                                            right: 15,
                                            top: 18,
                                            bottom: 2),
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: FintnessAppTheme.white,
                                            borderRadius: BorderRadius.only(
                                                topLeft: Radius.circular(8.0),
                                                bottomLeft:
                                                    Radius.circular(8.0),
                                                bottomRight:
                                                    Radius.circular(8.0),
                                                topRight:
                                                    Radius.circular(68.0)),
                                            boxShadow: <BoxShadow>[
                                              BoxShadow(
                                                  color: FintnessAppTheme.grey
                                                      .withOpacity(0.2),
                                                  offset: Offset(1.1, 1.1),
                                                  blurRadius: 10.0),
                                            ],
                                          ),
                                          child: Column(
                                            children: <Widget>[
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 8,
                                                    left: 16,
                                                    right: 24),
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: <Widget>[
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: <Widget>[
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: <Widget>[
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                          .only(
                                                                      left: 4,
                                                                      bottom:
                                                                          3),
                                                              child: Text(
                                                                "N " + balance,
                                                                textAlign:
                                                                    TextAlign
                                                                        .center,
                                                                style:
                                                                    TextStyle(
                                                                  fontFamily:
                                                                      FintnessAppTheme
                                                                          .fontName,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
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
                                                                  right: 10.0),
                                                          child: new Container(
                                                            width: 110.0,
                                                            child: ButtonTheme(
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
                                                                      color: Color(
                                                                          0xff212435),
                                                                      child: const Text(
                                                                          'Account Officer',
                                                                          style: TextStyle(
                                                                              fontFamily:
                                                                                  "sfprodisplaylight",
                                                                              fontSize:
                                                                                  12.0)),
                                                                      shape: new RoundedRectangleBorder(
                                                                          borderRadius:
                                                                              new BorderRadius.circular(5.0))),
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
                                                    left: 24,
                                                    right: 24,
                                                    bottom: 4),
                                                child: Container(
                                                  height: 2,
                                                  decoration: BoxDecoration(
                                                    color: FintnessAppTheme
                                                        .background,
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                4.0)),
                                                  ),
                                                ),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 15,
                                                    right: 24,
                                                    bottom: 10,
                                                    top: 10),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceEvenly,
                                                  children: <Widget>[
                                                    Expanded(
                                                      child: Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: <Widget>[
                                                          Text(
                                                            accountName,
                                                            textAlign: TextAlign
                                                                .center,
                                                            style: TextStyle(
                                                              fontFamily:
                                                                  FintnessAppTheme
                                                                      .fontName,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                              fontSize: 13,
                                                              letterSpacing:
                                                                  -0.2,
                                                              color:
                                                                  FintnessAppTheme
                                                                      .darkText,
                                                            ),
                                                          ),
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .only(
                                                                    top: 3),
                                                            child: Text(
                                                              'Account Name',
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                              style: TextStyle(
                                                                fontFamily:
                                                                    FintnessAppTheme
                                                                        .fontName,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                                fontSize: 12,
                                                                color: FintnessAppTheme
                                                                    .grey
                                                                    .withOpacity(
                                                                        0.5),
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    Expanded(
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .center,
                                                        children: <Widget>[
                                                          Column(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .center,
                                                            children: <Widget>[
                                                              Text(
                                                                username,
                                                                textAlign:
                                                                    TextAlign
                                                                        .center,
                                                                style:
                                                                    TextStyle(
                                                                  fontFamily:
                                                                      FintnessAppTheme
                                                                          .fontName,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500,
                                                                  fontSize: 13,
                                                                  letterSpacing:
                                                                      -0.2,
                                                                  color: FintnessAppTheme
                                                                      .darkText,
                                                                ),
                                                              ),
                                                              Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                            .only(
                                                                        top: 3),
                                                                child: Text(
                                                                  'Account Number',
                                                                  textAlign:
                                                                      TextAlign
                                                                          .center,
                                                                  style:
                                                                      TextStyle(
                                                                    fontFamily:
                                                                        FintnessAppTheme
                                                                            .fontName,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600,
                                                                    fontSize:
                                                                        12,
                                                                    color: FintnessAppTheme
                                                                        .grey
                                                                        .withOpacity(
                                                                            0.5),
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
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .end,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .center,
                                                        children: <Widget>[
                                                          Column(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .end,
                                                            children: <Widget>[
                                                              Text(
                                                                type,
                                                                style:
                                                                    TextStyle(
                                                                  fontFamily:
                                                                      FintnessAppTheme
                                                                          .fontName,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500,
                                                                  fontSize: 13,
                                                                  letterSpacing:
                                                                      -0.2,
                                                                  color: FintnessAppTheme
                                                                      .darkText,
                                                                ),
                                                              ),
                                                              Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                            .only(
                                                                        top: 3),
                                                                child: Text(
                                                                  'Account Type',
                                                                  textAlign:
                                                                      TextAlign
                                                                          .center,
                                                                  style:
                                                                      TextStyle(
                                                                    fontFamily:
                                                                        FintnessAppTheme
                                                                            .fontName,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600,
                                                                    fontSize:
                                                                        12,
                                                                    color: FintnessAppTheme
                                                                        .grey
                                                                        .withOpacity(
                                                                            0.5),
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
//                            _contentWidget(),
                                Container(
                                  child: Column(
                                    children: <Widget>[
                                      Padding(
                                        padding: const EdgeInsets.only(top: 50,right: 20,left: 20,bottom: 20),
                                        child: Center(
                                          child: RepaintBoundary(
                                            key: globalKey,
                                            child: QrImage(
                                              data: _dataString,
                                              size: 0.5 * bodyHeight,
                                              onError: (ex) {
                                                print("[QR] ERROR - $ex");
                                                setState(() {
                                                  _inputErrorText =
                                                      "Error! Maybe your input value is too long?";
                                                });
                                              },
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

  Future<void> _captureAndSharePng() async {
    try {
      RenderRepaintBoundary boundary =
          globalKey.currentContext.findRenderObject();
      var image = await boundary.toImage();
      ByteData byteData = await image.toByteData(format: ImageByteFormat.png);
      Uint8List pngBytes = byteData.buffer.asUint8List();

      final tempDir = await getTemporaryDirectory();
      final file = await new File('${tempDir.path}/image.png').create();
      await file.writeAsBytes(pngBytes);

      final channel = const MethodChannel('channel:me.alfian.share/share');
      channel.invokeMethod('shareFile', 'image.png');
    } catch (e) {
      print(e.toString());
    }
  }
}
