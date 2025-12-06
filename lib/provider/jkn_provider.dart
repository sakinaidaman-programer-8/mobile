import 'package:apk_poli/model/jkn_model.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class JknProvider with ChangeNotifier {
  List<JknModel> _menuItems = [];
  bool isLoading = false;

  List<JknModel> get menuItems => _menuItems;

  Future<void> fetchMenuItems() async {
    isLoading = true;
    notifyListeners();

    final url = Uri.parse('http://127.0.0.1:8000/api/layanan-bpjs');
    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body)['data'];
        _menuItems = data.map((json) => JknModel.fromJson(json)).toList();
      } else {
        // handle error
        if (kDebugMode) {
          print('Error: ${response.statusCode}');
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('Exception: $e');
      }
    }

    isLoading = false;
    notifyListeners();
  }

  void updateBadge(String kode, int newBadge) {
    final index = _menuItems.indexWhere((item) => item.kode == kode);
    if (index != -1) {
      _menuItems[index].badge = newBadge;
      notifyListeners();
    }
  }
}
