import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';

import '../globals_.dart';

class Laboratories extends StatelessWidget {
  const Laboratories({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            gradientAppBar(context: context, title: "Labs Nearby"),
          ],
        ),
      ),
    );
  }

  getPositionFromAddress(String address) async {
    final coordinates = await locationFromAddress(address);
    print(coordinates[0]);
  }
}
