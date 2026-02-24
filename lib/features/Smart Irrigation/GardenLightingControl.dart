import 'package:flutter/material.dart';
// استيراد ملف الألوان المركزي لضمان توحيد الهوية البصرية
import 'package:smart_village_for_green_gnergy_optimization/core/theme/app_colors.dart';

class GardenLightingControl extends StatefulWidget {
  const GardenLightingControl({super.key});

  @override
  State<GardenLightingControl> createState() => _GardenLightingControlState();
}

class _GardenLightingControlState extends State<GardenLightingControl> {
  // متغير يعكس حالة LDR_RELAY القادمة من الـ ESP32
  bool isGardenLightOn = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(25),
      decoration: BoxDecoration(
        color: AppColors.cardBg.withValues(alpha: 0.4), // تأثير زجاجي نيون
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Row(
        children: [
          // أيقونة "اللمبة" التفاعلية
          _buildAnimatedBulb(),
          const SizedBox(width: 25),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "GARDEN LIGHTS",
                  style: TextStyle(color: AppColors.textGrey, fontSize: 12, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 5),
                Text(
                  isGardenLightOn ? "Lights Active" : "Daylight Mode",
                  style: const TextStyle(color: AppColors.textLight, fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 5),
                Text(
                  isGardenLightOn ? "Controlled by LDR Sensor" : "System in standby",
                  style: const TextStyle(color: AppColors.textGrey, fontSize: 10),
                ),
              ],
            ),
          ),
          // زر للتحكم اليدوي السريع
          Switch(
            value: isGardenLightOn,
            onChanged: (v) => setState(() => isGardenLightOn = v),
            activeColor: AppColors.primaryNeon,
          ),
        ],
      ),
    );
  }

  // ويدجت اللمبة التي تتوهج باللون النيون
  Widget _buildAnimatedBulb() {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 500),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: isGardenLightOn ? AppColors.primaryNeon.withValues(alpha: 0.1) : Colors.white10,
        shape: BoxShape.circle,
        boxShadow: isGardenLightOn 
          ? [BoxShadow(color: AppColors.primaryNeon.withValues(alpha: 0.3), blurRadius: 15, spreadRadius: 2)]
          : [],
      ),
      child: Icon(
        isGardenLightOn ? Icons.lightbulb_rounded : Icons.lightbulb_outline_rounded,
        color: isGardenLightOn ? AppColors.primaryNeon : AppColors.textGrey,
        size: 32,
      ),
    );
  }
}