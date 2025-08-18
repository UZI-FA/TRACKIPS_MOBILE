// main.dart
import 'package:flutter/material.dart';

// 54e
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'provider/auth_provider.dart';
import 'util/background_service.dart';
import 'routing.dart';
import 'package:shared_preferences/shared_preferences.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final SharedPreferences _storage = await SharedPreferences.getInstance();
  // await ServiceBackground.instance.init();
  runApp(
    ChangeNotifierProvider(
      create: (guard) => AuthProvider(
        token: _storage.getString('accesstoken'),
        refreshToken: _storage.getString('refreshtoken')
      ),
      child: const IndoorNavigationApp(),
    ),
  );
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