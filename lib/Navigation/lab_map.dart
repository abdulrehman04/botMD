import 'dart:async';
import 'dart:ffi';

import 'package:bot_md/Navigation/MapsNavigation.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../constants.dart';
import '../globals_.dart';

class LabMap extends StatelessWidget {
  late DocumentSnapshot currentLab;
  late RxInt currentLabIndex;
  late List allLabs;
  late RxList searchResults;
  var labsKey = GlobalKey<ScaffoldState>();
  bool savedLabs = false;
  SwiperController _swipeController = SwiperController();
  bool firstOpen = true;

  LabMap({Key? key, currentLab, allLabs, currentLabIndex, savedLabs = false})
      : super(key: key) {
    this.allLabs = allLabs;
    this.currentLab = currentLab;
    this.savedLabs = savedLabs;
    this.currentLabIndex = RxInt(currentLabIndex);
    locateCurrentLab();
    getCurrentLocation();
    this.searchResults = RxList(this.allLabs);
  }

  Completer<GoogleMapController> _controller = Completer();
  late GoogleMapController mapController;
  RxSet<Marker> markers = RxSet({});
  TextEditingController inputController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      key: labsKey,
      drawer: SafeArea(
        child: Drawer(
          child: SingleChildScrollView(
            child: Obx(() {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 15,
                  ),
                  ListTile(
                    title: montserratText(
                        text: savedLabs ? "Saved Labs" : "All Labs",
                        color: Colors.black,
                        weight: FontWeight.w500,
                        align: TextAlign.start),
                  ),
                  Container(
                    height: 40,
                    margin: const EdgeInsets.symmetric(horizontal: 7),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      gradient: const LinearGradient(
                        colors: [
                          Color(0xff424242),
                          Color(0xff2f2f2f),
                        ],
                      ),
                    ),
                    child: TextField(
                      controller: inputController,
                      style: GoogleFonts.montserrat(
                        color: Colors.white,
                      ),
                      decoration: InputDecoration(
                        hintText: "Search",
                        hintStyle: GoogleFonts.montserrat(
                          color: Colors.white,
                        ),
                        contentPadding: const EdgeInsets.fromLTRB(22, 0, 12, 0),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(50),
                        ),
                      ),
                      onChanged: (str) {
                        searchResults.value = List.from(allLabs
                            .where((element) => element
                                .get('name')
                                .toUpperCase()
                                .contains(str.toUpperCase()))
                            .toList());
                      },
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  ...searchResults.value.map((e) {
                    return Column(
                      children: [
                        ListTile(
                          title: montserratText(
                            text: e.get('name'),
                            color: Colors.black,
                            weight: FontWeight.w400,
                            size: 14,
                            align: TextAlign.start,
                          ),
                          subtitle: montserratText(
                            text: e.get('formatted_address'),
                            size: 12,
                            color: Colors.grey[700],
                            align: TextAlign.start,
                            weight: FontWeight.w300,
                          ),
                          onTap: () {
                            FocusScope.of(context).unfocus();
                            markers.value = {};
                            Get.back();
                            Marker marker = Marker(
                              markerId: MarkerId("0"),
                              position: LatLng(
                                e.get('geometry')['location']['lat'],
                                e.get('geometry')['location']['lng'],
                              ),
                            );
                            markers.value.add(marker);
                            mapController.animateCamera(
                              CameraUpdate.newCameraPosition(
                                CameraPosition(
                                  target: LatLng(
                                    e.get('geometry')['location']['lat'],
                                    e.get('geometry')['location']['lng'],
                                  ),
                                  zoom: 14,
                                ),
                              ),
                            );
                            _swipeController.move(allLabs.indexOf(e));
                          },
                        ),
                        const Divider()
                      ],
                    );
                  }).toList(),
                ],
              );
            }),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.miniStartTop,
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(top: 10),
        child: FloatingActionButton(
          backgroundColor: primaryColor,
          child: Image.asset("Assets/DrawerIcon.png"),
          onPressed: () {
            labsKey.currentState?.openDrawer();
          },
        ),
      ),
      body: Stack(
        children: [
          Obx(() {
            return GoogleMap(
              myLocationButtonEnabled: true,
              myLocationEnabled: true,
              mapType: MapType.terrain,
              initialCameraPosition: CameraPosition(
                target: LatLng(
                  currentLab.get('geometry')['location']['lat'],
                  currentLab.get('geometry')['location']['lng'],
                ),
                zoom: 14,
              ),
              markers: markers.value,
              onMapCreated: (GoogleMapController controller) async {
                if (firstOpen) {
                  firstOpen = false;
                  _controller.complete(controller);
                }
                mapController = await _controller.future;
              },
            );
          }),
          DraggableScrollableSheet(
            initialChildSize: 0.31,
            minChildSize: 0.31,
            maxChildSize: 0.62,
            builder: (context, cont) {
              return Container(
                padding: const EdgeInsets.only(top: 18, left: 0),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [primaryColor, secondaryColor],
                    begin: Alignment.topLeft,
                  ),
                  boxShadow: [boxShad(5, 5, 25)],
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(25),
                    topRight: Radius.circular(25),
                  ),
                ),
                child: SingleChildScrollView(
                  controller: cont,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          const Icon(
                            Icons.navigate_before,
                            color: Colors.white,
                          ),
                          montserratText(
                            align: TextAlign.start,
                            text: savedLabs
                                ? "Labs you've saved"
                                : "Labs Available in your ${currentUserData['labRadius']} km",
                            size: 18,
                            color: Colors.white,
                            weight: FontWeight.w300,
                          ),
                          const Icon(
                            Icons.navigate_next,
                            color: Colors.white,
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.55,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 18),
                          child: Obx(() {
                            return Swiper(
                              loop: false,
                              controller: _swipeController,
                              itemCount: allLabs.length,
                              autoplay: false,
                              index: currentLabIndex.value,
                              onIndexChanged: (index) async {
                                currentLabIndex.value = index;
                                markers.value = {};
                                Marker marker = Marker(
                                  markerId: MarkerId("0"),
                                  position: LatLng(
                                    allLabs[index].get('geometry')['location']
                                        ['lat'],
                                    allLabs[index].get('geometry')['location']
                                        ['lng'],
                                  ),
                                );
                                markers.value.add(marker);
                                // GoogleMapController controller =
                                //     await _controller.future;
                                mapController.animateCamera(
                                  CameraUpdate.newCameraPosition(
                                    CameraPosition(
                                      target: LatLng(
                                        allLabs[index]
                                            .get('geometry')['location']['lat'],
                                        allLabs[index]
                                            .get('geometry')['location']['lng'],
                                      ),
                                      zoom: 14,
                                    ),
                                  ),
                                );
                              },
                              itemBuilder: (context, index) {
                                return Column(
                                  children: [
                                    SizedBox(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.25,
                                      child: Column(
                                        children: [
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                right: 70),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                montserratText(
                                                  text: allLabs[index]
                                                      .get('name'),
                                                  size: 18,
                                                  weight: FontWeight.w400,
                                                  color: Colors.white,
                                                  align: TextAlign.start,
                                                ),
                                                const SizedBox(
                                                  height: 5,
                                                ),
                                                montserratText(
                                                  text: allLabs[index]
                                                      .get('formatted_address'),
                                                  size: 12,
                                                  weight: FontWeight.w400,
                                                  color: Colors.white70,
                                                  align: TextAlign.start,
                                                ),
                                                const SizedBox(
                                                  height: 10,
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          right: 18),
                                                  child: Row(
                                                    // mainAxisAlignment:
                                                    //     MainAxisAlignment.spaceBetween,
                                                    children: [
                                                      Row(
                                                        children: [
                                                          Icon(
                                                            Icons.star,
                                                            size: 14,
                                                            color: Colors
                                                                .yellow[700],
                                                          ),
                                                          montserratText(
                                                            text: allLabs[index]
                                                                        .get(
                                                                            'rating') ==
                                                                    null
                                                                ? "0.0"
                                                                : " ${allLabs[index].get('rating').toString()}",
                                                            color:
                                                                Colors.white70,
                                                            size: 12,
                                                            weight:
                                                                FontWeight.w400,
                                                          )
                                                        ],
                                                      ),
                                                      montserratText(
                                                        text: allLabs[index].get(
                                                                    'user_ratings_total') ==
                                                                null
                                                            ? "(0)"
                                                            : " (${allLabs[index].get('user_ratings_total').toString()})",
                                                        color: Colors.white70,
                                                        size: 12,
                                                        weight: FontWeight.w400,
                                                      )
                                                    ],
                                                  ),
                                                ),
                                                const SizedBox(
                                                  height: 15,
                                                ),
                                              ],
                                            ),
                                          ),
                                          SingleChildScrollView(
                                            child: Row(
                                              children: [
                                                InkWell(
                                                  onTap: () {
                                                    Get.to(
                                                      () => MapsNavigation(
                                                        LatLng(
                                                          currentLab.get(
                                                                  'geometry')[
                                                              'location']['lat'],
                                                          currentLab.get(
                                                                  'geometry')[
                                                              'location']['lng'],
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                  child: Container(
                                                    padding:
                                                        const EdgeInsets.only(
                                                      right: 15,
                                                      top: 8,
                                                      bottom: 8,
                                                      left: 10,
                                                    ),
                                                    margin:
                                                        const EdgeInsets.only(
                                                            left: 7),
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              18),
                                                      color: Colors.white,
                                                    ),
                                                    child: Row(
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      children: [
                                                        Icon(
                                                          Icons.directions,
                                                          color: primaryColor,
                                                          size: 20,
                                                        ),
                                                        const SizedBox(
                                                          width: 5,
                                                        ),
                                                        montserratText(
                                                          text: "Directions",
                                                          color: primaryColor,
                                                          size: 15,
                                                          weight:
                                                              FontWeight.w400,
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                                Obx(() {
                                                  return InkWell(
                                                    onTap: () {
                                                      if (!currentUserData
                                                          .value['savedLabs']
                                                          .contains(allLabs[
                                                                  currentLabIndex
                                                                      .value]
                                                              .id)) {
                                                        print("Here");
                                                        FirebaseFirestore
                                                            .instance
                                                            .collection('Users')
                                                            .doc(currentUser.id)
                                                            .update({
                                                          'savedLabs':
                                                              FieldValue
                                                                  .arrayUnion([
                                                            allLabs[currentLabIndex
                                                                    .value]
                                                                .id
                                                          ])
                                                        }).then((_) {
                                                          Get.snackbar(
                                                            "All Set!",
                                                            "Added to saved labs",
                                                            colorText:
                                                                Colors.white,
                                                            backgroundColor:
                                                                Colors
                                                                    .lightGreen
                                                                    .withOpacity(
                                                                        0.5),
                                                          );
                                                        });
                                                      } else {
                                                        FirebaseFirestore
                                                            .instance
                                                            .collection('Users')
                                                            .doc(currentUser.id)
                                                            .update({
                                                          'savedLabs':
                                                              FieldValue
                                                                  .arrayRemove([
                                                            allLabs[currentLabIndex
                                                                    .value]
                                                                .id
                                                          ])
                                                        }).then((_) {
                                                          Get.snackbar(
                                                            "All Set!",
                                                            "Removed from saved labs",
                                                            colorText:
                                                                Colors.white,
                                                            backgroundColor:
                                                                Colors
                                                                    .lightGreen
                                                                    .withOpacity(
                                                                        0.5),
                                                          );
                                                        });
                                                      }
                                                    },
                                                    child: Container(
                                                      padding:
                                                          const EdgeInsets.only(
                                                        right: 15,
                                                        top: 8,
                                                        bottom: 8,
                                                        left: 10,
                                                      ),
                                                      margin:
                                                          const EdgeInsets.only(
                                                        left: 7,
                                                      ),
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(18),
                                                        border: Border.all(
                                                          color: Colors.white70,
                                                        ),
                                                      ),
                                                      child: Row(
                                                        mainAxisSize:
                                                            MainAxisSize.min,
                                                        children: [
                                                          Icon(
                                                            currentUserData
                                                                    .value[
                                                                        'savedLabs']
                                                                    .contains(
                                                                        allLabs[currentLabIndex.value]
                                                                            .id)
                                                                ? Icons.check
                                                                : Icons.flag,
                                                            color: Colors.white,
                                                            size: 20,
                                                          ),
                                                          const SizedBox(
                                                            width: 5,
                                                          ),
                                                          montserratText(
                                                            text: "Save",
                                                            color: Colors.white,
                                                            size: 15,
                                                            weight:
                                                                FontWeight.w400,
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                  );
                                                }),
                                                Container(
                                                  padding:
                                                      const EdgeInsets.only(
                                                    right: 15,
                                                    top: 8,
                                                    bottom: 8,
                                                    left: 10,
                                                  ),
                                                  margin: const EdgeInsets.only(
                                                    left: 7,
                                                  ),
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            18),
                                                    border: Border.all(
                                                      color: Colors.white70,
                                                    ),
                                                  ),
                                                  child: Row(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    children: [
                                                      const Icon(
                                                        Icons.share,
                                                        color: Colors.white,
                                                        size: 20,
                                                      ),
                                                      const SizedBox(
                                                        width: 5,
                                                      ),
                                                      montserratText(
                                                        text: "Share",
                                                        color: Colors.white,
                                                        size: 15,
                                                        weight: FontWeight.w400,
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Expanded(
                                            child: Container(),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      margin: EdgeInsets.only(right: 18),
                                      height: 200,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(18),
                                        image:
                                            allLabs[index].get('photo') != null
                                                ? DecorationImage(
                                                    image: MemoryImage(
                                                      allLabs[index]
                                                          .get('photo')
                                                          .bytes,
                                                    ),
                                                    fit: BoxFit.cover,
                                                  )
                                                : const DecorationImage(
                                                    image: AssetImage(
                                                      'Assets/userAvatar.png',
                                                    ),
                                                  ),
                                      ),
                                    )
                                  ],
                                );
                              },
                            );
                          }),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
            snap: true,
          ),
        ],
      ),
    );
  }

  locateCurrentLab() {
    Marker marker = Marker(
      markerId: MarkerId("0"),
      position: LatLng(
        currentLab.get('geometry')['location']['lat'],
        currentLab.get('geometry')['location']['lng'],
      ),
    );
    markers.value.add(marker);
  }
}
