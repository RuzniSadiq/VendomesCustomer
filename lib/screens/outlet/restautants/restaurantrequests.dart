import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:worldsgate/helper/responsive_helper.dart';
import 'package:worldsgate/widgets/drivernavigationdrawer.dart';
import '../../../../widgets/header.dart';

class RestaurantRequests extends StatefulWidget {
  String? uid;

  RestaurantRequests(this.uid);

  @override
  State<RestaurantRequests> createState() => _RestaurantRequestsState();
}

class _RestaurantRequestsState extends State<RestaurantRequests> {
  var _scaffoldState = new GlobalKey<ScaffoldState>();

  bool _isLoading = true;
  var entryList;
  var orderid;

  String? cusname;
  String? role;
  String? customerid;
  String? customername;
  String? customercontactnumber;
  String? customeremail;

  double? restaurantlat;
  double? restaurantlong;

  String? restaurantid;
  String? restaurantname;




  getname() async {
    FirebaseFirestore.instance
        .collection('users')
        .doc(widget.uid)
        .get()
        .then((myDocuments) {
      cusname = myDocuments.data()!['name'].toString();
      role = myDocuments.data()!['role'].toString();
      restaurantid = myDocuments.data()!['restaurantid'].toString();
      FirebaseFirestore.instance
          .collection('delivery')
          .doc("9WRNvPkoftSw4o2rHGUI")
          .collection('restaurants')
          .doc(restaurantid)
          .get()
          .then((datarestaurant) {
        restaurantlat = datarestaurant.data()!['restaurantlat'].toDouble();
        restaurantlong = datarestaurant.data()!['restaurantlong'].toDouble();
        restaurantname = datarestaurant.data()!['name'].toString();
      });
    });
  }

  @override
  void initState() {
    super.initState();
    getname();
    _requestPermission();
    Future.delayed(Duration(seconds: 1), () {
      setState(() {
        _isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        key: _scaffoldState,
        drawer: new DriverNavigationDrawer(widget.uid),
        backgroundColor: Color(0xFF000000),
        body: (_isLoading == true)
            ? Center(child: CircularProgressIndicator())
            : Stack(
                children: [
                  SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: ResponsiveWidget(
                      mobile:
                          RestaurantRequestsContainer(context, "mobile", 70),
                      tab: RestaurantRequestsContainer(context, "tab", 125),
                      desktop:
                          RestaurantRequestsContainer(context, "desktop", 125),
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
      ),
    );
  }

  Container RestaurantRequestsContainer(
      BuildContext context, String device, double headergap) {
    return Container(
      width: double.infinity,
      child: Column(
        children: [
          SizedBox(height: headergap,),
          StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('delivery')
                  .doc("9WRNvPkoftSw4o2rHGUI")
                  .collection('orders')
                  .where('outletid', isEqualTo: restaurantid)
                  .where('orderaccepted', isEqualTo: false)
                  .where('ordercancelled', isEqualTo: false)
                  .snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }
              return SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Theme(
                  data: Theme.of(context).copyWith(dividerColor: Color(0xFFBA780F)),
                  child: DataTable(
                    dividerThickness: 3.0,

                      dataRowHeight: 100,
                    columns: const <DataColumn>[
                      DataColumn(
                        label: Text(
                          'Order Information',
                          style: TextStyle(fontStyle: FontStyle.italic),
                        ),
                      ),
                      DataColumn(
                        label:  Text(
                          'Customer Information',
                          style: TextStyle(fontStyle: FontStyle.italic),
                        ),
                      ),
                      DataColumn(
                        label:  Text(
                          'Customer Paid Amount',
                          style: TextStyle(fontStyle: FontStyle.italic),
                        ),
                      ),
                      DataColumn(
                        label:  Text(
                          'Status',
                          style: TextStyle(fontStyle: FontStyle.italic),
                        ),
                      ),
                      DataColumn(
                        label:  Text(
                          'Action',
                          style: TextStyle(fontStyle: FontStyle.italic),
                        ),
                      ),
                    ],
                    rows: _createRows(snapshot.data!)
                  ),
                ),
              );
            }
          ),
        ],
      ),
    );
  }



  List<DataRow> _createRows(QuerySnapshot snapshot) {

    List<DataRow> newList = snapshot.docs.map((DocumentSnapshot documentSnapshot) {
      return DataRow(cells: [

        DataCell(Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(

            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("ID: ${documentSnapshot.get("orderid").toString()}"),
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Wrap(children: newbuilder(documentSnapshot.get("orderdetails"))),
              ),
            ],
          ),
        )),

        DataCell(StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
            stream: FirebaseFirestore.instance.collection('users').where('uid', isEqualTo: documentSnapshot.get("customerid").toString()
            ).snapshots(),
            builder: (_, snapshot) {
              if (snapshot.hasError) return Text('Error = ${snapshot.error}');
      if (snapshot.hasData) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(snapshot.data!.docs[0]["name"],),
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(snapshot.data!.docs[0]["email"],),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(snapshot.data!.docs[0]["contactnumber"],),
              ),
            ],
          ),
        );

      }
              return Center(child: CircularProgressIndicator());

          }
        )),
        DataCell(Text("${documentSnapshot.get("totalamount").toString()} AED"),),
        DataCell(Text(
            documentSnapshot.get("orderaccepted") == false ? "Order Received" : "Loading"

        )),
        DataCell(Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(5.0)),
                child: MaterialButton(child:
                Text(
                  "Confirm",
                  style: TextStyle(
                      color: Colors.black,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                color: Color(0xFF00ff00),
                onPressed: (){
                  FirebaseFirestore.instance
                      .collection('delivery')
                      .doc("9WRNvPkoftSw4o2rHGUI")
                      .collection('orders')
                      .doc(documentSnapshot.get("orderid"))
                  //update method
                      .update({
                    //add the user id inside the favourites array
                    "orderaccepted": true
                  });

                },
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(5.0)),
                child: MaterialButton(child:
                Text(
                  "Cancel",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                  color: Colors.red,
                  onPressed: (){
                    FirebaseFirestore.instance
                        .collection('delivery')
                        .doc("9WRNvPkoftSw4o2rHGUI")
                        .collection('orders')
                        .doc(documentSnapshot.get("orderid"))
                    //update method
                        .update({
                      //add the user id inside the favourites array
                      "ordercancelled": true
                    });

                  },
                ),
              ),
            )
          ],
        )),

      ]);
    }).toList();

    return newList;
  }

  List<Widget> newbuilder(List<dynamic> x) {
    List<Widget> m = [];

    entryList = x;

    m.add(Text("Item: "));

    for (int i = 0; i < entryList.length; i++) {
      //print(entryList.length);

      m.add(Text(
        "(${entryList[i]["quantity"]}) ${entryList[i]["foodname"]}, ",
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      ));
    }

    return m;
  }




  List<Widget> newbuildder(String customerid) {
    List<Widget> m = [];

    m.add(Container(
      height: 200.0,
      child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: FirebaseFirestore.instance.collection('users').where('uid', isEqualTo: customerid
        ).snapshots(),
        builder: (_, snapshot) {
          if (snapshot.hasError) return Text('Error = ${snapshot.error}');

          if (snapshot.hasData) {
            final docs = snapshot.data!.docs;
            return ListView.builder(
              shrinkWrap: true,
              itemCount: docs.length,
              itemBuilder: (_, i) {
                final data = docs[i].data();
                return Text(data['name'], style: TextStyle(color: Colors.blue),);
              },
            );
          }

          return Center(child: CircularProgressIndicator());
        },
      ),
    ));
    return m;


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
}
