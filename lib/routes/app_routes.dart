import 'package:apk_poli/awal/awal_page.dart';
import 'package:apk_poli/auth/nik/nik_page.dart';
import 'package:apk_poli/splash/splash_page.dart';
import 'package:flutter/material.dart';

class AppRoutes {
  static const splash = "/splash";
  static const awal = "/";
  static const inputNik = "/input-nik";
  static const home = "/home";

  static Route<dynamic> generate(RouteSettings settings) {
    switch (settings.name) {

      case splash:
        return MaterialPageRoute(builder: (_) => const SplashPage());

      case awal:
        return MaterialPageRoute(builder: (_) => const AwalPage());

      case inputNik:
        return MaterialPageRoute(builder: (_) => const InputNikPage());

      default:
        return MaterialPageRoute(
          builder: (_) => const Scaffold(
            body: Center(child: Text("Halaman tidak ditemukan")),
          ),
        );
    }
  }
}
