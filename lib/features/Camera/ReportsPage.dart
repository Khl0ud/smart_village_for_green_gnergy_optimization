import 'package:flutter/material.dart';
import 'dart:ui';
// استيراد ملف الألوان المركزي والويدجت المشتركة لضمان الربط المعماري
import 'package:smart_village_for_green_gnergy_optimization/core/theme/app_colors.dart';
import 'shared_widgets.dart';

class ReportsPage extends StatelessWidget {
  const ReportsPage({super.key});

  @override
  Widget build(BuildContext context) {
    // استخدام الألوان الموحدة من ملف AppColors
    const Color mainBg = AppColors.scaffoldBg;

    return Scaffold(
      backgroundColor: mainBg,
      body: SafeArea(
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            // شريط البحث العلوي الموحد بتصميم زجاجي
            const SliverToBoxAdapter(child: TopSearchBar()),

            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 20, 24, 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'ACTIVITY LOGS',
                      style: TextStyle(
                        color: AppColors.textGrey,
                        fontSize: 12,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 2.0,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'System History',
                      style: TextStyle(
                        color: AppColors.textLight,
                        fontWeight: FontWeight.bold,
                        fontSize: 28,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // قائمة سجل التنبيهات المنسقة بأسلوب Glassmorphism
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate((context, i) {
                  return HistoryTile(
                    title: i % 2 == 0 ? 'Motion Detected' : 'Gate Accessed',
                    subtitle: i % 2 == 0
                        ? 'Kitchen Area • 07:30 PM'
                        : 'Main Entrance • 11:20 PM',
                    // الربط مع أصول مشروعك التقني
                    assetPath: i % 2 == 0
                        ? 'assets/kitchen.png'
                        : 'assets/living_room.png',
                    onTap: () {
                      // سيتم الربط مع صفحة Video View لاحقاً
                    },
                  );
                }, childCount: 15),
              ),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 120)),
          ],
        ),
      ),
    );
  }
}

class HistoryTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final String assetPath;
  final VoidCallback onTap;

  const HistoryTile({
    super.key,
    required this.title,
    required this.subtitle,
    required this.assetPath,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    const Color cardBg = AppColors.cardBg;
    const Color accentGreen = AppColors.primaryNeon;

    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      decoration: BoxDecoration(
        // تأثير الشفافية الزجاجي المعتمد في المشروع
        color: cardBg.withOpacity(0.4),
        borderRadius: BorderRadius.circular(25),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(25),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              // مصغر الصورة مع أيقونة تشغيل نيون لتعزيز الطابع الذكي
              _buildImagePreview(assetPath, accentGreen),

              const SizedBox(width: 16),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        color: AppColors.textLight,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        color: AppColors.textGrey,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.arrow_forward_ios_rounded,
                color: Colors.white12,
                size: 16,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImagePreview(String path, Color accent) {
    return Stack(
      alignment: Alignment.center,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(15),
          child: Image.asset(
            path,
            width: 90,
            height: 65,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) => Container(
              width: 90,
              height: 65,
              color: Colors.white10,
              child: const Icon(
                Icons.videocam_off_rounded,
                color: Colors.white24,
              ),
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.5),
            shape: BoxShape.circle,
            border: Border.all(color: accent.withOpacity(0.5), width: 1),
          ),
          child: Icon(Icons.play_arrow_rounded, color: accent, size: 20),
        ),
      ],
    );
  }
}
