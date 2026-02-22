import 'package:flutter/material.dart';
import 'dart:ui';
// استيراد ملف الألوان المركزي لضمان الربط المعماري
import 'package:smart_village_for_green_gnergy_optimization/core/theme/app_colors.dart';
// استيراد الصفحات الفرعية للربط البرمجي
import 'about_us_1_page.dart';
import 'about_us_2_page.dart';

class AboutUsPage extends StatelessWidget {
  const AboutUsPage({super.key});

  @override
  Widget build(BuildContext context) {
    // استخدام الألوان الموحدة من ملف AppColors
    const Color primaryNeon = AppColors.primaryNeon;

    return Scaffold(
      backgroundColor: AppColors.scaffoldBg, // توحيد الخلفية الداكنة
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "About Us",
          style: TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.bold,
            color: primaryNeon, // اللون النيون الموحد
            letterSpacing: 1.1,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          children: [
            const SizedBox(height: 50),

            // زر About Us 1 بتصميم Stadium Border والربط البرمجي
            _buildStadiumButton(
              context,
              title: "Our Mission",
              icon: Icons.auto_awesome_outlined,
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (_) => const AboutUs1Page()));
              },
            ),

            const SizedBox(height: 25),

            // زر About Us 2 بتصميم Stadium Border والربط البرمجي
            _buildStadiumButton(
              context,
              title: "Our Team",
              icon: Icons.groups_outlined,
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (_) => const AboutUs2Page()));
              },
            ),
          ],
        ),
      ),
    );
  }

  // ويدجت بناء الأزرار الكبيرة المنحنية (Stadium Shape) بتصميم Glassmorphism
  Widget _buildStadiumButton(
    BuildContext context, {
    required String title,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(50),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(50),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            width: double.infinity,
            height: 90, 
            decoration: BoxDecoration(
              // استخدام درجات الأسود المخضر الشفاف الموحد
              color: AppColors.cardBg.withOpacity(0.4),
              borderRadius: BorderRadius.circular(50),
              border: Border.all(color: AppColors.cardBorder, width: 1.2),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, color: AppColors.primaryNeon, size: 28),
                const SizedBox(width: 15),
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
