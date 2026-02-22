import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// استيراد ملف الألوان المركزي من مجلد core لضمان الربط
import 'package:smart_village_for_green_gnergy_optimization/core/theme/app_colors.dart';
import 'HomeDashboardPage.dart';

/// ====================== MainShell الرئيسي الموحد ======================
/// هذا الملف يعمل كـ Wrapper أساسي لواجهة التطبيق
class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  
  @override
  void initState() {
    super.initState();
    // ضبط شفافية شريط الحالة ليتناسب مع التصميم الداكن للمشروع
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
    ));
  }

  @override
  Widget build(BuildContext context) {
    // استخدام Scaffold لضمان دعم الـ SafeArea والـ Layout بشكل صحيح
    return Scaffold(
      backgroundColor: AppColors.scaffoldBg, // توحيد الخلفية الداكنة للمشروع
      body: const HomeDashboardPage(), // عرض صفحة الـ Dashboard مباشرة
    );
  }
}
