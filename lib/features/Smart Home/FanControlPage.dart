import 'package:flutter/material.dart';
import 'dart:ui';
// استيراد ملف الألوان المركزي الخاص بكِ لضمان الربط المعماري
import 'package:smart_village_for_green_gnergy_optimization/core/theme/app_colors.dart';

class FanControlPage extends StatefulWidget {
  static const String routeName = '/FanControlPage';
  const FanControlPage({Key? key}) : super(key: key);

  @override
  State<FanControlPage> createState() => _FanControlPageState();
}

class _FanControlPageState extends State<FanControlPage> {
  // حالات المراوح بناءً على تصميم النظام
  bool livingRoomFan = false;
  bool bedroomFan = false;
  bool kitchenFan = false;
  double fanSpeed = 2.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBg, // استخدام الخلفية الموحدة من ملفك
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            color: AppColors.textLight,
            size: 22,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Fan Control", // العنوان مطابق للصورة
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 22,
            color: AppColors.textLight,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            // قائمة التحكم في المراوح الفردية بتصميم Glassmorphism
            _buildFanTile(
              "Living Room Fan",
              livingRoomFan,
              (val) => setState(() => livingRoomFan = val),
            ),
            const SizedBox(height: 15),
            _buildFanTile(
              "Bedroom Fan",
              bedroomFan,
              (val) => setState(() => bedroomFan = val),
            ),
            const SizedBox(height: 15),
            _buildFanTile(
              "Kitchen Fan",
              kitchenFan,
              (val) => setState(() => kitchenFan = val),
            ),

            const SizedBox(height: 30),

            // قسم التحكم في السرعة (Slider) مطابق للصورة
            _buildSpeedControlCard(),

            const Spacer(),

            // زر إيقاف الكل بلون الخطر الموحد من ملفك
            _buildTurnOffAllButton(),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildFanTile(String title, bool isOn, Function(bool) onChanged) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: AppColors.cardBg.withOpacity(0.3), // استخدام لون الكروت الموحد
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              // أيقونة المروحة كما في الصورة
              Icon(Icons.wind_power, color: AppColors.textGrey, size: 28),
              const SizedBox(width: 15),
              Text(
                title,
                style: const TextStyle(
                  color: AppColors.textLight,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          Switch(
            value: isOn,
            activeColor: AppColors.textLight, // اللون مطابق للصورة
            activeTrackColor: AppColors.textGrey,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }

  Widget _buildSpeedControlCard() {
    return Container(
      padding: const EdgeInsets.all(25),
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.cardBg.withOpacity(0.3),
        borderRadius: BorderRadius.circular(25),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Column(
        children: [
          const Text(
            "Fan Speed Control",
            style: TextStyle(
              color: AppColors.textGrey,
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 10),
          // الـ Slider باللون النيون الموحد مطابق للصورة
          Slider(
            value: fanSpeed,
            min: 0,
            max: 4,
            divisions: 4,
            activeColor: AppColors.primaryNeon,
            inactiveColor: AppColors.glassWhite,
            onChanged: (val) => setState(() => fanSpeed = val),
          ),
          Text(
            "Speed: ${fanSpeed.round()}",
            style: const TextStyle(
              color: AppColors.textLight,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTurnOffAllButton() {
    return SizedBox(
      width: double.infinity,
      height: 60,
      child: ElevatedButton.icon(
        onPressed: () {
          setState(() {
            livingRoomFan = bedroomFan = kitchenFan = false;
            fanSpeed = 0;
          });
        },
        icon: const Icon(Icons.power_settings_new, color: AppColors.textLight),
        label: const Text(
          "Turn Off All Fans",
          style: TextStyle(
            color: AppColors.textLight,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.danger, // استخدام اللون الموحد للإيقاف
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
      ),
    );
  }
}
