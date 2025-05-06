import 'package:flutter/material.dart';
import 'package:ongo_desk/core/config/routes.dart';
import 'package:ongo_desk/core/config/theme.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'OngoDesk Civic Engagement',
      debugShowCheckedModeBanner: false,

      theme: AppTheme.lightTheme,
      initialRoute: '/',
      onGenerateRoute: AppRoutes.generateRoute,
    );
  }
}