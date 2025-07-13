import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:image_picker/image_picker.dart';
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
      headers: {'Accept': 'application/json', 'Authorization': 'Bearer $token'},
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

  Future<void> tambahKategori({
    required String nama,
    String? deskripsi,
    required int urutan,
    XFile? gambar,
  }) async {
    final token = await _storage.read(key: 'auth_token');
    var request = http.MultipartRequest(
      'POST',
      Uri.parse('$_baseUrl/kategori'),
    );

    request.headers['Authorization'] = 'Bearer $token';
    request.headers['Accept'] = 'application/json';

    request.fields['nama'] = nama;
    if (deskripsi != null) request.fields['deskripsi'] = deskripsi;
    request.fields['urutan'] = urutan.toString();

    if (gambar != null) {
      request.files.add(
        await http.MultipartFile.fromPath('gambar', gambar.path),
      );
    }

    final response = await request.send();
    if (response.statusCode != 201) {
      final responseBody = await response.stream.bytesToString();
      throw Exception('Gagal menambah kategori: $responseBody');
    }
  }

  Future<void> updateKategori({
    required int kategoriId,
    required String nama,
    String? deskripsi,
    required int urutan,
    XFile? gambar,
  }) async {
    final token = await _storage.read(key: 'auth_token');
    var request = http.MultipartRequest(
      'POST',
      Uri.parse('$_baseUrl/kategori/$kategoriId'),
    );

    request.headers['Authorization'] = 'Bearer $token';
    request.headers['Accept'] = 'application/json';
    request.fields['_method'] = 'PUT'; 

    request.fields['nama'] = nama;
    if (deskripsi != null) request.fields['deskripsi'] = deskripsi;
    request.fields['urutan'] = urutan.toString();

    if (gambar != null) {
      request.files.add(
        await http.MultipartFile.fromPath('gambar', gambar.path),
      );
    }

    final response = await request.send();
    if (response.statusCode != 200) {
      final responseBody = await response.stream.bytesToString();
      throw Exception('Gagal memperbarui kategori: $responseBody');
    }
  }

  Future<void> deleteKategori(int kategoriId) async {
    final token = await _storage.read(key: 'auth_token');
    final response = await http.delete(
      Uri.parse('$_baseUrl/kategori/$kategoriId'),
      headers: {'Accept': 'application/json', 'Authorization': 'Bearer $token'},
    );
    if (response.statusCode != 200) {
      throw Exception('Gagal menghapus kategori.');
    }
  }
}
