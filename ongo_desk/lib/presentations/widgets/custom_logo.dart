import 'package:flutter/material.dart';

class CustomLogo extends StatelessWidget {
  const CustomLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Image.asset(
          'assets/images/logo.png',
          width: MediaQuery.of(context).size.width * 0.3,
          fit: BoxFit.contain,
        ),
        const SizedBox(
          height: 2,
        ),
        Column(
          children: [
            const Text(
              ".OngoDesk",
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 20,
                fontWeight: FontWeight.w600
              ),
            ),

            SizedBox(
              height: 16,
            ),

            const Text(
              "Smarter cities start with you!",
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 18,
                fontWeight: FontWeight.w400
              ),
            )
          ],
        )
      ],
    );
  }
}