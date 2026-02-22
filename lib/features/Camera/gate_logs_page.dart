import 'package:flutter/material.dart';
import 'dart:ui';
// استيراد ملف الألوان المركزي والويدجت المشتركة لضمان الربط المعماري
import 'package:smart_village_for_green_gnergy_optimization/core/theme/app_colors.dart';
import 'shared_widgets.dart';

class GateLogsPage extends StatelessWidget {
  const GateLogsPage({super.key});

  @override
  Widget build(BuildContext context) {
    // محاكاة لبيانات السجلات الخاصة ببوابة القرية الذكية
    final logs = List.generate(
      14,
      (i) => i.isEven
          ? ('Check in', '03:35 AM • 24/Aug/2026', Icons.login_rounded)
          : ('Check out', '11:20 PM • 24/Aug/2026', Icons.logout_rounded),
    );

    const Color mainBg = AppColors.scaffoldBg;
    const Color primaryNeon = AppColors.primaryNeon;

    return Scaffold(
      backgroundColor: mainBg,
      body: Stack(
        children: [
          // الخلفية المنحنية العلوية المتناسقة مع هوية المشروع
          const TopCurvedBackground(height: 200),

          Column(
            children: [
              const TopSearchBar(),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 10, 16, 20),
                child: Text(
                  'Gate Access Logs',
                  style: TextStyle(
                    color: primaryNeon, // استخدام اللون النيون الموحد
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.5,
                  ),
                ),
              ),

              // رأس الجدول بتصميم Glassmorphism
              const _TableHeader(),

              const SizedBox(height: 10),

              // قائمة السجلات المنسقة
              Expanded(
                child: ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  physics: const BouncingScrollPhysics(),
                  itemCount: logs.length,
                  itemBuilder: (_, i) {
                    final (type, date, icon) = logs[i];
                    return _TableRow(
                      type: type,
                      date: date,
                      icon: icon,
                    );
                  },
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                ),
              ),
              const SizedBox(height: 100), // مساحة للتنقل السفلي
            ],
          ),
        ],
      ),
    );
  }
}

class _TableHeader extends StatelessWidget {
  const _TableHeader();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: AppColors.cardBg.withOpacity(0.5), // تأثير شفاف زجاجي
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: AppColors.cardBorder),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      child: const Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              'Activity Type',
              style: TextStyle(color: AppColors.primaryNeon, fontWeight: FontWeight.bold, fontSize: 13),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              'Timestamp',
              style: TextStyle(color: AppColors.primaryNeon, fontWeight: FontWeight.bold, fontSize: 13),
            ),
          ),
        ],
      ),
    );
  }
}

class _TableRow extends StatelessWidget {
  final String type;
  final String date;
  final IconData icon;

  const _TableRow({
    required this.type,
    required this.date,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
      decoration: BoxDecoration(
        color: AppColors.cardBg.withOpacity(0.3), // تأثير شفاف زجاجي مطور
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.03)),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: type.contains('in') ? AppColors.success.withOpacity(0.1) : AppColors.warning.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    icon,
                    size: 16,
                    color: type.contains('in') ? AppColors.success : AppColors.warning,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  type,
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 14),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              date,
              style: const TextStyle(color: AppColors.textGrey, fontSize: 12),
            ),
          ),
          const Icon(Icons.arrow_forward_ios_rounded, color: Colors.white10, size: 14),
        ],
      ),
    );
  }
}
