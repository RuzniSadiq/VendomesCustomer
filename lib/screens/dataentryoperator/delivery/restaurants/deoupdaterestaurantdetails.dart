import 'dart:io';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:worldsgate/helper/responsive_helper.dart';
import 'package:worldsgate/screens/dataentryoperator/delivery/restaurants/deomanagerestaurant.dart';
import '../../../../widgets/deonavigationdrawer.dart';
import '../../../../widgets/header.dart';

class UpdateRestaurantDetails extends StatefulWidget {
  String? uid;
  String? restaurantid;

  //const UpdateRestaurantDetails({ Key? key }) : super(key: key);
  UpdateRestaurantDetails(this.uid, this.restaurantid);

  @override
  State<UpdateRestaurantDetails> createState() => _UpdateRestaurantDetailsState();
}

class _UpdateRestaurantDetailsState extends State<UpdateRestaurantDetails> {
  final _formkey = GlobalKey<FormState>();
  var _scaffoldState = new GlobalKey<ScaffoldState>();

  final TextEditingController restaurantNameController =
  TextEditingController();
  final TextEditingController preptimeController = TextEditingController();
  final TextEditingController cityNameController = TextEditingController();
  final TextEditingController minimumorderpriceController =
  TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController deliverychargeController = TextEditingController();
  final TextEditingController addressController = TextEditingController();


  String? city;
  String? deliverytypechosen;
  bool? livetrackingbool;
  bool? deliverychargeavailable;


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

  final deliveryType = [
    "Free",
    "Paid",
  ];

