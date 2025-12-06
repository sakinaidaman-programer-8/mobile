import 'package:apk_poli/splash/splash_particles.dart';
import 'package:flutter/material.dart';
import '../awal/awal_page.dart';
import 'splash_background.dart';
import 'splash_logo.dart';
import 'splash_text.dart';
import 'splash_ecg.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage>
    with TickerProviderStateMixin {
  late AnimationController bg;
  late AnimationController logo;
  late AnimationController text;
  late AnimationController particle;
  late AnimationController ecg;

  @override
  void initState() {
    super.initState();

    bg = AnimationController(vsync: this, duration: const Duration(seconds: 6))
      ..repeat(reverse: true);

    logo = AnimationController(vsync: this, duration: const Duration(seconds: 3))
      ..forward();

    text = AnimationController(vsync: this, duration: const Duration(seconds: 3))
      ..forward();

    particle =
        AnimationController(vsync: this, duration: const Duration(seconds: 12))
          ..repeat();

    ecg = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1800))
      ..repeat();

    Future.delayed(const Duration(seconds: 5), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const AwalPage()),
      );
    });
  }

  @override
  void dispose() {
    bg.dispose();
    logo.dispose();
    text.dispose();
    particle.dispose();
    ecg.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Stack(
              children: [
                SplashBackground(bg: bg),
                SplashParticles(particle: particle),
                SplashLogo(logo: logo),
                SplashText(text: text),
                SplashECG(ecg: ecg),
              ],
            );
          },
        ),
      ),
    );
  }
}
