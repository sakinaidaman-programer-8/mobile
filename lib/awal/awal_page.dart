import 'dart:ui';
import 'package:apk_poli/auth/register_page.dart';
import 'package:apk_poli/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

import '../theme/app_colors.dart';
import '../theme/app_text.dart';
import '../theme/app_styles.dart';

class AwalPage extends StatefulWidget {
  const AwalPage({super.key});

  @override
  State<AwalPage> createState() => _AwalPageState();
}

class _AwalPageState extends State<AwalPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeIn;
  late Animation<Offset> _slideUp;
  
  double _btnScale1 = 1.0;
  double _btnScale2 = 1.0;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );

    _fadeIn = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    );

    _slideUp = Tween<Offset>(
      begin: const Offset(0, 0.2),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOutBack,
      ),
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
    final size = MediaQuery.of(context).size;
    final isTablet = size.width > 600;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Stack(
          children: [
            // Background Gradient
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color(0xFFE4EEFF),
                    Color(0xFFFFFFFF),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
            ),

            // Glow Circle
            Positioned(
              top: -60,
              right: -40,
              child: Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  color: AppColors.primaryBlue.withOpacity(.25),
                  shape: BoxShape.circle,
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(22),
              child: Column(
                children: [
                  const SizedBox(height: 20),

                  FadeTransition(
                    opacity: _fadeIn,
                    child: SlideTransition(
                      position: _slideUp,
                      child: _headerCard(isTablet),
                    ),
                  ),

                  const Spacer(),

                  // BUTTON ROW
                  SlideTransition(
                    position: Tween<Offset>(
                      begin: const Offset(0, 0.4),
                      end: Offset.zero,
                    ).animate(
                      CurvedAnimation(
                        parent: _controller,
                        curve: Curves.easeOutBack,
                      ),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: _menuButton(
                            color: AppColors.primaryGreen,
                            icon: Iconsax.tick_circle,
                            text: "Sudah Pernah\nPeriksa",
                            isTablet: isTablet,
                            scale: _btnScale1,
                            onTapDown: () => setState(() => _btnScale1 = 0.94),
                            onTapUp: () => setState(() => _btnScale1 = 1.0),
                            onTapCancel: () => setState(() => _btnScale1 = 1.0),
                            onTap: () {
                              Navigator.pushNamed(context, AppRoutes.inputNik);
                            },        
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _menuButton(
                            color: AppColors.primaryBlue,
                            icon: Iconsax.user,
                            text: "Belum Pernah\nPeriksa",
                            isTablet: isTablet,
                            scale: _btnScale2,
                            onTapDown: () => setState(() => _btnScale2 = 0.94),
                            onTapUp: () => setState(() => _btnScale2 = 1.0),
                            onTapCancel: () => setState(() => _btnScale2 = 1.0),
                            onTap: () {
                              // Navigasi ke RegistrasiPage
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => RegistrasiPage(),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // HEADER CARD
  Widget _headerCard(bool isTablet) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(22),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 35, horizontal: 22),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.55),
            borderRadius: BorderRadius.circular(22),
            border: Border.all(color: Colors.white.withOpacity(0.3)),
            boxShadow: [
              BoxShadow(
                blurRadius: 18,
                offset: const Offset(0, 8),
                color: Colors.black.withOpacity(0.08),
              ),
            ],
          ),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.red.shade400,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.red.shade200.withOpacity(.45),
                      blurRadius: 15,
                      offset: const Offset(0, 6),
                    )
                  ],
                ),
                child: const Icon(
                  Icons.local_hospital,
                  color: Colors.white,
                  size: 45,
                ),
              ),
              const SizedBox(height: 18),
              Text(
                "Rumah Sakit",
                textAlign: TextAlign.center,
                style: AppText.title(isTablet ? 32 : 23),
              ),
              const SizedBox(height: 10),
              Text(
                "Pilih status pemeriksaan pasien",
                style: AppText.subtitle(isTablet ? 18 : 15),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ANIMATED MENU BUTTON
 Widget _menuButton({
  required Color color,
  required IconData icon,
  required String text,
  required bool isTablet,
  required double scale,
  required VoidCallback onTapDown,
  required VoidCallback onTapUp,
  required VoidCallback onTapCancel,
  required VoidCallback onTap,
}) {
  return GestureDetector(
    behavior: HitTestBehavior.translucent,  
    onTapDown: (_) => onTapDown(),
    onTapUp: (_) => onTapUp(),
    onTapCancel: () => onTapCancel(),
    onTap: onTap, 

    child: AnimatedScale(
      scale: scale,
      duration: const Duration(milliseconds: 120),
      curve: Curves.easeOut,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        padding: EdgeInsets.symmetric(vertical: isTablet ? 34 : 24),
        decoration: AppStyles.menuButtonAnimated(color),
        child: Column(
          children: [
            Icon(icon, size: isTablet ? 44 : 34, color: Colors.white),
            const SizedBox(height: 12),
            Text(
              text,
              textAlign: TextAlign.center,
              style: AppText.button(isTablet ? 21 : 17),
            ),
          ],
        ),
      ),
    ),
  );
}


}
