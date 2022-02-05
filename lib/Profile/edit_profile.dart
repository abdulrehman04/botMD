import 'package:bot_md/Profile/update_email.dart';
import 'package:bot_md/Profile/update_name.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../globals_.dart';

class EditProfile extends StatelessWidget {
  const EditProfile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            gradientAppBar(context: context, title: "Edit Profile"),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  shadedListTile(
                    title: "Update Name",
                    subtitle: "Updates the display name of the user",
                    onTap: () {
                      Get.to(() => UpdateName());
                    },
                  ),
                  shadedListTile(
                    title: "Update Email",
                    subtitle: "Updates the email of the current user",
                    onTap: () {
                      Get.to(() => UpdateEmail());
                    },
                  ),
                  shadedListTile(
                    title: "Update Password",
                    subtitle: "Updates the password of the user",
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
