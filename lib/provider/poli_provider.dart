import 'package:apk_poli/services/poli_service.dart';
import 'package:flutter/material.dart';
import '../model/poli_model.dart';

class PoliProvider extends ChangeNotifier {
  List<Poli> _poliList = [];
  bool _loading = false;

  List<Poli> get poliList => _poliList;
  bool get loading => _loading;

  final PoliService _service = PoliService();

  Future<void> fetchPoli() async {
    _loading = true;
    notifyListeners();

    try {
      _poliList = await _service.getPoli();
    } catch (e) {
      _poliList = [];
      debugPrint("Error fetch poli: $e");
    } finally {
      _loading = false;
      notifyListeners();
    }
  }
}
