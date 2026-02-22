import 'package:flutter/material.dart';
// استيراد ملف الألوان المركزي لضمان توحيد الهوية البصرية لمشروعكِ
import 'package:smart_village_for_green_gnergy_optimization/core/theme/app_colors.dart';
// استيراد كلاس Bin من الملف الرئيسي للموديول
import 'waste_main.dart';

class DashboardScreen extends StatelessWidget {
  final List<Bin> bins;

  const DashboardScreen({super.key, required this.bins});

  // حساب متوسط امتلاء كافة الصناديق برمجياً
  double get avgFill =>
      bins.isEmpty ? 0.0 : (bins.fold(0.0, (p, e) => p + e.fill) / bins.length);

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
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 40),
                  _buildHeader(),
                  const SizedBox(height: 30),

                  // كارت الإحصائيات الرئيسي بتصميم زجاجي (Overall Status)
                  _TopStatCard(
                    avgFill: avgFill,
                    total: bins.length,
                    criticalCount: bins.where((b) => b.fill >= 0.8).length,
                  ),

                  const SizedBox(height: 35),
                  _buildSectionTitle('Category Analysis'),
                  const SizedBox(height: 15),

                  // قائمة الكروت الأفقية لتحليل الحالة
                  _buildCategoryAnalysis(),

                  const SizedBox(height: 35),
                  _buildSectionTitle('Recent System Alerts'),
                  const SizedBox(height: 15),

                  // قائمة التنبيهات الأخيرة بنظام نيون
                  _buildAlertsList(),
                  const SizedBox(height: 50),
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

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        Text(
          'Smart Waste Management',
          style: TextStyle(
            color: AppColors.textGrey,
            fontSize: 13,
            letterSpacing: 1.2,
            fontWeight: FontWeight.w600,
          ),
        ),
        Text(
          'System Overview', // مطابق لعنوان صورتك
          style: TextStyle(
            fontSize: 28,
            color: AppColors.textLight,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        color: AppColors.textLight,
        fontSize: 18,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildCategoryAnalysis() {
    final List<Map<String, dynamic>> categories = [
      {
        'label': 'Critical',
        'value': bins.where((b) => b.fill >= 0.8).length.toString(),
        'color': AppColors.danger,
      },
      {
        'label': 'Moderate',
        'value': bins
            .where((b) => b.fill >= 0.5 && b.fill < 0.8)
            .length
            .toString(),
        'color': AppColors.warning,
      },
      {
        'label': 'Empty',
        'value': bins.where((b) => b.fill < 0.5).length.toString(),
        'color': AppColors.primaryNeon,
      },
      {'label': 'Pending', 'value': "2", 'color': AppColors.info},
    ];

    return SizedBox(
      height: 140,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: categories.length,
        separatorBuilder: (_, index) => const SizedBox(width: 15),
        itemBuilder: (context, idx) {
          return _AnimatedStatCard(
            label: categories[idx]['label'],
            value: categories[idx]['value'],
            color: categories[idx]['color'],
          );
        },
      ),
    );
  }

  Widget _buildAlertsList() {
    return Column(
      children: const [
        _AlertTile(
          color: AppColors.danger,
          text: 'Critical level detected in Bin A4', // مطابق للحالات في صورتك
          time: 'Just now',
        ),
        SizedBox(height: 12),
        _AlertTile(
          color: AppColors.primaryNeon,
          text: 'Collection completed for Zone C',
          time: '45m ago',
        ),
      ],
    );
  }
}

// كارت الحالة العامة المطور
class _TopStatCard extends StatelessWidget {
  final double avgFill;
  final int total;
  final int criticalCount;

  const _TopStatCard({
    required this.avgFill,
    required this.total,
    required this.criticalCount,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(25),
      decoration: BoxDecoration(
        color: AppColors.cardBg.withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Row(
        children: [
          _buildCircularProgress(),
          const SizedBox(width: 30),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Operational Bins',
                  style: TextStyle(
                    color: AppColors.textGrey,
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  '$total',
                  style: const TextStyle(
                    color: AppColors.textLight,
                    fontSize: 36,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _tinyStat('Critical', '$criticalCount', AppColors.danger),
                    _tinyStat(
                      'Healthy',
                      '${total - criticalCount}',
                      AppColors.primaryNeon,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCircularProgress() {
    return SizedBox(
      width: 100,
      height: 100,
      child: TweenAnimationBuilder<double>(
        tween: Tween(begin: 0.0, end: avgFill),
        duration: const Duration(milliseconds: 1500),
        curve: Curves.easeOutQuart,
        builder: (context, progress, _) {
          return Stack(
            alignment: Alignment.center,
            children: [
              CircularProgressIndicator(
                value: progress.clamp(0.0, 1.0),
                strokeWidth: 12,
                backgroundColor: Colors.white10,
                valueColor: const AlwaysStoppedAnimation(AppColors.primaryNeon),
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '${(progress * 100).toInt()}%',
                    style: const TextStyle(
                      color: AppColors.textLight,
                      fontWeight: FontWeight.w900,
                      fontSize: 20,
                    ),
                  ),
                  const Text(
                    'AVG',
                    style: TextStyle(
                      color: AppColors.textGrey,
                      fontSize: 9,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1,
                    ),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _tinyStat(String label, String val, Color c) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          val,
          style: TextStyle(color: c, fontWeight: FontWeight.w900, fontSize: 16),
        ),
        Text(
          label,
          style: const TextStyle(
            color: AppColors.textGrey,
            fontSize: 10,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}

// كروت التحليل المتحركة
class _AnimatedStatCard extends StatelessWidget {
  final String label, value;
  final Color color;

  const _AnimatedStatCard({
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 150,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.cardBg.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(25),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: AppColors.textGrey,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Spacer(),
          Text(
            value,
            style: const TextStyle(
              color: AppColors.textLight,
              fontSize: 32,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(5),
            child: LinearProgressIndicator(
              value: (double.tryParse(value) ?? 0) / 5,
              backgroundColor: Colors.white10,
              valueColor: AlwaysStoppedAnimation(color),
              minHeight: 5,
            ),
          ),
        ],
      ),
    );
  }
}

// ويدجت التنبيهات النيون
class _AlertTile extends StatelessWidget {
  final Color color;
  final String text, time;

  const _AlertTile({
    required this.color,
    required this.text,
    required this.time,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.cardBg.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.1)),
      ),
      child: Row(
        children: [
          Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: color.withValues(alpha: 0.4),
                  blurRadius: 10,
                  spreadRadius: 2,
                ),
              ],
            ),
          ),
          const SizedBox(width: 18),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                color: AppColors.textLight,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Text(
            time,
            style: const TextStyle(color: AppColors.textGrey, fontSize: 11),
          ),
        ],
      ),
    );
  }
}
