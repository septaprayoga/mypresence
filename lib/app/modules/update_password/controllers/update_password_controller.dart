import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

class UpdatePasswordController extends GetxController {
  RxBool isLoading = false.obs;

  TextEditingController currentController = TextEditingController();
  TextEditingController newController = TextEditingController();
  TextEditingController confirmController = TextEditingController();

  FirebaseAuth auth = FirebaseAuth.instance;

  void updatePassword() async {
    if (currentController.text.isNotEmpty &&
        newController.text.isNotEmpty &&
        confirmController.text.isNotEmpty) {
      if (newController.text == confirmController.text) {
        isLoading.value = true;
        try {
          String emailUser = auth.currentUser!.email!;

          await auth.signInWithEmailAndPassword(
            email: emailUser,
            password: currentController.text,
          );

          await auth.currentUser!.updatePassword(newController.text);

          Get.back();

          Get.snackbar("Sukses", "Password berhasil di update.");
        } on FirebaseException catch (e) {
          if (e.code == "wrong-password") {
            Get.snackbar(
              "Terjadi Kesalahan",
              "Password yang anda masukan tidak valid!",
            );
          } else {
            Get.snackbar(
              "Terjadi Kesalahan",
              // ignore: unnecessary_string_interpolations
              "${e.code.toLowerCase()}",
            );
          }
        } catch (e) {
          Get.snackbar("Terjadi Kesalahan", "Tidak dapat update password!");
        } finally {
          isLoading.value = false;
        }
      } else {
        Get.snackbar("Terjadi Kesalahan", "Confirm password tidak valid!");
      }
    } else {
      Get.snackbar("Terjadi Kesalahan", "Semua input wajib di isi!");
    }
  }
}
