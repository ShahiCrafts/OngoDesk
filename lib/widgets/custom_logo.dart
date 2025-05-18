import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class CustomLogo extends StatelessWidget {
  const CustomLogo({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Image.asset(
          'assets/images/logo.png',
          width: size.width * 0.26,
          fit: BoxFit.contain,
        ),

        const SizedBox(height: 2),

        Column(
          children: [
            const Text(
              ".OnGo Desk",
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),

            SizedBox(height: 6),

            const Text(
              "' Smarter cities start with you! '",
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 18,
                fontWeight: FontWeight.w400,
                fontStyle: FontStyle.italic
              ),
            ),

            Align(
              alignment: Alignment.bottomCenter,
              child: Lottie.asset(
                'assets/animations/load_animation.json',
                width: size.width * 0.3,
                height: size.width * 0.3,
                fit: BoxFit.contain,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
