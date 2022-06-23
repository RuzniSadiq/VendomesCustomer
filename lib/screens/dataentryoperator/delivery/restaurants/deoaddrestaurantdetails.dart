import 'dart:io';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:universal_io/io.dart' as u;
import 'package:path/path.dart';
import 'package:worldsgate/helper/responsive_helper.dart';
import 'package:worldsgate/screens/dataentryoperator/delivery/restaurants/deomanagerestaurant.dart';

import '../../../../widgets/deonavigationdrawer.dart';
import '../../../../widgets/header.dart';


class AddRestaurantDetails extends StatefulWidget {
  //const AddRestaurantDetails({Key? key}) : super(key: key);

  String? uid;

  AddRestaurantDetails(this.uid);

  @override
  State<AddRestaurantDetails> createState() => _AddRestaurantDetailsState();
}

class _AddRestaurantDetailsState extends State<AddRestaurantDetails> {
  final _formkey = GlobalKey<FormState>();
  var _scaffoldState = new GlobalKey<ScaffoldState>();

  final TextEditingController restaurantNameController =
      TextEditingController();
  final TextEditingController distanceController = TextEditingController();
  final TextEditingController minimumOrderprepTimeController =
      TextEditingController();
  final TextEditingController prepTimeController = TextEditingController();
  final TextEditingController restaurantAddressController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController deliverychargeController =
      TextEditingController();



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


  String? deliverytypechosen;
  final deliveryType = [
    "Free",
    "Paid",
  ];

  String? livetrackingchosen;
  final livetracking = [
    "Yes",
    "No",
  ];

  List<String> otherFeatures = [
    'Sensors',
    'Bluetooth',
    'Camera',
    'Safety',
    'Mp3/CD',
  ];

  bool _isLoading = true;

  bool _isMainUploading = false;
  bool _isOtherUploading = false;

  FilePickerResult? result;
  String? file;
  UploadTask? task;
  var coverImageLink;
  List<Uint8List> coverImage = [];

