import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../models/kategori.dart';

class KategoriRepository {
  final _baseUrl = 'http://10.0.2.2:8000/api';
  final _storage = const FlutterSecureStorage();

  Future<List<Kategori>> fetchKategori() async {

    final token = await _storage.read(key: 'auth_token');

    if (token == null) {
      throw Exception('Token tidak ditemukan, harap login kembali.');
    }

    final response = await http.get(
      Uri.parse('$_baseUrl/kategori'),
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      // Jika sukses, ubah JSON array menjadi List<Kategori>
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => Kategori.fromJson(json)).toList();
    } else {
      // Jika gagal, lemparkan error
      throw Exception('Gagal memuat data kategori dari server.');
    }
  }
}