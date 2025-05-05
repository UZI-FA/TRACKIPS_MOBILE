import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AuthProvider extends ChangeNotifier {
  String? _token;
  String? get token => _token;

  bool get isAuthenticated => _token != null;

  Future<bool> login(String email, String password) async {
    await Future.delayed(const Duration(seconds: 2));
    if (email == 'test@example.com' && password == 'password') {
      _token = 'dummy_token';
      notifyListeners();
      return true;
    }
    return false;
  }

  Future<bool> register(String email, String password) async {
    await Future.delayed(const Duration(seconds: 2));
    _token = 'dummy_token';
    notifyListeners();
    return true;
  }

  void logout() {
    _token = null;
    notifyListeners();
  }
}