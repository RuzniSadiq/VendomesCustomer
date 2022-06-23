import 'dart:io';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:worldsgate/helper/responsive_helper.dart';
import '../../../../widgets/deonavigationdrawer.dart';
import '../../../../widgets/header.dart';
import 'deomanagecars.dart';

class UpdateCarDetails extends StatefulWidget {
  //const UpdateCarDetails({Key? key}) : super(key: key);

  String? uid;
  String? carid;

  UpdateCarDetails(this.uid, this.carid);

  @override
  State<UpdateCarDetails> createState() => _UpdateCarDetailsState();
}

class _UpdateCarDetailsState extends State<UpdateCarDetails> {
  var _scaffoldState = new GlobalKey<ScaffoldState>();
  final _formkey = GlobalKey<FormState>();

  final TextEditingController carNameController = TextEditingController();
  final TextEditingController distanceController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  String? model;
  String? delivery;
  String? insurance;
  String? brand;
  String? gear;
  String? engine;
  String? color;
  String? seats;
  String? doors;
  String? luggage;

  final models = [
    "2022",
    "2021",
    "2020",
    "2019",
    "2018",
    "2017",
    "2016",
    "2015",
    "2014",
    "2013",
    "2012",
    "2011",
    "2010",
  ];

  final deliveryType = [
    "Free",
    "Paid",
  ];

  final insuranceType = [
    "Full",
    "Part",
  ];

  final carBrand = ["Lamborghini", "Ferrari", "Rolls Royce", "McLaren"];

  final gearType = [
    "Auto",
    "Manual",
  ];

  final engineType = [
    "V8",
  ];

  final carColor = [
    "Red",
    "White",
    "Yellow",
    "Blue",
    "Grey",
    "Black",
    "Gold",
    "Tricolor"
  ];

  final seatsDoorsLuggageCount = [
    "2",
    "4",
    "6",
  ];

  bool featureBoolValue = true;

  List<String> allOtherFeatures = [
    'Sensors',
    'Bluetooth',
    'Camera',
    'Safety',
    'Mp3/CD',
  ];

  DropdownMenuItem<String> buildMenuItem(String place) => DropdownMenuItem(
        value: place,
        child: Text(
          place,
          style: const TextStyle(fontSize: 16.0),
        ),
      );

  bool _isLoading = true;

  bool _isMainUploading = false;
  bool _isOtherUploading = false;

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
          final destination = '/carimages/carmain/$filename';
          print("The destination is $destination");

          final ref = FirebaseStorage.instance.ref(destination);
          task = ref.putData(uploadfile);
          setState(() {
            _isMainUploading = true;
          });
          setState(() {});
          print("Total bytes $task");
          print("Total bytes ${task!.snapshot.totalBytes}");

