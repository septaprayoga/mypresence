import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../controllers/detail_presensi_controller.dart';

class DetailPresensiView extends GetView<DetailPresensiController> {
  final Map<String, dynamic> data = Get.arguments;
  DetailPresensiView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Detail Presensi Page"),
        titleSpacing: 00.0,
        centerTitle: true,
        toolbarHeight: 55,
        toolbarOpacity: 0.8,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomRight: Radius.circular(14),
            bottomLeft: Radius.circular(14),
          ),
        ),
        elevation: 0.00,
        backgroundColor: const Color.fromRGBO(17, 70, 143, 1),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            // ignore: sort_child_properties_last
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Text(
                    // ignore: unnecessary_string_interpolations
                    "${DateFormat.yMMMMEEEEd().format(DateTime.parse(data['date']))}",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 17,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                const Text(
                  "Masuk",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
                ),
                Text(
                  data['masuk']?['date'] == null
                      ? "Jam -"
                      : "Jam : ${DateFormat.jms().format(DateTime.parse(data['masuk']!['date']))}",
                ),
                Text(data['masuk']?['lat'] == null &&
                        data['masuk']?['long'] == null
                    ? "Posisi -"
                    : "Posisi : ${data['masuk']!['lat']}, ${data['masuk']!['long']}"),
                Text(
                  data['masuk']?['status'] == null
                      ? "Status -"
                      : "Status : ${data['masuk']!['status']}",
                ),
                Text(
                  data['masuk']?['distance'] == null
                      ? "Distance -"
                      : "Distance : +- ${data['masuk']!['distance'].toString().split(".").first} meter",
                ),
                Text(
                  data['masuk']?['address'] == null
                      ? "Address -"
                      : "Address : ${data['masuk']!['address']}",
                ),
                const SizedBox(
                  height: 20,
                ),
                const Text(
                  "Keluar",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
                ),
                Text(
                  data['keluar']?['date'] == null
                      ? "Jam -"
                      : "Jam : ${DateFormat.jms().format(DateTime.parse(data['keluar']!['date']))}",
                ),
                Text(data['keluar']?['lat'] == null &&
                        data['keluar']?['long'] == null
                    ? "Posisi -"
                    : "Posisi : ${data['keluar']!['lat']}, ${data['keluar']!['long']}"),
                Text(
                  data['keluar']?['status'] == null
                      ? "Status -"
                      : "Status : ${data['keluar']!['status']}",
                ),
                Text(
                  data['keluar']?['distance'] == null
                      ? "Distance -"
                      : "Distance : +- ${data['keluar']!['distance'].toString().split(".").first} meter",
                ),
                Text(
                  data['keluar']?['address'] == null
                      ? "Address -"
                      : "Address : ${data['keluar']!['address']}",
                ),
              ],
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Colors.grey.shade200,
            ),
          ),
        ],
      ),
    );
  }
}
