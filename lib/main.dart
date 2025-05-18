import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ongo_desk/app.dart';

void main() {

  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.white,
      statusBarBrightness: Brightness.light,
      statusBarIconBrightness: Brightness.dark
    )
  );
  
  runApp(App());
}