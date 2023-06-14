// ignore_for_file: unnecessary_overrides

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mypresence/app/routes/app_pages.dart';

class LoginController extends GetxController {
  RxBool isLoading = false.obs;

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  FirebaseAuth auth = FirebaseAuth.instance;

  Future<void> login() async {
    if (emailController.text.isNotEmpty && passwordController.text.isNotEmpty) {
      isLoading.value = true;
      try {
        // ignore: unused_local_variable
        UserCredential userCredential =
            await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailController.text,
          password: passwordController.text,
        );

        if (userCredential.user != null) {
          if (userCredential.user!.emailVerified == true) {
            isLoading.value = false;
            if (passwordController.text == "password") {
              Get.offAllNamed(Routes.NEW_PASSWORD);
            } else {
              Get.snackbar(
                "Sukses",
                "anda berhasil login",
                colorText: Colors.white,
              );
              Get.offAllNamed(Routes.HOME);
            }
          } else {
            Get.defaultDialog(
              title: "Belum Terverifikasi",
              middleText:
                  "Kamu belum verifikasi akun ini, verifikasi akun melalu pesan email yang sudah kami kirim!",
              actions: [
                OutlinedButton(
                  onPressed: () {
                    isLoading.value = false;
                    Get.back();
                  }, // for closed dialogue
                  child: const Text("Cancel"),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromRGBO(6, 74, 203, 1),
                  ),
                  onPressed: () async {
                    try {
                      await userCredential.user!.sendEmailVerification();
                      Get.back();
                      Get.snackbar(
                        "Sukses",
                        "Link verifikasi akun sudah dikirim, silahkan cek email ${emailController.text} dan lakukan verifikasi akun.",
                        colorText: Colors.white,
                      );
                      isLoading.value = false;
                    } catch (e) {
                      isLoading.value = false;
                      Get.snackbar(
                        "Terjadi Kegagalan",
                        "Tidak dapat mengirim email verifikasi, Silahkan hubungi admin atau CS kami.",
                        colorText: Colors.white,
                      );
                    }
                  }, // send verification
                  child: const Text("Kirim Ulang"),
                ),
              ],
            );
          }
        }
        isLoading.value = false;
      } on FirebaseAuthException catch (e) {
        isLoading.value = false;
        if (e.code == 'user-not-found') {
          Get.snackbar(
            "Terjadi Kesalahan",
            "Email tidak terdaftar!",
            colorText: Colors.white,
          );
        } else if (e.code == 'wrong-password') {
          Get.snackbar(
            "Terjadi Kesalahan",
            "Password tidak terdaftar!",
            colorText: Colors.white,
          );
        }
      } catch (e) {
        isLoading.value = false;
        Get.snackbar(
          "Terjadi Kesalahan",
          "Tidak dapat login",
          colorText: Colors.white,
        );
      }
    } else {
      Get.snackbar(
        "Terjadi Kesalahan",
        "Email dan Password wajib di isi!",
        colorText: Colors.white,
      );
    }
  }
}
