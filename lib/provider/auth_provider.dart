import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:convert';

class AuthProvider extends ChangeNotifier {
  final String _baseUrl = 'http://localhost:8000/api/user';
  FlutterSecureStorage _storage = FlutterSecureStorage();
  String? _token;
  String? _refreshToken;

  bool get isAuthenticated => _token != null;

  Future<bool> tryAutoLogin() async{
    final token = await getToken();
    if(_token != null){
      var url = Uri.http('$_baseUrl');
      var response = await http.get(url,headers: {
        'Authorization' : 'Bearer $token'
      },);
      if (response.statusCode == 200){
        _token = token;
        return true;
      }
      
      url = Uri.http('$_baseUrl/refresh-token');
      response = await http.get(url,headers: {
        'Authorization' : 'Bearer $_refreshToken'
      },);
      if (response.statusCode == 200){
        final responseData = jsonDecode(response.body);
        _token = responseData['access_token'];
        
        await _storeTokens(responseData);

        return true;
      }
    }
    await _deleteTokens();
    _token = null;
    return false;
  }
  

  Future<bool> login(String email, String password) async {
    await Future.delayed(const Duration(seconds: 2));
    var url = Uri.http('$_baseUrl/login');
    var response = await http.post(url,body: {
      'email' : email,
      'password' : password
    });

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      _token = responseData['access_token'];
      _refreshToken = responseData['refresh_token'];

      await _storeTokens(responseData);

      notifyListeners();
      return true;
    }
    return false;
  }

  Future<bool> register(String name,String email, String password) async {
    await Future.delayed(const Duration(seconds: 2));
    var url = Uri.http('$_baseUrl/register');
    var response = await http.post(url,body: {
      'name' : name,
      'email' : email,
      'password' : password,
      'confirm_password' : password
    });

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      _token = responseData['access_token'];
      _refreshToken = responseData['refresh_token'];
      await _storeTokens(responseData);

      notifyListeners();
      return true;
    }
    notifyListeners();
    return false;
  }

  Future<bool> logout() async {
    _token = null;
    await _storage.delete(key: _token!);
    await _storage.delete(key: _refreshToken!);

    await _deleteTokens();

    notifyListeners();
    return true;
  }

  Future<void> _storeTokens(Map<String, dynamic> response) async {
    await _storage.write(
      key: _token!,
      value: response['access_token'],
    );
    
    if (response.containsKey('refresh_token')) {
      await _storage.write(
        key: _refreshToken!,
        value: response['refresh_token'],
      );
    }
  }

  Future<void> _deleteTokens() async {
    await _storage.delete(key: _token!);
    await _storage.delete(key: _refreshToken!);
  }

  Future<String?> getToken() async {
    return await _storage.read(key: _token!);
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