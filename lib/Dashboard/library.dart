import 'package:bot_md/Diets/diet_list.dart';
import 'package:bot_md/Navigation/lab_map.dart';
import 'package:bot_md/bartest.dart';
import 'package:bot_md/constants.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../globals_.dart';

class Library extends StatelessWidget {
  Library() {}

  List remedies = [
    "https://g.foolcdn.com/editorial/images/660924/restaurant-gettyimages-643847438.jpg",
    "https://expertphotography.b-cdn.net/wp-content/uploads/2019/01/brooke-lark-158017-unsplash-1500-1-1024x767.jpg",
    'https://health.clevelandclinic.org/wp-content/uploads/sites/3/2019/06/cropped-GettyImages-643764514.jpg',
    'https://www.creativebloggingworld.com/wp-content/uploads/2020/06/Indian-Street-Food.jpg',
    'https://post.healthline.com/wp-content/uploads/2018/04/steak-meat-1200x628-facebook-1200x628.jpg',
  ];

  // List diets = [
  //   'https://post.healthline.com/wp-content/uploads/2018/04/steak-meat-1200x628-facebook-1200x628.jpg',
  //   'https://health.clevelandclinic.org/wp-content/uploads/sites/3/2019/06/cropped-GettyImages-643764514.jpg',
  //   'https://www.creativebloggingworld.com/wp-content/uploads/2020/06/Indian-Street-Food.jpg',
  //   "https://g.foolcdn.com/editorial/images/660924/restaurant-gettyimages-643847438.jpg",
  //   "https://expertphotography.b-cdn.net/wp-content/uploads/2019/01/brooke-lark-158017-unsplash-1500-1-1024x767.jpg",
  // ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              gradientAppBar(context: context, title: "Remedies and Diets"),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    const SizedBox(
                      height: 10,
                    ),
                    InkWell(
                      onTap: () {
                        currentIndex.value = 2;
                      },
                      child:
                          headingWidget("Nearby Labs", color: Colors.grey[700]),
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    Obx(() {
                      return SizedBox(
                        width: MediaQuery.of(context).size.width,
                        height: labs.value.length == 0
                            ? MediaQuery.of(context).size.height * 0.30
                            : MediaQuery.of(context).size.height * 0.25,
                        child: labs.value.length == 0
                            ? Column(
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
                              )
                            : ListView(
                                scrollDirection: Axis.horizontal,
                                children: labs.value.length <= 5
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
                                    : labs.value.sublist(0, 5).map((e) {
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
                              ),
                      );
                    }),
                    // const SizedBox(
                    //   height: 25,
                    // ),
                    headingWidget("Diets", color: Colors.grey[700]),
                    const SizedBox(
                      height: 25,
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height * 0.25,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: diets.map<Widget>((e) {
                          return InkWell(
                            onTap: () {
                              Get.to(() => DietList(e.id, e.get('title')));
                            },
                            child: miniCards(e, context, 'image', 'title'),
                          );
                        }).toList(),
                      ),
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    headingWidget("Remedies", color: Colors.grey[700]),
                    const SizedBox(
                      height: 25,
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height * 0.25,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: remedies.map<Widget>((e) {
                          return miniCardsTemp(e, context, remedies.indexOf(e));
                        }).toList(),
                      ),
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    headingWidget("Vaccination Data", color: Colors.grey[700]),
                    const SizedBox(
                      height: 25,
                    ),
                    Obx(() {
                      return showBarData();
                    }),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  miniCards(e, context, img, title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8.0, 8, 8.0, 15),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.4,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.white,
          boxShadow: [
            boxShad(5, 7, 10, opacity: 0.15),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: MediaQuery.of(context).size.width * 0.4,
              height: MediaQuery.of(context).size.height * 0.15,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                image: DecorationImage(
                  image: NetworkImage(e.get(img)),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10),
              child: montserratText(
                align: TextAlign.start,
                text: e.get(title),
                size: 18,
                color: Colors.grey[700],
                weight: FontWeight.w300,
              ),
            ),
          ],
        ),
      ),
    );
  }

  miniCardsTemp(e, context, index) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8.0, 8, 8.0, 15),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.4,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.white,
          boxShadow: [
            boxShad(5, 7, 10, opacity: 0.15),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: MediaQuery.of(context).size.width * 0.4,
              height: MediaQuery.of(context).size.height * 0.15,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                image: DecorationImage(
                  image: NetworkImage(e),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10),
              child: montserratText(
                align: TextAlign.start,
                text: "Remedy $index",
                size: 18,
                color: Colors.grey[700],
                weight: FontWeight.w300,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
