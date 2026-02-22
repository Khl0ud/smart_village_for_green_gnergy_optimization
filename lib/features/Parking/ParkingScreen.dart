import 'package:flutter/material.dart';
// استيراد كافة الصفحات لضمان الربط المعماري الصحيح
import 'ParkingDashboardPage.dart';
import 'MakeReservationPage.dart';
import 'PaymentWalletPage.dart';
import 'ParkingSettingsPage.dart';
import 'FindMyCarPageState.dart'; // تأكدي أن اسم الملف مطابق لما في جهازك
import 'ShowReservationsPage.dart';
import 'ParkingSpacePage.dart';

class ParkingScreen {
  // هذه الأسماء هي "المفاتيح" الثابتة التي تضمن استجابة الأزرار عند الضغط
  static const String dashboard = '/ParkingDashboardPage';
  static const String reservation = '/MakeReservationPage';
  static const String wallet = '/PaymentWalletPage';
  static const String settings = '/ParkingSettingsPage';
  static const String findCar = '/FindMyCarPageState'; // تم توحيد المسمى ليتطابق مع صفحة الموقع
  static const String bookings = '/ShowReservationsPage';
  static const String map = '/ParkingSpacePage';

  // دالة تجمع كافة المسارات لتسجيلها في ملف main.dart دفعة واحدة
  static Map<String, WidgetBuilder> get routes => {
    dashboard: (context) => const ParkingDashboardPage(),
    reservation: (context) => const MakeReservationPage(),
    wallet: (context) => const PaymentWalletPage(),
    settings: (context) => const ParkingSettingsPage(),
    findCar: (context) => const FindMyCarPage(),
    bookings: (context) => const ShowReservationsPage(),
    map: (context) => const ParkingSpacePage(),
  };
}