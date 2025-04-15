import 'package:flutter/material.dart';
import 'package:weather_app/weather_page.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(Object context) {
    return MaterialApp(debugShowCheckedModeBanner: false, home: WeatherPage());
  }
}
