import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:worldsgate/helper/responsive_helper.dart';
import 'package:worldsgate/screens/user/booking/hotels/userviewhoteldetails.dart';
import 'package:worldsgate/screens/user/delivery/restaurants/userviewrestaurentdetails.dart';
import 'package:worldsgate/widgets/usernavigationdrawer.dart';

import '../../../../widgets/cusheader.dart';

class UserPharmacyOrder extends StatefulWidget {
  //const UserPharmacyOrder({Key? key}) : super(key: key);

  String? uid;
  String? city;

  UserPharmacyOrder(this.uid, this.city);

  @override
  State<UserPharmacyOrder> createState() => _UserPharmacyOrderState();
}

class _UserPharmacyOrderState extends State<UserPharmacyOrder> {
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

  String? city;
  String? mainFoodCategory;

  bool _isLocationSelected = false;
  @override
  Widget build(BuildContext context) {
    final CollectionReference packageCollection = FirebaseFirestore.instance
        .collection('delivery')
        .doc("9WRNvPkoftSw4o2rHGUI")
        .collection('pharmacys');
    final Query unpicked = mainFoodCategory != null
        ? packageCollection
            .where('city', isEqualTo: widget.city)
            .where('mainfoodcategories', arrayContainsAny: [mainFoodCategory])
        : packageCollection.where('city', isEqualTo: widget.city);

    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return SafeArea(
        child: Scaffold(
      key: _scaffoldState,
      drawer: new UserNavigationDrawer(widget.uid, widget.city),
      backgroundColor: Color(0xFF000000),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: ResponsiveWidget(
              mobile: buildColumnContent(
                  context, unpicked, height, width, "mobile"),
              tab: buildColumnContent(context, unpicked, height, width, "tab"),
              desktop: buildColumnContent(
                  context, unpicked, height, width, "desktop"),
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
    ));
  }

  Padding buildColumnContent(BuildContext context, Query<Object?> unpicked,
      double height, double width, String device) {
    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: device == "mobile"
              ? 0
              : device == "tab"
                  ? width * 0.1
                  : device == "desktop"
                      ? width * 0.13
                      : width * 0),
      child: Column(
        children: [
          Container(
            margin: EdgeInsets.only(
                top: device == "mobile"
                    ? height * 0.09
                    : device == "tab"
                        ? height * 0.1
                        : device == "desktop"
                            ? height * 0.13
                            : 0),
          ),
          Container(
            child: Align(
              alignment: Alignment.topLeft,
              child: Padding(
                padding: const EdgeInsets.only(left: 14.0),
                child: Text(
                  "200 Pharmacys Nearby You",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 16.0),
            child: StreamBuilder<QuerySnapshot>(
              stream: unpicked.snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else {
                  return Wrap(
                    //shrinkWrap: true,
                    //physics: NeverScrollableScrollPhysics(),
                    direction: Axis.horizontal,
                    children: snapshot.data!.docs.map((doc) {
                      return nearByRestaurantMethod(
                          context, doc, device, width, height);
                    }).toList(),
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  InkWell nearByRestaurantMethod(
      BuildContext context,
      QueryDocumentSnapshot<Object?> doc,
      String device,
      double width,
      double height) {
    return InkWell(
      onTap: () {
        //Navigator.of(context).push(MaterialPageRoute(
          //  builder: (context) =>
            //    UserViewRestaurantDetails(widget.uid, widget.city, doc.id)));
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 16.0),
        child: Container(
            width: device == "mobile"
                ? width
                : device == "tab"
                    ? width * 0.1
                    : device == "desktop"
                        ? width * 0.2
                        : width * 0,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Color(0xFFBA780F)),
            ),
            child: device == "mobile"
                ? Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Stack(
                          children: [
                            nearByRestaurantsImageMethod(context, doc),
                            nearByRestaurantsPromotionMethod(width, doc),
                          ],
                        ),
                        SizedBox(
                          width: width * 0.03,
                        ),
                        nearByRestaurantsOtherDetailsMethod(
                            context, height, width, device, doc),
                      ],
                    ),
                  )
                : device == "tab"
                    ? Row(
                        children: [
                          Stack(
                            children: [
                              nearByRestaurantsImageMethod(context, doc),
                              nearByRestaurantsPromotionMethod(width, doc),
                            ],
                          ),
                          nearByRestaurantsOtherDetailsMethod(
                              context, height, width, device, doc),
                        ],
                      )
                    : device == "desktop"
                        ? Column(
                            children: [
                              Stack(
                                children: [
                                  nearByRestaurantsImageMethod(context, doc),
                                  nearByRestaurantsPromotionMethod(width, doc),
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: nearByRestaurantsOtherDetailsMethod(
                                    context, height, width, device, doc),
                              ),
                            ],
                          )
                        : Row(
                            children: [
                              Stack(
                                children: [
                                  nearByRestaurantsImageMethod(context, doc),
                                  nearByRestaurantsPromotionMethod(width, doc),
                                ],
                              ),
                              nearByRestaurantsOtherDetailsMethod(
                                  context, height, width, device, doc),
                            ],
                          )),
      ),
    );
  }

  Container nearByRestaurantsOtherDetailsMethod(
      BuildContext context,
      double height,
      double width,
      String device,
      QueryDocumentSnapshot<Object?> doc) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Container(
            decoration: BoxDecoration(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: width * 0.45,
                  child: Wrap(
                    //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    direction: Axis.horizontal,
                    children: [
                      Text(
                        "${doc['name']}",
                        style: TextStyle(
                            fontSize: 14,
                            color: Colors.white,
                            fontWeight: FontWeight.bold),
                      ),
                      Text(" 3.2 KM",
                          style: TextStyle(fontSize: 12, color: Colors.white))
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                      top: device == "mobile"
                          ? height * 0.01
                          : device == "tab"
                              ? height * 0.1
                              : device == "desktop"
                                  ? height * 0.01
                                  : height * 0),
                  child: Text(
                    "${doc['city']}",
                    style: TextStyle(
                      fontSize: 12,
                      color: Color(0xFFBA780F),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                      top: device == "mobile"
                          ? height * 0.001
                          : device == "tab"
                              ? height * 0.1
                              : device == "desktop"
                                  ? height * 0.001
                                  : height * 0),
                  child: Container(
                    width: device == "mobile" ? width * 0.46 : null,
                    child: Text(/*
                      "${doc['mainfoodcategories'].join(", ")}"*/"",
                      style: TextStyle(
                          fontSize: 12,
                          color: Color(0xFFBA780F),
                          fontStyle: FontStyle.italic),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                      vertical: device == "mobile"
                          ? height * 0.001
                          : device == "tab"
                              ? height * 0.1
                              : device == "desktop"
                                  ? height * 0.02
                                  : height * 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Image.asset(
                        "assets/images/restaurentimages/DeliveryBike.png",
                        height: device == "mobile"
                            ? height * 0.06
                            : device == "tab"
                                ? height * 0.1
                                : device == "desktop"
                                    ? height * 0.03
                                    : height * 0,
                        width: width * 0.06,
                      ),
                      Text(
                        "  Live Tracking ",
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        "${doc['livetracking']}",
                        style:
                            TextStyle(fontSize: 12, color: Color(0xFFBA780F)),
                      )
                    ],
                  ),
                ),
                IntrinsicHeight(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      otherDetailsMethod(height, width, "Deal Time",
                          "${doc['preparationtime']}", device),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5.0),
                        child: otherDetailsMethod(height, width, "Delivery Fee",
                            "${doc['delivery']}", device),
                      ),
                      otherDetailsMethod(height, width, "Min Order",
                          "${doc['minimumorderprice']} AED", device)
                    ],
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Padding nearByRestaurantsPromotionMethod(
      double width, QueryDocumentSnapshot<Object?> doc) {
    return Padding(
      padding: const EdgeInsets.only(
          left: 12.0, top: 158.0, right: 8.0, bottom: 8.0),
      child: Container(
        height: 50,
        width: width * 0.35,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Color(0xFFBA780F)),
          color: Color(0xFFBA780F),
        ),
        child: Center(
          child: Text(
            "10% off",
            style: TextStyle(
              fontSize: 24,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  Container nearByRestaurantsImageMethod(
      BuildContext context, QueryDocumentSnapshot<Object?> doc) {
    return Container(
      height: 180.0,
      width: MediaQuery.of(context).size.width / 2.5,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Color(0xFFBA780F)),
        image: DecorationImage(
          image:
              NetworkImage(doc['coverimage'] == null ? "" : doc['coverimage']),
          fit: BoxFit.fill,
        ),
      ),
    );
  }

  Container otherDetailsMethod(double height, double width,
      String otherDetailsHeading, String otherDetail, String device) {
    return Container(
      width: device == "mobile"
          ? width * 0.146
          : device == "tab"
              ? width * 0.1
              : device == "desktop"
                  ? width * 0.055
                  : width * 0,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Color(0xFFBA780F)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Text(
              otherDetailsHeading,
              textAlign: TextAlign.center,
            ),
          ),
          Divider(
            color: Color(0xFFBA780F),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Text(otherDetail),
          )
        ],
      ),
    );
  }

  Padding favouriteChoiceMethod(double height, double width, String foodType,
      int numOfRestaurents, String deviceName) {
    return Padding(
      padding: EdgeInsets.only(right: width * 0.02),
      child: Align(
        alignment: Alignment.center,
        child: Stack(
          children: [
            Container(
              height: height * 0.15,
              width: deviceName == "mobile"
                  ? width * 0.2
                  : deviceName == "tab"
                      ? width * 0.1
                      : deviceName == "desktop"
                          ? width * 0.07
                          : width * 0,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Color(0xFFBA780F)),
                  color: Color(0xFF000000)),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: deviceName == "mobile"
                        ? width * 0.02
                        : deviceName == "tab"
                            ? width * 0.1
                            : deviceName == "desktop"
                                ? width * 0
                                : width * 0),
                child: Container(
                  width: deviceName == "mobile"
                      ? width * 0.16
                      : deviceName == "tab"
                          ? width * 0.1
                          : deviceName == "desktop"
                              ? width * 0.07
                              : width * 0,
                  child: Image.asset(
                    'assets/images/restaurentimages/FoodCatageryImages.png',
                    height: deviceName == "mobile"
                        ? height * 0.1
                        : deviceName == "tab"
                            ? height * 0.1
                            : deviceName == "desktop"
                                ? height * 0.09
                                : height * 0,
                    width: deviceName == "mobile"
                        ? width * 0.16
                        : deviceName == "tab"
                            ? width * 0.1
                            : deviceName == "desktop"
                                ? width * 0.1
                                : width * 0,
                  ),
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(
                  top: deviceName == "mobile"
                      ? height * 0.02
                      : deviceName == "tab"
                          ? height * 0.1
                          : deviceName == "desktop"
                              ? height * 0.04
                              : height * 0),
              height: height * 0.15,
              width: deviceName == "mobile"
                  ? width * 0.2
                  : deviceName == "tab"
                      ? width * 0.1
                      : deviceName == "desktop"
                          ? width * 0.07
                          : width * 0,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
              ),
              child: Stack(
                children: [
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      margin: EdgeInsets.only(
                          top: deviceName == "mobile"
                              ? height * 0.085
                              : deviceName == "tab"
                                  ? height * 0.1
                                  : deviceName == "desktop"
                                      ? height * 0.065
                                      : height * 0),
                      child: Column(
                        children: [
                          Text(
                            foodType,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 14,
                              color: Color(0xFFBA780F),
                            ),
                          ),
                          SizedBox(
                            height: 5.0,
                          ),
                          Text(
                            numOfRestaurents.toString() + "+ Places",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Align favouriteFoodMethod(double height, double width, String restaurentName,
      String restaurentBrandImage, Color color, String deviceName) {
    return Align(
      alignment: Alignment.center,
      child: Stack(
        children: [
          Container(
            height: height * 0.3,
            width: deviceName == "mobile"
                ? width * 0.3
                : deviceName == "tab"
                    ? width * 0.1
                    : deviceName == "desktop"
                        ? width * 0.226
                        : width * 0,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Color(0xFFBA780F)),
              image: DecorationImage(
                image: NetworkImage(
                  "https://images.theconversation.com/files/410720/original/file-20210712-46002-1ku5one.jpg?ixlib=rb-1.1.0&q=45&auto=format&w=1200&h=1200.0&fit=crop",
                ),
                fit: BoxFit.fill,
                // colorFilter: new ColorFilter.mode(
                //     Colors.black.withOpacity(0.3),
                //     BlendMode.colorBurn),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
                left: deviceName == "mobile"
                    ? width * 0.22
                    : deviceName == "tab"
                        ? width * 0.1
                        : deviceName == "desktop"
                            ? width * 0.20
                            : width * 0,
                top: height * 0.01),
            child: Container(
              height: height * 0.03,
              width: deviceName == "mobile"
                  ? width * 0.06
                  : deviceName == "tab"
                      ? width * 0.1
                      : deviceName == "desktop"
                          ? width * 0.02
                          : width * 0,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(restaurentBrandImage),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: height * 0.1),
            height: height * 0.3,
            width: deviceName == "mobile"
                ? width * 0.3
                : deviceName == "tab"
                    ? width * 0.1
                    : deviceName == "desktop"
                        ? width * 0.226
                        : width * 0,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                //border: Border.all(color: Color(0xFFBA780F)),
                // color: Colors.black,
                gradient: LinearGradient(
                    begin: FractionalOffset.topCenter,
                    end: FractionalOffset.bottomCenter,
                    colors: [
                      Colors.black87.withOpacity(0.0),
                      Colors.black87,
                    ],
                    stops: [
                      0.0,
                      0.7
                    ])),
            child: Stack(
              children: [
                Align(
                  alignment: Alignment.center,
                  child: Container(
                    margin: const EdgeInsets.only(top: 73.0),
                    child: Column(
                      children: [
                        Text(
                          "Indulge in delicious duo combos starting at 69 AED",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(
                          height: 5.0,
                        ),
                        Text(
                          restaurentName,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 11,
                            color: color,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
