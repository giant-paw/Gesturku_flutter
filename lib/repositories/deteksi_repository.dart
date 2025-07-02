import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

class DeteksiRepository {
  final _flaskBaseUrl = 'http://10.0.2.2:5000'; 

  Future<Map<String, dynamic>> cekGambar(XFile imageFile) async {
    var request = http.MultipartRequest(
      'POST',
      Uri.parse('$_flaskBaseUrl/detect'),
    );

    request.files.add(
      await http.MultipartFile.fromPath('image', imageFile.path),
    );

    final streamedResponse = await request.send();

    final response = await http.Response.fromStream(streamedResponse);

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Gagal melakukan deteksi ke server Flask. Status: ${response.statusCode}');
    }
  }
}