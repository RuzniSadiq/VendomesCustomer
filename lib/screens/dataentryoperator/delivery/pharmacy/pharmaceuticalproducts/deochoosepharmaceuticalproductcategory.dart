import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:worldsgate/helper/responsive_helper.dart';
import '../../../../../widgets/deonavigationdrawer.dart';
import '../../../../../widgets/header.dart';
import 'deoaddpharmaceuticalproductdetails.dart';

class SelectPharmaceuticalProductCategory extends StatefulWidget {
  //const SelectPharmaceuticalProductCategory({Key? key}) : super(key: key);

  String? uid;
  String? pharmacyid;

  SelectPharmaceuticalProductCategory(this.uid, this.pharmacyid);

  @override
  State<SelectPharmaceuticalProductCategory> createState() => _SelectPharmaceuticalProductCategoryState();
}

class _SelectPharmaceuticalProductCategoryState extends State<SelectPharmaceuticalProductCategory> {
  final _formkey = GlobalKey<FormState>();
  var _scaffoldState = new GlobalKey<ScaffoldState>();

  final TextEditingController pharmaceuticalproductCategoryNameController =
      TextEditingController();

  String? pharmaceuticalproductcategory;
  String? subcategory;
  String? pharmaceuticalproductcategorydropdownvalue;

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

  getpharmaceuticalproductcategories() async {
    await FirebaseFirestore.instance
        .collection('delivery')
        .doc("9WRNvPkoftSw4o2rHGUI")
        .collection('pharmacys')
        .doc(widget.pharmacyid)
        .collection('pharmaceuticalproductcategory')
        .get()
        .then((QuerySnapshot querySnapshot) => {
              querySnapshot.docs.forEach((doc) {
                setState(() {
                  name = doc['name'];
                  pharmaceuticalproductcategorydropdown!.add(name!);
                });
                print(pharmaceuticalproductcategorydropdown);
              })
            });
  }

  List<String>? pharmaceuticalproductcategorydropdown = [];

  @override
  void initState() {
    super.initState();
    getname();
    getpharmaceuticalproductcategories();
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
                      mobile: SelectPharmaceuticalProductCategoryContainer(context, "mobile"),
                      tab: SelectPharmaceuticalProductCategoryContainer(context, "tab"),
                      desktop: SelectPharmaceuticalProductCategoryContainer(context, "desktop"),
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

  Container SelectPharmaceuticalProductCategoryContainer(BuildContext context, String device) {
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
                            "Pharmaceutical product Category",
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
                                hintText: "Pharmaceutical product Category",
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
                              value: pharmaceuticalproductcategorydropdownvalue,
                              items: pharmaceuticalproductcategorydropdown!
                                  .map(buildMenuItem)
                                  .toList(),
                              onChanged: (value) => setState(() {
                                    this.pharmaceuticalproductcategorydropdownvalue =
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
                                  builder: (context) => AddPharmaceuticalProductDetails(
                                      widget.uid,
                                      widget.pharmacyid,
                                      pharmaceuticalproductcategorydropdownvalue)));
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
