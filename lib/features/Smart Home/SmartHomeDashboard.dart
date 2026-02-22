import 'package:flutter/material.dart';
import 'dart:ui';
// استيراد ملف الألوان المركزي الخاص بكِ لضمان الربط المعماري
import 'package:smart_village_for_green_gnergy_optimization/core/theme/app_colors.dart';

// استيراد الصفحات الخاصة بمشروعك (تأكدي من صحة المسارات في جهازك)
import 'HomePage.dart';
import 'LightingControlPage.dart';
import 'DoorControlPage.dart';
import 'FanControlPage.dart';
import 'ValveControlPage.dart';
import 'GasSafetyPage.dart';

class SmartHomeDashboard extends StatelessWidget {
  static const String routeName = '/SmartHomeDashboard';
  const SmartHomeDashboard({super.key});

  void _openPage(BuildContext context, Widget page) {
    Navigator.of(context).push(MaterialPageRoute(builder: (_) => page));
  }

  // ويدجت بناء الكروت التفاعلية (Tiles) لربط الصفحات بالداشبورد
  Widget _buildCategoryTile(
    BuildContext context,
    IconData icon,
    String title,
    Widget page,
  ) {
    return InkWell(
      onTap: () => _openPage(context, page),
      borderRadius: BorderRadius.circular(24),
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: AppColors.cardBg.withOpacity(0.3), // استخدام لون الكروت الموحد
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: AppColors.cardBorder),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // أيقونة بلون النيون الأساسي
            Icon(icon, color: AppColors.primaryNeon, size: 38),
            const SizedBox(height: 12),
            Text(
              title,
              style: const TextStyle(
                color: AppColors.textLight,
                fontWeight: FontWeight.bold,
                fontSize: 15,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      body: Stack(
        children: [
          // خلفية متدرجة تعزز الطابع التقني
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: AppColors.mainGradient,
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(),
                  const SizedBox(height: 30),

                  // شبكة التحكم المركزية التي تجمع كافة الصفحات
                  Expanded(
                    child: GridView.count(
                      crossAxisCount: 2,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      physics: const BouncingScrollPhysics(),
                      children: [
                        _buildCategoryTile(
                          context,
                          Icons.home_max_rounded,
                          'Overview',
                          const HomePage(),
                        ),
                        _buildCategoryTile(
                          context,
                          Icons.lightbulb_rounded,
                          'Lighting',
                          const LightingControlPage(),
                        ),
                        _buildCategoryTile(
                          context,
                          Icons.sensor_door_rounded,
                          'Doors',
                          const DoorControlPage(),
                        ),
                        _buildCategoryTile(
                          context,
                          Icons.air_rounded,
                          'Fans',
                          const FanControlPage(),
                        ),
                        _buildCategoryTile(
                          context,
                          Icons.water_drop_rounded,
                          'Valves',
                          const ValveControlPage(),
                        ),
                        _buildCategoryTile(
                          context,
                          Icons.shield_rounded,
                          'Gas Safety',
                          const GasSafetyPage(),
                        ),
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

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              'Welcome Home,',
              style: TextStyle(
                color: AppColors.textGrey,
                fontSize: 14,
                letterSpacing: 1,
              ),
            ),
            SizedBox(height: 6),
            Text(
              'Smart Residence', // مطابق لعنوان الداشبورد في صورتك
              style: TextStyle(
                color: AppColors.textLight,
                fontSize: 26,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        // أيقونة المستخدم الدائرية
        Container(
          padding: const EdgeInsets.all(2),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: AppColors.primaryNeon, width: 1.5),
          ),
          child: const CircleAvatar(
            radius: 22,
            backgroundImage: NetworkImage(
              'https://cdn-icons-png.flaticon.com/512/147/147144.png',
            ),
          ),
        ),
      ],
    );
  }
}
