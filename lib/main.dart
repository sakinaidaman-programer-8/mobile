import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'provider/booking_provider.dart';
import 'provider/dashboard_provider.dart';
import 'provider/dokter_jadwal_provider.dart';
import 'provider/histori_provider.dart';
import 'provider/jadwal_provider.dart';
import 'provider/jkn_provider.dart';
import 'provider/poli_provider.dart';
import 'routes/app_routes.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => DashboardProvider()),
        ChangeNotifierProvider(create: (_) => DokterJadwalProvider()),
        ChangeNotifierProvider(create: (_) => PoliProvider()),
        ChangeNotifierProvider(create: (_) => JknProvider()),
        ChangeNotifierProvider(create: (_) => BookingProvider()),
        ChangeNotifierProvider(create: (_) => HistoryProvider()),
        ChangeNotifierProvider(create: (_) => JadwalProvider()),
      ],
      child: MyApp(),
    ),
  );
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, 
      title: 'Display Antrian Poliklinik',
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: Colors.black,
      ),
       onGenerateRoute: AppRoutes.generate,
      initialRoute: '/',
    );
  }
}