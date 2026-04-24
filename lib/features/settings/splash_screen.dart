import 'package:flutter/material.dart';
import 'dart:async';
// استيراد ملف الألوان المركزي من مجلد core
import 'package:smart_village_for_green_gnergy_optimization/core/theme/app_colors.dart';
import 'LoginScreen.dart'; 
import 'MainShell.dart';
import 'data/services/auth_service.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _startTransition();
  }

  // دالة ذكية تفحص حالة التوكن قبل الانتقال
  Future<void> _startTransition() async {
    final authService = AuthService();
    final token = await authService.getToken();

    // ننتظر 3 ثواني لعرض الـ Splash
    await Future.delayed(const Duration(seconds: 3));

    if (mounted) {
      if (token != null && token.isNotEmpty) {
        // لو في توكن، ادخل على الرئيسي علطول
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const MainShell()),
        );
      } else {
        // لو مفيش، روح لصفحة اللوجن
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const LoginScreen()),
        );
      }
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // استخدام الخلفية الداكنة الموحدة لمشروعك
      backgroundColor: AppColors.scaffoldBg, 
      body: Stack(
        children: [
          // عرض الصورة الخلفية
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/spbg.jpeg"), 
                fit: BoxFit.cover, 
              ),
            ),
          ),
          
          // إضافة مؤشر تحميل نيون ليعرف المستخدم أن التطبيق يعمل 
          Positioned(
            bottom: 60,
            left: 0,
            right: 0,
            child: Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(AppColors.primaryNeon),
                strokeWidth: 2,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
