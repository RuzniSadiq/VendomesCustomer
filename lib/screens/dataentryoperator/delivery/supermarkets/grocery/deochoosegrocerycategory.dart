import 'dart:io';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:image_picker/image_picker.dart';
import 'package:universal_io/io.dart' as u;
import 'package:path/path.dart';
import 'package:worldsgate/helper/responsive_helper.dart';
import 'package:worldsgate/screens/dataentryoperator/delivery/supermarkets/grocery/deoaddgrocerydetails.dart';

import '../../../../../widgets/deonavigationdrawer.dart';
import '../../../../../widgets/header.dart';

class SelectGroceryCategory extends StatefulWidget {
  //const SelectGroceryCategory({Key? key}) : super(key: key);

  String? uid;
  String? supermarketid;

  SelectGroceryCategory(this.uid, this.supermarketid);

  @override
  State<SelectGroceryCategory> createState() => _SelectGroceryCategoryState();
}

class _SelectGroceryCategoryState extends State<SelectGroceryCategory> {
  final _formkey = GlobalKey<FormState>();
  var _scaffoldState = new GlobalKey<ScaffoldState>();

  final TextEditingController groceryCategoryNameController =
      TextEditingController();

  String? grocerycategory;
  String? subcategory;
  String? grocerycategorydropdownvalue;

  var entryList;

  List<String> tags = [];

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

  String? cusname;
  String? role;

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

  String? name;

  getgrocerycategories() async {
    await FirebaseFirestore.instance
        .collection('delivery')
        .doc("9WRNvPkoftSw4o2rHGUI")
        .collection('supermarkets')
        .doc(widget.supermarketid)
        .collection('grocerycategory')
        .get()
        .then((QuerySnapshot querySnapshot) => {
              querySnapshot.docs.forEach((doc) {
                setState(() {
                  name = doc['name'];
                  grocerycategorydropdown!.add(name!);
                });
                print(grocerycategorydropdown);
              })
            });
  }

  List<String>? grocerycategorydropdown = [];

  @override
  void initState() {
    super.initState();
    getname();
    getgrocerycategories();
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
                      mobile: SelectGroceryCategoryContainer(context, "mobile"),
                      tab: SelectGroceryCategoryContainer(context, "tab"),
                      desktop: SelectGroceryCategoryContainer(context, "desktop"),
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

  Container SelectGroceryCategoryContainer(BuildContext context, String device) {
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
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Align(
                          alignment: Alignment.topLeft,
                          child: Text(
                            "Grocery Category",
                            style:
                                TextStyle(color: Colors.white, fontSize: 16.0),
                          ),
                        ),
                      ),
                      Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: DropdownButtonFormField(
                              validator: (value) =>
                                  value == null ? 'field required' : null,
                              decoration: InputDecoration(
                                hintText: "Grocery Category",
                                hintStyle: TextStyle(color: Colors.white70),
                                labelText: 'Grocery Catgeory',
                                labelStyle: TextStyle(
                                    color: Colors.white70, height: 0.1),
                                enabled: true,
                                enabledBorder: UnderlineInputBorder(
                                  borderSide:
                                      new BorderSide(color: Colors.white70),
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
                              value: grocerycategorydropdownvalue,
                              items: grocerycategorydropdown!
                                  .map(buildMenuItem)
                                  .toList(),
                              onChanged: (value) => setState(() {
                                    this.grocerycategorydropdownvalue =
                                        value as String?;
                                  }))),
                      Container(
                        width: 100.0,
                        height: 50.0,
                        margin: EdgeInsets.only(top: 40.0),
                        child: ElevatedButton(
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
                            if (_formkey.currentState!.validate()) {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => AddgroceryDetails(
                                      widget.uid,
                                      widget.supermarketid,
                                      grocerycategorydropdownvalue)));
                            }
                          },
                          child: const Text(
                            'Select',
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
