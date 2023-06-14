import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:intl/intl.dart';
import 'package:mypresence/app/routes/app_pages.dart';

class PageIndexController extends GetxController {
  RxInt pageIndex = 0.obs;

  FirebaseAuth auth = FirebaseAuth.instance;

  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<Map<String, dynamic>> determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return {
        "message": "Tidak dapat mengambil GPS dari device ini !",
        "error": true,
      };
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return {
          "message": "Hak akses menggunakan GPS ditolak !",
          "error": true,
        };
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return {
        "message":
            "Settingan hp anda tidak memperbolehkan untuk mengakses GPS, ijin kan aplikasi mengakses GPS pada settingan ponsel anda !",
        "error": true,
      };
    }

    Position position = await Geolocator.getCurrentPosition();
    return {
      "position": position,
      "message": "Berhasil mendapatkan posisi device.",
      "error": false,
    };
  }

  Future<void> updatePosition(Position position, String address) async {
    // ignore: await_only_futures
    String uid = await auth.currentUser!.uid;

    firestore.collection("pegawai").doc(uid).update({
      "position": {
        "lat": position.latitude,
        "long": position.longitude,
      },
      "address": address,
    });
  }

  Future<void> presensi(
      Position position, String address, double distance) async {
    // ignore: await_only_futures
    String uid = await auth.currentUser!.uid;

    CollectionReference<Map<String, dynamic>> collectionPresence =
        // ignore: await_only_futures
        await firestore.collection("pegawai").doc(uid).collection("presence");

    QuerySnapshot<Map<String, dynamic>> snapPresensi =
        await collectionPresence.get();

    DateTime now = DateTime.now();

    String todayDocID = DateFormat.yMd().format(now).replaceAll("/", "-");

    String status = "Di luar area";

    if (distance <= 1000) {
      // in area
      status = "Di dalam area";
    }

    // ignore: prefer_is_empty
    if (snapPresensi.docs.length == 0) {
      // never been presence
      await Get.defaultDialog(
        title: "Validasi Absensi",
        middleText:
            "Apakah kamu yakin akan mengisi daftar hadir (MASUK) sekarang ?",
        actions: [
          OutlinedButton(
            onPressed: () => Get.back(),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color.fromRGBO(4, 21, 98, 1),
            ),
            onPressed: () async {
              await collectionPresence.doc(todayDocID).set(
                {
                  "date": now.toIso8601String(),
                  "masuk": {
                    "date": now.toIso8601String(),
                    "lat": position.latitude,
                    "long": position.longitude,
                    "address": address,
                    "status": status,
                    "distance": distance,
                  }
                },
              );
              Get.back();
              Get.snackbar(
                "Sukses",
                "Kamu telah mengisi daftar hadir (MASUK)",
              );
            },
            child: const Text("Yes"),
          ),
        ],
      );
    } else {
      // presence already
      DocumentSnapshot<Map<String, dynamic>> todayDoc =
          await collectionPresence.doc(todayDocID).get();

      if (todayDoc.exists == true) {
        // presence out
        Map<String, dynamic>? dataPresenceToday = todayDoc.data();

        if (dataPresenceToday?["keluar"] != null) {
          // presence out / in already
          Get.snackbar(
            "Peringatan",
            "Kamu telah mengisi daftar hadir (MASUK) & (KELUAR), tidak dapat mengubah data kembali !",
          );
        } else {
          // presence out finished
          await Get.defaultDialog(
            title: "Validasi Absensi",
            middleText:
                "Apakah kamu yakin akan mengisi daftar hadir (KELUAR) sekarang ?",
            actions: [
              OutlinedButton(
                onPressed: () => Get.back(),
                child: const Text("Cancel"),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromRGBO(4, 21, 98, 1),
                ),
                onPressed: () async {
                  await collectionPresence.doc(todayDocID).update(
                    {
                      "keluar": {
                        "date": now.toIso8601String(),
                        "lat": position.latitude,
                        "long": position.longitude,
                        "address": address,
                        "status": status,
                        "distance": distance,
                      }
                    },
                  );
                  Get.back();
                  Get.snackbar(
                    "Sukses",
                    "Kamu telah mengisi daftar hadir keluar",
                  );
                },
                child: const Text("Yes"),
              ),
            ],
          );
        }
      } else {
        // presence in
        await Get.defaultDialog(
          title: "Validasi Absensi",
          middleText: "Apakah kamu yakin akan mengisi daftar hadir sekarang ?",
          actions: [
            OutlinedButton(
              onPressed: () => Get.back(),
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromRGBO(4, 21, 98, 1),
              ),
              onPressed: () async {
                await collectionPresence.doc(todayDocID).set(
                  {
                    "date": now.toIso8601String(),
                    "masuk": {
                      "date": now.toIso8601String(),
                      "lat": position.latitude,
                      "long": position.longitude,
                      "address": address,
                      "status": status,
                      "distance": distance,
                    }
                  },
                );
                Get.back();
                Get.snackbar(
                  "Sukses",
                  "Kamu telah mengisi daftar hadir (MASUK)",
                );
              },
              child: const Text("Yes"),
            ),
          ],
        );
      }
    }
  }

  void changePage(int i) async {
    switch (i) {
      case 1:
        Map<String, dynamic> dataResponse = await determinePosition();
        if (dataResponse["error"] != true) {
          Position position = dataResponse["position"];

          List<Placemark> placemarks = await placemarkFromCoordinates(
              position.latitude, position.longitude);

          String address =
              "${placemarks[0].street}, ${placemarks[0].subLocality}, ${placemarks[0].locality}";

          await updatePosition(position, address);

          // check distance between 2 position
          double distance = Geolocator.distanceBetween(
              -6.2603274, 107.0028569, position.latitude, position.longitude);

          await presensi(position, address, distance);
        } else {
          Get.snackbar("Terjadi Kesalahan", dataResponse["message"]);
        }

        break;
      case 2:
        pageIndex.value = i;

        Get.offAllNamed(Routes.PROFILE);
        break;
      default:
        pageIndex.value = i;

        Get.offAllNamed(Routes.HOME);
    }
  }
}
