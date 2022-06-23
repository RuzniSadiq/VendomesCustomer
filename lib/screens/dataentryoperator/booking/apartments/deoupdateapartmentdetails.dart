import 'dart:io';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:path/path.dart';
import '../../../../widgets/deonavigationdrawer.dart';
import '../../../../widgets/header.dart';
import 'deomanageapartments.dart';

class UpdateAparmentDetails extends StatefulWidget {
  String? uid;
  String? apartmentid;

  UpdateAparmentDetails(this.uid, this.apartmentid);

  @override
  _UpdateAparmentDetailsState createState() => _UpdateAparmentDetailsState();
}

class _UpdateAparmentDetailsState extends State<UpdateAparmentDetails> {
  final _formkey = GlobalKey<FormState>();
  var _scaffoldState = new GlobalKey<ScaffoldState>();

  double starInitialNumber = 0;
  List<String> apartmentCoverImageList = [];

  _getapartmentData() async {
    await FirebaseFirestore.instance
        .collection('apartments')
        .doc(widget.apartmentid)
        .get()
        .then((documentSnapshot) {
      if (documentSnapshot.exists) {
        setState(() {
          if ((documentSnapshot.data() as Map<String, dynamic>)
              .containsKey('name')) {
            apartmentNameController.text = documentSnapshot['name'];
          }
          if ((documentSnapshot.data() as Map<String, dynamic>)
              .containsKey('stars')) {
            starInitialNumber = documentSnapshot['stars'];
            setState(() {
              stars = documentSnapshot['stars'];
            });
          }
          if ((documentSnapshot.data() as Map<String, dynamic>)
              .containsKey('city')) {
            city = documentSnapshot['city'];
          }
          if ((documentSnapshot.data() as Map<String, dynamic>)
              .containsKey('address')) {
            apartmentAddressController.text = documentSnapshot['address'];
          }
          if ((documentSnapshot.data() as Map<String, dynamic>)
              .containsKey('promotion')) {
            discountController.text = documentSnapshot['promotion'].toString();
          }
          if ((documentSnapshot.data() as Map<String, dynamic>)
              .containsKey('description')) {
            descriptionController.text = documentSnapshot['description'];
          }
          if ((documentSnapshot.data() as Map<String, dynamic>)
              .containsKey('mainfacilities')) {
            mainFacilities = documentSnapshot['mainfacilities'];
          } else {
            setState(() {
              mainFacilities = allMainFacilities;
            });
          }
          if ((documentSnapshot.data() as Map<String, dynamic>)
              .containsKey('subfacilities')) {
            subFacilities = documentSnapshot['subfacilities'];
          } else {
            setState(() {
              subFacilities = allSubFacilities;
            });
          }
          if ((documentSnapshot.data() as Map<String, dynamic>)
              .containsKey('rooms')) {
            roomDeatils = documentSnapshot['rooms'];
          }
          if ((documentSnapshot.data() as Map<String, dynamic>)
              .containsKey('coverimage')) {
            coverImageLink = documentSnapshot['coverimage'];
            apartmentCoverImageList.add(coverImageLink);
          }
          if ((documentSnapshot.data() as Map<String, dynamic>)
              .containsKey('otherapartmentimages')) {
            for (int i = 0;
                i < documentSnapshot['otherapartmentimages'].length;
                i++) {
              OtherapartmentImagesUrl.add(documentSnapshot['otherapartmentimages'][i]);
            }
            print(OtherapartmentImagesUrl);
          }
        });
      } else {
        print("The document does not exist");
      }
    });
  }

  _removeapartmentCoverPhoto(url) async {
    await FirebaseStorage.instance.refFromURL(url).delete();
    setState(() {
      apartmentCoverImageList.removeAt(apartmentCoverImageList.indexOf(url));
    });
  }

  _removeOtherapartmentPhotos(url) async {
    await FirebaseStorage.instance.refFromURL(url).delete();
    setState(() {
      OtherapartmentImagesUrl.removeAt(OtherapartmentImagesUrl.indexOf(url));
    });
  }

  final TextEditingController apartmentNameController = TextEditingController();
  final TextEditingController apartmentAddressController = TextEditingController();
  final TextEditingController startingPriceController = TextEditingController();
  final TextEditingController discountController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  double stars = 0;

  String? city;

  final places = [
    'Deira',
    'Bur Dubai',
    'Beach & Coast',
    'Garhoud',
    'Palm Jumeirah',
    'Barsha Heights (Tecom)',
    'Sheikh Zayed Road',
    'Al Barsha',
    'Dubai Creek',
    'Jumeirah Beach Residence',
    'Dubai Marina',
    'Trade Centre',
    'Old Dubai',
    'Downtown Dubai',
    'Business Bay',
    "Guests' favourite area",
    'Jadaf',
    'Al Qusais',
    'Oud Metha',
    'Dubai Investment Park',
    'Dubai Festival City',
    'Dubai World Central',
    'Umm Suqeim',
    'Discovery Gardens',
    'Dubai Production City',
    'Jumeirah Lakes Towers',
  ];

  DropdownMenuItem<String> buildMenuItem(String place) => DropdownMenuItem(
        value: place,
        child: Text(
          place,
          style: const TextStyle(fontSize: 16.0),
        ),
      );

  bool addRoom = false;

  String? rooms;
  String? adults;
  String? children;
  String? roomType;
  String? bedType;
  String? numOfBeds;

  List<String> typesOfBedsAndCount = [];
  List<String> roomTypeDetails = [];

  Map roomDeatils = {};

  final typeOfBeds = [
    'Twin bed',
    'Full bed',
    'King bed',
    'Queen bed',
    'Sofa bed',
  ];

  final typeOfRoom = [
    'Superior Twin Room',
    'Grand Room',
    'Deluxe Twin Room',
    'Club Suite',
    'Executive Deluxe Suite',
    'Deluxe King Room',
    'Superior King Room',
    'Pool View King Room'
  ];

  final bedCount = [
    '1',
    '2',
    '3',
    '4',
    '5',
    '6',
    '7',
    '8',
    '9',
    '10',
  ];

  final childrenCount = [
    '0',
    '1',
    '2',
    '3',
    '4',
    '5',
    '6',
    '7',
    '8',
    '9',
    '10',
  ];

  final roomsAndAdultCount = [
    '1',
    '2',
    '3',
    '4',
    '5',
    '6',
    '7',
    '8',
    '9',
    '10',
    '11',
    '12',
    '13',
    '14',
    '15',
    '16',
    '17',
    '18',
    '19',
    '20',
    '21',
    '22',
    '23',
    '24',
    '25',
    '26',
    '27',
    '28',
    '29',
    '30'
  ];

  DropdownMenuItem<String> buildMenuItemRoomDetails(String value) =>
      DropdownMenuItem(
        value: value,
        child: Text(
          value,
          style: const TextStyle(fontSize: 16.0),
        ),
      );

  DropdownMenuItem<String> buildMenuItemBedDetails(String value) =>
      DropdownMenuItem(
        value: value,
        child: Text(
          value,
          style: const TextStyle(fontSize: 16.0),
        ),
      );

  var mainFacilities;

  bool mainFacilitiesBoolValue = true;

  List<String> allMainFacilities = [
    'Swimming Pool',
    'Fitness Center',
    'Airport Shuttle',
    'Non-smoking rooms',
    'Spa',
    'Restaurant',
    'Room service',
    'Bar',
    'Breakfast',
    'WiFi in all areas',
    'Tea/Coffee Maker in All Rooms',
    'Facilities for disabled guests'
  ];

  var subFacilities;

  bool subFacilitiesBoolValue = true;

  Map allSubFacilities = {
    "Bathroom": [
      'Towels',
      'Bathtub or shower',
      'Slippers',
      'Private Bathroom',
      'Toilet',
      'Free toiletries',
      'Bathrobe',
      'Hairdryer',
      'Bathtub',
      'Shower',
    ],
    "Bedroom": [
      'Linens',
      'Wardrobe or closet',
      'Alarm clock',
    ],
    "View": ['View'],
    "Outdoors": [
      'Sun deck',
      'Terrace',
    ],
    "Kitchen": ['Electric kettle'],
    "Rooms Amenities": ['Clothes rack'],
    "Activities": [
      'Live sports events',
      'Happy hour',
      'Themed dinners',
      'Evening entertainment',
      'Darts',
      'Pool table',
      'Playground',
    ],
    "Living Area": ['Desk'],
    "Media & Technology": [
      'Flat-screen TV',
      'Telephone',
      'TV',
    ],
    "Food & Drink": [
      'Coffee house on site',
      'Restaurant',
      'Tea/Coffee maker',
    ],
    "Internet": ['WiFi is available in the apartment rooms and is free of charge'],
    "Parking": [
      'Accessible parking',
      'Parking garage',
    ],
    "Transportation": [
      'Airport drop-off',
      'Airport pickup',
    ],
    "Front Desk Services": [
      'Concierge',
      'Baggage storage',
      'Tour desk',
      'Currency exchange',
      '24-hour front desk',
    ],
    "Entertainment & Family Services": [
      'Outdoor play equipment for kids',
      'Babysitting/Child services'
    ],
    "Cleaning Services": [
      'Suit press',
      'Dry cleaning',
      'Laundry',
    ],
    "Business Facilities": [
      'Fax/Photocopying',
      'Business center',
      'Meeting/Banquet facilities',
    ],
    "Safety & Security Facilities": ['Safe'],
    "General Facilities": [
      'Airport shuttle (additional charge)',
      'Designated smoking area',
      'Air conditioning',
      'Smoke-free property',
      'Wake-up service',
      'Tile/Marble floor',
      'Carpeted',
      'Elevator',
      'Family rooms',
      'Hair/Beauty salon',
      'Facilities for disabled guests',
      'Ironing facilities',
      'Non-smoking rooms',
      'Room service',
    ],
    "Accessibility Facilities": [
      'Visual aids (tactile signs)',
      'Visual aids (Braille)',
      'Bathroom emergency cord',
      'Lowered sink',
      'Raised toilet',
      'Toilet with grab rails',
      'Wheelchair accessible',
    ],
    "Swimming Pool Facilities": [
      'Open all year',
      'All ages welcome',
    ],
    "Spa Facilities": [
      'Fitness',
      'Fitness center',
    ],
    "Language Spoken": [
      'Arabic',
      'English',
      'Hindi',
      'Filipino',
      'Urdu',
    ]
  };

  bool _isLoading = true;

  // Main Facilities
  bool swimmingValue = true;
  bool fitnessCenterValue = true;
  bool airportShuttleValue = true;
  bool nonSmokingRoomsValue = true;
  bool spaValue = true;
  bool restaurentValue = true;
  bool roomServiceValue = true;
  bool barValue = true;
  bool breakfastValue = true;
  bool wifiValue = true;
  bool teaCoffeeMakerValue = true;
  bool disabledGuestsValue = true;

  bool _isMainUploadingLoading = false;
  bool _isOtherUploadingLoading = false;

  FilePickerResult? result;
  String? file;
  UploadTask? task;
  var coverImageLink;
  List<Uint8List> coverImage = [];

  Future selectFileandUpload() async {
    try {
      result = await FilePicker.platform
          .pickFiles(type: FileType.any, allowMultiple: false);
      setState(() => result = result);
      String filename = basename(result!.files.single.name);
      setState(() => file = filename);

      if (result == null) {
        print("Result is null!");
      }

      if (result != null) {
        try {
          print("Start of upload file method");
          Uint8List uploadfile = result!.files.single.bytes!;
          setState(() {
            coverImage.add(uploadfile);
          });
          String filename = basename(result!.files.single.name);

          //final fileName = basename(file!.path);
          final destination = '/apartmentimages/apartmentmain/$filename';
          print("The destination is $destination");

          final ref = FirebaseStorage.instance.ref(destination);
          task = ref.putData(uploadfile);
          setState(() {
            _isMainUploadingLoading = true;
          });
          setState(() {});
          print("Total bytes $task");
          print("Total bytes ${task!.snapshot.totalBytes}");

          if (task == null) return;
          final snapshot = await task!.whenComplete(() {
            setState(() {
              _isMainUploadingLoading = false;
            });
          });
          final urlDownload = await snapshot.ref.getDownloadURL();

          print('Download-Link: $urlDownload');

          coverImageLink = urlDownload;

          setState(() => coverImageLink = urlDownload);
        } catch (e) {
          print(e);
        }
      }
    } catch (e) {
      print(e);
    }
  }

