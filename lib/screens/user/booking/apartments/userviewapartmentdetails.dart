import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:worldsgate/helper/responsive_helper.dart';
import 'package:worldsgate/widgets/header.dart';

import '../../../../widgets/cusheader.dart';
import '../../../../widgets/usernavigationdrawer.dart';

class UserViewApartmentDetails extends StatefulWidget {
  //const UserViewApartmentDetails({Key? key}) : super(key: key);
  String? uid;
  String? apartmentid;
  String? city;

  UserViewApartmentDetails(this.uid, this.apartmentid, this.city);

  @override
  _UserViewApartmentDetailsState createState() =>
      _UserViewApartmentDetailsState(apartmentid);
}

class _UserViewApartmentDetailsState extends State<UserViewApartmentDetails> {
  var _scaffoldState = new GlobalKey<ScaffoldState>();
  String? apartmentid;
  _UserViewApartmentDetailsState(this.apartmentid);

  bool _isLoading = true;

  var name;
  var stars;
  var address;
  var description;
  var apartmentCoverImage;
  var otherapartmentImages;
  var mainfacilities = [];
  var subFacilities;

  List<Map> rooms = <Map>[];

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
    print("The apartment ID is " + apartmentid.toString());
    await FirebaseFirestore.instance
        .collection('apartments')
        .doc(apartmentid.toString())
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        name = documentSnapshot['name'];
        address = documentSnapshot['address'];
        description = documentSnapshot['description'];

