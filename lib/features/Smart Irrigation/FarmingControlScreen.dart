import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';
// استيراد ملف الألوان المركزي لضمان توحيد الهوية البصرية لمشروعكِ
import 'package:smart_village_for_green_gnergy_optimization/core/theme/app_colors.dart';

class FarmingControlScreen extends StatefulWidget {
  const FarmingControlScreen({super.key});

  @override
  State<FarmingControlScreen> createState() => _FarmingControlScreenState();
}

class _FarmingControlScreenState extends State<FarmingControlScreen> {
  // متغيرات تمثل القراءات القادمة من ESP32
  double temperature = 23.0; // من حساس DHT11
  double humidity = 35.0; // من حساس DHT11
  double soilPercent = 0.55; // محسوبة من soilPercent (0.0 to 1.0)
  bool isPumpOn = false; // تعكس حالة RELAY_PIN
  bool isValveOpen = false; // تعكس حالة RELAY2_PIN

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
                children: [
                  const SizedBox(height: 30),
                  _buildHeader(),
                  const SizedBox(height: 30),

                  // 1. مؤشر الحرارة والرطوبة الجوية (DHT11 Data)
                  _buildWeatherStatusCard(),

                  const SizedBox(height: 20),

                  // 2. دائرة رطوبة التربة (Soil Moisture Circle)
                  _buildSoilMoistureSection(),

                  const SizedBox(height: 25),

                  // 3. حالة المضخة وصمام الخزان (Actuators Status)
                  _buildSystemStatusGrid(),

                  const SizedBox(height: 40),
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
          colors: AppColors.mainGradient, // استخدام تدرج مشروعك الرسمي
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return const Text(
      "Farming Control Center",
      style: TextStyle(
        color: AppColors.textLight,
        fontSize: 24,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  // يعرض القيم القادمة من حساس DHT11
  Widget _buildWeatherStatusCard() {
    return Container(
      padding: const EdgeInsets.all(25),
      decoration: BoxDecoration(
        color: AppColors.cardBg.withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "${temperature.toInt()}°C",
                style: const TextStyle(
                  color: AppColors.textLight,
                  fontSize: 32,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const Text(
                "Air Temperature",
                style: TextStyle(color: AppColors.textGrey, fontSize: 12),
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                "${humidity.toInt()}%",
                style: const TextStyle(
                  color: AppColors.info,
                  fontSize: 32,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const Text(
                "Air Humidity",
                style: TextStyle(color: AppColors.textGrey, fontSize: 12),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // يعرض النسبة المئوية لـ soilPercent
  Widget _buildSoilMoistureSection() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 30),
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.cardBg.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Column(
        children: [
          CircularPercentIndicator(
            radius: 70.0,
            lineWidth: 12.0,
            percent: soilPercent,
            center: Text(
              "${(soilPercent * 100).toInt()}%",
              style: const TextStyle(
                color: AppColors.textLight,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            progressColor: AppColors.primaryNeon,
            backgroundColor: Colors.white10,
            circularStrokeCap: CircularStrokeCap.round,
            animation: true,
          ),
          const SizedBox(height: 15),
          const Text(
            "Soil Moisture Level",
            style: TextStyle(
              color: AppColors.textGrey,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  // يعرض حالة RELAY_PIN و RELAY2_PIN
  Widget _buildSystemStatusGrid() {
    return Row(
      children: [
        _buildStatusTile(
          "Pump Status",
          isPumpOn ? "RUNNING" : "OFF",
          Icons.water_drop_rounded,
          isPumpOn ? AppColors.primaryNeon : AppColors.textGrey,
        ),
        const SizedBox(width: 15),
        _buildStatusTile(
          "Fill Valve",
          isValveOpen ? "OPENING" : "CLOSED",
          Icons.settings_input_component_rounded,
          isValveOpen ? AppColors.warning : AppColors.textGrey,
        ),
      ],
    );
  }

  Widget _buildStatusTile(
    String title,
    String status,
    IconData icon,
    Color statusColor,
  ) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppColors.cardBg.withValues(alpha: 0.4),
          borderRadius: BorderRadius.circular(25),
          border: Border.all(color: AppColors.cardBorder),
        ),
        child: Column(
          children: [
            Icon(icon, color: statusColor, size: 30),
            const SizedBox(height: 12),
            Text(
              title,
              style: const TextStyle(
                color: AppColors.textGrey,
                fontSize: 11,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              status,
              style: TextStyle(
                color: statusColor,
                fontWeight: FontWeight.w900,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
