import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:worldsgate/helper/responsive_helper.dart';
import 'package:worldsgate/widgets/deonavigationdrawer.dart';
import 'package:worldsgate/widgets/header.dart';
import '../../../../widgets/sidelayout.dart';
import 'deoaddhoteldetails.dart';
import 'deomanagehotels.dart';
import 'deoupdatehoteldetails.dart';

class DeoViewHotels extends StatefulWidget {
  //const DeoViewHotels({Key? key}) : super(key: key);

  String? uid;
  String? hotelid;

  // constructor
  DeoViewHotels(this.uid, this.hotelid);

  @override
  _DeoViewHotelsState createState() => _DeoViewHotelsState(uid, hotelid);
}

class _DeoViewHotelsState extends State<DeoViewHotels> {
  String? uid;
  String? hotelid;

  _DeoViewHotelsState(this.uid, this.hotelid);



  bool _isLoading = true;

  var _scaffoldState = new GlobalKey<ScaffoldState>();


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

  List<dynamic> dategroupbylist = <dynamic>[];
  List<Map> subfacilities = <Map>[];
  List<Map> rooms = <Map>[];

  var name;
  var address;
  var description;
  var stars;
  var hotelCoverPhoto;
  var allOtherHotelImages = [];
  var otherHotelImages;
  var mainfacilities = [];
  var subFacilities;

  getyo() async {
    // print("The hotel ID is " + hotelid.toString());
    await FirebaseFirestore.instance
        .collection('hotels')
        .doc(hotelid.toString())
        .get()
        .then(((DocumentSnapshot doc) {
      if ((doc.data() as Map<String, dynamic>).containsKey('name')) {
        name = doc['name'];
      }
      if ((doc.data() as Map<String, dynamic>).containsKey('address')) {
        address = doc['address'];
      }
      if ((doc.data() as Map<String, dynamic>).containsKey('description')) {
        description = doc['description'];
      }
      if ((doc.data() as Map<String, dynamic>).containsKey('stars')) {
        stars = doc['stars'];
      }
      if ((doc.data() as Map<String, dynamic>)
          .containsKey('otherhotelimages')) {
        allOtherHotelImages = doc['otherhotelimages'].toList();
      }
      if ((doc.data() as Map<String, dynamic>).containsKey('mainfacilities')) {
        mainfacilities = doc['mainfacilities'].toList();
      }
      if ((doc.data() as Map<String, dynamic>).containsKey('subfacilities')) {
        subFacilities = doc['subfacilities'];
      }
      if ((doc.data() as Map<String, dynamic>).containsKey('rooms')) {
        rooms.add(
          doc['rooms'],
        );
      }
      if ((doc.data() as Map<String, dynamic>).containsKey('coverimage')) {
        hotelCoverPhoto = doc['coverimage'];
      }
    }));
    try {
      setState(() {
        otherHotelImages = allOtherHotelImages;
      });
    } catch (e) {
      print(e);
    }
  }

