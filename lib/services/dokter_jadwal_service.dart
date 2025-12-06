import 'dart:convert';
import 'package:apk_poli/model/dokter_jadwal.dart';
import 'package:http/http.dart' as http;

class DokterJadwalService {
  final String baseUrl = "http://127.0.0.1:8000/api";

  Future<List<DokterJadwal>> getJadwal() async {
    final url = Uri.parse("$baseUrl/jadwal_dokter");
    final response = await http.get(url);

    if (response.statusCode != 200) {
      throw Exception("Gagal fetch data (Status ${response.statusCode})");
    }

    final body = json.decode(response.body);

    if (body is! Map<String, dynamic>) {
      throw Exception("Format API salah: body bukan Map<String, dynamic>");
    }

    if (!body.containsKey("data")) {
      throw Exception('Format API salah: key "data" tidak ditemukan');
    }

    final rawData = body["data"];
    if (rawData == null) {
      throw Exception('Data kosong: "data" = null');
    }

    if (rawData is! List) {
      throw Exception('Format API salah: "data" bukan List (ditemukan: ${rawData.runtimeType})');
    }

    try {
      return rawData.map((item) => DokterJadwal.fromJson(item)).toList();
    } catch (e) {
      throw Exception("Error parsing data: $e");
    }
  }
}
