import 'dart:convert';
import 'package:apk_poli/model/jadwal.dart';
import 'package:http/http.dart' as http;

class JadwalService {
  final String baseUrl = "http://127.0.0.1:8000/api";

  Future<List<Jadwal>> getJadwal() async {
    final url = Uri.parse("$baseUrl/jadwal");
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => Jadwal.fromJson(json)).toList();
    } else {
      throw Exception("Failed to load jadwal: ${response.statusCode}");
    }
  }
}
