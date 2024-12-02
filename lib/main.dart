import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';

import 'Presentation/weather_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      theme: ThemeData.light(useMaterial3: false).copyWith(
        scaffoldBackgroundColor: Colors.blueGrey[50],
      ),
      debugShowCheckedModeBanner: false,
      home: WeatherScreen(),
    );
  }
}
