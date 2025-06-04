import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_background_service/flutter_background_service.dart';

class ServiceBackground {
  static final ServiceBackground instance = ServiceBackground._internal();

  factory ServiceBackground() => instance;

  ServiceBackground._internal();

  Future<void> init() async {
    final service = FlutterBackgroundService();

    await service.configure(
      androidConfiguration: AndroidConfiguration(
        onStart: onStart,
        autoStart: true,
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
  if (service is AndroidServiceInstance) {
    service.setForegroundNotificationInfo(
      title: "Wi-Fi Tracker Active",
      content: "Sending strongest BSSID...",
    );
  }

  Timer.periodic(const Duration(minutes: 5), (timer) async {
    final bssid = "00:11:22:33:44:55"; // Dummy BSSID
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