  FilePickerResult? otherResult;
  String? otherFile;
  UploadTask? otherTask;
  var otherImageLink;
  List<Uint8List> otherImage = [];
  List<String> OtherapartmentImagesUrl = [];

  List<File>? files;

  Future selectOtherFileandUpload() async {
    try {
      otherResult = await FilePicker.platform
          .pickFiles(type: FileType.any, allowMultiple: true);
      setState(() => otherResult = otherResult);

      files = otherResult!.names.map((name) => File(name!)).toList();

      //String filename = basename(otherResult!.files.single.name);
      //setState(() => otherFile = filename);

      for (int i = 0; i < files!.length; i++) {
        Uint8List uploadOtherFile = otherResult!.files[i].bytes!;
        setState(() {
          otherImage.add(uploadOtherFile);
        });
      }

      if (otherResult == null) {
        print("Result is null!");
      }

      if (otherResult != null) {
        try {
          for (int i = 0; i < files!.length; i++) {
            print("Start of upload file method");
            Uint8List uploadfile = otherResult!.files[i].bytes!;
            //setState(() {
            //otherImage.add(uploadfile);
            //});
            String filename = basename(otherResult!.files[i].name);
            final destination = '/apartmentimages/apartmentsub/$filename';
            print("The destination is $destination");

            final ref = FirebaseStorage.instance.ref(destination);
            otherTask = ref.putData(uploadfile);
            setState(() {
              _isOtherUploadingLoading = true;
            });
            print("Total bytes $otherTask");
            print("Total bytes ${otherTask!.snapshot.totalBytes}");

            if (otherTask == null) return;
            final snapshot = await otherTask!.whenComplete(() {
              //setState(() {
              //_isUploadingLoading = false;
              //});
            });
            final urlDownload = await snapshot.ref.getDownloadURL();

            print('Download-Link: $urlDownload');

            otherImageLink = urlDownload;

            setState(() => otherImageLink = urlDownload);
            OtherapartmentImagesUrl.add(otherImageLink);
          }

          setState(() {
            _isOtherUploadingLoading = false;
          });
        } catch (e) {
          print(e);
        }
      }
    } catch (e) {
      print(e);
    }
  }

