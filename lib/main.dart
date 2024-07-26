import 'package:flutter/material.dart';
import "./weather_screen.dart";

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(
        useMaterial3: true,
      ).copyWith(
        //  custom THEMES
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        cardTheme: const CardTheme(
          elevation: 10,
          color: Color.fromARGB(255, 34, 33, 39),
        ),
      ),
      home: const WeatherScreen(),
    );
  }
}
