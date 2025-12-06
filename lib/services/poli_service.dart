import 'dart:convert';
import 'package:apk_poli/model/poli_model.dart';
import 'package:http/http.dart' as http;

class PoliService {
  final String baseUrl = "http://127.0.0.1:8000/api";

  Future<List<Poli>> getPoli() async {
    final url = Uri.parse("$baseUrl/layanan");
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);

      if (body is Map && body['data'] is List) {
        final List data = body['data'];
        return data
            .map((e) => Poli.fromJson(e))
            .where((p) => p.fsKdLayanan.toUpperCase().contains('POL'))
            .toList();
      } else {
        return [];
      }
    } else {
      throw Exception("Gagal fetch poli: ${response.statusCode}");
    }
  }
}
