import 'package:flutter/material.dart';
// استيراد ملف الألوان المركزي لضمان توحيد الهوية البصرية
import 'package:smart_village_for_green_gnergy_optimization/core/theme/app_colors.dart';

class SettingsScreen extends StatefulWidget {
  // اسم المسار للربط في ملف main.dart
  static const String routeName = '/irrigation_settings';
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  // قيم الإعدادات الافتراضية بناءً على تصميمك
  double _moistureThreshold = 50;
  String _selectedInterval = "10 Sec.";
  final List<String> _intervals = ["5 Sec.", "10 Sec.", "30 Sec.", "1 Min."];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBg, // استخدام الخلفية الموحدة من ملفك
      body: Stack(
        children: [
          _buildBackgroundGradient(),
          SafeArea(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),

                  // زر الرجوع الموحد (Back Button)
                  IconButton(
                    icon: const Icon(
                      Icons.arrow_back_ios_new_rounded,
                      color: AppColors.textLight,
                      size: 22,
                    ),
                    onPressed: () => Navigator.pop(context),
                  ),

                  const SizedBox(height: 20),
                  const Text(
                    "System Configurations",
                    style: TextStyle(
                      color: AppColors.textLight,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.1,
                    ),
                  ),
                  const Text(
                    "Adjust your smart irrigation parameters",
                    style: TextStyle(color: AppColors.textGrey, fontSize: 14),
                  ),

                  const SizedBox(height: 40),

                  // ======= كارت التحكم في الرطوبة (Moisture Threshold) =======
                  _buildSettingsCard(
                    title: "Moisture Threshold",
                    icon: Icons.waves_rounded,
                    child: Column(
                      children: [
                        SliderTheme(
                          data: SliderTheme.of(context).copyWith(
                            activeTrackColor: AppColors.primaryNeon,
                            inactiveTrackColor: AppColors.glassWhite,
                            thumbColor: AppColors.textLight,
                            overlayColor: AppColors.primaryNeon.withOpacity(
                              0.2,
                            ),
                            valueIndicatorColor: AppColors.primaryNeon,
                            valueIndicatorTextStyle: const TextStyle(
                              color: AppColors.textDark,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          child: Slider(
                            value: _moistureThreshold,
                            min: 0,
                            max: 100,
                            divisions: 100,
                            label: "${_moistureThreshold.toInt()}%",
                            onChanged: (value) =>
                                setState(() => _moistureThreshold = value),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              "0%",
                              style: TextStyle(
                                color: AppColors.textDisabled,
                                fontSize: 12,
                              ),
                            ),
                            Text(
                              "${_moistureThreshold.toInt()}%",
                              style: const TextStyle(
                                color: AppColors.primaryNeon,
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                            const Text(
                              "100%",
                              style: TextStyle(
                                color: AppColors.textDisabled,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 25),

                  // ======= كارت فترة التحديث (Update Interval) =======
                  _buildSettingsCard(
                    title: "Data Update Interval",
                    icon: Icons.timer_outlined,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: _selectedInterval,
                          isExpanded: true,
                          dropdownColor: AppColors.cardBg,
                          icon: const Icon(
                            Icons.keyboard_arrow_down_rounded,
                            color: AppColors.primaryNeon,
                          ),
                          style: const TextStyle(
                            color: AppColors.textLight,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                          items: _intervals.map((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                          onChanged: (value) =>
                              setState(() => _selectedInterval = value!),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 50),

                  // ======= زر الحفظ النيوني الموحد (SAVE) =======
                  _buildSaveButton(context),
                  const SizedBox(height: 30),
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
          colors: AppColors.mainGradient,
        ),
      ),
    );
  }

  Widget _buildSettingsCard({
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
          const SizedBox(height: 20),
          child,
        ],
      ),
    );
  }

  Widget _buildSaveButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 60,
      child: ElevatedButton.icon(
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
              backgroundColor: AppColors.cardBg,
              content: Text(
                "Configurations saved successfully! ✅",
                style: TextStyle(color: AppColors.primaryNeon),
              ),
            ),
          );
        },
        icon: const Icon(Icons.save_rounded, size: 22),
        label: const Text(
          "SAVE CONFIGURATIONS",
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w900,
            letterSpacing: 1.2,
          ),
        ),
      ),
    );
  }
}
