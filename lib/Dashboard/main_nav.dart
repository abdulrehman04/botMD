import 'dart:convert';

import 'package:bot_md/Dashboard/home_.dart';
import 'package:bot_md/Dashboard/library.dart';
import 'package:bot_md/Dashboard/profile.dart';
import 'package:bot_md/Navigation/laboratories.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:http/http.dart' as http;
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../constants.dart';

class MainNav extends StatefulWidget {
  const MainNav({Key? key}) : super(key: key);

  @override
  _MainNavState createState() => _MainNavState();
}

class _MainNavState extends State<MainNav> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (usingHopkins) {
      getWorldStats_hopkins();
    } else {
      getWorldCountries();
    }
  }

  List pages = [
    const Home(),
    Library(),
    Profile(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() {
        return pages[currentIndex.value];
      }),
      floatingActionButton: InkWell(
        onTap: () {
          currentIndex.value = 0;
        },
        child: Container(
          padding: const EdgeInsets.all(13),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                primaryColor,
                secondaryColor,
              ],
            ),
          ),
          child: const Icon(
            Icons.home_rounded,
            size: 40,
            color: Colors.white,
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        color: Colors.white,
        shape: CircularNotchedRectangle(),
        notchMargin: 5,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 35),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              IconButton(
                icon: Icon(
                  Icons.assignment,
                  color: secondaryColor,
                ),
                onPressed: () {
                  currentIndex.value = 1;
                },
              ),
              IconButton(
                icon: Icon(
                  currentIndex.value == 2
                      ? FontAwesomeIcons.solidUser
                      : FontAwesomeIcons.user,
                  color: const Color(0xff1F0751),
                ),
                onPressed: () {
                  currentIndex.value = 2;
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> getWorldCountries() async {
    var headers = {
      'x-rapidapi-host':
          'vaccovid-coronavirus-vaccine-and-treatment-tracker.p.rapidapi.com',
      'x-rapidapi-key': '32a65a8edamsh5c74cac186577f2p13515cjsn65552860b4d1'
    };
    var request = http.Request(
        'GET',
        Uri.parse(
            'https://vaccovid-coronavirus-vaccine-and-treatment-tracker.p.rapidapi.com/api/npm-covid-data/world'));

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      var result = await response.stream.bytesToString();
      print(result);
      worldStats.value = Map.from(jsonDecode(result)[0]);
    } else {
      print(response.reasonPhrase);
    }
  }

  Future<void> getWorldStats_hopkins() async {
    var headers = {
      'x-rapidapi-host': 'covid-19-statistics.p.rapidapi.com',
      'x-rapidapi-key': '32a65a8edamsh5c74cac186577f2p13515cjsn65552860b4d1'
    };
    var request = http.Request('GET',
        Uri.parse('https://covid-19-statistics.p.rapidapi.com/reports/total'));

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      var result = await response.stream.bytesToString();
      print("data heree");
      worldStats.value = Map.from(jsonDecode(result)['data']);
      print(worldStats.value);
    } else {
      print(response.reasonPhrase);
    }
  }
}
