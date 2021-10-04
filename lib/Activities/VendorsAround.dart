import 'dart:async';
import 'dart:typed_data';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:savease/Model/UserLocation.dart';
import 'package:savease/Utils/ZoomScaffoldActivites.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:ui' as ui;
import 'package:url_launcher/url_launcher.dart';

class VendorsAround extends StatefulWidget {
  @override
  _HoomeState createState() => new _HoomeState();
}

class _HoomeState extends State<VendorsAround> with TickerProviderStateMixin {
  MenuController menuController;
  String accountName = "";
  Map<PolylineId, Polyline> _mapPolylines = {};
  Map<MarkerId, Marker> _mapMarkers= <MarkerId, Marker>{};
  GoogleMapController _mapController;
  BitmapDescriptor customIcon;
  var _scaffoldKey = GlobalKey<ScaffoldState>();
  var latitude;
  var logitude;

  MarkerId selectedMarker;
  var list = [];
  var databaseRef;

  UserLocation _currentLocation;
  var location = Location();


  void getList() async{
    databaseRef.once().then((DataSnapshot snapshot) {
      if(snapshot.value == null){

      }else{

        Map<dynamic, dynamic> yearMap = snapshot.value;

        yearMap.forEach((key, value) {
          setState(() {
            list.add(value);
          });
        });
      }

    });
  }


  Future<UserLocation> getLocation() async {
    try {
      var userLocation = await location.getLocation();
      _currentLocation = UserLocation(
        latitude: userLocation.latitude,
        longitude: userLocation.longitude,
      );
    } on Exception catch (e) {
      print('Could not get location: ${e.toString()}');
    }
    return _currentLocation;
  }

