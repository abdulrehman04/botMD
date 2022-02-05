import 'package:bot_md/Dashboard/main_nav.dart';
import 'package:bot_md/globals_.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../constants.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Align(
          alignment: Alignment.center,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(
                  height: 20,
                ),
                Image.asset("Assets/Icon.png"),
                const SizedBox(
                  height: 60,
                ),
                Column(
                  children: [
                    montserratText(
                        text: "Login",
                        size: 18,
                        weight: FontWeight.bold,
                        color: headingColor),
                    const SizedBox(
                      height: 10,
                    ),
                    montserratText(
                        text:
                            "Enter your login details to\n access your account",
                        color: secondaryColor,
                        weight: FontWeight.w400,
                        size: 13),
                  ],
                ),
                const SizedBox(
                  height: 60,
                ),
                loginInputField(controller: email, hint: "Email"),
                const SizedBox(
                  height: 15,
                ),
                loginInputField(controller: password, hint: "Password"),
                const SizedBox(
                  height: 40,
                ),
                gradientLongButton(
                  text: "LOG IN",
                  onTap: () {
                    FirebaseAuth.instance
                        .signInWithEmailAndPassword(
                            email: email.text.trim(),
                            password: password.text.trim())
                        .then((value) {
                      getandUpdateUsersData();
                    });
                  },
                ),
                const SizedBox(
                  height: 10,
                ),
                const Divider(
                  thickness: 2.5,
                  endIndent: 50,
                  indent: 50,
                ),
                const SizedBox(
                  height: 10,
                ),
                longButton(
                  onTap: () {
                    GoogleSignIn().signOut().then((_) {
                      GoogleSignIn().signIn().then((value) async {
                        final GoogleSignInAuthentication googleAuth =
                            await value!.authentication;
                        final credential = GoogleAuthProvider.credential(
                          accessToken: googleAuth.accessToken,
                          idToken: googleAuth.idToken,
                        );
                        FirebaseAuth.instance
                            .signInWithCredential(credential)
                            .then((user) {
                          FirebaseFirestore.instance
                              .collection("Users")
                              .doc(user.user!.uid)
                              .get()
                              .then((doc) {
                            if (doc.exists) {
                              getandUpdateUsersData();
                            } else {
                              FirebaseFirestore.instance
                                  .collection("Users")
                                  .doc(user.user!.uid)
                                  .set({
                                'name': value.displayName,
                                'image': null,
                              }).then((_) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text("Signed you up!"),
                                  ),
                                );
                                getandUpdateUsersData();
                              });
                            }
                          });
                        });
                      });
                    });
                  },
                  text: "Continue with Google",
                  icon: const Icon(FontAwesomeIcons.google),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void getandUpdateUsersData() {
    // messaging.getToken().then((token) {
    //   print(token);
    //   FirebaseFirestore.instance
    //       .collection('Users')
    //       .doc(FirebaseAuth.instance.currentUser!.uid)
    //       .update({
    //     'token': token,
    //   }).then((value) {
    FirebaseFirestore.instance
        .collection('Users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .snapshots()
        .listen((value) {
      currentUser = value;
      currentUserData.value = Map.from(value.data()!);
      if (firstOpen == false) {
        firstOpen = true;
        Get.off(MainNav());
      }
    });
    //   });
    // });
  }
}