  String? livetrackingchosen;
  final livetracking = [
    "Yes",
    "No",
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
          final destination = '/delivery/restaurantimages/restaurantmain/$filename';
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
  List<String> OtherrestaurantImagesUrl = [];

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
            final destination = '/delivery/restaurantimages/restaurantsub/$filename';
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
            OtherrestaurantImagesUrl.add(otherImageLink);
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


  getyoo() async {
        FirebaseFirestore.instance
            .collection('delivery').doc("9WRNvPkoftSw4o2rHGUI")
            .collection('restaurants').doc(widget.restaurantid)
            .get()
            .then((myDocuments) {
          setState(() {
            restaurantNameController.text = myDocuments.data()!['name'].toString();
            city = myDocuments.data()!['city'].toString();
            minimumorderpriceController.text = myDocuments.data()!['minimumorderprice'].toString();
            preptimeController.text = myDocuments.data()!['preparationtime'].toString();
            deliverychargeController.text = myDocuments.data()!['deliverycharge'].toString();
            descriptionController.text = myDocuments.data()!['description'].toString();
            addressController.text = myDocuments.data()!['address'].toString();
            coverImageLink = myDocuments.data()!['coverimage'].toString();
            deliverytypechosen = myDocuments.data()!['delivery'].toString();
            livetrackingchosen = myDocuments.data()!['livetracking'].toString();
            for (int i = 0;
            i < myDocuments.data()!['otherrestaurantimages'].length;
            i++) {
              print(OtherrestaurantImagesUrl.length);
              OtherrestaurantImagesUrl.add(myDocuments.data()!['otherrestaurantimages'][i]);
            }
          });

        });


  }

  _uploadHotelData() async {

    try {
      if (deliverytypechosen == "Paid"){

        await FirebaseFirestore.instance
            .collection('delivery').doc("9WRNvPkoftSw4o2rHGUI")
            .collection('restaurants').doc(widget.restaurantid).update({
          'name': restaurantNameController.text,
          'minimumorderprice':
          double.parse(minimumorderpriceController.text),
          'preparationtime': double.parse(preptimeController.text),
          'description': descriptionController.text,
          'city': city,
          'coverimage': coverImageLink,
          'otherrestaurantimages': OtherrestaurantImagesUrl,
          'delivery': deliverytypechosen,
          'livetracking': livetrackingchosen,
          'deliverycharge': deliverychargeController.text,
          'address': addressController.text,
        });


      }else{
        await FirebaseFirestore.instance
            .collection('delivery').doc("9WRNvPkoftSw4o2rHGUI")
            .collection('restaurants').doc(widget.restaurantid).update({
          'name': restaurantNameController.text,
          'minimumorderprice':
          double.parse(minimumorderpriceController.text),
          'preparationtime': double.parse(preptimeController.text),
          'description': descriptionController.text,
          'city': city,
          'coverimage': coverImageLink,
          'otherrestaurantimages': OtherrestaurantImagesUrl,
          'delivery': deliverytypechosen,
          'livetracking': livetrackingchosen,
          'deliverycharge': 0,
          'address': addressController.text,
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
    getyoo();
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
                      mobile: UpdateRestaurantDetailsContainer(context, "mobile"),
                      tab: UpdateRestaurantDetailsContainer(context, "tab"),
                      desktop: UpdateRestaurantDetailsContainer(context, "desktop"),
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

  Container UpdateRestaurantDetailsContainer(BuildContext context, String device) {
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
                            return "Restaurant name cannot be empty";
                          }
                        },
                        onSaved: (value) {
                          restaurantNameController.text = value!;
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
                              child: TextFormField(
                                style: TextStyle(color: Colors.white),
                                controller: minimumorderpriceController,
                                inputFormatters: <TextInputFormatter>[
                                  FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                                ],
                                decoration: InputDecoration(
                                  suffixIcon: IconButton(
                                      icon: Icon(
                                        Icons.cancel,
                                        color: Color(0xFFdb9e1f),
                                      ),
                                      onPressed: () {
                                        minimumorderpriceController..text = "";
                                      }),
                                  hintText: "Minimum Order price",
                                  labelText: "Minimum Order Price",
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
                                    return "Minimum order price cannot be empty";
                                  }
                                },
                                onSaved: (value) {
                                  minimumorderpriceController.text = value!;
                                },
                                keyboardType: TextInputType.number,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        style: TextStyle(color: Colors.white),
                        maxLines: null,
                        controller: preptimeController,
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                        ],
                        decoration: InputDecoration(
                          suffixIcon: IconButton(
                              icon: Icon(
                                Icons.cancel,
                                color: Color(0xFFdb9e1f),
                              ),
                              onPressed: () {
                                preptimeController..text = "";
                              }),
                          hintText: "Enter deal time",
                          labelText: "Deal Time",
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
                            return "Deal time cannot be empty";
                          }
                        },
                        onSaved: (value) {
                          preptimeController.text = value!;
                        },
                        keyboardType: TextInputType.multiline,
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
                      (deliverytypechosen == "Paid")
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
                        controller: addressController,
                        decoration: InputDecoration(
                          suffixIcon: IconButton(
                              icon: Icon(
                                Icons.cancel,
                                color: Color(0xFFdb9e1f),
                              ),
                              onPressed: () {
                                addressController..text = "";
                              }),
                          hintText: "Enter restaurant address",
                          labelText: "Restaurant address",
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
                            return "Restaurant address cannot be empty";
                          }
                        },
                        onSaved: (value) {
                          addressController.text = value!;
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
                            return "Restaurant description cannot be empty";
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
                      (coverImageLink != "")
                          ? Container(
                        height: 100,
                        width: 100,
                        decoration: BoxDecoration(
                            image: DecorationImage(
                                image: NetworkImage('$coverImageLink'),
                                fit: BoxFit.cover)),
                        child: Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Align(
                            alignment: Alignment.topRight,
                            child: CircleAvatar(
                              radius: 12,
                              backgroundColor: Colors.white,
                              child: IconButton(
                                onPressed: (){

                                  _showMyDialog();




                                },

                                icon: Icon(Icons.close, color: Colors.red, size: 9, ),
                              ),
                            ),
                          ),
                        ),


                      )
                          : SizedBox(
                        height: 10,
                      ),

                      SizedBox(
                        height: 40,
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
                      OtherrestaurantImagesUrl.length != 0
                          ? Container(
                              width: MediaQuery.of(context).size.width / 1.6,
                              height: 160,
                              child: GridView.builder(
                                  itemCount: OtherrestaurantImagesUrl.length,
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
                                                        OtherrestaurantImagesUrl[index]),
                                                    fit: BoxFit.cover)),
                                          child:  Padding(
                                            padding: const EdgeInsets.all(4.0),
                                            child: Align(
                                              alignment: Alignment.topRight,
                                              child: CircleAvatar(
                                                radius: 12,
                                                backgroundColor: Colors.white,
                                                child: IconButton(
                                                  onPressed: (){

                                                    _showMyDialogOtherImage(OtherrestaurantImagesUrl[index], index);




                                                  },

                                                  icon: Icon(Icons.close, color: Colors.red, size: 9, ),
                                                ),
                                              ),
                                            ),
                                          ),


                                        ),
                                      ),
                                    );
                                    //Text('Image : ' + index.toString());
                                  }),
                            )
                          : SizedBox(
                              height: 10,
                            ),
                      SizedBox(
                        height: 30,
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


  _removefoodCoverPhoto(url) async {
    await FirebaseStorage.instance.refFromURL(url).delete();


    FirebaseFirestore.instance
        .collection('delivery').doc("9WRNvPkoftSw4o2rHGUI")
        .collection('restaurants').doc(widget.restaurantid)
        .update({
      'coverimage': "",
    });

    setState(() {
      //coverImageList.removeAt(coverImageList.indexOf(url));
      coverImageLink = "";
    });
  }

  _removerestaurantOtherPhoto(url, theindex) async {
  //await FirebaseStorage.instance.refFromURL(url).delete();

    var list = [url];
    FirebaseFirestore.instance
        .collection('delivery').doc("9WRNvPkoftSw4o2rHGUI")
        .collection('restaurants').doc(widget.restaurantid)
        .update({
      'otherrestaurantimages': FieldValue.arrayRemove(list),
    });
  print(OtherrestaurantImagesUrl.elementAt(theindex));
  print(theindex);
 // var toremove = [OtherrestaurantImagesUrl.elementAt(theindex)];
    setState(() {

     OtherrestaurantImagesUrl.remove(OtherrestaurantImagesUrl.elementAt(theindex));
      //FieldValue.arrayRemove(toremove);
    });
    //
    // setState(() {
    //   //coverImageList.removeAt(coverImageList.indexOf(url));
    //   coverImageLink = "";
    // });
  }

  Future<void> _showMyDialog() async {
    return showDialog<void>(
      context: this.context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete'),
          content: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Text('You are about to delete this image.'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Confirm'),
              onPressed: () {
                setState(() {
                  _removefoodCoverPhoto(coverImageLink);
                  coverImageLink = "";

                });
                print('Confirmed');
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _showMyDialogOtherImage(String x, int theindex) async {
    return showDialog<void>(
      context: this.context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete'),
          content: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Text('You are about to delete this image.'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Confirm'),
              onPressed: () {
                setState(() {
                  _removerestaurantOtherPhoto(x, theindex);

                });
                print('Confirmed');
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}


