import 'package:flutter/material.dart';
// استيراد ملف الألوان المركزي لضمان الربط المعماري للمشروع
import 'package:smart_village_for_green_gnergy_optimization/core/theme/app_colors.dart';

class StatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData? icon;
  final Color? color;

  const StatCard({
    super.key,
    required this.title,
    required this.value,
    this.icon,
    this.color,
  });
  // داخل ملف StatCard.dart
  @override
  Widget build(BuildContext context) {
    final themeColor = color ?? AppColors.primaryNeon;

    return Container(
      padding: const EdgeInsets.all(
        12,
      ), // تقليل الـ padding لزيادة المساحة الداخلية
      decoration: BoxDecoration(
        color: AppColors.cardBg.withOpacity(0.3),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.cardBorder, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min, // جعل الكارت يستهلك أقل مساحة ممكنة
        children: [
          if (icon != null)
            Icon(icon, color: themeColor, size: 20), // تقليل حجم الأيقونة
          const SizedBox(height: 8),
          Text(
            title,
            style: const TextStyle(color: AppColors.textGrey, fontSize: 11),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),
          FittedBox(
            // حماية القيمة من التداخل (Overflow)
            fit: BoxFit.scaleDown,
            child: Text(
              value,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
