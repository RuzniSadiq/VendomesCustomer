import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutterfire_ui/firestore.dart';
import 'package:worldsgate/helper/extended_responsive_helper.dart';
import 'package:worldsgate/screens/user/booking/yacht/userviewyachtdetails.dart';
import 'package:worldsgate/widgets/cusheader.dart';
import 'package:worldsgate/widgets/usernavigationdrawer.dart';

class UserYachtListing extends StatefulWidget {
  // const UserYachtListing({ Key? key }) : super(key: key);
  String? uid;

  String? city;

  UserYachtListing(this.uid, this.city);

  @override
  State<UserYachtListing> createState() => _UserYachtListingState();
}

class _UserYachtListingState extends State<UserYachtListing> {
  bool _isLoading = true;

  var _scaffoldState = new GlobalKey<ScaffoldState>();
  String? datecreated;
  String? yachtname;

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



  List<Widget> newbuilder(double fontsize, double columntextwidth, String tex) {
    List<Widget> m = [];



        m.add(
          FirestoreQueryBuilder<Map<String, dynamic>>(

              query: FirebaseFirestore.instance
                  .collection('booking')
                  .doc("aGAm7T71ShOqGUhYphfc")
                  .collection('yachts'),
              //reduce the height
              pageSize: 2,
              // loadingBuilder: (context) =>
              //     Center(child: CircularProgressIndicator()),
              //errorBuilder: (context, error, stackTrace) => MyCustomError(error, stackTrace),

              builder: (context, snapshot, _) {
              return Container(
                height: 800,
                child: GridView.builder(
                    physics: ScrollPhysics(),
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
                            child: yachtContainer(snapshot.docs[index], context, tex, fontsize),
                          );

                        }

                  }
                ),
              );
            }
          ),
        );


    return m;
  }

  InkWell yachtContainer(QueryDocumentSnapshot<Map<String, dynamic>> snapshot, BuildContext context, String tex, double fontsize) {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) =>
                UserViewYachtDetails(widget.uid, snapshot.get("yachtid"), widget.city)));
      },
      child: Container(

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
                      Color(0xFFf2f2f2).withOpacity(0.3),
                      Color(0xFFb3b3b3).withOpacity(0.9)
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
                        style: TextStyle(color: Colors.white, fontSize: 16.0),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 14.0, bottom: 5.0),
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        "${snapshot.get("build")}",
                        style: TextStyle(color: Colors.white, fontSize: 16.0),
                      ),
                    ),
                  ),
                  Expanded(
                    child:
                    AspectRatio(
                      aspectRatio: 16/10,
                      child: Container(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(left: 14.0, ),
                                  child: Align(
                                    alignment: Alignment.bottomLeft,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        Text(
                                          "AED",
                                          style: TextStyle(
                                              color: Colors.white, fontSize: fontsize),
                                        ),
                                        Text(
                                          "  ${snapshot.get("perhourprice").toString()}",
                                          style: TextStyle(
                                              color: Colors.black87, fontSize:fontsize),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 14.0, ),
                                  child: Align(
                                    alignment: Alignment.bottomLeft,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        Text(
                                          "AED",
                                          style: TextStyle(
                                              color: Colors.white, fontSize: fontsize),
                                        ),
                                        Text(
                                          "  ${snapshot.get("dailyprice").toString()}",
                                          style: TextStyle(
                                              color: Colors.black87, fontSize: fontsize),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(left: 14.0, bottom: 15.0),
                                  child: Align(
                                    alignment: Alignment.bottomLeft,
                                    child: Text(
                                      "Per Hour Price",
                                      style: TextStyle(
                                          color: Colors.black87, fontSize: 14.0),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 14.0, bottom: 15.0),
                                  child: Align(
                                    alignment: Alignment.bottomLeft,
                                    child: Text(
                                      "Daily Price",
                                      style: TextStyle(
                                          color: Colors.black87, fontSize: 14.0),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

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
                        width: 150.0,
                        margin: EdgeInsets.only(
                            top: MediaQuery.of(context).size.height * 0.1,
                            bottom: 7.0),
                        decoration: BoxDecoration(
                          border: Border(
                            left: BorderSide(width: 1.0, color: Colors.black),
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(right: 14.0, bottom: 5.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                "Capacity - ${snapshot.get("capacity")}",
                                style: TextStyle(
                                    color: Colors.black87,
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.w600),
                              ),
                              Text(
                                "Length - ${snapshot.get("length").toString()} ft",
                                style: TextStyle(
                                    color: Colors.black87,
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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getname();

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

      // appBar: AppBar(
      //   backgroundColor: Colors. transparent,
      //   elevation: 0.0,
      //   iconTheme: IconThemeData(color: Color(0xFFdb9e1f)),
      // ),

      //endDrawer: new DeoNavigationDrawer(),

      drawer: new UserNavigationDrawer(widget.uid, widget.city),

      backgroundColor: Color(0xFF000000),
      body: (_isLoading == true)
          ? Center(child: CircularProgressIndicator())
          : Stack(
              fit: StackFit.expand,
              children: <Widget>[
                SingleChildScrollView(
                  child: ExtendedResponsiveWidget(
                      mobile: buildColumnContent(context, "mobile", 14, 350.0, 70),
                      tab: buildColumnContent(context, "tab", 16, 800.0, 100),
                      tabextended: buildColumnContent(context, "tabextended", 16, 800.0, 120),
                      desktop: buildColumnContent(context, "desktop", 16, 800.0, 120)),
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
      BuildContext context, String tex, double fontshize, double columntextwidth, double headergap) {
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
                "Yacht Booking",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),

        Column(
          children: newbuilder(fontshize, columntextwidth, tex),
        ),


      ],
    );
  }
}
