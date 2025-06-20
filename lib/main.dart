import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ongo_desk/app/app.dart';
import 'package:ongo_desk/app/get_it/service_locator.dart';
import 'package:ongo_desk/core/network/hive_service.dart';

void main() async {

  WidgetsFlutterBinding.ensureInitialized();

  await initDependencies();

  await HiveService().init();

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.white,
      statusBarBrightness: Brightness.light,
      statusBarIconBrightness: Brightness.dark
    )
  );
  
  runApp(App());
}