  List<Widget> roomall() {
    List<Widget> m = [];

    for (int i = 0; i < rooms.length; i++) {
      // print(rooms[i].entries);

      var entryList = rooms[i].entries.toList()
        ..sort((e1, e2) => e2.key.compareTo(e1.key));

      for (int j = 0; j < entryList.length; j++) {
        //each list -  room name
        // print(entryList[j].key);
        // print(entryList[j].value);

        m.add(IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                decoration:
                    BoxDecoration(border: Border.all(color: Color(0xFFb38219))),
                width: MediaQuery.of(context).size.width / 6.01,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          "${entryList[j].key.toString()}",
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ),
                      Row(
                        children: [
                          Text(
                            "${entryList[j].value[2]}     ",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                          Icon(
                            Icons.king_bed_outlined,
                            color: Color(0xFFdb9e1f),
                            size: 30.0,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                decoration:
                    BoxDecoration(border: Border.all(color: Color(0xFFb38219))),
                width: MediaQuery.of(context).size.width / 6.01,
                // height:
                //     MediaQuery.of(context)
                //             .size
                //             .height /
                //         10,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Tooltip(
                        message:
                            '${entryList[j].value[0]} Adults and ${entryList[j].value[1]} Children',
                        child: Icon(
                          Icons.supervisor_account,
                          color: Color(0xFFdb9e1f),
                          size: 30.0,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                decoration:
                    BoxDecoration(border: Border.all(color: Color(0xFFb38219))),
                width: MediaQuery.of(context).size.width / 6.01,
                // height:
                //     MediaQuery.of(context)
                //             .size
                //             .height /
                //         10,
                child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Align(
                          alignment: Alignment.topLeft,
                          child: Text(
                            "AED ${entryList[j].value[3]}",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        Align(
                          alignment: Alignment.topLeft,
                          child: Text(
                            "Includes Taxes and Fees",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w100),
                          ),
                        ),
                      ],
                    )),
              ),
            ],
          ),
        ));
      }
    }
    return m;
  }

  List<Widget> imageBuilderOne() {
    List<Widget> m = [];
    int numberOfImagesDisplayed =
        otherHotelImages.length >= 2 ? 2 : otherHotelImages.length;
    for (int i = 0; i < numberOfImagesDisplayed; i++) {
      m.add(
        Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(5.0),
              child: Container(
                height: MediaQuery.of(context).size.height / 4.45,
                width: MediaQuery.of(context).size.width / 5.85,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(otherHotelImages[i].toString()),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    }

    return m;
  }

  List<Widget> imageBuilderTwo() {
    List<Widget> m = [];
    int numberOfImagesDisplayed =
        otherHotelImages.length >= 7 ? 7 : otherHotelImages.length;
    for (int i = 2; i < numberOfImagesDisplayed; i++) {
      m.add(
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(5.0),
              child: Container(
                height: MediaQuery.of(context).size.height / 7.5,
                width: MediaQuery.of(context).size.width / 9.95,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(otherHotelImages[i].toString()),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    }
    return m;
  }

  List<Widget> imageBuilderThree() {
    List<Widget> m = [];

    m.add(Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              children: imageBuilderOne(),
            ),
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Container(
                    height: MediaQuery.of(context).size.height / 2.18,
                    width: MediaQuery.of(context).size.width / 2.85,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: NetworkImage(hotelCoverPhoto.toString()),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                )
              ],
            ),
          ],
        ),
        Row(
          children: imageBuilderTwo(),
        )
      ],
    ));

    return m;
  }

  List<Widget> mainfacilitiez() {
    List<Widget> m = [];

    for (int i = 0; i < mainfacilities.length; i++) {
      //print(mainfacilities[i]);
      m.add(Wrap(
        children: [
          Icon(
            Icons.check,
            color: Color(0xFFb38219),
          ),
          Text(
            mainfacilities[i].toString(),
            style: TextStyle(color: Colors.white),
          ),
        ],
      ));
    }
    return m;
  }

  // Sub-Facilities Start
  List<Widget> allSubFacilitiesKeys() {
    List<Widget> m = [];
    subFacilities.forEach((k, v) {
      print('{ key: $k, value: $v }');
      m.add(Container(
        child: Column(
          children: [
            Container(
                width: MediaQuery.of(context).size.width / 5.00,
                height: MediaQuery.of(context).size.height / 19,
                //decoration: BoxDecoration(
                //border: Border.all(color: Color(0xFFdb9e1f)),
                //color: Color(0xFFdb9e1f),
                //),
                child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "$k",
                      style: TextStyle(color: Colors.white70, fontSize: 16.0),
                    ))),
            Container(
              width: MediaQuery.of(context).size.width / 5.00,
              //decoration:
              //BoxDecoration(border: Border.all(color: Color(0xFFb38219))),
              child: Column(
                children: allSubFacilitiesValues(v),
              ),
            )
          ],
        ),
      ));
    });
    return m;
  }

  List<Widget> allSubFacilitiesValues(v) {
    List<Widget> m = [];
    for (int i = 0; i < v.length; i++) {
      m.add(Align(
          alignment: Alignment.topLeft,
          child: Row(
            children: [
              Icon(
                Icons.check,
                color: Color(0xFFdb9e1f),
              ),
              SizedBox(
                width: 10.0,
              ),
              Flexible(
                  child: Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: Text("${v[i]}"),
              )),
            ],
          )));
    }
    return m;
  }
  // Sub-Facilities End

  TextEditingController _textFieldController = TextEditingController();
  String? valueText;

  Future<void> _displayTextInputDialog(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            backgroundColor: Color(0xFFdb9e1f),
            title: Text(
              'DELETE HOTEL DOCUMENT',
              style: TextStyle(color: Color(0xFF000000)),
            ),
            content: TextField(
              onChanged: (value) {
                setState(() {
                  valueText = value;
                });
              },
              controller: _textFieldController,
              decoration: InputDecoration(hintText: "Enter Password"),
            ),
            actions: <Widget>[
              TextButton(
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.all(16.0),
                  primary: Color(0xFF000000),
                  backgroundColor: Colors.white,
                  textStyle: const TextStyle(fontSize: 16),
                ),
                onPressed: () {
                  setState(() {
                    Navigator.pop(context);
                  });
                },
                child: const Text('CANCEL'),
              ),
              SizedBox(
                width: 90.0,
              ),
              TextButton(
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.all(16.0),
                  primary: Colors.white,
                  backgroundColor: Color(0xFF000000),
                  textStyle: const TextStyle(fontSize: 16),
                ),
                onPressed: () {
                  valueText == "12345"
                      ? _deleteHotelDocument()
                      : print("Wrong password entered");
                },
                child: const Text('DELETE'),
              ),
            ],
          );
        });
  }

  _deleteHotelDocument() async {
    try {
      await FirebaseStorage.instance.refFromURL(hotelCoverPhoto).delete();

      for (int i = 0; i < otherHotelImages.length; i++) {
        await FirebaseStorage.instance.refFromURL(otherHotelImages[i]).delete();
      }

      await FirebaseFirestore.instance
          .collection("hotels")
          .doc(hotelid.toString())
          .delete()
          .then((value) => print("Hotel Document Deleted"))
          .catchError((error) => print("Failed to delete user: $error"));

      Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => DeoManageHotels(widget.uid)));
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    super.initState();
    getname();
    getyo();
    Future.delayed(Duration(seconds: 1), () {
      setState(() {
        _isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    //final double height = MediaQuery.of(context).size.height;

    return SafeArea(
        child: Scaffold(
      key: _scaffoldState,

      // appBar: AppBar(
      //   backgroundColor: Colors.transparent,
      //   elevation: 0.0,
      //   iconTheme: IconThemeData(color: Color(0xFFdb9e1f)),
      // ),

      //endDrawer: new DeoNavigationDrawer(),

      drawer: new DeoNavigationDrawer(widget.uid),

      backgroundColor: Color(0xFF000000),
      body: (_isLoading == true)
          ? Center(child: CircularProgressIndicator())
          : Stack(
              fit: StackFit.expand,
              children: <Widget>[
                ResponsiveWidget(
                    mobile: buildColumnContent(context, width),
                    tab: buildColumnContent(context, width),
                    desktop: buildColumnContent(context, width)
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

  Column buildColumnContent(BuildContext context, double width) {
    return Column(
                children: [
                  SizedBox(
                    height: 160.0,
                  ),
                  Expanded(
                    child: LayoutBuilder(

                        builder: (context, constraints) {
                        return Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            (constraints.maxWidth >= 1008)
                                ?SideLayout():Container(),
                            Expanded(
                              child: SingleChildScrollView(
                                scrollDirection: Axis.vertical,
                                child: Container(
                                  margin: EdgeInsets.only(
                                    left: MediaQuery.of(context).size.width / 80,
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        child: Align(
                                            alignment: Alignment.topLeft,
                                            child: Row(
                                              children: [
                                                Text(
                                                  name,
                                                  style: TextStyle(
                                                      fontSize: 20,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                RatingBar.builder(
                                                  initialRating: stars == 1
                                                      ? 1
                                                      : stars == 2
                                                          ? 2
                                                          : stars == 3
                                                              ? 3
                                                              : stars == 4
                                                                  ? 4
                                                                  : stars == 5
                                                                      ? 5
                                                                      : 0,
                                                  direction: Axis.horizontal,
                                                  ignoreGestures: true,
                                                  itemCount: 5,
                                                  itemSize: width * 0.016,
                                                  itemPadding:
                                                      EdgeInsets.symmetric(
                                                          horizontal: 4.0),
                                                  itemBuilder: (context, _) =>
                                                      Icon(
                                                    Icons.star,
                                                    color: Colors.amber,
                                                  ),
                                                  onRatingUpdate: (rating) {
                                                    print(rating);
                                                  },
                                                ),
                                              ],
                                            )),
                                      ),
                                      //row for button and booking hotel heading
                                      Container(
                                        margin: EdgeInsets.only(top: 10.0),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Align(
                                              alignment: Alignment.topLeft,
                                              child: Row(
                                                children: [
                                                  Icon(
                                                    Icons.location_on,
                                                    color: Color(0xFFdb9e1f),
                                                    size: width * 0.015,
                                                  ),
                                                  Text(
                                                    "  ${address} - Great location - show map",
                                                    style: TextStyle(
                                                      fontSize: width * 0.008,
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Align(
                                              alignment: Alignment.topRight,
                                              child: MaterialButton(
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                10.0)),
                                                    side: BorderSide(
                                                        color:
                                                            Color(0xFFdb9e1f))),
                                                elevation: 5.0,
                                                height: MediaQuery.of(context)
                                                        .size
                                                        .height /
                                                    18,
                                                minWidth: MediaQuery.of(context)
                                                        .size
                                                        .width /
                                                    30,
                                                onPressed: () {
                                                  Navigator.of(context).push(
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              // TaskCardWidget(id: user.id, name: user.ingredients,)
                                                              AddHotelDetails(
                                                                  widget.uid)));
                                                },
                                                child: Text(
                                                  "Reserve",
                                                  style: TextStyle(
                                                    fontSize: width * 0.013,
                                                    color: Color(0xFFdb9e1f),
                                                  ),
                                                ),
                                                color: Colors.black,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        child: Column(
                                          children: imageBuilderThree(),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 50.0,
                                      ),
                                      Container(
                                        child: Padding(
                                          padding: EdgeInsets.only(
                                              right: MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  4.9,
                                              bottom: 30),
                                          child: Text(
                                            description,
                                            style: TextStyle(fontSize: 16.0),
                                          ),
                                        ),
                                      ),
                                      //table
                                      Padding(
                                        padding: EdgeInsets.only(
                                            bottom: 24.0, top: 8.0),
                                        child: Column(
                                          children: [
                                            Container(
                                              child: Column(
                                                children: [
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    children: [
                                                      Container(
                                                        decoration: BoxDecoration(
                                                          //border: Border.all(color: Color(0xFFdb9e1f)),
                                                          color:
                                                              Color(0xFFdb9e1f),
                                                        ),
                                                        width:
                                                            MediaQuery.of(context)
                                                                    .size
                                                                    .width /
                                                                6.01,
                                                        height:
                                                            MediaQuery.of(context)
                                                                    .size
                                                                    .height /
                                                                10,
                                                        child: Center(
                                                          child: Text(
                                                            "Room Type",
                                                            style: TextStyle(
                                                                color:
                                                                    Colors.white,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                          ),
                                                        ),
                                                      ),
                                                      Container(
                                                        decoration: BoxDecoration(
                                                          //border: Border.all(color: Color(0xFFdb9e1f)),
                                                          color:
                                                              Color(0xFFdb9e1f),
                                                        ),
                                                        width:
                                                            MediaQuery.of(context)
                                                                    .size
                                                                    .width /
                                                                6.01,
                                                        height:
                                                            MediaQuery.of(context)
                                                                    .size
                                                                    .height /
                                                                10,
                                                        child: Center(
                                                          child: Text(
                                                            "Sleeps",
                                                            style: TextStyle(
                                                                color:
                                                                    Colors.white,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                          ),
                                                        ),
                                                      ),
                                                      Container(
                                                        decoration: BoxDecoration(
                                                          //border: Border.all(color: Color(0xFFdb9e1f)),
                                                          color:
                                                              Color(0xFFdb9e1f),
                                                        ),
                                                        width:
                                                            MediaQuery.of(context)
                                                                    .size
                                                                    .width /
                                                                6.01,
                                                        height:
                                                            MediaQuery.of(context)
                                                                    .size
                                                                    .height /
                                                                10,
                                                        child: Center(
                                                          child: Text(
                                                            "Price",
                                                            style: TextStyle(
                                                                color:
                                                                    Colors.white,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                          ),
                                                        ),
                                                      ),
                                                      //4th column
                                                      // Container(
                                                      //   decoration: BoxDecoration(
                                                      //     //border: Border.all(color: Color(0xFFdb9e1f)),
                                                      //     color:
                                                      //         Color(0xFFdb9e1f),
                                                      //   ),
                                                      //   width:
                                                      //       MediaQuery.of(context)
                                                      //               .size
                                                      //               .width /
                                                      //           6.01,
                                                      //   height:
                                                      //       MediaQuery.of(context)
                                                      //               .size
                                                      //               .height /
                                                      //           10,
                                                      //   child: Center(
                                                      //     child: Text(
                                                      //       "Room Type",
                                                      //       style: TextStyle(
                                                      //           color:
                                                      //               Colors.white,
                                                      //           fontWeight:
                                                      //               FontWeight
                                                      //                   .bold),
                                                      //     ),
                                                      //   ),
                                                      // ),
                                                    ],
                                                  ),
                                                  IntrinsicHeight(
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .stretch,
                                                      children: roomall(),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Text(
                                        "Facilities of $name",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 20.0,
                                        ),
                                      ),
                                      SizedBox(height: 20.0),
                                      Text(
                                        "Most popular facilities",
                                        style: TextStyle(
                                            color: Colors.white70,
                                            fontSize: 16.0),
                                      ),
                                      SizedBox(height: 10.0),
                                      Wrap(
                                        spacing: 20.0,
                                        children: mainfacilitiez(),
                                      ),
                                      SizedBox(height: 20.0),
                                      /*Text(
                                        "Other facilities",
                                        style: TextStyle(
                                            color: Colors.white70,
                                            fontSize: 16.0),
                                      ),
                                      SizedBox(height: 10.0),*/
                                      Wrap(
                                          children: subFacilities != null
                                              ? allSubFacilitiesKeys()
                                              : []),
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
                                                            UpdateHotelDetails(
                                                                widget.uid,
                                                                widget.hotelid)));
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
                                                _displayTextInputDialog(context);
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
                                      Container(
                                        child: Column(
                                          children: [],
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        );
                      }
                    ),
                  ),
                ],
              );
  }
}
