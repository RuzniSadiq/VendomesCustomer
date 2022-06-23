import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:worldsgate/screens/user/booking/apartments/userapartmentbooking.dart';
import 'package:worldsgate/screens/user/booking/hotels/userhotelbooking.dart';
import 'package:worldsgate/screens/user/delivery/pharmacy/userpharmacyorder.dart';
import 'package:worldsgate/screens/user/delivery/restaurants/userrestaurantorder.dart';
import 'package:worldsgate/screens/user/delivery/supermarkets/usersupermarketorder.dart';
import 'package:worldsgate/widgets/header.dart';
import 'package:worldsgate/widgets/usernavigationdrawer.dart';

import '../../helper/responsive_helper.dart';
import '../../widgets/cusheader.dart';
import 'booking/cars/usercarbooking.dart';
import 'booking/yacht/useryachtlisting.dart';

class UserHomePage extends StatefulWidget {
  //const UserHomePage({Key? key}) : super(key: key);

  String? uid;
  String city;

  //constructor
  UserHomePage(this.uid, this.city);

  @override
  _UserHomePageState createState() => _UserHomePageState();
}

class _UserHomePageState extends State<UserHomePage> {
  var _scaffoldState = new GlobalKey<ScaffoldState>();
  CarouselController _carouselController = CarouselController();

  //List<String> imageURLs = ["assets/images/promo/promo1.jpeg", "http://cdn.srilanka-promotions.com/wp-content/uploads/2012/12/Fashion-Bug-21-Dec-2012.jpg", "https://www.swaart.com/wp-content/uploads/2021/01/Swaart-Main.jpg"];

  List imageList = [
    'assets/images/promo/promo1.jpeg',
    'assets/images/promo/promo2.jpeg',
    'assets/images/promo/promo3.jpeg',
  ];

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
    //final double height = MediaQuery.of(context).size.height;

