import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../constants.dart';
import '../globals_.dart';

class Signup extends StatelessWidget {
  String nameVal;
  Signup(this.nameVal) {
    name.text = nameVal;
  }

  TextEditingController name = TextEditingController();
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
                        text: "Signup",
                        size: 18,
                        weight: FontWeight.bold,
                        color: headingColor),
                    const SizedBox(
                      height: 10,
                    ),
                    montserratText(
                        text:
                            "Choose your login credentials to\n create your account",
                        color: secondaryColor,
                        weight: FontWeight.w400,
                        size: 13),
                  ],
                ),
                const SizedBox(
                  height: 60,
                ),
                loginInputField(
                  controller: name,
                  hint: "Name",
                ),
                const SizedBox(
                  height: 15,
                ),
                loginInputField(
                  controller: email,
                  hint: "Email",
                ),
                const SizedBox(
                  height: 15,
                ),
                loginInputField(
                  controller: password,
                  hint: "Password",
                  obscure: true,
                ),
                const SizedBox(
                  height: 40,
                ),
                gradientLongButton(
                  text: "SIGNUP",
                  onTap: () async {
                    if (name.text == "" ||
                        email.text == "" ||
                        password.text == "") {
                      errorSnack("Fields must not be empty");
                    } else if (!GetUtils.isEmail(email.text.trim())) {
                      errorSnack("Please Enter a valid email");
                    } else if (password.text.length < 8) {
                      errorSnack("Password must be atleast 8 characters");
                    } else {
                      try {
                        await FirebaseAuth.instance
                            .createUserWithEmailAndPassword(
                                email: email.text.trim(),
                                password: password.text.trim())
                            .then((value) {
                          FirebaseFirestore.instance
                              .collection("Users")
                              .doc(value.user!.uid)
                              .set({
                            'name': name.text.trim(),
                            "labRadius": 20,
                            'email': email.text.trim(),
                            'isolated': false,
                            'image': null,
                            'savedLabs': [],
                            'hadFirstVacc': false,
                          }).then((_) {
                            successSnack("Signup successful!");
                            getandUpdateUsersData();
                          });
                        });
                      } on FirebaseException catch (e) {
                        Get.snackbar(
                          "Error",
                          "${e.message}",
                          backgroundColor: Colors.redAccent.withOpacity(0.5),
                        );
                      }
                    }
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
                              successSnack(
                                "Signing you in",
                                title: 'Account already exists',
                              );
                              getandUpdateUsersData();
                            } else {
                              FirebaseFirestore.instance
                                  .collection("Users")
                                  .doc(user.user!.uid)
                                  .set({
                                'name': value.displayName,
                                "labRadius": 20,
                                'email': value.email,
                                'isolated': false,
                                'savedLabs': [],
                                'lastVac': DateTime(1980),
                                'isolationDays': 14,
                                'image': null,
                                'hadFirstVacc': false,
                                'sos_contacts': [],
                                'isolatedOn': null,
                              }).then((_) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
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
}
