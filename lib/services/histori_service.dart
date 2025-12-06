import 'dart:convert';
import 'package:http/http.dart' as http;

class HistoryService {
  static const String baseUrl = "http://127.0.0.1:8000/api";

  static Future<List<Map<String, dynamic>>> getHistory(String token) async {
    final url = "$baseUrl/booking/history";

    final response = await http.get(
      Uri.parse(url),
      headers: {
        "Authorization": "Bearer $token",
        "Accept": "application/json",
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final list = data['data'] as List<dynamic>? ?? [];
      return list.map((e) => Map<String, dynamic>.from(e)).toList();
    } else if (response.statusCode == 401) {
      throw Exception("Token expired atau tidak valid");
    } else {
      throw Exception("Status ${response.statusCode}: ${response.body}");
    }
  }
}