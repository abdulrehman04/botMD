import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/state_manager.dart';
import 'package:get/get.dart';
import '../constants.dart';
import '../globals_.dart';

class UpdateName extends StatelessWidget {
  UpdateName({Key? key}) : super(key: key);

  TextEditingController name = TextEditingController();
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
                    if (name.text == "") {
                      Get.snackbar(
                        "Uh no",
                        "Name can't be Empty",
                        colorText: Colors.white,
                        backgroundColor: Colors.redAccent.withOpacity(0.5),
                      );
                    } else {
                      isSubmitting.value = false;
                      FirebaseFirestore.instance
                          .collection("Users")
                          .doc(currentUser.id)
                          .update({
                        "name": name.text.trim(),
                      }).then((_) {
                        isSubmitting.value = true;
                        Get.back();
                        Get.snackbar(
                          "Check!",
                          "Name was updated Successfully",
                          colorText: Colors.white,
                          backgroundColor: Colors.lightGreen.withOpacity(0.65),
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
            gradientAppBar(context: context, title: "Update Name"),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  loginInputField(
                    controller: name,
                    hint: "New Name",
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