          if (task == null) return;
          final snapshot = await task!.whenComplete(() {
            setState(() {
              _isMainUploading = false;
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
  List<String> OtherHotelImagesUrl = [];

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
            final destination = '/carimages/carsub/$filename';
            print("The destination is $destination");

            final ref = FirebaseStorage.instance.ref(destination);
            otherTask = ref.putData(uploadfile);
            setState(() {
              _isOtherUploading = true;
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
            OtherHotelImagesUrl.add(otherImageLink);
          }

          setState(() {
            _isOtherUploading = false;
          });
        } catch (e) {
          print(e);
        }
      }
    } catch (e) {
      print(e);
    }
  }

  var otherFeatures;
  List<String> carCoverImageList = [];

  _getCarDetails() async {
    await FirebaseFirestore.instance
        .collection("cars")
        .doc(widget.carid)
        .get()
        .then((documentSnapshot) {
      if (documentSnapshot.exists) {
        setState(() {
          if ((documentSnapshot.data() as Map<String, dynamic>)
              .containsKey('name')) {
            carNameController.text = documentSnapshot['name'];
          }
          if ((documentSnapshot.data() as Map<String, dynamic>)
              .containsKey('model')) {
            model = documentSnapshot['model'];
          }
          if ((documentSnapshot.data() as Map<String, dynamic>)
              .containsKey('delivery')) {
            delivery = documentSnapshot['delivery'];
          }
          if ((documentSnapshot.data() as Map<String, dynamic>)
              .containsKey('insurance')) {
            insurance = documentSnapshot['insurance'];
          }
          if ((documentSnapshot.data() as Map<String, dynamic>)
              .containsKey('brand')) {
            brand = documentSnapshot['brand'];
          }
          if ((documentSnapshot.data() as Map<String, dynamic>)
              .containsKey('distance')) {
            distanceController.text = documentSnapshot['distance'];
          }
          if ((documentSnapshot.data() as Map<String, dynamic>)
              .containsKey('age')) {
            ageController.text = documentSnapshot['age'];
          }
          if ((documentSnapshot.data() as Map<String, dynamic>)
              .containsKey('price')) {
            priceController.text = documentSnapshot['price'].toString();
          }
          if ((documentSnapshot.data() as Map<String, dynamic>)
              .containsKey('description')) {
            descriptionController.text = documentSnapshot['description'];
          }
          if ((documentSnapshot.data() as Map<String, dynamic>)
              .containsKey('coverimage')) {
            coverImageLink = documentSnapshot['coverimage'];
            carCoverImageList.add(coverImageLink);
          }
          if ((documentSnapshot.data() as Map<String, dynamic>)
              .containsKey('othercarimages')) {
            for (int i = 0;
                i < documentSnapshot['othercarimages'].length;
                i++) {
              OtherHotelImagesUrl.add(documentSnapshot['othercarimages'][i]);
            }
          }
          if ((documentSnapshot.data() as Map<String, dynamic>)
              .containsKey('gear')) {
            gear = documentSnapshot['gear'];
          }
          if ((documentSnapshot.data() as Map<String, dynamic>)
              .containsKey('engine')) {
            engine = documentSnapshot['engine'];
          }
          if ((documentSnapshot.data() as Map<String, dynamic>)
              .containsKey('color')) {
            color = documentSnapshot['color'];
          }
          if ((documentSnapshot.data() as Map<String, dynamic>)
              .containsKey('seats')) {
            seats = documentSnapshot['seats'];
          }
          if ((documentSnapshot.data() as Map<String, dynamic>)
              .containsKey('doors')) {
            doors = documentSnapshot['doors'];
          }
          if ((documentSnapshot.data() as Map<String, dynamic>)
              .containsKey('luggage')) {
            luggage = documentSnapshot['luggage'];
          }
          if ((documentSnapshot.data() as Map<String, dynamic>)
              .containsKey('otherfeatures')) {
            otherFeatures = documentSnapshot['otherfeatures'];
          }
        });
      } else {
        print("The document does not exist");
      }
    });
  }

  _removeCarCoverPhoto(url) async {
    await FirebaseStorage.instance.refFromURL(url).delete();
    setState(() {
      carCoverImageList.removeAt(carCoverImageList.indexOf(url));
      coverImageLink = "";
    });
  }

  _removeOtherCarPhotos(url) async {
    await FirebaseStorage.instance.refFromURL(url).delete();
    setState(() {
      OtherHotelImagesUrl.removeAt(OtherHotelImagesUrl.indexOf(url));
    });
  }

  _uploadHotelData() async {
    //String newCarId = FirebaseFirestore.instance.collection('cars').doc().id;

    try {
      await FirebaseFirestore.instance
          .collection('cars')
          .doc(widget.carid)
          .update({
        'name': carNameController.text,
        'model': model,
        'delivery': delivery,
        'insurance': insurance,
        'brand': brand,
        'distance': distanceController.text,
        'age': ageController.text,
        'price': double.parse(priceController.text),
        'description': descriptionController.text,
        //'mainfacilities': mainFacilities,
        //'subfacilities': subFacilities,
        //'rooms': roomDeatils,
        //'datecreated': DateTime.now(),
        //'dataentryuid': widget.uid,
        'coverimage': coverImageLink,
        'othercarimages': OtherHotelImagesUrl,
        //'cancellationfee': null,
        //'stars': stars,
        //'taxandcharges': null,
        'gear': gear,
        'engine': engine,
        'color': color,
        'seats': seats,
        'doors': doors,
        'luggage': luggage,
        'otherfeatures': otherFeatures,
        //'carid': newCarId,
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
    super.initState();
    getname();
    _getCarDetails();
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
        drawer: new DeoNavigationDrawer(widget.uid),
        backgroundColor: Color(0xFF000000),
        body: (_isLoading == true)
            ? Center(child: CircularProgressIndicator())
            : Stack(
                children: [
                  SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: ResponsiveWidget(
                      mobile: addCarDetailsContainer(context, "mobile"),
                      tab: addCarDetailsContainer(context, "tab"),
                      desktop: addCarDetailsContainer(context, "desktop"),
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

  Container addCarDetailsContainer(BuildContext context, String device) {
    return Container(
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.width * 0.25,
          vertical: MediaQuery.of(context).size.height * 0.2,
        ),
        child: Column(
          children: [
            Container(
              child: Form(
                  key: _formkey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      TextFormField(
                        style: TextStyle(color: Colors.white),
                        controller: carNameController,
                        decoration: InputDecoration(
                          suffixIcon: IconButton(
                              icon: Icon(
                                Icons.cancel,
                                color: Color(0xFFdb9e1f),
                              ),
                              onPressed: () {
                                carNameController..text = "";
                              }),
                          hintText: "Enter car name",
                          labelText: "Car Name",
                          hintStyle: TextStyle(color: Colors.white70),
                          labelStyle:
                              new TextStyle(color: Colors.white70, height: 0.1),
                          enabled: true,
                          enabledBorder: UnderlineInputBorder(
                            borderSide: new BorderSide(color: Colors.white70),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide:
                                new BorderSide(color: Color(0xFFdb9e1f)),
                          ),
                        ),
                        validator: (value) {
                          if (value!.length == 0) {
                            return "Car name cannot be empty";
                          }
                        },
                        onSaved: (value) {
                          carNameController.text = value!;
                        },
                        keyboardType: TextInputType.text,
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Expanded(
                              child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8.0),
                                  child: DropdownButtonFormField(
                                      decoration: InputDecoration(
                                        hintText: "Car Model",
                                        hintStyle:
                                            TextStyle(color: Colors.white70),
                                        labelText: 'Model',
                                        labelStyle: TextStyle(
                                            color: Colors.white70, height: 0.1),
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
                                      dropdownColor: Color(0xFF000000),
                                      //focusColor: Color(0xFFdb9e1f),
                                      style: TextStyle(color: Colors.white),
                                      isExpanded: true,
                                      value: model,
                                      items: models.map(buildMenuItem).toList(),
                                      onChanged: (value) => setState(() {
                                            this.model = value as String?;
                                          }))),
                            ),
                            Expanded(
                              child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8.0),
                                  child: DropdownButtonFormField(
                                      decoration: InputDecoration(
                                        hintText: "Type of Delivery",
                                        hintStyle:
                                            TextStyle(color: Colors.white70),
                                        labelText: 'Delivery',
                                        labelStyle: TextStyle(
                                            color: Colors.white70, height: 0.1),
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
                                      dropdownColor: Color(0xFF000000),
                                      //focusColor: Color(0xFFdb9e1f),
                                      style: TextStyle(color: Colors.white),
                                      isExpanded: true,
                                      value: delivery,
                                      items: deliveryType
                                          .map(buildMenuItem)
                                          .toList(),
                                      onChanged: (value) => setState(() {
                                            this.delivery = value as String?;
                                          }))),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Expanded(
                              child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8.0),
                                  child: DropdownButtonFormField(
                                      decoration: InputDecoration(
                                        hintText: "Type of insurance",
                                        hintStyle:
                                            TextStyle(color: Colors.white70),
                                        labelText: 'Insurance',
                                        labelStyle: TextStyle(
                                            color: Colors.white70, height: 0.1),
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
                                      dropdownColor: Color(0xFF000000),
                                      //focusColor: Color(0xFFdb9e1f),
                                      style: TextStyle(color: Colors.white),
                                      isExpanded: true,
                                      value: insurance,
                                      items: insuranceType
                                          .map(buildMenuItem)
                                          .toList(),
                                      onChanged: (value) => setState(() {
                                            this.insurance = value as String?;
                                          }))),
                            ),
                            Expanded(
                              child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8.0),
                                  child: DropdownButtonFormField(
                                      decoration: InputDecoration(
                                        hintText: "Car Brand",
                                        hintStyle:
                                            TextStyle(color: Colors.white70),
                                        labelText: 'Brand',
                                        labelStyle: TextStyle(
                                            color: Colors.white70, height: 0.1),
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
                                      dropdownColor: Color(0xFF000000),
                                      //focusColor: Color(0xFFdb9e1f),
                                      style: TextStyle(color: Colors.white),
                                      isExpanded: true,
                                      value: brand,
                                      items:
                                          carBrand.map(buildMenuItem).toList(),
                                      onChanged: (value) => setState(() {
                                            this.brand = value as String?;
                                          }))),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                        child: Row(
                          children: [
                            Expanded(
                              child: TextFormField(
                                style: TextStyle(color: Colors.white),
                                controller: distanceController,
                                decoration: InputDecoration(
                                  suffixIcon: IconButton(
                                      icon: Icon(
                                        Icons.cancel,
                                        color: Color(0xFFdb9e1f),
                                      ),
                                      onPressed: () {
                                        distanceController..text = "";
                                      }),
                                  hintText: "Enter KMs Per Day",
                                  labelText: "KMs/Day",
                                  hintStyle: TextStyle(color: Colors.white70),
                                  labelStyle: new TextStyle(
                                      color: Colors.white70, height: 0.1),
                                  enabled: true,
                                  enabledBorder: UnderlineInputBorder(
                                    borderSide:
                                        new BorderSide(color: Colors.white70),
                                  ),
                                  focusedBorder: UnderlineInputBorder(
                                    borderSide: new BorderSide(
                                        color: Color(0xFFdb9e1f)),
                                  ),
                                ),
                                validator: (value) {
                                  if (value!.length == 0) {
                                    return "KMs/Day cannot be empty";
                                  }
                                },
                                onSaved: (value) {
                                  distanceController.text = value!;
                                },
                                keyboardType: TextInputType.text,
                              ),
                            ),
                            SizedBox(
                              width: 16.0,
                            ),
                            Expanded(
                              child: TextFormField(
                                style: TextStyle(color: Colors.white),
                                controller: ageController,
                                decoration: InputDecoration(
                                  suffixIcon: IconButton(
                                      icon: Icon(
                                        Icons.cancel,
                                        color: Color(0xFFdb9e1f),
                                      ),
                                      onPressed: () {
                                        ageController..text = "";
                                      }),
                                  hintText: "Enter minimum age",
                                  labelText: "Minimum Age",
                                  hintStyle: TextStyle(color: Colors.white70),
                                  labelStyle: new TextStyle(
                                      color: Colors.white70, height: 0.1),
                                  enabled: true,
                                  enabledBorder: UnderlineInputBorder(
                                    borderSide:
                                        new BorderSide(color: Colors.white70),
                                  ),
                                  focusedBorder: UnderlineInputBorder(
                                    borderSide: new BorderSide(
                                        color: Color(0xFFdb9e1f)),
                                  ),
                                ),
                                validator: (value) {
                                  if (value!.length == 0) {
                                    return "Minimum age cannot be empty";
                                  }
                                },
                                onSaved: (value) {
                                  ageController.text = value!;
                                },
                                keyboardType: TextInputType.text,
                              ),
                            )
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        style: TextStyle(color: Colors.white),
                        controller: priceController,
                        decoration: InputDecoration(
                          suffixIcon: IconButton(
                              icon: Icon(
                                Icons.cancel,
                                color: Color(0xFFdb9e1f),
                              ),
                              onPressed: () {
                                priceController..text = "";
                              }),
                          hintText: "Enter price",
                          labelText: "Price",
                          hintStyle: TextStyle(color: Colors.white70),
                          labelStyle:
                              new TextStyle(color: Colors.white70, height: 0.1),
                          enabled: true,
                          enabledBorder: UnderlineInputBorder(
                            borderSide: new BorderSide(color: Colors.white70),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide:
                                new BorderSide(color: Color(0xFFdb9e1f)),
                          ),
                        ),
                        validator: (value) {
                          if (value!.length == 0) {
                            return "Price cannot be empty";
                          }
                        },
                        onSaved: (value) {
                          priceController.text = value!;
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
                                descriptionController..text = "";
                              }),
                          hintText: "Enter car description",
                          labelText: "Car Description",
                          hintStyle: TextStyle(color: Colors.white70),
                          labelStyle:
                              new TextStyle(color: Colors.white70, height: 0.1),
                          enabled: true,
                          enabledBorder: UnderlineInputBorder(
                            borderSide: new BorderSide(color: Colors.white70),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide:
                                new BorderSide(color: Color(0xFFdb9e1f)),
                          ),
                        ),
                        validator: (value) {
                          if (value!.length == 0) {
                            return "Car description cannot be empty";
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
                      const Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Car Cover Photo",
                          style: TextStyle(color: Colors.white70, fontSize: 16),
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
                                        BorderRadius.all(Radius.circular(20.0)),
                                    side: BorderSide(color: Color(0xFFdb9e1f))),
                                side: BorderSide(
                                  width: 2.5,
                                  color: Color(0xFFdb9e1f),
                                ),
                                textStyle: const TextStyle(fontSize: 16)),
                            onPressed: () {
                              selectFileandUpload();
                            },
                            icon: Icon(
                              Icons.add_a_photo,
                              color: Colors.white,
                              size: 20,
                            ), //icon data for elevated button
                            label: Text(
                              "Car Cover Photo",
                              style: TextStyle(color: Colors.white),
                            ),
                            /*child: const Text(
                                            'Hotel Cover Photo',
                                            style: TextStyle(
                                                color: Colors.white),
                                          ),*/
                          ),
                        ),
                      ),
                      carCoverImageList.isNotEmpty
                          ? Container(
                              width: MediaQuery.of(context).size.width / 1.6,
                              height: 160,
                              child: GridView.builder(
                                  itemCount: carCoverImageList.length,
                                  gridDelegate:
                                      SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisCount: 7),
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return Padding(
                                      padding: const EdgeInsets.only(top: 8.0),
                                      child: Container(
                                          height: 100,
                                          width: 100,
                                          decoration: BoxDecoration(
                                              image: DecorationImage(
                                                  image: NetworkImage(
                                                      carCoverImageList[index]),
                                                  fit: BoxFit.cover)),
                                          child: IconButton(
                                            icon: Icon(
                                              Icons.delete,
                                              color: Color(0xFFdb9e1f),
                                              size: 40.0,
                                            ),
                                            onPressed: () {
                                              _removeCarCoverPhoto(
                                                  carCoverImageList[index]);
                                            },
                                          )),
                                    );
                                    //Text('Image : ' + index.toString());
                                  }),
                            )
                          : Container(
                              width: MediaQuery.of(context).size.width / 1.6,
                              height: 160,
                              child: GridView.builder(
                                  itemCount: coverImage.length,
                                  gridDelegate:
                                      SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisCount: 7),
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return Padding(
                                      padding: const EdgeInsets.only(top: 8.0),
                                      child: Container(
                                        height: 100,
                                        width: 100,
                                        decoration: BoxDecoration(
                                            image: DecorationImage(
                                                image: MemoryImage(
                                                    coverImage[index]),
                                                fit: BoxFit.cover)),
                                      ),
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
                          "Other Car Photos",
                          style: TextStyle(color: Colors.white70, fontSize: 16),
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
                                        BorderRadius.all(Radius.circular(20.0)),
                                    side: BorderSide(color: Color(0xFFdb9e1f))),
                                side: BorderSide(
                                  width: 2.5,
                                  color: Color(0xFFdb9e1f),
                                ),
                                textStyle: const TextStyle(fontSize: 16)),
                            onPressed: () {
                              selectOtherFileandUpload();
                            },
                            icon: Icon(
                              Icons.add_a_photo,
                              color: Colors.white,
                              size: 20,
                            ), //icon data for elevated button
                            label: Text(
                              "Other Car Photos",
                              style: TextStyle(color: Colors.white),
                            ),
                            /*child: const Text(
                                            'Hotel Cover Photo',
                                            style: TextStyle(
                                                color: Colors.white),
                                          ),*/
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      OtherHotelImagesUrl.length != 0
                          ? Container(
                              width: MediaQuery.of(context).size.width / 1.6,
                              height: 160,
                              child: GridView.builder(
                                  itemCount: OtherHotelImagesUrl.length,
                                  gridDelegate:
                                      SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisCount: 8),
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return Padding(
                                      padding: const EdgeInsets.only(top: 8.0),
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Container(
                                            height: 100,
                                            width: 100,
                                            decoration: BoxDecoration(
                                                image: DecorationImage(
                                                    image: NetworkImage(
                                                        OtherHotelImagesUrl[
                                                            index]),
                                                    fit: BoxFit.cover)),
                                            child: IconButton(
                                              icon: Icon(
                                                Icons.delete,
                                                color: Color(0xFFdb9e1f),
                                                size: 40.0,
                                              ),
                                              onPressed: () {
                                                _removeOtherCarPhotos(
                                                    OtherHotelImagesUrl[index]);
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
                              width: MediaQuery.of(context).size.width / 1.6,
                              height: 160,
                              child: GridView.builder(
                                  itemCount: otherImage.length,
                                  gridDelegate:
                                      SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisCount: 8),
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return Padding(
                                      padding: const EdgeInsets.only(top: 8.0),
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Container(
                                            height: 100,
                                            width: 100,
                                            decoration: BoxDecoration(
                                                image: DecorationImage(
                                                    image: MemoryImage(
                                                        otherImage[index]),
                                                    fit: BoxFit.cover))),
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
                          "Features",
                          style: TextStyle(color: Colors.white70, fontSize: 16),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8.0),
                                      child: DropdownButtonFormField(
                                          decoration: InputDecoration(
                                            hintText: "Car Gear",
                                            hintStyle: TextStyle(
                                                color: Colors.white70),
                                            labelText: 'Gear',
                                            labelStyle: TextStyle(
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
                                          dropdownColor: Color(0xFF000000),
                                          //focusColor: Color(0xFFdb9e1f),
                                          style: TextStyle(color: Colors.white),
                                          isExpanded: true,
                                          value: gear,
                                          items: gearType
                                              .map(buildMenuItem)
                                              .toList(),
                                          onChanged: (value) => setState(() {
                                                this.gear = value as String?;
                                              }))),
                                ),
                                Expanded(
                                  child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8.0),
                                      child: DropdownButtonFormField(
                                          decoration: InputDecoration(
                                            hintText: "Car Engine",
                                            hintStyle: TextStyle(
                                                color: Colors.white70),
                                            labelText: 'Engine',
                                            labelStyle: TextStyle(
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
                                          dropdownColor: Color(0xFF000000),
                                          //focusColor: Color(0xFFdb9e1f),
                                          style: TextStyle(color: Colors.white),
                                          isExpanded: true,
                                          value: engine,
                                          items: engineType
                                              .map(buildMenuItem)
                                              .toList(),
                                          onChanged: (value) => setState(() {
                                                this.engine = value as String?;
                                              }))),
                                ),
                                Expanded(
                                  child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8.0),
                                      child: DropdownButtonFormField(
                                          decoration: InputDecoration(
                                            hintText: "Car Color",
                                            hintStyle: TextStyle(
                                                color: Colors.white70),
                                            labelText: 'Color',
                                            labelStyle: TextStyle(
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
                                          dropdownColor: Color(0xFF000000),
                                          //focusColor: Color(0xFFdb9e1f),
                                          style: TextStyle(color: Colors.white),
                                          isExpanded: true,
                                          value: color,
                                          items: carColor
                                              .map(buildMenuItem)
                                              .toList(),
                                          onChanged: (value) => setState(() {
                                                this.color = value as String?;
                                              }))),
                                ),
                                Expanded(
                                  child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8.0),
                                      child: DropdownButtonFormField(
                                          decoration: InputDecoration(
                                            hintText: "Number of Seats",
                                            hintStyle: TextStyle(
                                                color: Colors.white70),
                                            labelText: 'Seats',
                                            labelStyle: TextStyle(
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
                                          dropdownColor: Color(0xFF000000),
                                          //focusColor: Color(0xFFdb9e1f),
                                          style: TextStyle(color: Colors.white),
                                          isExpanded: true,
                                          value: seats,
                                          items: seatsDoorsLuggageCount
                                              .map(buildMenuItem)
                                              .toList(),
                                          onChanged: (value) => setState(() {
                                                this.seats = value as String?;
                                              }))),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8.0),
                                      child: DropdownButtonFormField(
                                          decoration: InputDecoration(
                                            hintText: "Number of Doors",
                                            hintStyle: TextStyle(
                                                color: Colors.white70),
                                            labelText: 'Doors',
                                            labelStyle: TextStyle(
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
                                          dropdownColor: Color(0xFF000000),
                                          //focusColor: Color(0xFFdb9e1f),
                                          style: TextStyle(color: Colors.white),
                                          isExpanded: true,
                                          value: doors,
                                          items: seatsDoorsLuggageCount
                                              .map(buildMenuItem)
                                              .toList(),
                                          onChanged: (value) => setState(() {
                                                this.doors = value as String?;
                                              }))),
                                ),
                                Expanded(
                                  child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8.0),
                                      child: DropdownButtonFormField(
                                          decoration: InputDecoration(
                                            hintText: "Number of Luggage",
                                            hintStyle: TextStyle(
                                                color: Colors.white70),
                                            labelText: 'Luggage',
                                            labelStyle: TextStyle(
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
                                          dropdownColor: Color(0xFF000000),
                                          //focusColor: Color(0xFFdb9e1f),
                                          style: TextStyle(color: Colors.white),
                                          isExpanded: true,
                                          value: luggage,
                                          items: seatsDoorsLuggageCount
                                              .map(buildMenuItem)
                                              .toList(),
                                          onChanged: (value) => setState(() {
                                                this.luggage = value as String?;
                                              }))),
                                ),
                              ],
                            ),
                            SizedBox(height: 20.0),
                            Wrap(
                              //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  width: device == "mobile"
                                      ? MediaQuery.of(context).size.width * 0.5
                                      : device == "tab"
                                          ? MediaQuery.of(context).size.width *
                                              0.25
                                          : device == "desktop"
                                              ? MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.1
                                              : MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.1,
                                  child: OtherCarFeatures(
                                    featureText: 'Sensors',
                                    featureValue:
                                        otherFeatures.contains('Sensors')
                                            ? featureBoolValue == true
                                            : featureBoolValue == false,
                                    featureList: otherFeatures,
                                  ),
                                ),
                                Container(
                                  width: device == "mobile"
                                      ? MediaQuery.of(context).size.width * 0.5
                                      : device == "tab"
                                          ? MediaQuery.of(context).size.width *
                                              0.25
                                          : device == "desktop"
                                              ? MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.1
                                              : MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.1,
                                  child: OtherCarFeatures(
                                      featureText: 'Bluetooth',
                                      featureValue:
                                          otherFeatures.contains('Bluetooth')
                                              ? featureBoolValue == true
                                              : featureBoolValue == false,
                                      featureList: otherFeatures),
                                ),
                                Container(
                                  width: device == "mobile"
                                      ? MediaQuery.of(context).size.width * 0.5
                                      : device == "tab"
                                          ? MediaQuery.of(context).size.width *
                                              0.25
                                          : device == "desktop"
                                              ? MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.1
                                              : MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.1,
                                  child: OtherCarFeatures(
                                      featureText: 'Camera',
                                      featureValue:
                                          otherFeatures.contains('Camera')
                                              ? featureBoolValue == true
                                              : featureBoolValue == false,
                                      featureList: otherFeatures),
                                ),
                                Container(
                                  width: device == "mobile"
                                      ? MediaQuery.of(context).size.width * 0.5
                                      : device == "tab"
                                          ? MediaQuery.of(context).size.width *
                                              0.25
                                          : device == "desktop"
                                              ? MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.1
                                              : MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.1,
                                  child: OtherCarFeatures(
                                      featureText: 'Safety',
                                      featureValue:
                                          otherFeatures.contains('Safety')
                                              ? featureBoolValue == true
                                              : featureBoolValue == false,
                                      featureList: otherFeatures),
                                ),
                                Container(
                                  width: device == "mobile"
                                      ? MediaQuery.of(context).size.width * 0.5
                                      : device == "tab"
                                          ? MediaQuery.of(context).size.width *
                                              0.25
                                          : device == "desktop"
                                              ? MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.1
                                              : MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.1,
                                  child: OtherCarFeatures(
                                      featureText: 'Mp3/CD',
                                      featureValue:
                                          otherFeatures.contains('Mp3/CD')
                                              ? featureBoolValue == true
                                              : featureBoolValue == false,
                                      featureList: otherFeatures),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 40,
                      ),
                      _isMainUploading || _isOtherUploading
                          ? Padding(
                              padding: const EdgeInsets.only(top: 16.0),
                              child: SizedBox(
                                  height: 80.0,
                                  width: 80.0,
                                  child: CircularProgressIndicator(
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                        Color(0xFFdb9e1f)),
                                  )),
                            )
                          : Container(
                              width: 300.0,
                              height: 50.0,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    primary: Color(0xFF000000),
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(20.0)),
                                        side: BorderSide(
                                            color: Color(0xFFdb9e1f))),
                                    side: BorderSide(
                                      width: 2.5,
                                      color: Color(0xFFdb9e1f),
                                    ),
                                    textStyle: const TextStyle(fontSize: 16)),
                                onPressed: () {
                                  //uploadMainFunction(_selectedFile);
                                  //uploadFile();
                                  _uploadHotelData();
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) =>
                                          DeoManageCars(widget.uid)));
                                },
                                child: const Text(
                                  'Update',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                    ],
                  )),
            )
          ],
        ),
      ),
    );
  }
}