  Future selectFileandUpload() async {
    print('OS: ${u.Platform.operatingSystem}');
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
          final destination = '/restaurantimages/restaurantmain/$filename';
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
  List<String> OtherRestaurantImagesUrl = [];

  List<File>? files;

  Future selectOtherFileandUpload() async {
    print('OS: ${u.Platform.operatingSystem}');
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
            final destination = '/restaurantimages/restaurantsub/$filename';
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
            OtherRestaurantImagesUrl.add(otherImageLink);
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

  bool? livetrackingbool;
  bool? deliverychargeavailable;

  _uploadHotelData() async {
    DateTime currentPhoneDate = DateTime.now(); //DateTime

    Timestamp myTimeStamp = Timestamp.fromDate(currentPhoneDate);
    DateTime dt = (myTimeStamp as Timestamp).toDate();
    String formattedDate = DateFormat('yyyy/MM/dd').format(dt);
    String newrestaurantid =
        FirebaseFirestore.instance.collection('restaurants').doc().id;

    try {
      if (deliverychargeavailable == true) {
        await FirebaseFirestore.instance
            .collection('delivery')
            .doc("9WRNvPkoftSw4o2rHGUI")
            .collection('restaurants')
            .doc(newrestaurantid)
            .set({
          'name': restaurantNameController.text,
          'minimumorderprice':
              double.parse(minimumOrderprepTimeController.text),
          'preparationtime': double.parse(prepTimeController.text),
          'city': city,
          'address': restaurantAddressController.text,
          'mainfoodcategories': [],
          'description': descriptionController.text,
          'datecreated': DateTime.now(),
          'dataentryuid': widget.uid,
          'coverimage': coverImageLink,
          'otherrestaurantimages': OtherRestaurantImagesUrl,
          'restaurantid': newrestaurantid,
          'delivery': deliverytypechosen,
          'livetracking': livetrackingbool,
          'deliverycharge': descriptionController.text,
          'date': formattedDate
        });
      } else {
        await FirebaseFirestore.instance
            .collection('delivery')
            .doc("9WRNvPkoftSw4o2rHGUI")
            .collection('restaurants')
            .doc(newrestaurantid)
            .set({
          'name': restaurantNameController.text,
          'minimumorderprice':
              double.parse(minimumOrderprepTimeController.text),
          'preparationtime': double.parse(prepTimeController.text),
          'city': city,
          'address': restaurantAddressController.text,
          'mainfoodcategories': [],
          'description': descriptionController.text,
          'datecreated': DateTime.now(),
          'dataentryuid': widget.uid,
          'coverimage': coverImageLink,
          'otherrestaurantimages': OtherRestaurantImagesUrl,
          'restaurantid': newrestaurantid,
          'delivery': deliverytypechosen,
          'livetracking': livetrackingbool,
          'deliverycharge': 0,
          'date': formattedDate
        });
      }
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
                      mobile: addRestaurantDetailsContainer(context, "mobile"),
                      tab: addRestaurantDetailsContainer(context, "tab"),
                      desktop:
                          addRestaurantDetailsContainer(context, "desktop"),
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

  Container addRestaurantDetailsContainer(BuildContext context, String device) {
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
                        controller: restaurantNameController,
                        decoration: InputDecoration(
                          suffixIcon: IconButton(
                              icon: Icon(
                                Icons.cancel,
                                color: Color(0xFFdb9e1f),
                              ),
                              onPressed: () {
                                restaurantNameController..text = "";
                              }),
                          hintText: "Enter restaurant name",
                          labelText: "Restaurant Name",
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
                            return "restaurant name cannot be empty";
                          }
                        },
                        onSaved: (value) {
                          restaurantNameController.text = value!;
                        },
                        keyboardType: TextInputType.text,
                      ),

                      SizedBox(
                        height: 20.0,
                      ),
                      TextFormField(
                        keyboardType: TextInputType.number,
                        controller: minimumOrderprepTimeController,
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                        ],
                        style: TextStyle(color: Colors.white),
                        // controller: restaurantNameController,
                        decoration: InputDecoration(
                          suffixIcon: IconButton(
                              icon: Icon(
                                Icons.cancel,
                                color: Color(0xFFdb9e1f),
                              ),
                              onPressed: () {
                                //  restaurantNameController..text = "";
                              }),
                          hintText: "Minimum Order Price",
                          labelText: "Minimum Order Price",
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
                            return "restaurant name cannot be empty";
                          }
                        },
                        onSaved: (value) {
                          //   restaurantNameController.text = value!;
                        },
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        keyboardType: TextInputType.number,
                        controller: prepTimeController,
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                        ],
                        style: TextStyle(color: Colors.white),
                        // controller: restaurantNameController,
                        decoration: InputDecoration(
                          suffixIcon: IconButton(
                              icon: Icon(
                                Icons.cancel,
                                color: Color(0xFFdb9e1f),
                              ),
                              onPressed: () {
                                prepTimeController..text = "";
                              }),
                          hintText: "Preparation Time",
                          labelText: "Preparation Time",
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
                            return "preparation time cannot be empty";
                          }
                        },
                        onSaved: (value) {
                          prepTimeController.text = value!;
                        },
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      DropdownButtonFormField(
                          decoration: InputDecoration(
                            hintText: "Delivery Type",
                            hintStyle: TextStyle(color: Colors.white70),
                            labelText: 'Delivery Type',
                            labelStyle:
                                TextStyle(color: Colors.white70, height: 0.1),
                            enabled: true,
                            enabledBorder: UnderlineInputBorder(
                              borderSide: new BorderSide(color: Colors.white70),
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide:
                                  new BorderSide(color: Color(0xFFdb9e1f)),
                            ),
                          ),
                          dropdownColor: Color(0xFF000000),
                          //focusColor: Color(0xFFdb9e1f),
                          style: TextStyle(color: Colors.white),
                          isExpanded: true,
                          value: deliverytypechosen,
                          items: deliveryType.map(buildMenuItem).toList(),
                          onChanged: (value) => setState(() {
                                deliverytypechosen = value as String?;
                                if (value == "Paid") {
                                  setState(() {
                                    deliverychargeavailable = true;
                                  });
                                } else {
                                  setState(() {
                                    deliverychargeavailable = false;
                                  });
                                }
                              })),
                      SizedBox(
                        height: 20,
                      ),
                      (deliverychargeavailable == true)
                          ? Padding(
                              padding: const EdgeInsets.only(bottom: 20.0),
                              child: TextFormField(
                                keyboardType: TextInputType.number,
                                inputFormatters: <TextInputFormatter>[
                                  FilteringTextInputFormatter.allow(
                                      RegExp(r'[0-9]')),
                                ],
                                controller: deliverychargeController,
                                style: TextStyle(color: Colors.white),
                                // controller: restaurantNameController,
                                decoration: InputDecoration(
                                  suffixIcon: IconButton(
                                      icon: Icon(
                                        Icons.cancel,
                                        color: Color(0xFFdb9e1f),
                                      ),
                                      onPressed: () {
                                        deliverychargeController..text = "";
                                      }),
                                  hintText: "Delivery Charge",
                                  labelText: "Delivery Charge",
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
                                    return "Delivery Charge cannot be empty";
                                  }
                                },
                                onSaved: (value) {
                                  deliverychargeController.text = value!;
                                },
                              ),
                            )
                          : Container(),
                      DropdownButtonFormField(
                          decoration: InputDecoration(
                            hintText: "Live Tracking",
                            hintStyle: TextStyle(color: Colors.white70),
                            labelText: 'Live Tracking',
                            labelStyle:
                                TextStyle(color: Colors.white70, height: 0.1),
                            enabled: true,
                            enabledBorder: UnderlineInputBorder(
                              borderSide: new BorderSide(color: Colors.white70),
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide:
                                  new BorderSide(color: Color(0xFFdb9e1f)),
                            ),
                          ),
                          dropdownColor: Color(0xFF000000),
                          //focusColor: Color(0xFFdb9e1f),
                          style: TextStyle(color: Colors.white),
                          isExpanded: true,
                          value: livetrackingchosen,
                          items: livetracking.map(buildMenuItem).toList(),
                          onChanged: (value) => setState(() {
                                livetrackingchosen = value as String?;
                                if (value == "Yes") {
                                  setState(() {
                                    livetrackingbool = true;
                                  });
                                } else {
                                  setState(() {
                                    livetrackingbool = false;
                                  });
                                }
                              })),
                      SizedBox(
                        height: 20,
                      ),


                      DropdownButtonFormField(
                          decoration: InputDecoration(
                            hintText: "Select place in UAE",
                            hintStyle: TextStyle(
                                color: Colors.white70),
                            labelText: 'Restaurant City',
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
                        maxLines: null,
                        controller: restaurantAddressController,
                        decoration: InputDecoration(
                          suffixIcon: IconButton(
                              icon: Icon(
                                Icons.cancel,
                                color: Color(0xFFdb9e1f),
                              ),
                              onPressed: () {
                                restaurantAddressController..text = "";
                              }),
                          hintText: "Enter restaurant address",
                          labelText: "Restaurant Address",
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
                            return "restaurant description cannot be empty";
                          }
                        },
                        onSaved: (value) {
                          restaurantAddressController.text = value!;
                        },
                        keyboardType: TextInputType.multiline,
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
                          hintText: "Enter restaurant description",
                          labelText: "Restaurant Description",
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
                            return "restaurant description cannot be empty";
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
                      // // const Align(
                      // //   alignment: Alignment.centerLeft,
                      // //   child: Text(
                      // //     "restaurant Tables",
                      // //     style: TextStyle(color: Colors.white70, fontSize: 16),
                      // //   ),
                      // // ),
                      // // SizedBox(
                      // //   height: 15,
                      // // ),
                      // // Padding(
                      // //   padding: const EdgeInsets.all(8.0),
                      // //   child: Container(
                      // //     width: 270.0,
                      // //     height: 50.0,
                      // //     child: ElevatedButton.icon(
                      // //       style: ElevatedButton.styleFrom(
                      // //           primary: Color(0xFF000000),
                      // //           shape: RoundedRectangleBorder(
                      // //               borderRadius:
                      // //                   BorderRadius.all(Radius.circular(20.0)),
                      // //               side: BorderSide(color: Color(0xFFdb9e1f))),
                      // //           side: BorderSide(
                      // //             width: 2.5,
                      // //             color: Color(0xFFdb9e1f),
                      // //           ),
                      // //           textStyle: const TextStyle(fontSize: 16)),
                      // //       onPressed: () {
                      // //         //selectFileandUpload();
                      // //       },
                      // //       icon: Icon(
                      // //         Icons.add,
                      // //         color: Colors.white,
                      // //         size: 20,
                      // //       ), //icon data for elevated button
                      // //       label: Text(
                      // //         "Add restaurant Tables",
                      // //         style: TextStyle(color: Colors.white),
                      // //       ),
                      // //       /*child: const Text(
                      // //                       'Hotel Cover Photo',
                      // //                       style: TextStyle(
                      // //                           color: Colors.white),
                      // //                     ),*/
                      // //     ),
                      // //   ),
                      // // ),
                      // // SizedBox(
                      // //   height: 15,
                      // // ),
                      // // Container(
                      // //   child: Row(
                      // //     mainAxisAlignment: MainAxisAlignment.spaceAround,
                      // //     children: [
                      // //       Expanded(
                      // //         child: Padding(
                      // //             padding: const EdgeInsets.symmetric(
                      // //                 horizontal: 8.0),
                      // //             child: DropdownButtonFormField(
                      // //                 decoration: InputDecoration(
                      // //                   hintText: "Number of Tables",
                      // //                   hintStyle:
                      // //                       TextStyle(color: Colors.white70),
                      // //                   labelText: 'Tables',
                      // //                   labelStyle: TextStyle(
                      // //                       color: Colors.white70, height: 0.1),
                      // //                   enabled: true,
                      // //                   enabledBorder: UnderlineInputBorder(
                      // //                     borderSide: new BorderSide(
                      // //                         color: Colors.white70),
                      // //                   ),
                      // //                   focusedBorder: UnderlineInputBorder(
                      // //                     borderSide: new BorderSide(
                      // //                         color: Color(0xFFdb9e1f)),
                      // //                   ),
                      // //                 ),
                      // //                 dropdownColor: Color(0xFF000000),
                      // //                 //focusColor: Color(0xFFdb9e1f),
                      // //                 style: TextStyle(color: Colors.white),
                      // //                 isExpanded: true,
                      // //                 value: model,
                      // //                 items: models.map(buildMenuItem).toList(),
                      // //                 onChanged: (value) => setState(() {
                      // //                       this.model = value as String?;
                      // //                     }))),
                      // //       ),
                      // //       Expanded(
                      // //         child: Padding(
                      // //             padding: const EdgeInsets.symmetric(
                      // //                 horizontal: 8.0),
                      // //             child: DropdownButtonFormField(
                      // //                 decoration: InputDecoration(
                      // //                   hintText: "Table Position",
                      // //                   hintStyle:
                      // //                       TextStyle(color: Colors.white70),
                      // //                   labelText: 'Position',
                      // //                   labelStyle: TextStyle(
                      // //                       color: Colors.white70, height: 0.1),
                      // //                   enabled: true,
                      // //                   enabledBorder: UnderlineInputBorder(
                      // //                     borderSide: new BorderSide(
                      // //                         color: Colors.white70),
                      // //                   ),
                      // //                   focusedBorder: UnderlineInputBorder(
                      // //                     borderSide: new BorderSide(
                      // //                         color: Color(0xFFdb9e1f)),
                      // //                   ),
                      // //                 ),
                      // //                 dropdownColor: Color(0xFF000000),
                      // //                 //focusColor: Color(0xFFdb9e1f),
                      // //                 style: TextStyle(color: Colors.white),
                      // //                 isExpanded: true,
                      // //                 value: model,
                      // //                 items: models.map(buildMenuItem).toList(),
                      // //                 onChanged: (value) => setState(() {
                      // //                       this.model = value as String?;
                      // //                     }))),
                      // //       ),
                      // //       Container(
                      // //         width: 170.0,
                      // //         height: 50.0,
                      // //         child: Padding(
                      // //           padding:
                      // //               const EdgeInsets.symmetric(horizontal: 8.0),
                      // //           child: ElevatedButton.icon(
                      // //             style: ElevatedButton.styleFrom(
                      // //                 primary: Color(0xFF000000),
                      // //                 shape: RoundedRectangleBorder(
                      // //                     borderRadius: BorderRadius.all(
                      // //                         Radius.circular(00.0)),
                      // //                     side: BorderSide(
                      // //                         color: Color(0xFFdb9e1f))),
                      // //                 side: BorderSide(
                      // //                   width: 2.5,
                      // //                   color: Color(0xFFdb9e1f),
                      // //                 ),
                      // //                 textStyle: const TextStyle(fontSize: 16)),
                      // //             onPressed: () {
                      // //               setState(() {
                      // //                 //typesOfBedsAndCount
                      // //                 //  .add("${numOfBeds} - ${bedType}");
                      // //               });
                      // //             },
                      // //             icon: Icon(
                      // //               Icons.add,
                      // //               color: Colors.white,
                      // //               size: 20,
                      // //             ),
                      // //             label: Text(
                      // //               "Add Table",
                      // //               style: TextStyle(color: Colors.white),
                      // //             ),
                      // //           ),
                      // //         ),
                      // //       ),
                      // //     ],
                      // //   ),
                      // // ),
                      // // SizedBox(
                      // //   height: 30,
                      // // ),
                      // Container(
                      //   child: Column(
                      //     children: [
                      //       Container(
                      //         height: 450.0,
                      //         width: MediaQuery.of(context).size.width / 1.6,
                      //         decoration: BoxDecoration(
                      //             border: Border.all(color: Color(0xFFdb9e1f))),
                      //         /*child: ListView.builder(
                      //             itemCount: typesOfBedsAndCount.length,
                      //             itemBuilder:
                      //                 (BuildContext context, int index) {
                      //               return new ListTile(
                      //                 title: Text(
                      //                   typesOfBedsAndCount[index],
                      //                   style: TextStyle(color: Colors.white70),
                      //                 ),
                      //                 trailing: IconButton(
                      //                     icon: Icon(
                      //                       Icons.delete,
                      //                       color: Color(0xFFdb9e1f),
                      //                     ),
                      //                     onPressed: () {
                      //                       setState(() {
                      //                         typesOfBedsAndCount.remove(
                      //                             typesOfBedsAndCount[index]);
                      //                       });
                      //                     }),
                      //               );
                      //             }),*/
                      //       ),
                      //     ],
                      //   ),
                      // ),
                      // SizedBox(
                      //   height: 30,
                      // ),
                      const Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Restaurant Cover Photo",
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
                              "Restaurant Cover Photo",
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
                      coverImage.length != 0
                          ? Container(
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
                                                  fit: BoxFit.cover))),
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
                      const Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Other restaurant Photos",
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
                              "Other restaurant Photos",
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
                              width: 100.0,
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
                                  _uploadHotelData();
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) =>
                                          DeoManageRestaurant(widget.uid)));
                                },
                                child: const Text(
                                  'Save',
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
