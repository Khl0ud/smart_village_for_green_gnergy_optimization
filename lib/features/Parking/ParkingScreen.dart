import 'package:flutter/material.dart';
// استيراد كافة الصفحات لضمان الربط المعماري الصحيح
import 'ParkingDashboardPage.dart';
import 'MakeReservationPage.dart';
import 'PaymentWalletPage.dart';
import 'ParkingSettingsPage.dart';
import 'FindMyCarPageState.dart';
import 'ShowReservationsPage.dart';
import 'ParkingSpacePage.dart';

class ParkingScreen {
  static const String dashboard = '/ParkingDashboardPage';
  static const String reservation = '/MakeReservationPage';
  static const String wallet = '/PaymentWalletPage';
  static const String settings = '/ParkingSettingsPage';
  static const String findCar = '/FindMyCarPageState';
  static const String bookings = '/ShowReservationsPage';
  static const String map = '/ParkingSpacePage';

  // دالة تجمع كافة المسارات مع تمرير zoneId للـ ParkingSpacePage
  static Map<String, WidgetBuilder> get routes => {
    dashboard: (context) => const ParkingDashboardPage(),
    reservation: (context) => const MakeReservationPage(),
    wallet: (context) => const PaymentWalletPage(),
    settings: (context) => const ParkingSettingsPage(),
    findCar: (context) => const FindMyCarPage(),
    bookings: (context) => const ShowReservationsPage(),
    // تمرير zoneId من الـ arguments إن وجدت، وإلا Zone 1 افتراضياً
    map: (context) {
      final args = ModalRoute.of(context)?.settings.arguments;
      final zoneId = (args is int) ? args : 1;
      return ParkingSpacePage(zoneId: zoneId);
    },
  };
}