// ignore_for_file: unnecessary_overrides

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mypresence/app/routes/app_pages.dart';

class NewPasswordController extends GetxController {
  TextEditingController newPasswordController = TextEditingController();
  FirebaseAuth auth = FirebaseAuth.instance;

  void newPassword() async {
    if (newPasswordController.text.isNotEmpty) {
      if (newPasswordController.text != "password") {
        try {
          String email = auth.currentUser!.email!;

          await auth.currentUser!.updatePassword(newPasswordController.text);

          await auth.signOut();

          await auth.signInWithEmailAndPassword(
            email: email,
            password: newPasswordController.text,
          );
          Get.snackbar(
            "Sukses",
            "Password berhasil di ubah, selamat datang di home page My Presence",
            colorText: Colors.white,
          );
          Get.offAllNamed(Routes.HOME);
        } on FirebaseAuthException catch (e) {
          if (e.code == 'weak-password') {
            Get.snackbar(
              "Terjadi Kesalahan",
              "Password yang di gunakan harus lebih dari 6 karakter",
              colorText: Colors.white,
            );
          }
        } catch (e) {
          Get.snackbar(
            "Terjadi Kesalahan",
            "Tidak dapat membuat password baru, silahkan hubungi admin atau CS kami!",
            colorText: Colors.white,
          );
        }
      } else {
        Get.snackbar(
          "Terjadi Kesalahan",
          "Password baru harus di ubah, tidak boleh 'password' kembali!",
          colorText: Colors.white,
        );
      }
    } else {
      Get.snackbar(
        "Terjadi Kesalahan",
        "Password baru wajib di isi!",
        colorText: Colors.white,
      );
    }
  }
}
