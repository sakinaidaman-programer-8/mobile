import 'package:apk_poli/services/dokter_jadwal_service.dart';
import 'package:flutter/material.dart';
import '../model/dokter_jadwal.dart';

class DokterJadwalProvider with ChangeNotifier {
  List<DokterJadwal> _jadwals = [];
  bool _loading = false;
  String? _error;

  List<DokterJadwal> get jadwals => _jadwals;
  bool get loading => _loading;
  String? get error => _error;

  final DokterJadwalService _service = DokterJadwalService();

  Future<void> fetchJadwal() async {
    _loading = true;
    _error = null;
    notifyListeners();

    try {
      _jadwals = await _service.getJadwal();
    } catch (e) {
      _jadwals = [];
      _error = e.toString();
      debugPrint("ERROR: $_error");
    } finally {
      _loading = false;
      notifyListeners();
    }
  }
}
