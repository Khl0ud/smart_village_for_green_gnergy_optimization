import 'package:flutter/material.dart';
import 'dart:ui';
// استيراد ملف الألوان المركزي لضمان الربط المعماري
import 'package:smart_village_for_green_gnergy_optimization/core/theme/app_colors.dart';

/// الخلفية المنحنية العلوية (Top Curved Background) بتصميم Glassmorphism
class TopCurvedBackground extends StatelessWidget {
  final double height;

  const TopCurvedBackground({super.key, this.height = 200});

  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: CurvedClipper(),
      child: Container(
        height: height,
        decoration: BoxDecoration(
          // استخدام تدرج لوني يتناسب مع هوية مشروعك
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppColors.cardBg, 
              AppColors.scaffoldBg,
            ],
          ),
          border: Border(
            bottom: BorderSide(color: AppColors.primaryNeon.withOpacity(0.1), width: 1),
          ),
        ),
      ),
    );
  }
}

/// المقص المنحني للخلفية (Curved Clipper)
class CurvedClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0, size.height - 50);
    path.quadraticBezierTo(
      size.width / 2,
      size.height,
      size.width,
      size.height - 50,
    );
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CurvedClipper oldClipper) => false;
}

/// شريط البحث العلوي الموحد (Top Search Bar) بتصميم زجاجي
class TopSearchBar extends StatelessWidget {
  const TopSearchBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10), // تأثير الضباب الزجاجي
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.cardBg.withOpacity(0.4),
              borderRadius: BorderRadius.circular(15),
              border: Border.all(
                color: AppColors.primaryNeon.withOpacity(0.2), // حدود نيون خفيفة
                width: 1,
              ),
            ),
            child: TextField(
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Search for devices or logs...',
                hintStyle: TextStyle(color: AppColors.textGrey, fontSize: 14),
                prefixIcon: const Icon(
                  Icons.search_rounded,
                  color: AppColors.primaryNeon, // أيقونة باللون النيون الموحد
                  size: 22,
                ),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
