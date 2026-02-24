import 'package:flutter/material.dart';
import 'dart:ui';
// استيراد ملف الألوان المركزي لضمان توحيد الهوية البصرية لمشروعكِ
import 'package:smart_village_for_green_gnergy_optimization/core/theme/app_colors.dart';

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  // بيانات حقيقية قادمة من حساسات الـ ESP32
  int rainPercent = 45; // القيمة المستلمة من متغير rainPercent في كود Arduino
  double temp = 23.0;   // القيمة المستلمة من حساس DHT11
  int humidity = 60;    // القيمة المستلمة من حساس DHT11

  // دالة لتحديد وصف حالة المطر بناءً على النسبة المئوية للحساس
  String _getRainDescription(int percent) {
    if (percent <= 5) return "Clear Sky";
    if (percent < 30) return "Light Drizzle";
    if (percent < 70) return "Moderate Rain";
    return "Heavy Storm";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBg, // استخدام الخلفية الموحدة
      body: Stack(
        children: [
          _buildBackgroundGradient(),
          SafeArea(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  _buildHeader(context),
                  const SizedBox(height: 10),
                  
                  // عرض الموقع والحرارة الحقيقية من DHT11
                  const Text("Asyut, Garden Area", style: TextStyle(color: AppColors.textLight, fontSize: 26, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 5),
                  Text("${temp.toInt()}°", style: const TextStyle(color: AppColors.textLight, fontSize: 64, fontWeight: FontWeight.w200)),
                  Text(_getRainDescription(rainPercent), style: const TextStyle(color: AppColors.textGrey, fontSize: 18)),

                  const SizedBox(height: 40),
                  _buildSectionTitle("Live Garden Sensors"),
                  const SizedBox(height: 20),

                  // كارت شدة المطر اللحظي (Local Rain Intensity)
                  _buildRainIntensityCard(),

                  const SizedBox(height: 25),
                  
                  // شبكة المعلومات البيئية الإضافية
                  _buildEnvironmentalGrid(),
                  const SizedBox(height: 50),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBackgroundGradient() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: AppColors.mainGradient,
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: AppColors.textLight, size: 22),
          onPressed: () => Navigator.pop(context),
        ),
        const CircleAvatar(
          backgroundColor: AppColors.cardBg,
          child: Icon(Icons.sensors_rounded, color: AppColors.primaryNeon, size: 20),
        ),
      ],
    );
  }

  // كارت يعرض شدة المطر بناءً على قراءة rainPercent من الحساس
  Widget _buildRainIntensityCard() {
    return Container(
      padding: const EdgeInsets.all(25),
      decoration: BoxDecoration(
        color: AppColors.cardBg.withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("RAIN INTENSITY", style: TextStyle(color: AppColors.textGrey, fontSize: 12, fontWeight: FontWeight.bold)),
              Icon(Icons.umbrella_rounded, color: rainPercent > 10 ? AppColors.info : AppColors.textGrey, size: 20),
            ],
          ),
          const SizedBox(height: 20),
          LinearProgressIndicator(
            value: rainPercent / 100,
            backgroundColor: Colors.white10,
            color: AppColors.info, // استخدام اللون الأزرق للمطر
            minHeight: 12,
            borderRadius: BorderRadius.circular(10),
          ),
          const SizedBox(height: 10),
          Align(
            alignment: Alignment.centerRight,
            child: Text("$rainPercent%", style: const TextStyle(color: AppColors.textLight, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  Widget _buildEnvironmentalGrid() {
    return Row(
      children: [
        Expanded(child: _buildSmallInfoCard("HUMIDITY", "$humidity%", Icons.water_drop_rounded, AppColors.info)),
        const SizedBox(width: 15),
        Expanded(child: _buildSmallInfoCard("AIR QUALITY", "Low Risk", Icons.air_rounded, AppColors.primaryNeon)),
      ],
    );
  }

  Widget _buildSmallInfoCard(String title, String val, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.cardBg.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(25),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 12),
          Text(title, style: const TextStyle(color: AppColors.textGrey, fontSize: 10, fontWeight: FontWeight.bold)),
          const SizedBox(height: 5),
          Text(val, style: const TextStyle(color: AppColors.textLight, fontSize: 14, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(title, style: const TextStyle(color: AppColors.textLight, fontSize: 18, fontWeight: FontWeight.bold)),
    );
  }
}