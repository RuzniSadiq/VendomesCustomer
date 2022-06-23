import 'dart:async';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart' as loc;
import 'package:location/location.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:worldsgate/screens/driver/driverrequests.dart';

import '../../api/google_map_api.dart';

class DriverMapTracking extends StatefulWidget {
  final String orderid;
  LatLng outletpickupdestination;
  LatLng customerdropoffdestination;

  final String uid;
  final String cusid;
  bool? orderpickedup;
  bool? orderdelivered;

  DriverMapTracking(
      this.orderid,
      this.outletpickupdestination,
      this.customerdropoffdestination,
      this.uid,
      this.cusid,
      this.orderpickedup, this.orderdelivered);

  @override
  _DriverMapTrackingState createState() => _DriverMapTrackingState();
}

class _DriverMapTrackingState extends State<DriverMapTracking> {
  BitmapDescriptor? icon;

  LocationData? currentLocation;

  Set<Polyline> _polylines = Set<Polyline>();

  Set<Polyline> _orderdroppedpolylines = Set<Polyline>();
  List<LatLng> polylineCoordinates = [];
  late PolylinePoints polylinePoints;

  final loc.Location location = loc.Location();
  late GoogleMapController _controller;
  bool _added = false;


  String? cusname;
  String? cusnumber;

  StreamSubscription<loc.LocationData>? _locationSubscription;

  changeMapMode() {
    getJsonFile('assets/styles/mapstyle.json').then(setMapStyle);
  }

  Future<String> getJsonFile(String path) async {
    return await rootBundle.loadString(path);
  }

  void setMapStyle(String mapStyle) {
    _controller.setMapStyle(mapStyle);
  }

  getcusdetailsl() async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(widget.cusid)
        .get()
        .then((value) {
      cusname = value.data()!['name'].toString();
      cusnumber = value.data()!['mobile'].toString();
    });
  }

  Future<void> _listenLocation() async {
    _locationSubscription = location.onLocationChanged.handleError((onError) {
      print(onError);
      _locationSubscription?.cancel();
      setState(() {
        _locationSubscription = null;
      });
    }).listen((loc.LocationData currentlocation) async {
      await FirebaseFirestore.instance
          .collection('delivery')
          .doc("9WRNvPkoftSw4o2rHGUI")
          .collection('orders')
          .doc(widget.orderid)
          .set({
        'driverlat': currentlocation.latitude,
        'driverlong': currentlocation.longitude,
      }, SetOptions(merge: true));
    });

    // _locationSubscription = location.onLocationChanged.listen((clocation) {
    //   currentLocation = clocation;
    //
    // });
  }

  void setPolylinesInMap() async {
    //var xy = currentLocation;
    print("${widget.outletpickupdestination.latitude} oiiiiiiii");

    var result = await polylinePoints.getRouteBetweenCoordinates(
      GoogleMapApi().url,
      PointLatLng(
          currentLocation!.latitude ?? 0.0, currentLocation!.longitude ?? 0.0),
      PointLatLng(widget.outletpickupdestination.latitude,
          widget.outletpickupdestination.longitude),
    );

    if (result.points.isNotEmpty) {
      result.points.forEach((pointLatLng) {
        polylineCoordinates
            .add(LatLng(pointLatLng.latitude, pointLatLng.longitude));
      });
    }

    setState(() {
      _polylines.add(Polyline(
        width: 5,
        polylineId: PolylineId('polyline'),
        color: Colors.blue,
        points: polylineCoordinates,
      ));
    });
    print("woky ${result.points}");
    if (currentLocation == null) {
      print("sucks man");
    } else {
      print("oi man");
    }
  }

  void showLocationPins() {
    setPolylinesInMap();
    //setPackageDroppedPolylinesInMap();
  }

  void showPickedUpLocationPins() {
    setPackageDroppedPolylinesInMap();
  }

  void setPackageDroppedPolylinesInMap() async {
    var result = await polylinePoints.getRouteBetweenCoordinates(
      GoogleMapApi().url,
      PointLatLng(
          currentLocation!.latitude ?? 0.0, currentLocation!.longitude ?? 0.0),
      PointLatLng(widget.customerdropoffdestination.latitude,
          widget.customerdropoffdestination.longitude),
    );

    if (result.points.isNotEmpty) {
      result.points.forEach((pointLatLng) {
        polylineCoordinates
            .add(LatLng(pointLatLng.latitude, pointLatLng.longitude));
      });
    }

    setState(() {
      _orderdroppedpolylines.add(Polyline(
        width: 5,
        polylineId: PolylineId('polyline'),
        color: Colors.blue,
        points: polylineCoordinates,
      ));
    });
  }

  Future<Uint8List> getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
        targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!
        .buffer
        .asUint8List();
  }

