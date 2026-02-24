import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// استيراد ملف الألوان المركزي لضمان توحيد الهوية البصرية لمشروعكِ
import 'package:smart_village_for_green_gnergy_optimization/core/theme/app_colors.dart';

// 1. استيراد صفحات النظام الأساسي والإعدادات
import 'features/settings/SettingsPage.dart';
import 'features/settings/ProfileScreen.dart';
import 'features/settings/notifications_page.dart';
import 'features/settings/sos_page.dart';
import 'features/settings/IntegrationPage.dart';
import 'features/settings/splash_screen.dart';
import 'features/settings/LoginScreen.dart';
import 'features/settings/MainShell.dart';

// 2. استيراد موديول الركن الذكي (Smart Parking)
import 'features/parking/ParkingScreen.dart';

// 3. استيراد موديول السمارت هوم (Smart Home) لربط صفحات الغاز والإضاءة
import 'features/Smart Home/SmartHomeDashboard.dart';
import 'features/Smart Home/LightingControlPage.dart';
import 'features/Smart Home/DoorControlPage.dart';
import 'features/Smart Home/FanControlPage.dart';
import 'features/Smart Home/ValveControlPage.dart';
import 'features/Smart Home/GasSafetyPage.dart';
import 'features/Smart Home/HomePage.dart';

void main() {
  // ضبط إعدادات النظام وتثبيت الاتجاهات لضمان أفضل أداء للـ IoT Dashboard
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
    ),
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Smart Village Project', // مشروع القرية الذكية خلود أسامة
      // إعداد الثيم العام بناءً على AppColors المعتمدة
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.primaryNeon,
          brightness: Brightness.dark,
          surface: AppColors.scaffoldBg,
        ),
        scaffoldBackgroundColor: AppColors.scaffoldBg,
        fontFamily: 'Poppins',
      ),

      // تعريف المسارات (Routes) لضمان انتقال سلس بين موديول الركن والمنزل
      initialRoute: '/',
      routes: {
        // --- مسارات الواجهة الرئيسية والإعدادات ---
        '/': (context) => const SplashScreen(),
        '/login': (context) => const LoginScreen(),
        '/main': (context) => const MainShell(),
        '/settings': (context) => const SettingsPage(),
        '/profile': (context) => const ProfileScreen(),
        '/notifications': (context) => const NotificationsPage(),
        '/sos': (context) => const SOS(),
        '/integration': (context) => const IntegrationPage(),

        // --- مسارات موديول السمارت هوم (Smart Residence) ---
        SmartHomeDashboard.routeName: (context) => const SmartHomeDashboard(),
        '/LightingControlPage': (context) => const LightingControlPage(),
        DoorControlPage.routeName: (context) => const DoorControlPage(),
        '/FanControlPage': (context) => const FanControlPage(),
        '/ValveControlPage': (context) => const ValveControlPage(),
        '/GasSafetyPage': (context) => const GasSafetyPage(),
        '/HomePage': (context) => const HomePage(),

        // --- دمج مسارات الركن الذكي (Parking Module) تلقائياً ---
        // سيقوم هذا السطر بتفعيل أزرار الحجز، المحفظة، وسجل الحجوزات
        ...ParkingScreen.routes,
      },
    );
  }
}
