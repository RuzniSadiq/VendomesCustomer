import 'dart:io';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:universal_io/io.dart' as u;
import 'package:path/path.dart';
import 'package:worldsgate/helper/responsive_helper.dart';

import '../../../../../widgets/deonavigationdrawer.dart';
import '../../../../../widgets/header.dart';

class UpdatepharmaceuticalproductDetails extends StatefulWidget {
  //const UpdatepharmaceuticalproductDetails({Key? key}) : super(key: key);

  String? uid;
  String? pharmacyid;
  String? pharmaceuticalproductcatgeoryname;
  String? pharmaceuticalproductid;

  UpdatepharmaceuticalproductDetails(
      this.uid, this.pharmacyid, this.pharmaceuticalproductcatgeoryname, this.pharmaceuticalproductid);

  @override
  State<UpdatepharmaceuticalproductDetails> createState() => _UpdatepharmaceuticalproductDetailsState();
}

class _UpdatepharmaceuticalproductDetailsState extends State<UpdatepharmaceuticalproductDetails> {
  final _formkey = GlobalKey<FormState>();
  var _scaffoldState = new GlobalKey<ScaffoldState>();

  final TextEditingController pharmaceuticalproductNameController = TextEditingController();
  final TextEditingController pharmaceuticalproducttagController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  //String? pharmaceuticalproductcategory;
  String? subcategory;

  var entryList;

  List<String> tags = [];

  List<String> coverImageList = [];

  _removepharmaceuticalproductCoverPhoto(url) async {
    await FirebaseStorage.instance.refFromURL(url).delete();


    await FirebaseFirestore.instance
        .collection('delivery')
        .doc("9WRNvPkoftSw4o2rHGUI")
        .collection('pharmacys')
        .doc(widget.pharmacyid)
        .collection('pharmaceuticalproductcategory')
        .doc(pharmaceuticalproductcategoryid)
        .collection('pharmaceuticalproduct')
        .doc(widget.pharmaceuticalproductid)
        .update({
      'coverimage': "",
    });

    setState(() {
      //coverImageList.removeAt(coverImageList.indexOf(url));
      coverImageLink = "";
    });
  }

