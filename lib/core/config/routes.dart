import 'package:flutter/material.dart';
import 'package:ongo_desk/presentation/screens/auth/login_screen.dart';
import 'package:ongo_desk/presentation/screens/auth/signup_screen.dart';
import 'package:ongo_desk/presentation/screens/dashboard/dashboard_screen.dart';
// import 'package:ongo_desk/presentation/screens/splash/splash_screen.dart';

class AppRoutes {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => DashboardScreen());

      case '/login':
        return MaterialPageRoute(builder: (_) => const LoginScreen());

      case '/signup':
        return MaterialPageRoute(builder: (_) => const SignupScreen());

      default:
        return MaterialPageRoute(
          builder:
              (_) =>
                  const Scaffold(body: Center(child: Text('Page not found!'))),
        );
    }
  }
}
