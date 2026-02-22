import 'package:flutter/material.dart';
import 'dart:ui';
// استيراد ملف الألوان المركزي لضمان توحيد الهوية البصرية
import 'package:smart_village_for_green_gnergy_optimization/core/theme/app_colors.dart';

class SolarHistoryScreen extends StatelessWidget {
  // اسم المسار للربط في ملف main.dart
  static const String routeName = '/SolarHistoryScreen';

  const SolarHistoryScreen({super.key});

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
                        const Text(
                          "Solar History", // مطابق لعنوان صورتك
                          style: TextStyle(
                            color: AppColors.textLight,
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Text(
                          "Solar energy performance over time",
                          style: TextStyle(
                            color: AppColors.textGrey,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 30),

                        // سجل شهر مايو المطور
                        _buildMonthSection("May Statistics", [
                          0.4,
                          0.7,
                          0.5,
                          0.9,
                          0.6,
                          0.8,
                        ]),

                        const SizedBox(height: 30),

                        // سجل شهر يونيو المطور
                        _buildMonthSection("June Statistics", [
                          0.8,
                          0.5,
                          0.9,
                          0.4,
                          0.8,
                          0.7,
                        ]),

                        const SizedBox(height: 50),
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
            icon: const Icon(
              Icons.arrow_back_ios_new_rounded,
              color: AppColors.textLight,
              size: 22,
            ),
            onPressed: () => Navigator.pop(context),
          ),
          Expanded(
            child: Container(
              height: 45,
              margin: const EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                color: AppColors.cardBg.withOpacity(0.5),
                borderRadius: BorderRadius.circular(30),
                border: Border.all(color: AppColors.cardBorder),
              ),
              child: const TextField(
                decoration: InputDecoration(
                  hintText: "Search logs...",
                  hintStyle: TextStyle(
                    color: AppColors.textDisabled,
                    fontSize: 14,
                  ),
                  prefixIcon: Icon(
                    Icons.search_rounded,
                    color: AppColors.primaryNeon,
                    size: 20,
                  ),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(vertical: 10),
                ),
              ),
            ),
          ),
          const CircleAvatar(
            backgroundColor: AppColors.cardBg,
            child: Icon(
              Icons.history_rounded,
              color: AppColors.primaryNeon,
              size: 20,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMonthSection(String title, List<double> dummyData) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(
              Icons.calendar_month_rounded,
              color: AppColors.primaryNeon,
              size: 18,
            ),
            const SizedBox(width: 8),
            Text(
              title,
              style: const TextStyle(
                color: AppColors.textLight,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 15),
        GraphContainer(data: dummyData),
      ],
    );
  }
}

// ويدجت حاوية الرسم البياني بتأثير زجاجي متطور
class GraphContainer extends StatelessWidget {
  final List<double> data;
  const GraphContainer({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.cardBg.withOpacity(0.4),
        borderRadius: BorderRadius.circular(25),
        border: Border.all(color: AppColors.cardBorder),
      ),
      padding: const EdgeInsets.all(20),
      child: CustomPaint(painter: GraphPainter(data)),
    );
  }
}

class GraphPainter extends CustomPainter {
  final List<double> data;
  GraphPainter(this.data);

  @override
  void paint(Canvas canvas, Size size) {
    final gridPaint = Paint()
      ..color = Colors.white.withOpacity(0.05)
      ..strokeWidth = 1;

    for (double i = 0; i <= size.height; i += size.height / 4) {
      canvas.drawLine(Offset(0, i), Offset(size.width, i), gridPaint);
    }

    if (data.isEmpty) return;

    final path = Path();
    final paint = Paint()
      ..color = AppColors.primaryNeon
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final double segmentWidth = size.width / (data.length - 1);
    path.moveTo(0, size.height * (1 - data[0]));

    for (int i = 1; i < data.length; i++) {
      path.lineTo(i * segmentWidth, size.height * (1 - data[i]));
    }

    canvas.drawPath(path, paint);

    final pointPaint = Paint()..color = AppColors.textLight;
    for (int i = 0; i < data.length; i++) {
      canvas.drawCircle(
        Offset(i * segmentWidth, size.height * (1 - data[i])),
        4,
        pointPaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
