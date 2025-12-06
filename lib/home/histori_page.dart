import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';
import '../provider/histori_provider.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';
import '../theme/app_colors.dart';
import '../theme/app_styles.dart';

class HistoryPage extends StatelessWidget {
  const HistoryPage({super.key, required String token});

  @override
  Widget build(BuildContext context) {
    final historyProv = Provider.of<HistoryProvider>(context);

    final size = MediaQuery.of(context).size;
    final width = size.width;
    final height = size.height;

    double fontSubtitle = width * 0.04;
    double paddingHorizontal = width * 0.04;
    double paddingVertical = height * 0.01;
    double avatarRadius = width * 0.08;
    double buttonHeight = height * 0.065;
    double spacing = height * 0.015;

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
                "Riwayat Booking",
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
      body: historyProv.loading
          ? Center(
              child: CircularProgressIndicator(
                color: AppColors.primaryBlueDark,
              ),
            )
          : historyProv.history.isEmpty
              ? Center(
                  child: Text(
                    "Belum ada riwayat booking",
                    style: TextStyle(
                      fontSize: fontSubtitle,
                      fontWeight: FontWeight.w500,
                      color: AppColors.textLight,
                    ),
                  ),
                )
              : ListView.builder(
                  itemCount: historyProv.history.length,
                  itemBuilder: (context, index) {
                    final booking = historyProv.history[index];

                    return Container(
                      margin: EdgeInsets.symmetric(
                          horizontal: paddingHorizontal,
                          vertical: paddingVertical),
                      decoration: AppStyles.elevated(),
                      child: ListTile(
                        contentPadding: EdgeInsets.symmetric(
                            horizontal: paddingHorizontal,
                            vertical: paddingVertical),
                        leading: CircleAvatar(
                          radius: avatarRadius,
                          backgroundColor: AppColors.primaryBlueDark,
                          child: Icon(
                            Iconsax.calendar_1,
                            color: Colors.white,
                            size: avatarRadius,
                          ),
                        ),
                        title: Text(
                          booking['nama_pasien'] ?? 'Pasien',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, color: AppColors.textDark,
                              fontSize: fontSubtitle),
                        ),
                        subtitle: Padding(
                          padding: EdgeInsets.only(top: paddingVertical / 2),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("RM: ${booking['rm'] ?? '-'}",
                                  style: TextStyle(color:AppColors.textDark, fontSize: 13)),
                              Text("Tanggal: ${booking['tgl_booking'] ?? '-'}",
                                  style: TextStyle(color:AppColors.textDark, fontSize: 13)),
                              // Text("No Antrian: ${booking['no_antrian'] ?? '-'}",
                              //     style: TextStyle(color:AppColors.textDark, fontSize: 13)),
                              // Text("No Booking: ${booking['booking_id'] ?? '-'}",
                              //     style: TextStyle(color:AppColors.textDark, fontSize: 13)),
                            ],
                          ),
                        ),
                        trailing: Icon(Icons.arrow_forward_ios,
                            size: fontSubtitle, color: AppColors.primaryBlueDark),
                        onTap: () {
                          _showBookingDetail(
                              context, booking, fontSubtitle, avatarRadius, spacing, buttonHeight);
                        },
                      ),
                    );
                  },
                ),
    );
  }

  void _showBookingDetail(BuildContext context, Map<String, dynamic> booking,
      double fontSize, double avatarRadius, double spacing, double buttonHeight) {
    showDialog(
      context: context,
      builder: (_) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        elevation: 5,
        child: Container(
          padding: EdgeInsets.all(spacing * 2),
          decoration: AppStyles.glassCard(),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircleAvatar(
                radius: avatarRadius,
                backgroundColor: AppColors.primaryBlueDark,
                child: Icon(Icons.medical_services,
                    color: Colors.white, size: avatarRadius),
              ),
              SizedBox(height: spacing),
              Text(
                "Detail Booking",
                style: TextStyle(
                    fontSize: fontSize + 2,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textDark),
              ),
              SizedBox(height: spacing * 1.5),
              _buildInfoRow("Nama Pasien", booking['nama_pasien'] ?? "-", fontSize),
              _buildInfoRow("RM", booking['rm'] ?? "-", fontSize),
              _buildInfoRow("Poli", booking['poli'] ?? "-", fontSize),
              _buildInfoRow("Tanggal", booking['tgl_booking'] ?? "-", fontSize),
              _buildInfoRow("No Antrian", booking['no_antrian'] ?? "-", fontSize),
              _buildInfoRow("No Booking", booking['booking_id'] ?? "-", fontSize),
              SizedBox(height: spacing),
              PrettyQr(
                data: booking['booking_id']?.toString() ?? "-",
                size: 150,
                roundEdges: true,
                errorCorrectLevel: QrErrorCorrectLevel.M,
                typeNumber: null,
                elementColor: AppColors.backgroundDark,
              ),
              SizedBox(height: spacing * 2),
              Text(
                "*Mohon di screenshot terlebih dahulu",
                style: TextStyle(
                  fontSize: fontSize * 0.85,
                  fontWeight: FontWeight.w500,
                  color: Colors.red,
                ),
              ),
              SizedBox(height: spacing),
              SizedBox(
                width: double.infinity,
                height: buttonHeight,
                child: Container(
                  decoration: AppStyles.menuButton(AppColors.primaryBlueDark),
                  child: TextButton(
                    onPressed: () => Navigator.pop(context),
                    style: TextButton.styleFrom(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18)),
                    ),
                    child: Text(
                      "Tutup",
                      style: TextStyle(
                          fontSize: fontSize,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, double fontSize) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: fontSize * 0.3),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: TextStyle(
                  fontSize: fontSize * 0.9,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textLight)),
          Text(value,
              style: TextStyle(
                  fontSize: fontSize * 0.9,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textDark)),
        ],
      ),
    );
  }
}
