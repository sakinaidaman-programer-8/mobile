import 'package:flutter/material.dart';
import '../services/booking_service.dart';

class BookingProvider extends ChangeNotifier {
  final BookingService _service = BookingService();

  bool loading = false;
  Map<String, dynamic>? lastResponse;

  Future<void> createBookingMobile(
      Map<String, dynamic> body, String token) async {
    loading = true;
    notifyListeners();

    // Kirim token ke service
    lastResponse = await _service.createBookingMobile(body, token);

    loading = false;
    notifyListeners();
  }
}
