import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutterfire_ui/firestore.dart';
import 'package:supercharged/supercharged.dart';
import 'package:worldsgate/helper/responsive_helper.dart';
import 'package:worldsgate/screens/dataentryoperator/delivery/restaurants/deoaddrestaurantdetails.dart';
import 'package:worldsgate/widgets/deonavigationdrawer.dart';
import 'package:worldsgate/widgets/header.dart';
import 'package:intl/intl.dart';
import 'package:worldsgate/widgets/sidelayout.dart';

import '../../booking/cars/deoviewcars.dart';

//import 'deoaddcardetails.dart';

class DeoManageRestaurant extends StatefulWidget {
  //const DeoManageRestaurant({Key? key}) : super(key: key);

  String? uid;

  DeoManageRestaurant(this.uid);

  @override
  State<DeoManageRestaurant> createState() => _DeoManageRestaurantState();
}

class _DeoManageRestaurantState extends State<DeoManageRestaurant> {
  bool _isLoading = true;

  var _scaffoldState = new GlobalKey<ScaffoldState>();
  String? datecreated;
  String? carname;

  List<Map> dategroupbylist = <Map>[];

  var entryList;
  var subEntryList;
  var testList;
  var newMap;
  var subNewMap;

  int? totaladded;

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
    FirebaseFirestore.instance

        .collection('delivery')
        .doc("9WRNvPkoftSw4o2rHGUI")
        .collection('restaurants')
        .where('dataentryuid', isEqualTo: widget.uid)
        .get()
        .then((myDocuments) {
      print("${myDocuments.docs.length}");
      totaladded = myDocuments.docs.length;
    });
    await FirebaseFirestore.instance

        .collection('delivery')
        .doc("9WRNvPkoftSw4o2rHGUI")
        .collection('restaurants')
        .where('dataentryuid', isEqualTo: widget.uid)
        .get()
        .then((QuerySnapshot querySnapshot) => {
              querySnapshot.docs.forEach((doc) {
                DateTime dt = (doc['datecreated'] as Timestamp).toDate();
                String formattedDate = DateFormat('yyyy/MM/dd').format(dt);
                dategroupbylist.add({
                  "restaurantid": doc.id,
                  "name": '${doc['name']}',
                  "minimumorderprice": '${doc['minimumorderprice']}',
                  "preparationtime": '${doc['preparationtime']}',
                  "description": '${doc['description']}',
                  "coverimage": '${doc['coverimage']}',
                  "otherrestaurantimages": '${doc['otherrestaurantimages']}',
                  "delivery": '${doc['delivery']}',
                  "livetracking": '${doc['livetracking']}',
                  "deliverycharge": '${doc['deliverycharge']}',
                  "address": '${doc['address']}',
                  "added_date": '${formattedDate}',
                });
              })
            });

    final maps = dategroupbylist.groupBy<String, Map>(
      (item) => item['added_date'],
      valueTransform: (item) => item..remove('added_date'),
    );

