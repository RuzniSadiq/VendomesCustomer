import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutterfire_ui/firestore.dart';
import 'package:worldsgate/helper/extended_responsive_helper.dart';
import 'package:worldsgate/screens/user/booking/cars/userviewcardetails.dart';
import 'package:worldsgate/widgets/cusheader.dart';
import 'package:worldsgate/widgets/usernavigationdrawer.dart';

class UserCarBooking extends StatefulWidget {
  String? uid;
  String city;

  //constructor
  UserCarBooking(this.uid, this.city);

  //const UserCarBooking({Key? key}) : super(key: key);

  @override
  _UserCarBookingState createState() => _UserCarBookingState();
}

class _UserCarBookingState extends State<UserCarBooking> {
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

  @override
  Widget build(BuildContext context) {

    return SafeArea(
        child: Scaffold(
      key: _scaffoldState,
      backgroundColor: Color(0xFF000000),

      // appBar: AppBar(
      //   backgroundColor: Colors.transparent,
      //   elevation: 0.0,
      //   iconTheme: IconThemeData(color: Color(0xFFdb9e1f)),
      // ),

      drawer: new UserNavigationDrawer(widget.uid, widget.city),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: ExtendedResponsiveWidget(
              mobile: buildColumnContent(context, "mobile",  70),
              tab: buildColumnContent(context, "tab",  100),
              tabextended: buildColumnContent(context, "tabextended",  100),
              desktop:
                  buildColumnContent(context, "desktop",  120),
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

  Column buildColumnContent(
      BuildContext context, String tex, double headergap) {
    return Column(
      children: [
        SizedBox(
          height: headergap,
        ),
        Container(
          margin: const EdgeInsets.only(bottom: 5.0),
          child: Align(
            alignment: Alignment.topLeft,
            child: Padding(
              padding: const EdgeInsets.only(left: 14.0),
              child: Text(
                "Car Booking",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Align(
            alignment: Alignment.topLeft,
            child: FirestoreQueryBuilder<Map<String, dynamic>>(

                query: FirebaseFirestore.instance
                    .collection('booking')
                    .doc("aGAm7T71ShOqGUhYphfc")
                    .collection('cars'),
                //reduce the height
                pageSize: 2,
                // loadingBuilder: (context) =>
                //     Center(child: CircularProgressIndicator()),
                //errorBuilder: (context, error, stackTrace) => MyCustomError(error, stackTrace),

                builder: (context, snapshot, _) {
                  return GridView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      scrollDirection: Axis.vertical,
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
                            child: carContainer(tex, context, snapshot.docs[index]),
                          );

                        }

                      }
                  );
                          }),

          ),
        ),
      ],
    );
  }

  InkWell carContainer(String tex, BuildContext context, QueryDocumentSnapshot<Map<String, dynamic>> snapshot,
      ) {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) =>
                UserViewCarDetails(widget.uid, snapshot.get("carid"), widget.city)));
      },
      child: Container(
        constraints:
        BoxConstraints(
            maxWidth:
            (tex=="desktop" || tex=="tabextended")
                ?450.0:double.infinity
        ),
        child: AspectRatio(
          aspectRatio: 16 / 9,
          child: Stack(
            children: [
              Container(
                foregroundDecoration: BoxDecoration(
                  border: Border.all(
                    color:
                    Color(0xFFBA780F), //                   <--- border color
                  ),
                  borderRadius: BorderRadius.circular(30),
                  gradient: LinearGradient(
                    colors: [
                      Colors.black,
                      Colors.transparent,
                      Colors.transparent,
                      Color(0xff000000).withOpacity(1),
                      Color(0xff000000).withOpacity(1)
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    stops: [0, 0.4, 0.75, 0, 1],
                  ),
                ),

                decoration: BoxDecoration(
                  border: Border.all(
                    color:
                    Color(0xFFBA780F), //                   <--- border color
                  ),

                  borderRadius: BorderRadius.circular(30),
                  // border: Border.all(color: Color(0xFFBA780F)),
                  image: DecorationImage(
                      image:
                      NetworkImage('${snapshot.get("coverimage")}'),
                      fit: BoxFit.cover),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 14.0, bottom: 5.0, top: 20.0),
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        "${snapshot.get("name")}".toUpperCase(),
                        style: TextStyle(
                          foreground: Paint()..shader = LinearGradient(
                            colors: <Color>[
                              Color(0xFFffd77f),
                              Color(0xFFcda349),
                              Color(0xFFc59c3c),
                              Color(0xFF865c13),
                              Color(0xFFc1983e),
                              Color(0xFFc29c42),
                              Color(0xFFffd77f),
                              //add more color here.
                            ],
                          ).createShader(Rect.fromLTWH(0.0, 0.0, 200.0, 100.0)),
                          fontSize: 14.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 14.0, bottom: 5.0),
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        "${snapshot.get("model")}",
                        style: TextStyle(color: Colors.white, fontSize: 16.0),
                      ),
                    ),
                  ),
                  Expanded(
                    child:
                    Padding(
                      padding: const EdgeInsets.only(left: 25.0,bottom: 18 ),
                      child: Align(
                        alignment: Alignment.bottomLeft,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              "AED",
                              style: TextStyle(
                                foreground: Paint()..shader = LinearGradient(
                                  colors: <Color>[
                                    Color(0xFFffd77f),
                                    Color(0xFFcda349),
                                    Color(0xFFc59c3c),
                                    Color(0xFF865c13),
                                    Color(0xFFc1983e),
                                    Color(0xFFc29c42),
                                    Color(0xFFffd77f),
                                    //add more color here.
                                  ],
                                ).createShader(Rect.fromLTWH(0.0, 0.0, 200.0, 100.0)),
                                fontSize: 30.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              "  ${snapshot.get("price").toString()}",
                              style: TextStyle(
                                foreground: Paint()..shader = LinearGradient(
                                  colors: <Color>[
                                    Color(0xFFffd77f),
                                    Color(0xFFcda349),
                                    Color(0xFFc59c3c),
                                    Color(0xFF865c13),
                                    Color(0xFFc1983e),
                                    Color(0xFFc29c42),
                                    Color(0xFFffd77f),
                                    //add more color here.
                                  ],
                                ).createShader(Rect.fromLTWH(0.0, 0.0, 200.0, 100.0)),
                                fontSize: 30.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  /*Padding(
                    padding: const EdgeInsets.only(left: 14.0, bottom: 15.0),
                    child: Align(
                      alignment: Alignment.bottomLeft,
                      child: Text(
                        "Rent Price",
                        style: TextStyle(
                          foreground: Paint()..shader = LinearGradient(
                            colors: <Color>[
                              Color(0xFFffd77f),
                              Color(0xFFcda349),
                              Color(0xFFc59c3c),
                              Color(0xFF865c13),
                              Color(0xFFc1983e),
                              Color(0xFFc29c42),
                              Color(0xFFffd77f),
                              //add more color here.
                            ],
                          ).createShader(Rect.fromLTWH(0.0, 0.0, 200.0, 100.0)),
                          fontSize: 14.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),*/
                ],
              ),
              Align(
                alignment: Alignment.centerRight,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 4.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Container(
                        width: 200.0,
                        margin: EdgeInsets.only(
                            top: MediaQuery.of(context).size.height * 0.1,
                            left: 10, bottom: 7.0),
                        decoration: BoxDecoration(
                          border: Border(
                            left: BorderSide(width: 1.0, color: Colors.white),
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(right: 14.0, bottom: 5.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                "Delivery - ${snapshot.get("delivery")}",
                                style: TextStyle(
                                    color: Color(0xFFFFFFFF),
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.w600),
                              ),
                              Text(
                                "Included - ${snapshot.get("distance").toString()} KM",
                                style: TextStyle(
                                    color: Color(0xFFFFFFFF),
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.w600),
                              ),
                            ],
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
      ),
    );
  }
}
