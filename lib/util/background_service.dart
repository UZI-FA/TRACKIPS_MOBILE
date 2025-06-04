import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_background_service_android/flutter_background_service_android.dart';
import 'package:wifi_scan/wifi_scan.dart';
import 'package:http/http.dart' as http;

Future<void> initializeService() async {
  final service = FlutterBackgroundService();

  await service.configure(
    androidConfiguration: AndroidConfiguration(
      onStart: onStart,
      autoStart: false, // jangan auto start, kita jalankan manual setelah login
      isForegroundMode: true,
      notificationChannelId: 'wifi_channel',
      initialNotificationTitle: 'WiFi Tracker Active',
      initialNotificationContent: 'Scanning for strongest BSSID...',
    ),
    iosConfiguration: IosConfiguration(),
  );

  await service.startService();
}

void onStart(ServiceInstance service) async {
  // Jika berjalan di Android, tampilkan notifikasi foreground
  WidgetsFlutterBinding.ensureInitialized();
  if (service is AndroidServiceInstance) {
    service.setAsForegroundService();
  }

  // Handler untuk menghentikan service dari luar (dari logout misalnya)
  service.on("stopService").listen((event) {
    service.stopSelf();
  });

  // Timer untuk scanning BSSID setiap 5 menit
  Timer.periodic(const Duration(minutes: 5), (timer) async {

    final bssid = '23:DE:7C:AA:35';
    // final bssid = await getStrongestBSSID();
    if (bssid != null) {
      final url = Uri.parse("https://trackips.my.id/api/user-update-location/$bssid"); // ganti dengan IP server kamu
      try {
        final res = await http.get(url);
        print("Sent BSSID: $bssid, status: ${res.statusCode}");
      } catch (e) {
        print("Error sending BSSID: $e");
      }
    } else {
      print("No BSSID found.");
    }
  });
}

Future<String?> getStrongestBSSID() async {
  final can = await WiFiScan.instance.canGetScannedResults();
  if (can != CanGetScannedResults.yes) {
    print("Cannot get WiFi scan results.");
    return null;
  }

  await WiFiScan.instance.startScan();
  final results = await WiFiScan.instance.getScannedResults();
  if (results.isEmpty) {
    print("No WiFi networks found.");
    return null;
  }

  // Ambil BSSID dengan sinyal terkuat
  results.sort((a, b) => b.level!.compareTo(a.level!));
  return results.first.bssid;
}
