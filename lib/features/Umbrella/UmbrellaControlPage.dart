import 'package:flutter/material.dart';
import 'dart:ui';
// استيراد ملف الألوان المركزي لضمان توحيد الهوية البصرية لمشروعكِ
import 'package:smart_village_for_green_gnergy_optimization/core/theme/app_colors.dart';

class UmbrellaControlPage extends StatefulWidget {
  // اسم المسار للربط في ملف main.dart والداشبورد
  static const String routeName = '/UmbrellaControlPage';
  const UmbrellaControlPage({super.key});

  @override
  State<UmbrellaControlPage> createState() => _UmbrellaControlPageState();
}

class _UmbrellaControlPageState extends State<UmbrellaControlPage> {
  bool isOn = true; // حالة المظلة (مفتوحة/مغلقة)
  bool isAuto = false; // وضع التشغيل التلقائي

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBg, // استخدام الخلفية الموحدة من ملفكِ
      body: Stack(
        children: [
          _buildBackgroundGradient(),
          SafeArea(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                children: [
                  _buildModernHeader(context),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                    child: Column(
                      children: [
                        _buildPageTitles(),
                        const SizedBox(height: 40),
                        
                        // عرض حالة المظلة بصورة تفاعلية مع هالة ضوئية
                        _buildUmbrellaDisplay(),
                        const SizedBox(height: 40),

                        // زر التشغيل المركزي بتأثير نيون
                        _buildPowerButton(),
                        const SizedBox(height: 50),

                        // بطاقة الإحصائيات والتحكم التلقائي بتصميم زجاجي
                        _buildStatsCard(),
                        const SizedBox(height: 30),
                      ],
                    ),
                  ),
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
          colors: AppColors.mainGradient, // استخدام التدرج الموحد
        ),
      ),
    );
  }

  Widget _buildModernHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back_ios_new_rounded, color: AppColors.textLight, size: 22),
            onPressed: () => Navigator.pop(context), // العودة للداشبورد الرئيسي
          ),
          IconButton(
            icon: const Icon(Icons.schedule_rounded, color: AppColors.textLight),
            onPressed: () => _showTimeSettingsDialog(context), // فتح إعدادات الوقت
          ),
        ],
      ),
    );
  }

  Widget _buildPageTitles() {
    return Column(
      children: const [
        Text(
          "Smart Umbrella", // مطابق لعنوان صورتك
          style: TextStyle(color: AppColors.textLight, fontSize: 28, fontWeight: FontWeight.bold, letterSpacing: 1.1),
        ),
        Text(
          "Outdoor Shading System",
          style: TextStyle(color: AppColors.textGrey, fontSize: 14),
        ),
      ],
    );
  }

  Widget _buildUmbrellaDisplay() {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          height: 180,
          width: 180,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: (isOn ? AppColors.primaryNeon : AppColors.danger).withOpacity(0.15),
                blurRadius: 100,
                spreadRadius: 20,
              ),
            ],
          ),
        ),
        Image.network(
          isOn 
              ? "https://static.vecteezy.com/system/resources/previews/036/130/673/original/ai-generated-black-umbrella-isolated-on-transparent-background-umbrella-generative-ai-png.png"
              : "https://th.bing.com/th/id/R.d9731dc3bd088fa009e8fd360d515197?rik=KHgwM2jN2E9toQ&pid=ImgRaw&r=0",
          height: 220,
          fit: BoxFit.contain,
        ),
      ],
    );
  }

  Widget _buildPowerButton() {
    return GestureDetector(
      onTap: () => setState(() => isOn = !isOn),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.all(25),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: isOn ? AppColors.primaryNeon.withOpacity(0.1) : AppColors.danger.withOpacity(0.05),
          border: Border.all(color: isOn ? AppColors.primaryNeon : AppColors.danger, width: 2),
          boxShadow: [
            BoxShadow(
              color: (isOn ? AppColors.primaryNeon : AppColors.danger).withOpacity(0.3),
              blurRadius: 30,
              spreadRadius: 5,
            ),
          ],
        ),
        child: Icon(
          Icons.power_settings_new_rounded,
          size: 60,
          color: isOn ? AppColors.primaryNeon : AppColors.danger,
        ),
      ),
    );
  }

  Widget _buildStatsCard() {
    return Container(
      padding: const EdgeInsets.all(25),
      decoration: BoxDecoration(
        color: AppColors.cardBg.withOpacity(0.4),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Column(
        children: [
          _buildInfoRow(Icons.wb_sunny_rounded, "Weather Condition", "Clear Sky", AppColors.warning),
          const Divider(color: Colors.white10, height: 30),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: const [
                  Icon(Icons.auto_awesome_rounded, color: AppColors.primaryNeon, size: 20),
                  SizedBox(width: 12),
                  Text("Automatic Mode", style: TextStyle(color: AppColors.textLight, fontSize: 16, fontWeight: FontWeight.w500)),
                ],
              ),
              Switch(
                value: isAuto,
                activeColor: AppColors.primaryNeon,
                onChanged: (val) => setState(() => isAuto = val),
              ),
            ],
          ),
          const Divider(color: Colors.white10, height: 30),
          _buildInfoRow(Icons.schedule_rounded, "Scheduled Time", "11:45 AM - 07:45 PM", AppColors.info),
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value, Color iconColor) {
    return Row(
      children: [
        Icon(icon, color: iconColor, size: 20),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: const TextStyle(color: AppColors.textGrey, fontSize: 12)),
            Text(value, style: const TextStyle(color: AppColors.textLight, fontSize: 15, fontWeight: FontWeight.bold)),
          ],
        ),
      ],
    );
  }

  void _showTimeSettingsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
        child: AlertDialog(
          backgroundColor: AppColors.cardBg,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
          title: const Center(child: Text("Select Time Range", style: TextStyle(color: AppColors.textLight))),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildDialogButton("Select Start Time"),
              const SizedBox(height: 15),
              _buildDialogButton("Select End Time"),
            ],
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel", style: TextStyle(color: AppColors.danger))),
            TextButton(onPressed: () => Navigator.pop(context), child: const Text("Save", style: TextStyle(color: AppColors.primaryNeon))),
          ],
        ),
      ),
    );
  }

  Widget _buildDialogButton(String text) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.primaryNeon.withOpacity(0.1),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: AppColors.primaryNeon.withOpacity(0.2)),
      ),
      child: Center(child: Text(text, style: const TextStyle(color: AppColors.textLight))),
    );
  }
}
