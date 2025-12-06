import 'dart:math';
import 'package:flutter/material.dart';

class SplashParticles extends StatelessWidget {
  final AnimationController particle;

  const SplashParticles({
    super.key,
    required this.particle,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return RepaintBoundary(
      child: AnimatedBuilder(
        animation: particle,
        builder: (_, __) {
          return CustomPaint(
            size: size,
            painter: MedicalParticlePainter(particle.value),
          );
        },
      ),
    );
  }
}

class MedicalParticlePainter extends CustomPainter {
  final double value;
  MedicalParticlePainter(this.value);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.white.withOpacity(0.12);

    final count = (size.width / 12).clamp(20, 60).toInt();

    for (int i = 0; i < count; i++) {
      final dx = size.width * ((i / count + value) % 1);

      final dy = size.height *
          (0.2 + 0.6 * sin((i / count * 2 + value) * pi));

      final radius = size.width * 0.004 + (i % 3);

      canvas.drawCircle(
        Offset(dx, dy),
        radius,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
