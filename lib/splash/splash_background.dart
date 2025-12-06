import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class SplashBackground extends StatelessWidget {
  final AnimationController bg;
  const SplashBackground({super.key, required this.bg});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return AnimatedBuilder(
      animation: bg,
      builder: (_, __) {
        return SizedBox(
          width: size.width,
          height: size.height,
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color.lerp(
                    Colors.teal.shade900,
                    AppColors.primaryBlueDark,
                    bg.value,
                  )!,
                  Color.lerp(
                    AppColors.primaryBlueLight,
                    Colors.tealAccent,
                    bg.value,
                  )!,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
        );
      },
    );
  }
}
