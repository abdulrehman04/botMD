import 'package:bot_md/Auth/login.dart';
import 'package:bot_md/Dashboard/main_nav.dart';
import 'package:bot_md/globals_.dart';
import 'package:bot_md/onBoarding/on_boarding_1.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Bot MD',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      // home: OnBoarding1(),
      home: FutureBuilder(
        initialData: auth.currentUser,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Login();
          } else {
            print("Ithee");
            if (snapshot.data != null) {
              getandUpdateUsersData();
            } else {
              return Login();
            }
            return Center(
              child: Text("Splash Screen"),
            );
          }
        },
      ),
    );
  }
}
