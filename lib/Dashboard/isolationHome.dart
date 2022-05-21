import 'package:bot_md/Chat/botchat.dart';
import 'package:bot_md/Chat/chat_list.dart';
import 'package:bot_md/Dashboard/library.dart';
import 'package:bot_md/Isolation/Isolation_covid_stats.dart';
import 'package:bot_md/Navigation/laboratories.dart';
import 'package:bot_md/constants.dart';
import 'package:bot_md/globals_.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class IsolationHome extends StatelessWidget {
  late DateTime currentTime;
  int currentDay = 0;

  IsolationHome({Key? key}) : super(key: key) {
    currentTime = DateTime.now();
    currentDay =
        currentTime.difference(currentUserData['isolatedOn'].toDate()).inDays;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[700],
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(
                height: 60,
              ),
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: "Bot",
                      style: GoogleFonts.montserrat(
                        fontSize: 25,
                        color: Colors.blueGrey[900],
                      ),
                    ),
                    TextSpan(
                      text: "MD",
                      style: GoogleFonts.montserrat(
                        fontSize: 25,
                        color: Colors.purple,
                      ),
                    )
                  ],
                ),
              ),
              const SizedBox(
                height: 40,
              ),
              montserratText(
                text: DateFormat('EEE dd MMM yyyy').format(currentTime),
                color: Colors.white,
                weight: FontWeight.w400,
                size: 15,
              ),
              const SizedBox(
                height: 35,
              ),
              montserratText(
                text: "${14 - (currentDay + 1)} days left",
                color: Colors.white,
                size: 27,
                weight: FontWeight.w600,
              ),
              const SizedBox(
                height: 20,
              ),
              Obx(() {
                print(adminDetails.value);
                return RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: "${adminDetails.value['totalIsolations']} ",
                        style: GoogleFonts.montserrat(
                            fontSize: 18,
                            color: Colors.white,
                            fontWeight: FontWeight.w600),
                      ),
                      TextSpan(
                        text:
                            "other people\nare on the same day of isolation\nwith you",
                        style: GoogleFonts.montserrat(
                          fontSize: 18,
                          color: Colors.white,
                        ),
                      )
                    ],
                  ),
                );
              }),
              const SizedBox(
                height: 20,
              ),
              Wrap(
                children: List.generate(14, (index) => index).map((e) {
                  return Container(
                    height: 23,
                    width: 23,
                    margin: const EdgeInsets.fromLTRB(0, 10, 10, 10),
                    decoration: BoxDecoration(
                      color: e <= currentDay ? Colors.white : Colors.lightBlue,
                      shape: BoxShape.circle,
                    ),
                    child: e < currentDay
                        ? Icon(
                            Icons.check,
                            size: 12,
                            color: Colors.blue[700],
                          )
                        : Container(),
                  );
                }).toList(),
              ),
              const SizedBox(
                height: 40,
              ),
              Wrap(
                spacing: 5,
                runSpacing: 10,
                children: [
                  isolationPillButton("Chat With Bot", () {
                    Get.to(() => const BotChat());
                  }),
                  isolationPillButton("My Chats", () {
                    Get.to(() => ChatList());
                  }),
                  isolationPillButton("Covid Stats", () {
                    Get.to(() => const IsolationCovidStats());
                  }),
                  isolationPillButton("View Labs Nearby", () {
                    Get.to(() => const Laboratories());
                  }),
                  isolationPillButton("View diets and remedies", () {
                    Get.to(() => Library());
                  }),
                  isolationPillButton("Send SOS", () {}),
                  isolationPillButton("Exit Isolation", () {
                    FirebaseFirestore.instance
                        .collection("Users")
                        .doc(currentUser.id)
                        .update({'isolated': false, 'isolatedOn': null});
                    FirebaseFirestore.instance
                        .collection("Admin")
                        .doc('Admin Details')
                        .update({'totalIsolations': FieldValue.increment(-1)});
                  }),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
