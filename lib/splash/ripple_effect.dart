import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class RippleEffect extends StatelessWidget {
  final AnimationController controller;
  const RippleEffect({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;

    return AnimatedBuilder(
      animation: controller,
      builder: (_, __) {
        return Stack(
          alignment: Alignment.center,
          children: List.generate(3, (i) {
            final size = (w * 0.22) + controller.value * (w * 0.45) + i * 20;
            final opacity = (1 - controller.value).clamp(0.0, 1.0);

            return Container(
              width: size,
              height: size,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  width: 2,
                  color: AppColors.background.withOpacity(opacity * 0.35),
                ),
              ),
            );
          }),
        );
      },
    );
  }
}
