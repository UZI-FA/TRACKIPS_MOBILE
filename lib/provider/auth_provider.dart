import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:workmanager/workmanager.dart';

import '../util/background_service.dart';
class AuthProvider extends ChangeNotifier {
  // local mobile
  // final String _baseUrl = 'http://192.168.137.1:8000/api/user';
  // local web
  final String _baseUrl = 'http://192.168.1.6:8000/api/user';
  // production
  // final String _baseUrl = 'https://trackips.my.id/api/user';
  String? token;
  String? refresh_token;

  AuthProvider({ required this.token, required this.refresh_token});
  bool get isAuthenticated => token != null;

  Future<bool> tryAutoLogin() async{
    if(token != null){
      var url = Uri.parse('$_baseUrl');
      var response = await http.get(url,headers: {
        'Authorization' : 'Bearer $token'
      },);
      if (response.statusCode == 200){
        token = token;
        return true;
      }
      
      url = Uri.parse('$_baseUrl/refresh-token');
      response = await http.get(url,headers: {
        'Authorization' : 'Bearer $refresh_token'
      },);
      if (response.statusCode == 200){
        final responseData = jsonDecode(response.body);
        token = responseData['data']['access_token'];
        
        await _storeTokens(responseData);

        return true;
      }
    }
    await _deleteTokens();
    token = null;
    return false;
  }
  

  Future<bool> login(String email, String password) async {
    await Future.delayed(const Duration(seconds: 2));
    var url = Uri.parse('$_baseUrl/login');
    var response = await http.post(url,body: {
      'email' : email,
      'password' : password
    });
    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      token = responseData['data']['access_token'];
      refresh_token = responseData['data']['refresh_token'];

      await _storeTokens(responseData);

      // Mulai background service
      Workmanager().registerPeriodicTask(
        "update-loc",
        "update_wifi_loc",
        initialDelay: Duration(minutes: 5),
        frequency: Duration(minutes : 15),
      );

      Workmanager().registerPeriodicTask(
        "jjjjjjj",
        "unkno",
        initialDelay: Duration(minutes: 5),
        frequency: Duration(minutes : 15),
      );
      notifyListeners();
      return true;
    }
    return false;
  }

  Future<bool> register(String name,String email, String password) async {
    await Future.delayed(const Duration(seconds: 2));
    var url = Uri.parse('$_baseUrl/register');
    var response = await http.post(url,body: {
      'name' : name,
      'email' : email,
      'password' : password,
      'password_confirmation' : password
    });
    print(response);
    print(response.statusCode);
    print(jsonDecode(response.body));

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      token = responseData['data']['access_token'];
      refresh_token = responseData['data']['refresh_token'];
      await _storeTokens(responseData);

      // Mulai background service
      Workmanager().registerOneOffTask(
        "update-loc",
        "update_wifi_loc",
        initialDelay: Duration(seconds: 10),
      );
      
      Workmanager().registerPeriodicTask(
        "update-loc",
        "update_wifi_loc",
        initialDelay: Duration(minutes: 1),
        frequency: Duration(minutes : 15),
      );

      Workmanager().registerPeriodicTask(
        "jjjjjjj",
        "unkno",
        initialDelay: Duration(minutes: 5),
        frequency: Duration(minutes : 15),
      );
      notifyListeners();
      return true;
    }
    notifyListeners();
    return false;
  }

  Future<bool> logout() async {
    final SharedPreferences _storage = await SharedPreferences.getInstance();
    token = null;
    await _storage.remove('access_token');
    await _storage.remove('refresh_token');

    await _deleteTokens();

    // Hentikan background service
    Workmanager().cancelAll();

    notifyListeners();
    return true;
  }

  Future<void> _storeTokens(Map<String, dynamic> response) async {
    final SharedPreferences _storage = await SharedPreferences.getInstance();
    await _storage.setString('access_token',response['data']['access_token']);
    
    if (response['data'].containsKey('refresh_token')) {
      await _storage.setString('refresh_token',response['data']['refresh_token']);
    }
  }

  Future<void> _deleteTokens() async {
    final SharedPreferences _storage = await SharedPreferences.getInstance();
    await _storage.remove('access_token');
    await _storage.remove('refresh_token');
  }

  void _handleResponse(http.Response response) {
    switch (response.statusCode) {
      case 401:
        throw const AuthException('Unauthorized');
      case 403:
        throw const AuthException('Forbidden');
      case 404:
        throw const AuthException('Not Found');
      case 500:
        throw const AuthException('Server Error');
      default:
        if (response.statusCode < 200 || response.statusCode >= 300) {
          throw const AuthException('Unknown Error');
        }
    }
  }
}
class AuthException implements Exception {
  final String message;
  const AuthException(this.message);

  @override
  String toString() => 'AuthException: $message';
}