import 'dart:math';
import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import 'ripple_effect.dart';

class SplashLogo extends StatelessWidget {
  final AnimationController logo;
  const SplashLogo({super.key, required this.logo});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final base = size.width * 0.32;

    return Center(
      child: Stack(
        alignment: Alignment.center,
        children: [
          RippleEffect(controller: logo),
          AnimatedBuilder(
            animation: logo,
            builder: (_, child) {
              return Transform.rotate(
                angle: logo.value * pi * 2,
                child: Transform.scale(
                  scale: 0.55 + logo.value,
                  child: child,
                ),
              );
            },
            child: Container(
              width: base,
              height: base,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.background,
                boxShadow: [
                  BoxShadow(
                    color: Colors.tealAccent.withOpacity(.6),
                    blurRadius: base * 0.25,
                    spreadRadius: base * 0.03,
                  ),
                ],
              ),
              child: Icon(
                Icons.local_hospital,
                size: base * 0.5,
                color: Colors.teal,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
