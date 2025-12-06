import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_text.dart';
import '../widget/detail_layanan_widget.dart';

class LayananPage extends StatelessWidget {
  const LayananPage({super.key});

   final List<Map<String, dynamic>> layanan = const [
    {
      "nama": "Dokter Umum",
      "icon": Icons.medical_services,
      "color": AppColors.primaryBlue,
      "deskripsi": "Konsultasi untuk masalah kesehatan umum dan pemeriksaan rutin.",
      "fitur": [],
    },
    {
      "nama": "Dokter Spesialis",
      "icon": Icons.local_hospital,
      "color": AppColors.primaryGreen,
      "deskripsi": "Konsultasi dengan dokter spesialis sesuai kebutuhan pasien.",
      "fitur": [],
    },
    {
      "nama": "Rawat Inap",
      "icon": Icons.hotel,
      "color": AppColors.orange1,
      "deskripsi": "Layanan rawat inap dengan berbagai pilihan kelas.",
      "fitur": [
        "Kelas VIP Asmorodono",
        "Kelas VIP Gambuh",
        "Kelas I Maskumambang",
        "Kelas II Sinom",
        "Kelas III Dangungdulo & Pangkur",
      ]
    },
    {
      "nama": "UGD",
      "icon": Icons.warning,
      "color": AppColors.danger,
      "deskripsi": "Unit Gawat Darurat 24 jam.",
      "fitur": [
        "Ambulance Gratis 24 Jam",
        "Tenaga Ahli Cepat Tanggap",
        "Fasilitas Penunjang Lengkap",
      ]
    },
    {
      "nama": "Laboratorium",
      "icon": Icons.biotech,
      "color": AppColors.secondary,
      "deskripsi": "Pemeriksaan darah, urin, dan tes diagnostik lainnya.",
      "fitur": [],
    },
    {
      "nama": "Radiologi",
      "icon": Icons.image,
      "color": AppColors.primaryBlueLight,
      "deskripsi": "Pemeriksaan citra untuk diagnosa penyakit dan cedera.",
      "fitur": [],
    },
    {
      "nama": "Layanan Hemodialisa",
      "icon": Icons.local_hospital,
      "color": AppColors.primaryGreen,
      "deskripsi": "Layanan hemodialisa lengkap dan aman.",
      "fitur": [
        "Didukung Teknologi Canggih",
        "Fasilitas Lengkap",
        "Ruang Nyaman",
        "Tenaga Ahli Bersertifikat",
      ]
    },
    {
      "nama": "Layanan Covid-19",
      "icon": Icons.local_hospital,
      "color": AppColors.primaryGreen,
      "deskripsi": "Layanan pemeriksaan dan perawatan Covid-19.",
      "fitur": [
        "Rapid Test Antibody",
        "Rapid Test Antigen",
        "Swab PCR",
        "Kamar Isolasi",
      ]
    },
    {
      "nama": "Layanan Penunjang Lainnya",
      "icon": Icons.local_hospital,
      "color": AppColors.primaryGreen,
      "deskripsi": "Fasilitas penunjang lengkap untuk kebutuhan pasien.",
      "fitur": [
        "USG 2D/4D",
        "Apotek",
        "Laboratorium 24 Jam",
        "Bank Darah",
        "Radiologi",
        "Kelas & Konseling Laktasi",
        "Pijat Bayi & Laktasi",
        "ICU/HCU/NICU",
        "Ruang Operasi",
        "Senam Hamil",
        "Fisioterapi",
      ]
    },
  ];


  Widget _layananCard(IconData icon, String title, Color color, String deskripsi,
      {required VoidCallback onTap}) {
    return TweenAnimationBuilder(
      tween: Tween<double>(begin: 0.85, end: 1.0),
      duration: const Duration(milliseconds: 700),
      curve: Curves.easeOutBack,
      builder: (context, scale, child) {
        return Transform.scale(
          scale: scale,
          child: GestureDetector(
            onTap: onTap,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 350),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: color.withOpacity(0.2),
                    blurRadius: 15,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 400),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [color.withOpacity(0.85), color],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: color.withOpacity(0.35),
                          blurRadius: 20,
                          spreadRadius: 1,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: Icon(
                      icon,
                      color: Colors.white,
                      size: 36,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    title,
                    textAlign: TextAlign.center,
                    style: AppText.title(16).copyWith(
                      color: AppColors.textDark,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: AppBar(
          automaticallyImplyLeading: false,
          centerTitle: true,
          elevation: 0,
          backgroundColor: Colors.transparent,
          flexibleSpace: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [AppColors.primaryBlue, AppColors.primaryBlueDark],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: const BorderRadius.vertical(
                bottom: Radius.circular(20),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.15),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: const Center(
              child: Text(
                "Layanan",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 22,
                ),
              ),
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: GridView.builder(
          itemCount: layanan.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, 
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 0.95,
          ),
          itemBuilder: (context, index) {
            final item = layanan[index];
            return _layananCard(
              item["icon"],
              item["nama"],
              item["color"],
              item["deskripsi"],
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DetailLayananPage(
                      nama: item["nama"],
                      icon: item["icon"],
                      color: item["color"],
                      deskripsi: item["deskripsi"],
                      fitur: item["fitur"], 
                    ),
                  ),
                );
              },
            );
          }                 
        ),
      ),
    );
  }
}
