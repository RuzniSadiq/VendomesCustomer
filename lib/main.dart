import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:universal_io/io.dart' as u;
import 'package:worldsgate/screens/databaseupdatefile.dart';
import 'package:worldsgate/screens/dataentryoperator/booking/cars/deomanagecars.dart';
import 'package:worldsgate/screens/dataentryoperator/booking/hotels/deomanagehotels.dart';
import 'package:worldsgate/screens/dataentryoperator/booking/yacht/deomanageyachts.dart';
import 'package:worldsgate/screens/dataentryoperator/booking/yacht/deoviewyachts.dart';
import 'package:worldsgate/screens/dataentryoperator/delivery/restaurants/food/deoaddfooddetails.dart';
import 'package:worldsgate/screens/dataentryoperator/delivery/supermarkets/deomanagesupermarket.dart';
import 'package:worldsgate/screens/driver/driverrequests.dart';
import 'package:worldsgate/screens/loginpage.dart';
import 'package:worldsgate/screens/outlet/restautants/restaurantrequests.dart';
import 'package:worldsgate/screens/user/booking/apartments/userapartmentbooking.dart';
import 'package:worldsgate/screens/user/booking/hotels/userhotelbooking.dart';
import 'package:worldsgate/screens/user/booking/yacht/useryachtlisting.dart';
import 'package:worldsgate/screens/user/userhomepage.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (u.Platform.operatingSystem == "android" ||
      u.Platform.operatingSystem == "ios") {
    await Firebase.initializeApp();
  } else {
    await Firebase.initializeApp(
      // For Firebase JS SDK v7.20.0 and later, measurementId is optional
      options: const FirebaseOptions(
        apiKey: "AIzaSyDw9J5oQw3a1OrqBWAVgNmirp-7Es5gs8E",
        projectId: "worldgates-93f28",
        storageBucket: "worldgates-93f28.appspot.com",
        messagingSenderId: "1087644602140",
        appId: "1:1087644602140:web:4c5600a8e70960eaa6b4d9",
      ),
    );
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        useInheritedMediaQuery: true,
        title: 'worldsgate',
        theme: ThemeData(
          colorScheme: ColorScheme.dark(
              primary: const Color(0xFFBA780F),
              onSurface: const Color(0xFFBA780F)),
          primarySwatch: Colors.blue,
        ),
        home: /*UserHomePage("WpzPfHN360dyUtmpSo2a3yhXVak2",
            "Palm Jumeirah")*/ LoginPage()
            /*UpdateDatabase()*/ /*LoginPage()*/ /*UserOrderFood(
                "WpzPfHN360dyUtmpSo2a3yhXVak2", "Deira")*/);
  }
}
