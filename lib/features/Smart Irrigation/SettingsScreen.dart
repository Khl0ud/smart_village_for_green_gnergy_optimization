import 'package:flutter/material.dart';
// استيراد ملف الألوان المركزي لضمان توحيد الهوية البصرية لمشروعكِ
import 'package:smart_village_for_green_gnergy_optimization/core/theme/app_colors.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  // 1. عتبة الرطوبة (Threshold): القيمة التي ستحدث رقم 60 في كود الـ ESP32
  double _moistureThreshold = 60.0;

  // 2. مفاتيح التشغيل (Switches): لتغيير قيم isAutoModeOn والتحكم في الريلاي
  bool isAutoModeOn = true;
  bool isManualIrrigationOn = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      body: Stack(
        children: [
          _buildBackgroundGradient(),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(context),
                  const SizedBox(height: 40),

                  // كارت ضبط عتبة الرطوبة (Threshold Slider)
                  _buildSectionCard(
                    title: "Moisture Threshold",
                    child: _buildSliderSection(),
                  ),

                  const SizedBox(height: 25),

                  // كارت مفاتيح التشغيل (Control Switches)
                  _buildSectionCard(
                    title: "System Control",
                    child: _buildSwitchSection(),
                  ),

                  const Spacer(),
                  _buildSyncButton(),
                  const SizedBox(height: 20),
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
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: AppColors.mainGradient,
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: AppColors.textLight,
            size: 22,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        const Text(
          "Settings", // مطابق لعنوان صورتك
          style: TextStyle(
            color: AppColors.textLight,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        const Icon(
          Icons.settings_suggest_rounded,
          color: AppColors.primaryNeon,
        ),
      ],
    );
  }

  Widget _buildSectionCard({required String title, required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.cardBg.withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(25),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: AppColors.textLight,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          child,
        ],
      ),
    );
  }

  // شريط التمرير لتحديث رقم 60 في كود الـ ESP32
  Widget _buildSliderSection() {
    return Column(
      children: [
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            activeTrackColor: AppColors.primaryNeon,
            thumbColor: AppColors.textLight,
            overlayColor: AppColors.primaryNeon.withValues(alpha: 0.2),
          ),
          child: Slider(
            value: _moistureThreshold,
            min: 0,
            max: 100,
            divisions: 100,
            onChanged: (v) => setState(() => _moistureThreshold = v),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              "Trigger Pump at:",
              style: TextStyle(color: AppColors.textGrey, fontSize: 12),
            ),
            Text(
              "${_moistureThreshold.toInt()}% Soil Moisture",
              style: const TextStyle(
                color: AppColors.primaryNeon,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ],
    );
  }

  // أزرار الـ Toggle لإرسال أوامر التشغيل/الإيقاف
  Widget _buildSwitchSection() {
    return Column(
      children: [
        _buildCustomSwitch(
          "Auto Mode",
          isAutoModeOn,
          (v) => setState(() {
            isAutoModeOn = v;
            if (v)
              isManualIrrigationOn = false; // تفعيل الوضع التلقائي يلغي اليدوي
          }),
        ),
        const Divider(color: Colors.white10, height: 30),
        _buildCustomSwitch(
          "Manual Irrigation",
          isManualIrrigationOn,
          (v) => setState(() {
            isManualIrrigationOn = v;
            if (v) isAutoModeOn = false; // تفعيل اليدوي يلغي التلقائي
          }),
        ),
      ],
    );
  }

  Widget _buildCustomSwitch(String label, bool val, Function(bool) onChanged) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(color: AppColors.textLight, fontSize: 15),
        ),
        Switch(
          value: val,
          onChanged: onChanged,
          activeColor: AppColors.primaryNeon,
          activeTrackColor: AppColors.primaryNeon.withValues(alpha: 0.2),
        ),
      ],
    );
  }

  Widget _buildSyncButton() {
    return SizedBox(
      width: double.infinity,
      height: 60,
      child: ElevatedButton.icon(
        onPressed: () {
          // هنا سيتم إرسال قيمة _moistureThreshold و isAutoModeOn للـ ESP32 عبر الـ API
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Sending commands to ESP32... 🚀"),
              backgroundColor: AppColors.cardBg,
            ),
          );
        },
        icon: const Icon(Icons.sync_rounded),
        label: const Text(
          "UPDATE SYSTEM PARAMETERS",
          style: TextStyle(fontWeight: FontWeight.w900),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryNeon,
          foregroundColor: AppColors.textDark,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
      ),
    );
  }
}
