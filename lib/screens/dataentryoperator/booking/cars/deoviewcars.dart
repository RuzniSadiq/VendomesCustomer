import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:worldsgate/helper/responsive_helper.dart';
import 'package:worldsgate/widgets/deonavigationdrawer.dart';
import 'package:worldsgate/widgets/header.dart';
import 'dart:math' as math;

import 'deoupdatecardetails.dart';

class DeoViewCarDetails extends StatefulWidget {
  //const DeoViewCarDetails({Key? key}) : super(key: key);
  String? uid;
  String? carid;

  DeoViewCarDetails(this.uid, this.carid);

  @override
  _DeoViewCarDetailsState createState() => _DeoViewCarDetailsState(carid);
}

class _DeoViewCarDetailsState extends State<DeoViewCarDetails> {
  var _scaffoldState = new GlobalKey<ScaffoldState>();
  String? carid;

  _DeoViewCarDetailsState(this.carid);

  bool _isLoading = true;

  var brand;
  var gear;
  var engine;
  var color;
  var seats;
  var luggage;
  var door;
  var name;
  var model;
  var insurance;
  var delivery;
  var kms;
  var age;
  var otherfeaturez = [];

  var stars;

  var description;
  var carCoverImage;
  var othercarImages;

  String? cusname;
  String? role;

  getname() async {
    FirebaseFirestore.instance
        .collection('users')
        .doc(widget.uid)
        .get()
        .then((myDocuments) {
      cusname = myDocuments.data()!['name'].toString();
      role = myDocuments.data()!['role'].toString();
    });
  }

