import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:worldsgate/screens/user/booking/apartments/userapartmentbooking.dart';
import 'package:worldsgate/screens/user/booking/cars/usercarbooking.dart';
import 'package:worldsgate/screens/user/booking/yacht/useryachtlisting.dart';
import 'package:worldsgate/screens/user/userhomepage.dart';
import 'package:worldsgate/screens/user/booking/hotels/userhotelbooking.dart';

import '../screens/loginpage.dart';

import 'package:firebase_auth/firebase_auth.dart' as u;

class UserNavigationDrawer extends StatelessWidget {
  //const UserNavigationDrawer({Key? key}) : super(key: key);

  String? uid;
  String? city;

  // //constructor
  UserNavigationDrawer(
      this.uid,
      this.city
      );

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,

          children: <Widget>[
            buildHeader(context),
            buildMenuItems(context),

          ],
        ),
      ),
    );


  }
  Widget buildHeader(BuildContext context) => Container(
    padding: EdgeInsets.only(
      top: MediaQuery.of(context).padding.top
    ),
  );
  Widget buildMenuItems(BuildContext context) => Container(
    padding: const EdgeInsets.all(24),
    child: Wrap(
      runSpacing: 16,
      children: [
        ListTile(
          leading: const Icon(Icons.home_outlined),
          title: const Text('Home'),
          onTap: (){
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => UserHomePage(uid, city!),
            ));

          },
        ),
        Text(
          "Booking",
          style: TextStyle(color: Colors.white),
        ),
        ListTile(
          leading: const Icon(Icons.home_outlined),
          title: const Text('Hotel Booking'),
          onTap: (){

            Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => UserHotelBooking(uid, city!),
            ));

          },
        ),
        ListTile(
          leading: const Icon(Icons.home_outlined),
          title: const Text('Apartment Booking'),
          onTap: (){

            Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => UserApartmentBooking(uid, city!),
            ));

          },
        ),
        ListTile(
          leading: const Icon(Icons.home_outlined),
          title: const Text('Cars'),
          onTap: (){
            Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => UserCarBooking(uid, city!),
            ));

          },
        ),
        ListTile(
          leading: const Icon(Icons.home_outlined),
          title: const Text('Yacht'),
          onTap: (){
            Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => UserYachtListing(uid, city!),
            ));

          },
        ),
        Text(
          "Logout",
          style: TextStyle(color: Colors.white),
        ),
        ListTile(
          leading: const Icon(Icons.logout),
          title: const Text(
            'Logout',
            style: TextStyle(color: Colors.white),
          ),
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => LoginPage(),
            ));
            logout(context);
          },
        ),
      ],
    ),
  );

  //logout function
  Future<void> logout(BuildContext context) async {
    CircularProgressIndicator();
    await u.FirebaseAuth.instance.signOut();
    print("Signed out Successfully");

    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => LoginPage(),
      ),
    );
  }
}
