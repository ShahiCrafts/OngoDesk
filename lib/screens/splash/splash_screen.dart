import 'package:flutter/material.dart';
import 'package:ongo_desk/widgets/custom_logo.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  // @override 
  // void initState() {
  //   super.initState();
  //   Timer(const Duration(seconds: 4), () {
  //     Navigator.pushReplacementNamed(context, '/login');
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: CustomLogo(),
      ),
    );
  }
}