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
import 'package:permission_handler/permission_handler.dart';
import 'dart:convert';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Workmanager().initialize(callbackDispatcher);
  final SharedPreferences _storage = await SharedPreferences.getInstance();
  // await ServiceBackground.instance.init();
  if (await Permission.location.isDenied) {
  // We haven't asked for permission yet or the permission has been denied before, but not permanently.
    Map<Permission, PermissionStatus> statuses = await [
      Permission.location,
    ].request();
    print(statuses[Permission.location]);
    }
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

Future<List?> getWifiList() async{
  List<String> wifis = [];
  final token = await getToken();
  final url = Uri.parse('http://192.168.137.1:8000/api/user-wifi-info');
  // final url = Uri.parse("https://trackips.my.id/api/user-wifi-info");
  
  final res = await http.get(url,headers: {
    'Authorization' : 'Bearer $token'
  });

    if (res.statusCode == 200) {
    //retrieve data
    var data = jsonDecode(res.body)['data'];

    for (var value in data['wifi']){
      wifis.add(value['bssid']);
    }
  }
  return wifis;
}

Future<String?> getStrongestBSSID() async {
  // List Access Point On Server
  List<String> wifiList = await getWifiList() as List<String>;

  final can = await WiFiScan.instance.canStartScan();
  print(can);
  if (can != CanStartScan.yes) {
    print("Cannot scan Wi-Fi: $can");
    return null;
  }

  await WiFiScan.instance.startScan();

  // Tunggu hasil pemindaian tersedia
  await Future.delayed(Duration(seconds: 2));

  final results = await WiFiScan.instance.getScannedResults();
  print(results);

  final filtered = results.where((item) => wifiList.contains(item.bssid)).toList();
  if (filtered == null || filtered.isEmpty) {
    return null;
  }

  // Ambil BSSID dari sinyal terkuat (RSSI terbesar)
  final strongest = filtered.reduce((a, b) => a.level > b.level ? a : b);

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

  String data = '$bssid';
  if (bssid == null) {
    data = 'null';
  }
  
  // final url = Uri.parse("https://trackips.my.id/api/user-update-location/$bssid");
  final res = await http.post(Uri.parse('http://192.168.137.1:8000/api/user-update-location/$data'),headers: {
    'Authorization' : 'Bearer $token'
  });
  
  print(res.statusCode);
}

@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    switch (task) {
      case "update_wifi_loc":
        print('background service run');
        print('bss');
        await postUpdate();
        break;
      case "updat":
        print('background service run');
        var url = Uri.parse('http://192.168.137.1:8000/api/user-update-location/ligma');
        var response = await http.get(url,headers: {
          // 'Authorization' : 'Bearer $token'
          'Authorization' : 'Bearer aMxwr0s6nH4QACaRYXtJbRWZS2vO6inMpPK0TGX6a1465bc8'
        });
        print(response.statusCode);
        print('lig');
        break;
      case "unkno":
        print('background service run');
        var url = Uri.parse('http://192.168.137.1:8000/api/user-update-location/zzzzz');
        var response = await http.get(url,headers: {
          // 'Authorization' : 'Bearer $token'
          'Authorization' : 'Bearer aMxwr0s6nH4QACaRYXtJbRWZS2vO6inMpPK0TGX6a1465bc8'
        });
        print(response.statusCode);
        print('zzz');
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
          Workmanager().registerPeriodicTask(
        "update-kol",
        "updat",
        initialDelay: Duration(minutes: 1),
        frequency: Duration(minutes : 15),
      );
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