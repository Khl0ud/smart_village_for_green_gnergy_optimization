import 'package:flutter/material.dart';
import 'package:smart_village_for_green_gnergy_optimization/core/theme/app_colors.dart';

// استيراد كافة الملفات المطلوبة للربط
import 'AlertsScreen.dart';
import 'FarmingControlScreen.dart';
import 'GardenLightingControl.dart';
import 'SettingsScreen.dart';
import 'WeatherScreen.dart';

class SmartIrrigationHub extends StatefulWidget {
  const SmartIrrigationHub({super.key});

  @override
  State<SmartIrrigationHub> createState() => _SmartIrrigationHubState();
}

class _SmartIrrigationHubState extends State<SmartIrrigationHub> {
  // متغيرات حالة النظام
  double temp = 23.0;
  double humidity = 35.0;
  double soilMoisture = 55.0;
  int waterLevel = 43;
  bool isPumpOn = false;
  bool gardenLight = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      body: Stack(
        children: [
          _buildGradientBackground(),
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(),
                  const SizedBox(height: 25),

                  // 1. نظام التنبيهات -> يفتح صفحة AlertsScreen
                  if (waterLevel <= 20 || true) // جعلتها true للعرض فقط
                    GestureDetector(
                      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const AlertsScreen())),
                      child: _buildAlertBanner("System Notifications (Tap to view)", AppColors.danger),
                    ),

                  const SizedBox(height: 20),

                  // 2. كارت رطوبة التربة -> يفتح FarmingControlScreen
                  GestureDetector(
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const FarmingControlScreen())),
                    child: _buildMainStatsGrid(),
                  ),

                  const SizedBox(height: 25),
                  _buildSectionTitle("System Control"),
                  const SizedBox(height: 15),

                  // 3. التحكم بالإضاءة والمضخة يدوياً
                  _buildControlGrid(),

                  const SizedBox(height: 30),

                  // 4. كروت التنقل للصفحات التفصيلية
                  _buildNavigationCards(),
                  const SizedBox(height: 50),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // دالة بناء كروت التنقل المربوطة فعلياً
  Widget _buildNavigationCards() {
    return Column(
      children: [
        // ربط صفحة الطقس
        _buildNavCard(
          "Weather Analysis",
          "Local garden forecast",
          Icons.cloud_queue,
              () => Navigator.push(context, MaterialPageRoute(builder: (context) => const WeatherScreen())),
        ),
        const SizedBox(height: 15),
        // ربط صفحة الإعدادات
        _buildNavCard(
          "System Settings",
          "Moisture & Thresholds",
          Icons.settings_suggest,
              () => Navigator.push(context, MaterialPageRoute(builder: (context) => const SettingsScreen())),
        ),
      ],
    );
  }

  // دالة التحكم بالإضاءة (GardenLightingControl)
  Widget _buildControlGrid() {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      mainAxisSpacing: 15,
      crossAxisSpacing: 15,
      childAspectRatio: 1.5,
      children: [
        _buildControlTile("Irrigation Pump", isPumpOn, Icons.water_drop, (v) => setState(() => isPumpOn = v)),
        // هنا يمكن استبدال هذا المربع بـ GardenLightingControl فعلياً
        _buildControlTile("Garden Lights", gardenLight, Icons.lightbulb, (v) => setState(() => gardenLight = v)),
      ],
    );
  }

  // --- دوائر التصميم الأساسية المسؤولة عن المظهر ---

  Widget _buildGradientBackground() => Container(decoration: const BoxDecoration(gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: AppColors.mainGradient)));

  Widget _buildHeader() => Padding(padding: const EdgeInsets.symmetric(vertical: 20), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: const [Text("Welcome Back, Loda", style: TextStyle(color: AppColors.textGrey, fontSize: 16)), Text("Garden Hub", style: TextStyle(color: AppColors.textLight, fontSize: 28, fontWeight: FontWeight.bold))]));

  Widget _buildAlertBanner(String message, Color color) => Container(margin: const EdgeInsets.only(bottom: 15), padding: const EdgeInsets.all(15), decoration: BoxDecoration(color: color.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(20), border: Border.all(color: color.withValues(alpha: 0.3))), child: Row(children: [Icon(Icons.warning_amber_rounded, color: color, size: 20), const SizedBox(width: 12), Text(message, style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 13))]));

  Widget _buildMainStatsGrid() => Row(children: [_buildStatTile("Temp", "${temp.toInt()}°C", Icons.thermostat, AppColors.warning), const SizedBox(width: 15), _buildStatTile("Soil", "${soilMoisture.toInt()}%", Icons.grass, AppColors.primaryNeon), const SizedBox(width: 15), _buildStatTile("Water", "$waterLevel%", Icons.waves, AppColors.info)]);

  Widget _buildStatTile(String label, String val, IconData icon, Color color) => Expanded(child: Container(padding: const EdgeInsets.all(15), decoration: BoxDecoration(color: AppColors.cardBg.withValues(alpha: 0.3), borderRadius: BorderRadius.circular(25), border: Border.all(color: AppColors.cardBorder)), child: Column(children: [Icon(icon, color: color, size: 22), const SizedBox(height: 10), Text(val, style: const TextStyle(color: AppColors.textLight, fontWeight: FontWeight.bold, fontSize: 18)), Text(label, style: const TextStyle(color: AppColors.textGrey, fontSize: 10))])));

  Widget _buildControlTile(String title, bool status, IconData icon, Function(bool) toggle) => Container(padding: const EdgeInsets.all(15), decoration: BoxDecoration(color: AppColors.cardBg.withValues(alpha: 0.4), borderRadius: BorderRadius.circular(25), border: Border.all(color: status ? AppColors.primaryNeon.withValues(alpha: 0.3) : AppColors.cardBorder)), child: Row(children: [Icon(icon, color: status ? AppColors.primaryNeon : AppColors.textGrey, size: 24), const SizedBox(width: 12), Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.center, children: [Text(title, style: const TextStyle(color: AppColors.textLight, fontSize: 12, fontWeight: FontWeight.bold)), Text(status ? "ON" : "OFF", style: TextStyle(color: status ? AppColors.primaryNeon : AppColors.textGrey, fontSize: 10))])), Switch(value: status, onChanged: toggle, activeColor: AppColors.primaryNeon, materialTapTargetSize: MaterialTapTargetSize.shrinkWrap)]));

  Widget _buildNavCard(String title, String subtitle, IconData icon, VoidCallback tap) => InkWell(onTap: tap, borderRadius: BorderRadius.circular(25), child: Container(padding: const EdgeInsets.all(20), decoration: BoxDecoration(color: Colors.black.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(25)), child: Row(children: [Icon(icon, color: AppColors.primaryNeon), const SizedBox(width: 20), Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(title, style: const TextStyle(color: AppColors.textLight, fontWeight: FontWeight.bold)), Text(subtitle, style: const TextStyle(color: AppColors.textGrey, fontSize: 12))]), const Spacer(), const Icon(Icons.arrow_forward_ios_rounded, color: AppColors.textGrey, size: 14)])));

  Widget _buildSectionTitle(String title) => Text(title, style: const TextStyle(color: AppColors.textLight, fontSize: 18, fontWeight: FontWeight.bold));
}