  Future<Uint8List> getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(), targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png)).buffer.asUint8List();
  }


  void getData() async{
    final prefs = await SharedPreferences.getInstance();

    String  fname = prefs.getString('fname') ?? '';
    String  lname = prefs.getString('lname') ?? '';


    if(fname != null || fname != ""){

      setState(() {
        accountName = fname +" "+ lname;

      });

    }else{
      accountName = "";

    }


  }

  void _addMarkerDefault(String mkId) async {

    // remove old
    _mapMarkers.remove(mkId);
    final MarkerId markerId = MarkerId(mkId);


    final Marker marker = Marker(
      markerId: markerId,
      position: LatLng(_currentLocation.latitude, _currentLocation.longitude),
      infoWindow: InfoWindow(title: "My Location", snippet: "I am here "),
    );

    setState(() {
      // adding a new marker to map
      _mapMarkers[markerId] = marker;
    });


  }

  void _addMarker(String mkId,var latitude, var longitude,String name ) async {
    final Uint8List markerIcon = await getBytesFromAsset('assets/image/mp.png', 50);

    // remove old
    _mapMarkers.remove(mkId);
    final MarkerId markerId = MarkerId(mkId);


    final Marker marker = Marker(
      markerId: markerId,
      position: LatLng(latitude, longitude),
      infoWindow: InfoWindow(title: name, snippet: "Savease vendor"),
        icon: BitmapDescriptor.fromBytes(markerIcon)


    );

    setState(() {
      // adding a new marker to map
      _mapMarkers[markerId] = marker;
    });


  }

  void _moveCamera(String mkId) {
    print("move camera: ");


    var _list = _mapMarkers.values.toList();

    print(_list[0].position);
    var myLatLng = _list[0].position;

    if (_mapMarkers.length > 1) {
      var fromLatLng = _list[0].position;
      var toLatLng = _list[1].position;

      var sLat, sLng, nLat, nLng;
      if(fromLatLng.latitude <= toLatLng.latitude) {
        sLat = fromLatLng.latitude;
        nLat = toLatLng.latitude;
      } else {
        sLat = toLatLng.latitude;
        nLat = fromLatLng.latitude;
      }

      if(fromLatLng.longitude <= toLatLng.longitude) {
        sLng = fromLatLng.longitude;
        nLng = toLatLng.longitude;
      } else {
        sLng = toLatLng.longitude;
        nLng = fromLatLng.longitude;
      }

      LatLngBounds bounds = LatLngBounds(northeast: LatLng(nLat, nLng), southwest: LatLng(sLat, sLng));
      _mapController.animateCamera(CameraUpdate.newLatLngBounds(bounds, 50));
    } else {
      print(_list[0].position);
      _mapController.animateCamera(CameraUpdate.newLatLng(myLatLng));
    }
  }

  @override
  void initState() {
    databaseRef = FirebaseDatabase.instance.reference().child("Vendors");
    getList();
    getData();
    super.initState();
    menuController = new MenuController(
      vsync: this,
    )..addListener(() => setState(() {}));
  }

  void _back() {
    Navigator.pop(context);
  }

  @override
  void dispose() {
    menuController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.black,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
//        backgroundColor: Colors.transparent,
        backgroundColor: Color(0x00000000),
        elevation: 0,
      ),
      body: Container(
        child: Stack(
          children: <Widget>[

            GoogleMap(
              myLocationEnabled: true,
              onMapCreated: (GoogleMapController controller) {
                var i = 0;
                _mapController = controller;
                getLocation().then((value) {
                  setState(() {
                    _currentLocation = value;
                    var mkId =  "my_location";
                    _addMarkerDefault(mkId);
                    _moveCamera(mkId);
                  });
                });

                location.onLocationChanged().listen((location){

                  setState(() {
                    _currentLocation = UserLocation(
                      latitude: location.latitude,
                      longitude: location.longitude,
                    );

                    var mkId =  "my_location";
                    _addMarkerDefault(mkId);
                    _moveCamera(mkId);
                  });
                });

                for (i; i < list.length; i++) {
                  print(list[i]["latitude"]);
                  _addMarker(i.toString(), list[i]["latitude"], list[i]["longitude"], list[i]["vendorName"]);


                }

              },
              polylines:Set<Polyline>.of(_mapPolylines.values),
              markers: Set<Marker>.of(_mapMarkers.values),
              initialCameraPosition: CameraPosition(
                target: LatLng(4.8156 , 7.0498
                ),
                zoom: 14.4746,
              ),
            ),
            Positioned(left: 20, right: 20, bottom: 100,
              height: 160,
              child:  Container(
                decoration: BoxDecoration(

                  borderRadius: BorderRadius.all(Radius.circular(6)),
                ),
                child: ListView.builder(itemBuilder: (context, index) {
                 return Container(

                   child: Card(
                      child: Row(
                        children: <Widget>[
                          Container(
                            width: MediaQuery.of(context).size.width/3,
                            height: 200,
                            child: Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: Image.asset("assets/image/lo.jpeg",height: 200,),
                            ),
                          ),

                          Container(
                            width: MediaQuery.of(context).size.width/2,
                            child: Column(
                              children: <Widget>[

                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Padding(
                                    padding: const EdgeInsets.only(top: 20),
                                    child: Text(
                                         "Merchant : "+ list[index]["vendorName"],
                                          style:
                                          TextStyle(fontFamily: "sfprodisplaylight", fontSize: 16.0,color: Colors.black)),
                                  ),
                                ),


                                Padding(
                                  padding: const EdgeInsets.only(top: 2,right: 5),
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                        "Location: Click on navigation pointer to navigate to the merchant/vendor",
                                        style:
                                        TextStyle(fontFamily: "sfprodisplaylight", fontSize: 13.0,color: Colors.black)),
                                  ),
                                ),


                                Row(
                                  children: <Widget>[
                                    Padding(
                                      padding: const EdgeInsets.only(top: 10),
                                      child: Align(
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                            list[index]["status"],
                                            style:
                                            TextStyle(fontFamily: "sfprodisplaylight", fontSize: 13.0,color: Colors.black)),
                                      ),
                                    ),

                                    Container(
                                      child: ButtonTheme(
                                        minWidth: 80.0,
                                        height: 30.0,

                                        child :  Padding(
                                          padding: const EdgeInsets.only(left: 30,right: 10),
                                          child: RaisedButton(
                                              onPressed: () {
                                                launch("tel://${list[index]["vendorNumber"]}");
                                              },
                                              textColor: Colors.white,
                                              color: Color(0xff212435),
                                              child: const Text('Call',style: TextStyle(fontFamily: "sfprodisplaybold")),
                                              shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(10.0))
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ), Padding(
                                  padding: const EdgeInsets.only(top: 0),
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                        "Status",
                                        style:
                                        TextStyle(fontFamily: "sfprodisplaylight", fontSize: 13.0,color: Colors.black)),
                                  ),
                                ),



                              ],
                            ),
                          )
                        ],
                      ),
                   ),
                 );
                }, itemCount: list.length, scrollDirection: Axis.horizontal,),
              ),

            )
          ],
        ),


      ),
    );
  }
}
