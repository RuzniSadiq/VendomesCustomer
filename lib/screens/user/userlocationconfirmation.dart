import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:worldsgate/screens/user/userhomepage.dart';
import 'package:uuid/uuid.dart';
import 'package:http/http.dart' as http;

class LocationConfirmation extends StatefulWidget {
  //const LocationConfirmation({Key? key}) : super(key: key);
  String userUID;

  LocationConfirmation(this.userUID);

  @override
  _LocationConfirmationState createState() => _LocationConfirmationState();
}

class _LocationConfirmationState extends State<LocationConfirmation> {
  final auth = FirebaseAuth.instance.currentUser;
  User? user;

  final _formkey = GlobalKey<FormState>();
  var _addressController = TextEditingController();

  var uuid = new Uuid();
  String? _sessionToken;
  List<dynamic> _placeList = [];

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

  bool _isLocationSelected = false;

  _onChanged() {
    if (_sessionToken == null) {
      setState(() {
        _sessionToken = uuid.v4();
      });
    }
    getSuggestion(_addressController.text);
  }

  void getSuggestion(String input) async {
    String kPLACES_API_KEY = "AIzaSyAeHBTXB2FAQyamm02kA9KHtDcKvCHaljU";
    String type = '(regions)';
    String baseURL =
        'https://maps.googleapis.com/maps/api/place/autocomplete/json';
    String request =
        '$baseURL?input=$input&key=$kPLACES_API_KEY&sessiontoken=$_sessionToken';
    var response = await http.get(Uri.parse(request));
    if (response.statusCode == 200) {
      setState(() {
        _placeList = json.decode(response.body)['predictions'];
      });
    } else {
      throw Exception('Failed to load predictions');
    }
  }

  @override
  void initState() {
    user = auth;
    _addressController.addListener(() {
      _onChanged();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Color(0xFF000000),
        body: /*Container(
            child: Stack(
              fit: StackFit.expand,
              children: [
                GoogleMap(
                  mapType: MapType.normal,
                  initialCameraPosition: CameraPosition(
                      target: LatLng(25.08559163749154, 55.14159403093483),
                      zoom: 14.47),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: TextField(
                        controller: _addressController,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.black,
                          hintText: "Enter Your Address",
                          hintStyle: TextStyle(color: Colors.white),
                          enabled: true,
                          focusColor: Colors.white,
                          contentPadding: const EdgeInsets.only(
                              left: 14.0, bottom: 8.0, top: 15.0),
                          focusedBorder: OutlineInputBorder(
                            borderSide: new BorderSide(color: Colors.white),
                            borderRadius: new BorderRadius.circular(10),
                          ),
                          border: OutlineInputBorder(
                            borderSide: new BorderSide(color: Colors.white),
                            borderRadius: new BorderRadius.circular(10),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: new BorderSide(color: Colors.white),
                            borderRadius: new BorderRadius.circular(10),
                          ),
                          floatingLabelBehavior: FloatingLabelBehavior.never,
                          //prefixIcon: Icon(Icons.map),
                          suffixIcon: IconButton(
                            icon: Icon(
                              Icons.cancel,
                              color: Colors.grey,
                            ),
                            onPressed: () {
                              _addressController..text = "";
                            },
                          ),
                        ),
                        keyboardType: TextInputType.streetAddress,
                      ),
                    ),
                    Flexible(
                      child: ListView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: _placeList.length,
                        itemBuilder: (context, index) {
                          return InkWell(
                            onTap: () async {
                              /*List<Location> locations =
                                  await locationFromAddress(
                                      _placeList[index]["description"]);
                              _addressController.text =
                                  _placeList[index]["description"];
                              getTotalCost(locations.first.latitude,
                                  locations.first.longitude);
                              customerPickUpLat = locations.first.latitude;
                              customerPickUpLan = locations.first.longitude;
                              pickUpAddress = _placeList[index]["description"];
                              print("The total cost of the package: ");
                              print(totalCost);
                              _goToNewAddress(locations.first.latitude,
                                  locations.first.longitude);
                              print("Latitude is: ${locations.first.latitude}");
                              print(
                                  "Longitude is: ${locations.first.longitude}");*/
                            },
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(
                                  12.0, 0.0, 12.0, 0.0),
                              child: Container(
                                decoration: BoxDecoration(color: Colors.white),
                                child: ListTile(
                                  title: Text(_placeList[index]["description"]),
                                  textColor: Colors.black,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    Expanded(child: Container()),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 16.0),
                      child: Container(
                        width: 300.0,
                        height: 50.0,
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
                            //uploadMainFunction(_selectedFile);
                            //uploadFile();
                            /*_uploadHotelData();
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) =>
                                    DeoManageHotels(widget.uid)));*/
                          },
                          child: const Text(
                            'Confirm',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          )*/
            Center(
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "CONFIRM LOCATION",
                  style: TextStyle(color: Color(0xFFdb9e1f), fontSize: 20),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 40.0),
                  child: Form(
                      key: _formkey,
                      child: DropdownButtonFormField(
                          decoration: InputDecoration(
                            hintText: "Select place in UAE",
                            hintStyle: TextStyle(color: Colors.white70),
                            //labelText: 'City',
                            labelStyle:
                                TextStyle(color: Colors.white70, height: 0.1),
                            enabled: true,
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              borderSide: BorderSide(color: Color(0xFFdb9e1f)),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              borderSide: BorderSide(color: Color(0xFFdb9e1f)),
                            ),
                          ),
                          dropdownColor: Color(0xFF000000),
                          //focusColor: Color(0xFFdb9e1f),
                          style: TextStyle(color: Colors.white),
                          isExpanded: true,
                          value: city,
                          items: places.map(buildMenuItem).toList(),
                          onChanged: (value) => setState(() {
                                this.city = value as String?;
                                setState(() {
                                  _isLocationSelected = true;
                                });
                              }))),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      fixedSize: Size(MediaQuery.of(context).size.width / 2,
                          MediaQuery.of(context).size.height / 15),
                      primary: Color(0xFF000000),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(20.0)),
                          side: BorderSide(
                              color: _isLocationSelected
                                  ? Color(0xFFdb9e1f)
                                  : Colors.grey)),
                      side: BorderSide(
                        width: 2.5,
                        color: _isLocationSelected
                            ? Color(0xFFdb9e1f)
                            : Colors.grey,
                      ),
                      textStyle: const TextStyle(fontSize: 18)),
                  onPressed: () {
                    _isLocationSelected
                        ? Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) =>
                                UserHomePage(widget.userUID, city!)))
                        : null;
                  },
                  child: const Text(
                    'Confirm',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
