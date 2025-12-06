import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class BookingService {
  static const String baseUrl = "http://127.0.0.1:8000/api"; 
  String? token;

  BookingService({this.token});

  Future<Map<String, dynamic>> createBookingMobile(
    Map<String, dynamic> body,
    String token,
  ) async {
    final url = Uri.parse("$baseUrl/booking");

    try {
      if (kDebugMode) {
        print("SEND POST TO: $url");
      }
      if (kDebugMode) {
        print("BODY: $body");
      }

      final response = await http.post(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
        body: body,
      );

      if (kDebugMode) {
        print("RESPONSE CODE: ${response.statusCode}");
      }
      if (kDebugMode) {
        print("RESPONSE BODY: ${response.body}");
      }

      return jsonDecode(response.body);
    } catch (e) {
      if (kDebugMode) {
        print("ERROR createBookingMobile: $e");
      }
      return {
        'status': 'error',
        'message': 'Terjadi error: $e',
      };
    }
  }

  Future<List<dynamic>> getHistory() async {
    final url = Uri.parse("$baseUrl/booking/history");

    try {
      if (kDebugMode) {
        print("SEND GET TO: $url");
      }

      final response = await http.get(url);

      if (kDebugMode) {
        print("RESPONSE CODE: ${response.statusCode}");
      }
      if (kDebugMode) {
        print("RESPONSE BODY: ${response.body}");
      }

      final data = jsonDecode(response.body);
      return data["data"] ?? [];
    } catch (e) {
      if (kDebugMode) {
        print("ERROR getHistory: $e");
      }
      return [];
    }
  }

  Future<Map<String, dynamic>> getQueueToday({
    required int idUnit,
    required int idDokter,
  }) async {
    final url = Uri.parse(
      "$baseUrl/booking/antrian?id_unit=$idUnit&id_dokter=$idDokter",
    );

    try {
      if (kDebugMode) {
        print("SEND GET TO: $url");
      }

      final response = await http.get(url);

      if (kDebugMode) {
        print("RESPONSE CODE: ${response.statusCode}");
      }
      if (kDebugMode) {
        print("RESPONSE BODY: ${response.body}");
      }

      return jsonDecode(response.body);
    } catch (e) {
      if (kDebugMode) {
        print("ERROR getQueueToday: $e");
      }
      return {
        "status": "error",
        "message": "Terjadi error: ${e.toString()}",
      };
    }
  }
}
