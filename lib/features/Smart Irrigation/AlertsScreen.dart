import 'package:flutter/material.dart';
// استيراد ملف الألوان المركزي لضمان توحيد الهوية البصرية
import 'package:smart_village_for_green_gnergy_optimization/core/theme/app_colors.dart';

class AlertsScreen extends StatefulWidget {
  const AlertsScreen({super.key});

  @override
  State<AlertsScreen> createState() => _AlertsScreenState();
}

class _AlertsScreenState extends State<AlertsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBg, // استخدام الخلفية الموحدة
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: AppColors.mainGradient, // استخدام تدرج مشروعك الرسمي
          ),
        ),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildAppBar(context),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Text(
                  "System Notifications",
                  style: TextStyle(
                    color: AppColors.textLight, // اللون الفاتح المعتمد
                    fontSize: 24, 
                    fontWeight: FontWeight.bold
                  ),
                ),
              ),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.all(20),
                  children: [
                    // 1. تنبيه انخفاض المياه (بناءً على شرط waterPercent <= 20)
                    _buildAlertCard(
                      title: "Critical Water Level!",
                      message: "Warning: Water level is critically low - 20%! Fill the tank now.",
                      time: "Just Now",
                      icon: Icons.warning_amber_rounded,
                      accentColor: AppColors.danger, // استخدام لون التحذير الأحمر
                      isCritical: true,
                    ),
                    
                    const SizedBox(height: 15),

                    // 2. تنبيه المطر (بناءً على شرط isRaining)
                    _buildAlertCard(
                      title: "Rain Detected",
                      message: "System protected. Components secured by Servo mechanism.",
                      time: "10 mins ago",
                      icon: Icons.umbrella_rounded,
                      accentColor: AppColors.info, // استخدام اللون الأزرق للمعلومات
                      isCritical: false,
                    ),

                    const SizedBox(height: 15),

                    // تنبيه حالة المضخة
                    _buildAlertCard(
                      title: "Pump Status",
                      message: "Irrigation completed successfully. Total water: 12L.",
                      time: "2 hours ago",
                      icon: Icons.check_circle_outline_rounded,
                      accentColor: AppColors.primaryNeon, // استخدام اللون النيون للنجاح
                      isCritical: false,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: IconButton(
        icon: const Icon(Icons.arrow_back_ios_new, color: AppColors.textLight),
        onPressed: () => Navigator.pop(context),
      ),
    );
  }

  Widget _buildAlertCard({
    required String title,
    required String message,
    required String time,
    required IconData icon,
    required Color accentColor,
    required bool isCritical,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.cardBg.withOpacity(0.3), // تأثير زجاجي نيون
        borderRadius: BorderRadius.circular(25),
        border: Border.all(
          color: isCritical ? accentColor.withOpacity(0.5) : AppColors.cardBorder, // حدود نيون
          width: isCritical ? 2 : 1,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            backgroundColor: accentColor.withOpacity(0.1),
            child: Icon(icon, color: accentColor),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(title, style: TextStyle(color: accentColor, fontWeight: FontWeight.bold, fontSize: 16)),
                    Text(time, style: const TextStyle(color: AppColors.textGrey, fontSize: 12)),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  message,
                  style: const TextStyle(color: AppColors.textGrey, fontSize: 14, height: 1.4),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}