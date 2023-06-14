import 'dart:io';

import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/update_profile_controller.dart';

class UpdateProfileView extends GetView<UpdateProfileController> {
  final Map<String, dynamic> user = Get.arguments;
  UpdateProfileView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    controller.nipController.text = user["nip"];
    controller.nameController.text = user["name"];
    controller.jobController.text = user["job"];
    controller.emailController.text = user["email"];
    return Scaffold(
      appBar: AppBar(
        title: const Text("Update Profile Page"),
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
              readOnly: false,
              autocorrect: false,
              controller: controller.nipController,
              decoration: const InputDecoration(
                labelText: "NIP",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              readOnly: false,
              autocorrect: false,
              controller: controller.nameController,
              decoration: const InputDecoration(
                labelText: "Name",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              readOnly: false,
              autocorrect: false,
              controller: controller.jobController,
              decoration: const InputDecoration(
                labelText: "Job",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              readOnly: false,
              autocorrect: false,
              controller: controller.emailController,
              decoration: const InputDecoration(
                labelText: "Email",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 25),
            const Text(
              "Photo Profile",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GetBuilder<UpdateProfileController>(
                  builder: (controller) {
                    if (controller.image != null) {
                      return ClipOval(
                        child: SizedBox(
                          height: 100,
                          width: 100,
                          child: Image.file(
                            File(controller.image!.path),
                            fit: BoxFit.cover,
                          ),
                        ),
                      );
                    } else {
                      if (user["profile"] != null) {
                        return Column(
                          children: [
                            ClipOval(
                              child: SizedBox(
                                height: 100,
                                width: 100,
                                child: Image.network(
                                  user["profile"],
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                controller.deleteImage(user["uid"]);
                              },
                              child: const Text("Delete"),
                            ),
                          ],
                        );
                      } else {
                        return const Text("No Image !");
                      }
                    }
                  },
                ),
                TextButton(
                  onPressed: () {
                    controller.pickImage();
                  },
                  child: const Text("Choose"),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Obx(
                  () => ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromRGBO(6, 74, 203, 1),
                    ),
                    onPressed: () async {
                      if (controller.isLoading.isFalse) {
                        await controller.updateProfile(user["uid"]);
                      }
                    },
                    child: Text(
                      controller.isLoading.isFalse
                          ? "Update Profile"
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
