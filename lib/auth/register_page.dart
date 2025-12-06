import 'dart:io';
import 'package:apk_poli/theme/flash_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import '../theme/app_colors.dart';
import '../theme/app_text.dart';
import '../model/data_pasien.dart';

class RegistrasiPage extends StatefulWidget {
  final String? initialNik;
  const RegistrasiPage({super.key, this.initialNik});

  @override
  State<RegistrasiPage> createState() => _RegistrasiPageState();
}

class _RegistrasiPageState extends State<RegistrasiPage> {
  final TextEditingController nikController = TextEditingController();
  final TextEditingController namaController = TextEditingController();
  final TextEditingController tempatLahirController = TextEditingController();
  final TextEditingController alamatController = TextEditingController();
  final TextEditingController noTelpController = TextEditingController();
  final TextEditingController emailController = TextEditingController();

  File? ktpImage;

  @override
  void initState() {
    super.initState();
    if (widget.initialNik != null) {
      nikController.text = widget.initialNik!;
    }
  }

  Future<void> pickKtpImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() => ktpImage = File(pickedFile.path));
      await extractTextFromKtp(ktpImage!);
    }
  }

  Future<void> extractTextFromKtp(File imageFile) async {
    final inputImage = InputImage.fromFile(imageFile);
    final textRecognizer = GoogleMlKit.vision.textRecognizer();
    final recognizedText = await textRecognizer.processImage(inputImage);
    final fullText = recognizedText.text;

    final nikMatch = RegExp(r'\b\d{16}\b').firstMatch(fullText);
    if (nikMatch != null) nikController.text = nikMatch.group(0)!;

    final lines = fullText.split('\n');
    for (var line in lines) {
      if (line.toLowerCase().contains('nama')) {
        namaController.text = line.replaceAll(RegExp(r'Nama|nama|:'), '').trim();
      }
      if (line.toLowerCase().contains('tempat/tanggal lahir')) {
        final parts = line.split(':');
        if (parts.length > 1) {
          tempatLahirController.text = parts[1].split(',')[0].trim();
        }
      }
    }

    textRecognizer.close();
  }

  void handleRegistrasi() {
    if (nikController.text.length != 16 || namaController.text.isEmpty) {
      showFlashSnackBar(context,"Lengkapi NIK & Nama!");
      return;
    }

    final pasien = DataPasien(
      rm: "",
      rmLama: null,
      noIdentitas: nikController.text,
      nama: namaController.text,
      jenisKelamin: "",
      tempatLahir: tempatLahirController.text,
      alamat: alamatController.text,
      noTelp: noTelpController.text,
      email: emailController.text,
    );

    debugPrint("Data Pasien: ${pasien.toJson()}");
    // TODO: Kirim data ke API
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    TextInputType? type,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.backgroundLight,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        keyboardType: type,
        style: TextStyle(color: AppColors.textDark),
        maxLength: type == TextInputType.number ? 16 : null,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(color: AppColors.textDark), 
          border: InputBorder.none,
          counterText: "",
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primaryBlue,
        elevation: 0,
        title: Row(
          children: [
            Text(
              "Registrasi Pasien",
              style: AppText.title(20).copyWith(color: Colors.white),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Upload Foto KTP", style: AppText.subtitle(16).copyWith(fontWeight: FontWeight.w600)),
            const SizedBox(height: 12),
            GestureDetector(
              onTap: pickKtpImage,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                height: 180,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.04),
                      blurRadius: 12,
                      offset: const Offset(0, 6),
                    ),
                  ],
                  border: Border.all(
                    color: AppColors.primaryBlue.withOpacity(0.3),
                    width: 2,
                  ),
                ),
                child: ktpImage != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Image.file(ktpImage!, fit: BoxFit.cover),
                      )
                    : Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Icon(Icons.camera_alt, size: 50, color: Colors.grey),
                            SizedBox(height: 8),
                            Text("Tap untuk upload KTP"),
                          ],
                        ),
                      ),
              ),
            ),
            const SizedBox(height: 24),
            _buildTextField(controller: nikController, label: "NIK", type: TextInputType.number),
            _buildTextField(controller: namaController, label: "Nama Lengkap"),
            _buildTextField(controller: tempatLahirController, label: "Tempat Lahir"),
            _buildTextField(controller: alamatController, label: "Alamat"),
            _buildTextField(controller: noTelpController, label: "No. Telp", type: TextInputType.phone),
            _buildTextField(controller: emailController, label: "Email", type: TextInputType.emailAddress),
            const SizedBox(height: 32),
            GestureDetector(
              onTap: handleRegistrasi,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 16),
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
                    ),
                  ],
                ),
                child: Center(
                  child: Text("Daftar", style: AppText.button(17).copyWith(color: Colors.white)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
