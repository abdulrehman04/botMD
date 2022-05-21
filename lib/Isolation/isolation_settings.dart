import 'package:bot_md/Isolation/SOS_contacts.dart';
import 'package:bot_md/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';

import '../globals_.dart';

class IsolatoionSettings extends StatelessWidget {
  const IsolatoionSettings({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            gradientAppBar(context: context, title: "Isolation Settings"),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white,
                      boxShadow: [
                        boxShad(5, 7, 10, opacity: 0.15),
                      ],
                    ),
                    child: Column(
                      children: [
                        ListTile(
                          title: montserratText(
                            text: "Isolation Days",
                            color: Colors.black,
                            align: TextAlign.start,
                            size: 17,
                          ),
                          subtitle: montserratText(
                            text: "Customise the number of days to isolate for",
                            size: 13,
                            align: TextAlign.start,
                            color: Colors.grey[500],
                            weight: FontWeight.w400,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              InkWell(
                                onTap: () {
                                  if (currentUserData['isolationDays'] > 1) {
                                    FirebaseFirestore.instance
                                        .collection("Users")
                                        .doc(currentUser.id)
                                        .update({
                                      "isolationDays": FieldValue.increment(-1)
                                    });
                                  }
                                },
                                child: Icon(
                                  Icons.navigate_before,
                                  color: primaryColor,
                                ),
                              ),
                              Obx(() {
                                return montserratText(
                                    text: currentUserData['isolationDays']
                                        .toString(),
                                    weight: FontWeight.w500,
                                    color: primaryColor);
                              }),
                              InkWell(
                                onTap: () {
                                  if (currentUserData['isolationDays'] < 14) {
                                    FirebaseFirestore.instance
                                        .collection("Users")
                                        .doc(currentUser.id)
                                        .update({
                                      "isolationDays": FieldValue.increment(1)
                                    });
                                  }
                                },
                                child: Icon(
                                  Icons.navigate_next,
                                  color: primaryColor,
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  shadedListTile(
                    title: "Emergency Contacts",
                    subtitle: "Select contacts to send SOS to",
                    onTap: () {
                      Get.to(() => const SOSContacts());
                    },
                  ),
                  shadedListTile(
                    title: "Update Password",
                    subtitle: "Updates the password of the user",
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
