import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

Color primaryColor = const Color(0xff95356B);
Color headingColor = const Color(0xff205072);
Color secondaryColor = const Color(0xff1F0751);
RxInt currentIndex = RxInt(0);
late Position currentLocation;
bool usingHopkins = true;
RxMap worldStats = RxMap({});
RxList labs = RxList([]);
RxList chats = RxList([]);
RxList diets = RxList([]);
late SharedPreferences prefs;
bool firstOpen = false;
bool labSearchedOnce = false;
final height = Get.height;
final width = Get.width;
FirebaseMessaging messaging = FirebaseMessaging.instance;
String cloudNotifkey =
    'AAAADSLO2bw:APA91bES-GehRq5dnapiVZDOcySjEieqyuuG2VlU5MqOs7c9cxcsGi8GMfvYfDuf5LguVDGyDSCIu0kLARoro0WidTtwHuFdnbd7VXmKKY0-Nruvf8OFnTVPXVQN9185GtwlMJrao-OL';

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

// Vaccine vars
RxBool vaccinated = RxBool(true);
RxBool reCovid = RxBool(true);
Rx selectedVaccine = Rx(null);
List<String> vaccines = [
  'Moderna',
  "Pfizer",
  'Cansino',
  'Gamaleya',
  'AstraZeneca',
  'Sinopharm',
  'Sinovac'
];
TextEditingController covidNotes = TextEditingController();
Rx dateVaccinated = Rx(null);

// Vaccine data
RxMap vaccData = RxMap({
  'Moderna': 1,
  "Pfizer": 11,
  'Cansino': 7,
  'Gamaleya': 3,
  'AstraZeneca': 10,
  'Sinopharm': 5,
  'Sinovac': 2
});
