import 'dart:convert';
import 'package:apk_poli/home/main_home.dart';
import 'package:apk_poli/theme/flash_snackbar.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:apk_poli/auth/register_page.dart';
import 'package:apk_poli/model/data_pasien.dart';
import 'package:apk_poli/theme/app_colors.dart';
import 'package:apk_poli/theme/app_text.dart';
import 'package:http/http.dart' as http;
import 'package:loading_animation_widget/loading_animation_widget.dart';

class InputNikPage extends StatefulWidget {
  const InputNikPage({super.key});

  @override
  State<InputNikPage> createState() => _InputNikPageState();
}

class _InputNikPageState extends State<InputNikPage>
    with SingleTickerProviderStateMixin {
  final TextEditingController nikController = TextEditingController();
  bool isProcessing = false;

  late AnimationController _animController;
  late Animation<double> _fadeAnim;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _fadeAnim = CurvedAnimation(parent: _animController, curve: Curves.easeIn);
  }

  @override
  void dispose() {
    _animController.dispose();
    nikController.dispose();
    super.dispose();
  }

  Future<DataPasien?> cekIdentitas(String nik) async {
    final url = Uri.parse("http://127.0.0.1:8000/api/login-pasien");
    try {
      final response = await http.post(url, body: {'nik': nik});
      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);
        if (body["success"] == true && body["data"] != null) {
          final pasien = DataPasien.fromJson(
            Map<String, dynamic>.from(body["data"]),
          );
          pasien.token = body["token"];
          if (kDebugMode) {
            print("TOKEN PASIEN: ${pasien.token}");
            print("DATA PASIEN: ${pasien.toJson()}");
          }
          return pasien;
        } else {
          if (kDebugMode) print("Response API gagal: $body");
        }
      } else {
        if (kDebugMode) print("Status code error: ${response.statusCode}");
      }
    } catch (e) {
      debugPrint("Error cek identitas: $e");
    }
    return null;
  }

  Future<void> handleLanjut() async {
    String nik = nikController.text.trim();

    if (nik.length != 16 || !RegExp(r'^\d{16}$').hasMatch(nik)) {
      showFlashSnackBar(context,"NIK harus 16 digit angka!");
      return;
    }

    setState(() => isProcessing = true);

    try {
      final pasien = await cekIdentitas(nik);

      if (pasien == null) {
        await _animController.forward(from: 0);
        _showNotFoundDialog(nik);
        return;
      }

      // Navigasi ke halaman utama dengan token dari API
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => Base(dataPasien: pasien, token: pasien.token ?? ''),
        ),
      );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Terjadi kesalahan: $e")),
        );
      }
      if (kDebugMode) print("Error handleLanjut: $e");
    } finally {
      if (mounted) setState(() => isProcessing = false);
    }
  }

  void _showNotFoundDialog(String nik) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => FadeTransition(
        opacity: _fadeAnim,
        child: AlertDialog(
          backgroundColor: AppColors.backgroundLight,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Row(
            children: const [
              Icon(Icons.error_outline, color: AppColors.danger, size: 30),
              SizedBox(width: 12),
              Text("Data Tidak Ditemukan")
            ],
          ),
          content: const Text(
              "NIK ini belum terdaftar. Silahkan lanjut ke registrasi pasien baru."),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => RegistrasiPage(initialNik: nik),
                  ),
                );
              },
              child: const Text("Registrasi",
                  style: TextStyle(color: AppColors.primaryBlue)),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Batal",
                  style: TextStyle(color: AppColors.grey600)),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.backgroundLight,
        elevation: 0,
        centerTitle: true,
        title: Text(
          "Input NIK",
          style: AppText.title(20).copyWith(color: AppColors.textDark),
        ),
        iconTheme: const IconThemeData(color: AppColors.textDark),
      ),
      body: Padding(
        padding: const EdgeInsets.all(22),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Masukkan Nomor Induk Kependudukan",
              style: AppText.subtitle(16)
                  .copyWith(fontWeight: FontWeight.w600, color: AppColors.textDark),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
              decoration: BoxDecoration(
                color: AppColors.backgroundLight,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.06),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: TextField(
                controller: nikController,
                style: const TextStyle(color: AppColors.textDark), 
                keyboardType: TextInputType.number,
                cursorColor: AppColors.primaryBlue,
                maxLength: 16,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  counterText: "",
                  hintText: "Masukkan 16 digit NIK",
                  hintStyle: TextStyle(color: AppColors.textDark),
                ),
              ),
            ),
            const SizedBox(height: 32),
            GestureDetector(
              onTap: isProcessing ? null : handleLanjut,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 14),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  gradient: const LinearGradient(
                    colors: [AppColors.primaryBlue, AppColors.primaryBlueDark],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primaryBlue.withOpacity(0.35),
                      blurRadius: 14,
                      offset: const Offset(0, 6),
                    )
                  ],
                ),
                child: Center(
                  child: isProcessing
                      ? SizedBox(
                          height: 20,
                          width: 20,
                          child: LoadingAnimationWidget.staggeredDotsWave(color: AppColors.backgroundLight, size: 25)
                        )
                      : Text("Lanjutkan", style: AppText.button(17)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
