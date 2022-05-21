import 'dart:io';
import 'package:bot_md/Isolation/isolation_settings.dart';
import 'package:bot_md/Profile/Reports.dart';
import 'package:bot_md/Profile/edit_profile.dart';
import 'package:bot_md/Profile/saved_labs.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:image_picker/image_picker.dart';
import 'package:bot_md/Auth/login.dart';
import 'package:bot_md/globals_.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:get/get.dart';

import '../constants.dart';

class Profile extends StatelessWidget {
  Profile({Key? key}) : super(key: key);

  late File file;
  RxBool updatingImage = RxBool(false);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              children: [
                Container(
                  height: MediaQuery.of(context).size.height * 0.37,
                ),
                Container(
                  height: MediaQuery.of(context).size.height * 0.25,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [primaryColor, secondaryColor],
                      begin: Alignment.topLeft,
                    ),
                    boxShadow: [boxShad(5, 5, 25)],
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(25),
                      bottomRight: Radius.circular(25),
                    ),
                  ),
                ),
                Positioned(
                  top: MediaQuery.of(context).size.height * 0.078,
                  left: 25,
                  right: 25,
                  child: montserratText(
                    text: "Profile",
                    size: 20,
                    color: Colors.white,
                    weight: FontWeight.w500,
                  ),
                ),
                Obx(() {
                  return Positioned(
                    top: MediaQuery.of(context).size.height * 0.135,
                    left: 125,
                    right: 125,
                    child: (currentUserData['image'] == null)
                        ? const CircleAvatar(
                            radius: 70,
                            backgroundColor: Colors.white,
                            backgroundImage: NetworkImage(
                                'https://www.prajwaldesai.com/wp-content/uploads/2021/02/Find-Users-Last-Logon-Time-using-4-Easy-Methods.jpg'),
                          )
                        : CircleAvatar(
                            radius: 70,
                            backgroundImage:
                                NetworkImage(currentUserData['image']),
                          ),
                  );
                }),
                Obx(() {
                  return Positioned(
                    top: MediaQuery.of(context).size.height * 0.34,
                    left: 25,
                    right: 25,
                    child: montserratText(
                      text: "${currentUserData['name']}",
                      size: 15,
                      color: Colors.black,
                      weight: FontWeight.w400,
                    ),
                  );
                }),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  const SizedBox(
                    height: 10,
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: montserratText(
                      align: TextAlign.start,
                      text: "General Information",
                      size: 18,
                      color: Colors.grey[700],
                      weight: FontWeight.w300,
                    ),
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white,
                      boxShadow: [
                        boxShad(5, 7, 10, opacity: 0.15),
                      ],
                    ),
                    child: ListTile(
                      onTap: () {
                        Get.to(() => EditProfile());
                      },
                      title: montserratText(
                        text: 'Edit Profile',
                        color: Colors.black,
                        align: TextAlign.start,
                        size: 17,
                      ),
                      subtitle: montserratText(
                        text: "Update your profile settings",
                        size: 13,
                        align: TextAlign.start,
                        color: Colors.grey[500],
                        weight: FontWeight.w400,
                      ),
                      trailing: const Icon(
                        Icons.navigate_next_rounded,
                        size: 30,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white,
                      boxShadow: [
                        boxShad(5, 7, 10, opacity: 0.15),
                      ],
                    ),
                    child: Obx(() {
                      return ListTile(
                        onTap: () {
                          if (!updatingImage.value) {
                            getGalleryImage(context);
                          }
                        },
                        title: montserratText(
                          text: 'Update Profile Picture',
                          color: Colors.black,
                          align: TextAlign.start,
                          size: 17,
                        ),
                        subtitle: montserratText(
                          text: "Update your profile image",
                          size: 13,
                          align: TextAlign.start,
                          color: Colors.grey[500],
                          weight: FontWeight.w400,
                        ),
                        trailing: updatingImage.value
                            ? CircularProgressIndicator(
                                color: primaryColor,
                              )
                            : const Icon(
                                Icons.navigate_next_rounded,
                                size: 30,
                              ),
                      );
                    }),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white,
                      boxShadow: [
                        boxShad(5, 7, 10, opacity: 0.15),
                      ],
                    ),
                    child: ListTile(
                      onTap: () {
                        firstOpen = false;
                        FirebaseAuth.instance.signOut().then((value) {
                          Get.offAll(() => Login());
                        });
                      },
                      title: montserratText(
                        text: 'Logout',
                        color: Colors.black,
                        align: TextAlign.start,
                        size: 17,
                      ),
                      subtitle: montserratText(
                        text: "Log out of your account",
                        size: 13,
                        align: TextAlign.start,
                        color: Colors.grey[500],
                        weight: FontWeight.w400,
                      ),
                      trailing: const Icon(
                        Icons.navigate_next_rounded,
                        size: 30,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: montserratText(
                      align: TextAlign.start,
                      text: "Saves",
                      size: 18,
                      color: Colors.grey[700],
                      weight: FontWeight.w300,
                    ),
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  InkWell(
                    onTap: () {
                      Get.to(() => SavedLabs());
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.white,
                        boxShadow: [
                          boxShad(5, 7, 10, opacity: 0.15),
                        ],
                      ),
                      child: ListTile(
                        title: montserratText(
                          text: 'Labs',
                          color: Colors.black,
                          align: TextAlign.start,
                          size: 17,
                        ),
                        subtitle: montserratText(
                          text: "Labs you've saved",
                          size: 13,
                          align: TextAlign.start,
                          color: Colors.grey[500],
                          weight: FontWeight.w400,
                        ),
                        trailing: const Icon(
                          Icons.navigate_next_rounded,
                          size: 30,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white,
                      boxShadow: [
                        boxShad(5, 7, 10, opacity: 0.15),
                      ],
                    ),
                    child: ListTile(
                      title: montserratText(
                        text: 'Diets',
                        color: Colors.black,
                        align: TextAlign.start,
                        size: 17,
                      ),
                      subtitle: montserratText(
                        text: "Diets you've saved",
                        size: 13,
                        align: TextAlign.start,
                        color: Colors.grey[500],
                        weight: FontWeight.w400,
                      ),
                      trailing: const Icon(
                        Icons.navigate_next_rounded,
                        size: 30,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white,
                      boxShadow: [
                        boxShad(5, 7, 10, opacity: 0.15),
                      ],
                    ),
                    child: ListTile(
                      title: montserratText(
                        text: 'Remedies',
                        color: Colors.black,
                        align: TextAlign.start,
                        size: 17,
                      ),
                      subtitle: montserratText(
                        text: "Remedies you've saved",
                        size: 13,
                        align: TextAlign.start,
                        color: Colors.grey[500],
                        weight: FontWeight.w400,
                      ),
                      trailing: const Icon(
                        Icons.navigate_next_rounded,
                        size: 30,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: montserratText(
                      align: TextAlign.start,
                      text: "Covid Settings",
                      size: 18,
                      color: Colors.grey[700],
                      weight: FontWeight.w300,
                    ),
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white,
                      boxShadow: [
                        boxShad(5, 7, 10, opacity: 0.15),
                      ],
                    ),
                    child: CheckboxListTile(
                      value: currentUserData['isolated'],
                      onChanged: (val) {
                        DateTime now = DateTime.now();
                        FirebaseFirestore.instance
                            .collection("Users")
                            .doc(currentUser.id)
                            .update({
                          'isolated': val,
                          "isolatedOn": DateTime(now.year, now.month, now.day),
                        });
                        FirebaseFirestore.instance
                            .collection("Admin")
                            .doc('Admin Details')
                            .update(
                                {'totalIsolations': FieldValue.increment(1)});
                      },
                      title: montserratText(
                        text: 'Isolation',
                        color: Colors.black,
                        align: TextAlign.start,
                        size: 17,
                      ),
                      subtitle: montserratText(
                        text: "Toggle Isolation mode",
                        size: 13,
                        align: TextAlign.start,
                        color: Colors.grey[500],
                        weight: FontWeight.w400,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white,
                      boxShadow: [
                        boxShad(5, 7, 10, opacity: 0.15),
                      ],
                    ),
                    child: ListTile(
                      onTap: () {
                        Get.to(() => const IsolatoionSettings());
                      },
                      title: montserratText(
                        text: 'Isolation Settings',
                        color: Colors.black,
                        align: TextAlign.start,
                        size: 17,
                      ),
                      subtitle: montserratText(
                        text: "Update your profile settings",
                        size: 13,
                        align: TextAlign.start,
                        color: Colors.grey[500],
                        weight: FontWeight.w400,
                      ),
                      trailing: const Icon(
                        Icons.navigate_next_rounded,
                        size: 30,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white,
                      boxShadow: [
                        boxShad(5, 7, 10, opacity: 0.15),
                      ],
                    ),
                    child: ListTile(
                      onTap: () {
                        Get.to(() => const Reports());
                      },
                      title: montserratText(
                        text: 'Covid Reports',
                        color: Colors.black,
                        align: TextAlign.start,
                        size: 17,
                      ),
                      subtitle: montserratText(
                        text: "Generate reports against your covid tests",
                        size: 13,
                        align: TextAlign.start,
                        color: Colors.grey[500],
                        weight: FontWeight.w400,
                      ),
                      trailing: const Icon(
                        Icons.navigate_next_rounded,
                        size: 30,
                      ),
                    ),
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

  Future getGalleryImage(context) async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      file = File(pickedFile.path);
      cropper(context);
    } else {
      print('No image selected.');
    }
  }

  cropper(context) async {
    await ImageCropper()
        .cropImage(
            sourcePath: file.path,
            cropStyle: CropStyle.circle,
            aspectRatioPresets: [
              CropAspectRatioPreset.ratio3x2,
              CropAspectRatioPreset.original,
              CropAspectRatioPreset.ratio4x3,
              CropAspectRatioPreset.ratio16x9
            ],
            androidUiSettings: const AndroidUiSettings(
                toolbarTitle: 'Crop',
                toolbarColor: Colors.white,
                toolbarWidgetColor: Colors.black,
                initAspectRatio: CropAspectRatioPreset.original,
                lockAspectRatio: false),
            iosUiSettings: IOSUiSettings(
              minimumAspectRatio: 1.0,
            ))
        .then((value) async {
      updatingImage.value = true;
      var ref = await FirebaseStorage.instance
          .ref()
          .child('${value!.path}${DateTime.now()}');
      var upload = await ref.putFile(value);

      await ref.getDownloadURL().then((value) {
        FirebaseFirestore.instance
            .collection('Users')
            .doc(currentUser.id)
            .update({
          'image': value,
        }).then((_) {
          FirebaseFirestore.instance
              .collection('Users')
              .doc(currentUser.id)
              .get()
              .then((user) {
            updatingImage.value = false;
          });
        });
      });
    });
  }
}
