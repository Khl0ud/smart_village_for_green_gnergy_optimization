import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:ui';
// استيراد ملف الألوان المركزي لضمان الربط المعماري
import 'package:smart_village_for_green_gnergy_optimization/core/theme/app_colors.dart';

class PreferencesPage extends StatefulWidget {
  const PreferencesPage({super.key});

  @override
  State<PreferencesPage> createState() => _PreferencesPageState();
}

class _PreferencesPageState extends State<PreferencesPage> {
  final TextEditingController _searchController = TextEditingController();
  bool isDarkTheme = true;
  String query = "";

  @override
  void initState() {
    super.initState();
    // ضبط شفافية شريط الحالة العلوي ليتناسب مع التصميم الداكن
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // استخدام الألوان الموحدة من ملف AppColors المعتمد
    const Color primaryNeon = AppColors.primaryNeon;

    return Scaffold(
      backgroundColor: AppColors.scaffoldBg, // توحيد الخلفية الداكنة
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Colors.white,
            size: 20,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Preferences",
          style: TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.bold,
            color: primaryNeon, // اللون النيون الموحد
            letterSpacing: 1.1,
          ),
        ),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        child: Column(
          children: [
            // مربع البحث المودرن بتأثير زجاجي
            _buildSearchBar(primaryNeon),

            const SizedBox(height: 30),

            // خيار اللغة
            _buildPreferenceItem(
              context,
              title: "Language",
              trailing: const Icon(
                Icons.translate_rounded,
                color: Colors.white70,
                size: 20,
              ),
            ),

            // خيار الثيم (Theme Switch) المربوط باللون النيون
            _buildPreferenceItem(
              context,
              title: "Theme Mode",
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    isDarkTheme ? "Dark" : "Light",
                    style: const TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                  const SizedBox(width: 8),
                  Switch(
                    value: isDarkTheme,
                    onChanged: (value) => setState(() => isDarkTheme = value),
                    activeColor: primaryNeon,
                    activeTrackColor: primaryNeon.withOpacity(0.3),
                  ),
                ],
              ),
            ),

            // خيار الوحدات (Units) المناسب لمشاريع الـ IoT
            _buildPreferenceItem(
              context,
              title: "Measurement Units",
              trailing: const Icon(
                Icons.settings_input_component_rounded,
                color: Colors.white70,
                size: 20,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar(Color accent) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: AppColors.cardBg.withOpacity(0.5), // تأثير شفاف زجاجي
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Row(
        children: [
          Icon(Icons.search_rounded, color: accent, size: 22),
          const SizedBox(width: 10),
          Expanded(
            child: TextField(
              controller: _searchController,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                hintText: 'Search preferences...',
                hintStyle: TextStyle(color: Colors.white24, fontSize: 14),
                border: InputBorder.none,
              ),
              onChanged: (value) => setState(() => query = value),
            ),
          ),
          if (_searchController.text.isNotEmpty)
            IconButton(
              onPressed: () {
                _searchController.clear();
                setState(() => query = "");
              },
              icon: const Icon(
                Icons.clear_rounded,
                color: Colors.white38,
                size: 18,
              ),
            ),
        ],
      ),
    );
  }

  // ويدجت بناء عناصر التفضيلات بتصميم Glassmorphism Stadium Shape
  Widget _buildPreferenceItem(
    BuildContext context, {
    required String title,
    required Widget trailing,
    VoidCallback? onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(40),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 24),
          decoration: BoxDecoration(
            color: AppColors.cardBg.withOpacity(0.3),
            borderRadius: BorderRadius.circular(40),
            border: Border.all(color: Colors.white.withOpacity(0.05)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 17,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 0.5,
                ),
              ),
              trailing,
            ],
          ),
        ),
      ),
    );
  }
}

// ---------------- HELPER ----------------
// ويدجت القالب البسيط المربوط بتخصصك في الـ IoT

Widget buildSimplePage(BuildContext context, String title) {
  return Scaffold(
    backgroundColor: AppColors.scaffoldBg,
    appBar: AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      centerTitle: true,
      leading: IconButton(
        icon: const Icon(
          Icons.arrow_back_ios_new_rounded,
          color: Colors.white,
          size: 20,
        ),
        onPressed: () => Navigator.pop(context),
      ),
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: AppColors.primaryNeon,
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
                color: AppColors.cardBg.withOpacity(0.3),
                borderRadius: BorderRadius.circular(30),
                border: Border.all(color: AppColors.cardBorder),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.sensors_rounded, // أيقونة تعبر عن تخصصك في الـ IoT
                    size: 60,
                    color: AppColors.primaryNeon,
                  ),
                  const SizedBox(height: 25),
                  Text(
                    "$title module is being optimized.",
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    "Integrating real-time sensor data for your smart village dashboard.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white38,
                      fontSize: 14,
                      height: 1.4,
                    ),
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