        if ((documentSnapshot.data() as Map<String, dynamic>)
            .containsKey('otherapartmentimages')) {
          otherapartmentImages = documentSnapshot['otherapartmentimages'].toList();
        }
        if ((documentSnapshot.data() as Map<String, dynamic>)
            .containsKey('coverimage')) {
          apartmentCoverImage = documentSnapshot['coverimage'];
        }
        if ((documentSnapshot.data() as Map<String, dynamic>)
            .containsKey('stars')) {
          stars = documentSnapshot['stars'];
        }
        if ((documentSnapshot.data() as Map<String, dynamic>)
            .containsKey('mainfacilities')) {
          mainfacilities = documentSnapshot['mainfacilities'].toList();
        }
        if ((documentSnapshot.data() as Map<String, dynamic>)
            .containsKey('subfacilities')) {
          subFacilities = documentSnapshot['subfacilities'];
        }
        if ((documentSnapshot.data() as Map<String, dynamic>)
            .containsKey('rooms')) {
          rooms.add(
            documentSnapshot['rooms'],
          );
        }
      } else {
        print("The document does not exist");
      }
    });
  }

  List<Widget> imageBuilderOne() {
    List<Widget> m = [];
    int numberOfImagesDisplayed =
        otherapartmentImages.length >= 2 ? 2 : otherapartmentImages.length;
    for (int i = 0; i < numberOfImagesDisplayed; i++) {
      m.add(
        Column(
          children: [
            Padding(
              padding: EdgeInsets.only(
                  right: MediaQuery.of(context).size.width * 0.005,
                  bottom: MediaQuery.of(context).size.width * 0.005),
              child: Container(
                height: MediaQuery.of(context).size.height * 0.25,
                width: MediaQuery.of(context).size.width * 0.366,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(otherapartmentImages[i].toString()),
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
    int numberOfImagesDisplayed = otherapartmentImages
            .length /*
        otherapartmentImages.length >= 5 ? 5 : otherapartmentImages.length*/
        ;
    for (int i = 2; i < numberOfImagesDisplayed; i++) {
      m.add(
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(
                  right: MediaQuery.of(context).size.width * 0.005),
              child: Container(
                height: MediaQuery.of(context).size.height / 7.5,
                width: MediaQuery.of(context).size.width / 3.62,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(otherapartmentImages[i].toString()),
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

  List<Widget> imageBuilderThree() {
    List<Widget> m = [];
    m.add(Column(
      mainAxisAlignment: MainAxisAlignment.start,
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
                  padding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).size.width * 0.005),
                  child: Container(
                    height: MediaQuery.of(context).size.height * 0.504,
                    width: MediaQuery.of(context).size.width * 0.549,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: NetworkImage(apartmentCoverImage.toString()),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                )
              ],
            ),
          ],
        ),
        Align(
          alignment: Alignment.bottomLeft,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: imageBuilderTwo(),
            ),
          ),
        )
      ],
    ));
    return m;
  }

  List<Widget> mainfacilitiez(width, height, device) {
    List<Widget> m = [];
    for (int i = 0; i < mainfacilities.length; i++) {
      m.add(Container(
        width: device == "mobile"
            ? width * 0.46
            : device == "tab"
                ? width * 0.30
                : device == "desktop"
                    ? width * 0.23
                    : width * 0.23,
        child: RichText(
          maxLines: 5,
          text: TextSpan(children: [
            WidgetSpan(
              alignment: PlaceholderAlignment.bottom,
              child: Icon(
                Icons.check,
                color: Color(0xFFb38219),
              ),
            ),
            TextSpan(
              text: mainfacilities[i].toString(),
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ]),
        ),
      ));
    }
    return m;
  }

  // Sub-Facilities Start
  List<Widget> allSubFacilitiesKeys(width, height, device) {
    List<Widget> m = [];
    subFacilities.forEach((k, v) {
      print('{ key: $k, value: $v }');
      m.add(Container(
        child: Column(
          children: [
            Container(
                height: MediaQuery.of(context).size.height / 19,
                child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "$k",
                      style: TextStyle(
                          color: Colors.white70,
                          fontSize: device == "mobile"
                              ? 15
                              : device == "tab"
                                  ? 16
                                  : device == "desktop"
                                      ? 17
                                      : 17),
                    ))),
            Align(
              alignment: Alignment.topLeft,
              child: Wrap(
                direction: Axis.horizontal,
                alignment: WrapAlignment.start,
                children: allSubFacilitiesValues(v, width, height, device),
              ),
            )
          ],
        ),
      ));
    });
    return m;
  }

  List<Widget> allSubFacilitiesValues(v, width, height, device) {
    List<Widget> m = [];
    for (int i = 0; i < v.length; i++) {
      m.add(Container(
        width: device == "mobile"
            ? width * 0.46
            : device == "tab"
                ? width * 0.30
                : device == "desktop"
                    ? width * 0.23
                    : width * 0.23,
        child: RichText(
          maxLines: 5,
          text: TextSpan(children: [
            WidgetSpan(
              alignment: PlaceholderAlignment.bottom,
              child: Icon(
                Icons.check,
                color: Color(0xFFb38219),
              ),
            ),
            TextSpan(
              text: "${v[i]}",
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ]),
        ),
      ));
    }
    return m;
  }
  // Sub-Facilities End

  List<Widget> roomall() {
    List<Widget> m = [];
    for (int i = 0; i < rooms.length; i++) {
      var entryList = rooms[i].entries.toList()
        ..sort((e1, e2) => e2.key.compareTo(e1.key));
      for (int j = 0; j < entryList.length; j++) {
        m.add(IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                decoration:
                    BoxDecoration(border: Border.all(color: Color(0xFFb38219))),
                width: MediaQuery.of(context).size.width * 0.368,
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
                width: MediaQuery.of(context).size.width * 0.184,
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
                width: MediaQuery.of(context).size.width * 0.368,
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

  @override
  void initState() {
    getyo();
    getname();
    Future.delayed(Duration(seconds: 2), () {
      setState(() {
        _isLoading = false;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return _isLoading
        ? Center(child: CircularProgressIndicator())
        : SafeArea(
            child: Scaffold(
              key: _scaffoldState,
              drawer: new UserNavigationDrawer(widget.uid, widget.city),
              backgroundColor: Color(0xFF000000),
              body: Stack(
                children: [
                  SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: ResponsiveWidget(
                      mobile: viewapartmentDetailsContainer(
                          context, width, height, "mobile"),
                      tab: viewapartmentDetailsContainer(
                          context, width, height, "tab"),
                      desktop: viewapartmentDetailsContainer(
                          context, width, height, "desktop"),
                    ),
                  ),
                  Positioned(
                      left: 0.0,
                      top: 0.0,
                      right: 0.0,
                      child: Container(
                          child: VendomeHeaderCustomer(
                        drawer: _scaffoldState,
                        cusname: cusname,
                        cusaddress: widget.city,
                            role: role,
                      ))),
                ],
              ),
            ),
          );
  }

  Container viewapartmentDetailsContainer(
      BuildContext context, double width, double height, String device) {
    return Container(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: width * 0.04),
        child: Column(
          children: [
            SizedBox(
              height: height * 0.18,
            ),
            Container(
              child: Align(
                alignment: Alignment.topLeft,
                child: RichText(
                  maxLines: 5,
                  text: TextSpan(children: [
                    TextSpan(
                      text: name + " ",
                      style: TextStyle(
                          fontSize: device == "mobile"
                              ? 25
                              : device == "tab"
                                  ? 25
                                  : device == "desktop"
                                      ? 25
                                      : 25,
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                    ),
                    WidgetSpan(
                      alignment: PlaceholderAlignment.bottom,
                      child: RatingBar.builder(
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
                        itemCount: stars == 1
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
                        itemSize: device == "mobile"
                            ? 25
                            : device == "tab"
                                ? 25
                                : device == "desktop"
                                    ? 25
                                    : 25,
                        itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                        itemBuilder: (context, _) => Icon(
                          Icons.star,
                          color: Colors.amber,
                        ),
                        onRatingUpdate: (rating) {
                          print(rating);
                        },
                      ),
                    ),
                  ]),
                ),
              ),
            ),
            SizedBox(
              height: 10.0,
            ),
            Container(
              child: Align(
                alignment: Alignment.topLeft,
                child: RichText(
                  maxLines: 5,
                  text: TextSpan(children: [
                    WidgetSpan(
                      alignment: PlaceholderAlignment.bottom,
                      child: Icon(
                        Icons.location_on,
                        color: Color(0xFFdb9e1f),
                        size: device == "mobile"
                            ? 15
                            : device == "tab"
                                ? 16
                                : device == "desktop"
                                    ? 17
                                    : 17,
                      ),
                    ),
                    TextSpan(
                      text: "  ${address} - Great location - show map",
                      style: TextStyle(
                        fontSize: device == "mobile"
                            ? 15
                            : device == "tab"
                                ? 16
                                : device == "desktop"
                                    ? 17
                                    : 17,
                        color: Colors.white,
                      ),
                    ),
                  ]),
                ),
              ),
            ),
            SizedBox(
              height: 20.0,
            ),
            Container(
              child: Column(
                children: imageBuilderThree(),
              ),
            ),
            SizedBox(
              height: 20.0,
            ),
            Container(
              child: Column(
                children: [
                  Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        "Property Description",
                        style: TextStyle(
                            fontSize: device == "mobile"
                                ? 15
                                : device == "tab"
                                    ? 16
                                    : device == "desktop"
                                        ? 17
                                        : 17,
                            color: Colors.white70),
                      )),
                  SizedBox(
                    height: 10.0,
                  ),
                  Text(
                    description,
                    style: TextStyle(
                      fontSize: device == "mobile"
                          ? 13
                          : device == "tab"
                              ? 14
                              : device == "desktop"
                                  ? 15
                                  : 15,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 20.0,
            ),
            Container(
              child: Column(
                children: [
                  Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        "Facilities",
                        style: TextStyle(
                            fontSize: device == "mobile"
                                ? 15
                                : device == "tab"
                                    ? 16
                                    : device == "desktop"
                                        ? 17
                                        : 17,
                            color: Colors.white70),
                      )),
                  SizedBox(
                    height: 10.0,
                  ),
                  Wrap(
                    children: mainfacilitiez(width, height, device),
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  Wrap(
                      children: subFacilities != null
                          ? allSubFacilitiesKeys(width, height, device)
                          : []),
                ],
              ),
            ),
            SizedBox(
              height: 20.0,
            ),
            Column(
              children: [
                Container(
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              color: Color(0xFFdb9e1f),
                            ),
                            width: MediaQuery.of(context).size.width * 0.368,
                            height: MediaQuery.of(context).size.height / 10,
                            child: Center(
                              child: Text(
                                "Room Type",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                          Container(
                            decoration: BoxDecoration(
                              color: Color(0xFFdb9e1f),
                            ),
                            width: MediaQuery.of(context).size.width * 0.184,
                            height: MediaQuery.of(context).size.height / 10,
                            child: Center(
                              child: Text(
                                "Sleeps",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                          Container(
                            decoration: BoxDecoration(
                              color: Color(0xFFdb9e1f),
                            ),
                            width: MediaQuery.of(context).size.width * 0.368,
                            height: MediaQuery.of(context).size.height / 10,
                            child: Center(
                              child: Text(
                                "Price",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ],
                      ),
                      IntrinsicHeight(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: roomall(),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 20.0,
            ),
          ],
        ),
      ),
    );
  }
}
