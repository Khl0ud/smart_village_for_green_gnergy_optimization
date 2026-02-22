import 'package:flutter/material.dart';
import 'dart:ui';
// استيراد ملف الألوان المركزي لضمان الربط المعماري للمشروع
import 'package:smart_village_for_green_gnergy_optimization/core/theme/app_colors.dart';

// =============================================================
// الصفحات الفرعية باستخدام القالب الموحد لضمان التناسق البصري
// =============================================================

class CustomerServicePage extends StatelessWidget {
  const CustomerServicePage({super.key});
  @override
  Widget build(BuildContext context) => _buildSupportPageTemplate(
    context,
    "Customer Service",
    "Start a live chat session with our support team",
    Icons.headset_mic_rounded,
  );
}

class WhatsAppPage extends StatelessWidget {
  const WhatsAppPage({super.key});
  @override
  Widget build(BuildContext context) => _buildSupportPageTemplate(
    context,
    "WhatsApp",
    "Send a message directly to our WhatsApp support",
    Icons.chat_rounded,
  );
}

class EmailPage extends StatelessWidget {
  const EmailPage({super.key});
  @override
  Widget build(BuildContext context) => _buildSupportPageTemplate(
    context,
    "Email",
    "Send your inquiries via official email",
    Icons.email_rounded,
  );
}

class FacebookPage extends StatelessWidget {
  const FacebookPage({super.key});
  @override
  Widget build(BuildContext context) => _buildSupportPageTemplate(
    context,
    "Facebook",
    "Follow our latest Smart Village updates",
    Icons.facebook_rounded,
  );
}

// =============================================================
// ويدجت القالب الموحد لجميع صفحات الدعم (Modern Glassmorphism)
// تم ربطه بملف AppColors لضمان وحدة الهوية البصرية
// =============================================================

Widget _buildSupportPageTemplate(
  BuildContext context,
  String title,
  String subtitle,
  IconData icon,
) {
  // استخدام الألوان الموحدة من ملف AppColors
  const Color primaryNeon = AppColors.primaryNeon;
  const Color cardBg = AppColors.cardBg;

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
          color: primaryNeon, // اللون الأخضر النيون الموحد
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
                // تأثير الشفافية الزجاجي المعتمد في المشروع
                color: cardBg.withOpacity(0.3),
                borderRadius: BorderRadius.circular(30),
                border: Border.all(color: AppColors.cardBorder),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // أيقونة الخدمة داخل تأثير توهج نيون خفيف
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: primaryNeon.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(icon, size: 70, color: primaryNeon),
                  ),
                  const SizedBox(height: 30),
                  Text(
                    subtitle,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 15),
                  const Text(
                    "Our technical support team is ready to assist you with Smart Village systems.",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: AppColors.textGrey, fontSize: 14, height: 1.4),
                  ),
                  const SizedBox(height: 30),
                  // زر تفاعلي للبدء (اختياري) لتعزيز تجربة المستخدم
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryNeon.withOpacity(0.1),
                      side: const BorderSide(color: primaryNeon),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                    ),
                    child: const Text("Contact Now", style: TextStyle(color: primaryNeon, fontWeight: FontWeight.bold)),
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
