import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:supercharged/supercharged.dart';
import 'package:worldsgate/helper/responsive_helper.dart';
import 'package:worldsgate/screens/dataentryoperator/delivery/restaurants/deoaddrestaurantdetails.dart';
import 'package:worldsgate/widgets/deonavigationdrawer.dart';
import 'package:worldsgate/widgets/header.dart';
import 'package:intl/intl.dart';
import 'package:worldsgate/widgets/sidelayout.dart';

class DeoManageFood extends StatefulWidget {
  //const DeoManageFood({Key? key}) : super(key: key);

  String? uid;
  String? restaurantid;

  DeoManageFood(this.uid, this.restaurantid);

  @override
  State<DeoManageFood> createState() => _DeoManageFoodState();
}

class _DeoManageFoodState extends State<DeoManageFood> {
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
        .doc(widget.restaurantid)
        .collection('foodcategory')
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
        .doc(widget.restaurantid)
        .collection('foodcategory')
        .where('dataentryuid', isEqualTo: widget.uid)
        .get()
        .then((QuerySnapshot querySnapshot) => {
              querySnapshot.docs.forEach((doc) {
                DateTime dt = (doc['datecreated'] as Timestamp).toDate();
                String formattedDate = DateFormat('yyyy/MM/dd').format(dt);
                dategroupbylist.add({
                  "foodcategoryid": doc.id,
                  "coverimage": '${doc['coverimage']}',
                  "name": '${doc['name']}',
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
      print("Number of cars added on a specific date : " +
          entryList[i].value.length.toString());

      for (int j = 0; j < entryList[i].value.length; j++) {
        print(entryList[i].value[j]["distance"]);
        print(entryList[i].value[j]["price"]);
        m.add(
          Padding(
              padding: const EdgeInsets.all(8.0),
              child: foodCatergoriesDetails(i, j, context, tex, width, height)),
        );
      }
    }

    return m;
  }

  Padding foodCatergoriesDetails(int i, int j, BuildContext context,
      String device, double width, double height) {
    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: device == "mobile"
              ? width * 0.02
              : device == "tab"
                  ? width * 0.02
                  : device == "desktop"
                      ? width * 0.05
                      : width * 0),
      child: Container(
        width: device == "mobile"
            ? width * 0.96
            : device == "tab"
                ? width * 0.96
                : device == "desktop"
                    ? width * 0.24
                    : width * 0.24,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: width * 0.215,
                  height: height * 0.05,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "${entryList[i].value[j]["name"]}",
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
                Icon(Icons.arrow_drop_up)
              ],
            ),
            SizedBox(
              height: height * 0.01,
            ),
            StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('delivery')
                    .doc("9WRNvPkoftSw4o2rHGUI")
                    .collection('restaurants')
                    .doc(widget.restaurantid)
                    .collection('foodcategory')
                    .doc(entryList[i].value[j]["foodcategoryid"])
                    .collection('food')
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  } else {
                    return Wrap(
                      direction: Axis.horizontal,
                      children: snapshot.data!.docs.map((doc) {
                        return ListTile(
                          leading: Container(
                            height: 50,
                            width: 50,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image:
                                    NetworkImage(doc['coverimage'].toString()),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          title: Text("${doc['name']}"),
                          subtitle: Text("${doc['description']}"),
                          trailing: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("AED ${doc['price']}"),
                              Icon(Icons.add_circle),
                            ],
                          ),
                        );
                      }).toList(),
                    );
                  }
                }),
          ],
        ),
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
                                  "Delivery > Food Category (${totaladded.toString()}) & Food () $tex",
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
