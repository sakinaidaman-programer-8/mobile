// import 'dart:math';
// import 'package:apk_poli/awal/awal_page.dart';
// import 'package:apk_poli/theme/app_colors.dart';
// import 'package:flutter/material.dart';

// class SplashPage extends StatefulWidget {
//   const SplashPage({super.key});

//   @override
//   State<SplashPage> createState() => _SplashPageState();
// }

// class _SplashPageState extends State<SplashPage>
//   with TickerProviderStateMixin {
//   late AnimationController bg;
//   late AnimationController logo;
//   late AnimationController text;
//   late AnimationController particle;

//   @override
//   void initState() {
//     super.initState();

//     bg = AnimationController(vsync: this, duration: const Duration(seconds: 6))
//       ..repeat(reverse: true);

//     logo = AnimationController(vsync: this, duration: const Duration(seconds: 3))
//       ..forward();

//     text = AnimationController(vsync: this, duration: const Duration(seconds: 3))
//       ..forward();

//     particle =
//         AnimationController(vsync: this, duration: const Duration(seconds: 8))
//           ..repeat();

//     Future.delayed(const Duration(seconds: 5), () {
//       Navigator.pushReplacement(
//         context,
//         MaterialPageRoute(builder: (_) => const AwalPage()),
//       );
//     });
//   }

//   @override
//   void dispose() {
//     bg.dispose();
//     logo.dispose();
//     text.dispose();
//     particle.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final size = MediaQuery.of(context).size;

//     return Scaffold(
//       body: Stack(
//         children: [
//           AnimatedBuilder(
//             animation: bg,
//             builder: (_, __) {
//               return Container(
//                 decoration: BoxDecoration(
//                   gradient: LinearGradient(
//                     colors: [
//                       Color.lerp(
//                           Colors.teal.shade900, Colors.blue, bg.value)!,
//                       Color.lerp(
//                           AppColors.primaryBlueLight, AppColors.primaryBlueDark, bg.value)!,
//                     ],
//                     begin: Alignment.topLeft,
//                     end: Alignment.bottomRight,
//                   ),
//                 ),
//               );
//             },
//           ),

//           AnimatedBuilder(
//             animation: particle,
//             builder: (_, __) {
//               return CustomPaint(
//                 size: size,
//                 painter: MedicalParticlePainter(particle.value),
//               );
//             },
//           ),

//           Center(
//             child: Stack(
//               alignment: Alignment.center,
//               children: [
//                 RippleEffect(controller: logo),

//                 AnimatedBuilder(
//                   animation: logo,
//                   builder: (_, child) {
//                     return Transform.rotate(
//                       angle: logo.value * pi * 2,
//                       child: Transform.scale(
//                         scale: 0.5 + logo.value,
//                         child: child,
//                       ),
//                     );
//                   },
//                   child: Container(
//                     width: 130,
//                     height: 130,
//                     decoration: BoxDecoration(
//                       shape: BoxShape.circle,
//                       color:AppColors.background,
//                       boxShadow: [
//                         BoxShadow(
//                             color: Colors.black26,
//                             blurRadius: 18,
//                             offset: Offset(0, 10))
//                       ],
//                     ),
//                     child: const Icon(Icons.local_hospital,
//                         size: 70, color: Colors.teal),
//                   ),
//                 ),
//               ],
//             ),
//           ),

//           Positioned(
//             bottom: 160,
//             left: 0,
//             right: 0,
//             child: Column(
//               children: [
//                 AnimatedBuilder(
//                   animation: text,
//                   builder: (_, __) {
//                     const title = "Sistem Informasi Rumah Sakit";
//                     int count = (text.value * title.length).toInt();
//                     return Text(
//                       title.substring(0, count.clamp(0, title.length)),
//                       textAlign: TextAlign.center,
//                       style: const TextStyle(
//                           color: AppColors.background,
//                           fontSize: 22,
//                           fontWeight: FontWeight.bold),
//                     );
//                   },
//                 ),
//                 const SizedBox(height: 10),
//                 FadeTransition(
//                   opacity: text,
//                   child: const Text(
//                     "Melayani dengan Cepat & Akurat",
//                     style: TextStyle(color: Colors.white70),
//                   ),
//                 )
//               ],
//             ),
//           ),

//           Positioned(
//             bottom: 60,
//             left: 32,
//             right: 32,
//             child: LinearProgressIndicator(
//               value: logo.value,
//               minHeight: 6,
//               backgroundColor: Colors.white12,
//               color: AppColors.background,
//             ),
//           )
//         ],
//       ),
//     );
//   }
// }

// class RippleEffect extends StatelessWidget {
//   final AnimationController controller;
//   const RippleEffect({super.key, required this.controller});

//   @override
//   Widget build(BuildContext context) {
//     return AnimatedBuilder(
//       animation: controller,
//       builder: (_, __) {
//         return Stack(
//           alignment: Alignment.center,
//           children: List.generate(3, (i) {
//             final size = 80 + controller.value * 140 + i * 30;
//             final opacity = (1 - controller.value).clamp(0.0, 1.0);
//             return Container(
//               width: size,
//               height: size,
//               decoration: BoxDecoration(
//                 shape: BoxShape.circle,
//                 border:
//                     Border.all(color: AppColors.background.withOpacity(opacity * .4)),
//               ),
//             );
//           }),
//         );
//       },
//     );
//   }
// }

// class MedicalParticlePainter extends CustomPainter {
//   final double value;
//   MedicalParticlePainter(this.value);

//   @override
//   void paint(Canvas canvas, Size size) {
//     final paint = Paint()..color = Colors.white.withOpacity(0.15);
//     for (int i = 0; i < 30; i++) {
//       final dx = size.width * sin((i + value) * pi);
//       final dy = size.height * ((i / 30 + value) % 1);
//       canvas.drawCircle(Offset(dx, dy), 3 + i % 4, paint);
//     }
//   }

//   @override
//   bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
// }