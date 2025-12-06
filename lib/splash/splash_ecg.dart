import 'dart:math';
import 'package:flutter/material.dart';

class SplashECG extends StatelessWidget {
  final AnimationController ecg;
  const SplashECG({super.key, required this.ecg});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Positioned(
      bottom: size.height * 0.14,
      left: size.width * 0.06,
      right: size.width * 0.06,
      child: SizedBox(
        height: size.height * 0.065,
        child: AnimatedBuilder(
          animation: ecg,
          builder: (_, __) => CustomPaint(
            painter: _ECGPainter(ecg.value),
          ),
        ),
      ),
    );
  }
}

class _ECGPainter extends CustomPainter {
  final double v;
  _ECGPainter(this.v);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.tealAccent
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = size.height * 0.08;

    final path = Path();
    final y = size.height / 2;
    final amplitude = size.height * 0.35;

    for (double x = 0; x <= size.width; x++) {
      final value = sin((x / size.width * 3 + v) * pi * 2);
      path.lineTo(x, y + value * amplitude);
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
