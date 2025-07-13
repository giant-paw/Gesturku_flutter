import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:image_picker/image_picker.dart';
import '../models/materi.dart';

class MateriRepository {
  final _baseUrl = 'http://10.0.2.2:8000/api';
  final _storage = const FlutterSecureStorage();

  Future<List<Materi>> fetchMateriByKategori(int kategoriId) async {
    final token = await _storage.read(key: 'auth_token');

    final response = await http.get(
      Uri.parse('$_baseUrl/kategori/$kategoriId/materi'),
      headers: {'Accept': 'application/json', 'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => Materi.fromJson(json)).toList();
    } else {
      throw Exception('Gagal memuat daftar materi.');
    }
  }

  Future<List<Materi>> fetchAllMateriForAdmin() async {
    final token = await _storage.read(key: 'auth_token');
    if (token == null) throw Exception('Token tidak ditemukan');

    final response = await http.get(
      Uri.parse('$_baseUrl/admin/materi'),
      headers: {'Accept': 'application/json', 'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => Materi.fromJson(json)).toList();
    } else {
      throw Exception('Gagal memuat semua materi untuk admin.');
    }
  }

  Future<void> tambahMateriBaru({
    required String nama,
    required int kategoriId,
    required String deskripsi,
    required int urutan,
    required XFile file,
  }) async {
    final token = await _storage.read(key: 'auth_token');
    var request = http.MultipartRequest('POST', Uri.parse('$_baseUrl/materi'));

    request.headers['Authorization'] = 'Bearer $token';
    request.headers['Accept'] = 'application/json';

    request.fields['nama'] = nama;
    request.fields['kategori_id'] = kategoriId.toString();
    request.fields['deskripsi'] = deskripsi;
    request.fields['urutan'] = urutan.toString();
    request.files.add(await http.MultipartFile.fromPath('file', file.path));

    final response = await request.send();

    if (response.statusCode != 201) {
      // Coba baca respons error jika ada
      final responseBody = await response.stream.bytesToString();
      throw Exception('Gagal menambah materi baru: $responseBody');
    }
  }

  Future<void> deleteMateri(int materiId) async {
    final token = await _storage.read(key: 'auth_token');
    final response = await http.delete(
      Uri.parse('$_baseUrl/materi/$materiId'), // Panggil endpoint DELETE
      headers: {'Accept': 'application/json', 'Authorization': 'Bearer $token'},
    );

    if (response.statusCode != 200) {
      // Status sukses untuk delete biasanya 200 atau 204
      throw Exception('Gagal menghapus materi.');
    }
  }
}
