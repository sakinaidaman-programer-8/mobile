import 'package:apk_poli/widget/view_dokter.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';
import '../provider/dokter_jadwal_provider.dart';
import '../theme/app_colors.dart';
import '../theme/app_text.dart';
import 'dart:ui';

class JadwalDokterWidget extends StatefulWidget {
  const JadwalDokterWidget({Key? key}) : super(key: key);

  @override
  State<JadwalDokterWidget> createState() => _JadwalDokterWidgetState();
}

class _JadwalDokterWidgetState extends State<JadwalDokterWidget> {
  String searchQuery = "";
  int showCount = 8;

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<DokterJadwalProvider>(context);

    // Fetch jadwal jika kosong
    if (provider.jadwals.isEmpty && !provider.loading) {
      Future.microtask(() => provider.fetchJadwal());
    }

    // Filter search
    final filteredJadwal = provider.jadwals.where((jadwal) {
      final q = searchQuery.toLowerCase();
      return jadwal.namaPoli.toLowerCase().contains(q) ||
          jadwal.namaDokter.toLowerCase().contains(q) ||
          (jadwal.namaSubspesialis?.toLowerCase().contains(q) ?? false);
    }).toList();

    // Unique doctors
    final Map<String, dynamic> uniqueMap = {};
    for (var d in filteredJadwal) {
      if (!uniqueMap.containsKey(d.dokterId)) {
        uniqueMap[d.dokterId] = d;
      }
    }
    final uniqueDoctors = uniqueMap.values.toList();

    // Pagination
    final displayedJadwal = uniqueDoctors.length > showCount
        ? uniqueDoctors.sublist(0, showCount)
        : uniqueDoctors;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primaryBlue,
        elevation: 0,
        centerTitle: true,
        title: Text(
          "Jadwal Dokter",
          style: AppText.title(20).copyWith(color: AppColors.background),
        ),
        iconTheme: const IconThemeData(color: AppColors.background),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              decoration: InputDecoration(
                hintText: "Cari dokter atau poli...",
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: AppColors.backgroundLight,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
              onChanged: (v) {
                setState(() {
                  searchQuery = v;
                  showCount = 8;
                });
              },
            ),
          ),

          Expanded(
            child: provider.loading
                ? _buildModernLoading()
                : provider.jadwals.isEmpty
                    ? Center(
                        child: Text(
                          provider.error ?? "Data jadwal dokter kosong",
                          style: const TextStyle(fontSize: 16),
                        ),
                      )
                    : LayoutBuilder(
                        builder: (context, constraints) {
                          final maxWidth = constraints.maxWidth;
                          final crossAxisCount = maxWidth > 900
                              ? 4
                              : maxWidth > 600
                                  ? 3
                                  : 2;

                          final cardWidth =
                              (maxWidth - (crossAxisCount - 1) * 16) /
                                  crossAxisCount;

                          return Column(
                            children: [
                              Expanded(
                                child: GridView.builder(
                                  padding: const EdgeInsets.all(16),
                                  itemCount: displayedJadwal.length,
                                  gridDelegate:
                                      SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: crossAxisCount,
                                    mainAxisSpacing: 16,
                                    crossAxisSpacing: 16,
                                    childAspectRatio: cardWidth / 260,
                                  ),
                                  itemBuilder: (context, index) {
                                    final jadwal = displayedJadwal[index];
                                    return _buildJadwalCard(jadwal, index);
                                  },
                                ),
                              ),

                              if (uniqueDoctors.length > showCount)
                                TextButton(
                                  onPressed: () {
                                    setState(() {
                                      showCount = uniqueDoctors.length;
                                    });
                                  },
                                  child: const Text(
                                    "Selanjutnya",
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.primaryBlue,
                                    ),
                                  ),
                                ),
                            ],
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }

  Widget _buildJadwalCard(dynamic jadwal, int index) {
        return Stack(
        clipBehavior: Clip.none,
        children: [

          Container(
            margin: const EdgeInsets.only(top: 50, bottom: 16), // top margin buat foto overlap
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: AppColors.primaryBlue.withOpacity(0.2),
                width: 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 16,
                  spreadRadius: 1,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Column(
              children: [
                const SizedBox(height: 60), 

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        jadwal.namaDokter,
                        style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textDark,
                        ),
                        textAlign: TextAlign.center,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        jadwal.namaSubspesialis != null
                            ? jadwal.namaSubspesialis!
                            : "Poliklinik ${jadwal.namaPoli}",
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: AppColors.textDark,
                        ),
                        textAlign: TextAlign.center,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 12),

                        SizedBox(
                          width: double.infinity,
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(context, MaterialPageRoute(builder: (_) => DokterDetailPage(dokterId: jadwal.dokterId)));
                            },
                            child: const Text(
                              "Lihat Detail",
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: AppColors.blue1,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Center(
              child: Container(
                height: 100,
                width: 100,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(12),
                  image: DecorationImage(
                    image: NetworkImage(
                      jadwal.foto ??
                          "https://picsum.photos/200/200?random=$index",
                    ),
                    fit: BoxFit.cover,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 6,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
    );
  }

  Widget _buildModernLoading() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          LoadingAnimationWidget.staggeredDotsWave(
          color: AppColors.blue2, 
          size: 50,
        ),
          // const SizedBox(height: 20),
          // const Text(
          //   "Memuat jadwal dokter...",
          //   style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
          // ),
        ],
      ),
    );
  }
}