  getyo() async {
    print("The car ID is " + carid.toString());
    await FirebaseFirestore.instance
        .collection('cars')
        .doc(carid.toString())
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        name = documentSnapshot['name'];
        brand = documentSnapshot['brand'];
        gear = documentSnapshot['gear'];
        engine = documentSnapshot['engine'];
        color = documentSnapshot['color'];
        seats = documentSnapshot['seats'];
        door = documentSnapshot['doors'];
        luggage = documentSnapshot['luggage'];
        model = documentSnapshot['model'];
        insurance = documentSnapshot['insurance'];
        delivery = documentSnapshot['delivery'];
        kms = documentSnapshot['distance'];
        age = documentSnapshot['age'];
        description = documentSnapshot['description'];
        otherfeaturez = documentSnapshot['otherfeatures'].toList();

        if ((documentSnapshot.data() as Map<String, dynamic>)
            .containsKey('othercarimages')) {
          othercarImages = documentSnapshot['othercarimages'].toList();
        }
        if ((documentSnapshot.data() as Map<String, dynamic>)
            .containsKey('coverimage')) {
          carCoverImage = documentSnapshot['coverimage'];
        }

        //
        // if ((documentSnapshot.data() as Map<String, dynamic>)
        //     .containsKey('otherfeatures')) {
        //   otherfeatures = documentSnapshot['otherfeatures'];
        // }

      } else {
        print("The document does not exist");
      }
    });
  }

  getanother() {
    for (int i = 0; i < otherfeaturez.length; i++) {}
  }

  List<Widget> mainfacilitiez() {
    List<Widget> m = [];

    for (int i = 0; i < otherfeaturez.length; i++) {
      //print(otherfeaturez[i]);
      m.add(Wrap(
        children: [
          Icon(
            Icons.check,
            color: Color(0xFFb38219),
          ),
          Text(
            otherfeaturez[i].toString(),
            style: TextStyle(color: Colors.white),
          ),
        ],
      ));
    }
    return m;
  }

  @override
  void initState() {
    getyo();
    getname();
    Future.delayed(Duration(seconds: 3), () {
      setState(() {
        _isLoading = false;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final CollectionReference packageCollection =
    FirebaseFirestore.instance.collection('cars');

    return _isLoading
        ? Center(child: CircularProgressIndicator())
        : SafeArea(
        child: Scaffold(
          key: _scaffoldState,
          backgroundColor: Color(0xFF000000),

          // appBar: AppBar(
          //   backgroundColor: Colors.transparent,
          //   elevation: 0.0,
          //   iconTheme: IconThemeData(color: Color(0xFFdb9e1f)),
          // ),

          drawer: new DeoNavigationDrawer(widget.uid),
          body: Stack(
            children: [
              // SingleChildScrollView(
              //   child: ResponsiveWidget(
              //     mobile: buildColumnContent(context, "mobile", packageCollection),
              //     tab: buildColumnContent(context, "tab", packageCollection),
              //     desktop: buildColumnContent(context, "desktop", packageCollection),
              //   ),
              // ),
              Container(
                // width: double.infinity,
                // height: double.infinity,

                margin: const EdgeInsets.only(top: 200.0, bottom: 5.0),
                child: SingleChildScrollView(
                  child: ResponsiveWidget(
                    mobile: buildColumnContent("mob", 15, 13),
                    tab: buildColumnContent("tab", 16, 14),
                    desktop: buildColumnContent("des", 17, 15),
                  ),
                ),
              ),
              Positioned(
                  left: 0.0,
                  top: 0.0,
                  right: 0.0,
                  child: Container(
                      child: VendomeHeader(
                        drawer: _scaffoldState,
                        cusname: cusname,
                        cusaddress: "",
                        role: role,
                      ))),
            ],
          ),
        ));
  }

  Column buildColumnContent(
      String lala, double headingfontsize, double normalfontsize) {
    return Column(
      children: [
        Text(
          "Book Now $brand $name $model",
          style: TextStyle(
            color: Colors.white,
            fontSize: headingfontsize,
          ),
        ),
        SizedBox(
          height: 30.0,
        ),
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: Container(
            constraints: BoxConstraints(maxHeight: 550.0),
            child: AspectRatio(
              aspectRatio: 16 / 9,
              child: Stack(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      //borderRadius: BorderRadius.circular(10),
                      // border: Border.all(color: Color(0xFFBA780F)),
                      image: DecorationImage(
                          image: NetworkImage(
                              'https://stimg.cardekho.com/images/carexteriorimages/930x620/Lamborghini/Aventador/6721/Lamborghini-Aventador-SVJ/1621849426405/front-left-side-47.jpg'),
                          fit: BoxFit.cover),
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      height: 80.0,
                      width: double.infinity,
                      decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(color: Colors.black),
                          ),
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            // begin: FractionalOffset
                            //     .topCenter,
                            // end: FractionalOffset.bottomCenter,
                            transform: GradientRotation(math.pi / 2),
                            colors: [
                              Colors.amber,
                              Colors.amber.withOpacity(0.5),
                              Colors.amber.withOpacity(0),
                            ],
                          )),
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: Text(
                            "AED 3. 000, 00",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: headingfontsize,
                              fontWeight: FontWeight.bold,
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
        ),
        SizedBox(
          height: 30.0,
        ),
        Text(
          "$brand $name $model",
          style: TextStyle(
            color: Color(0xFFBA780F),
            fontSize: headingfontsize,
          ),
        ),
        SizedBox(
          height: 20.0,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Icon(
                        Icons.ac_unit,
                        size: 20.0,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "Model",
                        style: TextStyle(
                          color: Color(0xFFBA780F),
                          fontSize: normalfontsize,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "$model",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: normalfontsize,
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Icon(
                        Icons.ac_unit,
                        size: 20.0,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "Insurance",
                        style: TextStyle(
                          color: Color(0xFFBA780F),
                          fontSize: normalfontsize,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "$insurance",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: normalfontsize,
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Icon(
                        Icons.ac_unit,
                        size: 20.0,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "Brand",
                        style: TextStyle(
                          color: Color(0xFFBA780F),
                          fontSize: normalfontsize,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "$brand",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: normalfontsize,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Icon(
                        Icons.ac_unit,
                        size: 20.0,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "Delivery",
                        style: TextStyle(
                          color: Color(0xFFBA780F),
                          fontSize: normalfontsize,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "$delivery",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: normalfontsize,
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Icon(
                        Icons.ac_unit,
                        size: 20.0,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "KMs",
                        style: TextStyle(
                          color: Color(0xFFBA780F),
                          fontSize: normalfontsize,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "$kms",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: normalfontsize,
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Icon(
                        Icons.ac_unit,
                        size: 20.0,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "Min Age",
                        style: TextStyle(
                          color: Color(0xFFBA780F),
                          fontSize: normalfontsize,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "$age",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: normalfontsize,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            )
          ],
        ),
        SizedBox(
          height: 30.0,
        ),
        Text(
          "Car Features",
          style: TextStyle(
            color: Color(0xFFBA780F),
            fontSize: headingfontsize,
          ),
        ),
        SizedBox(
          height: 20.0,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            (lala == "mob")
                ? Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //1st col
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: RichText(
                        text: TextSpan(
                          children: [
                            WidgetSpan(
                                child: Icon(
                                  Icons.directions_car,
                                  size: 28.0,
                                  color: Color(0xFFb38219),
                                )),
                            TextSpan(
                              text: "Brand - $brand",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: normalfontsize,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    //engine
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: RichText(
                        text: TextSpan(
                          children: [
                            WidgetSpan(
                                child: Icon(
                                  Icons.stay_current_landscape,
                                  size: 28.0,
                                  color: Color(0xFFb38219),
                                )),
                            TextSpan(
                              text: "Engine - $engine",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: normalfontsize,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    //seats
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: RichText(
                        text: TextSpan(
                          children: [
                            WidgetSpan(
                                child: Icon(
                                  Icons.event_seat,
                                  size: 28.0,
                                  color: Color(0xFFb38219),
                                )),
                            TextSpan(
                              text: "Seats - $seats",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: normalfontsize,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    //luggage
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: RichText(
                        text: TextSpan(
                          children: [
                            WidgetSpan(
                                child: Icon(
                                  Icons.shopping_bag,
                                  size: 28.0,
                                  color: Color(0xFFb38219),
                                )),
                            TextSpan(
                              text: "Luggage - $luggage",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: normalfontsize,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    //bluetooth
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: RichText(
                        text: TextSpan(
                          children: [
                            WidgetSpan(
                                child: Icon(
                                  Icons.bluetooth_audio,
                                  size: 28.0,
                                  color: Color(0xFFb38219),
                                )),
                            TextSpan(
                              text: otherfeaturez.contains("Bluetooth")
                                  ? "Bluetooth - Yes"
                                  : "Bluetooth - No",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: normalfontsize,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    //safety

                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: RichText(
                        text: TextSpan(
                          children: [
                            WidgetSpan(
                                child: Icon(
                                  Icons.shield,
                                  size: 28.0,
                                  color: Color(0xFFb38219),
                                )),
                            TextSpan(
                              text: otherfeaturez.contains("Safety")
                                  ? "Safety - Yes"
                                  : "Safety - No",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: normalfontsize,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),

                //2nd col
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    //gear
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: RichText(
                        text: TextSpan(
                          children: [
                            WidgetSpan(
                                child: Icon(
                                  Icons.checklist,
                                  size: 28.0,
                                  color: Color(0xFFb38219),
                                )),
                            TextSpan(
                              text: "Gear - $gear",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: normalfontsize,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    //color
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: RichText(
                        text: TextSpan(
                          children: [
                            WidgetSpan(
                                child: Icon(
                                  Icons.color_lens_outlined,
                                  size: 28.0,
                                  color: Color(0xFFb38219),
                                )),
                            TextSpan(
                              text: "Color - $color",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: normalfontsize,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    //doors
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: RichText(
                        text: TextSpan(
                          children: [
                            WidgetSpan(
                                child: Icon(
                                  Icons.door_back_door,
                                  size: 28.0,
                                  color: Color(0xFFb38219),
                                )),
                            TextSpan(
                              text: "Door - $door",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: normalfontsize,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    //sensor
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: RichText(
                        text: TextSpan(
                          children: [
                            WidgetSpan(
                                child: Icon(
                                  Icons.sensor_window_outlined,
                                  size: 28.0,
                                  color: Color(0xFFb38219),
                                )),
                            TextSpan(
                              text: otherfeaturez.contains("Sensors")
                                  ? "Sensors - Yes"
                                  : "Sensors - No",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: normalfontsize,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    //camera
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: RichText(
                        text: TextSpan(
                          children: [
                            WidgetSpan(
                                child: Icon(
                                  Icons.camera_alt_outlined,
                                  size: 28.0,
                                  color: Color(0xFFb38219),
                                )),
                            TextSpan(
                              text: otherfeaturez.contains("Camera")
                                  ? "Camera - Yes"
                                  : "Camera - No",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: normalfontsize,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    //mp3
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: RichText(
                        text: TextSpan(
                          children: [
                            WidgetSpan(
                                child: Icon(
                                  Icons.music_note,
                                  size: 28.0,
                                  color: Color(0xFFb38219),
                                )),
                            TextSpan(
                              text: otherfeaturez.contains("Mp3/CD")
                                  ? "Mp3/CD - Yes"
                                  : "Mp3/CD - No",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: normalfontsize,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            )
                : Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: RichText(
                        text: TextSpan(
                          children: [
                            WidgetSpan(
                                child: Icon(
                                  Icons.directions_car,
                                  size: 28.0,
                                  color: Color(0xFFb38219),
                                )),
                            TextSpan(
                              text: "Brand - $brand",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: normalfontsize,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    //seats
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: RichText(
                        text: TextSpan(
                          children: [
                            WidgetSpan(
                                child: Icon(
                                  Icons.event_seat,
                                  size: 28.0,
                                  color: Color(0xFFb38219),
                                )),
                            TextSpan(
                              text: "Seats - $seats",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: normalfontsize,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    //bluetooth
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: RichText(
                        text: TextSpan(
                          children: [
                            WidgetSpan(
                                child: Icon(
                                  Icons.bluetooth_audio,
                                  size: 28.0,
                                  color: Color(0xFFb38219),
                                )),
                            TextSpan(
                              text: otherfeaturez.contains("Bluetooth")
                                  ? "Bluetooth - Yes"
                                  : "Bluetooth - No",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: normalfontsize,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    //gear
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: RichText(
                        text: TextSpan(
                          children: [
                            WidgetSpan(
                                child: Icon(
                                  Icons.checklist,
                                  size: 28.0,
                                  color: Color(0xFFb38219),
                                )),
                            TextSpan(
                              text: "Gear - $gear",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: normalfontsize,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    //doors
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: RichText(
                        text: TextSpan(
                          children: [
                            WidgetSpan(
                                child: Icon(
                                  Icons.door_back_door,
                                  size: 28.0,
                                  color: Color(0xFFb38219),
                                )),
                            TextSpan(
                              text: "Door - $door",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: normalfontsize,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    //camera
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: RichText(
                        text: TextSpan(
                          children: [
                            WidgetSpan(
                                child: Icon(
                                  Icons.camera_alt_outlined,
                                  size: 28.0,
                                  color: Color(0xFFb38219),
                                )),
                            TextSpan(
                              text: otherfeaturez.contains("Camera")
                                  ? "Camera - Yes"
                                  : "Camera - No",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: normalfontsize,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    //engine
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: RichText(
                        text: TextSpan(
                          children: [
                            WidgetSpan(
                                child: Icon(
                                  Icons.stay_current_landscape,
                                  size: 28.0,
                                  color: Color(0xFFb38219),
                                )),
                            TextSpan(
                              text: "Engine - $engine",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: normalfontsize,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    //luggage
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: RichText(
                        text: TextSpan(
                          children: [
                            WidgetSpan(
                                child: Icon(
                                  Icons.shopping_bag,
                                  size: 28.0,
                                  color: Color(0xFFb38219),
                                )),
                            TextSpan(
                              text: "Luggage - $luggage",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: normalfontsize,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: RichText(
                        text: TextSpan(
                          children: [
                            WidgetSpan(
                                child: Icon(
                                  Icons.shield,
                                  size: 28.0,
                                  color: Color(0xFFb38219),
                                )),
                            TextSpan(
                              text: otherfeaturez.contains("Safety")
                                  ? "Safety - Yes"
                                  : "Safety - No",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: normalfontsize,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    //color
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: RichText(
                        text: TextSpan(
                          children: [
                            WidgetSpan(
                                child: Icon(
                                  Icons.color_lens_outlined,
                                  size: 28.0,
                                  color: Color(0xFFb38219),
                                )),
                            TextSpan(
                              text: "Color - $color",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: normalfontsize,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    //sensor
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: RichText(
                        text: TextSpan(
                          children: [
                            WidgetSpan(
                                child: Icon(
                                  Icons.sensor_window_outlined,
                                  size: 28.0,
                                  color: Color(0xFFb38219),
                                )),
                            TextSpan(
                              text: otherfeaturez.contains("Sensors")
                                  ? "Sensors - Yes"
                                  : "Sensors - No",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: normalfontsize,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    //mp3
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: RichText(
                        text: TextSpan(
                          children: [
                            WidgetSpan(
                                child: Icon(
                                  Icons.music_note,
                                  size: 28.0,
                                  color: Color(0xFFb38219),
                                )),
                            TextSpan(
                              text: otherfeaturez.contains("Mp3/CD")
                                  ? "Mp3/CD - Yes"
                                  : "Mp3/CD - No",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: normalfontsize,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
        SizedBox(
          height: 30.0,
        ),
        ElevatedButton(
          onPressed: () {},
          child: Text('Book Now'),
          style: ElevatedButton.styleFrom(
            primary: Color(0xFFBA780F),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5), // <-- Radius
            ),
          ),
        ),
        SizedBox(
          height: 30.0,
        ),
        Align(
          alignment: Alignment.center,
          child: Text(
            "Description",
            style: TextStyle(
              color: Color(0xFFb38219),
              fontSize: headingfontsize,
            ),
          ),
        ),
        SizedBox(
          height: 20.0,
        ),
        Align(
          alignment: Alignment.center,
          child: Container(
            width: MediaQuery.of(context).size.width * 0.63,
            child: Text(
              "$description",
              style: TextStyle(
                color: Colors.white,
                fontSize: normalfontsize,
              ),
              textAlign: TextAlign.justify,
            ),
          ),
        ),




        SizedBox(height: 50.0),
        Row(
          mainAxisAlignment:
          MainAxisAlignment.center,
          children: [
            Container(
              width: 200.0,
              height: 50.0,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    primary: Color(0xFF000000),
                    shape: RoundedRectangleBorder(
                        borderRadius:
                        BorderRadius.all(
                            Radius.circular(
                                20.0)),
                        side: BorderSide(
                            color:
                            Color(0xFFdb9e1f))),
                    side: BorderSide(
                      width: 2.5,
                      color: Color(0xFFdb9e1f),
                    ),
                    textStyle: const TextStyle(
                        fontSize: 16)),
                onPressed: () {
                  Navigator.of(context).push(
                      MaterialPageRoute(
                          builder: (context) =>
                              UpdateCarDetails(
                                  widget.uid,
                                  widget.carid)));
                },
                child: const Text(
                  'Update',
                  style: TextStyle(
                      color: Colors.white),
                ),
              ),
            ),
            SizedBox(
              width: 50.0,
            ),
            Container(
              width: 200.0,
              height: 50.0,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    primary: Color(0xFF000000),
                    shape: RoundedRectangleBorder(
                        borderRadius:
                        BorderRadius.all(
                            Radius.circular(
                                20.0)),
                        side: BorderSide(
                            color:
                            Color(0xFFdb9e1f))),
                    side: BorderSide(
                      width: 2.5,
                      color: Color(0xFFdb9e1f),
                    ),
                    textStyle: const TextStyle(
                        fontSize: 16)),
                onPressed: () {
                  //_displayTextInputDialog(context);
                },
                child: const Text(
                  'Delete',
                  style: TextStyle(
                      color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
