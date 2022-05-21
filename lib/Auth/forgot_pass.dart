import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../constants.dart';
import '../globals_.dart';

class ForgotPass extends StatelessWidget {
  ForgotPass({Key? key}) : super(key: key);

  TextEditingController email = TextEditingController();
  RxBool isSubmitting = RxBool(false);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomSheet: Obx(() {
        return SizedBox(
          height: 70,
          child: isSubmitting.value == true
              ? Center(
                  child: CircularProgressIndicator(
                    color: primaryColor,
                  ),
                )
              : gradientLongButton(
                  horizontal: 20,
                  text: "RESET PASSWORD",
                  onTap: () async {
                    if (email.text == "") {
                      Get.snackbar(
                        "Uh no",
                        "Email can't be Empty",
                        colorText: Colors.white,
                        backgroundColor: Colors.redAccent.withOpacity(0.5),
                      );
                    } else {
                      if (GetUtils.isEmail(email.text.trim())) {
                        isSubmitting.value = true;
                        try {
                          FirebaseFirestore.instance
                              .collection("Users")
                              .where('email', isEqualTo: email.text.trim())
                              .get()
                              .then((value) {
                            if (value.docs.length == 0) {
                              Get.snackbar(
                                "Error",
                                "User doesn't exist",
                                backgroundColor:
                                    Colors.redAccent.withOpacity(0.4),
                              );
                            } else {
                              FirebaseAuth.instance
                                  .sendPasswordResetEmail(
                                      email: email.text.trim())
                                  .then((value) {
                                Get.back();
                                Get.snackbar(
                                  "All Set",
                                  "A password reset link has been sent to your email",
                                );
                              });
                            }
                          });
                        } on FirebaseException catch (e) {
                          isSubmitting.value = false;
                          Get.snackbar(
                            "Uh oh",
                            e.message!,
                            colorText: Colors.white,
                            backgroundColor: Colors.redAccent.withOpacity(0.5),
                          );
                        }
                      } else {
                        Get.snackbar(
                          "Uh no",
                          "Please enter a valid Email",
                          colorText: Colors.white,
                          backgroundColor: Colors.redAccent.withOpacity(0.5),
                        );
                      }
                    }
                  },
                ),
        );
      }),
      body: SafeArea(
        child: Column(
          children: [
            gradientAppBar(context: context, title: "Reset Password"),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  loginInputField(
                    controller: email,
                    hint: "Enter your Email Address",
                    horizontal: 0,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