  _uploadapartmentData() async {
    //String newapartmentId =
    //  FirebaseFirestore.instance.collection('apartments').doc().id;

    try {
      await FirebaseFirestore.instance
          .collection('apartments')
          .doc(widget.apartmentid)
          .update({
        'name': apartmentNameController.text,
        'city': city,
        'address': apartmentAddressController.text,
        //'price': null,
        //'price': double.parse(startingPriceController.text),
        'promotion': double.parse(discountController.text),
        'description': descriptionController.text,
        'mainfacilities': mainFacilities,
        'subfacilities': subFacilities,
        'rooms': roomDeatils,
        //'datecreated': DateTime.now(),
        //'dataentryuid': widget.uid,
        'coverimage': coverImageLink,
        'otherapartmentimages': OtherapartmentImagesUrl,
        //'cancellationfee': null,
        'stars': stars,
        //'taxandcharges': null,
        'apartmentid': widget.apartmentid,
      });
    } catch (e) {
      print(e);
    }
  }

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
  void initState() {
    // TODO: implement initState
    super.initState();
    getname();
    _getapartmentData();
    Future.delayed(Duration(seconds: 2), () {
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
        drawer: new DeoNavigationDrawer(widget.uid),
        backgroundColor: Color(0xFF000000),
        body: (_isLoading == true)
            ? Center(child: CircularProgressIndicator())
            : Stack(
                children: [
                  SingleChildScrollView(
                    child: Column(
                      children: [
                        Center(
                          child: Container(
                            width: MediaQuery.of(context).size.width / 1.6,
                            color: Color(0xFF000000),
                            child: Center(
                              child: Container(
                                margin: EdgeInsets.only(
                                    left: 120,
                                    right: 120,
                                    bottom: 120,
                                    top: MediaQuery.of(context).size.height *
                                        0.25),
                                child: Form(
                                    key: _formkey,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        TextFormField(
                                          style: TextStyle(color: Colors.white),
                                          controller: apartmentNameController,
                                          decoration: InputDecoration(
                                            suffixIcon: IconButton(
                                                icon: Icon(
                                                  Icons.cancel,
                                                  color: Color(0xFFdb9e1f),
                                                ),
                                                onPressed: () {
                                                  apartmentNameController
                                                    ..text = "";
                                                }),
                                            hintText: "Enter apartment name",
                                            labelText: "apartment Name",
                                            hintStyle: TextStyle(
                                                color: Colors.white70),
                                            labelStyle: new TextStyle(
                                                color: Colors.white70,
                                                height: 0.1),
                                            enabled: true,
                                            enabledBorder: UnderlineInputBorder(
                                              borderSide: new BorderSide(
                                                  color: Colors.white70),
                                            ),
                                            focusedBorder: UnderlineInputBorder(
                                              borderSide: new BorderSide(
                                                  color: Color(0xFFdb9e1f)),
                                            ),
                                          ),
                                          validator: (value) {
                                            if (value!.length == 0) {
                                              return "apartment name cannot be empty";
                                            }
                                          },
                                          onSaved: (value) {
                                            apartmentNameController.text = value!;
                                          },
                                          keyboardType: TextInputType.text,
                                        ),
                                        SizedBox(
                                          height: 20,
                                        ),
                                        Container(
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text("Star",
                                                  style: TextStyle(
                                                      color: Colors.white70,
                                                      fontSize: 16)),
                                              SizedBox(
                                                height: 20.0,
                                              ),
                                              Center(
                                                child: RatingBar.builder(
                                                    initialRating:
                                                        starInitialNumber,
                                                    minRating: 1,
                                                    itemBuilder: (context, _) =>
                                                        Icon(Icons.star,
                                                            color: Color(
                                                                0xFFdb9e1f)),
                                                    onRatingUpdate: (stars) =>
                                                        setState(() {
                                                          this.stars = stars;
                                                        })),
                                              )
                                            ],
                                          ),
                                        ),
                                        SizedBox(
                                          height: 20,
                                        ),
                                        DropdownButtonFormField(
                                            decoration: InputDecoration(
                                              hintText: "Select place in UAE",
                                              hintStyle: TextStyle(
                                                  color: Colors.white70),
                                              labelText: 'apartment City',
                                              labelStyle: TextStyle(
                                                  color: Colors.white70,
                                                  height: 0.1),
                                              enabled: true,
                                              enabledBorder:
                                                  UnderlineInputBorder(
                                                borderSide: new BorderSide(
                                                    color: Colors.white70),
                                              ),
                                              focusedBorder:
                                                  UnderlineInputBorder(
                                                borderSide: new BorderSide(
                                                    color: Color(0xFFdb9e1f)),
                                              ),
                                            ),
                                            dropdownColor: Color(0xFF000000),
                                            //focusColor: Color(0xFFdb9e1f),
                                            style:
                                                TextStyle(color: Colors.white),
                                            isExpanded: true,
                                            value: city,
                                            items: places
                                                .map(buildMenuItem)
                                                .toList(),
                                            onChanged: (value) => setState(() {
                                                  this.city = value as String?;
                                                })),
                                        SizedBox(
                                          height: 20,
                                        ),
                                        TextFormField(
                                          style: TextStyle(color: Colors.white),
                                          controller: apartmentAddressController,
                                          decoration: InputDecoration(
                                            suffixIcon: IconButton(
                                                icon: Icon(
                                                  Icons.cancel,
                                                  color: Color(0xFFdb9e1f),
                                                ),
                                                onPressed: () {
                                                  apartmentAddressController
                                                    ..text = "";
                                                }),
                                            hintText: "Enter apartment address",
                                            labelText: "apartment Address",
                                            hintStyle: TextStyle(
                                                color: Colors.white70),
                                            labelStyle: new TextStyle(
                                                color: Colors.white70,
                                                height: 0.1),
                                            enabled: true,
                                            enabledBorder: UnderlineInputBorder(
                                              borderSide: new BorderSide(
                                                  color: Colors.white70),
                                            ),
                                            focusedBorder: UnderlineInputBorder(
                                              borderSide: new BorderSide(
                                                  color: Color(0xFFdb9e1f)),
                                            ),
                                          ),
                                          validator: (value) {
                                            if (value!.length == 0) {
                                              return "apartment address cannot be empty";
                                            }
                                          },
                                          onSaved: (value) {
                                            apartmentAddressController.text =
                                                value!;
                                          },
                                          keyboardType: TextInputType.text,
                                        ),
                                        SizedBox(
                                          height: 20,
                                        ),
                                        TextFormField(
                                          style: TextStyle(color: Colors.white),
                                          controller: discountController,
                                          decoration: InputDecoration(
                                            suffixIcon: IconButton(
                                                icon: Icon(
                                                  Icons.cancel,
                                                  color: Color(0xFFdb9e1f),
                                                ),
                                                onPressed: () {
                                                  discountController..text = "";
                                                }),
                                            hintText: "Enter discounts",
                                            labelText: "Discounts",
                                            hintStyle: TextStyle(
                                                color: Colors.white70),
                                            labelStyle: new TextStyle(
                                                color: Colors.white70,
                                                height: 0.1),
                                            enabled: true,
                                            enabledBorder: UnderlineInputBorder(
                                              borderSide: new BorderSide(
                                                  color: Colors.white70),
                                            ),
                                            focusedBorder: UnderlineInputBorder(
                                              borderSide: new BorderSide(
                                                  color: Color(0xFFdb9e1f)),
                                            ),
                                          ),
                                          validator: (value) {
                                            if (value!.length == 0) {
                                              return "Discounts cannot be empty";
                                            }
                                          },
                                          onSaved: (value) {
                                            discountController.text = value!;
                                          },
                                          keyboardType: TextInputType.number,
                                        ),
                                        SizedBox(
                                          height: 20,
                                        ),
                                        TextFormField(
                                          style: TextStyle(color: Colors.white),
                                          maxLines: null,
                                          controller: descriptionController,
                                          decoration: InputDecoration(
                                            suffixIcon: IconButton(
                                                icon: Icon(
                                                  Icons.cancel,
                                                  color: Color(0xFFdb9e1f),
                                                ),
                                                onPressed: () {
                                                  descriptionController
                                                    ..text = "";
                                                }),
                                            hintText: "Enter apartment description",
                                            labelText: "apartment Description",
                                            hintStyle: TextStyle(
                                                color: Colors.white70),
                                            labelStyle: new TextStyle(
                                                color: Colors.white70,
                                                height: 0.1),
                                            enabled: true,
                                            enabledBorder: UnderlineInputBorder(
                                              borderSide: new BorderSide(
                                                  color: Colors.white70),
                                            ),
                                            focusedBorder: UnderlineInputBorder(
                                              borderSide: new BorderSide(
                                                  color: Color(0xFFdb9e1f)),
                                            ),
                                          ),
                                          validator: (value) {
                                            if (value!.length == 0) {
                                              return "apartment description cannot be empty";
                                            }
                                          },
                                          onSaved: (value) {
                                            descriptionController.text = value!;
                                          },
                                          keyboardType: TextInputType.multiline,
                                        ),
                                        SizedBox(
                                          height: 30,
                                        ),
                                        Container(
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Align(
                                                alignment: Alignment.topLeft,
                                                child: Text("Rooms",
                                                    style: TextStyle(
                                                        color: Colors.white70,
                                                        fontSize: 16)),
                                              ),
                                              SizedBox(
                                                height: 20.0,
                                              ),
                                              Center(
                                                child: Container(
                                                  width: 170.0,
                                                  height: 50.0,
                                                  child: ElevatedButton.icon(
                                                    style: ElevatedButton
                                                        .styleFrom(
                                                            primary: Color(
                                                                0xFF000000),
                                                            shape: RoundedRectangleBorder(
                                                                borderRadius: BorderRadius
                                                                    .all(Radius
                                                                        .circular(
                                                                            20.0)),
                                                                side: BorderSide(
                                                                    color: Color(
                                                                        0xFFdb9e1f))),
                                                            side: BorderSide(
                                                              width: 2.5,
                                                              color: Color(
                                                                  0xFFdb9e1f),
                                                            ),
                                                            textStyle:
                                                                const TextStyle(
                                                                    fontSize:
                                                                        16)),
                                                    onPressed: () {
                                                      setState(() {
                                                        this.addRoom = !addRoom;
                                                      });
                                                      //print(subFacilities);
                                                    },
                                                    icon: Icon(
                                                      Icons
                                                          .add_circle_outline_rounded,
                                                      color: Colors.white,
                                                      size: 20,
                                                    ),
                                                    label: Text(
                                                      "Room",
                                                      style: TextStyle(
                                                          color: Colors.white),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                height: 30.0,
                                              ),
                                              addRoom
                                                  ? Container(
                                                      child: Column(
                                                        children: [
                                                          Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceAround,
                                                            children: [
                                                              Expanded(
                                                                child: Padding(
                                                                    padding: const EdgeInsets
                                                                            .symmetric(
                                                                        horizontal:
                                                                            8.0),
                                                                    child: DropdownButtonFormField(
                                                                        decoration: InputDecoration(
                                                                          hintText:
                                                                              "Number of rooms",
                                                                          hintStyle:
                                                                              TextStyle(color: Colors.white70),
                                                                          labelText:
                                                                              'Rooms',
                                                                          labelStyle: TextStyle(
                                                                              color: Colors.white70,
                                                                              height: 0.1),
                                                                          enabled:
                                                                              true,
                                                                          enabledBorder:
                                                                              UnderlineInputBorder(
                                                                            borderSide:
                                                                                new BorderSide(color: Colors.white70),
                                                                          ),
                                                                          focusedBorder:
                                                                              UnderlineInputBorder(
                                                                            borderSide:
                                                                                new BorderSide(color: Color(0xFFdb9e1f)),
                                                                          ),
                                                                        ),
                                                                        dropdownColor: Color(0xFF000000),
                                                                        //focusColor: Color(0xFFdb9e1f),
                                                                        style: TextStyle(color: Colors.white),
                                                                        isExpanded: true,
                                                                        value: rooms,
                                                                        items: roomsAndAdultCount.map(buildMenuItemRoomDetails).toList(),
                                                                        onChanged: (value) => setState(() {
                                                                              this.rooms = value as String?;
                                                                            }))),
                                                              ),
                                                              Expanded(
                                                                child: Padding(
                                                                  padding: const EdgeInsets
                                                                          .symmetric(
                                                                      horizontal:
                                                                          8.0),
                                                                  child: DropdownButtonFormField(
                                                                      decoration: InputDecoration(
                                                                        hintText:
                                                                            "Number of adults",
                                                                        hintStyle:
                                                                            TextStyle(color: Colors.white70),
                                                                        labelText:
                                                                            'Adults',
                                                                        labelStyle: TextStyle(
                                                                            color:
                                                                                Colors.white70,
                                                                            height: 0.1),
                                                                        enabled:
                                                                            true,
                                                                        enabledBorder:
                                                                            UnderlineInputBorder(
                                                                          borderSide:
                                                                              new BorderSide(color: Colors.white70),
                                                                        ),
                                                                        focusedBorder:
                                                                            UnderlineInputBorder(
                                                                          borderSide:
                                                                              new BorderSide(color: Color(0xFFdb9e1f)),
                                                                        ),
                                                                      ),
                                                                      dropdownColor: Color(0xFF000000),
                                                                      //focusColor: Color(0xFFdb9e1f),
                                                                      style: TextStyle(color: Colors.white),
                                                                      isExpanded: true,
                                                                      value: adults,
                                                                      items: roomsAndAdultCount.map(buildMenuItemRoomDetails).toList(),
                                                                      onChanged: (value) => setState(() {
                                                                            this.adults =
                                                                                value as String?;
                                                                          })),
                                                                ),
                                                              ),
                                                              Expanded(
                                                                child: Padding(
                                                                  padding: const EdgeInsets
                                                                          .symmetric(
                                                                      horizontal:
                                                                          8.0),
                                                                  child: DropdownButtonFormField(
                                                                      decoration: InputDecoration(
                                                                        hintText:
                                                                            "Number of children",
                                                                        hintStyle:
                                                                            TextStyle(color: Colors.white70),
                                                                        labelText:
                                                                            'Children',
                                                                        labelStyle: TextStyle(
                                                                            color:
                                                                                Colors.white70,
                                                                            height: 0.1),
                                                                        enabled:
                                                                            true,
                                                                        enabledBorder:
                                                                            UnderlineInputBorder(
                                                                          borderSide:
                                                                              new BorderSide(color: Colors.white70),
                                                                        ),
                                                                        focusedBorder:
                                                                            UnderlineInputBorder(
                                                                          borderSide:
                                                                              new BorderSide(color: Color(0xFFdb9e1f)),
                                                                        ),
                                                                      ),
                                                                      dropdownColor: Color(0xFF000000),
                                                                      //focusColor: Color(0xFFdb9e1f),
                                                                      style: TextStyle(color: Colors.white),
                                                                      isExpanded: true,
                                                                      value: children,
                                                                      items: childrenCount.map(buildMenuItemRoomDetails).toList(),
                                                                      onChanged: (value) => setState(() {
                                                                            this.children =
                                                                                value as String?;
                                                                          })),
                                                                ),
                                                              ),
                                                              Expanded(
                                                                child: Padding(
                                                                  padding: const EdgeInsets
                                                                          .symmetric(
                                                                      horizontal:
                                                                          8.0),
                                                                  child:
                                                                      TextFormField(
                                                                    style: TextStyle(
                                                                        color: Colors
                                                                            .white),
                                                                    controller:
                                                                        startingPriceController,
                                                                    decoration:
                                                                        InputDecoration(
                                                                      suffixIcon: IconButton(
                                                                          icon: Icon(
                                                                            Icons.cancel,
                                                                            color:
                                                                                Color(0xFFdb9e1f),
                                                                          ),
                                                                          onPressed: () {
                                                                            startingPriceController
                                                                              ..text = "";
                                                                          }),
                                                                      hintText:
                                                                          "Enter Price",
                                                                      labelText:
                                                                          "Price",
                                                                      hintStyle: TextStyle(
                                                                          color: Colors
                                                                              .white70,
                                                                          height:
                                                                              1.5),
                                                                      labelStyle: new TextStyle(
                                                                          color: Colors
                                                                              .white70,
                                                                          height:
                                                                              0.1),
                                                                      enabled:
                                                                          true,
                                                                      enabledBorder:
                                                                          UnderlineInputBorder(
                                                                        borderSide:
                                                                            new BorderSide(color: Colors.white70),
                                                                      ),
                                                                      focusedBorder:
                                                                          UnderlineInputBorder(
                                                                        borderSide:
                                                                            new BorderSide(color: Color(0xFFdb9e1f)),
                                                                      ),
                                                                    ),
                                                                    validator:
                                                                        (value) {
                                                                      if (value!
                                                                              .length ==
                                                                          0) {
                                                                        return "Starting price cannot be empty";
                                                                      }
                                                                    },
                                                                    onSaved:
                                                                        (value) {
                                                                      startingPriceController
                                                                              .text =
                                                                          value!;
                                                                    },
                                                                    keyboardType:
                                                                        TextInputType
                                                                            .number,
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                          SizedBox(
                                                            height: 15.0,
                                                          ),
                                                          Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceAround,
                                                            children: [
                                                              Expanded(
                                                                child: Padding(
                                                                    padding: const EdgeInsets
                                                                            .symmetric(
                                                                        horizontal:
                                                                            8.0),
                                                                    child: DropdownButtonFormField(
                                                                        decoration: InputDecoration(
                                                                          hintText:
                                                                              "Type of room",
                                                                          hintStyle:
                                                                              TextStyle(color: Colors.white70),
                                                                          labelText:
                                                                              'Room Type',
                                                                          labelStyle: TextStyle(
                                                                              color: Colors.white70,
                                                                              height: 0.1),
                                                                          enabled:
                                                                              true,
                                                                          enabledBorder:
                                                                              UnderlineInputBorder(
                                                                            borderSide:
                                                                                new BorderSide(color: Colors.white70),
                                                                          ),
                                                                          focusedBorder:
                                                                              UnderlineInputBorder(
                                                                            borderSide:
                                                                                new BorderSide(color: Color(0xFFdb9e1f)),
                                                                          ),
                                                                        ),
                                                                        dropdownColor: Color(0xFF000000),
                                                                        //focusColor: Color(0xFFdb9e1f),
                                                                        style: TextStyle(color: Colors.white),
                                                                        isExpanded: true,
                                                                        value: roomType,
                                                                        items: typeOfRoom.map(buildMenuItemRoomDetails).toList(),
                                                                        onChanged: (value) => setState(() {
                                                                              this.roomType = value as String?;
                                                                            }))),
                                                              ),
                                                            ],
                                                          ),
                                                          SizedBox(
                                                              height: 15.0),
                                                          Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceAround,
                                                            children: [
                                                              Expanded(
                                                                child: Padding(
                                                                    padding: const EdgeInsets
                                                                            .symmetric(
                                                                        horizontal:
                                                                            8.0),
                                                                    child: DropdownButtonFormField(
                                                                        decoration: InputDecoration(
                                                                          hintText:
                                                                              "Type of beds",
                                                                          hintStyle:
                                                                              TextStyle(color: Colors.white70),
                                                                          labelText:
                                                                              'Bed Type',
                                                                          labelStyle: TextStyle(
                                                                              color: Colors.white70,
                                                                              height: 0.1),
                                                                          enabled:
                                                                              true,
                                                                          enabledBorder:
                                                                              UnderlineInputBorder(
                                                                            borderSide:
                                                                                new BorderSide(color: Colors.white70),
                                                                          ),
                                                                          focusedBorder:
                                                                              UnderlineInputBorder(
                                                                            borderSide:
                                                                                new BorderSide(color: Color(0xFFdb9e1f)),
                                                                          ),
                                                                        ),
                                                                        dropdownColor: Color(0xFF000000),
                                                                        //focusColor: Color(0xFFdb9e1f),
                                                                        style: TextStyle(color: Colors.white),
                                                                        isExpanded: true,
                                                                        value: bedType,
                                                                        items: typeOfBeds.map(buildMenuItemBedDetails).toList(),
                                                                        onChanged: (value) => setState(() {
                                                                              this.bedType = value as String?;
                                                                            }))),
                                                              ),
                                                              Expanded(
                                                                child: Padding(
                                                                  padding: const EdgeInsets
                                                                          .symmetric(
                                                                      horizontal:
                                                                          8.0),
                                                                  child: DropdownButtonFormField(
                                                                      decoration: InputDecoration(
                                                                        hintText:
                                                                            "Number of beds",
                                                                        hintStyle:
                                                                            TextStyle(color: Colors.white70),
                                                                        labelText:
                                                                            'Number of Beds',
                                                                        labelStyle: TextStyle(
                                                                            color:
                                                                                Colors.white70,
                                                                            height: 0.1),
                                                                        enabled:
                                                                            true,
                                                                        enabledBorder:
                                                                            UnderlineInputBorder(
                                                                          borderSide:
                                                                              new BorderSide(color: Colors.white70),
                                                                        ),
                                                                        focusedBorder:
                                                                            UnderlineInputBorder(
                                                                          borderSide:
                                                                              new BorderSide(color: Color(0xFFdb9e1f)),
                                                                        ),
                                                                      ),
                                                                      dropdownColor: Color(0xFF000000),
                                                                      //focusColor: Color(0xFFdb9e1f),
                                                                      style: TextStyle(color: Colors.white),
                                                                      isExpanded: true,
                                                                      value: numOfBeds,
                                                                      items: bedCount.map(buildMenuItemBedDetails).toList(),
                                                                      onChanged: (value) => setState(() {
                                                                            this.numOfBeds =
                                                                                value as String?;
                                                                          })),
                                                                ),
                                                              ),
                                                              Container(
                                                                width: 170.0,
                                                                height: 50.0,
                                                                child: Padding(
                                                                  padding: const EdgeInsets
                                                                          .symmetric(
                                                                      horizontal:
                                                                          8.0),
                                                                  child:
                                                                      ElevatedButton
                                                                          .icon(
                                                                    style: ElevatedButton.styleFrom(
                                                                        primary: Color(0xFF000000),
                                                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(00.0)), side: BorderSide(color: Color(0xFFdb9e1f))),
                                                                        side: BorderSide(
                                                                          width:
                                                                              2.5,
                                                                          color:
                                                                              Color(0xFFdb9e1f),
                                                                        ),
                                                                        textStyle: const TextStyle(fontSize: 16)),
                                                                    onPressed:
                                                                        () {
                                                                      setState(
                                                                          () {
                                                                        typesOfBedsAndCount
                                                                            .add("${numOfBeds} - ${bedType}");
                                                                      });
                                                                    },
                                                                    icon: Icon(
                                                                      Icons.add,
                                                                      color: Colors
                                                                          .white,
                                                                      size: 20,
                                                                    ),
                                                                    label: Text(
                                                                      "Bed Type",
                                                                      style: TextStyle(
                                                                          color:
                                                                              Colors.white),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                          SizedBox(
                                                            height: 40.0,
                                                          ),
                                                          Align(
                                                            alignment: Alignment
                                                                .topLeft,
                                                            child: Text(
                                                                "Type of Beds",
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .white70,
                                                                    fontSize:
                                                                        16)),
                                                          ),
                                                          SizedBox(
                                                              height: 20.0),
                                                          Container(
                                                            height: 150.0,
                                                            width: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width /
                                                                1.6,
                                                            decoration: BoxDecoration(
                                                                border: Border.all(
                                                                    color: Color(
                                                                        0xFFdb9e1f))),
                                                            child: ListView
                                                                .builder(
                                                                    itemCount:
                                                                        typesOfBedsAndCount
                                                                            .length,
                                                                    itemBuilder:
                                                                        (BuildContext
                                                                                context,
                                                                            int index) {
                                                                      return new ListTile(
                                                                        title:
                                                                            Text(
                                                                          typesOfBedsAndCount[
                                                                              index],
                                                                          style:
                                                                              TextStyle(color: Colors.white70),
                                                                        ),
                                                                        trailing: IconButton(
                                                                            icon: Icon(
                                                                              Icons.delete,
                                                                              color: Color(0xFFdb9e1f),
                                                                            ),
                                                                            onPressed: () {
                                                                              setState(() {
                                                                                typesOfBedsAndCount.remove(typesOfBedsAndCount[index]);
                                                                              });
                                                                            }),
                                                                      );
                                                                    }),
                                                          ),
                                                          SizedBox(
                                                              height: 20.0),
                                                          Container(
                                                            width: 170.0,
                                                            height: 50.0,
                                                            child: Padding(
                                                              padding: const EdgeInsets
                                                                      .symmetric(
                                                                  horizontal:
                                                                      8.0),
                                                              child:
                                                                  ElevatedButton
                                                                      .icon(
                                                                style: ElevatedButton
                                                                    .styleFrom(
                                                                        primary:
                                                                            Color(
                                                                                0xFF000000),
                                                                        shape: RoundedRectangleBorder(
                                                                            borderRadius: BorderRadius.all(Radius.circular(
                                                                                00.0)),
                                                                            side: BorderSide(
                                                                                color: Color(
                                                                                    0xFFdb9e1f))),
                                                                        side:
                                                                            BorderSide(
                                                                          width:
                                                                              2.5,
                                                                          color:
                                                                              Color(0xFFdb9e1f),
                                                                        ),
                                                                        textStyle:
                                                                            const TextStyle(fontSize: 16)),
                                                                onPressed: () {
                                                                  setState(() {
                                                                    roomTypeDetails
                                                                        .add(
                                                                            adults!);
                                                                    roomTypeDetails
                                                                        .add(
                                                                            children!);
                                                                    for (int i =
                                                                            0;
                                                                        i < typesOfBedsAndCount.length;
                                                                        i++) {
                                                                      roomTypeDetails.add(
                                                                          typesOfBedsAndCount[
                                                                              i]);
                                                                    }

                                                                    roomTypeDetails.add(
                                                                        startingPriceController
                                                                            .text);
                                                                    roomDeatils.putIfAbsent(
                                                                        roomType!,
                                                                        () =>
                                                                            roomTypeDetails);
                                                                    typesOfBedsAndCount =
                                                                        [];
                                                                    roomTypeDetails =
                                                                        [];
                                                                  });
                                                                  print(
                                                                      roomDeatils);
                                                                },
                                                                icon: Icon(
                                                                  Icons.add,
                                                                  color: Colors
                                                                      .white,
                                                                  size: 20,
                                                                ),
                                                                label: Text(
                                                                  "Add Room",
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .white),
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                          SizedBox(
                                                              height: 20.0),
                                                          Align(
                                                            alignment: Alignment
                                                                .topLeft,
                                                            child: Text(
                                                                "Type of Rooms",
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .white70,
                                                                    fontSize:
                                                                        16)),
                                                          ),
                                                          SizedBox(
                                                              height: 20.0),
                                                          Container(
                                                              height: 150.0,
                                                              width: MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width /
                                                                  1.6,
                                                              decoration: BoxDecoration(
                                                                  border: Border.all(
                                                                      color: Color(
                                                                          0xFFdb9e1f))),
                                                              child: ListView(
                                                                children: roomDeatils
                                                                    .entries
                                                                    .map((entry) =>
                                                                        new ListTile(
                                                                          leading: Text(entry.value[0] +
                                                                              " - Adult" +
                                                                              " & " +
                                                                              entry.value[1] +
                                                                              " - Children"),
                                                                          title:
                                                                              Padding(
                                                                            padding:
                                                                                const EdgeInsets.only(left: 200.0, top: 00.0),
                                                                            child:
                                                                                Row(
                                                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                              crossAxisAlignment: CrossAxisAlignment.center,
                                                                              children: [
                                                                                Text(entry.key),
                                                                                Padding(
                                                                                  padding: const EdgeInsets.only(right: 70.0, top: 10.0),
                                                                                  child: Text(entry.value[entry.value.length - 1] + " AED"),
                                                                                ),
                                                                              ],
                                                                            ),
                                                                          ),
                                                                          subtitle:
                                                                              Padding(
                                                                            padding:
                                                                                const EdgeInsets.only(left: 200.0, top: 10.0),
                                                                            child:
                                                                                Text(entry.value.getRange(2, entry.value.length - 1).toString()),
                                                                          ),
                                                                          isThreeLine:
                                                                              true,
                                                                          trailing: IconButton(
                                                                              icon: Icon(
                                                                                Icons.delete,
                                                                                color: Color(0xFFdb9e1f),
                                                                              ),
                                                                              onPressed: () {
                                                                                setState(() {
                                                                                  roomDeatils.remove(entry.key);
                                                                                });
                                                                                print(roomDeatils);
                                                                              }),
                                                                        ))
                                                                    .toList(),
                                                              ))
                                                        ],
                                                      ),
                                                    )
                                                  : SizedBox(
                                                      height: 0,
                                                    )
                                            ],
                                          ),
                                        ),
                                        SizedBox(
                                          height: 30,
                                        ),
                                        const Align(
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                            "apartment Cover Photo",
                                            style: TextStyle(
                                                color: Colors.white70,
                                                fontSize: 16),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 15,
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Container(
                                            width: 270.0,
                                            height: 50.0,
                                            child: ElevatedButton.icon(
                                              style: ElevatedButton.styleFrom(
                                                  primary: Color(0xFF000000),
                                                  shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  20.0)),
                                                      side: BorderSide(
                                                          color: Color(
                                                              0xFFdb9e1f))),
                                                  side: BorderSide(
                                                    width: 2.5,
                                                    color: Color(0xFFdb9e1f),
                                                  ),
                                                  textStyle: const TextStyle(
                                                      fontSize: 16)),
                                              onPressed: () {
                                                selectFileandUpload();
                                              },
                                              icon: Icon(
                                                Icons.add_a_photo,
                                                color: Colors.white,
                                                size: 20,
                                              ), //icon data for elevated button
                                              label: Text(
                                                "apartment Cover Photo",
                                                style: TextStyle(
                                                    color: Colors.white),
                                              ),
                                              /*child: const Text(
                                                'apartment Cover Photo',
                                                style: TextStyle(
                                                    color: Colors.white),
                                              ),*/
                                            ),
                                          ),
                                        ),
                                        apartmentCoverImageList.length != 0
                                            ? Container(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width /
                                                    1.6,
                                                height: 160,
                                                child: GridView.builder(
                                                    itemCount:
                                                        apartmentCoverImageList
                                                            .length,
                                                    gridDelegate:
                                                        SliverGridDelegateWithFixedCrossAxisCount(
                                                            crossAxisCount: 7),
                                                    itemBuilder:
                                                        (BuildContext context,
                                                            int index) {
                                                      return Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(top: 8.0),
                                                        child: Container(
                                                            height: 100,
                                                            width: 100,
                                                            decoration: BoxDecoration(
                                                                image: DecorationImage(
                                                                    image: NetworkImage(
                                                                        apartmentCoverImageList[
                                                                            index]),
                                                                    fit: BoxFit
                                                                        .cover)),
                                                            child: IconButton(
                                                              icon: Icon(
                                                                Icons.delete,
                                                                color: Color(
                                                                    0xFFdb9e1f),
                                                                size: 40.0,
                                                              ),
                                                              onPressed: () {
                                                                _removeapartmentCoverPhoto(
                                                                    apartmentCoverImageList[
                                                                        index]);
                                                              },
                                                            )),
                                                      );
                                                      //Text('Image : ' + index.toString());
                                                    }),
                                              )
                                            : Container(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width /
                                                    1.6,
                                                height: 160,
                                                child: GridView.builder(
                                                    itemCount:
                                                        coverImage.length,
                                                    gridDelegate:
                                                        SliverGridDelegateWithFixedCrossAxisCount(
                                                            crossAxisCount: 7),
                                                    itemBuilder:
                                                        (BuildContext context,
                                                            int index) {
                                                      return Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(top: 8.0),
                                                        child: Container(
                                                            height: 100,
                                                            width: 100,
                                                            decoration: BoxDecoration(
                                                                image: DecorationImage(
                                                                    image: MemoryImage(
                                                                        coverImage[
                                                                            index]),
                                                                    fit: BoxFit
                                                                        .cover))),
                                                      );
                                                      //Text('Image : ' + index.toString());
                                                    }),
                                              ),
                                        SizedBox(
                                          height: 30,
                                        ),
                                        const Align(
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                            "Other apartment Photos",
                                            style: TextStyle(
                                                color: Colors.white70,
                                                fontSize: 16),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 15,
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Container(
                                            width: 270.0,
                                            height: 50.0,
                                            child: ElevatedButton.icon(
                                              style: ElevatedButton.styleFrom(
                                                  primary: Color(0xFF000000),
                                                  shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  20.0)),
                                                      side: BorderSide(
                                                          color: Color(
                                                              0xFFdb9e1f))),
                                                  side: BorderSide(
                                                    width: 2.5,
                                                    color: Color(0xFFdb9e1f),
                                                  ),
                                                  textStyle: const TextStyle(
                                                      fontSize: 16)),
                                              onPressed: () {
                                                selectOtherFileandUpload();
                                              },
                                              icon: Icon(
                                                Icons.add_a_photo,
                                                color: Colors.white,
                                                size: 20,
                                              ), //icon data for elevated button
                                              label: Text(
                                                "Other apartment Photos",
                                                style: TextStyle(
                                                    color: Colors.white),
                                              ),
                                              /*child: const Text(
                                                'apartment Cover Photo',
                                                style: TextStyle(
                                                    color: Colors.white),
                                              ),*/
                                            ),
                                          ), /*Container(
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                InkWell(
                                                  onTap: () {
                                                    //selectImage();
                                                    //selectFile();
                                                    selectOtherFileandUpload();
                                                  },
                                                  child: Container(
                                                    height: 100.0,
                                                    width: 100.0,
                                                    decoration: BoxDecoration(
                                                        border: Border.all(
                                                            color: Color(
                                                                0xFFdb9e1f))),
                                                    child: Icon(Icons.add),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),*/
                                        ),
                                        OtherapartmentImagesUrl.length != 0
                                            ? Container(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width /
                                                    1.6,
                                                height: 160,
                                                child: GridView.builder(
                                                    itemCount:
                                                        OtherapartmentImagesUrl
                                                            .length,
                                                    gridDelegate:
                                                        SliverGridDelegateWithFixedCrossAxisCount(
                                                            crossAxisCount: 8),
                                                    itemBuilder:
                                                        (BuildContext context,
                                                            int index) {
                                                      return Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(top: 8.0),
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(8.0),
                                                          child: Container(
                                                              height: 100,
                                                              width: 100,
                                                              decoration: BoxDecoration(
                                                                  image: DecorationImage(
                                                                      image: NetworkImage(
                                                                          OtherapartmentImagesUrl[
                                                                              index]),
                                                                      fit: BoxFit
                                                                          .cover)),
                                                              child: IconButton(
                                                                icon: Icon(
                                                                  Icons.delete,
                                                                  color: Color(
                                                                      0xFFdb9e1f),
                                                                  size: 40.0,
                                                                ),
                                                                onPressed: () {
                                                                  _removeOtherapartmentPhotos(
                                                                      OtherapartmentImagesUrl[
                                                                          index]);
                                                                },
                                                              )),
                                                        ),
                                                      );
                                                      //Text('Image : ' + index.toString());
                                                    }),
                                              )
                                            : SizedBox(
                                                height: 10,
                                              ),
                                        otherImage.length != 0
                                            ? Container(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width /
                                                    1.6,
                                                height: 160,
                                                child: GridView.builder(
                                                    itemCount:
                                                        otherImage.length,
                                                    gridDelegate:
                                                        SliverGridDelegateWithFixedCrossAxisCount(
                                                            crossAxisCount: 8),
                                                    itemBuilder:
                                                        (BuildContext context,
                                                            int index) {
                                                      return Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(top: 8.0),
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(8.0),
                                                          child: Container(
                                                              height: 100,
                                                              width: 100,
                                                              decoration: BoxDecoration(
                                                                  image: DecorationImage(
                                                                      image: MemoryImage(
                                                                          otherImage[
                                                                              index]),
                                                                      fit: BoxFit
                                                                          .cover))),
                                                        ),
                                                      );
                                                      //Text('Image : ' + index.toString());
                                                    }),
                                              )
                                            : SizedBox(
                                                height: 10,
                                              ),
                                        SizedBox(
                                          height: 20,
                                        ),
                                        Align(
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                            "Main Facilities",
                                            style: TextStyle(
                                                color: Colors.white70,
                                                fontSize: 16),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Container(
                                          child: Column(
                                            children: [
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceAround,
                                                //crossAxisAlignment:
                                                //CrossAxisAlignment.center,
                                                children: [
                                                  MainFacilitiesCheckBox(
                                                    checkBoxText:
                                                        "Swimming Pool",
                                                    checkBoxValue:
                                                        mainFacilitiesBoolValue,
                                                    mainFacilities:
                                                        mainFacilities,
                                                  ),
                                                  MainFacilitiesCheckBox(
                                                    checkBoxText:
                                                        "Fitness Center",
                                                    checkBoxValue:
                                                        mainFacilitiesBoolValue,
                                                    mainFacilities:
                                                        mainFacilities,
                                                  ),
                                                  MainFacilitiesCheckBox(
                                                    checkBoxText:
                                                        "Airport Shuttle",
                                                    checkBoxValue:
                                                        mainFacilitiesBoolValue,
                                                    mainFacilities:
                                                        mainFacilities,
                                                  ),
                                                  MainFacilitiesCheckBox(
                                                    checkBoxText:
                                                        "Non-smoking rooms",
                                                    checkBoxValue:
                                                        mainFacilitiesBoolValue,
                                                    mainFacilities:
                                                        mainFacilities,
                                                  ),
                                                ],
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceAround,
                                                children: [
                                                  MainFacilitiesCheckBox(
                                                    checkBoxText: "Spa",
                                                    checkBoxValue:
                                                        mainFacilitiesBoolValue,
                                                    mainFacilities:
                                                        mainFacilities,
                                                  ),
                                                  MainFacilitiesCheckBox(
                                                    checkBoxText: "Restaurant",
                                                    checkBoxValue:
                                                        mainFacilitiesBoolValue,
                                                    mainFacilities:
                                                        mainFacilities,
                                                  ),
                                                  MainFacilitiesCheckBox(
                                                    checkBoxText:
                                                        "Room service",
                                                    checkBoxValue:
                                                        mainFacilitiesBoolValue,
                                                    mainFacilities:
                                                        mainFacilities,
                                                  ),
                                                  MainFacilitiesCheckBox(
                                                    checkBoxText: "Bar",
                                                    checkBoxValue:
                                                        mainFacilitiesBoolValue,
                                                    mainFacilities:
                                                        mainFacilities,
                                                  ),
                                                ],
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceAround,
                                                children: [
                                                  MainFacilitiesCheckBox(
                                                    checkBoxText: "Breakfast",
                                                    checkBoxValue:
                                                        mainFacilitiesBoolValue,
                                                    mainFacilities:
                                                        mainFacilities,
                                                  ),
                                                  MainFacilitiesCheckBox(
                                                    checkBoxText:
                                                        "WiFi in all areas",
                                                    checkBoxValue:
                                                        mainFacilitiesBoolValue,
                                                    mainFacilities:
                                                        mainFacilities,
                                                  ),
                                                  MainFacilitiesCheckBox(
                                                    checkBoxText:
                                                        "Tea/Coffee Maker in All Rooms",
                                                    checkBoxValue:
                                                        mainFacilitiesBoolValue,
                                                    mainFacilities:
                                                        mainFacilities,
                                                  ),
                                                  MainFacilitiesCheckBox(
                                                    checkBoxText:
                                                        "Facilities for disabled guests",
                                                    checkBoxValue:
                                                        mainFacilitiesBoolValue,
                                                    mainFacilities:
                                                        mainFacilities,
                                                  ),
                                                ],
                                              )
                                            ],
                                          ),
                                        ),
                                        SizedBox(
                                          height: 20,
                                        ),
                                        const Align(
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                            "Sub-Facilities",
                                            style: TextStyle(
                                                color: Colors.white70,
                                                fontSize: 16),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Container(
                                          child: Column(
                                            children: [
                                              Column(
                                                children: [
                                                  const Align(
                                                    alignment:
                                                        Alignment.centerLeft,
                                                    child: Text(
                                                      "Bathroom",
                                                      style: TextStyle(
                                                          color: Colors.white70,
                                                          fontSize: 16),
                                                    ),
                                                  ),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceAround,
                                                    children: [
                                                      SubFacilitiesCheckBoxWidget(
                                                        checkBoxCategory:
                                                            "Bathroom",
                                                        checkBoxText: 'Towels',
                                                        checkBoxValue:
                                                            subFacilitiesBoolValue,
                                                        subFacilities:
                                                            subFacilities,
                                                      ),
                                                      SubFacilitiesCheckBoxWidget(
                                                        checkBoxCategory:
                                                            "Bathroom",
                                                        checkBoxText:
                                                            'Bathtub or shower',
                                                        checkBoxValue:
                                                            subFacilitiesBoolValue,
                                                        subFacilities:
                                                            subFacilities,
                                                      ),
                                                      SubFacilitiesCheckBoxWidget(
                                                        checkBoxCategory:
                                                            "Bathroom",
                                                        checkBoxText:
                                                            'Slippers',
                                                        checkBoxValue:
                                                            subFacilitiesBoolValue,
                                                        subFacilities:
                                                            subFacilities,
                                                      ),
                                                      SubFacilitiesCheckBoxWidget(
                                                        checkBoxCategory:
                                                            "Bathroom",
                                                        checkBoxText:
                                                            'Private Bathroom',
                                                        checkBoxValue:
                                                            subFacilitiesBoolValue,
                                                        subFacilities:
                                                            subFacilities,
                                                      ),
                                                    ],
                                                  ),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceAround,
                                                    children: [
                                                      SubFacilitiesCheckBoxWidget(
                                                        checkBoxCategory:
                                                            "Bathroom",
                                                        checkBoxText: 'Toilet',
                                                        checkBoxValue:
                                                            subFacilitiesBoolValue,
                                                        subFacilities:
                                                            subFacilities,
                                                      ),
                                                      SubFacilitiesCheckBoxWidget(
                                                        checkBoxCategory:
                                                            "Bathroom",
                                                        checkBoxText:
                                                            'Free toiletries',
                                                        checkBoxValue:
                                                            subFacilitiesBoolValue,
                                                        subFacilities:
                                                            subFacilities,
                                                      ),
                                                      SubFacilitiesCheckBoxWidget(
                                                        checkBoxCategory:
                                                            "Bathroom",
                                                        checkBoxText:
                                                            'Bathrobe',
                                                        checkBoxValue:
                                                            subFacilitiesBoolValue,
                                                        subFacilities:
                                                            subFacilities,
                                                      ),
                                                      SubFacilitiesCheckBoxWidget(
                                                        checkBoxCategory:
                                                            "Bathroom",
                                                        checkBoxText:
                                                            'Hairdryer',
                                                        checkBoxValue:
                                                            subFacilitiesBoolValue,
                                                        subFacilities:
                                                            subFacilities,
                                                      ),
                                                    ],
                                                  ),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceAround,
                                                    children: [
                                                      SubFacilitiesCheckBoxWidget(
                                                        checkBoxCategory:
                                                            "Bathroom",
                                                        checkBoxText: 'Bathtub',
                                                        checkBoxValue:
                                                            subFacilitiesBoolValue,
                                                        subFacilities:
                                                            subFacilities,
                                                      ),
                                                      SubFacilitiesCheckBoxWidget(
                                                        checkBoxCategory:
                                                            "Bathroom",
                                                        checkBoxText: 'Shower',
                                                        checkBoxValue:
                                                            subFacilitiesBoolValue,
                                                        subFacilities:
                                                            subFacilities,
                                                      ),
                                                      Expanded(
                                                          child: SizedBox()),
                                                      Expanded(
                                                          child: SizedBox()),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                              Column(
                                                children: [
                                                  const Align(
                                                    alignment:
                                                        Alignment.centerLeft,
                                                    child: Text(
                                                      "Bedroom",
                                                      style: TextStyle(
                                                          color: Colors.white70,
                                                          fontSize: 16),
                                                    ),
                                                  ),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceAround,
                                                    children: [
                                                      SubFacilitiesCheckBoxWidget(
                                                        checkBoxCategory:
                                                            "Bedroom",
                                                        checkBoxText: 'Linens',
                                                        checkBoxValue:
                                                            subFacilitiesBoolValue,
                                                        subFacilities:
                                                            subFacilities,
                                                      ),
                                                      SubFacilitiesCheckBoxWidget(
                                                        checkBoxCategory:
                                                            "Bedroom",
                                                        checkBoxText:
                                                            'Wardrobe or closet',
                                                        checkBoxValue:
                                                            subFacilitiesBoolValue,
                                                        subFacilities:
                                                            subFacilities,
                                                      ),
                                                      SubFacilitiesCheckBoxWidget(
                                                        checkBoxCategory:
                                                            "Bedroom",
                                                        checkBoxText:
                                                            'Alarm clock',
                                                        checkBoxValue:
                                                            subFacilitiesBoolValue,
                                                        subFacilities:
                                                            subFacilities,
                                                      ),
                                                      Expanded(
                                                          child: SizedBox()),
                                                    ],
                                                  )
                                                ],
                                              ),
                                              Column(
                                                children: [
                                                  const Align(
                                                    alignment:
                                                        Alignment.centerLeft,
                                                    child: Text(
                                                      "View",
                                                      style: TextStyle(
                                                          color: Colors.white70,
                                                          fontSize: 16),
                                                    ),
                                                  ),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceAround,
                                                    children: [
                                                      SubFacilitiesCheckBoxWidget(
                                                        checkBoxCategory:
                                                            "View",
                                                        checkBoxText: 'View',
                                                        checkBoxValue:
                                                            subFacilitiesBoolValue,
                                                        subFacilities:
                                                            subFacilities,
                                                      ),
                                                    ],
                                                  )
                                                ],
                                              ),
                                              Column(
                                                children: [
                                                  const Align(
                                                    alignment:
                                                        Alignment.centerLeft,
                                                    child: Text(
                                                      "Outdoors",
                                                      style: TextStyle(
                                                          color: Colors.white70,
                                                          fontSize: 16),
                                                    ),
                                                  ),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceAround,
                                                    children: [
                                                      SubFacilitiesCheckBoxWidget(
                                                        checkBoxCategory:
                                                            "Outdoors",
                                                        checkBoxText:
                                                            'Sun deck',
                                                        checkBoxValue:
                                                            subFacilitiesBoolValue,
                                                        subFacilities:
                                                            subFacilities,
                                                      ),
                                                      SubFacilitiesCheckBoxWidget(
                                                        checkBoxCategory:
                                                            "Outdoors",
                                                        checkBoxText: 'Terrace',
                                                        checkBoxValue:
                                                            subFacilitiesBoolValue,
                                                        subFacilities:
                                                            subFacilities,
                                                      ),
                                                      Expanded(
                                                          child: SizedBox()),
                                                      Expanded(
                                                          child: SizedBox()),
                                                    ],
                                                  )
                                                ],
                                              ),
                                              Column(
                                                children: [
                                                  const Align(
                                                    alignment:
                                                        Alignment.centerLeft,
                                                    child: Text(
                                                      "Kitchen",
                                                      style: TextStyle(
                                                          color: Colors.white70,
                                                          fontSize: 16),
                                                    ),
                                                  ),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceAround,
                                                    children: [
                                                      SubFacilitiesCheckBoxWidget(
                                                        checkBoxCategory:
                                                            "Kitchen",
                                                        checkBoxText:
                                                            'Electric kettle',
                                                        checkBoxValue:
                                                            subFacilitiesBoolValue,
                                                        subFacilities:
                                                            subFacilities,
                                                      ),
                                                    ],
                                                  )
                                                ],
                                              ),
                                              Column(
                                                children: [
                                                  const Align(
                                                    alignment:
                                                        Alignment.centerLeft,
                                                    child: Text(
                                                      "Rooms Amenities",
                                                      style: TextStyle(
                                                          color: Colors.white70,
                                                          fontSize: 16),
                                                    ),
                                                  ),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceAround,
                                                    children: [
                                                      SubFacilitiesCheckBoxWidget(
                                                        checkBoxCategory:
                                                            "Rooms Amenities",
                                                        checkBoxText:
                                                            'Clothes rack',
                                                        checkBoxValue:
                                                            subFacilitiesBoolValue,
                                                        subFacilities:
                                                            subFacilities,
                                                      ),
                                                    ],
                                                  )
                                                ],
                                              ),
                                              Column(
                                                children: [
                                                  const Align(
                                                    alignment:
                                                        Alignment.centerLeft,
                                                    child: Text(
                                                      "Activities",
                                                      style: TextStyle(
                                                          color: Colors.white70,
                                                          fontSize: 16),
                                                    ),
                                                  ),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceAround,
                                                    children: [
                                                      SubFacilitiesCheckBoxWidget(
                                                        checkBoxCategory:
                                                            "Activities",
                                                        checkBoxText:
                                                            'Live sports events',
                                                        checkBoxValue:
                                                            subFacilitiesBoolValue,
                                                        subFacilities:
                                                            subFacilities,
                                                      ),
                                                      SubFacilitiesCheckBoxWidget(
                                                        checkBoxCategory:
                                                            "Activities",
                                                        checkBoxText:
                                                            'Happy hour',
                                                        checkBoxValue:
                                                            subFacilitiesBoolValue,
                                                        subFacilities:
                                                            subFacilities,
                                                      ),
                                                      SubFacilitiesCheckBoxWidget(
                                                        checkBoxCategory:
                                                            "Activities",
                                                        checkBoxText:
                                                            'Themed dinners',
                                                        checkBoxValue:
                                                            subFacilitiesBoolValue,
                                                        subFacilities:
                                                            subFacilities,
                                                      ),
                                                      SubFacilitiesCheckBoxWidget(
                                                        checkBoxCategory:
                                                            "Activities",
                                                        checkBoxText:
                                                            'Evening entertainment',
                                                        checkBoxValue:
                                                            subFacilitiesBoolValue,
                                                        subFacilities:
                                                            subFacilities,
                                                      ),
                                                    ],
                                                  ),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceAround,
                                                    children: [
                                                      SubFacilitiesCheckBoxWidget(
                                                        checkBoxCategory:
                                                            "Activities",
                                                        checkBoxText: 'Darts',
                                                        checkBoxValue:
                                                            subFacilitiesBoolValue,
                                                        subFacilities:
                                                            subFacilities,
                                                      ),
                                                      SubFacilitiesCheckBoxWidget(
                                                        checkBoxCategory:
                                                            "Activities",
                                                        checkBoxText:
                                                            'Pool table',
                                                        checkBoxValue:
                                                            subFacilitiesBoolValue,
                                                        subFacilities:
                                                            subFacilities,
                                                      ),
                                                      SubFacilitiesCheckBoxWidget(
                                                        checkBoxCategory:
                                                            "Activities",
                                                        checkBoxText:
                                                            'Playground',
                                                        checkBoxValue:
                                                            subFacilitiesBoolValue,
                                                        subFacilities:
                                                            subFacilities,
                                                      ),
                                                      Expanded(
                                                          child: SizedBox()),
                                                    ],
                                                  )
                                                ],
                                              ),
                                              Column(
                                                children: [
                                                  const Align(
                                                    alignment:
                                                        Alignment.centerLeft,
                                                    child: Text(
                                                      "Living Area",
                                                      style: TextStyle(
                                                          color: Colors.white70,
                                                          fontSize: 16),
                                                    ),
                                                  ),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceAround,
                                                    children: [
                                                      SubFacilitiesCheckBoxWidget(
                                                        checkBoxCategory:
                                                            "Living Area",
                                                        checkBoxText: 'Desk',
                                                        checkBoxValue:
                                                            subFacilitiesBoolValue,
                                                        subFacilities:
                                                            subFacilities,
                                                      ),
                                                    ],
                                                  )
                                                ],
                                              ),
                                              Column(
                                                children: [
                                                  const Align(
                                                    alignment:
                                                        Alignment.centerLeft,
                                                    child: Text(
                                                      "Media & Technology",
                                                      style: TextStyle(
                                                          color: Colors.white70,
                                                          fontSize: 16),
                                                    ),
                                                  ),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceAround,
                                                    children: [
                                                      SubFacilitiesCheckBoxWidget(
                                                        checkBoxCategory:
                                                            "Media & Technology",
                                                        checkBoxText:
                                                            'Flat-screen TV',
                                                        checkBoxValue:
                                                            subFacilitiesBoolValue,
                                                        subFacilities:
                                                            subFacilities,
                                                      ),
                                                      SubFacilitiesCheckBoxWidget(
                                                        checkBoxCategory:
                                                            "Media & Technology",
                                                        checkBoxText:
                                                            'Telephone',
                                                        checkBoxValue:
                                                            subFacilitiesBoolValue,
                                                        subFacilities:
                                                            subFacilities,
                                                      ),
                                                      SubFacilitiesCheckBoxWidget(
                                                        checkBoxCategory:
                                                            "Media & Technology",
                                                        checkBoxText: 'TV',
                                                        checkBoxValue:
                                                            subFacilitiesBoolValue,
                                                        subFacilities:
                                                            subFacilities,
                                                      ),
                                                      Expanded(
                                                          child: SizedBox()),
                                                    ],
                                                  )
                                                ],
                                              ),
                                              Column(
                                                children: [
                                                  const Align(
                                                    alignment:
                                                        Alignment.centerLeft,
                                                    child: Text(
                                                      "Food & Drink",
                                                      style: TextStyle(
                                                          color: Colors.white70,
                                                          fontSize: 16),
                                                    ),
                                                  ),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceAround,
                                                    children: [
                                                      SubFacilitiesCheckBoxWidget(
                                                        checkBoxCategory:
                                                            "Food & Drink",
                                                        checkBoxText:
                                                            'Coffee house on site',
                                                        checkBoxValue:
                                                            subFacilitiesBoolValue,
                                                        subFacilities:
                                                            subFacilities,
                                                      ),
                                                      SubFacilitiesCheckBoxWidget(
                                                        checkBoxCategory:
                                                            "Food & Drink",
                                                        checkBoxText:
                                                            'Restaurant',
                                                        checkBoxValue:
                                                            subFacilitiesBoolValue,
                                                        subFacilities:
                                                            subFacilities,
                                                      ),
                                                      SubFacilitiesCheckBoxWidget(
                                                        checkBoxCategory:
                                                            "Food & Drink",
                                                        checkBoxText:
                                                            'Tea/Coffee maker',
                                                        checkBoxValue:
                                                            subFacilitiesBoolValue,
                                                        subFacilities:
                                                            subFacilities,
                                                      ),
                                                      Expanded(
                                                          child: SizedBox()),
                                                    ],
                                                  )
                                                ],
                                              ),
                                              Column(
                                                children: [
                                                  const Align(
                                                    alignment:
                                                        Alignment.centerLeft,
                                                    child: Text(
                                                      "Internet",
                                                      style: TextStyle(
                                                          color: Colors.white70,
                                                          fontSize: 16),
                                                    ),
                                                  ),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceAround,
                                                    children: [
                                                      SubFacilitiesCheckBoxWidget(
                                                        checkBoxCategory:
                                                            "Internet",
                                                        checkBoxText:
                                                            'WiFi is available in the apartment rooms and is free of charge',
                                                        checkBoxValue:
                                                            subFacilitiesBoolValue,
                                                        subFacilities:
                                                            subFacilities,
                                                      ),
                                                    ],
                                                  )
                                                ],
                                              ),
                                              Column(
                                                children: [
                                                  const Align(
                                                    alignment:
                                                        Alignment.centerLeft,
                                                    child: Text(
                                                      "Parking",
                                                      style: TextStyle(
                                                          color: Colors.white70,
                                                          fontSize: 16),
                                                    ),
                                                  ),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceAround,
                                                    children: [
                                                      SubFacilitiesCheckBoxWidget(
                                                        checkBoxCategory:
                                                            "Parking",
                                                        checkBoxText:
                                                            'Accessible parking',
                                                        checkBoxValue:
                                                            subFacilitiesBoolValue,
                                                        subFacilities:
                                                            subFacilities,
                                                      ),
                                                      SubFacilitiesCheckBoxWidget(
                                                        checkBoxCategory:
                                                            "Parking",
                                                        checkBoxText:
                                                            'Parking garage',
                                                        checkBoxValue:
                                                            subFacilitiesBoolValue,
                                                        subFacilities:
                                                            subFacilities,
                                                      ),
                                                      Expanded(
                                                          child: SizedBox()),
                                                      Expanded(
                                                          child: SizedBox()),
                                                    ],
                                                  )
                                                ],
                                              ),
                                              Column(
                                                children: [
                                                  const Align(
                                                    alignment:
                                                        Alignment.centerLeft,
                                                    child: Text(
                                                      "Transportation",
                                                      style: TextStyle(
                                                          color: Colors.white70,
                                                          fontSize: 16),
                                                    ),
                                                  ),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceAround,
                                                    children: [
                                                      SubFacilitiesCheckBoxWidget(
                                                        checkBoxCategory:
                                                            "Transportation",
                                                        checkBoxText:
                                                            'Airport drop-off',
                                                        checkBoxValue:
                                                            subFacilitiesBoolValue,
                                                        subFacilities:
                                                            subFacilities,
                                                      ),
                                                      SubFacilitiesCheckBoxWidget(
                                                        checkBoxCategory:
                                                            "Transportation",
                                                        checkBoxText:
                                                            'Airport pickup',
                                                        checkBoxValue:
                                                            subFacilitiesBoolValue,
                                                        subFacilities:
                                                            subFacilities,
                                                      ),
                                                      Expanded(
                                                          child: SizedBox()),
                                                      Expanded(
                                                          child: SizedBox()),
                                                    ],
                                                  )
                                                ],
                                              ),
                                              Column(
                                                children: [
                                                  const Align(
                                                    alignment:
                                                        Alignment.centerLeft,
                                                    child: Text(
                                                      "Front Desk Services",
                                                      style: TextStyle(
                                                          color: Colors.white70,
                                                          fontSize: 16),
                                                    ),
                                                  ),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceAround,
                                                    children: [
                                                      SubFacilitiesCheckBoxWidget(
                                                        checkBoxCategory:
                                                            "Front Desk Services",
                                                        checkBoxText:
                                                            'Concierge',
                                                        checkBoxValue:
                                                            subFacilitiesBoolValue,
                                                        subFacilities:
                                                            subFacilities,
                                                      ),
                                                      SubFacilitiesCheckBoxWidget(
                                                        checkBoxCategory:
                                                            "Front Desk Services",
                                                        checkBoxText:
                                                            'Baggage storage',
                                                        checkBoxValue:
                                                            subFacilitiesBoolValue,
                                                        subFacilities:
                                                            subFacilities,
                                                      ),
                                                      SubFacilitiesCheckBoxWidget(
                                                        checkBoxCategory:
                                                            "Front Desk Services",
                                                        checkBoxText:
                                                            'Tour desk',
                                                        checkBoxValue:
                                                            subFacilitiesBoolValue,
                                                        subFacilities:
                                                            subFacilities,
                                                      ),
                                                      SubFacilitiesCheckBoxWidget(
                                                        checkBoxCategory:
                                                            "Front Desk Services",
                                                        checkBoxText:
                                                            'Currency exchange',
                                                        checkBoxValue:
                                                            subFacilitiesBoolValue,
                                                        subFacilities:
                                                            subFacilities,
                                                      ),
                                                    ],
                                                  ),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceAround,
                                                    children: [
                                                      SubFacilitiesCheckBoxWidget(
                                                        checkBoxCategory:
                                                            "Front Desk Services",
                                                        checkBoxText:
                                                            '24-hour front desk',
                                                        checkBoxValue:
                                                            subFacilitiesBoolValue,
                                                        subFacilities:
                                                            subFacilities,
                                                      ),
                                                    ],
                                                  )
                                                ],
                                              ),
                                              Column(
                                                children: [
                                                  const Align(
                                                    alignment:
                                                        Alignment.centerLeft,
                                                    child: Text(
                                                      "Entertainment & Family Services",
                                                      style: TextStyle(
                                                          color: Colors.white70,
                                                          fontSize: 16),
                                                    ),
                                                  ),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceAround,
                                                    children: [
                                                      SubFacilitiesCheckBoxWidget(
                                                        checkBoxCategory:
                                                            "Entertainment & Family Services",
                                                        checkBoxText:
                                                            'Outdoor play equipment for kids',
                                                        checkBoxValue:
                                                            subFacilitiesBoolValue,
                                                        subFacilities:
                                                            subFacilities,
                                                      ),
                                                      SubFacilitiesCheckBoxWidget(
                                                        checkBoxCategory:
                                                            "Entertainment & Family Services",
                                                        checkBoxText:
                                                            'Babysitting/Child services',
                                                        checkBoxValue:
                                                            subFacilitiesBoolValue,
                                                        subFacilities:
                                                            subFacilities,
                                                      ),
                                                      Expanded(
                                                          child: SizedBox()),
                                                      Expanded(
                                                          child: SizedBox()),
                                                    ],
                                                  )
                                                ],
                                              ),
                                              Column(
                                                children: [
                                                  const Align(
                                                    alignment:
                                                        Alignment.centerLeft,
                                                    child: Text(
                                                      "Cleaning Services",
                                                      style: TextStyle(
                                                          color: Colors.white70,
                                                          fontSize: 16),
                                                    ),
                                                  ),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceAround,
                                                    children: [
                                                      SubFacilitiesCheckBoxWidget(
                                                        checkBoxCategory:
                                                            "Cleaning Services",
                                                        checkBoxText:
                                                            'Suit press',
                                                        checkBoxValue:
                                                            subFacilitiesBoolValue,
                                                        subFacilities:
                                                            subFacilities,
                                                      ),
                                                      SubFacilitiesCheckBoxWidget(
                                                        checkBoxCategory:
                                                            "Cleaning Services",
                                                        checkBoxText:
                                                            'Dry cleaning',
                                                        checkBoxValue:
                                                            subFacilitiesBoolValue,
                                                        subFacilities:
                                                            subFacilities,
                                                      ),
                                                      SubFacilitiesCheckBoxWidget(
                                                        checkBoxCategory:
                                                            "Cleaning Services",
                                                        checkBoxText: 'Laundry',
                                                        checkBoxValue:
                                                            subFacilitiesBoolValue,
                                                        subFacilities:
                                                            subFacilities,
                                                      ),
                                                      Expanded(
                                                          child: SizedBox()),
                                                    ],
                                                  )
                                                ],
                                              ),
                                              Column(
                                                children: [
                                                  const Align(
                                                    alignment:
                                                        Alignment.centerLeft,
                                                    child: Text(
                                                      "Business Facilities",
                                                      style: TextStyle(
                                                          color: Colors.white70,
                                                          fontSize: 16),
                                                    ),
                                                  ),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceAround,
                                                    children: [
                                                      SubFacilitiesCheckBoxWidget(
                                                        checkBoxCategory:
                                                            "Business Facilities",
                                                        checkBoxText:
                                                            'Fax/Photocopying',
                                                        checkBoxValue:
                                                            subFacilitiesBoolValue,
                                                        subFacilities:
                                                            subFacilities,
                                                      ),
                                                      SubFacilitiesCheckBoxWidget(
                                                        checkBoxCategory:
                                                            "Business Facilities",
                                                        checkBoxText:
                                                            'Business center',
                                                        checkBoxValue:
                                                            subFacilitiesBoolValue,
                                                        subFacilities:
                                                            subFacilities,
                                                      ),
                                                      SubFacilitiesCheckBoxWidget(
                                                        checkBoxCategory:
                                                            "Business Facilities",
                                                        checkBoxText:
                                                            'Meeting/Banquet facilities',
                                                        checkBoxValue:
                                                            subFacilitiesBoolValue,
                                                        subFacilities:
                                                            subFacilities,
                                                      ),
                                                      Expanded(
                                                          child: SizedBox()),
                                                    ],
                                                  )
                                                ],
                                              ),
                                              Column(
                                                children: [
                                                  const Align(
                                                    alignment:
                                                        Alignment.centerLeft,
                                                    child: Text(
                                                      "Safety & Security Facilities",
                                                      style: TextStyle(
                                                          color: Colors.white70,
                                                          fontSize: 16),
                                                    ),
                                                  ),
                                                  Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceAround,
                                                      children: [
                                                        SubFacilitiesCheckBoxWidget(
                                                          checkBoxCategory:
                                                              "Safety & Security Facilities",
                                                          checkBoxText: 'Safe',
                                                          checkBoxValue:
                                                              subFacilitiesBoolValue,
                                                          subFacilities:
                                                              subFacilities,
                                                        ),
                                                      ])
                                                ],
                                              ),
                                              Column(
                                                children: [
                                                  const Align(
                                                    alignment:
                                                        Alignment.centerLeft,
                                                    child: Text(
                                                      "General Facilities",
                                                      style: TextStyle(
                                                          color: Colors.white70,
                                                          fontSize: 16),
                                                    ),
                                                  ),
                                                  Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceAround,
                                                      children: [
                                                        SubFacilitiesCheckBoxWidget(
                                                          checkBoxCategory:
                                                              "General Facilities",
                                                          checkBoxText:
                                                              'Airport shuttle (additional charge)',
                                                          checkBoxValue:
                                                              subFacilitiesBoolValue,
                                                          subFacilities:
                                                              subFacilities,
                                                        ),
                                                        SubFacilitiesCheckBoxWidget(
                                                          checkBoxCategory:
                                                              "General Facilities",
                                                          checkBoxText:
                                                              'Designated smoking area',
                                                          checkBoxValue:
                                                              subFacilitiesBoolValue,
                                                          subFacilities:
                                                              subFacilities,
                                                        ),
                                                        SubFacilitiesCheckBoxWidget(
                                                          checkBoxCategory:
                                                              "General Facilities",
                                                          checkBoxText:
                                                              'Air conditioning',
                                                          checkBoxValue:
                                                              subFacilitiesBoolValue,
                                                          subFacilities:
                                                              subFacilities,
                                                        ),
                                                        SubFacilitiesCheckBoxWidget(
                                                          checkBoxCategory:
                                                              "General Facilities",
                                                          checkBoxText:
                                                              'Smoke-free property',
                                                          checkBoxValue:
                                                              subFacilitiesBoolValue,
                                                          subFacilities:
                                                              subFacilities,
                                                        ),
                                                      ]),
                                                  Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceAround,
                                                      children: [
                                                        SubFacilitiesCheckBoxWidget(
                                                          checkBoxCategory:
                                                              "General Facilities",
                                                          checkBoxText:
                                                              'Wake-up service',
                                                          checkBoxValue:
                                                              subFacilitiesBoolValue,
                                                          subFacilities:
                                                              subFacilities,
                                                        ),
                                                        SubFacilitiesCheckBoxWidget(
                                                          checkBoxCategory:
                                                              "General Facilities",
                                                          checkBoxText:
                                                              'Tile/Marble floor',
                                                          checkBoxValue:
                                                              subFacilitiesBoolValue,
                                                          subFacilities:
                                                              subFacilities,
                                                        ),
                                                        SubFacilitiesCheckBoxWidget(
                                                          checkBoxCategory:
                                                              "General Facilities",
                                                          checkBoxText:
                                                              'Carpeted',
                                                          checkBoxValue:
                                                              subFacilitiesBoolValue,
                                                          subFacilities:
                                                              subFacilities,
                                                        ),
                                                        SubFacilitiesCheckBoxWidget(
                                                          checkBoxCategory:
                                                              "General Facilities",
                                                          checkBoxText:
                                                              'Elevator',
                                                          checkBoxValue:
                                                              subFacilitiesBoolValue,
                                                          subFacilities:
                                                              subFacilities,
                                                        ),
                                                      ]),
                                                  Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceAround,
                                                      children: [
                                                        SubFacilitiesCheckBoxWidget(
                                                          checkBoxCategory:
                                                              "General Facilities",
                                                          checkBoxText:
                                                              'Family rooms',
                                                          checkBoxValue:
                                                              subFacilitiesBoolValue,
                                                          subFacilities:
                                                              subFacilities,
                                                        ),
                                                        SubFacilitiesCheckBoxWidget(
                                                          checkBoxCategory:
                                                              "General Facilities",
                                                          checkBoxText:
                                                              'Hair/Beauty salon',
                                                          checkBoxValue:
                                                              subFacilitiesBoolValue,
                                                          subFacilities:
                                                              subFacilities,
                                                        ),
                                                        SubFacilitiesCheckBoxWidget(
                                                          checkBoxCategory:
                                                              "General Facilities",
                                                          checkBoxText:
                                                              'Facilities for disabled guests',
                                                          checkBoxValue:
                                                              subFacilitiesBoolValue,
                                                          subFacilities:
                                                              subFacilities,
                                                        ),
                                                        SubFacilitiesCheckBoxWidget(
                                                          checkBoxCategory:
                                                              "General Facilities",
                                                          checkBoxText:
                                                              'Ironing facilities',
                                                          checkBoxValue:
                                                              subFacilitiesBoolValue,
                                                          subFacilities:
                                                              subFacilities,
                                                        ),
                                                      ]),
                                                  Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceAround,
                                                      children: [
                                                        SubFacilitiesCheckBoxWidget(
                                                          checkBoxCategory:
                                                              "General Facilities",
                                                          checkBoxText:
                                                              'Non-smoking rooms',
                                                          checkBoxValue:
                                                              subFacilitiesBoolValue,
                                                          subFacilities:
                                                              subFacilities,
                                                        ),
                                                        SubFacilitiesCheckBoxWidget(
                                                          checkBoxCategory:
                                                              "General Facilities",
                                                          checkBoxText:
                                                              'Room service',
                                                          checkBoxValue:
                                                              subFacilitiesBoolValue,
                                                          subFacilities:
                                                              subFacilities,
                                                        ),
                                                        Expanded(
                                                            child: SizedBox()),
                                                        Expanded(
                                                            child: SizedBox()),
                                                      ])
                                                ],
                                              ),
                                              Column(
                                                children: [
                                                  const Align(
                                                    alignment:
                                                        Alignment.centerLeft,
                                                    child: Text(
                                                      "Accessibility Facilities",
                                                      style: TextStyle(
                                                          color: Colors.white70,
                                                          fontSize: 16),
                                                    ),
                                                  ),
                                                  Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceAround,
                                                      children: [
                                                        SubFacilitiesCheckBoxWidget(
                                                          checkBoxCategory:
                                                              "Accessibility Facilities",
                                                          checkBoxText:
                                                              'Visual aids (tactile signs)',
                                                          checkBoxValue:
                                                              subFacilitiesBoolValue,
                                                          subFacilities:
                                                              subFacilities,
                                                        ),
                                                        SubFacilitiesCheckBoxWidget(
                                                          checkBoxCategory:
                                                              "Accessibility Facilities",
                                                          checkBoxText:
                                                              'Visual aids (Braille)',
                                                          checkBoxValue:
                                                              subFacilitiesBoolValue,
                                                          subFacilities:
                                                              subFacilities,
                                                        ),
                                                        SubFacilitiesCheckBoxWidget(
                                                          checkBoxCategory:
                                                              "Accessibility Facilities",
                                                          checkBoxText:
                                                              'Bathroom emergency cord',
                                                          checkBoxValue:
                                                              subFacilitiesBoolValue,
                                                          subFacilities:
                                                              subFacilities,
                                                        ),
                                                        SubFacilitiesCheckBoxWidget(
                                                          checkBoxCategory:
                                                              "Accessibility Facilities",
                                                          checkBoxText:
                                                              'Lowered sink',
                                                          checkBoxValue:
                                                              subFacilitiesBoolValue,
                                                          subFacilities:
                                                              subFacilities,
                                                        ),
                                                      ]),
                                                  Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceAround,
                                                      children: [
                                                        SubFacilitiesCheckBoxWidget(
                                                          checkBoxCategory:
                                                              "Accessibility Facilities",
                                                          checkBoxText:
                                                              'Raised toilet',
                                                          checkBoxValue:
                                                              subFacilitiesBoolValue,
                                                          subFacilities:
                                                              subFacilities,
                                                        ),
                                                        SubFacilitiesCheckBoxWidget(
                                                          checkBoxCategory:
                                                              "Accessibility Facilities",
                                                          checkBoxText:
                                                              'Toilet with grab rails',
                                                          checkBoxValue:
                                                              subFacilitiesBoolValue,
                                                          subFacilities:
                                                              subFacilities,
                                                        ),
                                                        SubFacilitiesCheckBoxWidget(
                                                          checkBoxCategory:
                                                              "Accessibility Facilities",
                                                          checkBoxText:
                                                              'Wheelchair accessible',
                                                          checkBoxValue:
                                                              subFacilitiesBoolValue,
                                                          subFacilities:
                                                              subFacilities,
                                                        ),
                                                        Expanded(
                                                            child: SizedBox()),
                                                      ])
                                                ],
                                              ),
                                              Column(
                                                children: [
                                                  const Align(
                                                    alignment:
                                                        Alignment.centerLeft,
                                                    child: Text(
                                                      "Swimming Pool Facilities",
                                                      style: TextStyle(
                                                          color: Colors.white70,
                                                          fontSize: 16),
                                                    ),
                                                  ),
                                                  Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceAround,
                                                      children: [
                                                        SubFacilitiesCheckBoxWidget(
                                                          checkBoxCategory:
                                                              "Swimming Pool Facilities",
                                                          checkBoxText:
                                                              'Open all year',
                                                          checkBoxValue:
                                                              subFacilitiesBoolValue,
                                                          subFacilities:
                                                              subFacilities,
                                                        ),
                                                        SubFacilitiesCheckBoxWidget(
                                                          checkBoxCategory:
                                                              "Swimming Pool Facilities",
                                                          checkBoxText:
                                                              'All ages welcome',
                                                          checkBoxValue:
                                                              subFacilitiesBoolValue,
                                                          subFacilities:
                                                              subFacilities,
                                                        ),
                                                        Expanded(
                                                            child: SizedBox()),
                                                        Expanded(
                                                            child: SizedBox()),
                                                      ])
                                                ],
                                              ),
                                              Column(
                                                children: [
                                                  const Align(
                                                    alignment:
                                                        Alignment.centerLeft,
                                                    child: Text(
                                                      "Spa Facilities",
                                                      style: TextStyle(
                                                          color: Colors.white70,
                                                          fontSize: 16),
                                                    ),
                                                  ),
                                                  Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceAround,
                                                      children: [
                                                        SubFacilitiesCheckBoxWidget(
                                                          checkBoxCategory:
                                                              "Spa Facilities",
                                                          checkBoxText:
                                                              'Fitness',
                                                          checkBoxValue:
                                                              subFacilitiesBoolValue,
                                                          subFacilities:
                                                              subFacilities,
                                                        ),
                                                        SubFacilitiesCheckBoxWidget(
                                                          checkBoxCategory:
                                                              "Spa Facilities",
                                                          checkBoxText:
                                                              'Fitness center',
                                                          checkBoxValue:
                                                              subFacilitiesBoolValue,
                                                          subFacilities:
                                                              subFacilities,
                                                        ),
                                                        Expanded(
                                                            child: SizedBox()),
                                                        Expanded(
                                                            child: SizedBox())
                                                      ])
                                                ],
                                              ),
                                              Column(
                                                children: [
                                                  const Align(
                                                    alignment:
                                                        Alignment.centerLeft,
                                                    child: Text(
                                                      "Language Spoken",
                                                      style: TextStyle(
                                                          color: Colors.white70,
                                                          fontSize: 16),
                                                    ),
                                                  ),
                                                  Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceAround,
                                                      children: [
                                                        SubFacilitiesCheckBoxWidget(
                                                          checkBoxCategory:
                                                              "Language Spoken",
                                                          checkBoxText:
                                                              'Arabic',
                                                          checkBoxValue:
                                                              subFacilitiesBoolValue,
                                                          subFacilities:
                                                              subFacilities,
                                                        ),
                                                        SubFacilitiesCheckBoxWidget(
                                                          checkBoxCategory:
                                                              "Language Spoken",
                                                          checkBoxText:
                                                              'English',
                                                          checkBoxValue:
                                                              subFacilitiesBoolValue,
                                                          subFacilities:
                                                              subFacilities,
                                                        ),
                                                        SubFacilitiesCheckBoxWidget(
                                                          checkBoxCategory:
                                                              "Language Spoken",
                                                          checkBoxText: 'Hindi',
                                                          checkBoxValue:
                                                              subFacilitiesBoolValue,
                                                          subFacilities:
                                                              subFacilities,
                                                        ),
                                                        SubFacilitiesCheckBoxWidget(
                                                          checkBoxCategory:
                                                              "Language Spoken",
                                                          checkBoxText:
                                                              'Filipino',
                                                          checkBoxValue:
                                                              subFacilitiesBoolValue,
                                                          subFacilities:
                                                              subFacilities,
                                                        ),
                                                      ]),
                                                  Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceAround,
                                                      children: [
                                                        SubFacilitiesCheckBoxWidget(
                                                          checkBoxCategory:
                                                              "Language Spoken",
                                                          checkBoxText: 'Urdu',
                                                          checkBoxValue:
                                                              subFacilitiesBoolValue,
                                                          subFacilities:
                                                              subFacilities,
                                                        ),
                                                      ])
                                                ],
                                              )
                                            ],
                                          ),
                                        ),
                                        SizedBox(
                                          height: 40,
                                        ),
                                        _isMainUploadingLoading ||
                                                _isOtherUploadingLoading
                                            ? Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 16.0),
                                                child: SizedBox(
                                                    height: 80.0,
                                                    width: 80.0,
                                                    child:
                                                        CircularProgressIndicator(
                                                      valueColor:
                                                          AlwaysStoppedAnimation<
                                                                  Color>(
                                                              Color(
                                                                  0xFFdb9e1f)),
                                                    )),
                                              )
                                            : Container(
                                                width: 300.0,
                                                height: 50.0,
                                                child: ElevatedButton(
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                          primary:
                                                              Color(0xFF000000),
                                                          shape: RoundedRectangleBorder(
                                                              borderRadius: BorderRadius
                                                                  .all(Radius
                                                                      .circular(
                                                                          20.0)),
                                                              side: BorderSide(
                                                                  color: Color(
                                                                      0xFFdb9e1f))),
                                                          side: BorderSide(
                                                            width: 2.5,
                                                            color: Color(
                                                                0xFFdb9e1f),
                                                          ),
                                                          textStyle:
                                                              const TextStyle(
                                                                  fontSize:
                                                                      16)),
                                                  onPressed: () {
                                                    //uploadMainFunction(_selectedFile);
                                                    //uploadFile();
                                                    _uploadapartmentData();
                                                    Navigator.of(context).push(
                                                        MaterialPageRoute(
                                                            builder: (context) =>
                                                                DeoManageApartments(
                                                                    widget
                                                                        .uid)));
                                                  },
                                                  child: const Text(
                                                    'Update',
                                                    style: TextStyle(
                                                        color: Colors.white),
                                                  ),
                                                ),
                                              ),
                                      ],
                                    )),
                              ),
                            ),
                          ),
                        )
                      ],
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
}

