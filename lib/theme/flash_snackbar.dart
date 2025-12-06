import 'dart:ui';
import 'package:apk_poli/theme/app_colors.dart';
import 'package:flutter/material.dart';

void showFlashSnackBar(
  BuildContext context,
  String message, {
  int milliseconds = 1600,
}) {
  final overlay = Overlay.of(context);
  late OverlayEntry overlayEntry;

  overlayEntry = OverlayEntry(
    builder: (context) => Positioned(
      top: 50,
      left: 20,
      right: 20,
      child: _IOSSnackBarWidget(
        message: message,
        duration: Duration(milliseconds: milliseconds),
        onFinish: () => overlayEntry.remove(),
      ),
    ),
  );

  overlay.insert(overlayEntry);
}

class _IOSSnackBarWidget extends StatefulWidget {
  final String message;
  final Duration duration;
  final VoidCallback onFinish;

  const _IOSSnackBarWidget({
    required this.message,
    required this.duration,
    required this.onFinish,
  });

  @override
  State<_IOSSnackBarWidget> createState() => _IOSSnackBarWidgetState();
}

class _IOSSnackBarWidgetState extends State<_IOSSnackBarWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _opacity;
  late Animation<Offset> _slide;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 350),
    );

    _opacity = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );

    _slide = Tween<Offset>(
      begin: const Offset(0, -0.4),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );

    _controller.forward();

    Future.delayed(widget.duration, () async {
      await _controller.reverse();
      widget.onFinish();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _opacity,
      child: SlideTransition(
        position: _slide,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(18),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 14, sigmaY: 14),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.15),
                borderRadius: BorderRadius.circular(18),
                border: Border.all(
                  color: Colors.white.withOpacity(0.25),
                ),
              ),
              child: Text(
                widget.message,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: AppColors.textDark,
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
