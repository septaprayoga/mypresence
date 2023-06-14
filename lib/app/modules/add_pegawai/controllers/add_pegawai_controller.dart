// ignore_for_file: unnecessary_overrides, unnecessary_string_interpolations

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AddPegawaiController extends GetxController {
  RxBool isLoading = false.obs;
  RxBool isLoadingAdd = false.obs;

  TextEditingController nipController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController jobController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordAdminController = TextEditingController();

  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<void> prosesAddPegawai() async {
    if (passwordAdminController.text.isNotEmpty) {
      isLoadingAdd.value = true;
      try {
        String emailAdmin = auth.currentUser!.email!;

        // ignore: unused_local_variable
        UserCredential userCredentialAdmin =
            await auth.signInWithEmailAndPassword(
          email: emailAdmin,
          password: passwordAdminController.text,
        );
        // ignore: unused_local_variable
        UserCredential pegawaiCredential =
            await auth.createUserWithEmailAndPassword(
          email: emailController.text,
          password: "password",
        );
        if (pegawaiCredential.user != null) {
          // ignore: unused_local_variable
          String uid = pegawaiCredential.user!.uid;

          await firestore.collection("pegawai").doc(uid).set({
            "nip": nipController.text,
            "name": nameController.text,
            "job": jobController.text,
            "email": emailController.text,
            "uid": uid,
            "role": "pegawai",
            "createdAt": DateTime.now().toIso8601String(),
          });
          await pegawaiCredential.user!.sendEmailVerification();
          await auth.signOut();

          // ignore: unused_local_variable
          UserCredential userCredentialAdmin =
              await auth.signInWithEmailAndPassword(
            email: emailAdmin,
            password: passwordAdminController.text,
          );
          Get.back(); // close dialog
          Get.back(); // back to home
          Get.snackbar("Sukses", "Pegawai berhasil di tambahkan");
        }
        isLoadingAdd.value = false;
      } on FirebaseAuthException catch (e) {
        isLoadingAdd.value = false;
        if (e.code == 'weak-password') {
          Get.snackbar(
              "Terjadi Kesalahan", "Password yang di gunakan terlalu singkat!");
        } else if (e.code == 'email-already-in-use') {
          Get.snackbar("Terjadi Kesalahan",
              "Email sudah di gunakan, kamu tidak dapat menambahkan akun menggunakan email ini");
        } else if (e.code == 'wrong-password') {
          Get.snackbar(
              "Terjadi Kesalahan", "Admin tidak dapat login, Password salah!");
        } else {
          Get.snackbar("Terjadi Kesalahan", "${e.code}");
        }
      } catch (e) {
        isLoadingAdd.value = false;
        Get.snackbar("Terjadi Kesalahan", "Tidak dapat menambahkan pegawai!");
      }
    } else {
      isLoading.value = false;
      Get.snackbar("Terjadi Kesalahan", "Password wajib di isi");
    }
  }

  Future<void> addPegawai() async {
    if (nameController.text.isNotEmpty &&
        jobController.text.isNotEmpty &&
        nipController.text.isNotEmpty &&
        emailController.text.isNotEmpty) {
      isLoading.value = true;
      Get.defaultDialog(
        title: "Validasi Admin",
        content: Column(
          children: [
            const Text("Masukan password untuk validasi admin!"),
            const SizedBox(
              height: 15,
            ),
            TextField(
              controller: passwordAdminController,
              autocorrect: false,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: "Password",
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          OutlinedButton(
            onPressed: () {
              isLoading.value = false;
              Get.back();
            },
            child: const Text("Cancel"),
          ),
          Obx(
            () => ElevatedButton(
              onPressed: () async {
                if (isLoadingAdd.isFalse) {
                  await prosesAddPegawai();
                }
                isLoading.value = false;
              },
              child: Text(
                isLoadingAdd.isFalse ? "Add Pegawai" : "Loading...",
              ),
            ),
          )
        ],
      );
    } else {
      Get.snackbar(
          "Terjadi Kesalahan", "NIP, Nama, Job, dan Email harus di isi!");
    }
  }
}