class MainFacilitiesCheckBox extends StatefulWidget {
  MainFacilitiesCheckBox({
    Key? key,
    required this.checkBoxText,
    required this.checkBoxValue,
    required this.mainFacilities,
  }) : super(key: key);

  String checkBoxText;
  bool checkBoxValue;
  var mainFacilities;

  @override
  State<MainFacilitiesCheckBox> createState() =>
      _MainFacilitiesCheckBoxState(checkBoxText, checkBoxValue, mainFacilities);
}

class _MainFacilitiesCheckBoxState extends State<MainFacilitiesCheckBox> {
  String checkBoxText;
  bool checkBoxValue;
  var mainFacilities;

  _MainFacilitiesCheckBoxState(
      this.checkBoxText, this.checkBoxValue, this.mainFacilities);

  @override
  void initState() {
    //print(mainFacilities);
    //print(mainFacilities.contains(checkBoxText));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: CheckboxListTile(
        title: Text(
          checkBoxText,
          style: TextStyle(color: Colors.white70),
        ),
        //secondary: Icon(
        //Icons.person,
        //color: Colors.white70,
        //),
        controlAffinity: ListTileControlAffinity.leading,
        value: mainFacilities.contains(checkBoxText)
            ? checkBoxValue == true
            : checkBoxValue == false,
        onChanged: (value) {
          setState(() {
            this.checkBoxValue = value!;
          });
          if (checkBoxValue) {
            mainFacilities.add(checkBoxText);
          } else {
            mainFacilities.removeAt(mainFacilities.indexOf(checkBoxText));
          }
          print(mainFacilities);
        },
        activeColor: Color(0xFFdb9e1f),
        checkColor: Colors.white,
        side: BorderSide(
          color: Colors.white70,
          width: 1.5,
        ),
      ),
    );
  }
}

