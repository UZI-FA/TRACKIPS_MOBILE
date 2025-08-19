// main.dart
import 'package:flutter/material.dart';

// 54e
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'provider/auth_provider.dart';
import 'util/background_service.dart';
import 'routing.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/foundation.dart';
import 'package:workmanager/workmanager.dart';
import 'package:http/http.dart' as http;
import 'package:wifi_scan/wifi_scan.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Workmanager().initialize(callbackDispatcher);
  final SharedPreferences _storage = await SharedPreferences.getInstance();
  // await ServiceBackground.instance.init();
  runApp(
    ChangeNotifierProvider(
      create: (guard) => AuthProvider(
        token: _storage.getString('access_token'),
        refresh_token: _storage.getString('refresh_token')
      ),
      child: const IndoorNavigationApp(),
    ),
  );
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

Future<String> getToken() async{
   final SharedPreferences _storage = await SharedPreferences.getInstance();
   return await _storage.getString('access_token') ?? '';
}

postUpdate() async{
  final token = await getToken();

  final bssid = await getStrongestBSSID();
  if (bssid == null) return;
  
  final url = Uri.parse("http://192.168.1.6:8000/api/user-update-location/$bssid");
  // final url = Uri.parse("https://trackips.my.id/api/user-update-location/$bssid");
  try {
    final res = await http.post(url,headers: {
      'Authorization' : 'Bearer $token'
  });
    debugPrint("Sent BSSID: $bssid | Status: ${res.statusCode}");
  } catch (e) {
    debugPrint("Error sending BSSID: $e");
  }
}
@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    switch (task) {
      case "update_wifi_loc":
        await postUpdate();
        break;
      default:
        // Handle unknown task types
        break;
    }
    
    return Future.value(true);
  });
}

class IndoorNavigationApp extends StatelessWidget {
  const IndoorNavigationApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    final GoRouter router = Routing(authProvider);

    return MaterialApp.router(
      // title: 'Flutter Map App with go_router',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      routerConfig: router,
      debugShowCheckedModeBanner: false,
    );
  }
}