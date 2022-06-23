import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:worldsgate/helper/responsive_helper.dart';
import 'package:worldsgate/screens/dataentryoperator/booking/yacht/deomanageyachts.dart';
import 'package:worldsgate/widgets/deonavigationdrawer.dart';
import 'package:worldsgate/widgets/header.dart';
import 'dart:math' as math;

import 'deoupdateyachtdetails.dart';

class DeoViewYachtDetails extends StatefulWidget {
  //const DeoViewYachtDetails({Key? key}) : super(key: key);
  String? uid;
  String? yachtid;

  DeoViewYachtDetails(this.uid, this.yachtid);

  @override
  _DeoViewYachtDetailsState createState() => _DeoViewYachtDetailsState(yachtid);
}

class _DeoViewYachtDetailsState extends State<DeoViewYachtDetails> {
  var _scaffoldState = new GlobalKey<ScaffoldState>();
  String? yachtid;

  _DeoViewYachtDetailsState(this.yachtid);

  bool _isLoading = true;

  var builds;
  var name;
  var perhourprice;
  var dailyprice;
  var description;
  var length;
  var speed;
  var overnightguests;
  var yachtCoverImage;
  var otheryachtImages;

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
    await FirebaseFirestore.instance
        .collection('booking').doc("aGAm7T71ShOqGUhYphfc")
        .collection('yachts')
        .doc(yachtid.toString())
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        name = documentSnapshot['name'];
        builds = documentSnapshot['build'];
       
        description = documentSnapshot['description'];
        perhourprice = documentSnapshot['perhourprice'];
        dailyprice = documentSnapshot['dailyprice'];
        length = documentSnapshot['length'];
        speed = documentSnapshot['speed'];
        overnightguests = documentSnapshot['overnightguests'];


        if ((documentSnapshot.data() as Map<String, dynamic>)
            .containsKey('otheryachtimages')) {
          otheryachtImages = documentSnapshot['otheryachtimages'].toList();
        }
        if ((documentSnapshot.data() as Map<String, dynamic>)
            .containsKey('coverimage')) {
          yachtCoverImage = documentSnapshot['coverimage'].toString();
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
              //     mobile: buildsColumnContent(context, "mobile", packageCollection),
              //     tab: buildsColumnContent(context, "tab", packageCollection),
              //     desktop: buildsColumnContent(context, "desktop", packageCollection),
              //   ),
              // ),
              SingleChildScrollView(
                child: ResponsiveWidget(
                  mobile: buildsColumnContent(70, "mobile", 15, 13),
                  tab: buildsColumnContent(100, "tab", 16, 14),
                  desktop: buildsColumnContent(120, "desktop", 17, 15),
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

  Column buildsColumnContent(double headergap,
      String device, double headingfontsize, double normalfontsize) {
    return Column(
      children: [

        SizedBox(
          height: headergap,
        ),
        Text(
          "Book Now - $name",
          style: TextStyle(
            color: Colors.white,
            fontSize: headingfontsize,
          ),
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
                              yachtCoverImage.toString()),
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
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(

                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "AED $perhourprice",
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: headingfontsize,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    "Per hour price",
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: headingfontsize,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(
                                    "AED $dailyprice",
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: headingfontsize,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    "Daily Price",
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: headingfontsize,
                                      fontWeight: FontWeight.bold,
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
                ],
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 12.0, right:  12.0),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: imageBuilderTwo(device),
            ),
          ),
        ),
        SizedBox(
          height: 30.0,
        ),
        Text(
          "Yacht Features",
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
                        "Build",
                        style: TextStyle(
                          color: Color(0xFFBA780F),
                          fontSize: normalfontsize,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "$builds",
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
                        "Length",
                        style: TextStyle(
                          color: Color(0xFFBA780F),
                          fontSize: normalfontsize,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "${length} Ft",
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
                        "Speed",
                        style: TextStyle(
                          color: Color(0xFFBA780F),
                          fontSize: normalfontsize,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "${speed} Kmph",
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
                        "Overnight Guests",
                        style: TextStyle(
                          color: Color(0xFFBA780F),
                          fontSize: normalfontsize,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "$overnightguests",
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
              width: 100.0,
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
                              UpdateYachtDetails(
                                  widget.uid,
                                  widget.yachtid)));
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
              width: 100.0,
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
                  _deleteconfirmation();
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
  Future<void> _deleteconfirmation() async {
    return showDialog<void>(
      context: this.context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete'),
          content: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Text('You are about to delete this listing.'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Confirm'),
              onPressed: () async {
                await FirebaseFirestore.instance
                    .collection('booking').doc("aGAm7T71ShOqGUhYphfc")
                    .collection('yachts')
                    .doc(widget.yachtid) // <-- Doc ID to be deleted.
                    .delete() // <-- Delete
                    .then((_) => print('Deleted'))
                    .catchError((error) => print('Delete failed: $error'));

                print('Confirmed');
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => DeoManageYachts(widget.uid)));
              },
            ),
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }





  List<Widget> imageBuilderTwo(String device) {
    List<Widget> m = [];
    int numberOfImagesDisplayed = otheryachtImages
        .length /*
        otheryachtImages.length >= 5 ? 5 : otheryachtImages.length*/
    ;
    for (int i = 0; i < numberOfImagesDisplayed; i++) {
      m.add(
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(
                  right: MediaQuery.of(context).size.width * 0.005),
              child: Container(
                height: device == "mobile" ? MediaQuery.of(context).size.height / 7.5 : device == "tab" ? MediaQuery.of(context).size.height / 5 : MediaQuery.of(context).size.height / 3.62,
                width: MediaQuery.of(context).size.width / 3.62,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(otheryachtImages[i].toString()),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            )
          ],
        ),
      );
    }
    return m;
  }
}
