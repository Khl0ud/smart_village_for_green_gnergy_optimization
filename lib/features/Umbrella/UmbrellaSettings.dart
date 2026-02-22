import 'package:flutter/material.dart';
import 'dart:ui';
// استيراد ملف الألوان المركزي لضمان توحيد الهوية البصرية
import 'package:smart_village_for_green_gnergy_optimization/core/theme/app_colors.dart';

class UmbrellaSettings extends StatefulWidget {
  // اسم المسار للربط في ملف main.dart والداشبورد
  static const String routeName = '/UmbrellaSettings';
  const UmbrellaSettings({super.key});

  @override
  State<UmbrellaSettings> createState() => _UmbrellaSettingsState();
}

class _UmbrellaSettingsState extends State<UmbrellaSettings> {
  TimeOfDay? startTime = const TimeOfDay(hour: 11, minute: 45);
  TimeOfDay? endTime = const TimeOfDay(hour: 19, minute: 45);
  bool notificationsEnabled = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBg, // استخدام الخلفية الموحدة
      body: Stack(
        children: [
          _buildBackgroundGradient(),
          SafeArea(
            child: Column(
              children: [
                _buildModernHeader(context),
                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 20),
                        _buildPageTitles(),
                        const SizedBox(height: 35),

                        // كارت ضبط الجدول الزمني بتصميم زجاجي
                        _buildSectionCard(
                          title: "Schedule",
                          icon: Icons.access_time_filled_rounded,
                          child: Column(
                            children: [
                              _buildTimeRow("Start Operation", startTime, true),
                              const Padding(
                                padding: EdgeInsets.symmetric(vertical: 10),
                                child: Divider(color: Colors.white10),
                              ),
                              _buildTimeRow("Stop Operation", endTime, false),
                            ],
                          ),
                        ),

                        const SizedBox(height: 25),

                        // كارت التنبيهات الموحد
                        _buildSectionCard(
                          title: "Alerts",
                          icon: Icons.notifications_active_rounded,
                          child: SwitchListTile(
                            contentPadding: EdgeInsets.zero,
                            title: const Text(
                              "Push Notifications",
                              style: TextStyle(
                                color: AppColors.textGrey,
                                fontSize: 15,
                              ),
                            ),
                            value: notificationsEnabled,
                            activeColor: AppColors.primaryNeon,
                            onChanged: (val) =>
                                setState(() => notificationsEnabled = val),
                          ),
                        ),

                        const SizedBox(height: 40),

                        // زر الحفظ الموحد (Stadium Shape)
                        _buildSaveButton(context),
                        const SizedBox(height: 50),
                      ],
                    ),
                  ),
                ),
              ],
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
          colors: AppColors.mainGradient, // التدرج الموحد للمشروع
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
            icon: const Icon(
              Icons.arrow_back_ios_new_rounded,
              color: AppColors.textLight,
              size: 22,
            ),
            onPressed: () => Navigator.pop(context), // العودة لصفحة التحكم
          ),
          const Text(
            "Settings", // مطابق لعنوان صورتك
            style: TextStyle(
              color: AppColors.textLight,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const CircleAvatar(
            backgroundColor: AppColors.cardBg,
            child: Icon(
              Icons.settings_suggest_rounded,
              color: AppColors.primaryNeon,
              size: 22,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPageTitles() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        Text(
          "System Timer",
          style: TextStyle(
            color: AppColors.textLight,
            fontSize: 28,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.1,
          ),
        ),
        Text(
          "Configure operation hours for smart devices",
          style: TextStyle(color: AppColors.textGrey, fontSize: 14),
        ),
      ],
    );
  }

  Widget _buildSectionCard({
    required String title,
    required IconData icon,
    required Widget child,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.cardBg.withOpacity(0.4), // تأثير زجاجي معتمد
        borderRadius: BorderRadius.circular(25),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: AppColors.primaryNeon, size: 20),
              const SizedBox(width: 10),
              Text(
                title,
                style: const TextStyle(
                  color: AppColors.textLight,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
          child,
        ],
      ),
    );
  }

  Widget _buildTimeRow(String label, TimeOfDay? time, bool isStart) {
    return InkWell(
      onTap: () async {
        final picked = await showTimePicker(
          context: context,
          initialTime: time ?? TimeOfDay.now(),
          builder: (context, child) => Theme(
            data: ThemeData.dark().copyWith(
              colorScheme: const ColorScheme.dark(
                primary: AppColors.primaryNeon,
                onPrimary: AppColors.textDark,
                surface: AppColors.cardBg,
              ),
            ),
            child: child!,
          ),
        );
        if (picked != null)
          setState(() => isStart ? startTime = picked : endTime = picked);
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(color: AppColors.textGrey, fontSize: 15),
          ),
          Text(
            time?.format(context) ?? "--:--",
            style: const TextStyle(
              color: AppColors.primaryNeon,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSaveButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 60,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryNeon,
          foregroundColor: AppColors.textDark,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          elevation: 0,
        ),
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Configurations updated! ✅"),
              backgroundColor: AppColors.cardBg,
            ),
          );
        },
        child: const Text(
          "SAVE SETTINGS",
          style: TextStyle(fontWeight: FontWeight.w900, letterSpacing: 1.2),
        ),
      ),
    );
  }
}
