import 'package:flutter/material.dart';

class SplashText extends StatelessWidget {
  final AnimationController text;
  const SplashText({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Positioned(
      bottom: size.height * 0.20,
      left: size.width * 0.08,
      right: size.width * 0.08,
      child: Column(
        children: [
          AnimatedBuilder(
            animation: text,
            builder: (_, __) {
              const title = "SISTEM INFORMASI RUMAH SAKIT";
              int count = (text.value * title.length).toInt();

              return Text(
                title.substring(0, count.clamp(0, title.length)),
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: size.width * 0.055,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.1,
                ),
              );
            },
          ),

          SizedBox(height: size.height * 0.012),
          FadeTransition(
            opacity: text,
            child: Text(
              "Melayani dengan Cepat & Akurat",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white70,
                fontSize: size.width * 0.038,
                letterSpacing: 0.5,
              ),
            ),
          )
        ],
      ),
    );
  }
}
