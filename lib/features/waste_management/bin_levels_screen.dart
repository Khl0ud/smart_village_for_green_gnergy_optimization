import 'package:flutter/material.dart';
// استيراد ملف الألوان المركزي لضمان توحيد الهوية البصرية
import 'package:smart_village_for_green_gnergy_optimization/core/theme/app_colors.dart';
// استيراد كلاس Bin من الملف الرئيسي للموديول
import 'waste_main.dart';

class BinLevelsScreen extends StatelessWidget {
  final List<Bin> bins;

  const BinLevelsScreen({super.key, required this.bins});

  // منطق تحديد اللون بناءً على مستوى الامتلاء من ملفك الرسمي
  Color _getStatusColor(double fill) {
    if (fill >= 0.8) return AppColors.danger; // حالة حرجة (أحمر)
    if (fill >= 0.5) return AppColors.warning; // حالة متوسطة (برتقالي)
    return AppColors.primaryNeon; // حالة جيدة (أخضر نيون)
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBg, // استخدام الخلفية الموحدة
      body: Stack(
        children: [
          _buildBackgroundGradient(),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(context),
                  const SizedBox(height: 25),
                  _buildBinsList(),
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

  Widget _buildHeader(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 10),
        IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: AppColors.textLight,
            size: 22,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        const SizedBox(height: 10),
        const Text(
          'Real-time Monitoring',
          style: TextStyle(
            color: AppColors.textGrey,
            fontSize: 14,
            letterSpacing: 1.2,
          ),
        ),
        const Text(
          'Bin Fill Levels', // مطابق لعنوان صورتك
          style: TextStyle(
            fontSize: 28,
            color: AppColors.textLight,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildBinsList() {
    return Expanded(
      child: ListView.separated(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.only(bottom: 50),
        itemCount: bins.length,
        separatorBuilder: (_, index) => const SizedBox(height: 16),
        itemBuilder: (context, i) {
          final bin = bins[i];
          final statusColor = _getStatusColor(bin.fill);
          return _BinLevelCard(bin: bin, color: statusColor);
        },
      ),
    );
  }
}

class _BinLevelCard extends StatelessWidget {
  final Bin bin;
  final Color color;
  const _BinLevelCard({required this.bin, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.cardBg.withValues(alpha: 0.4), // تأثير زجاجي معتمد
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Row(
        children: [
          _buildAnimatedCircularIndicator(),
          const SizedBox(width: 20),
          Expanded(child: _buildBinDetails()),
        ],
      ),
    );
  }

  Widget _buildAnimatedCircularIndicator() {
    return SizedBox(
      width: 80,
      height: 80,
      child: TweenAnimationBuilder<double>(
        tween: Tween(begin: 0.0, end: bin.fill),
        duration: const Duration(milliseconds: 1500),
        curve: Curves.easeOutQuart,
        builder: (context, v, _) {
          return Stack(
            alignment: Alignment.center,
            children: [
              CircularProgressIndicator(
                value: v.clamp(0.0, 1.0),
                strokeWidth: 8,
                backgroundColor: Colors.white.withValues(alpha: 0.05),
                valueColor: AlwaysStoppedAnimation(color),
              ),
              Text(
                '${(v * 100).toInt()}%',
                style: const TextStyle(
                  color: AppColors.textLight,
                  fontWeight: FontWeight.w900,
                  fontSize: 16,
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildBinDetails() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              bin.id,
              style: const TextStyle(
                color: AppColors.textLight,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            _buildStatusBadge(),
          ],
        ),
        const SizedBox(height: 6),
        Row(
          children: [
            const Icon(
              Icons.location_on_rounded,
              color: AppColors.textGrey,
              size: 14,
            ),
            const SizedBox(width: 4),
            Text(
              bin.location,
              style: const TextStyle(color: AppColors.textGrey, fontSize: 13),
            ),
          ],
        ),
        const SizedBox(height: 15),
        _buildLinearIndicator(),
      ],
    );
  }

  Widget _buildLinearIndicator() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: LinearProgressIndicator(
        value: bin.fill,
        minHeight: 8,
        backgroundColor: Colors.white.withValues(alpha: 0.05),
        valueColor: AlwaysStoppedAnimation(color),
      ),
    );
  }

  Widget _buildStatusBadge() {
    String label = bin.fill >= 0.8
        ? 'Critical'
        : bin.fill >= 0.5
        ? 'Moderate'
        : 'Good';
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: color.withValues(alpha: 0.2), width: 1),
      ),
      child: Text(
        label.toUpperCase(),
        style: TextStyle(
          color: color,
          fontSize: 9,
          fontWeight: FontWeight.w900,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}
