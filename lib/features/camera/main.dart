import 'package:flutter/material.dart';
import 'camera_screen.dart'; // تأكدي إن المسار صح حسب مكان الملف عندك

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // شلنا العلامة الحمراء اللي بتبقى فوق
      title: 'Smart City Surveillance',
      theme: ThemeData(
        brightness: Brightness.dark, // الثيم الغامق أفضل لرازي الراحة وشكل الكاميرات
        primarySwatch: Colors.green, // اللون الأساسي أخضر بما إنها Green Energy
        useMaterial3: true,
      ),
      home: CamerasScreen(),
    );
  }
}