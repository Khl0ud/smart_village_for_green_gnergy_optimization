import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';
// استيراد ملف الألوان المركزي الخاص بمشروعكِ لضمان الربط المعماري
import 'package:smart_village_for_green_gnergy_optimization/core/theme/app_colors.dart';

class ControlScreen extends StatefulWidget {
  // اسم المسار للربط في ملف main.dart والداشبورد
  static const String routeName = '/irrigation_control_center';
  const ControlScreen({super.key});

  @override
  State<ControlScreen> createState() => _ControlScreenState();
}

class _ControlScreenState extends State<ControlScreen> {
  // قراءات الحساسات بناءً على تصميم صورتك
  double humidity = 0.35;
  double temperature = 0.65;
  double soilMoisture = 0.55;

  bool isAutoModeOn = false;
  bool isManualModeOn = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBg, // استخدام الخلفية الموحدة من ملفك
      body: Stack(
        children: [
          _buildBackgroundGradient(),
          SafeArea(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(context),
                  const SizedBox(height: 30),

                  // كارت الطقس (Weather Card) مطابق للصورة
                  _buildWeatherCard(),
                  const SizedBox(height: 25),

                  // مؤشرات الرطوبة والحرارة الدائرية الملونة
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildCircularIndicator(
                        "Humidity",
                        humidity,
                        Icons.water_drop_rounded,
                        AppColors.info,
                      ),
                      _buildCircularIndicator(
                        "Temperature",
                        temperature,
                        Icons.thermostat_rounded,
                        AppColors.warning,
                      ),
                    ],
                  ),
                  const SizedBox(height: 25),

                  // كارت رطوبة التربة (Soil Moisture)
                  _buildSoilMoistureCard(),
                  const SizedBox(height: 25),

                  // أزرار التحكم (Toggle Switches)
                  _buildControlSwitches(),
                  const SizedBox(height: 25),

                  // سجل الري المختصر (Recent Activity)
                  _buildIrrigationHistoryPreview(),
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
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: AppColors.mainGradient,
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              IconButton(
                icon: const Icon(
                  Icons.arrow_back_ios_new_rounded,
                  color: AppColors.textLight,
                  size: 22,
                ),
                onPressed: () => Navigator.pop(context),
              ),
              const Text(
                "Smart Farming",
                style: TextStyle(
                  color: AppColors.textLight,
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const Padding(
            padding: EdgeInsets.only(left: 48),
            child: Text(
              "Irrigation Control Center",
              style: TextStyle(color: AppColors.textGrey, fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWeatherCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.cardBg.withOpacity(0.4),
        borderRadius: BorderRadius.circular(25),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "23°C",
                style: TextStyle(
                  color: AppColors.primaryNeon,
                  fontSize: 32,
                  fontWeight: FontWeight.w900,
                ),
              ),
              Text(
                "Partly Cloudy",
                style: TextStyle(color: AppColors.textLight, fontSize: 14),
              ),
              Text(
                "Asyut, Egypt",
                style: TextStyle(color: AppColors.textGrey, fontSize: 12),
              ),
            ],
          ),
          Icon(
            Icons.cloud_queue_rounded,
            color: AppColors.primaryNeon,
            size: 50,
          ),
        ],
      ),
    );
  }

  Widget _buildCircularIndicator(
    String label,
    double value,
    IconData icon,
    Color color,
  ) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.43,
      padding: const EdgeInsets.symmetric(vertical: 20),
      decoration: BoxDecoration(
        color: AppColors.cardBg.withOpacity(0.3),
        borderRadius: BorderRadius.circular(25),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: CircularPercentIndicator(
        radius: 50.0,
        lineWidth: 8.0,
        percent: value,
        animation: true,
        circularStrokeCap: CircularStrokeCap.round,
        backgroundColor: Colors.white10,
        progressColor: color,
        center: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "${(value * 100).toInt()}%",
              style: const TextStyle(
                color: AppColors.textLight,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              label,
              style: const TextStyle(color: AppColors.textGrey, fontSize: 10),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSoilMoistureCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.cardBg.withOpacity(0.3),
        borderRadius: BorderRadius.circular(25),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Soil Moisture",
                style: TextStyle(
                  color: AppColors.textLight,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Icon(Icons.water_drop, color: AppColors.info, size: 18),
            ],
          ),
          const SizedBox(height: 15),
          LinearPercentIndicator(
            lineHeight: 12.0,
            percent: soilMoisture,
            backgroundColor: Colors.white10,
            progressColor: AppColors.primaryNeon,
            barRadius: const Radius.circular(10),
            padding: EdgeInsets.zero,
            animation: true,
          ),
          const SizedBox(height: 8),
          Align(
            alignment: Alignment.centerRight,
            child: Text(
              "${(soilMoisture * 100).toInt()}%",
              style: const TextStyle(color: AppColors.textGrey, fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildControlSwitches() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.cardBg.withOpacity(0.3),
        borderRadius: BorderRadius.circular(25),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Column(
        children: [
          _customSwitch(
            "Auto Irrigation",
            "System handles watering",
            isAutoModeOn,
            (val) => setState(() => isAutoModeOn = val),
          ),
          Divider(color: AppColors.cardBorder, height: 1),
          _customSwitch(
            "Manual Water",
            "Turn on pump manually",
            isManualModeOn,
            (val) => setState(() => isManualModeOn = val),
          ),
        ],
      ),
    );
  }

  Widget _customSwitch(
    String title,
    String sub,
    bool value,
    Function(bool) onChanged,
  ) {
    return SwitchListTile(
      title: Text(
        title,
        style: const TextStyle(
          color: AppColors.textLight,
          fontSize: 15,
          fontWeight: FontWeight.w500,
        ),
      ),
      subtitle: Text(
        sub,
        style: const TextStyle(color: AppColors.textGrey, fontSize: 12),
      ),
      value: value,
      activeColor: AppColors.primaryNeon,
      inactiveTrackColor: AppColors.glassWhite,
      onChanged: onChanged,
    );
  }

  Widget _buildIrrigationHistoryPreview() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Recent Activity",
          style: TextStyle(
            color: AppColors.textLight,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 15),
        _buildHistoryItem("Today, 2:00 PM", "12 Liters", true),
        const SizedBox(height: 10),
        _buildHistoryItem("Yesterday, 10:00 AM", "15 Liters", true),
      ],
    );
  }

  Widget _buildHistoryItem(String time, String amount, bool success) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: AppColors.cardBg.withOpacity(0.2),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Row(
        children: [
          Icon(Icons.check_circle, color: AppColors.success, size: 20),
          const SizedBox(width: 15),
          Text(
            time,
            style: const TextStyle(color: AppColors.textLight, fontSize: 14),
          ),
          const Spacer(),
          Text(
            amount,
            style: const TextStyle(color: AppColors.textGrey, fontSize: 14),
          ),
        ],
      ),
    );
  }
}
