import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_text.dart';
import '../model/data_pasien.dart';

class ProfilePage extends StatefulWidget {
  final DataPasien pasien;
  const ProfilePage({super.key, required this.pasien});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnim;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _fadeAnim = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    double avatarRadius = width > 400 ? 55 : 45;

    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      body: FadeTransition(
        opacity: _fadeAnim,
        child: Column(
          children: [
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(
                  vertical: width > 400 ? 50 : 40,
                  horizontal: 24,
                ),
                color: AppColors.backgroundLight,
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    // Glow Circle
                    Positioned(
                      top: -100,
                      right: -40,
                      child: Container(
                        width: 200,
                        height: 200,
                        decoration: BoxDecoration(
                          color: AppColors.primaryBlue.withOpacity(.75),
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                    //  const SizedBox(height: 50),
                    Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min, 
                          children: [
                            CircleAvatar(
                              radius: avatarRadius,
                              backgroundImage:
                                  const NetworkImage('https://picsum.photos/200/200?random'),
                            ),
                            const SizedBox(height: 18),
                            Text(
                              widget.pasien.nama,
                              style: AppText.title(width > 400 ? 24 : 20).copyWith(
                                color: Colors.black87,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 6),
                            Text(
                              "Profil Pasien",
                              style: AppText.subtitle(width > 400 ? 16 : 14)
                                  .copyWith(color: Colors.black54),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
            const SizedBox(height: 20),

            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                children: [
                  _animatedInfoRow(Icons.person, "Nama Lengkap", widget.pasien.nama, 0),
                  _animatedInfoRow(Icons.badge, "RM", widget.pasien.rm, 1),
                  _animatedInfoRow(Icons.phone, "No. Telepon", widget.pasien.noTelp ?? "-", 2),
                  _animatedInfoRow(Icons.location_on, "Alamat", widget.pasien.alamat ?? "-", 3),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _animatedInfoRow(IconData icon, String title, String content, int index) {
    return TweenAnimationBuilder(
      tween: Tween<double>(begin: 0, end: 1),
      duration: Duration(milliseconds: 400 + index * 100),
      curve: Curves.easeOut,
      builder: (context, double value, child) {
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(0, 20 * (1 - value)),
            child: child,
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              AppColors.primaryBlue.withOpacity(0.05),
              AppColors.primaryBlue.withOpacity(0.1),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 22,
              backgroundColor: AppColors.primaryBlue.withOpacity(0.2),
              child: Icon(icon, color: AppColors.primaryBlue),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppText.subtitle(16)
                        .copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    content,
                    style: AppText.subtitle(14),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
