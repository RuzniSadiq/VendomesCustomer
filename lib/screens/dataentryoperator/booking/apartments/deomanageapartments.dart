import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:supercharged/supercharged.dart';
import 'package:worldsgate/helper/responsive_helper.dart';
import 'package:worldsgate/widgets/deonavigationdrawer.dart';
import 'package:worldsgate/widgets/header.dart';
import 'package:intl/intl.dart';
import '../../../../widgets/deonavigationdrawer.dart';
import '../../../../widgets/header.dart';
import '../../../../widgets/sidelayout.dart';
import 'deoaddapartmentdetails.dart';
import 'deoviewapartments.dart';

class DeoManageApartments extends StatefulWidget {
  //const DeoManageApartments({Key? key}) : super(key: key);

  String? uid;

  // //constructor
  DeoManageApartments(
    this.uid,
  );

  @override
  _DeoManageApartmentsState createState() => _DeoManageApartmentsState();
}

class _DeoManageApartmentsState extends State<DeoManageApartments> {
  bool _isLoading = true;

  var _scaffoldState = new GlobalKey<ScaffoldState>();
  String? datecreated;
  String? apartmentname;

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
        .collection('apartments')
        .where('dataentryuid', isEqualTo: widget.uid)
        .get()
        .then((myDocuments) {
      print("${myDocuments.docs.length}");
      totaladded = myDocuments.docs.length;
    });
    await FirebaseFirestore.instance
        .collection('apartments')
        .where('dataentryuid', isEqualTo: widget.uid)
        .get()
        .then((QuerySnapshot querySnapshot) => {
              querySnapshot.docs.forEach((doc) {
                DateTime dt = (doc['datecreated'] as Timestamp).toDate();
                String formattedDate = DateFormat('yyyy/MM/dd').format(dt);

                if(querySnapshot.docs.contains("price")) {
                  dategroupbylist.add({
                    "apartment_id": doc.id,
                    "apartment_name": '${doc['name']}',
                    "promotion": '${doc['promotion']}',
                    "cancellationfee": '${doc['cancellationfee']}',
                    "taxandcharges": '${doc['taxandcharges']}',
                    "coverimage": '${doc['coverimage']}',
                    "price": '${doc['price']}',
                    "added_date": '${formattedDate}',
                  });
                }else{

                  dategroupbylist.add({
                    "apartment_id": doc.id,
                    "apartment_name": '${doc['name']}',
                    "promotion": '${doc['promotion']}',
                    "cancellationfee": '${doc['cancellationfee']}',
                    "taxandcharges": '${doc['taxandcharges']}',
                    "coverimage": '${doc['coverimage']}',

                    "added_date": '${formattedDate}',
                  });

                }
              })
            });

    final maps = dategroupbylist.groupBy<String, Map>(
      (item) => item['added_date'],
      valueTransform: (item) => item..remove('added_date'),
    );

