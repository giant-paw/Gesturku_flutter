import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../models/peringkat.dart';

class LeaderboardRepository {
  final _baseUrl = 'http://10.0.2.2:8000/api'; 
  final _storage = const FlutterSecureStorage();

  Future<List<Peringkat>> fetchLeaderboard() async {
    final token = await _storage.read(key: 'auth_token');

    if (token == null) {
      throw Exception('Token otentikasi tidak ditemukan.');
    }

    final response = await http.get(
      Uri.parse('$_baseUrl/leaderboard'),
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => Peringkat.fromJson(json)).toList();
    } else {
      throw Exception('Gagal memuat data leaderboard.');
    }
  }
}