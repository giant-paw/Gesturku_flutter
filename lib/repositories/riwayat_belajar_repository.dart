import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class RiwayatBelajarRepository {
  final _baseUrl = 'http://10.0.2.2:8000/api'; 
  final _storage = const FlutterSecureStorage();

  Future<void> simpanProgres(int materiId) async {
    final token = await _storage.read(key: 'auth_token');

    // final response = await http.post(
    //   Uri.parse('$_baseUrl/riwayat-belajar'),
    //   headers: {
    //     'Accept': 'application/json',
    //     'Authorization': 'Bearer $token',
    //   },
    //   body: {
    //     'materi_id': materiId.toString(),
    //   },
    // );

    // if (response.statusCode != 201 && response.statusCode != 200) {
    //   throw Exception('Gagal menyimpan progres ke server.');
    // }

    if (token == null) {
      throw Exception('Token otentikasi tidak ditemukan.');
    }

    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/riwayat-belajar'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: {
          'materi_id': materiId.toString(),
        },
      ).timeout(const Duration(seconds: 15)); 

      if (response.statusCode != 201 && response.statusCode != 200) {
        final errorData = json.decode(response.body);
        final errorMessage = errorData['message'] ?? 'Terjadi error tidak diketahui dari server.';
        throw Exception('Gagal menyimpan progres: $errorMessage');
      }
      print('Progres berhasil disimpan ke server.');

    } on TimeoutException catch (_) {
        throw Exception('Koneksi ke server timeout. Gagal menyimpan progres.');
    } catch (e) {
        // Untuk error lainnya (misal tidak ada koneksi)
        throw Exception('Terjadi kesalahan jaringan: ${e.toString()}');
    }

  }
}