import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../constants.dart';
import '../globals_.dart';

class UpdateEmail extends StatelessWidget {
  UpdateEmail({Key? key}) : super(key: key);

  TextEditingController email = TextEditingController();
  RxBool isSubmitting = RxBool(false);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomSheet: Obx(() {
        return Container(
          height: 70,
          child: isSubmitting.value == true
              ? Center(
                  child: CircularProgressIndicator(
                    color: primaryColor,
                  ),
                )
              : gradientLongButton(
                  horizontal: 20,
                  text: "UPDATE",
                  onTap: () {
                    if (email.text == "") {
                      Get.snackbar(
                        "Uh no",
                        "Email can't be Empty",
                        colorText: Colors.white,
                        backgroundColor: Colors.redAccent.withOpacity(0.5),
                      );
                    } else {
                      isSubmitting.value = true;
                      FirebaseAuth.instance.currentUser!
                          .updateEmail('abdul.rehman@rwazi.com')
                          .then((_) {
                        isSubmitting.value = true;
                        Get.back();
                        Get.snackbar(
                          "All Set!",
                          "Your Email Address has been updated",
                          colorText: Colors.white,
                          backgroundColor: Colors.greenAccent.withOpacity(0.5),
                        );
                      });
                    }
                  },
                ),
        );
      }),
      body: SafeArea(
        child: Column(
          children: [
            gradientAppBar(context: context, title: "Update Email"),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  loginInputField(
                    controller: email,
                    hint: "Enter new Email Address",
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