  final subcategoryType = [
    "Free",
    "Paid",
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
          final destination = '/pharmaceuticalproductimages/pharmaceuticalproductmain/$filename';
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

  String? cusname;
  String? role;
  String? pharmaceuticalproductcategoryid;

  _uploadpharmaceuticalproductData() async {
    //   String newpharmaceuticalproductId = FirebaseFirestore.instance.collection('pharmacys').doc(widget.pharmacyid).collection('pharmaceuticalproductcategory').doc(pharmaceuticalproductcategoryid).collection('pharmaceuticalproduct').doc().id;
    print(pharmaceuticalproductcategoryid);
    try {
      await FirebaseFirestore.instance
          .collection('delivery')
          .doc("9WRNvPkoftSw4o2rHGUI")
          .collection('pharmacys')
          .doc(widget.pharmacyid)
          .collection('pharmaceuticalproductcategory')
          .doc(pharmaceuticalproductcategoryid)
          .collection('pharmaceuticalproduct')
          .doc(widget.pharmaceuticalproductid)
          .update({
        'name': pharmaceuticalproductNameController.text,
        'tags': tags,
        'price': double.parse(priceController.text),
        'description': descriptionController.text,
        'datecreated': DateTime.now(),
        'dataentryuid': widget.uid,
        'coverimage': coverImageLink,
      });
    } catch (e) {
      print(e);
    }
  }

  getname() async {
    FirebaseFirestore.instance
        .collection('users')
        .doc(widget.uid)
        .get()
        .then((myDocuments) {
      setState(() {
        cusname = myDocuments.data()!['name'].toString();
        role = myDocuments.data()!['role'].toString();
      });
    });
  }

  String? pharmaceuticalproductname;
  String? pharmaceuticalproductprice;
  String? pharmaceuticalproductdescription;
  String? pharmaceuticalproductcoverimage;

  getyoo() async {
    await FirebaseFirestore.instance
        .collection('delivery')
        .doc("9WRNvPkoftSw4o2rHGUI")
        .collection('pharmacys')
        .doc(widget.pharmacyid)
        .collection('pharmaceuticalproductcategory')
        .where('name', isEqualTo: widget.pharmaceuticalproductcatgeoryname)
        .get()
        .then((QuerySnapshot querySnapshot) => {
              querySnapshot.docs.forEach((doc) {
                setState(() {
                  pharmaceuticalproductcategoryid = doc['pharmaceuticalproductcategoryid'].toString();
                });

                FirebaseFirestore.instance
                    .collection('delivery')
                    .doc("9WRNvPkoftSw4o2rHGUI")
                    .collection('pharmacys')
                    .doc(widget.pharmacyid)
                    .collection('pharmaceuticalproductcategory')
                    .doc(pharmaceuticalproductcategoryid)
                    .collection('pharmaceuticalproduct')
                    .doc(widget.pharmaceuticalproductid)
                    .get()
                    .then((myDocuments) {
                  setState(() {
                    pharmaceuticalproductname = myDocuments.data()!['name'].toString();
                    pharmaceuticalproductprice = myDocuments.data()!['price'].toString();
                    pharmaceuticalproductdescription =
                        myDocuments.data()!['description'].toString();
                    pharmaceuticalproductcoverimage =
                        myDocuments.data()!['coverimage'].toString();
                    // tags.add(myDocuments.data()!['tags']);

                    for (int i = 0;
                        i < myDocuments.data()!['tags'].length;
                        i++) {
                      tags.add(myDocuments.data()!['tags'][i]);
                    }

                    pharmaceuticalproductNameController.text = pharmaceuticalproductname!;
                    priceController.text = pharmaceuticalproductprice!;
                    descriptionController.text = pharmaceuticalproductdescription!;

                    coverImageLink = myDocuments.data()!['coverimage'];
                  });
                });
              })
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
                      mobile: UpdatepharmaceuticalproductDetailsContainer(context, "mobile"),
                      tab: UpdatepharmaceuticalproductDetailsContainer(context, "tab"),
                      desktop: UpdatepharmaceuticalproductDetailsContainer(context, "desktop"),
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

  List<Widget> newbuilder() {
    List<Widget> m = [];
    for (int i = 0; i < tags.length; i++) {
      m.add(Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Padding(
            padding: const EdgeInsets.all(4.0),
            child: RichText(
              maxLines: 5,
              text: TextSpan(children: [
                TextSpan(
                  text: "${tags[i].toString()}",
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.black87,
                  ),
                ),
                WidgetSpan(
                  alignment: PlaceholderAlignment.bottom,
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        tags.remove(tags[i]);
                      });
                    },
                    child: Icon(Icons.close, color: Colors.red, size: 17),
                  ),
                ),
              ]),
            ),
          ),
        ),
      ));
    }
    return m;
  }

  Container UpdatepharmaceuticalproductDetailsContainer(BuildContext context, String device) {
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
                        controller: pharmaceuticalproductNameController,
                        decoration: InputDecoration(
                          suffixIcon: IconButton(
                              icon: Icon(
                                Icons.cancel,
                                color: Color(0xFFdb9e1f),
                              ),
                              onPressed: () {
                                pharmaceuticalproductNameController..text = "";
                              }),
                          hintText: "Enter pharmaceuticalproduct name",
                          labelText: "pharmaceuticalproduct Name",
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
                            return "pharmaceuticalproduct name cannot be empty";
                          }
                        },
                        onSaved: (value) {
                          pharmaceuticalproductNameController.text = value!;
                        },
                        keyboardType: TextInputType.text,
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
                          hintText: "Enter pharmaceutical product description",
                          labelText: "Pharmaceutical product Description",
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
                            return "Pharmaceutical product description cannot be empty";
                          }
                        },
                        onSaved: (value) {
                          descriptionController.text = value!;
                        },
                        keyboardType: TextInputType.multiline,
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        style: TextStyle(color: Colors.white),
                        controller: pharmaceuticalproducttagController,
                        decoration: InputDecoration(
                          suffixIcon: IconButton(
                              icon: Icon(
                                Icons.cancel,
                                color: Color(0xFFdb9e1f),
                              ),
                              onPressed: () {
                                pharmaceuticalproducttagController..text = "";
                              }),
                          hintText: "Enter pharmaceutical product tag",
                          labelText: "Pharmaceutical product Tag",
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
                            return "Pharmaceutical product tag cannot be empty";
                          }
                        },
                        // onSaved: (value) {
                        //   pharmaceuticalproducttagController.text = value!;
                        // },
                        onFieldSubmitted: (value) {
                          //  pharmaceuticalproducttagController.text = value!;
                          setState(() {
                            tags.add(value);
                          });
                        },
                        keyboardType: TextInputType.text,
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Wrap(
                        direction: Axis.horizontal,
                        children: newbuilder(),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      const Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Pharmaceutical product Cover Photo",
                          style: TextStyle(color: Colors.white70, fontSize: 16),
                        ),
                      ),
                      SizedBox(
                        height: 15,
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
                        height: 30,
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
                              "Pharmaceutical product Cover Photo",
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
                                  //uploadMainFunction(_selectedFile);
                                  //uploadFile();
                                  _uploadpharmaceuticalproductData();
                                  // Navigator.of(context).push(MaterialPageRoute(
                                  //     builder: (context) =>
                                  //         AddpharmacyDetails(widget.uid)));
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
                  _removepharmaceuticalproductCoverPhoto(coverImageLink);
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





}
