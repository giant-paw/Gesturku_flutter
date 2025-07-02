import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:image_picker/image_picker.dart';
import '../models/pengguna.dart';

class AuthRepository {
  final _baseUrl = 'http://10.0.2.2:8000/api';
  final _storage = const FlutterSecureStorage();

  Future<Map<String, dynamic>> login(String email, String password) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/login'),
      headers: {'Accept': 'application/json'},
      body: {'email': email, 'kata_sandi': password},
    );

    if (response.statusCode == 200) {
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

  Future<Map<String, dynamic>> register({
    required String nama,
    required String email,
    required String password,
    required String passwordConfirmation,
    XFile? fotoProfil,
  }) async {
    var request = http.MultipartRequest(
      'POST',
      Uri.parse('$_baseUrl/register'),
    );

    request.fields['nama'] = nama;
    request.fields['email'] = email;
    request.fields['kata_sandi'] = password;
    request.fields['kata_sandi_confirmation'] = passwordConfirmation;

    if (fotoProfil != null) {
      request.files.add(
        await http.MultipartFile.fromPath('foto_profil', fotoProfil.path),
      );
    }

    final streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);

    if (response.statusCode == 201) {
      final data = json.decode(response.body);
      await _storage.write(key: 'auth_token', value: data['access_token']);
      return {
        'token': data['access_token'],
        'user': Pengguna.fromJson(data['user']),
      };
    } else {
      final errorData = json.decode(response.body);
      throw Exception('Gagal Registrasi: ${errorData.toString()}');
    }
  }

  Future<void> logout() async {
    final token = await _storage.read(key: 'auth_token');
    await http.post(
      Uri.parse('$_baseUrl/logout'),
      headers: {'Accept': 'application/json', 'Authorization': 'Bearer $token'},
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