    try {
      setState(() {
        newMap = maps;
        entryList = maps.entries.toList()
          ..sort((e1, e2) => e2.key.compareTo(e1.key));
      });
      setState(() {
        testList = entryList[0].value[0].entries.toList();
      });
    } catch (e) {
      print(e);
    }
  }

  List<Widget> newbuilder(double fontsize, double columntextwidth, String tex,
      double height, double width) {
    List<Widget> m = [];

    for (int i = 0; i < entryList.length; i++) {
      m.add(Container(
        width: double.infinity,
        margin: EdgeInsets.only(top: 12.0, bottom: 12.0),
        child: Column(
          children: [
            Text(
              "${entryList[i].key} (${entryList[i].value.length.toString()})",
              style: TextStyle(color: Colors.white),
            ),
          ],
        ),
      ));
   
        m.add(   AspectRatio(
          aspectRatio:

          (tex=="desktop" || tex=="tabextended")?
          (entryList[i].value.length ==1 ? 16/4.7 : entryList[i].value.length ==2 ? 16/4.7 : entryList[i].value.length ==3 ? 16/9.4:  16/9.4):
          (entryList[i].value.length ==1 ? 16/9 : entryList[i].value.length ==2 ? 16/18 : entryList[i].value.length ==3 ? 16/27:  16/36),
          child: FirestoreQueryBuilder<Map<String, dynamic>>(

              query: FirebaseFirestore.instance
                  .collection('delivery')
                  .doc("9WRNvPkoftSw4o2rHGUI")
                  .collection('restaurants').where('dataentryuid', isEqualTo: widget.uid).where('date',

                  isEqualTo: entryList[i].key),
              //reduce the height
              pageSize: 2,
              // loadingBuilder: (context) =>
              //     Center(child: CircularProgressIndicator()),
              //errorBuilder: (context, error, stackTrace) => MyCustomError(error, stackTrace),

              builder: (context, snapshot, _) {
                return GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: tex=="desktop" ? 3 : tex=="tabextended" ? 2 : 1,
                      childAspectRatio: (16 / 9),
                    ),
                    itemCount: snapshot.docs.length,
                    itemBuilder: (context, index) {
                      final hasEndedReached = snapshot.hasMore && index + 1 == snapshot.docs.length && !snapshot.isFetchingMore;
                      if(hasEndedReached){
                        snapshot.fetchMore();
                      }
                      if(snapshot.isFetching){
                        return Center(child: Center(child: CircularProgressIndicator()),);
                      }else if(snapshot.hasError){
                        return Text('Something went wrong! ${snapshot.error}');
                      }else{
                        return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: nearByRestaurantMethod(
                                snapshot.docs[index], context, tex, width, height)
                        );

                      }

                    }
                );
              }
          ),
        ),
 
        );
      
    }

    return m;
  }

  InkWell nearByRestaurantMethod(QueryDocumentSnapshot<Map<String, dynamic>> snapshot, BuildContext context,
      String device, double width, double height) {
    return InkWell(
      onTap: () {
        /*Navigator.of(context).push(MaterialPageRoute(
            builder: (context) =>
                UserViewHotelDetails(widget.uid, doc.id, widget.city)));*/
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
                            nearByRestaurantsImageMethod(context,snapshot),
                            nearByRestaurantsPromotionMethod(width,snapshot),
                          ],
                        ),
                        SizedBox(
                          width: width * 0.03,
                        ),
                        nearByRestaurantsOtherDetailsMethod(
                            context, height, width, device,snapshot),
                      ],
                    ),
                  )
                : device == "tab"
                    ? Row(
                        children: [
                          Stack(
                            children: [
                              nearByRestaurantsImageMethod(context,snapshot),
                              nearByRestaurantsPromotionMethod(width,snapshot),
                            ],
                          ),
                          nearByRestaurantsOtherDetailsMethod(
                              context, height, width, device,snapshot),
                        ],
                      )
                    : device == "desktop"
                        ? Column(
                            children: [
                              Stack(
                                children: [
                                  nearByRestaurantsImageMethod(context,snapshot),
                                  nearByRestaurantsPromotionMethod(width,snapshot),
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: nearByRestaurantsOtherDetailsMethod(
                                    context, height, width, device,snapshot),
                              ),
                            ],
                          )
                        : Row(
                            children: [
                              Stack(
                                children: [
                                  nearByRestaurantsImageMethod(context,snapshot),
                                  nearByRestaurantsPromotionMethod(width,snapshot),
                                ],
                              ),
                              nearByRestaurantsOtherDetailsMethod(
                                  context, height, width, device,snapshot),
                            ],
                          )),
      ),
    );
  }

  Container nearByRestaurantsOtherDetailsMethod(BuildContext context,
      double height, double width, String device, QueryDocumentSnapshot<Map<String, dynamic>> snapshot,) {
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "${snapshot.get("name")}",
                      style: TextStyle(
                          fontSize: 14,
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                    ),
                    Text(" 3.2 KM",
                        style: TextStyle(fontSize: 12, color: Colors.white))
                  ],
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
                    "${snapshot.get("address")}",
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
                  /*child: Container(
                    width: device == "mobile" ? width * 0.46 : null,
                    child: Text(
                      "Healthy food, Lebanese, Sandwhiches, Pasta",
                      style: TextStyle(
                          fontSize: 12,
                          color: Color(0xFFBA780F),
                          fontStyle: FontStyle.italic),
                    ),
                  ),*/
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
                        "  Live Tracking  ",
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        "${snapshot.get("livetracking")}",
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
                      otherDetailsMethod(
                          height,
                          width,
                          "Deal Time",
                          "${snapshot.get("preparationtime")} Min",
                          device),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5.0),
                        child: otherDetailsMethod(height, width, "Delivery Fee",
                            "${snapshot.get("delivery")}", device),
                      ),
                      otherDetailsMethod(
                          height,
                          width,
                          "Min Order",
                          "${snapshot.get("minimumorderprice")} AED",
                          device)
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
    double width,
      QueryDocumentSnapshot<Map<String, dynamic>> snapshot,
  ) {
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
    BuildContext context,
      QueryDocumentSnapshot<Map<String, dynamic>> snapshot,
  ) {
    return Container(
      height: 180.0,
      width: MediaQuery.of(context).size.width / 2.5,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Color(0xFFBA780F)),
        image: DecorationImage(
          image: NetworkImage(
              /*doc['coverimage'] == null ? "" : doc['coverimage'] "https://st.depositphotos.com/1005682/2476/i/600/depositphotos_24762569-stock-photo-fast-food-hamburger-hot-dog.jpg"*/ "${snapshot.get("coverimage")}"),
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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getyo();
    getname();
    Future.delayed(Duration(seconds: 1), () {
      setState(() {
        _isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return SafeArea(
        child: Scaffold(
      key: _scaffoldState,
      drawer: new DeoNavigationDrawer(widget.uid),
      backgroundColor: Color(0xFF000000),
      body: (_isLoading == true)
          ? Center(child: CircularProgressIndicator())
          : Stack(
              fit: StackFit.expand,
              children: <Widget>[
                ResponsiveWidget(
                    mobile: buildColumnContent(
                      context,
                      "mobile",
                      14,
                      350.0,
                      70,
                      height,
                      width,
                    ),
                    tab: buildColumnContent(
                      context,
                      "tab",
                      16,
                      800.0,
                      100,
                      height,
                      width,
                    ),
                    desktop: buildColumnContent(
                      context,
                      "desktop",
                      16,
                      800.0,
                      100,
                      height,
                      width,
                    )),
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
    BuildContext context,
    String tex,
    double fontshize,
    double columntextwidth,
    double headergap,
    double height,
    double width,
  ) {
    return Column(
      children: [
        SizedBox(
          height: headergap,
        ),
        Expanded(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              (tex == "desktop") ? SideLayout() : Container(),
              Expanded(
                child: Container(
                  margin: EdgeInsets.only(top: 10.0),
                  child: Column(
                    children: [
                      //row for button and booking car heading
                      Container(
                        margin: EdgeInsets.only(top: 10.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Align(
                              alignment: Alignment.topLeft,
                              child: Padding(
                                padding: const EdgeInsets.only(left: 14.0),
                                child: Text(
                                  "Delivery > Food (${totaladded.toString()})  $tex",
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(right: 18.0),
                              child: Align(
                                alignment: Alignment.topRight,
                                child: MaterialButton(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10.0)),
                                      side:
                                          BorderSide(color: Color(0xFFdb9e1f))),
                                  elevation: 5.0,
                                  height: 40,
                                  onPressed: () {
                                    Navigator.of(context).push(MaterialPageRoute(
                                        builder: (context) =>
                                            // TaskCardWidget(id: user.id, name: user.ingredients,)
                                            AddRestaurantDetails(widget.uid)));
                                  },
                                  child: Text(
                                    "+ Add new",
                                    style: TextStyle(
                                      fontSize: 20,
                                      color: Color(0xFFdb9e1f),
                                    ),
                                  ),
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: SingleChildScrollView(
                          scrollDirection: Axis.vertical,
                          child: Wrap(
                            direction: Axis.horizontal,
                            spacing: 10.0,
                            runSpacing: 10.0,
                            children: newbuilder(
                                fontshize, columntextwidth, tex, height, width),
                          ),
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
    );
  }
}