class SubFacilitiesCheckBoxWidget extends StatefulWidget {
  SubFacilitiesCheckBoxWidget({
    Key? key,
    required this.checkBoxCategory,
    required this.checkBoxText,
    required this.checkBoxValue,
    required this.subFacilities,
  }) : super(key: key);

  String checkBoxCategory;
  String checkBoxText;
  bool checkBoxValue;
  var subFacilities;

  @override
  State<SubFacilitiesCheckBoxWidget> createState() =>
      _SubFacilitiesCheckBoxWidgetState(
          checkBoxCategory, checkBoxText, checkBoxValue, subFacilities);
}

class _SubFacilitiesCheckBoxWidgetState
    extends State<SubFacilitiesCheckBoxWidget> {
  String checkBoxCategory;
  String checkBoxText;
  bool checkBoxValue;
  var subFacilities;

  _SubFacilitiesCheckBoxWidgetState(this.checkBoxCategory, this.checkBoxText,
      this.checkBoxValue, this.subFacilities);
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: CheckboxListTile(
        title: Text(
          checkBoxText,
          style: TextStyle(color: Colors.white70),
        ),
        //secondary: Icon(
        //Icons.person,
        //color: Colors.white70,
        //),
        controlAffinity: ListTileControlAffinity.leading,
        value: subFacilities[checkBoxCategory].contains(checkBoxText)
            ? checkBoxValue == true
            : checkBoxValue == false,
        onChanged: (value) {
          setState(() {
            this.checkBoxValue = value!;
          });
          if (checkBoxValue) {
            subFacilities[checkBoxCategory].add(checkBoxText);
          } else {
            subFacilities[checkBoxCategory].removeAt(
                subFacilities[checkBoxCategory].indexOf(checkBoxText));
          }
          //print(subFacilities);
        },
        activeColor: Color(0xFFdb9e1f),
        checkColor: Colors.white,
        side: BorderSide(
          color: Colors.white70,
          width: 1.5,
        ),
      ),
    );
  }
}
