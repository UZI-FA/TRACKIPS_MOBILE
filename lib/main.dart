// main.dart
import 'package:flutter/material.dart';

// 54e
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'provider/auth_provider.dart';
import 'util/background_service.dart';
import 'routing.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // await ServiceBackground.instance.init();
  runApp(
    ChangeNotifierProvider(
      create: (guard) => AuthProvider(),
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