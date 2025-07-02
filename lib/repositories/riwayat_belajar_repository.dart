import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class RiwayatBelajarRepository {
  final _baseUrl = 'http://10.0.2.2:8000/api'; 
  final _storage = const FlutterSecureStorage();

  Future<void> simpanProgres(int materiId) async {
    final token = await _storage.read(key: 'auth_token');

    final response = await http.post(
      Uri.parse('$_baseUrl/riwayat-belajar'),
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: {
        'materi_id': materiId.toString(),
      },
    );

    if (response.statusCode != 201 && response.statusCode != 200) {
      throw Exception('Gagal menyimpan progres ke server.');
    }
  }
}