import 'dart:io';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:worldsgate/helper/responsive_helper.dart';
import 'package:worldsgate/screens/dataentryoperator/booking/yacht/deomanageyachts.dart';
import '../../../../widgets/deonavigationdrawer.dart';
import '../../../../widgets/header.dart';

class UpdateYachtDetails extends StatefulWidget {
  String? uid;
  String? yachtid;

  //const UpdateYachtDetails({ Key? key }) : super(key: key);
  UpdateYachtDetails(this.uid, this.yachtid);

  @override
  State<UpdateYachtDetails> createState() => _UpdateYachtDetailsState();
}

class _UpdateYachtDetailsState extends State<UpdateYachtDetails> {
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

  String? builds;
  String? overnightguests;

  getyoo() async {
        FirebaseFirestore.instance
            .collection('booking').doc("aGAm7T71ShOqGUhYphfc")
            .collection('yachts').doc(widget.yachtid)
            .get()
            .then((myDocuments) {
              print(myDocuments.data()!['description'].toString());
          setState(() {
            yachtNameController.text = myDocuments.data()!['name'].toString();
            perhourpriceController.text = myDocuments.data()!['perhourprice'].toString();
            dailypriceController.text = myDocuments.data()!['dailyprice'].toString();
            capacityController.text = myDocuments.data()!['capacity'].toString();
            yachtlengthController.text = myDocuments.data()!['length'].toString();
            descriptionController.text = myDocuments.data()!['description'].toString();
            speedController.text = myDocuments.data()!['speed'].toString();
            coverImageLink = myDocuments.data()!['coverimage'];
            for (int i = 0;
            i < myDocuments.data()!['otheryachtimages'].length;
            i++) {
              print(OtherYachtImagesUrl.length);
              OtherYachtImagesUrl.add(myDocuments.data()!['otheryachtimages'][i]);
            }
            builds = myDocuments.data()!['build'].toString();
            yachtBuildvalue = builds;
            overnightguests = myDocuments.data()!['overnightguests'].toString();
            overNightGuestsvalue = overnightguests;
          });
        });


  }

  _uploadHotelData() async {

    try {
      await FirebaseFirestore.instance
          .collection('booking').doc("aGAm7T71ShOqGUhYphfc")
          .collection('yachts').doc(widget.yachtid).update({
        'name': yachtNameController.text,
        'perhourprice': double.parse(perhourpriceController.text),
        'dailyprice': double.parse(dailypriceController.text),
        'capacity': double.parse(capacityController.text),
        'description': descriptionController.text,
        'length': double.parse(yachtlengthController.text),
        'speed': double.parse(speedController.text),
        'coverimage': coverImageLink,
        'otheryachtimages': OtherYachtImagesUrl,
        'build': yachtBuildvalue,
        'overnightguests': overNightGuestsvalue,
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
                      mobile: UpdateYachtDetailsContainer(context, "mobile"),
                      tab: UpdateYachtDetailsContainer(context, "tab"),
                      desktop: UpdateYachtDetailsContainer(context, "desktop"),
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

  Container UpdateYachtDetailsContainer(BuildContext context, String device) {
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
                      OtherYachtImagesUrl.length != 0
                          ? Container(
                              width: MediaQuery.of(context).size.width / 1.6,
                              height: 160,
                              child: GridView.builder(
                                  itemCount: OtherYachtImagesUrl.length,
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
                                                        OtherYachtImagesUrl[index]),
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

                                                    _showMyDialogOtherImage(OtherYachtImagesUrl[index], index);




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
                                      value: builds,
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
                                          value: overnightguests,
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


  _removefoodCoverPhoto(url) async {
    await FirebaseStorage.instance.refFromURL(url).delete();


    FirebaseFirestore.instance
        .collection('booking').doc("aGAm7T71ShOqGUhYphfc")
        .collection('yachts').doc(widget.yachtid)
        .update({
      'coverimage': "",
    });

    setState(() {
      //coverImageList.removeAt(coverImageList.indexOf(url));
      coverImageLink = "";
    });
  }

  _removeyachtOtherPhoto(url, theindex) async {
  //await FirebaseStorage.instance.refFromURL(url).delete();

    var list = [url];
    FirebaseFirestore.instance
        .collection('booking').doc("aGAm7T71ShOqGUhYphfc")
        .collection('yachts').doc(widget.yachtid)
        .update({
      'otheryachtimages': FieldValue.arrayRemove(list),
    });
  print(OtherYachtImagesUrl.elementAt(theindex));
  print(theindex);
 // var toremove = [OtherYachtImagesUrl.elementAt(theindex)];
    setState(() {

     OtherYachtImagesUrl.remove(OtherYachtImagesUrl.elementAt(theindex));
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
                  _removeyachtOtherPhoto(x, theindex);

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