    try {
      //print(maps);
      setState(() {
        newMap = maps;
        entryList = maps.entries.toList()..sort((e1, e2) => e2.key.compareTo(e1.key));
        // var sortMapByValue = Map.fromEntries(
        //     maps.entries.toList()
        //       ..sort((e1, e2) => e1.key.compareTo(e2.key)));
      });

      setState(() {
        testList = entryList[0].value[0].entries.toList();
      });

      //print(testList[0].key);
    } catch (e) {
      print(e);
    }
  }

  List<Widget> newbuilder() {
    List<Widget> m = [];

    for (int i = 0; i < entryList.length; i++) {
      //print(entryList.length);

      m.add(Container(
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
      print("Number of apartments added on a specific date : " +
          entryList[i].value.length.toString());

      for (int j = 0; j < entryList[i].value.length; j++) {
        m.add(StreamBuilder(
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            return Padding(
              padding:
                  const EdgeInsets.only(top: 16.0, left: 10.0, right: 10.0),
              child: Stack(
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => DeoViewApartments(widget.uid,
                              entryList[i].value[j]["apartment_id"].toString())));
                    },
                    child: Container(
                      height: MediaQuery.of(context).size.height / 6,
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Color(0xFFBA780F)),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(right: 10.0),
                                child: Text(
                                  "${entryList[i].value[j]["apartment_name"].toString()}",
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Icon(
                                    Icons.location_on_outlined,
                                    color: Color(0xFFBA780F),
                                    size: 15.0,
                                  ),
                                  Icon(
                                    Icons.arrow_upward_outlined,
                                    color: Color(0xFFBA780F),
                                    size: 15.0,
                                  ),
                                  Text(
                                    " 4 Km From Center",
                                    style: TextStyle(
                                      fontSize: 11,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),

                              Text(
                                "Price for 1 night 2 adults",
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Color(0xFFBA780F),
                                ),
                              ),
                              //price
                              Padding(
                                padding: const EdgeInsets.only(
                                    top: 2.0, bottom: 2.0),
                                child: Text(
                                  entryList[i].value[j]["price"]!=null ?"Price ${entryList[i].value[j]["price"]} AED": "Loading",
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.white,
                                  ),
                                ),
                              ),

                              //taxcharge
                              Text(
                                "${entryList[i].value[j]["taxandcharges"]} AED Taxes and Charges",
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.white,
                                ),
                              ),
                              //cancellation fee
                              Padding(
                                padding: const EdgeInsets.only(top: 2.0),
                                child: Text(
                                  "${entryList[i].value[j]["cancellationfee"]}% for Cancellation",
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Color(0xFFBA780F),
                                  ),
                                ),
                              ),

                              //
                              //
                              // Text("apartment name is " +
                              //     entryList[i].value[j]["apartment_name"] +
                              //     " & " +
                              //     "Promotion is " +
                              //     entryList[i].value[j]["promotion"])
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    height: MediaQuery.of(context).size.height / 6,
                    width: MediaQuery.of(context).size.width / 9,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      image: DecorationImage(
                        image:
                            NetworkImage(entryList[i].value[j]["coverimage"]),
                        fit: BoxFit.fill,
                      ),
                    ),
                    child: Stack(
                      children: [
                        Container(
                          margin: const EdgeInsets.only(top: 60.0, right: 0.0),
                          height: 80.0,
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              gradient: LinearGradient(
                                  begin: FractionalOffset.topCenter,
                                  end: FractionalOffset.bottomCenter,
                                  colors: [
                                    Colors.white70.withOpacity(0.0),
                                    Colors.orange.withOpacity(0.8),
                                  ],
                                  stops: [
                                    0.0,
                                    0.7
                                  ])),
                          child: Stack(
                            children: [
                              Align(
                                alignment: Alignment.bottomCenter,
                                child: Container(
                                  margin: const EdgeInsets.only(
                                      top: 6.0, right: 0.0),
                                  child: Column(
                                    children: [
                                      Align(
                                        alignment: Alignment.bottomCenter,
                                        child: Text(
                                          "${entryList[i].value[j]["promotion"]}% off",
                                          style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black,
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
                    ),
                  ),
                ],
              ),
            );
          },
        ));
      }
    }

    return m;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    getyo();
    getname();

    Future.delayed(Duration(seconds: 3), () {
      setState(() {
        _isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
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
                    mobile: buildColumnContent(context, 60),
                    tab: buildColumnContent(context, 90),
                    desktop: buildColumnContent(context, 100),

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

  Column buildColumnContent(BuildContext context, double headergap) {
    return Column(
                children: [
                  SizedBox(
                    height: headergap,
                  ),

                  Expanded(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SideLayout(),
                        Expanded(
                          child: Container(
                            margin: EdgeInsets.only(top: 30.0),
                            child: Column(
                              children: [
                                //row for button and booking apartment heading
                                Container(

                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Align(
                                        alignment: Alignment.topLeft,
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                              left: 14.0),
                                          child: Text(
                                            "Booking > Apartment (${totaladded.toString()})",
                                            style: TextStyle(
                                              fontSize: 16,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            right: 18.0),
                                        child: Align(
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
                                            height: 40,
                                            onPressed: () {
                                              Navigator.of(context).push(
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          // TaskCardWidget(id: user.id, name: user.ingredients,)
                                                          AddApartmentDetails(
                                                              widget.uid)));
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
                                    child: Column(
                                      children: newbuilder(),
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

                  // Container(
                  //   child: Column(
                  //     children: newbuilder(),
                  //   ),
                  // ),
                ],
              );
  }
}
