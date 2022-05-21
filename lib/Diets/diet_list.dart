import 'package:bot_md/Diets/diet_details.dart';
import 'package:bot_md/globals_.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/state_manager.dart';

class DietList extends StatelessWidget {
  String dietId = '';
  String title = '';
  RxList dietDetails = RxList([]);
  DietList(id, title) {
    dietId = id;
    this.title = title;
    getDietDetails();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              gradientAppBar(context: context, title: title),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Obx(() {
                  return Column(
                    children: [
                      const SizedBox(
                        height: 10,
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: montserratText(
                          align: TextAlign.start,
                          text: "${dietDetails.length} diet(s) found",
                          size: 18,
                          color: Colors.grey[700],
                          weight: FontWeight.w300,
                        ),
                      ),
                      const SizedBox(
                        height: 25,
                      ),
                      ...dietDetails.map((element) {
                        return Column(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.white,
                                boxShadow: [
                                  boxShad(5, 7, 10, opacity: 0.15),
                                ],
                              ),
                              child: ListTile(
                                onTap: () {
                                  Get.to(() => DietDetails(element));
                                },
                                title: montserratText(
                                  text: element.get('title'),
                                  color: Colors.black,
                                  align: TextAlign.start,
                                  size: 17,
                                ),
                                subtitle: montserratText(
                                  text: element.get('subtitle'),
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
                            ),
                            SizedBox(
                              height: 15,
                            ),
                          ],
                        );
                      }).toList()
                    ],
                  );
                }),
              )
            ],
          ),
        ),
      ),
    );
  }

  getDietDetails() {
    FirebaseFirestore.instance
        .collection("Diets")
        .doc(dietId)
        .collection("Details")
        .get()
        .then((value) {
      dietDetails.value = value.docs;
    });
  }
}
