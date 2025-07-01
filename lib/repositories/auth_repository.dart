import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../models/pengguna.dart';

class AuthRepository {
  final _baseUrl = 'http://127.0.0.1:8000/api';
  final _storage = const FlutterSecureStorage();

  Future<Map<String, dynamic>> login(String email, String password) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/login'),
      headers: {'Accept': 'application/json'},
      body: {
        'email': email,
        'kata_sandi': password,
      },
    );

    if(response.statusCode == 200) {
      final data = json.decode(response.body);

      //simpan token
      await _storage.write(key: 'auth_token', value: data['access_token']);

      return {
        'token': data['access_token'],
        'user': Pengguna.fromJson(data['user']),
      };
    } else {
      throw Exception('Gagal melakukan login. Cek email dan password');
    }
  }

  Future<void> logout() async {
    final token = await _storage.read(key: 'auth_token');
    await http.post(
      Uri.parse('$_baseUrl/logout'),
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    // Hapus token dari storage
    await _storage.delete(key: 'auth_token');
  }

  Future<String?> getToken() async {
    return await _storage.read(key: 'auth_token');
  }

  Future<bool> hasToken() async {
    var token = await _storage.read(key: 'auth_token');
    return token != null;
  }
}