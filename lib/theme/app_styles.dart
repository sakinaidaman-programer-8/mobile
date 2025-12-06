import 'package:flutter/material.dart';

class AppStyles {
  /// PREMIUM MENU BUTTON (gradient + inner glow)
  static BoxDecoration menuButton(Color color) {
    return BoxDecoration(
      borderRadius: BorderRadius.circular(18),
      gradient: LinearGradient(
        colors: [
          color.withOpacity(.92),
          color.withOpacity(.78),
        ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      boxShadow: [
        // Outer shadow
        BoxShadow(
          color: color.withOpacity(0.35),
          blurRadius: 18,
          offset: const Offset(0, 8),
        ),

        // Inner glow
        BoxShadow(
          color: Colors.white.withOpacity(0.15),
          blurRadius: 6,
          spreadRadius: -4,
          offset: const Offset(-2, -2),
        ),
      ],
      border: Border.all(
        color: Colors.white.withOpacity(0.18),
        width: 1.2,
      ),
    );
  }

  /// ANIMATED MENU BUTTON STYLE (dipakai pada AnimatedScale)
  static BoxDecoration menuButtonAnimated(Color color) {
    return BoxDecoration(
      borderRadius: BorderRadius.circular(18),
      gradient: LinearGradient(
        colors: [
          color.withOpacity(.95),
          color.withOpacity(.78),
        ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      boxShadow: [
        BoxShadow(
          color: color.withOpacity(.40),
          blurRadius: 15,
          offset: const Offset(0, 8),
        ),
      ],
    );
  }

  /// GLASSMORPHISM CARD (untuk header, panel transparan)
  static BoxDecoration glassCard() {
    return BoxDecoration(
      borderRadius: BorderRadius.circular(22),
      color: Colors.white.withOpacity(0.55),
      border: Border.all(
        color: Colors.white.withOpacity(0.28),
      ),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.08),
          blurRadius: 20,
          offset: const Offset(0, 10),
        ),
      ],
    );
  }

  /// LIGHT ELEVATED CARD
  static BoxDecoration elevated() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.06),
          blurRadius: 12,
          offset: const Offset(0, 4),
        ),
      ],
    );
  }
}
