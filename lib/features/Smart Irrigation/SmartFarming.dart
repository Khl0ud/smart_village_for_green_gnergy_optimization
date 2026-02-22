import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// استيراد ملف الألوان المركزي لضمان توحيد الهوية البصرية لمشروعكِ
import 'package:smart_village_for_green_gnergy_optimization/core/theme/app_colors.dart';

// استيراد الصفحات الخاصة بنظام الزراعة والري الذكي
// تأكدي من مطابقة أسماء الملفات في مشروعكِ
import 'ControlScreen.dart';
import 'SmartIrrigationPage.dart';
import 'SettingsScreen.dart';

void main() {
  // ضبط إعدادات النظام وتثبيت الشاشة على الوضع الداكن المريح للعين
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
    ),
  );

  runApp(const SmartFarmingApp());
}

class SmartFarmingApp extends StatelessWidget {
  const SmartFarmingApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Smart Farming IoT', // مشروع خلود أسامة
      debugShowCheckedModeBanner: false,

      // إعداد الثيم العام بناءً على AppColors المعتمدة في مشروعكِ
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: AppColors.scaffoldBg,

        // إعدادات الألوان المتناسقة مع "الأسكرينات" المودرن
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.primaryNeon,
          brightness: Brightness.dark,
          primary: AppColors.primaryNeon,
          surface: AppColors.cardBg,
        ),

        // توحيد نمط الخطوط لتعزيز الطابع التقني للمشروع
        textTheme: const TextTheme(
          titleLarge: TextStyle(
            color: AppColors.textLight,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.1,
          ),
          titleMedium: TextStyle(
            color: AppColors.primaryNeon,
            fontWeight: FontWeight.w600,
          ),
          bodyMedium: TextStyle(color: AppColors.textGrey, height: 1.5),
        ),

        // تصميم شريط التطبيق العلوي الموحد (Transparent Glass Effect)
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
          titleTextStyle: TextStyle(
            color: AppColors.textLight,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
          iconTheme: IconThemeData(color: AppColors.textLight),
        ),

        // تصميم الأزرار الموحد (Stadium Shape) المعتمد في صورك
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primaryNeon,
            foregroundColor: AppColors.textDark,
            textStyle: const TextStyle(
              fontWeight: FontWeight.w900,
              letterSpacing: 1,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            elevation: 0,
          ),
        ),
      ),

      // تفعيل المسارات (Routes) للتنقل السلس بين أقسام الزراعة
      initialRoute: "/",
      routes: {
        "/": (context) => const ControlScreen(), // الشاشة الرئيسية للتحكم
        SmartIrrigationPage.routeName: (context) =>
            const SmartIrrigationPage(), // تفاصيل الري
        SettingsScreen.routeName: (context) =>
            const SettingsScreen(), // الإعدادات
      },
    );
  }
}
