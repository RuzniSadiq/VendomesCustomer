import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:worldsgate/helper/responsive_helper.dart';
import '../../../../../widgets/deonavigationdrawer.dart';
import '../../../../../widgets/header.dart';
import 'deoaddfooddetails.dart';

class SelectFoodCategory extends StatefulWidget {
  //const SelectFoodCategory({Key? key}) : super(key: key);

  String? uid;
  String? restaurantid;

  SelectFoodCategory(this.uid, this.restaurantid);

  @override
  State<SelectFoodCategory> createState() => _SelectFoodCategoryState();
}

class _SelectFoodCategoryState extends State<SelectFoodCategory> {
  final _formkey = GlobalKey<FormState>();
  var _scaffoldState = new GlobalKey<ScaffoldState>();

  final TextEditingController foodCategoryNameController =
      TextEditingController();

  String? foodcategory;
  String? subcategory;
  String? foodcategorydropdownvalue;

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

  getfoodcategories() async {
    await FirebaseFirestore.instance
        .collection('delivery')
        .doc("9WRNvPkoftSw4o2rHGUI")
        .collection('restaurants')
        .doc(widget.restaurantid)
        .collection('foodcategory')
        .get()
        .then((QuerySnapshot querySnapshot) => {
              querySnapshot.docs.forEach((doc) {
                setState(() {
                  name = doc['name'];
                  foodcategorydropdown!.add(name!);
                });
                print(foodcategorydropdown);
              })
            });
  }

  List<String>? foodcategorydropdown = [];

  @override
  void initState() {
    super.initState();
    getname();
    getfoodcategories();
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
                      mobile: SelectFoodCategoryContainer(context, "mobile"),
                      tab: SelectFoodCategoryContainer(context, "tab"),
                      desktop: SelectFoodCategoryContainer(context, "desktop"),
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

  Container SelectFoodCategoryContainer(BuildContext context, String device) {
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
                            "Food Category",
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
                                hintText: "Food Category",
                                hintStyle: TextStyle(color: Colors.white70),
                                labelText: 'Catgeory',
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
                              value: foodcategorydropdownvalue,
                              items: foodcategorydropdown!
                                  .map(buildMenuItem)
                                  .toList(),
                              onChanged: (value) => setState(() {
                                    this.foodcategorydropdownvalue =
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
                                  builder: (context) => AddFoodDetails(
                                      widget.uid,
                                      widget.restaurantid,
                                      foodcategorydropdownvalue)));
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
