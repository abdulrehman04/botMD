import 'dart:convert';

import 'package:bot_md/Chat/botchat.dart';
import 'package:bot_md/globals_.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:async';
import 'package:http/http.dart' as http;

import '../constants.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  LatLng currentLocation = const LatLng(33.6844, 73.0479);
  Completer<GoogleMapController> _controller = Completer();
  late GoogleMapController mapController;
  var scaffoldKey = GlobalKey<ScaffoldState>();
  LatLng countryLocation = LatLng(0, 0);

  RxMap countryStats = RxMap({
    'confirmed': 0,
    'deaths': 0,
    'recovered': 0,
    'active': 0,
    'fatality_rate': 0.0,
  });

  RxMap countryresults = RxMap({});
  var covidStats = RxBool(false);
  var selectedView = RxString("world");
  var selectedCountry = RxString('');
  Set<Circle> circles = Set();

  String query = '';
  @override
  void initState() {
    // getLocation();
  }

  // getLocation() async {
  //   PermissionStatus status = await Permission.location.status;
  //   if (status.isDenied) {
  //     var permissionGranted = await requestLocationPermission();
  //     if (permissionGranted) {
  //       getCurrentLocation();
  //     } else {
  //       openAppSettings();
  //     }
  //   } else {
  //     getCurrentLocation();
  //   }
  // }
  //
  // Future<void> getCurrentLocation() async {
  //   await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
  //       .then((value) {
  //     setState(() {
  //       currentLocation = LatLng(value.latitude, value.longitude);
  //     });
  //   });
  // }

  List hopkinsAttributes = [
    {
      'name': 'Active',
      'statName': 'active',
      'icon': Icons.loop,
      'iconColor': Colors.white,
      'backgroundColor': Color(0xffdc3545),
    },
    {
      'name': 'Confirmed',
      'statName': 'confirmed',
      'icon': Icons.add,
      'iconColor': Colors.black,
      'backgroundColor': const Color(0xffffc107),
    },
    {
      'name': 'Recovered',
      'statName': 'recovered',
      'icon': Icons.check,
      'iconColor': Colors.white,
      'backgroundColor': const Color(0xff28a745),
    },
    {
      'name': 'Deaths',
      'statName': 'deaths',
      'icon': Icons.clear,
      'iconColor': Colors.white,
      'backgroundColor': Color(0xff6c757d),
    },
  ];

  List worldAttributes = [
    'Total Cases',
    'New Cases',
    'Total Recovered',
    'New Recovered',
    'Active Cases',
    "Critical",
    'Deaths',
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        key: scaffoldKey,
        // drawer: Drawer(
        //   child: ListView(
        //     padding: EdgeInsets.zero,
        //     children: [
        //       const DrawerHeader(
        //         decoration: BoxDecoration(
        //           color: Colors.blue,
        //         ),
        //         child: Text('Drawer Header'),
        //       ),
        //       ListTile(
        //         title: const Text('Item 1'),
        //         onTap: () {},
        //       ),
        //       ListTile(
        //         title: const Text('Item 2'),
        //         onTap: () {},
        //       ),
        //     ],
        //   ),
        // ),
        body: Stack(
          children: [
            GoogleMap(
              myLocationButtonEnabled: true,
              myLocationEnabled: true,
              mapType: MapType.terrain,
              initialCameraPosition: CameraPosition(
                target: currentLocation,
                zoom: 14,
              ),
              circles: circles,
              onMapCreated: (GoogleMapController controller) async {
                _controller.complete(controller);
                mapController = await _controller.future;
              },
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Obx(() {
                return AnimatedContainer(
                  duration: const Duration(
                    milliseconds: 350,
                  ),
                  color: Colors.white,
                  width: MediaQuery.of(context).size.width,
                  height: covidStats.value
                      ? 0
                      : MediaQuery.of(context).size.height * 0.53,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(15, 15, 15, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        montserratText(
                            text: "Main Overview",
                            color: secondaryColor,
                            size: 11,
                            weight: FontWeight.w300),
                        Container(
                          height: 150,
                          child: Swiper(
                            loop: false,
                            itemCount: 2,
                            autoplay: true,
                            onIndexChanged: (index) {
                              // currentIndex.value = index;
                            },
                            itemBuilder: (context, index) {
                              return InkWell(
                                onTap: () {
                                  Get.to(() => BotChat());
                                },
                                child: mainItems[index],
                              );
                            },
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            showVaccinationForm();
                          },
                          child: montserratText(
                              text: "Let's explore more options",
                              color: secondaryColor,
                              size: 11,
                              weight: FontWeight.w300),
                        ),
                        Column(
                          children: [
                            Container(
                              padding: EdgeInsets.symmetric(vertical: 5),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Colors.white,
                                  boxShadow: [boxShad(5, 5, 5)]),
                              child: ListTile(
                                onTap: () {
                                  currentIndex.value = 1;
                                },
                                leading:
                                    Image.asset('Assets/diet-schedule.png'),
                                trailing: Container(
                                  width: 50,
                                  height: 20,
                                  decoration: BoxDecoration(
                                    color: secondaryColor,
                                    borderRadius: BorderRadius.circular(35),
                                    border: Border.all(
                                      color: Colors.white,
                                      width: 0.6,
                                    ),
                                  ),
                                  child: Center(
                                    child: montserratText(
                                      text: "View",
                                      color: Colors.white,
                                      size: 9,
                                      weight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                                title: montserratText(
                                    text: "Diet and Remedies",
                                    color: secondaryColor,
                                    size: 17),
                              ),
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(vertical: 5),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Colors.white,
                                  boxShadow: [boxShad(5, 5, 5)]),
                              child: ListTile(
                                onTap: () {
                                  currentIndex.value = 2;
                                },
                                leading:
                                    Image.asset('Assets/navigation_img.png'),
                                trailing: Container(
                                  width: 50,
                                  height: 20,
                                  decoration: BoxDecoration(
                                    color: secondaryColor,
                                    borderRadius: BorderRadius.circular(35),
                                    border: Border.all(
                                      color: Colors.white,
                                      width: 0.6,
                                    ),
                                  ),
                                  child: Center(
                                    child: montserratText(
                                      text: "View",
                                      color: Colors.white,
                                      size: 9,
                                      weight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                                title: montserratText(
                                    text: "View Nearest Labs",
                                    color: secondaryColor,
                                    size: 17),
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              }),
            ),
            Align(
              alignment: Alignment.topCenter,
              child: Obx(() {
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 350),
                  height: covidStats.value == false
                      ? MediaQuery.of(context).size.height * 0.4
                      : MediaQuery.of(context).size.height * 0.25,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [primaryColor, secondaryColor],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    boxShadow: [
                      boxShad(-20, 15, 20),
                    ],
                    borderRadius: const BorderRadius.only(
                      bottomRight: Radius.circular(35),
                      bottomLeft: Radius.circular(35),
                    ),
                  ),
                  padding: covidStats.value
                      ? const EdgeInsets.only(
                          left: 45,
                          right: 10,
                        )
                      : const EdgeInsets.symmetric(
                          horizontal: 60,
                        ),
                  child: covidStats.value
                      ? Padding(
                          padding: const EdgeInsets.only(top: 45),
                          child: Align(
                            alignment: Alignment.topCenter,
                            child: Swiper(
                              loop: true,
                              autoplay: true,
                              itemCount: usingHopkins ? 4 : 7,
                              itemBuilder: (context, index) {
                                return Container(
                                  margin: const EdgeInsets.only(
                                      bottom: 78, right: 15, left: 18),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: ListTile(
                                    tileColor: Colors.white,
                                    title: montserratText(
                                      text: usingHopkins
                                          ? hopkinsAttributes[index]['name']
                                          : worldAttributes[index],
                                      size: 20,
                                      align: TextAlign.start,
                                      color: secondaryColor,
                                    ),
                                    trailing: Container(
                                        height: 50,
                                        width: 50,
                                        margin:
                                            const EdgeInsets.only(bottom: 5),
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: hopkinsAttributes[index]
                                              ['backgroundColor'],
                                        ),
                                        child: Center(
                                          child: Icon(
                                              hopkinsAttributes[index]['icon'],
                                              color: hopkinsAttributes[index]
                                                  ['iconColor'],
                                              size: 30),
                                        )),
                                    subtitle: montserratText(
                                      text: selectedView == 'world'
                                          ? '${worldStats.value[hopkinsAttributes[index]['statName']]}'
                                          : '${countryStats.value[hopkinsAttributes[index]['statName']]}',
                                      size: 13,
                                      align: TextAlign.start,
                                      weight: FontWeight.w400,
                                      color: primaryColor,
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        )
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            montserratText(
                              text: "Good Evening\n${currentUserData['name']}",
                              color: Colors.white,
                              size: 25,
                              align: TextAlign.left,
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            montserratText(
                              text: "Welcome to BotMD",
                              color: Colors.white,
                              size: 13,
                              weight: FontWeight.w400,
                              align: TextAlign.left,
                            ),
                            const SizedBox(
                              height: 18,
                            ),
                            Row(
                              children: [
                                InkWell(
                                  onTap: () async {
                                    covidStats.value = true;
                                    GoogleMapController controller =
                                        await _controller.future;
                                    controller.animateCamera(
                                      CameraUpdate.newCameraPosition(
                                        CameraPosition(
                                          target: currentLocation,
                                          zoom: 0,
                                        ),
                                      ),
                                    );
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: secondaryColor,
                                      borderRadius: BorderRadius.circular(35),
                                      border: Border.all(
                                        color: Colors.white,
                                        width: 0.6,
                                      ),
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 15,
                                      vertical: 5,
                                    ),
                                    child: Center(
                                      child: montserratText(
                                        text: "Covid Stats",
                                        color: Colors.white,
                                        size: 13,
                                        weight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  width: 5,
                                ),
                                InkWell(
                                  onTap: () {
                                    currentIndex.value = 2;
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: secondaryColor,
                                      borderRadius: BorderRadius.circular(35),
                                      border: Border.all(
                                        color: Colors.white,
                                        width: 0.6,
                                      ),
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 15,
                                      vertical: 5,
                                    ),
                                    child: montserratText(
                                      text: "View Your Profile",
                                      color: Colors.white,
                                      size: 13,
                                      weight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            InkWell(
                              onTap: () {
                                Get.to(() => const BotChat());
                              },
                              child: Container(
                                width: 130,
                                decoration: BoxDecoration(
                                  color: secondaryColor,
                                  borderRadius: BorderRadius.circular(35),
                                  border: Border.all(
                                    color: Colors.white,
                                    width: 0.6,
                                  ),
                                ),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 15,
                                  vertical: 5,
                                ),
                                child: Center(
                                  child: montserratText(
                                    text: "Hey MD!",
                                    color: Colors.white,
                                    size: 13,
                                    weight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                );
              }),
            ),
            Obx(() {
              return covidStats.value
                  ? Positioned(
                      top: 130,
                      right: 15,
                      left: 15,
                      child: InkWell(
                        onTap: () {
                          showModalBottomSheet(
                              context: context,
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(15),
                                  topRight: Radius.circular(15),
                                ),
                              ),
                              builder: (context) {
                                return SizedBox(
                                  height: 250,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      children: [
                                        InkWell(
                                          onTap: () {
                                            selectedView.value = 'world';
                                            animateCamera(
                                              currentLocation.latitude,
                                              currentLocation.longitude,
                                              1.0,
                                            );
                                            Get.back();
                                          },
                                          child: Container(
                                            decoration: BoxDecoration(
                                              color: primaryColor.withOpacity(
                                                  selectedView.value == 'world'
                                                      ? 0.3
                                                      : 0.1),
                                              borderRadius:
                                                  BorderRadius.circular(15),
                                              // boxShadow: [boxShad(5, 5, 5)],
                                            ),
                                            child: ListTile(
                                              title: montserratText(
                                                text: "World Stats",
                                                color: selectedView.value ==
                                                        'world'
                                                    ? primaryColor
                                                    : Colors.black,
                                                align: TextAlign.start,
                                                weight: FontWeight.w600,
                                                size: 16,
                                              ),
                                              subtitle: montserratText(
                                                text:
                                                    "View Covid stats all around the globe",
                                                color: selectedView.value ==
                                                        'world'
                                                    ? secondaryColor
                                                    : Colors.grey,
                                                align: TextAlign.start,
                                                weight: FontWeight.w400,
                                                size: 13,
                                              ),
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 7,
                                        ),
                                        InkWell(
                                          onTap: () {
                                            selectedView.value = 'country';
                                            Get.back();
                                            countryPicker();
                                          },
                                          child: Container(
                                            decoration: BoxDecoration(
                                              color: primaryColor.withOpacity(
                                                  selectedView.value ==
                                                          'country'
                                                      ? 0.3
                                                      : 0.1),
                                              borderRadius:
                                                  BorderRadius.circular(15),
                                              // boxShadow: [boxShad(5, 5, 5)],
                                            ),
                                            child: ListTile(
                                              title: montserratText(
                                                text: "Country wide Stats",
                                                color: selectedView.value ==
                                                        'country'
                                                    ? primaryColor
                                                    : Colors.black,
                                                align: TextAlign.start,
                                                weight: FontWeight.w600,
                                                size: 16,
                                              ),
                                              subtitle: montserratText(
                                                text:
                                                    "View Covid stats of a specific country",
                                                color: selectedView.value ==
                                                        'country'
                                                    ? secondaryColor
                                                    : Colors.grey,
                                                align: TextAlign.start,
                                                weight: FontWeight.w400,
                                                size: 13,
                                              ),
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 7,
                                        ),
                                        InkWell(
                                          onTap: () {
                                            selectedView.value = 'state';
                                            Get.back();
                                            countryPicker(pickCities: true);
                                          },
                                          child: Container(
                                            decoration: BoxDecoration(
                                              color: primaryColor.withOpacity(
                                                  selectedView.value == 'state'
                                                      ? 0.3
                                                      : 0.1),
                                              borderRadius:
                                                  BorderRadius.circular(15),
                                              // boxShadow: [boxShad(5, 5, 5)],
                                            ),
                                            child: ListTile(
                                              title: montserratText(
                                                text: "State wide Stats",
                                                color: selectedView.value ==
                                                        'state'
                                                    ? primaryColor
                                                    : Colors.black,
                                                align: TextAlign.start,
                                                weight: FontWeight.w600,
                                                size: 16,
                                              ),
                                              subtitle: montserratText(
                                                text:
                                                    "View Covid stats from different states of a country",
                                                color: selectedView.value ==
                                                        'state'
                                                    ? secondaryColor
                                                    : Colors.grey,
                                                align: TextAlign.start,
                                                weight: FontWeight.w400,
                                                size: 13,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              });
                          // scaffoldKey.currentState!
                          //     .showBottomSheet((context) {
                          //   return Container(
                          //     height: 250,
                          //     decoration: BoxDecoration(
                          //       borderRadius: BorderRadius.circular(25),
                          //     ),
                          //   );
                          // });
                        },
                        child: Container(
                          height: 40,
                          width: MediaQuery.of(context).size.width,
                          padding: EdgeInsets.only(left: 15),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Colors.white.withOpacity(0.6),
                          ),
                          child: TextField(
                            enabled: false,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              icon: const Icon(Icons.menu),
                              hintText: "Filters",
                              hintStyle: GoogleFonts.montserrat(),
                            ),
                          ),
                        ),
                      ),
                    )
                  : Container();
            }),
            Positioned(
              top: 45,
              left: 20,
              child: Obx(() {
                return InkWell(
                  onTap: () async {
                    if (covidStats.value) {
                      covidStats.value = false;
                      GoogleMapController controller = await _controller.future;
                      controller.animateCamera(
                        CameraUpdate.newCameraPosition(
                          CameraPosition(
                            target: currentLocation,
                            zoom: 10,
                          ),
                        ),
                      );
                    } else {
                      // scaffoldKey.currentState?.openDrawer();
                    }
                  },
                  child: covidStats.value
                      ? const Icon(
                          Icons.close,
                          color: Colors.white,
                        )
                      : Image.asset("Assets/DrawerIcon.png"),
                );
              }),
            ),
            Obx(() {
              return Positioned(
                top: 45,
                right: 20,
                child: covidStats.value
                    ? Container()
                    : InkWell(
                        onTap: () {},
                        child: (currentUserData['image'] == null)
                            ? const CircleAvatar(
                                radius: 25,
                                backgroundColor: Colors.white,
                                backgroundImage: NetworkImage(
                                    'https://www.prajwaldesai.com/wp-content/uploads/2021/02/Find-Users-Last-Logon-Time-using-4-Easy-Methods.jpg'),
                              )
                            : CircleAvatar(
                                radius: 25,
                                backgroundImage:
                                    NetworkImage(currentUserData['image']),
                              ),
                      ),
              );
            }),
          ],
        ),
      ),
    );
  }

  List mainItems = [
    Container(
      width: 300,
      margin: EdgeInsets.fromLTRB(10, 5, 10, 15),
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [boxShad(5, 10, 15)]),
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              flex: 3,
              child: Image.asset('Assets/Symptom.png'),
            ),
            Expanded(
              flex: 3,
              child: montserratText(
                  text: 'Track COVID\nSymptoms',
                  color: secondaryColor,
                  size: 15),
            )
          ],
        ),
      ),
    ),
    Container(
      width: 300,
      padding: EdgeInsets.all(10),
      margin: EdgeInsets.fromLTRB(10, 5, 10, 15),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [boxShad(5, 10, 15)]),
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              flex: 3,
              child: Image.asset('Assets/Symptom.png'),
            ),
            Expanded(
              flex: 3,
              child: montserratText(
                  text: 'Track COVID\nSymptoms',
                  color: secondaryColor,
                  size: 15),
            )
          ],
        ),
      ),
    ),
  ];

  Future<void> onCountrySelected(country, showCities) async {
    countryStats.value = {
      'confirmed': 0,
      'deaths': 0,
      'recovered': 0,
      'active': 0,
      'fatality_rate': 0.0,
    };
    var headers = {
      'x-rapidapi-host': 'covid-19-statistics.p.rapidapi.com',
      'x-rapidapi-key': '32a65a8edamsh5c74cac186577f2p13515cjsn65552860b4d1'
    };
    var request = http.Request(
      'GET',
      Uri.parse(
        "https://covid-19-statistics.p.rapidapi.com/reports?region_name=${selectedCountry.value}",
      ),
    );

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      String result = await response.stream.bytesToString();
      if (showCities) {
        showCityPicker(result);
      } else {
        print(jsonDecode(result));
        print("country is: ${selectedCountry.value}");
        List<Location> locations =
            await locationFromAddress(selectedCountry.value);
        countryLocation = LatLng(locations[0].latitude, locations[0].longitude);
        query = "";
        List items = jsonDecode(result)['data'];
        for (var i in items) {
          print("lololo");
          print(i['confirmed'].runtimeType);
          countryStats.value['confirmed'] =
              countryStats.value['confirmed'] + i['confirmed'];
          countryStats.value['deaths'] =
              countryStats.value['deaths'] + i['deaths'];
          countryStats.value['recovered'] =
              countryStats.value['recovered'] + i['recovered'];
          countryStats.value['active'] =
              countryStats.value['active'] + i['active'];
          countryStats.value['fatality_rate'] =
              countryStats.value['fatality_rate'] + i['fatality_rate'];
        }
        countryStats.value['fatality_rate'] =
            countryStats.value['fatality_rate'] / items.length.toDouble();
        Color color = Colors.white;
        if (countryStats.value['fatality_rate'] < 0.5) {
          color = Colors.lightGreen.withOpacity(0.3);
        } else if (countryStats.value['fatality_rate'] < 1) {
          color = Colors.yellow.withOpacity(0.3);
        } else {
          color = Colors.redAccent.withOpacity(0.3);
        }
        setState(() {
          circles.add(
            Circle(
              circleId: CircleId("1"),
              center: countryLocation,
              fillColor: color,
              strokeWidth: 1,
              radius: 800000,
            ),
          );
        });
        GoogleMapController controller = await _controller.future;
        controller.animateCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(
              target: LatLng(locations[0].latitude, locations[0].longitude),
              zoom: 5,
            ),
          ),
        );
      }
    } else {
      print(response.reasonPhrase);
    }
  }

  getCountryStats(LatLng countryLoc) async {}

  animateCamera(double lat, double lng, double zoom) async {
    GoogleMapController controller = await _controller.future;
    controller.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: LatLng(lat, lng),
          zoom: zoom,
        ),
      ),
    );
  }

  void countryPicker({pickCities = false}) {
    showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(
            builder: (context, sst) {
              return AlertDialog(
                title: montserratText(
                    text: "Select Country", size: 18, color: secondaryColor),
                scrollable: true,
                content: Column(
                  children: [
                    Container(
                      height: 40,
                      width: MediaQuery.of(context).size.width,
                      padding: const EdgeInsets.only(left: 15),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.black.withOpacity(0.1),
                      ),
                      child: TextField(
                        onChanged: (str) {
                          sst(() {
                            query = str;
                          });
                        },
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          icon: const Icon(Icons.search),
                          hintText: "Search",
                          hintStyle: GoogleFonts.montserrat(),
                        ),
                      ),
                    ),
                    Container(
                      height: 500,
                      width: 500,
                      child: ListView(
                        children: worldCountries_hopkins
                            .where((element) => element['name']
                                .toUpperCase()
                                .startsWith(query.toUpperCase()))
                            .toList()
                            .map((e) {
                          return ListTile(
                            onTap: () {
                              selectedCountry.value = e['name'];
                              Get.back();
                              onCountrySelected(
                                  selectedCountry.value, pickCities);
                            },
                            title: montserratText(
                                text: e['name'],
                                weight: FontWeight.w400,
                                size: 15,
                                align: TextAlign.start),
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        });
  }

  showCityPicker(String result) {
    List data = List.from(jsonDecode(result)['data']);
    print(data);
    query = "";
    return showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(
            builder: (context, sst) {
              return AlertDialog(
                title: montserratText(
                    text: "Select Province", size: 18, color: secondaryColor),
                scrollable: true,
                content: Column(
                  children: [
                    Container(
                      height: 40,
                      width: MediaQuery.of(context).size.width,
                      padding: const EdgeInsets.only(left: 15),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.black.withOpacity(0.1),
                      ),
                      child: TextField(
                        onChanged: (str) {
                          sst(() {
                            query = str;
                          });
                        },
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          icon: const Icon(Icons.search),
                          hintText: "Search",
                          hintStyle: GoogleFonts.montserrat(),
                        ),
                      ),
                    ),
                    Container(
                      height: 500,
                      width: 500,
                      child: ListView(
                        children: data
                            .where((element) => element['region']['province']
                                .toUpperCase()
                                .startsWith(query.toUpperCase()))
                            .toList()
                            .map((e) {
                          return ListTile(
                            onTap: () {
                              Get.back();
                              countryStats.value = {
                                'confirmed': e['confirmed'],
                                'deaths': e['deaths'],
                                'recovered': e['recovered'],
                                'active': e['active'],
                                'fatality_rate': e['fatality_rate'],
                              };

                              Color color = Colors.white;
                              if (countryStats.value['fatality_rate'] < 0.5) {
                                color = Colors.lightGreen.withOpacity(0.3);
                              } else if (countryStats.value['fatality_rate'] <
                                  1) {
                                color = Colors.yellow.withOpacity(0.3);
                              } else {
                                color = Colors.redAccent.withOpacity(0.3);
                              }
                              setState(() {
                                print("OOOOPDS");
                                circles.add(
                                  Circle(
                                    circleId: CircleId("1"),
                                    center: LatLng(
                                        double.parse(e['region']['lat']),
                                        double.parse(e['region']['long'])),
                                    fillColor: color,
                                    strokeWidth: 1,
                                    radius: 250000,
                                  ),
                                );
                              });

                              animateCamera(
                                double.parse(e['region']['lat']),
                                double.parse(e['region']['long']),
                                7,
                              );
                            },
                            title: montserratText(
                                text: e['region']['province'],
                                weight: FontWeight.w400,
                                size: 15,
                                align: TextAlign.start),
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        });
  }
}

getKey(String e) {
  switch (e) {
    case "Total Cases":
      return 'TotalCases';
    case "New Cases":
      return 'TotalCases';
    case "New Recovered":
      return 'NewRecovered';
    case "Total Recovered":
      return 'TotalRecovered';
    case "Active Cases":
      return 'ActiveCases';
    case "Critical":
      return 'Serious_Critical';
    case "Deaths":
      return 'TotalDeaths';
  }
}

getHopkinsKey(String e) {
  switch (e) {
    case "Confirmed":
      return 'confirmed';
    case "Recovered":
      return 'recovered';
    case "Active":
      return 'active';
    case "Deaths":
      return 'deaths';
  }
}
