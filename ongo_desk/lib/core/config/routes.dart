import 'package:flutter/material.dart';
import 'package:ongo_desk/presentations/screens/auth/login_screen.dart';

class AppRoutes {
  static Route<dynamic> generateRoute(RouteSettings routeSettings) {
    switch (routeSettings.name) {
      case '/':
      return MaterialPageRoute(builder: (_) => const LoginScreen());

      default:
      return MaterialPageRoute(builder: (_) => const Scaffold(
        body: Center(
          child: Text("Page Not Found!"),
        ),
      ));
    }
  }
}