import 'package:flutter/material.dart';
import 'dart:ui';
// استيراد ملف الألوان المركزي لضمان توحيد الهوية البصرية
import 'package:smart_village_for_green_gnergy_optimization/core/theme/app_colors.dart';
import 'SolarSettingsScreen.dart';
import 'SolarHistoryScreen.dart';

class SolarDashboard extends StatelessWidget {
  // اسم المسار للربط في ملف main.dart والداشبورد المركزي
  static const String routeName = '/SolarDashboard';

  const SolarDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBg, // استخدام الخلفية الموحدة
      body: Stack(
        children: [
          _buildBackgroundGradient(),
          SafeArea(
            child: Column(
              children: [
                _buildModernHeader(context),
                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 10),
                        _buildMainEnergyCard(), // كارت الطاقة الكبر المتوهج
                        const SizedBox(height: 30),
                        
                        const Text(
                          "System Statistics",
                          style: TextStyle(color: AppColors.textLight, fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 15),
                        
                        // إحصائيات النظام (Battery, Yield, Grid)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: const [
                            _StatCard(icon: Icons.battery_charging_full_rounded, title: "Battery", value: "85%", color: AppColors.success),
                            _StatCard(icon: Icons.bolt_rounded, title: "Yield", value: "4.2 kW", color: AppColors.warning),
                            _StatCard(icon: Icons.grid_view_rounded, title: "Grid", value: "0.0 kW", color: AppColors.info),
                          ],
                        ),
                        const SizedBox(height: 35),

                        _buildSectionHeader(context, "Generation History"),
                        const SizedBox(height: 15),

                        // الرسم البياني المطور بتأثير النيون
                        _buildPowerGraph(),
                        const SizedBox(height: 40),
                      ],
                    ),
                  ),
                ),
              ],
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

  Widget _buildModernHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back_ios_new_rounded, color: AppColors.textLight, size: 22),
            onPressed: () => Navigator.pop(context),
          ),
          const Text(
            "Solar Energy", // مطابق لعنوان صورتك
            style: TextStyle(color: AppColors.textLight, fontSize: 22, fontWeight: FontWeight.bold),
          ),
          IconButton(
            icon: const Icon(Icons.settings_outlined, color: AppColors.textLight),
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const SolarSettingsScreen())),
          ),
        ],
      ),
    );
  }

  Widget _buildMainEnergyCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(30),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: AppColors.neonGradient, // التدرج الأخضر المتوهج
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(color: AppColors.primaryNeon.withOpacity(0.3), blurRadius: 20, spreadRadius: 2),
        ],
      ),
      child: Column(
        children: const [
          Icon(Icons.solar_power_rounded, color: AppColors.textDark, size: 40),
          SizedBox(height: 15),
          Text("Total Generation", style: TextStyle(color: AppColors.textDark, fontSize: 16, fontWeight: FontWeight.w500)),
          SizedBox(height: 8),
          Text("12.4 kWh", style: TextStyle(color: AppColors.textDark, fontSize: 48, fontWeight: FontWeight.w900)), // مطابق للصورة
          SizedBox(height: 10),
          Text("Optimal Performance", style: TextStyle(color: AppColors.textDark, fontSize: 14, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: const TextStyle(color: AppColors.textLight, fontSize: 18, fontWeight: FontWeight.bold)),
        TextButton(
          onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const SolarHistoryScreen())),
          child: const Text("View History", style: TextStyle(color: AppColors.primaryNeon)),
        ),
      ],
    );
  }

  Widget _buildPowerGraph() {
    return Container(
      height: 200,
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.cardBg.withOpacity(0.4),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: AppColors.cardBorder),
      ),
      padding: const EdgeInsets.all(20),
      child: CustomPaint(
        painter: PowerGraphPainter(
          points: [
            const Offset(0, 140), const Offset(60, 120), const Offset(120, 130),
            const Offset(180, 40), const Offset(240, 90), const Offset(300, 20),
          ],
        ),
      ),
    );
  }
}

// ويدجت الكروت الإحصائية الموحدة
class _StatCard extends StatelessWidget {
  final IconData icon;
  final String title, value;
  final Color color;

  const _StatCard({required this.icon, required this.title, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.28,
      padding: const EdgeInsets.symmetric(vertical: 20),
      decoration: BoxDecoration(
        color: AppColors.cardBg.withOpacity(0.4),
        borderRadius: BorderRadius.circular(25),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 26),
          const SizedBox(height: 12),
          Text(value, style: const TextStyle(color: AppColors.textLight, fontSize: 16, fontWeight: FontWeight.w900)),
          Text(title, style: const TextStyle(color: AppColors.textGrey, fontSize: 12)),
        ],
      ),
    );
  }
}

// رسام الرسم البياني بتأثير نيون متوهج
class PowerGraphPainter extends CustomPainter {
  final List<Offset> points;
  PowerGraphPainter({required this.points});

  @override
  void paint(Canvas canvas, Size size) {
    final Paint linePaint = Paint()
      ..color = AppColors.primaryNeon
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final path = Path()..moveTo(points.first.dx, points.first.dy);
    for (var p in points.skip(1)) {
      path.lineTo(p.dx, p.dy);
    }
    canvas.drawPath(path, linePaint);
    
    final pointPaint = Paint()..color = AppColors.textLight;
    for (var p in points) {
      canvas.drawCircle(p, 4, pointPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
