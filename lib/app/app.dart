import 'package:flutter/material.dart';
import 'package:ongo_desk/app/theme/app_theme.dart';
import 'package:ongo_desk/app/config/routes.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '.OnGo Desk Civic Engagement Platform',
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      theme: AppTheme.getAppTheme(isDarkMode: false),
      onGenerateRoute: AppRoutes.generateRoute,
    );
  }
}