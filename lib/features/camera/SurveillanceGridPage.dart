import 'package:flutter/material.dart';
import 'dart:ui';
// تأكدي من صحة مسارات الـ imports بناءً على مشروعك
import 'package:smart_village_for_green_gnergy_optimization/core/theme/app_colors.dart';
import 'shared_widgets.dart';
// استيراد صفحة اللايف التي قمتِ بكتابتها
import 'live_screen.dart';

class SurveillanceGridPage extends StatelessWidget {
  const SurveillanceGridPage({super.key});

  @override
  Widget build(BuildContext context) {
    // تنظيم مجموعات الكاميرات
    final groups = [
      (
              'Main Security',
              [
                ('Gate', 'assets/gate.png', 'gate'),
                ('Street View', 'assets/street.png', 'street'),
              ],
            ),
            (
              'Private Areas',
              [
                ('Children Room', 'assets/room.png', 'childrenRoom'),
                ('Parking Lot', 'assets/parking.png', 'parking'),
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
          const SliverToBoxAdapter(child: TopSearchBar()),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 20, 24, 10),
              child: Text(
                'Live Surveillance',
                style: TextStyle(
                  color: primaryNeon,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                ),
              ),
            ),
          ),

          for (final (section, items) in groups) ...[
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 25, 24, 12),
                child: Text(
                  section.toUpperCase(),
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
                      // --- الربط الفعلي مع صفحة البث ---
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => LiveScreen(
                            cameraName: title,
                            // ⚠️ غيري الـ IP هنا لعنوان جهازك الحقيقي
                            url: "http://192.168.1.3:8888/cam1/index.m3u8",
                          ),
                        ),
                      );
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