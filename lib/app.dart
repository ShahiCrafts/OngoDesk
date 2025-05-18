import 'package:flutter/material.dart';
import 'package:ongo_desk/core/config/routes.dart';
import 'package:ongo_desk/core/config/theme.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '.OnGo Desk Civic Engagement Platform',
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      theme: AppTheme.lightTheme,
      onGenerateRoute: AppRoutes.generateRoute,
    );
  }
}