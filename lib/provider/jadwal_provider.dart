import 'package:apk_poli/services/jadwal_service.dart';
import 'package:flutter/foundation.dart';
import 'package:apk_poli/model/jadwal.dart';

class JadwalProvider with ChangeNotifier {
  List<Jadwal> _jadwal = [];
  bool _loading = false;

  List<Jadwal> get jadwals => _jadwal;
  bool get loading => _loading;

  final JadwalService _service = JadwalService();

  Future<void> fetchJadwal() async {
    _loading = true;
    notifyListeners();

    try {
      _jadwal = await _service.getJadwal();
    } catch (e) {
      if (kDebugMode) print("Error fetching jadwal: $e");
    } finally {
      _loading = false;
      notifyListeners();
    }
  }
}
