import 'dart:convert';
import 'dart:typed_data';

import 'package:bot_md/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/state_manager.dart';

import '../globals_.dart';

class Library extends StatelessWidget {
  Library() {
    getLabs();
  }

  RxList labs = RxList([]);
  List remedies = [
    "https://g.foolcdn.com/editorial/images/660924/restaurant-gettyimages-643847438.jpg",
    "https://expertphotography.b-cdn.net/wp-content/uploads/2019/01/brooke-lark-158017-unsplash-1500-1-1024x767.jpg",
    'https://health.clevelandclinic.org/wp-content/uploads/sites/3/2019/06/cropped-GettyImages-643764514.jpg',
    'https://www.creativebloggingworld.com/wp-content/uploads/2020/06/Indian-Street-Food.jpg',
    'https://post.healthline.com/wp-content/uploads/2018/04/steak-meat-1200x628-facebook-1200x628.jpg',
  ];

  List diets = [
    'https://post.healthline.com/wp-content/uploads/2018/04/steak-meat-1200x628-facebook-1200x628.jpg',
    'https://health.clevelandclinic.org/wp-content/uploads/sites/3/2019/06/cropped-GettyImages-643764514.jpg',
    'https://www.creativebloggingworld.com/wp-content/uploads/2020/06/Indian-Street-Food.jpg',
    "https://g.foolcdn.com/editorial/images/660924/restaurant-gettyimages-643847438.jpg",
    "https://expertphotography.b-cdn.net/wp-content/uploads/2019/01/brooke-lark-158017-unsplash-1500-1-1024x767.jpg",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              gradientAppBar(context: context, title: "Library"),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    const SizedBox(
                      height: 10,
                    ),
                    headingWidget("Nearby Labs"),
                    const SizedBox(
                      height: 25,
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height * 0.25,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: labs.value.map((e) {
                          return LabWidget(e, context);
                        }).toList(),
                      ),
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    headingWidget("Diets"),
                    const SizedBox(
                      height: 25,
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height * 0.25,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: diets.map<Widget>((e) {
                          return miniCards(e, context, diets.indexOf(e));
                        }).toList(),
                      ),
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    headingWidget("Remedies"),
                    const SizedBox(
                      height: 25,
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height * 0.25,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: remedies.map<Widget>((e) {
                          return miniCards(e, context, remedies.indexOf(e));
                        }).toList(),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  miniCards(e, context, index) {
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
                text: 'Diet $index',
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

  void getLabs() {
    FirebaseFirestore.instance.collection("Labs").get().then((value) {
      labs.value = value.docs;
    });
  }

  Widget LabWidget(e, context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.86,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        color: Colors.white,
        boxShadow: [
          boxShad(5, 7, 10, opacity: 0.15),
        ],
      ),
      margin: const EdgeInsets.only(
        right: 15,
        bottom: 18,
      ),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(18),
                  bottomLeft: Radius.circular(18),
                ),
                image: e.get('photo') != null
                    ? DecorationImage(
                        image: MemoryImage(
                          e.get('photo').bytes,
                        ),
                        fit: BoxFit.cover,
                      )
                    : const DecorationImage(
                        image: AssetImage(
                          'Assets/userAvatar.png',
                        ),
                      ),
              ),
            ),
          ),
          Expanded(
            flex: 4,
            child: Container(
              padding: const EdgeInsets.only(left: 15, top: 15, right: 10),
              child: Column(
                children: [
                  montserratText(
                    text: e.get('name'),
                    size: 15,
                    weight: FontWeight.w500,
                    color: Colors.black,
                    align: TextAlign.start,
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  montserratText(
                    text: e.get('formatted_address'),
                    size: 12,
                    weight: FontWeight.w400,
                    color: Colors.grey,
                    align: TextAlign.start,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 18),
                    child: Row(
                      // mainAxisAlignment:
                      //     MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.star,
                              size: 14,
                              color: primaryColor,
                            ),
                            montserratText(
                              text: e.get('rating') == null
                                  ? "0.0"
                                  : e.get('rating').toString(),
                              color: primaryColor,
                              size: 12,
                              weight: FontWeight.w400,
                            )
                          ],
                        ),
                        montserratText(
                          text: e.get('user_ratings_total') == null
                              ? "(0)"
                              : " (${e.get('user_ratings_total').toString()})",
                          color: primaryColor,
                          size: 12,
                          weight: FontWeight.w400,
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  headingWidget(text) {
    return Padding(
      padding: const EdgeInsets.only(right: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          montserratText(
            align: TextAlign.start,
            text: text,
            size: 18,
            color: Colors.grey[700],
            weight: FontWeight.w300,
          ),
          montserratText(
            align: TextAlign.start,
            text: "View All",
            size: 13,
            color: primaryColor.withOpacity(0.8),
            weight: FontWeight.w300,
          )
        ],
      ),
    );
  }
}
