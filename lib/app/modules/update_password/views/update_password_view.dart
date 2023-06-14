import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/update_password_controller.dart';

class UpdatePasswordView extends GetView<UpdatePasswordController> {
  const UpdatePasswordView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Update Password Page"),
        titleSpacing: 00.0,
        centerTitle: true,
        toolbarHeight: 55,
        toolbarOpacity: 0.8,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              bottomRight: Radius.circular(14),
              bottomLeft: Radius.circular(14)),
        ),
        elevation: 0.00,
        backgroundColor: const Color.fromRGBO(17, 70, 143, 1),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            TextField(
              controller: controller.currentController,
              autocorrect: false,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: "Current Password",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            TextField(
              controller: controller.newController,
              autocorrect: false,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: "New Password",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            TextField(
              controller: controller.confirmController,
              autocorrect: false,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: "Confirm Password",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Obx(
                  () => ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromRGBO(6, 74, 203, 1),
                    ),
                    onPressed: () {
                      if (controller.isLoading.isFalse) {
                        controller.updatePassword();
                      }
                    },
                    child: Text(
                      controller.isLoading.isFalse
                          ? "Change Password"
                          : "Loading...",
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
