import 'dart:io';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart';
import 'package:worldsgate/helper/responsive_helper.dart';
import 'package:worldsgate/screens/dataentryoperator/booking/yacht/deomanageyachts.dart';
import '../../../../widgets/deonavigationdrawer.dart';
import '../../../../widgets/header.dart';

class AddYachtDetails extends StatefulWidget {
  String? uid;

  //const AddYachtDetails({ Key? key }) : super(key: key);
  AddYachtDetails(this.uid);

  @override
  State<AddYachtDetails> createState() => _AddYachtDetailsState();
}

class _AddYachtDetailsState extends State<AddYachtDetails> {
  final _formkey = GlobalKey<FormState>();
  var _scaffoldState = new GlobalKey<ScaffoldState>();

  final TextEditingController yachtNameController = TextEditingController();
  final TextEditingController perhourpriceController = TextEditingController();
  final TextEditingController dailypriceController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController yachtlengthController = TextEditingController();
  final TextEditingController speedController = TextEditingController();
  final TextEditingController capacityController = TextEditingController();



  String? overNightGuestsvalue;
  String? yachtBuildvalue;

  final yachtBuild = [
    "Von Dutch",
    "Sunseeker",
    "Azimut",
    "Numarine",
    "Rodriguez",
    "Bennetti",
  ];


  final overNightGuests = [
    "2",
    "4",
    "6",
    "8",
    "10",
    "12",
    "N/A",
  ];

  final cabinType = ["Master", "Double", "VIP", "Twin"];

  final crew = [
    "Seychelles",
    "British",
    "Ukrainian",
    "South African",
    "French",
    "Filipino",
    "Australian",
    "Turkish"
  ];

  final engineType = [
    "V8",
  ];


  final seatsDoorsLuggageCount = [
    "2",
    "4",
    "6",
  ];

  bool featureBoolValue = true;

