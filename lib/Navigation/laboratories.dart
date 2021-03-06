import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';

import '../constants.dart';
import '../globals_.dart';
import 'lab_map.dart';

class Laboratories extends StatelessWidget {
  const Laboratories({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              gradientAppBar(context: context, title: "Labs Nearby"),
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
                        text:
                            "Labs Available in your ${currentUserData['labRadius']} km",
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
                    return labs.value.length == 0
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
                                SizedBox(
                                  height: 15,
                                ),
                                montserratText(
                                  text:
                                      "Please wait while we collect some data for your location",
                                  color: Colors.grey[700],
                                  weight: FontWeight.w300,
                                  size: 14,
                                )
                              ],
                            ),
                          )
                        : Column(
                            children: [
                              ...labs.value.length <= 8
                                  ? labs.value.map((e) {
                                      return InkWell(
                                          onTap: () {
                                            Get.to(
                                              () => LabMap(
                                                key: Key(e.toString()),
                                                currentLab: e,
                                                currentLabIndex:
                                                    labs.indexOf(e),
                                                allLabs: <DocumentSnapshot>[
                                                  ...labs.value
                                                ],
                                              ),
                                            );
                                          },
                                          child: LabWidget(e, context));
                                    }).toList()
                                  : labs.value.sublist(0, 8).map((e) {
                                      return InkWell(
                                          onTap: () {
                                            Get.to(
                                              () => LabMap(
                                                key: Key(e.toString()),
                                                currentLab: e,
                                                currentLabIndex:
                                                    labs.indexOf(e),
                                                allLabs: <DocumentSnapshot>[
                                                  ...labs.value
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
                            currentLab: labs.value[0],
                            currentLabIndex: 0,
                            allLabs: <DocumentSnapshot>[...labs.value],
                          ),
                        );
                      }),
                  SizedBox(
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
}