// Cargar imagen del Marker
  getIcons() async {
    final Uint8List markerIcon =
        await getBytesFromAsset('assets/images/mapsicons/bike.png', 150);
    setState(() {
      this.icon = BitmapDescriptor.fromBytes(markerIcon);
    });
  }

  late StreamSubscription<LocationData> subscription;

  bool _isLoading = true;

  @override
  void initState() {
    getcusdetailsl();
    Future.delayed(Duration(seconds: 3), () {
      setState(() {
        _isLoading = false;
      });
    });
    //_requestPermission();
    location.changeSettings(
        interval: 2300, accuracy: loc.LocationAccuracy.high);
    location.enableBackgroundMode(enable: true);
    _listenLocation();
    polylinePoints = PolylinePoints();
    subscription = location.onLocationChanged.listen((clocation) {
      currentLocation = clocation;
    });

    getIcons();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var x = icon;
    return WillPopScope(
      onWillPop: () async => false,
      child: SafeArea(
        child: Scaffold(
            body: (x == null || _isLoading == true)
                ? Center(child: CircularProgressIndicator())
                : StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection('delivery')
                        .doc("9WRNvPkoftSw4o2rHGUI")
                        .collection('orders')
                        .snapshots(),
                    builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (_added) {
                        DriverMapTracking(snapshot);
                      }
                      if (!snapshot.hasData) {
                        return Center(child: CircularProgressIndicator());
                      }
                      return (widget.orderpickedup == false)
                          ? Stack(
                              children: <Widget>[
                                GoogleMap(
                                  mapType: MapType.normal,
                                  polylines: _polylines,
                                  myLocationButtonEnabled: true,
                                  compassEnabled: true,
                                  markers: {
                                    Marker(
                                        //rotation:-45,
                                        position: LatLng(
                                          snapshot.data!.docs.singleWhere(
                                              (element) =>
                                                  element.id ==
                                                  widget.orderid)['driverlat'],
                                          snapshot.data!.docs.singleWhere(
                                              (element) =>
                                                  element.id ==
                                                  widget.orderid)['driverlong'],
                                        ),
                                        markerId: MarkerId('id'),
                                        icon: x),
                                    Marker(
                                      position: LatLng(
                                        widget.outletpickupdestination.latitude,
                                        widget
                                            .outletpickupdestination.longitude,
                                      ),
                                      markerId: MarkerId('idd'),
                                    ),
                                  },
                                  initialCameraPosition: CameraPosition(
                                      target: LatLng(
                                        snapshot.data!.docs.singleWhere(
                                            (element) =>
                                                element.id ==
                                                widget.orderid)['driverlat'],
                                        snapshot.data!.docs.singleWhere(
                                            (element) =>
                                                element.id ==
                                                widget.orderid)['driverlong'],
                                      ),
                                      zoom: 14.47),
                                  onMapCreated:
                                      (GoogleMapController controller) async {
                                    changeMapMode();

                                    setState(() {
                                      _controller = controller;
                                      _added = true;

                                    });

                                    showLocationPins();
                                  },
                                ),
                                Align(
                                  alignment: Alignment.topLeft,
                                  child: IconButton(
                                    icon: Icon(Icons.arrow_back_ios),
                                    iconSize: 20.0,
                                    onPressed: () {
                                      _stopListening();
                                      // Navigator.of(context).push(MaterialPageRoute(
                                      //     builder: (context) =>
                                      //         MyApp()));
                                      Navigator.of(context).push(
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  DriverRequests(widget.uid)));
                                    },
                                  ),
                                ),
                                Align(
                                  alignment: Alignment.bottomCenter,
                                  child: MaterialButton(
                                      color: Colors.black,
                                      textColor: Colors.white,
                                      onPressed: () {
                                        //_stopListening();
                                        // Navigator.of(context).push(MaterialPageRoute(
                                        //     builder: (context) =>
                                        //         MyApp()));

                                        //  _stopListening();
                                        FirebaseFirestore.instance
                                            .collection('delivery')
                                            .doc("9WRNvPkoftSw4o2rHGUI")
                                            .collection('orders')
                                            .doc(widget.orderid)
                                            //update method
                                            .update({
                                          //add the user id inside the favourites array
                                          "orderpickedup": true
                                        });
                                        setState(() {
                                          widget.orderpickedup = true;
                                          showPickedUpLocationPins();
                                          polylineCoordinates.clear();
                                        });

                                        // Navigator.of(context).push(MaterialPageRoute(
                                        //     builder: (context) => DriverMapTracking(
                                        //       widget.orderid,
                                        //         widget.outletpickupdestination,
                                        //      widget.customerdropoffdestination,
                                        //       widget.uid!,
                                        //       widget.cusid,
                                        //     )));
                                      },
                                      child: const Text("Start Delivery")),
                                ),
                                Align(
                                  alignment: Alignment.bottomLeft,
                                  child: Padding(
                                    padding:
                                        const EdgeInsets.only(bottom: 28.0),
                                    child: Row(
                                      children: <Widget>[
                                        IconButton(
                                            icon: Icon(Icons.expand_more),
                                            iconSize: 40.0,
                                            onPressed: () {
                                              _stopListening();
                                              showModalBottomSheet<void>(
                                                context: context,
                                                builder:
                                                    (BuildContext context) {
                                                  return Container(
                                                    height: 200,
                                                    color: Colors.white,
                                                    child: Center(
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(16.0),
                                                        child: Column(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          mainAxisSize:
                                                              MainAxisSize.min,
                                                          children: <Widget>[
                                                            Row(
                                                              children: [
                                                                IconButton(
                                                                  icon: Icon(Icons
                                                                      .account_circle_sharp),
                                                                  iconSize:
                                                                      30.0,
                                                                  onPressed:
                                                                      () {},
                                                                ),
                                                                Text(
                                                                    "${cusname}"),
                                                              ],
                                                            ),
                                                            Row(
                                                              children: [
                                                                IconButton(
                                                                  icon: Icon(Icons
                                                                      .phone),
                                                                  iconSize:
                                                                      30.0,
                                                                  onPressed:
                                                                      () {},
                                                                ),
                                                                Text(
                                                                    "${cusnumber}"),
                                                              ],
                                                            ),
                                                            Row(
                                                              children: [
                                                                IconButton(
                                                                  icon: Icon(Icons
                                                                      .location_on),
                                                                  iconSize:
                                                                      30.0,
                                                                  onPressed:
                                                                      () {},
                                                                ),
                                                              ],
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  );
                                                },
                                              );
                                            }),
                                        Text(
                                          "More",
                                          style: TextStyle(
                                              fontSize: 15.0,
                                              fontWeight: FontWeight.w600),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            )
                          : (widget.orderpickedup == true)
                              ? Stack(
                                  children: <Widget>[
                                    GoogleMap(
                                      mapType: MapType.normal,
                                      polylines: _orderdroppedpolylines,
                                      myLocationButtonEnabled: true,
                                      compassEnabled: true,
                                      markers: {
                                        Marker(
                                            //rotation:-45,
                                            position: LatLng(
                                              snapshot.data!.docs.singleWhere(
                                                      (element) =>
                                                          element.id ==
                                                          widget.orderid)[
                                                  'driverlat'],
                                              snapshot.data!.docs.singleWhere(
                                                      (element) =>
                                                          element.id ==
                                                          widget.orderid)[
                                                  'driverlong'],
                                            ),
                                            markerId: MarkerId('id'),
                                            icon: x),
                                        Marker(
                                          position: LatLng(
                                            widget.customerdropoffdestination
                                                .latitude,
                                            widget.customerdropoffdestination
                                                .longitude,
                                          ),
                                          markerId: MarkerId('idd'),
                                        ),
                                      },
                                      initialCameraPosition: CameraPosition(
                                          target: LatLng(
                                            snapshot.data!.docs.singleWhere(
                                                (element) =>
                                                    element.id ==
                                                    widget
                                                        .orderid)['driverlat'],
                                            snapshot.data!.docs.singleWhere(
                                                (element) =>
                                                    element.id ==
                                                    widget
                                                        .orderid)['driverlong'],
                                          ),
                                          zoom: 14.47),
                                      onMapCreated: (GoogleMapController
                                          controller) async {
                                        changeMapMode();

                                        _controller = controller;
                                        _added = true;
                                        showPickedUpLocationPins();
                                      },
                                    ),
                                    Align(
                                      alignment: Alignment.topLeft,
                                      child: IconButton(
                                        icon: Icon(Icons.arrow_back_ios),
                                        iconSize: 20.0,
                                        onPressed: () {
                                          _stopListening();
                                          // Navigator.of(context).push(MaterialPageRoute(
                                          //     builder: (context) =>
                                          //         MyApp()));
                                          Navigator.of(context).push(
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      DriverRequests(
                                                          widget.uid)));
                                        },
                                      ),
                                    ),
                                    Align(
                                      alignment: Alignment.bottomCenter,
                                      child:
                                      (widget.orderdelivered == false)
                                      ?MaterialButton(
                                          color: Colors.black,
                                          textColor: Colors.white,
                                          onPressed: () {
                                            //_stopListening();
                                            // Navigator.of(context).push(MaterialPageRoute(
                                            //     builder: (context) =>
                                            //         MyApp()));

                                            //  _stopListening();
                                            FirebaseFirestore.instance
                                                .collection('delivery')
                                                .doc("9WRNvPkoftSw4o2rHGUI")
                                                .collection('orders')
                                                .doc(widget.orderid)
                                                //update method
                                                .update({
                                              //add the user id inside the favourites array
                                              "orderdelivered": true
                                            });
                                            setState(() {
                                              widget.orderdelivered = true;
                                            });

                                            // Navigator.of(context).push(MaterialPageRoute(
                                            //     builder: (context) => DriverMapTracking(
                                            //       widget.orderid,
                                            //         widget.outletpickupdestination,
                                            //      widget.customerdropoffdestination,
                                            //       widget.uid!,
                                            //       widget.cusid,
                                            //     )));
                                          },
                                          child: Text("Deliver Order")): MaterialButton(
                                          color: Colors.black,
                                          textColor: Colors.white,
                                          onPressed: () {
                                            print("pressed");
                                            _stopListening();
                                            // Navigator.of(context).push(MaterialPageRoute(
                                            //     builder: (context) =>
                                            //         MyApp()));

                                            //  _stopListening();
                                            FirebaseFirestore.instance
                                                .collection('delivery')
                                                .doc("9WRNvPkoftSw4o2rHGUI")
                                                .collection('orders')
                                                .doc(widget.orderid)
                                            //update method
                                                .update({
                                              //add the user id inside the favourites array
                                              "ordercompleted": true,


                                            });

                                            FirebaseFirestore.instance
                                                .collection('users')
                                                .doc(widget.uid)
                                            //update method
                                                .update({
                                              //add the user id inside the favourites array
                                              "ongoingorder": '',
                                              "driveroccupied": false,


                                            });




                                            Navigator.of(context).push(MaterialPageRoute(
                                                builder: (context) => DriverRequests(
                                                  widget.uid,
                                                )));
                                          },
                                          child: Text("Collect Cash")),
                                    ),
                                    Align(
                                      alignment: Alignment.bottomLeft,
                                      child: Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 28.0),
                                        child: Row(
                                          children: <Widget>[
                                            IconButton(
                                                icon: Icon(Icons.expand_more),
                                                iconSize: 40.0,
                                                onPressed: () {
                                                  _stopListening();
                                                  showModalBottomSheet<void>(
                                                    context: context,
                                                    builder:
                                                        (BuildContext context) {
                                                      return Container(
                                                        height: 200,
                                                        color: Colors.white,
                                                        child: Center(
                                                          child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(16.0),
                                                            child: Column(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                              mainAxisSize:
                                                                  MainAxisSize
                                                                      .min,
                                                              children: <
                                                                  Widget>[
                                                                Row(
                                                                  children: [
                                                                    IconButton(
                                                                      icon: Icon(
                                                                          Icons
                                                                              .account_circle_sharp),
                                                                      iconSize:
                                                                          30.0,
                                                                      onPressed:
                                                                          () {},
                                                                    ),
                                                                    Text(
                                                                        "${cusname}"),
                                                                  ],
                                                                ),
                                                                Row(
                                                                  children: [
                                                                    IconButton(
                                                                      icon: Icon(
                                                                          Icons
                                                                              .phone),
                                                                      iconSize:
                                                                          30.0,
                                                                      onPressed:
                                                                          () {},
                                                                    ),
                                                                    Text(
                                                                        "${cusnumber}"),
                                                                  ],
                                                                ),
                                                                Row(
                                                                  children: [
                                                                    IconButton(
                                                                      icon: Icon(
                                                                          Icons
                                                                              .location_on),
                                                                      iconSize:
                                                                          30.0,
                                                                      onPressed:
                                                                          () {},
                                                                    ),
                                                                  ],
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                      );
                                                    },
                                                  );
                                                }),
                                            Text(
                                              "More",
                                              style: TextStyle(
                                                  fontSize: 15.0,
                                                  fontWeight: FontWeight.w600),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                )
                              : const Center(
                                  child: CircularProgressIndicator());
                    },
                  )),
      ),
    );
  }

  Future<void> DriverMapTracking(AsyncSnapshot<QuerySnapshot> snapshot) async {
    await _controller
        .animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
            target: LatLng(
              snapshot.data!.docs.singleWhere(
                  (element) => element.id == widget.orderid)['driverlat'],
              snapshot.data!.docs.singleWhere(
                  (element) => element.id == widget.orderid)['driverlong'],
            ),
            zoom: 14.47)));
  }

  _stopListening() {
    _locationSubscription?.cancel();
    subscription.cancel();
    setState(() {
      _locationSubscription = null;
      print("argh stop $_locationSubscription");
    });
  }

  _requestPermission() async {
    var status = await Permission.location.request();
    if (status.isGranted) {
      print('done');
    } else if (status.isDenied) {
      _requestPermission();
    } else if (status.isPermanentlyDenied) {
      openAppSettings();
    }
  }

  @override
  void dispose() {
    subscription.cancel();
    super.dispose();
  }
}
