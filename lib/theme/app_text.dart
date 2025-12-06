import 'package:flutter/material.dart';

class AppText {
  static TextStyle title(double size) => TextStyle(
        fontSize: size,
        fontWeight: FontWeight.bold,
        color: Colors.black87,
      );

  static TextStyle subtitle(double size) => TextStyle(
        fontSize: size,
        color: Colors.black54,
      );

  static TextStyle button(double size) => TextStyle(
        fontSize: size,
        fontWeight: FontWeight.w600,
        color: Colors.white,
        height: 1.3,
      );
}
