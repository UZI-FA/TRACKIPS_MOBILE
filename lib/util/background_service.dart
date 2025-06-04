import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_background_service/flutter_background_service.dart';

import 'package:wifi_scan/wifi_scan.dart';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ServiceBackground {
  static final ServiceBackground instance = ServiceBackground._internal();

  factory ServiceBackground() => instance;

  ServiceBackground._internal();

  Future<void> init() async {
    final service = FlutterBackgroundService();

    await service.configure(
      androidConfiguration: AndroidConfiguration(
        onStart: onStart,
        autoStart: false,
        isForegroundMode: true,
        initialNotificationTitle: 'Wi-Fi Tracker',
        initialNotificationContent: 'Tracking BSSID in background',
        // notificationChannelId: 'wifi_service_channel',
      ),
      iosConfiguration: IosConfiguration(),
    );

    await service.startService();
  }

  Future<void> stop() async {
    final service = FlutterBackgroundService();
    service.invoke("stopService");
  }
}

@pragma('vm:entry-point')
void onStart(ServiceInstance service) {
  DartPluginRegistrant.ensureInitialized();
  // if (service is AndroidServiceInstance) {
  //   service.setForegroundNotificationInfo(
  //     title: "Wi-Fi Tracker Active",
  //     content: "Sending strongest BSSID...",
  //   );
  // }

  Timer.periodic(const Duration(minutes: 1), (timer) async {
    final storage = FlutterSecureStorage();
    final token = await storage.read(key: 'access_token');

    final bssid = await getStrongestBSSID();
    if (bssid == null) return;
    
    final url = Uri.parse("https://trackips.my.id/api/user-update-location/$bssid");
    try {
      final res = await http.get(url,headers: {
        'Authorization' : 'Bearer $token'
      });
      debugPrint("Sent BSSID: $bssid | Status: ${res.statusCode}");
    } catch (e) {
      debugPrint("Error sending BSSID: $e");
    }
    // final bssid = "00:11:22:33:44:55"; // Dummy BSSID
    // final url = Uri.parse("https://trackips.my.id/api/user-update-location/$bssid"); // Ganti sesuai kebutuhan

    // try {
    //   final res = await http.get(url);
    //   debugPrint("BSSID sent: ${res.statusCode}");
    // } catch (e) {
    //   debugPrint("Error: $e");
    // }
  });

  service.on("stopService").listen((event) {
    service.stopSelf();
  });
}


Future<String?> getStrongestBSSID() async {


  final can = await WiFiScan.instance.canStartScan();
  if (can != CanStartScan.yes) {
    print("Cannot scan Wi-Fi: $can");
    return null;
  }

  await WiFiScan.instance.startScan();

  // Tunggu hasil pemindaian tersedia
  await Future.delayed(Duration(seconds: 2));

  final results = await WiFiScan.instance.getScannedResults();

  if (results == null || results.isEmpty) {
    return null;
  }

  // Ambil BSSID dari sinyal terkuat (RSSI terbesar)
  final strongest = results.reduce((a, b) => a.level > b.level ? a : b);

  print("Strongest BSSID: ${strongest.bssid}, RSSI: ${strongest.level}");
  return strongest.bssid;
}
