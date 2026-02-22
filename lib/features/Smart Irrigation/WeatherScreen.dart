import 'package:flutter/material.dart';
import 'dart:ui';
// استيراد ملف الألوان المركزي لضمان توحيد الهوية البصرية
import 'package:smart_village_for_green_gnergy_optimization/core/theme/app_colors.dart';

class WeatherScreen extends StatelessWidget {
  // اسم المسار للربط في ملف main.dart والداشبورد
  static const String routeName = '/weather_forecast';

  const WeatherScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBg, // استخدام الخلفية الموحدة من ملفك
      body: Stack(
        children: [
          _buildBackgroundGradient(),
          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _buildHeader(context),
                const SizedBox(height: 10),
                _buildCurrentWeather(),
                const SizedBox(height: 35),
                _buildSectionTitle("7-Day Forecast"),
                const SizedBox(height: 15),
                _buildForecastList(),
                const SizedBox(height: 25),
                _buildAirQualityCard(),
                const SizedBox(height: 15),
                _buildWeatherDetailsGrid(),
              ],
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
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: AppColors.mainGradient, // استخدام التدرج الموحد من ملفك
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back_ios_new_rounded, color: AppColors.textLight, size: 22),
            onPressed: () => Navigator.pop(context),
          ),
          const Text(
            "Weather Forecast",
            style: TextStyle(color: AppColors.textLight, fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _buildCurrentWeather() {
    return Column(
      children: [
        const Text(
          "Asyut, Egypt",
          style: TextStyle(color: AppColors.textGrey, fontSize: 16, letterSpacing: 1.2),
        ),
        const SizedBox(height: 5),
        const Text(
          "23°C",
          style: TextStyle(color: AppColors.textLight, fontSize: 64, fontWeight: FontWeight.w900),
        ),
        const Text(
          "Partly Cloudy",
          style: TextStyle(color: AppColors.primaryNeon, fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        const Text(
          "H:24°  L:18°",
          style: TextStyle(color: AppColors.textGrey, fontSize: 16),
        ),
      ],
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          title,
          style: const TextStyle(color: AppColors.textLight, fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget _buildForecastList() {
    return SizedBox(
      height: 140,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        physics: const BouncingScrollPhysics(),
        children: const [
          ForecastCard(day: "Mon", temp: "19°", icon: Icons.wb_cloudy_rounded, active: true),
          ForecastCard(day: "Tue", temp: "18°", icon: Icons.ac_unit_rounded),
          ForecastCard(day: "Wed", temp: "18°", icon: Icons.wb_sunny_rounded),
          ForecastCard(day: "Thu", temp: "19°", icon: Icons.cloud_queue_rounded),
          ForecastCard(day: "Fri", temp: "20°", icon: Icons.wb_cloudy_rounded),
        ],
      ),
    );
  }

  Widget _buildAirQualityCard() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppColors.cardBg.withOpacity(0.4),
          borderRadius: BorderRadius.circular(25),
          border: Border.all(color: AppColors.cardBorder),
        ),
        child: Row(
          children: [
            Icon(Icons.air_rounded, color: AppColors.primaryNeon, size: 24),
            const SizedBox(width: 15),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text("AIR QUALITY", style: TextStyle(color: AppColors.textGrey, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1)),
                Text("3 - Low Health Risk", style: TextStyle(color: AppColors.textLight, fontSize: 16, fontWeight: FontWeight.bold)),
              ],
            ),
            const Spacer(),
            const Icon(Icons.arrow_forward_ios_rounded, color: AppColors.textGrey, size: 14),
          ],
        ),
      ),
    );
  }

  Widget _buildWeatherDetailsGrid() {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 15,
          mainAxisSpacing: 15,
          childAspectRatio: 1.4,
          children: [
            _buildGridDetail("SUNRISE", "5:28 AM", Icons.wb_twilight_rounded, subtitle: "Sunset: 7:25 PM"),
            _buildGridDetail("UV INDEX", "4 Moderate", Icons.wb_sunny_rounded),
            _buildGridDetail("HUMIDITY", "60%", Icons.water_drop_rounded),
            _buildGridDetail("WIND", "12 km/h", Icons.air_rounded),
          ],
        ),
      ),
    );
  }

  Widget _buildGridDetail(String title, String value, IconData icon, {String? subtitle}) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: AppColors.cardBg.withOpacity(0.3),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            children: [
              Icon(icon, color: AppColors.primaryNeon, size: 16),
              const SizedBox(width: 8),
              Text(title, style: const TextStyle(color: AppColors.textGrey, fontSize: 10, fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 8),
          Text(value, style: const TextStyle(color: AppColors.textLight, fontSize: 16, fontWeight: FontWeight.bold)),
          if (subtitle != null) ...[
            const SizedBox(height: 4),
            Text(subtitle, style: const TextStyle(color: AppColors.textGrey, fontSize: 10)),
          ],
        ],
      ),
    );
  }
}

class ForecastCard extends StatelessWidget {
  final String day;
  final String temp;
  final IconData icon;
  final bool active;

  const ForecastCard({super.key, required this.day, required this.temp, required this.icon, this.active = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 80,
      margin: const EdgeInsets.only(right: 12),
      decoration: BoxDecoration(
        color: active ? AppColors.primaryNeon.withOpacity(0.1) : AppColors.cardBg.withOpacity(0.3),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: active ? AppColors.primaryNeon.withOpacity(0.3) : AppColors.cardBorder),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(day, style: TextStyle(color: active ? AppColors.textLight : AppColors.textGrey, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          Icon(icon, color: active ? AppColors.primaryNeon : AppColors.textLight.withOpacity(0.7), size: 28),
          const SizedBox(height: 10),
          Text(temp, style: const TextStyle(color: AppColors.textLight, fontWeight: FontWeight.bold, fontSize: 16)),
        ],
      ),
    );
  }
}
