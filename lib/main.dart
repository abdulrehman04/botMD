import 'package:bot_md/Auth/login.dart';
import 'package:bot_md/constants.dart';
import 'package:bot_md/globals_.dart';
import 'package:bot_md/onBoarding/on_boarding_1.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  prefs = await SharedPreferences.getInstance();
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
      home: FutureBuilder(
        initialData: auth.currentUser,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            getCurrentLocation().then((value) {
              currentLocation = value;
            });
            String? firstLogin = prefs.getString("firstLogin");
            if (firstLogin == null) {
              return OnBoarding1();
            } else {
              return const Login();
            }
          } else {
            if (snapshot.data != null) {
              getCurrentLocation().then((value) {
                currentLocation = value;
                print("Herer");
                getandUpdateUsersData();
              });
            } else {
              getCurrentLocation().then((value) {
                currentLocation = value;
              });
              return const Login();
            }
            return Scaffold(
              body: SizedBox(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'Assets/logo.png',
                      height: 170,
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: "Bot",
                            style: GoogleFonts.montserrat(
                              fontSize: 25,
                              color: Colors.blueGrey[900],
                            ),
                          ),
                          TextSpan(
                            text: "MD",
                            style: GoogleFonts.montserrat(
                              fontSize: 25,
                              color: Colors.purple,
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
