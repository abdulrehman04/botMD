import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../constants.dart';
import '../globals_.dart';

class UpdatePassword extends StatelessWidget {
  UpdatePassword({Key? key}) : super(key: key);

  TextEditingController password = TextEditingController();
  TextEditingController confirmPassword = TextEditingController();
  RxBool isSubmitting = RxBool(false);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomSheet: Obx(() {
        return Container(
          height: 70,
          child: isSubmitting.value
              ? CircularProgressIndicator(
                  color: primaryColor,
                )
              : gradientLongButton(
                  horizontal: 20,
                  text: "UPDATE",
                  onTap: () {
                    if (password.text == "" || confirmPassword.text == "") {
                      Get.snackbar(
                        "Uh no",
                        "Fields can't be empty",
                        colorText: Colors.white,
                        backgroundColor: Colors.redAccent.withOpacity(0.5),
                      );
                    } else {
                      // FirebaseAuth.instance.currentUser.updatePassword(newPassword)
                      // isSubmitting.value = false;
                      // FirebaseFirestore.instance
                      //     .collection("Users")
                      //     .doc(currentUser.id)
                      //     .update({
                      //   "name": name.text.trim(),
                      // }).then((_) {
                      //   isSubmitting.value = true;
                      //   Get.back();
                      //   Get.snackbar(
                      //     "Check!",
                      //     "Name was updated Successfully",
                      //     colorText: Colors.white,
                      //     backgroundColor: Colors.lightGreen.withOpacity(0.65),
                      //   );
                      // });
                    }
                  },
                ),
        );
      }),
      body: SafeArea(
        child: Column(
          children: [
            gradientAppBar(context: context, title: "Update Password"),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  loginInputField(
                    controller: password,
                    hint: "Enter your current password",
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  loginInputField(
                    controller: confirmPassword,
                    hint: "Choose a new Password",
                  ),
                  const SizedBox(
                    height: 40,
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
