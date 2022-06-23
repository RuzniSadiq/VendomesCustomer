import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class UpdateDatabase extends StatefulWidget {
  const UpdateDatabase({Key? key}) : super(key: key);

  @override
  State<UpdateDatabase> createState() => _UpdateDatabaseState();
}

class _UpdateDatabaseState extends State<UpdateDatabase> {
  var address;
  var cancellationfee;
  var city;
  var coverimage;
  var dataentryuid;
  var datecreated;
  var description;
  var hotelid;
  var mainfacilities;
  var name;
  var otherHotelImages;
  var price;
  var promotion;
  var rooms;
  var stars;
  var subfacilities;
  var taxandcharges;

  _updateHotel() async {
    await FirebaseFirestore.instance
        .collection('hotels')
        .where('dataentryuid', isEqualTo: "Oqsxr0M6r5XfEDMOqqoXZAc3mgz1")
        .get()
        .then((QuerySnapshot querySnapshot) => {
              querySnapshot.docs.forEach((documentSnapshot) {
                if (documentSnapshot.exists) {
                  DateTime dt =
                      (documentSnapshot['datecreated'] as Timestamp).toDate();
                  String formattedDate = DateFormat('yyyy/MM/dd').format(dt);

                  FirebaseFirestore.instance
                      .collection('booking')
                      .doc('aGAm7T71ShOqGUhYphfc')
                      .collection('hotels')
                      .doc(documentSnapshot.id)
                      .set({
                    'name': (documentSnapshot.data() as Map<String, dynamic>)
                            .containsKey('name')
                        ? documentSnapshot['name']
                        : "",
                    'city': (documentSnapshot.data() as Map<String, dynamic>)
                            .containsKey('city')
                        ? documentSnapshot['city']
                        : "",
                    'address': (documentSnapshot.data() as Map<String, dynamic>)
                            .containsKey('address')
                        ? documentSnapshot['address']
                        : "",
                    'price': null,
                    //'price': double.parse(startingPriceController.text),
                    'promotion': (documentSnapshot.data()
                                as Map<String, dynamic>)
                            .containsKey('promotion')
                        ? double.parse(documentSnapshot['promotion'].toString())
                        : 0,
                    'description':
                        (documentSnapshot.data() as Map<String, dynamic>)
                                .containsKey('description')
                            ? documentSnapshot['description']
                            : "",
                    'mainfacilities':
                        (documentSnapshot.data() as Map<String, dynamic>)
                                .containsKey('mainfacilities')
                            ? documentSnapshot['mainfacilities']
                            : [],
                    'subfacilities':
                        (documentSnapshot.data() as Map<String, dynamic>)
                                .containsKey('subfacilities')
                            ? documentSnapshot['subfacilities']
                            : {},
                    'rooms': (documentSnapshot.data() as Map<String, dynamic>)
                            .containsKey('rooms')
                        ? documentSnapshot['rooms']
                        : {},
                    'datecreated':
                        (documentSnapshot.data() as Map<String, dynamic>)
                                .containsKey('datecreated')
                            ? documentSnapshot['datecreated']
                            : "",
                    'dataentryuid':
                        (documentSnapshot.data() as Map<String, dynamic>)
                                .containsKey('dataentryuid')
                            ? documentSnapshot['dataentryuid']
                            : "",
                    'coverimage':
                        (documentSnapshot.data() as Map<String, dynamic>)
                                .containsKey('coverimage')
                            ? documentSnapshot['coverimage']
                            : "",
                    'otherhotelimages':
                        (documentSnapshot.data() as Map<String, dynamic>)
                                .containsKey('otherhotelimages')
                            ? documentSnapshot['otherhotelimages']
                            : [],
                    'cancellationfee': null,
                    'stars': (documentSnapshot.data() as Map<String, dynamic>)
                            .containsKey('stars')
                        ? documentSnapshot['stars']
                        : 0,
                    'taxandcharges': null,
                    'hotelid': (documentSnapshot.data() as Map<String, dynamic>)
                            .containsKey('hotelid')
                        ? documentSnapshot['hotelid']
                        : "",
                    'date': formattedDate
                  });
                  print("Document updated");
                } else {
                  print("Document does not exists");
                }
              })
            });
  }

  int count = 0;

  _updateHotelCount() async {
    await FirebaseFirestore.instance
        .collection('booking')
        .doc('aGAm7T71ShOqGUhYphfc')
        .collection('hotels')
        .where('dataentryuid', isEqualTo: "Oqsxr0M6r5XfEDMOqqoXZAc3mgz1")
        .get()
        .then((QuerySnapshot querySnapshot) => {
              querySnapshot.docs.forEach((documentSnapshot) {
                if (documentSnapshot.exists) {
                  setState(() {
                    this.count = count + 1;
                  });
                  print("Number of document exists is : ${count}");
                } else {
                  print("Document does not exists");
                }
              })
            });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF000000),
      body: Center(
        child: Container(
          width: 300.0,
          height: 50.0,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
                primary: Color(0xFF000000),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20.0)),
                    side: BorderSide(color: Color(0xFFdb9e1f))),
                side: BorderSide(
                  width: 2.5,
                  color: Color(0xFFdb9e1f),
                ),
                textStyle: const TextStyle(fontSize: 16)),
            onPressed: () {
              _updateHotelCount();
            },
            child: const Text(
              'Update Database',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }
}
