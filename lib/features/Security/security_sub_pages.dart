import 'package:flutter/material.dart';
import 'dart:ui';
// استيراد ملف الألوان المركزي لضمان الربط المعماري
import 'package:smart_village_for_green_gnergy_optimization/core/theme/app_colors.dart';

// ---------------- SUB PAGES ----------------
// هذه الصفحات تستدعي القالب الموحد لتقليل تكرار الكود

class ChangePasswordPage extends StatelessWidget {
  const ChangePasswordPage({super.key});

  @override
  Widget build(BuildContext context) {
    return _buildSubPageTemplate(context, "Change Password", Icons.lock_reset_rounded);
  }
}

class TwoFactorPage extends StatelessWidget {
  const TwoFactorPage({super.key});

  @override
  Widget build(BuildContext context) {
    return _buildSubPageTemplate(context, "Two-factor Auth (2FA)", Icons.verified_user_rounded);
  }
}

class AppPasswordPage extends StatelessWidget {
  const AppPasswordPage({super.key});

  @override
  Widget build(BuildContext context) {
    return _buildSubPageTemplate(context, "App Password", Icons.vpn_key_rounded);
  }
}

class HelpSupport1Page extends StatelessWidget {
  const HelpSupport1Page({super.key});

  @override
  Widget build(BuildContext context) {
    return _buildSubPageTemplate(context, "Help & Support", Icons.support_agent_rounded);
  }
}

// =============================================================
// ويدجت القالب الموحد لجميع الصفحات الفرعية (Modern Dark Forest)
// تم ربطه بملف AppColors لضمان وحدة الهوية البصرية
// =============================================================

Widget _buildSubPageTemplate(BuildContext context, String title, IconData icon) {
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
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.bold,
          color: AppColors.primaryNeon, // اللون الأخضر النيون الموحد
          letterSpacing: 1.1,
        ),
      ),
    ),
    body: Padding(
      padding: const EdgeInsets.all(24.0),
      child: Center(
        child: ClipRRect(
          borderRadius: BorderRadius.circular(30),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(35),
              decoration: BoxDecoration(
                // تأثير الشفافية الزجاجي المطور
                color: AppColors.cardBg.withOpacity(0.3),
                borderRadius: BorderRadius.circular(30),
                border: Border.all(color: AppColors.cardBorder),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // أيقونة الحالة داخل دائرة نيون خفيفة
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: AppColors.primaryNeon.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      icon, // أيقونة متغيرة حسب نوع الصفحة
                      size: 60,
                      color: AppColors.primaryNeon,
                    ),
                  ),
                  const SizedBox(height: 30),
                  Text(
                    "$title module is being integrated.",
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 15),
                  Text(
                    "This feature will allow remote management of village systems securely.",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: AppColors.textGrey, fontSize: 14, height: 1.4),
                  ),
                  const SizedBox(height: 30),
                  // مؤشر تحميل نيون ليعطي انطباعاً تقنياً حياً
                  const CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(AppColors.primaryNeon),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    ),
  );
}
