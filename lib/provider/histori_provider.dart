import 'package:apk_poli/services/histori_service.dart';
import 'package:flutter/foundation.dart';

class HistoryProvider extends ChangeNotifier {
  List<Map<String, dynamic>> _history = [];
  bool _loading = false;
  String? _error;

  List<Map<String, dynamic>> get history => _history;
  bool get loading => _loading;
  String? get error => _error;

  void addBooking(Map<String, dynamic> booking) {
    _history.insert(0, booking);
    notifyListeners();
  }

  // Optional: fetch dari API
  Future<void> fetchHistory(String token) async {
    _loading = true;
    notifyListeners();
    try {
 
      _history = await HistoryService.getHistory(token);
    } catch (e) {
      _error = e.toString();
    }
    _loading = false;
    notifyListeners();
  }
}
