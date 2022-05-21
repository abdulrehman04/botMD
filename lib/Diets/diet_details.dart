import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../globals_.dart';

class DietDetails extends StatelessWidget {
  late DocumentSnapshot diet;
  DietDetails(diet) {
    this.diet = diet;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              gradientAppBar(context: context, title: diet.get('title')),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: diet.get('content').map<Widget>((e) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          montserratText(
                              text: e['heading'],
                              color: Colors.black,
                              align: TextAlign.start,
                              size: 17,
                              weight: FontWeight.w500),
                          const SizedBox(
                            height: 5,
                          ),
                          montserratText(
                              text: e['para'],
                              color: Colors.black,
                              align: TextAlign.start,
                              size: 14,
                              weight: FontWeight.w300),
                          SizedBox(
                            height: 20,
                          ),
                        ],
                      );
                    }).toList(),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