class OtherCarFeatures extends StatefulWidget {
  OtherCarFeatures({
    Key? key,
    required this.featureText,
    required this.featureValue,
    required this.featureList,
  }) : super(key: key);

  String featureText;
  bool featureValue;
  var featureList;

  @override
  State<OtherCarFeatures> createState() =>
      _OtherCarFeaturesState(featureText, featureValue, featureList);
}

class _OtherCarFeaturesState extends State<OtherCarFeatures> {
  String featureText;
  bool featureValue;
  var featureList;
  _OtherCarFeaturesState(this.featureText, this.featureValue, this.featureList);

  @override
  Widget build(BuildContext context) {
    return CheckboxListTile(
      title: Text(
        featureText,
        style: TextStyle(color: Colors.white70),
      ),
      //secondary: Icon(
      //Icons.person,
      //color: Colors.white70,
      //),
      controlAffinity: ListTileControlAffinity.leading,
      value: featureValue,
      onChanged: (value) {
        setState(() {
          this.featureValue = value!;
        });
        if (featureValue) {
          featureList.add(featureText);
        } else {
          featureList.removeAt(featureList.indexOf(featureText));
        }
        print(featureList);
      },
      activeColor: Color(0xFFdb9e1f),
      checkColor: Colors.white,
      side: BorderSide(
        color: Colors.white70,
        width: 1.5,
      ),
    );
  }
}
