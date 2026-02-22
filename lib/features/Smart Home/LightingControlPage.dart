import 'package:flutter/material.dart';
import 'dart:ui';
// استيراد ملف الألوان المركزي لضمان التناسق الهيكلي
import 'package:smart_village_for_green_gnergy_optimization/core/theme/app_colors.dart';

class LightingControlPage extends StatefulWidget {
  static const String routeName = '/LightingControlPage';
  const LightingControlPage({Key? key}) : super(key: key);

  @override
  State<LightingControlPage> createState() => _LightingControlPageState();
}

class _LightingControlPageState extends State<LightingControlPage> {
  // الحالات الافتراضية بناءً على تصميم النظام في صورك
  bool bathroom = false;
  bool kitchen = true;
  bool livingRoom = false;
  bool corridor = false;
  bool bedroom = true;
  bool childrenRoom = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBg, // استخدام الخلفية الموحدة
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: AppColors.textLight, size: 22),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Lighting", // مطابق للصورة المرفقة
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24, color: AppColors.textLight),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Control every light in your home", // النص الفرعي مطابق للصورة
              style: TextStyle(color: AppColors.textGrey, fontSize: 14),
            ),
            const SizedBox(height: 25),
            
            // أزرار التحكم الكلي (All On / All Off)
            Row(
              children: [
                Expanded(child: _buildMasterButton("All On", Icons.lightbulb, true)),
                const SizedBox(width: 15),
                Expanded(child: _buildMasterButton("All Off", Icons.lightbulb_outline, false)),
              ],
            ),
            const SizedBox(height: 30),

            // شبكة التحكم في الغرف بتصميم Grid مطابق للصورة
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 15,
                mainAxisSpacing: 15,
                childAspectRatio: 1.1,
                children: [
                  _buildLightCard("Bathroom", bathroom, (val) => setState(() => bathroom = val)),
                  _buildLightCard("Kitchen", kitchen, (val) => setState(() => kitchen = val)),
                  _buildLightCard("Living Room", livingRoom, (val) => setState(() => livingRoom = val)),
                  _buildLightCard("Corridor", corridor, (val) => setState(() => corridor = val)),
                  _buildLightCard("Bedroom", bedroom, (val) => setState(() => bedroom = val)),
                  _buildLightCard("Children's Room", childrenRoom, (val) => setState(() => childrenRoom = val)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // أزرار التحكم العلوي بتصميم Stadium
  Widget _buildMasterButton(String label, IconData icon, bool turnOn) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.cardBg.withOpacity(0.3),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: AppColors.textLight, size: 20),
          const SizedBox(width: 8),
          Text(label, style: const TextStyle(color: AppColors.textLight, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  // كارت الغرفة الذكي بتصميم Glassmorphism المتغير
  Widget _buildLightCard(String room, bool isOn, Function(bool) onChanged) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        // التوهج الأخضر للكارت عند التشغيل مطابق للصورة
        color: isOn ? AppColors.primaryNeon.withOpacity(0.15) : AppColors.cardBg.withOpacity(0.3),
        borderRadius: BorderRadius.circular(25),
        border: Border.all(
          color: isOn ? AppColors.primaryNeon.withOpacity(0.5) : AppColors.cardBorder,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(Icons.lightbulb, color: isOn ? AppColors.primaryNeon : AppColors.textGrey, size: 28),
              Switch(
                value: isOn,
                activeColor: AppColors.primaryNeon,
                onChanged: onChanged,
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(room, style: const TextStyle(color: AppColors.textLight, fontSize: 16, fontWeight: FontWeight.bold)),
              Text(isOn ? "On" : "Off", style: TextStyle(color: isOn ? AppColors.primaryNeon : AppColors.textGrey, fontSize: 12)),
            ],
          ),
        ],
      ),
    );
  }
}
