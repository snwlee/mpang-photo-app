import 'package:flutter/material.dart';
import 'package:mpang_photo_app/screens/home_screen.dart';

void main() async {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '대광교회 포토 슬라이드',
      theme: ThemeData(
        primaryColor: const Color(0xFF07104E),
        scaffoldBackgroundColor: Colors.white,
      ),
      home: const HomeScreen(),
    );
  }
}