    return SafeArea(
        child: Scaffold(
      key: _scaffoldState,

      // appBar: AppBar(
      //   backgroundColor: Colors.transparent,
      //   elevation: 0.0,
      //   iconTheme: IconThemeData(color: Color(0xFFdb9e1f)),
      // ),

      drawer: new UserNavigationDrawer(widget.uid, widget.city),

      backgroundColor: Color(0xFF000000),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: ResponsiveWidget(
              mobile: buildColumnContent(context, "mobile", 130, 115, 65),
              tab: buildColumnContent(context, "tab", 120, 120, 50),
              desktop: buildColumnContent(context, "desktop", 180, 180, 100),
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

  Column buildColumnContent(BuildContext context, String tex, double wi,
      double heig, double imagewi) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin:
              EdgeInsets.only(top: MediaQuery.of(context).size.height / 7.95),
          child: CarouselSlider(
            items: imageList
                .map((imageList) => Container(
                      width: double.infinity,
                      child: Center(
                          child: Image(
                        image: AssetImage(imageList),
                        fit: BoxFit.cover,
                        width: double.infinity,
                        height: 300.0,
                      )),
                    ))
                .toList(),
            carouselController: _carouselController,
            options: CarouselOptions(
              autoPlay: true,
              aspectRatio: 16 / 9,
              enlargeCenterPage: true,
              height: 200.0,
              viewportFraction: 1.0,
            ),
          ),
        ),
        Center(
          child: Container(
            margin: EdgeInsets.only(top: 20),
            child: Text(
              "What would you like?",
              style: TextStyle(
                foreground: Paint()
                  ..shader = LinearGradient(
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
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
                fontFamily: 'crimson',
              ),
            ),
          ),
        ),
        Center(
          child: Container(
            margin: EdgeInsets.only(
                top: MediaQuery.of(context).size.height / 90.95),
            child: Text(
              " $cusname?",
              style: TextStyle(color: Colors.white, fontSize: 20.0),
            ),
          ),
        ),

        /*Center(
          child: Container(
            margin: EdgeInsets.only(
                top: MediaQuery.of(context).size.height / 20.95, bottom: 20.0),
            child: Text(
              "Explore",
              style: TextStyle(color: Colors.white, fontSize: 16.0),
            ),
          ),
        ),*/
        Align(
          alignment: Alignment.topLeft,
          child: Padding(
            padding: const EdgeInsets.only(left: 14.0, top: 20.0),
            child: Text(
              "Booking",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ), //Booking
        Container(
          height: 180.0,
          child: ListView(
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            primary: false,
            children: <Widget>[
              //Image.network('https://cdn.pixabay.com/photo/2015/04/23/22/00/tree-736885__480.jpg', height: 30.0, ),
              //hotel
              Padding(
                padding:
                    const EdgeInsets.only(top: 16.0, left: 10.0, right: 0.0),
                child: Align(
                  alignment: Alignment.topLeft,
                  child: InkWell(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) =>
                              // TaskCardWidget(id: user.id, name: user.ingredients,)
                              UserHotelBooking(widget.uid, widget.city)));
                    },
                    child: containerMethod(heig, wi, imagewi,
                        "assets/images/homepageicons/Hotel.png", "Hotels"),
                  ),
                ),
              ),
              //apartment
              Padding(
                padding:
                    const EdgeInsets.only(top: 16.0, left: 10.0, right: 0.0),
                child: Align(
                  alignment: Alignment.topLeft,
                  child: InkWell(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) =>
                          // TaskCardWidget(id: user.id, name: user.ingredients,)
                          UserApartmentBooking(widget.uid, widget.city


                          )));
                    },
                    child: containerMethod(
                        heig,
                        wi,
                        imagewi,
                        "assets/images/homepageicons/Appartment.png",
                        "Apartments"),
                  ),
                ),
              ),
              //cars
              Padding(
                padding:
                    const EdgeInsets.only(top: 16.0, left: 10.0, right: 0.0),
                child: Align(
                  alignment: Alignment.topLeft,
                  child: InkWell(
                    onTap: () {
                      // Navigator.of(context).push(MaterialPageRoute(
                      //     builder: (context) =>
                      //     // TaskCardWidget(id: user.id, name: user.ingredients,)
                      //     UserHotelBooking(
                      //
                      //
                      //     )));
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) =>
                            UserCarBooking(widget.uid, widget.city),
                      ));
                    },
                    child: containerMethod(heig, wi, imagewi,
                        "assets/images/homepageicons/Car.png", "Cars"),
                  ),
                ),
              ),
              //yacht
              Padding(
                padding:
                    const EdgeInsets.only(top: 16.0, left: 10.0, right: 0.0),
                child: Align(
                  alignment: Alignment.topLeft,
                  child: InkWell(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) =>
                              // TaskCardWidget(id: user.id, name: user.ingredients,)
                              UserYachtListing(widget.uid, widget.city)));
                    },
                    child: containerMethod(heig, wi, imagewi,
                        "assets/images/homepageicons/Yacht.png", "Yacht"),
                  ),
                ),
              ),
              //restaurant
              Padding(
                padding:
                    const EdgeInsets.only(top: 16.0, left: 10.0, right: 0.0),
                child: Align(
                  alignment: Alignment.topLeft,
                  child: InkWell(
                    onTap: () {
                      // Navigator.of(context).push(MaterialPageRoute(
                      //     builder: (context) =>
                      //     // TaskCardWidget(id: user.id, name: user.ingredients,)
                      //     UserHotelBooking(
                      //
                      //
                      //     )));
                    },
                    child: containerMethod(
                        heig,
                        wi,
                        imagewi,
                        "assets/images/homepageicons/restaurant.png",
                        "Restaurants"),
                  ),
                ),
              ),
              //bar
              Padding(
                padding:
                    const EdgeInsets.only(top: 16.0, left: 10.0, right: 0.0),
                child: Align(
                  alignment: Alignment.topLeft,
                  child: InkWell(
                    onTap: () {
                      // Navigator.of(context).push(MaterialPageRoute(
                      //     builder: (context) =>
                      //     // TaskCardWidget(id: user.id, name: user.ingredients,)
                      //     UserHotelBooking(
                      //
                      //
                      //     )));
                    },
                    child: containerMethod(heig, wi, imagewi,
                        "assets/images/homepageicons/Bar.png", "Bars"),
                  ),
                ),
              ),
            ],
          ),
        ),
        Align(
          alignment: Alignment.topLeft,
          child: Padding(
            padding: const EdgeInsets.only(left: 14.0),
            child: Text(
              "Fly",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ), //Flight
        Container(
          height: 180.0,
          child: ListView(
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            primary: false,
            children: <Widget>[
              //electronics
              Padding(
                padding:
                    const EdgeInsets.only(top: 16.0, left: 10.0, right: 0.0),
                child: Align(
                  alignment: Alignment.topLeft,
                  child: InkWell(
                      onTap: () {
                        // Navigator.of(context).push(MaterialPageRoute(
                        //     builder: (context) =>
                        //     // TaskCardWidget(id: user.id, name: user.ingredients,)
                        //     UserHotelBooking(
                        //
                        //
                        //     )));
                      },
                      child: containerMethod(
                          heig,
                          wi,
                          imagewi,
                          "assets/images/homepageicons/Flight_Ticket.png",
                          "Flights")),
                ),
              ),
              //clothes
              Padding(
                padding:
                    const EdgeInsets.only(top: 16.0, left: 10.0, right: 0.0),
                child: Align(
                  alignment: Alignment.topLeft,
                  child: InkWell(
                      onTap: () {
                        // Navigator.of(context).push(MaterialPageRoute(
                        //     builder: (context) =>
                        //     // TaskCardWidget(id: user.id, name: user.ingredients,)
                        //     UserHotelBooking(
                        //
                        //
                        //     )));
                      },
                      child: containerMethod(
                          heig,
                          wi,
                          imagewi,
                          "assets/images/homepageicons/Private _Jet1.png",
                          "Private Jet")),
                ),
              ),
              //cosmetics
              Padding(
                padding:
                    const EdgeInsets.only(top: 16.0, left: 10.0, right: 0.0),
                child: Align(
                  alignment: Alignment.topLeft,
                  child: InkWell(
                      onTap: () {
                        // Navigator.of(context).push(MaterialPageRoute(
                        //     builder: (context) =>
                        //     // TaskCardWidget(id: user.id, name: user.ingredients,)
                        //     UserHotelBooking(
                        //
                        //
                        //     )));
                      },
                      child: containerMethod(
                          heig,
                          wi,
                          imagewi,
                          "assets/images/homepageicons/Helicopter.png",
                          "Helicopter")),
                ),
              ),
            ],
          ),
        ),
        Align(
          alignment: Alignment.topLeft,
          child: Padding(
            padding: const EdgeInsets.only(left: 14.0),
            child: Text(
              "Delivery",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ), //Delivery
        Container(
          height: 180.0,
          child: ListView(
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            primary: false,
            children: <Widget>[
              //Food
              Padding(
                padding:
                    const EdgeInsets.only(top: 16.0, left: 10.0, right: 0.0),
                child: Align(
                  alignment: Alignment.topLeft,
                  child: InkWell(
                      onTap: () {
                        // Navigator.of(context).push(MaterialPageRoute(
                        //     builder: (context) =>
                        //     // TaskCardWidget(id: user.id, name: user.ingredients,)
                        //     UserHotelBooking(
                        //
                        //
                        //     )));
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) =>
                                // TaskCardWidget(id: user.id, name: user.ingredients,)
                                UserOrderFood(widget.uid, widget.city)));
                      },
                      child: containerMethod(heig, wi, imagewi,
                          "assets/images/homepageicons/Food.png", "Foods")),
                ),
              ),
              //Groceries
              Padding(
                padding:
                    const EdgeInsets.only(top: 16.0, left: 10.0, right: 0.0),
                child: Align(
                  alignment: Alignment.topLeft,
                  child: InkWell(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) =>
                                // TaskCardWidget(id: user.id, name: user.ingredients,)
                                UserSupermarketOrder(widget.uid, widget.city)));
                      },
                      child: containerMethod(
                          heig,
                          wi,
                          imagewi,
                          "assets/images/homepageicons/Grocery.png",
                          "SuperMarkets")),
                ),
              ),
              //pharmaceuticals
              Padding(
                padding:
                    const EdgeInsets.only(top: 16.0, left: 10.0, right: 0.0),
                child: Align(
                  alignment: Alignment.topLeft,
                  child: InkWell(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) =>
                                // TaskCardWidget(id: user.id, name: user.ingredients,)
                                UserPharmacyOrder(widget.uid, widget.city)));
                      },
                      child: containerMethod(
                          heig,
                          wi,
                          imagewi,
                          "assets/images/homepageicons/pharmecy.png",
                          "Pharmaceuticals")),
                ),
              ),
            ],
          ),
        ),
        Align(
          alignment: Alignment.topLeft,
          child: Padding(
            padding: const EdgeInsets.only(left: 14.0),
            child: Text(
              "Online Shopping",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ), // online Shoping
        Container(
          height: 180.0,
          child: ListView(
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            primary: false,
            children: <Widget>[
              //electronics
              Padding(
                padding:
                    const EdgeInsets.only(top: 16.0, left: 10.0, right: 0.0),
                child: Align(
                  alignment: Alignment.topLeft,
                  child: InkWell(
                      onTap: () {
                        // Navigator.of(context).push(MaterialPageRoute(
                        //     builder: (context) =>
                        //     // TaskCardWidget(id: user.id, name: user.ingredients,)
                        //     UserHotelBooking(
                        //
                        //
                        //     )));
                      },
                      child: containerMethod(
                          heig,
                          wi,
                          imagewi,
                          "assets/images/homepageicons/Electronics.png",
                          "Electronics")),
                ),
              ),
              //clothes
              Padding(
                padding:
                    const EdgeInsets.only(top: 16.0, left: 10.0, right: 0.0),
                child: Align(
                  alignment: Alignment.topLeft,
                  child: InkWell(
                      onTap: () {
                        // Navigator.of(context).push(MaterialPageRoute(
                        //     builder: (context) =>
                        //     // TaskCardWidget(id: user.id, name: user.ingredients,)
                        //     UserHotelBooking(
                        //
                        //
                        //     )));
                      },
                      child: containerMethod(heig, wi, imagewi,
                          "assets/images/homepageicons/Dress.png", "Clothes")),
                ),
              ),
              //cosmetics
              Padding(
                padding:
                    const EdgeInsets.only(top: 16.0, left: 10.0, right: 0.0),
                child: Align(
                  alignment: Alignment.topLeft,
                  child: InkWell(
                      onTap: () {
                        // Navigator.of(context).push(MaterialPageRoute(
                        //     builder: (context) =>
                        //     // TaskCardWidget(id: user.id, name: user.ingredients,)
                        //     UserHotelBooking(
                        //
                        //
                        //     )));
                      },
                      child: containerMethod(
                          heig,
                          wi,
                          imagewi,
                          "assets/images/homepageicons/Cosmetics.png",
                          "Cosmetics")),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Container containerMethod(
    double heig,
    double wi,
    double imagewi,
    String image,
    String name,
  ) {
    return Container(
      height: heig,
      width: wi,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        gradient: LinearGradient(colors: [
          Color(0xFFffd77f),
          Color(0xFFcda349),
          Color(0xFFc59c3c),
          Color(0xFF865c13),
          Color(0xFFc1983e),
          Color(0xFFc29c42),
          Color(0xFFffd77f),
        ]),
      ),
      child: Padding(
        padding: const EdgeInsets.all(1.5),
        child: Container(
          decoration: BoxDecoration(
            color: Color(0xFF000000),
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 15.0),
                child: Align(
                  alignment: Alignment.topCenter,
                  child: Image.asset(
                    image,
                    width: imagewi,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                  top: 10.0,
                ),
                child: Text(
                  name,
                  style: TextStyle(
                    foreground: Paint()
                      ..shader = LinearGradient(
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
                    //fontWeight: FontWeight.bold,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