  List<String> otherFeatures = [
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
          final destination = '/booking/yachtimages/yachtmain/$filename';
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
  List<String> OtherYachtImagesUrl = [];

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
            final destination = '/booking/yachtimages/yachtsub/$filename';
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
            OtherYachtImagesUrl.add(otherImageLink);
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

  _uploadHotelData() async {
    DateTime currentPhoneDate = DateTime.now(); //DateTime

    Timestamp myTimeStamp = Timestamp.fromDate(currentPhoneDate);
    DateTime dt = (myTimeStamp as Timestamp).toDate();
    String formattedDate = DateFormat('yyyy/MM/dd').format(dt);
    String newYachtid = FirebaseFirestore.instance
        .collection('booking').doc("aGAm7T71ShOqGUhYphfc")
        .collection('yachts').doc().id;


    try {
      await FirebaseFirestore.instance
          .collection('booking').doc("aGAm7T71ShOqGUhYphfc")
          .collection('yachts').doc(newYachtid).set({
        'name': yachtNameController.text,
        'perhourprice': double.parse(perhourpriceController.text),
        'dailyprice': double.parse(dailypriceController.text),
        'capacity': double.parse(capacityController.text),
        'description': descriptionController.text,
        'length': double.parse(yachtlengthController.text),
        'speed': double.parse(speedController.text),
        'datecreated': DateTime.now(),
        'dataentryuid': widget.uid,
        'coverimage': coverImageLink,
        'otheryachtimages': OtherYachtImagesUrl,
        'yachtid': newYachtid,
        'build': yachtBuildvalue,
        'overnightguests': overNightGuestsvalue,
        'date': formattedDate,
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
                      mobile: addyachtDetailsContainer(context, "mobile"),
                      tab: addyachtDetailsContainer(context, "tab"),
                      desktop: addyachtDetailsContainer(context, "desktop"),
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

  Container addyachtDetailsContainer(BuildContext context, String device) {
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
                        controller: yachtNameController,
                        decoration: InputDecoration(
                          suffixIcon: IconButton(
                              icon: Icon(
                                Icons.cancel,
                                color: Color(0xFFdb9e1f),
                              ),
                              onPressed: () {
                                yachtNameController..text = "";
                              }),
                          hintText: "Enter yacht name",
                          labelText: "Yacht Name",
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
                            return "Yacht name cannot be empty";
                          }
                        },
                        onSaved: (value) {
                          yachtNameController.text = value!;
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
                                controller: perhourpriceController,
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
                                        perhourpriceController..text = "";
                                      }),
                                  hintText: "Enter per hour price",
                                  labelText: "Per Hour Price",
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
                                    return "Per hour price cannot be empty";
                                  }
                                },
                                onSaved: (value) {
                                  perhourpriceController.text = value!;
                                },
                                keyboardType: TextInputType.number,
                              ),
                            ),
                            Expanded(
                              child: Padding(
                                padding:
                                    const EdgeInsets.only(left: 8.0),
                                child: TextFormField(
                                  style: TextStyle(color: Colors.white),
                                  controller: dailypriceController,
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
                                          dailypriceController..text = "";
                                        }),
                                    hintText: "Enter daily price",
                                    labelText: "Daily Price",
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
                                      return "Daily price cannot be empty";
                                    }
                                  },
                                  onSaved: (value) {
                                    dailypriceController.text = value!;
                                  },
                                  keyboardType: TextInputType.number,
                                ),
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
                        controller: yachtlengthController,
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
                                yachtlengthController..text = "";
                              }),
                          hintText: "Enter yacht length",
                          labelText: "Yacht Length",
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
                            return "Yacht length cannot be empty";
                          }
                        },
                        onSaved: (value) {
                          yachtlengthController.text = value!;
                        },
                        keyboardType: TextInputType.multiline,
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        style: TextStyle(color: Colors.white),
                        maxLines: null,
                        controller: speedController,
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
                                speedController..text = "";
                              }),
                          hintText: "Enter yacht speed",
                          labelText: "Yacht Speed",
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
                            return "Yacht speed cannot be empty";
                          }
                        },
                        onSaved: (value) {
                          speedController.text = value!;
                        },
                        keyboardType: TextInputType.multiline,
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        style: TextStyle(color: Colors.white),
                        maxLines: null,
                        controller: capacityController,
                        inputFormatters:  [  FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                          ],
                        decoration: InputDecoration(
                          suffixIcon: IconButton(
                              icon: Icon(
                                Icons.cancel,
                                color: Color(0xFFdb9e1f),
                              ),
                              onPressed: () {
                                capacityController..text = "";
                              }),
                          hintText: "Enter capacity",
                          labelText: "Capacity",
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
                            return "Capacity cannot be empty";
                          }
                        },
                        onSaved: (value) {
                          capacityController.text = value!;
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
                          hintText: "Enter yacht description",
                          labelText: "Yacht Description",
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
                            return "Yacht description cannot be empty";
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
                          "Yacht Cover Photo",
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
                              "Yacht Cover Photo",
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
                          "Other Yacht Photos",
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
                              "Other Yacht Photos",
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
                                  child: DropdownButtonFormField(
                                      decoration: InputDecoration(
                                        hintText: "Build",
                                        hintStyle: TextStyle(
                                            color: Colors.white70),
                                        labelText: 'Build',
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
                                      value: yachtBuildvalue,
                                      items:
                                      yachtBuild.map(buildMenuItem).toList(),
                                      onChanged: (value) => setState(() {
                                            this.yachtBuildvalue = value as String?;
                                          })),
                                ),
                                Expanded(
                                  child: Padding(
                                      padding: const EdgeInsets.only(
                                          left: 8.0),
                                      child: DropdownButtonFormField(
                                          decoration: InputDecoration(
                                            hintText: "Overnight Guests",
                                            hintStyle: TextStyle(
                                                color: Colors.white70),
                                            labelText: 'Overnight Guests',
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
                                          value: overNightGuestsvalue,
                                          items: overNightGuests
                                              .map(buildMenuItem)
                                              .toList(),
                                          onChanged: (value) => setState(() {
                                                this.overNightGuestsvalue = value as String?;
                                              }))),
                                ),
                              ],
                            ),
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
                                          DeoManageYachts(widget.uid)));
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

class OtheryachtFeatures extends StatefulWidget {
  OtheryachtFeatures({
    Key? key,
    required this.featureText,
    required this.featureValue,
    required this.featureList,
  }) : super(key: key);

  String featureText;
  bool featureValue;
  var featureList;

  @override
  State<OtheryachtFeatures> createState() =>
      _OtheryachtFeaturesState(featureText, featureValue, featureList);
}

class _OtheryachtFeaturesState extends State<OtheryachtFeatures> {
  String featureText;
  bool featureValue;
  var featureList;
  _OtheryachtFeaturesState(this.featureText, this.featureValue, this.featureList);
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
