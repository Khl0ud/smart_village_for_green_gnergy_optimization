import 'package:flutter/material.dart';
import 'dart:ui';
// استيراد ملف الألوان المركزي والويدجت المشتركة لضمان الربط المعماري
import 'package:smart_village_for_green_gnergy_optimization/core/theme/app_colors.dart';
import 'shared_widgets.dart';

class SurveillanceGridPage extends StatelessWidget {
  const SurveillanceGridPage({super.key});

  @override
  Widget build(BuildContext context) {
    // تنظيم مجموعات الكاميرات بناءً على مناطق القرية الذكية
    final groups = [
      (
        'Home Entrance',
        [
          ('Main Gate', 'assets/living_room.png'),
          ('Back Door', 'assets/living_room.png'),
        ],
      ),
      (
        'Farm Areas',
        [
          ('Robot View', 'assets/farm_robot.jpg'),
          ('Irrigation Zone', 'assets/farm_robot.jpg'),
        ],
      ),
      (
        'Garage',
        [
          ('Car Park', 'assets/living_room.png'),
          ('Exit Gate', 'assets/living_room.png'),
        ],
      ),
    ];

    const Color mainBg = AppColors.scaffoldBg;
    const Color primaryNeon = AppColors.primaryNeon;

    return Scaffold(
      backgroundColor: mainBg,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          // شريط البحث الموحد في الأعلى بتصميم زجاجي
          const SliverToBoxAdapter(child: TopSearchBar()),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 20, 24, 10),
              child: Text(
                'Live Surveillance',
                style: TextStyle(
                  color: primaryNeon, // استخدام اللون النيون الموحد
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                ),
              ),
            ),
          ),

          // حلقة التكرار لعرض الأقسام والكاميرات بأسلوب منظم
          for (final (section, items) in groups) ...[
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 25, 24, 12),
                child: Text(
                  section
                      .toUpperCase(), // تحويل النص لأحرف كبيرة للجمالية التقنية
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 1.5,
                  ),
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              sliver: SliverGrid(
                delegate: SliverChildBuilderDelegate((context, i) {
                  final (title, img) = items[i];
                  return _ImageCard(
                    title: title,
                    assetPath: img,
                    accentColor: primaryNeon,
                    onTap: () {
                      // سيتم الربط مع صفحة Video View لاحقاً
                    },
                  );
                }, childCount: items.length),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 15,
                  mainAxisSpacing: 15,
                  childAspectRatio: 1.1,
                ),
              ),
            ),
          ],

          const SliverToBoxAdapter(child: SizedBox(height: 120)),
        ],
      ),
    );
  }
}

class _ImageCard extends StatelessWidget {
  final String title;
  final String assetPath;
  final Color accentColor;
  final VoidCallback onTap;

  const _ImageCard({
    required this.title,
    required this.assetPath,
    required this.accentColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(25),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25),
          border: Border.all(color: Colors.white.withOpacity(0.05)),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(25),
          child: Stack(
            children: [
              Positioned.fill(
                child: Image.asset(
                  assetPath,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    color: AppColors.cardBg,
                    child: const Icon(
                      Icons.videocam_off_rounded,
                      color: Colors.white24,
                    ),
                  ),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black.withOpacity(0.1),
                      Colors.black.withOpacity(0.8),
                    ],
                  ),
                ),
                padding: const EdgeInsets.all(12),
                child: Stack(
                  children: [
                    Align(
                      alignment: Alignment.bottomLeft,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            title,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Row(
                            children: [
                              Container(
                                width: 6,
                                height: 6,
                                decoration: BoxDecoration(
                                  color: accentColor,
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: 4),
                              Text(
                                'LIVE',
                                style: TextStyle(
                                  color: accentColor,
                                  fontSize: 10,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const Align(
                      alignment: Alignment.topRight,
                      child: CircleAvatar(
                        radius: 14,
                        backgroundColor: Colors.white12,
                        child: Icon(
                          Icons.fullscreen_rounded,
                          color: Colors.white,
                          size: 16,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
