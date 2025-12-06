import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';
import '../provider/dokter_jadwal_provider.dart';
import '../theme/app_colors.dart';
import '../theme/app_text.dart';

class DokterDetailPage extends StatelessWidget {
  final String dokterId;

  const DokterDetailPage({Key? key, required this.dokterId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<DokterJadwalProvider>(context);

    if (provider.jadwals.isEmpty && !provider.loading) {
      Future.microtask(() => provider.fetchJadwal());
    }

    final filtered =
        provider.jadwals.where((d) => d.dokterId == dokterId).toList();
    final dokter = filtered.isNotEmpty ? filtered.first : null;

    if (provider.loading) {
      return Scaffold(
        backgroundColor: AppColors.background,
        body: Center(
          child: LoadingAnimationWidget.staggeredDotsWave(
            color: AppColors.blue2,
            size: 50,
          ),
        ),
      );
    }

    if (dokter == null) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: AppColors.primaryBlue,
          title: const Text("Detail Dokter"),
        ),
        body: const Center(child: Text("Dokter tidak ditemukan")),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          // FOTO FULL CERAH
          SizedBox(
            width: double.infinity,
            height: double.infinity,
            child: Image.network(
              dokter.foto ?? "https://picsum.photos/500",
              fit: BoxFit.cover,
            ),
          ),

          // TOMBOL BACK
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Align(
                alignment: Alignment.topLeft,
                child: CircleAvatar(
                  backgroundColor: Colors.black.withOpacity(0.6),
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
              ),
            ),
          ),

          // KARTU INFO BAWAH
          Align(
            alignment: Alignment.bottomCenter,
            child: SingleChildScrollView(
              child: Container(
                margin: const EdgeInsets.all(16),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.65), // solid & jelas
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black54,
                      blurRadius: 12,
                      offset: Offset(0, 6),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Text(
                        dokter.namaDokter,
                        style: AppText.title(20).copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Center(
                      child: Text(
                        dokter.namaSubspesialis != null
                        ? "Spesialis ${dokter.namaSubspesialis}"
                        : "Poliklinik ${dokter.namaPoli}",
                        style: const TextStyle(
                          fontSize: 16,
                          color: AppColors.primaryGreenDark,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    _infoRow(Icons.schedule, "Jadwal", dokter.jadwal),
                    _infoRow(
                      dokter.status == "Tersedia"
                          ? Icons.check_circle
                          : Icons.cancel,
                      "Status",
                      dokter.status ?? "Tersedia",
                      valueColor: dokter.status == "Tersedia"
                          ? AppColors.success
                          : AppColors.danger,
                    ),
                    const SizedBox(height: 10),
                    _infoRow(Icons.email, "Email", dokter.email ?? "-"),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _infoRow(IconData icon, String title, String value,
      {Color? valueColor}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Icon(icon, color: Colors.white70, size: 20),
          const SizedBox(width: 10),
          Text(
            "$title:",
            style: const TextStyle(color: Colors.white70, fontSize: 14),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                color: valueColor ?? Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
