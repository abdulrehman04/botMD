import 'package:flutter/material.dart';
import 'package:get/get.dart';

Color primaryColor = Color(0xff95356B);
Color headingColor = Color(0xff205072);
Color secondaryColor = Color(0xff1F0751);
RxInt currentIndex = RxInt(0);
bool usingHopkins = true;
RxMap worldStats = RxMap({});
bool firstOpen = false;
final height = Get.height;
final width = Get.width;
final backButton = InkWell(
  onTap: () {
    Get.back();
  },
  child: const Icon(
    Icons.navigate_before,
    color: Colors.white,
    size: 35,
  ),
);

final appGradient = LinearGradient(
  colors: [primaryColor, secondaryColor],
  begin: Alignment.topLeft,
);
