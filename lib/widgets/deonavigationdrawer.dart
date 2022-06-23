import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:worldsgate/screens/dataentryoperator/booking/yacht/deoaddyachtdetails.dart';
import 'package:worldsgate/screens/dataentryoperator/booking/yacht/deomanageyachts.dart';
import 'package:worldsgate/screens/dataentryoperator/delivery/restaurants/deomanagerestaurant.dart';
import 'package:worldsgate/screens/dataentryoperator/delivery/supermarkets/deomanagesupermarket.dart';
import '../screens/dataentryoperator/booking/apartments/deomanageapartments.dart';
import '../screens/dataentryoperator/booking/cars/deomanagecars.dart';
import '../screens/dataentryoperator/booking/hotels/deomanagehotels.dart';
import '../screens/dataentryoperator/delivery/pharmacy/deomanagepharmacy.dart';
import '../screens/dataentryoperator/delivery/restaurants/deoaddrestaurantdetails.dart';
import '../screens/loginpage.dart';
import 'package:firebase_auth/firebase_auth.dart' as u;

class DeoNavigationDrawer extends StatelessWidget {
  //const DeoNavigationDrawer({Key? key}) : super(key: key);

  String? uid;

  // //constructor
  DeoNavigationDrawer(
    this.uid,
  );

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Color(0xFF262626),
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
        padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
      );
  Widget buildMenuItems(BuildContext context) => Container(
        padding: const EdgeInsets.all(24),
        child: Wrap(
          runSpacing: 16,
          children: [
            Text(
              "Booking",
              style: TextStyle(color: Colors.white),
            ),
            ListTile(
              leading: const Icon(Icons.home_outlined),
              title: const Text(
                'Hotel',
                style: TextStyle(color: Colors.white),
              ),
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => DeoManageHotels(uid),
                ));
              },
            ),
            ListTile(
              leading: const Icon(Icons.home_outlined),
              title: const Text(
                'Apartments',
                style: TextStyle(color: Colors.white),
              ),
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => DeoManageApartments(uid),
                ));
              },
            ),
            ListTile(
              leading: const Icon(Icons.home_outlined),
              title: const Text(
                'Cars',
                style: TextStyle(color: Colors.white),
              ),
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => DeoManageCars(uid),
                ));
              },
            ),
            ListTile(
              leading: const Icon(Icons.home_outlined),
              title: const Text(
                'Yachts',
                style: TextStyle(color: Colors.white),
              ),
              onTap: () {

                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => DeoManageYachts(uid),
                ));

              },
            ),
            ListTile(
              leading: const Icon(Icons.home_outlined),
              title: const Text(
                'Bars',
                style: TextStyle(color: Colors.white),
              ),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.home_outlined),
              title: const Text(
                'Restaurants',
                style: TextStyle(color: Colors.white),
              ),
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => AddRestaurantDetails(uid),
                ));
              },
            ),
            Text(
              "Delivery",
              style: TextStyle(color: Colors.white),
            ),
            ListTile(
              leading: const Icon(Icons.home_outlined),
              title: const Text(
                'Restaurants',
                style: TextStyle(color: Colors.white),
              ),
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => DeoManageRestaurant(uid),
                ));
              },
            ),
            ListTile(
              leading: const Icon(Icons.home_outlined),
              title: const Text(
                'Supermarkets',
                style: TextStyle(color: Colors.white),
              ),
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => DeoManageSupermarket(uid),
                ));
              },
            ),
            ListTile(
              leading: const Icon(Icons.home_outlined),
              title: const Text(
                'Pharmacies',
                style: TextStyle(color: Colors.white),
              ),
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => DeoManagePharmacy(uid),
                ));
              },
            ),
            // ListTile(
            //   leading: const Icon(Icons.home_outlined),
            //   title: const Text(
            //     'Food',
            //     style: TextStyle(color: Colors.white),
            //   ),
            //   onTap: () {
            //     Navigator.of(context).push(MaterialPageRoute(
            //       builder: (context) => DeoOrderFood(uid),
            //     ));
            //   },
            // ),
            Text(
              "Online Shopping",
              style: TextStyle(color: Colors.white),
            ),
            ListTile(
              leading: const Icon(Icons.home_outlined),
              title: const Text(
                'Home',
                style: TextStyle(color: Colors.white),
              ),
              onTap: () {},
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
