import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';

import '../Navigation/lab_map.dart';
import '../constants.dart';
import '../globals_.dart';

class SavedLabs extends StatelessWidget {
  SavedLabs() {
    getSavedLabsDetails();
  }

  RxList savedLabs = RxList([]);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              gradientAppBar(context: context, title: "Saved Labs"),
              const SizedBox(
                height: 25,
              ),
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 20),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: montserratText(
                        align: TextAlign.start,
                        text: "Labs you've saved",
                        size: 17,
                        color: Colors.grey[600],
                        weight: FontWeight.w400,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  Obx(() {
                    return savedLabs.value.length == 0
                        ? SizedBox(
                            height: 300,
                            child: Column(
                              children: [
                                Expanded(
                                  child: Container(
                                    width: MediaQuery.of(context).size.width,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(18),
                                      color: Colors.white,
                                      boxShadow: [
                                        boxShad(5, 7, 10, opacity: 0.15),
                                      ],
                                    ),
                                    padding: const EdgeInsets.only(
                                      right: 10,
                                      left: 10,
                                      bottom: 10,
                                    ),
                                    child: Image.asset(
                                      'Assets/404.gif',
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 15,
                                ),
                                montserratText(
                                  text: "No labs saved",
                                  color: Colors.grey[700],
                                  weight: FontWeight.w300,
                                  size: 14,
                                )
                              ],
                            ),
                          )
                        : Column(
                            children: [
                              ...savedLabs.value.length <= 8
                                  ? savedLabs.value.map((e) {
                                      return InkWell(
                                          onTap: () {
                                            Get.to(
                                              () => LabMap(
                                                savedLabs: true,
                                                key: Key(e.toString()),
                                                currentLab: e,
                                                currentLabIndex:
                                                    savedLabs.indexOf(e),
                                                allLabs: <DocumentSnapshot>[
                                                  ...savedLabs.value
                                                ],
                                              ),
                                            );
                                          },
                                          child: LabWidget(e, context));
                                    }).toList()
                                  : savedLabs.value.sublist(0, 8).map((e) {
                                      return InkWell(
                                          onTap: () {
                                            Get.to(
                                              () => LabMap(
                                                savedLabs: true,
                                                key: Key(e.toString()),
                                                currentLab: e,
                                                currentLabIndex:
                                                    savedLabs.indexOf(e),
                                                allLabs: <DocumentSnapshot>[
                                                  ...savedLabs.value
                                                ],
                                              ),
                                            );
                                          },
                                          child: LabWidget(e, context));
                                    }).toList(),
                            ],
                          );
                  }),
                  gradientLongButton(
                      text: "View All Labs",
                      onTap: () {
                        Get.to(
                          () => LabMap(
                            savedLabs: true,
                            currentLab: labs.value[0],
                            currentLabIndex: 0,
                            allLabs: <DocumentSnapshot>[...labs.value],
                          ),
                        );
                      }),
                  const SizedBox(
                    height: 35,
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  getSavedLabsDetails() {
    currentUserData.value['savedLabs'].forEach((e) {
      FirebaseFirestore.instance.collection("Labs").doc(e).get().then((value) {
        savedLabs.value = [...savedLabs.value, value];
      });
    });
  }
}
