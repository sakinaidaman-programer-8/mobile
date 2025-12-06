import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class DashboardProvider with ChangeNotifier {
  int jadwalDokter = 0;
  bool loading = false;

  Future<void> fetchBadges() async {
    loading = true;
    notifyListeners();

    try {
      final response = await http.get(
        Uri.parse('http://127.0.0.1:8000/api/dashboard-badges'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        // pastikan key sesuai API
        jadwalDokter = data['jadwal_dokter'] ?? 0;
      } else {
        // bisa log error
        if (kDebugMode) {
          print('API error: ${response.statusCode}');
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('Fetch badges error: $e');
      }
    }

    loading = false;
    notifyListeners();
  }
}
