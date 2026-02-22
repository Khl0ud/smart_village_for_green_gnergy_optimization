import 'package:flutter/material.dart';
import 'dart:ui';
// استيراد ملف الألوان المركزي الخاص بكِ لضمان الربط المعماري
import 'package:smart_village_for_green_gnergy_optimization/core/theme/app_colors.dart';

class GasSafetyPage extends StatefulWidget {
  // اسم المسار لربطه بالداشبورد لاحقاً
  static const String routeName = '/GasSafetyPage';
  const GasSafetyPage({super.key});

  @override
  State<GasSafetyPage> createState() => _GasSafetyPageState();
}

class _GasSafetyPageState extends State<GasSafetyPage> {
  // الحالات الافتراضية بناءً على تصميم النظام
  bool isSafe = true;
  bool autoProtection = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBg, // استخدام الخلفية الموحدة من ملفك
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: AppColors.textLight, size: 22),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Gas Safety System", // مطابق للصورة
          style: TextStyle(
            fontWeight: FontWeight.bold, 
            fontSize: 22, 
            color: AppColors.textLight,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // مؤشر حالة الغاز الدائري المتوهج
            _buildStatusIndicator(),
            const SizedBox(height: 30),
            
            Text(
              isSafe ? "Gas Levels Normal" : "GAS LEAK DETECTED", // مطابق للصورة
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppColors.textLight,
              ),
            ),
            const SizedBox(height: 50),

            // كارت التحكم بنظام الحماية التلقائي
            _buildAutoProtectionCard(),
            const SizedBox(height: 30),

            // زر فحص النظام بلون النيون أو الأحمر حسب الحالة
            _buildDiagnosticButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusIndicator() {
    return Container(
      padding: const EdgeInsets.all(40),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: (isSafe ? AppColors.success : AppColors.danger).withOpacity(0.05),
        border: Border.all(
          color: (isSafe ? AppColors.success : AppColors.danger).withOpacity(0.2),
          width: 2,
        ),
      ),
      child: Icon(
        isSafe ? Icons.check_circle_outline_rounded : Icons.warning_amber_rounded,
        size: 100,
        color: isSafe ? AppColors.success : AppColors.danger, // الربط مع حالات النجاح والخطر
      ),
    );
  }

  Widget _buildAutoProtectionCard() {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: AppColors.cardBg.withOpacity(0.3),
        borderRadius: BorderRadius.circular(25),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: SwitchListTile(
        title: const Text(
          "Enable Auto Protection System", // مطابق للصورة
          style: TextStyle(color: AppColors.textLight, fontWeight: FontWeight.w500, fontSize: 16),
        ),
        value: autoProtection,
        activeColor: AppColors.primaryNeon, // استخدام لون النيون الموحد
        onChanged: (value) => setState(() => autoProtection = value),
      ),
    );
  }

  Widget _buildDiagnosticButton() {
    return SizedBox(
      width: double.infinity,
      height: 60,
      child: ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          backgroundColor: isSafe ? AppColors.textLight : AppColors.danger, // الزر الأبيض مطابق للصورة
          foregroundColor: AppColors.textDark,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          elevation: 0,
        ),
        icon: Icon(isSafe ? Icons.bolt_rounded : Icons.notifications_off_rounded, size: 22),
        label: Text(
          isSafe ? "Test Gas System" : "Silence Alarm", // مطابق للصورة
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        onPressed: () {
          setState(() => isSafe = !isSafe);
        },
      ),
    );
  }
}
