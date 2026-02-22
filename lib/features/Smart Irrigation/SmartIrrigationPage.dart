import 'package:flutter/material.dart';
import 'dart:ui';
// استيراد ملف الألوان المركزي الخاص بمشروعكِ
import 'package:smart_village_for_green_gnergy_optimization/core/theme/app_colors.dart';

class SmartIrrigationPage extends StatefulWidget {
  // اسم المسار للربط في ملف main.dart والداشبورد
  static const String routeName = '/SmartIrrigationPage';
  const SmartIrrigationPage({super.key});

  @override
  State<SmartIrrigationPage> createState() => _SmartIrrigationPageState();
}

class _SmartIrrigationPageState extends State<SmartIrrigationPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      body: Stack(
        children: [
          _buildBackgroundGradient(),
          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildHeader(context),

                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: Column(
                      children: [
                        const SizedBox(height: 20),
                        _buildMainStatusCard(),
                        const SizedBox(height: 35),
                        _buildDetailedInfoCard(),
                        const SizedBox(height: 35),
                        _buildWeeklySummary(),
                        const SizedBox(height: 40),
                        _buildActionButton(),
                        const SizedBox(height: 50),
                      ],
                    ),
                  ),
                ),
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
          colors: AppColors.mainGradient,
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Row(
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
            "Irrigation Details",
            style: TextStyle(
              color: AppColors.textLight,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMainStatusCard() {
    return Column(
      children: [
        Text(
          "Yesterday",
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.w900,
            color: AppColors.primaryNeon, // استخدام اللون النيون الموحد
            letterSpacing: 1.5,
            shadows: [
              Shadow(
                color: AppColors.primaryNeon.withOpacity(0.4),
                blurRadius: 20,
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          "Smart Irrigation Cycle",
          style: TextStyle(
            color: AppColors.textGrey,
            fontSize: 14,
            letterSpacing: 1.1,
          ),
        ),
      ],
    );
  }

  Widget _buildDetailedInfoCard() {
    return Container(
      padding: const EdgeInsets.all(25),
      decoration: BoxDecoration(
        color: AppColors.cardBg.withOpacity(0.4), // تأثير زجاجي معتمد
        borderRadius: BorderRadius.circular(35),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Column(
        children: [
          _buildInfoRow(
            Icons.eco_rounded,
            "Water Saved",
            "10 Mins",
            AppColors.success,
          ),
          const Divider(color: Colors.white10, height: 40),
          _buildInfoRow(
            Icons.access_time_filled_rounded,
            "Start Time",
            "5:00 AM",
            AppColors.info,
          ),
          const SizedBox(height: 20),
          _buildInfoRow(
            Icons.timer_rounded,
            "Cycle Length",
            "10 Mins",
            AppColors.warning,
          ),
          const Divider(color: Colors.white10, height: 40),
          _buildInfoRow(
            Icons.water_drop_rounded,
            "Water Used",
            "224 L",
            AppColors.primaryNeon,
            isHighlight: true,
          ),
          const SizedBox(height: 20),
          _buildInfoRow(
            Icons.bolt_rounded,
            "System Current",
            "240 mA",
            AppColors.info,
          ),
        ],
      ),
    );
  }

  Widget _buildWeeklySummary() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.glassWhite,
        borderRadius: BorderRadius.circular(25),
      ),
      child: const Text(
        "20 mins watering this week, 50% less than normal.\nTotal water usage: 454 liters",
        textAlign: TextAlign.center,
        style: TextStyle(color: AppColors.textGrey, fontSize: 13, height: 1.6),
      ),
    );
  }

  Widget _buildActionButton() {
    return SizedBox(
      height: 65,
      width: double.infinity,
      child: ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryNeon,
          foregroundColor: AppColors.textDark,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          elevation: 0,
        ),
        onPressed: () {},
        icon: const Icon(Icons.play_circle_filled_rounded, size: 28),
        label: const Text(
          "START IRRIGATION",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w900,
            letterSpacing: 1.2,
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(
    IconData icon,
    String label,
    String value,
    Color iconColor, {
    bool isHighlight = false,
  }) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: iconColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(15),
          ),
          child: Icon(icon, color: iconColor, size: 22),
        ),
        const SizedBox(width: 15),
        Text(
          label,
          style: const TextStyle(
            color: AppColors.textGrey,
            fontSize: 15,
            fontWeight: FontWeight.w500,
          ),
        ),
        const Spacer(),
        Text(
          value,
          style: TextStyle(
            color: isHighlight ? AppColors.primaryNeon : AppColors.textLight,
            fontSize: 17,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
