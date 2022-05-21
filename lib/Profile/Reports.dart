import 'package:bot_md/Profile/ReportDetails.dart';
import 'package:bot_md/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../globals_.dart';

class Reports extends StatelessWidget {
  const Reports({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            gradientAppBar(context: context, title: "Reports"),
            StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection("Reports")
                    .where('user', isEqualTo: currentUser.id)
                    .snapshots(),
                builder: (context, AsyncSnapshot snap) {
                  if (!snap.hasData) {
                    return Padding(
                      padding: const EdgeInsets.all(30.0),
                      child: CircularProgressIndicator(
                        color: primaryColor,
                      ),
                    );
                  }
                  QuerySnapshot data = snap.data;
                  return Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                        children: data.docs.map((e) {
                      return Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.white,
                          boxShadow: [
                            boxShad(5, 7, 10, opacity: 0.15),
                          ],
                        ),
                        child: ListTile(
                          onTap: () {
                            Get.to(() => ReportDetails(e));
                          },
                          title: montserratText(
                            text: DateFormat('dd MMM, yyyy')
                                .format(e['date'].toDate()),
                            color: Colors.black,
                            align: TextAlign.start,
                            size: 17,
                          ),
                          subtitle: montserratText(
                            text: "Result: ${e['result']}",
                            size: 13,
                            align: TextAlign.start,
                            color: Colors.grey[500],
                            weight: FontWeight.w400,
                          ),
                          trailing: const Icon(
                            Icons.navigate_next_rounded,
                            size: 30,
                          ),
                        ),
                      );
                    }).toList()),
                  );
                })
          ],
        ),
      ),
    );
  }
}
