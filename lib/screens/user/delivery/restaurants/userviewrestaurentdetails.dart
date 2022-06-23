import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_number_picker/flutter_number_picker.dart';
import 'package:worldsgate/helper/responsive_helper.dart';
import 'package:worldsgate/widgets/usernavigationdrawer.dart';

import '../../../../widgets/cusheader.dart';

class UserViewRestaurantDetails extends StatefulWidget {
  //const UserViewRestaurantDetails({Key? key}) : super(key: key);

  String? uid;
  String? city;
  String? restaurantid;

  UserViewRestaurantDetails(this.uid, this.city, this.restaurantid);

  @override
  State<UserViewRestaurantDetails> createState() =>
      _UserViewRestaurantDetailsState();
}

class _UserViewRestaurantDetailsState extends State<UserViewRestaurantDetails> {
  var _scaffoldState = new GlobalKey<ScaffoldState>();

  var _controller = TextEditingController();

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

  var name = "";
  var coverimage = "";
  var city = "";
  int minPriceOrder = 0;

  bool _isLoading = true;

  _getRestaurantDetails() async {
    await FirebaseFirestore.instance
        .collection('delivery')
        .doc("9WRNvPkoftSw4o2rHGUI")
        .collection('restaurants')
        .doc(widget.restaurantid)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        setState(() {
          name = documentSnapshot['name'];
          coverimage = documentSnapshot['coverimage'];
          city = documentSnapshot['city'];
          minPriceOrder = documentSnapshot['minimumorderprice'];
        });
      } else {
        print("Document does not exist");
      }
    });
    setState(() {
      this._isLoading = false;
    });
  }

  Map orders = {
    'booking': {},
    'delivery': {'pharmacy': [], 'restaurants': [], 'supermarkets': []},
    'e-commerce': {}
  };

  num subTotal = 0;
  num deliveryCharge = 0;
  num totalAmount = 0;

  @override
  void initState() {
    _getRestaurantDetails();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return _isLoading
        ? Center(child: CircularProgressIndicator())
        : SafeArea(
            child: Scaffold(
            key: _scaffoldState,
            drawer: new UserNavigationDrawer(widget.uid, widget.city),
            backgroundColor: Color(0xFF000000),
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                showModalBottomSheet<void>(
                  context: context,
                  builder: (context) {
                    return StatefulBuilder(builder: (context, setState) {
                      return SingleChildScrollView(
                        child: Container(
                          //height: 600,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.0),
                            gradient: LinearGradient(colors: [
                              Color(0xFFd7a827),
                              Color(0xFFffe08c),
                              Color(0xFFefc65f),
                              Color(0xFFe7bd50),
                              Color(0xFFffe9ae),
                              Color(0xFFe2b13c),
                              Color(0xFFbe8b0d),
                            ]),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(2.0),
                            child: Container(
                              //height: 400,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10.0),
                                color: Color(0xFF000000),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  Container(
                                    width: width,
                                    height: 50,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10.0),
                                      gradient: LinearGradient(colors: [
                                        Color(0xFFd7a827),
                                        Color(0xFFffe08c),
                                        Color(0xFFefc65f),
                                        Color(0xFFe7bd50),
                                        Color(0xFFffe9ae),
                                        Color(0xFFe2b13c),
                                        Color(0xFFbe8b0d),
                                      ]),
                                    ),
                                    child: Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 2.0),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                          color: Color(0xFF000000),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Align(
                                            alignment: Alignment.centerLeft,
                                            child: Text(
                                              "Your Cart",
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text("Delivery",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold)),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 5.0),
                                            child: Text("Restaurants"),
                                          ),
                                          Row(
                                            children: [
                                              Text(
                                                "${name} ",
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              Text("- ${city}, UAE")
                                            ],
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          Container(
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(10.0),
                                                color: Colors.white
                                                    .withOpacity(0.7),
                                              ),
                                              child: ListView.builder(
                                                  shrinkWrap: true,
                                                  physics:
                                                      NeverScrollableScrollPhysics(),
                                                  itemCount: orders['delivery']
                                                          ['restaurants']
                                                      .length,
                                                  itemBuilder:
                                                      (BuildContext context,
                                                          int index) {
                                                    return ListTile(
                                                      leading:
                                                          CustomNumberPicker(
                                                        initialValue: 1,
                                                        maxValue: 100,
                                                        minValue: 1,
                                                        step: 1,
                                                        onValue: (value) {
                                                          print(
                                                              value.toString());
                                                          setState(() {
                                                            orders['delivery'][
                                                                    'restaurants']
                                                                [
                                                                index][0] = value;
                                                            subTotal = 0;
                                                            for (int i = 0;
                                                                i <
                                                                    orders['delivery']
                                                                            [
                                                                            'restaurants']
                                                                        .length;
                                                                i++) {
                                                              print(
                                                                  "The length of order array is ${orders['delivery']['restaurants'].length}");
                                                              subTotal = subTotal +
                                                                  (orders['delivery']['restaurants']
                                                                              [
                                                                              i]
                                                                          [0] *
                                                                      orders['delivery']
                                                                              [
                                                                              'restaurants']
                                                                          [
                                                                          i][2]);
                                                            }
                                                            subTotal;
                                                            totalAmount =
                                                                subTotal +
                                                                    deliveryCharge;
                                                          });
                                                          print(orders);
                                                        },
                                                      ),
                                                      title: Text(orders[
                                                                      'delivery']
                                                                  [
                                                                  'restaurants']
                                                              [index][1]
                                                          .toString()),
                                                      trailing: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .symmetric(
                                                                vertical: 6.0),
                                                        child: Column(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            Text(
                                                                "AED ${orders['delivery']['restaurants'][index][0] * orders['delivery']['restaurants'][index][2]}.00"),
                                                            InkWell(
                                                              onTap: () {
                                                                setState(() {
                                                                  orders['delivery']
                                                                          [
                                                                          'restaurants']
                                                                      .removeAt(
                                                                          index);
                                                                  subTotal = 0;
                                                                  for (int i =
                                                                          0;
                                                                      i <
                                                                          orders['delivery']['restaurants']
                                                                              .length;
                                                                      i++) {
                                                                    print(
                                                                        "The length of order array is ${orders['delivery']['restaurants'].length}");
                                                                    subTotal = subTotal +
                                                                        (orders['delivery']['restaurants'][i][0] *
                                                                            orders['delivery']['restaurants'][i][2]);
                                                                  }
                                                                  subTotal;
                                                                  totalAmount =
                                                                      subTotal +
                                                                          deliveryCharge;
                                                                });
                                                                print(orders);
                                                              },
                                                              child: Icon(Icons
                                                                  .remove_circle),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    );
                                                  }) /*ListTile(
                                            leading: CustomNumberPicker(
                                              initialValue: 1,
                                              maxValue: 100,
                                              minValue: 0,
                                              step: 1,
                                              onValue: (value) {
                                                print(value.toString());
                                              },
                                            ),
                                            title: Text(
                                                "Almond Milk Overnight Oats"),
                                            trailing: Padding(
                                              padding: const EdgeInsets.symmetric(
                                                  vertical: 6.0),
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text("AED 36.00"),
                                                  Icon(Icons.remove_circle),
                                                ],
                                              ),
                                            ),
                                          ),*/
                                              ),
                                          //Expanded(child: SizedBox()),
                                          SizedBox(height: 8.0),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text("Subtotal"),
                                              Text("AED ${subTotal}.00"),
                                            ],
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 8.0),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text("Delivery Fee"),
                                                Text("Free"),
                                              ],
                                            ),
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text("Total Amount"),
                                              Text("AED ${totalAmount}.00"),
                                            ],
                                          ),
                                          SizedBox(height: 20.0),
                                          Align(
                                            alignment: Alignment.center,
                                            child: Container(
                                              width: 250.0,
                                              height: 40.0,
                                              child: ElevatedButton(
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
                                                  //uploadMainFunction(_selectedFile);
                                                  //uploadFile();
                                                  /*_uploadHotelData();
                                                Navigator.of(context).push(
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            DeoManageHotels(
                                                                widget.uid)));*/
                                                },
                                                child: const Text(
                                                  'PROCEED TO CHECKOUT',
                                                  style: TextStyle(
                                                      color: Colors.white),
                                                ),
                                              ),
                                            ),
                                          ),
                                          /*Icon(
                                          Icons.shopping_bag,
                                          size: width * 0.5,
                                        ),
                                        Text(
                                          "There are no items in your cart",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        )*/
                                        ],
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    });
                  },
                );
              },
              child: Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(colors: [
                      Color(0xFFd7a827),
                      Color(0xFFffe08c),
                      Color(0xFFefc65f),
                      Color(0xFFe7bd50),
                      Color(0xFFffe9ae),
                      Color(0xFFe2b13c),
                      Color(0xFFbe8b0d),
                    ])),
                child: Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Color(0xFF000000),
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                    child: Icon(
                      Icons.shopping_cart,
                      size: 25,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              /*Icon(Icons.shopping_cart),*/
              //backgroundColor: Color(0xFFdb9e1f),
              //mini: true,
            ),
            floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
            body: Stack(
              children: [
                SingleChildScrollView(
                  child: ResponsiveWidget(
                    mobile:
                        buildColumnContent(context, height, width, "mobile"),
                    tab: buildColumnContent(context, height, width, "tab"),
                    desktop:
                        buildColumnContent(context, height, width, "desktop"),
                  ),
                ),
                Positioned(
                    left: 0.0,
                    top: 0.0,
                    right: 0.0,
                    child: Container(
                        child: VendomeHeaderCustomer(
                      drawer: _scaffoldState,
                      cusname: cusname,
                      cusaddress: widget.city,
                      role: role,
                    ))),
              ],
            ),
          ));
  }

  Padding buildColumnContent(
      BuildContext context, double height, double width, String device) {
    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: device == "mobile"
              ? width * 0.02
              : device == "tab"
                  ? width * 0.02
                  : device == "desktop"
                      ? width * 0.25
                      : width * 0),
      child: Column(
        children: [
          Container(
            margin: EdgeInsets.only(
                top: device == "mobile"
                    ? height * 0.09
                    : device == "tab"
                        ? height * 0.09
                        : device == "desktop"
                            ? height * 0.13
                            : 0),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              height: height * 0.1,
              child: Row(
                children: [
                  AspectRatio(
                      aspectRatio: 1 / 1,
                      child: Container(
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: NetworkImage(coverimage),
                            fit: BoxFit.cover,
                          ),
                        ),
                      )),
                  SizedBox(
                    width: device == "mobile"
                        ? width * 0.05
                        : device == "tab"
                            ? width * 0.05
                            : device == "desktop"
                                ? width * 0.05
                                : width * 0,
                  ),
                  Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          name + "             ",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 15),
                        ),
                        Text(
                          "in ${city}, UAE             ".toString(),
                          style: TextStyle(fontSize: 14),
                        ),
                        Text("Iranian, Kebab, Grills  ".toString(),
                            style: TextStyle(fontSize: 13)),
                        Text("Min. order: AED ${minPriceOrder}.00".toString(),
                            style: TextStyle(fontSize: 13))
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            height: height * 0.03,
          ),
          Container(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                device == "desktop"
                    ? Container(
                        width: width * 0.12,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              Container(
                                width: width * 0.11,
                                height: height * 0.4,
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Categories",
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text("Most Selling"),
                                    Text("Chef's Daily Special"),
                                    Text("Starters"),
                                    Text("Salads"),
                                    Text("Kebab Wraps"),
                                    Text("Speciality Wraps"),
                                    Text(
                                        "From The Char Grill - Kebab & Nan Duo"),
                                    Text("Pizza"),
                                    Text("Mana'eesh"),
                                    Text("Saj"),
                                    Text("Desserts"),
                                    Text("Drinks"),
                                    Text("Extras"),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    : SizedBox(),
                SingleChildScrollView(
                  child: Container(
                    width: device == "mobile"
                        ? width * 0.96
                        : device == "tab"
                            ? width * 0.96
                            : device == "desktop"
                                ? width * 0.24
                                : width * 0.24,
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextFormField(
                            style: TextStyle(color: Colors.white),
                            controller: _controller,
                            decoration: InputDecoration(
                              suffixIcon: IconButton(
                                  icon: Icon(
                                    Icons.cancel,
                                    color: Color(0xFFdb9e1f),
                                  ),
                                  onPressed: () {
                                    _controller..text = "";
                                  }),
                              hintText: "Enter menu item",
                              labelText: "Search Menu Item",
                              hintStyle: TextStyle(color: Colors.white70),
                              labelStyle: new TextStyle(color: Colors.white70),
                              enabled: true,
                              enabledBorder: OutlineInputBorder(
                                borderSide:
                                    new BorderSide(color: Colors.white70),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide:
                                    new BorderSide(color: Color(0xFFdb9e1f)),
                              ),
                            ),
                            validator: (value) {
                              if (value!.length == 0) {
                                return "Menu item cannot be empty";
                              }
                            },
                            onSaved: (value) {
                              _controller.text = value!;
                            },
                            keyboardType: TextInputType.text,
                          ),
                        ),
                        SizedBox(
                          height: height * 0.02,
                        ),
                        Column(
                          children: [
                            StreamBuilder<QuerySnapshot>(
                                stream: FirebaseFirestore.instance
                                    .collection('delivery')
                                    .doc("9WRNvPkoftSw4o2rHGUI")
                                    .collection('restaurants')
                                    .doc(widget.restaurantid)
                                    .collection('foodcategory')
                                    .snapshots(),
                                builder: (context, snapshot) {
                                  if (!snapshot.hasData) {
                                    return Center(
                                      child: CircularProgressIndicator(),
                                    );
                                  } else {
                                    return Column(
                                      children: snapshot.data!.docs
                                          .map((foodCategory) {
                                        return Column(
                                          children: [
                                            Container(
                                              width: width,
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Text(
                                                      "${foodCategory['name']}",
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      style: TextStyle(
                                                          fontSize: 16,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                    Icon(
                                                      Icons.arrow_drop_up,
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              height: height * 0.01,
                                            ),
                                            StreamBuilder<QuerySnapshot>(
                                              stream: FirebaseFirestore.instance
                                                  .collection('delivery')
                                                  .doc("9WRNvPkoftSw4o2rHGUI")
                                                  .collection('restaurants')
                                                  .doc(widget.restaurantid)
                                                  .collection('foodcategory')
                                                  .doc(foodCategory[
                                                      'foodcategoryid'])
                                                  .collection('food')
                                                  .snapshots(),
                                              builder: (context, snapshot) {
                                                if (!snapshot.hasData) {
                                                  return Center(
                                                    child:
                                                        CircularProgressIndicator(),
                                                  );
                                                } else {
                                                  return ListView(
                                                      shrinkWrap: true,
                                                      physics:
                                                          NeverScrollableScrollPhysics(),
                                                      children: snapshot
                                                          .data!.docs
                                                          .map((food) {
                                                        return Column(
                                                          children: [
                                                            ListTile(
                                                              leading:
                                                                  Container(
                                                                height: 50,
                                                                width: 50,
                                                                decoration:
                                                                    BoxDecoration(
                                                                  image:
                                                                      DecorationImage(
                                                                    image: NetworkImage(
                                                                        food['coverimage']
                                                                            .toString()),
                                                                    fit: BoxFit
                                                                        .cover,
                                                                  ),
                                                                ),
                                                              ),
                                                              title: Text(
                                                                  "${food['name']}"),
                                                              subtitle: Text(
                                                                  "${food['description']}"),
                                                              trailing: Column(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceBetween,
                                                                children: [
                                                                  Text(
                                                                      "AED ${food['price']}.00"),
                                                                  InkWell(
                                                                    onTap: () {
                                                                      setState(
                                                                          () {
                                                                        orders['delivery']['restaurants']
                                                                            .add([
                                                                          1,
                                                                          food[
                                                                              'name'],
                                                                          food[
                                                                              'price'],
                                                                          food[
                                                                              'foodid']
                                                                        ]);
                                                                        subTotal =
                                                                            0;
                                                                        for (int i =
                                                                                0;
                                                                            i < orders['delivery']['restaurants'].length;
                                                                            i++) {
                                                                          print(
                                                                              "The length of order array is ${orders['delivery']['restaurants'].length}");
                                                                          subTotal =
                                                                              subTotal + (orders['delivery']['restaurants'][i][0] * orders['delivery']['restaurants'][i][2]);
                                                                        }
                                                                        subTotal;
                                                                        totalAmount =
                                                                            subTotal +
                                                                                deliveryCharge;
                                                                      });
                                                                      print(orders[
                                                                              'delivery']
                                                                          [
                                                                          'restaurants']);
                                                                    },
                                                                    child: Icon(
                                                                        Icons
                                                                            .add_circle),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ],
                                                        );
                                                      }).toList());
                                                }
                                              },
                                            ),
                                          ],
                                        );
                                      }).toList(),
                                    );
                                  }
                                }),
                            SizedBox(
                              height: height * 0.01,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                device == "desktop"
                    ? Container(
                        width: width * 0.14,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              Container(
                                width: width * 0.15,
                                height: height * 0.05,
                                color: Color(0xFFdb9e1f),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      "Your Cart",
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                width: width * 0.15,
                                height: height * 0.2,
                                decoration: BoxDecoration(
                                    border:
                                        Border.all(color: Color(0xFFdb9e1f))),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      Icon(
                                        Icons.shopping_bag,
                                        size: width * 0.07,
                                      ),
                                      Text(
                                        "There are no items in your cart",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      )
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      )
                    : SizedBox()
              ],
            ),
          )
        ],
      ),
    );
  }
}
