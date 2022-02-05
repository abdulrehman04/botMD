import 'package:bot_md/Auth/login.dart';
import 'package:bot_md/gps_location.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../constants.dart';
import '../globals_.dart';

class OnBoarding1 extends StatefulWidget {
  OnBoarding1({Key? key}) : super(key: key);

  @override
  State<OnBoarding1> createState() => _OnBoarding1State();
}

class _OnBoarding1State extends State<OnBoarding1> {
  @override
  initState() {
    requestLocationPermission();
  }

  var currentIndex = 0.obs;

  @override
  Widget build(BuildContext context) {
    List onBoardingData = [
      Column(
        children: [
          Column(
            children: [
              montserratText(
                text: "This is BotMD,\nWelcome!",
                color: headingColor,
                weight: FontWeight.bold,
              ),
              const SizedBox(
                height: 10,
              ),
              montserratText(
                text: "Your Personal Covid Companion",
                color: secondaryColor,
                weight: FontWeight.w400,
                size: 13,
              ),
            ],
          ),
          SizedBox(
            height: 40,
          ),
          Image.asset("Assets/Doctor.png"),
        ],
      ),
      Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          montserratText(
            text: "Navigate to Nearest Lab",
            color: headingColor,
            weight: FontWeight.bold,
          ),
          SizedBox(
            height: 40,
          ),
          Container(
            height: MediaQuery.of(context).size.height * 0.46,
            width: MediaQuery.of(context).size.width * 0.9,
            decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage("Assets/Navigations.png"),
                  fit: BoxFit.contain),
            ),
          ),
        ],
      ),
      Column(
        children: [
          Column(
            children: [
              montserratText(
                text: "Get Diet and Remedies\nSuggestions",
                color: headingColor,
                weight: FontWeight.bold,
              ),
            ],
          ),
          SizedBox(
            height: 15,
          ),
          Container(
            height: MediaQuery.of(context).size.height * 0.46,
            width: MediaQuery.of(context).size.width * 0.9,
            decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage("Assets/Diet Remedies.png"),
                  fit: BoxFit.contain),
            ),
          ),
        ],
      ),
      Column(
        children: [
          montserratText(
            text: "Chat with Other People",
            color: headingColor,
            weight: FontWeight.bold,
          ),
          SizedBox(
            height: 15,
          ),
          Container(
            height: MediaQuery.of(context).size.height * 0.46,
            width: MediaQuery.of(context).size.width * 0.9,
            decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage("Assets/Chat Feature.png"),
                  fit: BoxFit.contain),
            ),
          ),
        ],
      ),
      Column(
        children: [
          montserratText(
            text: "Chat with the BotMD",
            color: headingColor,
            weight: FontWeight.bold,
          ),
          SizedBox(
            height: 40,
          ),
          Image.asset("Assets/Bot Chat.png"),
        ],
      ),
      Column(
        children: [
          montserratText(
            text: "Track your Symptoms",
            color: headingColor,
            weight: FontWeight.bold,
          ),
          SizedBox(
            height: 15,
          ),
          Container(
            height: MediaQuery.of(context).size.height * 0.46,
            width: MediaQuery.of(context).size.width * 0.9,
            decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage("Assets/Symptom.png"), fit: BoxFit.contain),
            ),
          ),
        ],
      ),
      Column(
        children: [
          montserratText(
            text: "Track Latest COVID-19 Updates",
            color: headingColor,
            weight: FontWeight.bold,
          ),
          SizedBox(
            height: 15,
          ),
          Container(
            height: MediaQuery.of(context).size.height * 0.46,
            width: MediaQuery.of(context).size.width * 0.9,
            decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage("Assets/Tracking.png"),
                  fit: BoxFit.contain),
            ),
          ),
        ],
      ),
    ];

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Align(
          alignment: Alignment.center,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset("Assets/Icon.png"),
              Container(
                height: MediaQuery.of(context).size.height * 0.55,
                child: Swiper(
                  loop: false,
                  itemCount: 7,
                  onIndexChanged: (index) {
                    currentIndex.value = index;
                  },
                  itemBuilder: (context, index) {
                    return onBoardingData[index];
                  },
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(7, (index) => index).map((e) {
                  return Obx(() {
                    return Container(
                      width: 7,
                      height: 7,
                      margin: const EdgeInsets.symmetric(horizontal: 5),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: currentIndex != e
                            ? secondaryColor.withOpacity(0.3)
                            : secondaryColor,
                      ),
                    );
                  });
                }).toList(),
              ),
              gradientLongButton(
                text: "GET STARTED",
                onTap: () {
                  Get.to(() => const Login());
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
