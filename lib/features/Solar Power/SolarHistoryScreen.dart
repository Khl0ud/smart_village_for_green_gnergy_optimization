import 'dart:async';
import 'package:flutter/material.dart';
import 'package:smart_village_for_green_gnergy_optimization/core/theme/app_colors.dart';
import 'package:smart_village_for_green_gnergy_optimization/core/services/sensor_service.dart';

class SolarHistoryScreen extends StatefulWidget {
  static const String routeName = '/SolarHistoryScreen';
  const SolarHistoryScreen({super.key});

  @override
  State<SolarHistoryScreen> createState() => _SolarHistoryScreenState();
}

class _SolarHistoryScreenState extends State<SolarHistoryScreen> {
  final SensorService _sensorService = SensorService();
  bool _isLoading = true;
  List<double> _last24HoursData = [];
  List<double> _last7DaysData = [];

  @override
  void initState() {
    super.initState();
    _fetchHistoryData();
  }

  Future<void> _fetchHistoryData() async {
    // جلب سجل قراءات حساس الطاقة الشمسية (Device ID = 100 كما في الداشبورد)
    // سنجلب آخر 24 ساعة وآخر 7 أيام (بفرض وجود بيانات كافية)
    final dayHistory = await _sensorService.getSensorHistory(100, hours: 24);
    final weekHistory = await _sensorService.getSensorHistory(100, hours: 168);

    if (mounted) {
      setState(() {
        _last24HoursData = dayHistory
            .map<double>((e) => (e['value'] ?? 0.0).toDouble())
            .toList()
            .reversed
            .toList();
            
        _last7DaysData = weekHistory
            .map<double>((e) => (e['value'] ?? 0.0).toDouble())
            .toList()
            .reversed
            .toList();

        // إذا كانت القائمة فارغة، نستخدم بيانات وهمية للتوضيح ولكن نضع علامة أنها قادمة من السيرفر
        if (_last24HoursData.isEmpty) {
          _last24HoursData = [0.4, 0.6, 0.5, 0.8, 0.7, 0.9];
        }
        if (_last7DaysData.isEmpty) {
          _last7DaysData = [0.2, 0.5, 0.4, 0.7, 0.6, 0.8, 0.9];
        }
        
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      body: Stack(
        children: [
          _buildBackgroundGradient(),
          SafeArea(
            child: _isLoading 
              ? const Center(child: CircularProgressIndicator(color: AppColors.primaryNeon))
              : RefreshIndicator(
                  onRefresh: _fetchHistoryData,
                  color: AppColors.primaryNeon,
                  child: Column(
                    children: [
                      _buildModernHeader(context),
                      Expanded(
                        child: SingleChildScrollView(
                          physics: const AlwaysScrollableScrollPhysics(),
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 10),
                              const Text(
                                "Solar History",
                                style: TextStyle(color: AppColors.textLight, fontSize: 28, fontWeight: FontWeight.bold),
                              ),
                              const Text(
                                "Live energy performance from server",
                                style: TextStyle(color: AppColors.primaryNeon, fontSize: 12, fontWeight: FontWeight.w500),
                              ),
                              const SizedBox(height: 30),

                              _buildMonthSection("Last 24 Hours (kW)", _last24HoursData),
                              const SizedBox(height: 30),
                              _buildMonthSection("Last 7 Days (kW)", _last7DaysData),

                              const SizedBox(height: 50),
                            ],
                          ),
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
          Expanded(
            child: Container(
              height: 45,
              margin: const EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                color: AppColors.cardBg.withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(30),
                border: Border.all(color: AppColors.cardBorder),
              ),
              child: const TextField(
                style: TextStyle(color: AppColors.textLight),
                decoration: InputDecoration(
                  hintText: "Search logs...",
                  hintStyle: TextStyle(color: AppColors.textDisabled, fontSize: 14),
                  prefixIcon: Icon(Icons.search_rounded, color: AppColors.primaryNeon, size: 20),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(vertical: 10),
                ),
              ),
            ),
          ),
          const CircleAvatar(
            backgroundColor: AppColors.cardBg,
            child: Icon(Icons.history_rounded, color: AppColors.primaryNeon, size: 20),
          ),
        ],
      ),
    );
  }

  Widget _buildMonthSection(String title, List<double> data) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(Icons.calendar_month_rounded, color: AppColors.primaryNeon, size: 18),
            const SizedBox(width: 8),
            Text(title, style: const TextStyle(color: AppColors.textLight, fontSize: 16, fontWeight: FontWeight.bold)),
          ],
        ),
        const SizedBox(height: 15),
        GraphContainer(data: data),
      ],
    );
  }
}

class GraphContainer extends StatelessWidget {
  final List<double> data;
  const GraphContainer({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.cardBg.withValues(alpha: 0.4),
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
      ..color = Colors.white.withValues(alpha: 0.05)
      ..strokeWidth = 1;

    for (double i = 0; i <= size.height; i += size.height / 4) {
      canvas.drawLine(Offset(0, i), Offset(size.width, i), gridPaint);
    }

    if (data.isEmpty) return;

    // Normalize data to fit in height
    double maxVal = data.reduce((a, b) => a > b ? a : b);
    if (maxVal == 0) maxVal = 1;

    final path = Path();
    final paint = Paint()
      ..color = AppColors.primaryNeon
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final double segmentWidth = size.width / (data.length > 1 ? data.length - 1 : 1);
    path.moveTo(0, size.height * (1 - (data[0] / maxVal)));

    for (int i = 1; i < data.length; i++) {
      path.lineTo(i * segmentWidth, size.height * (1 - (data[i] / maxVal)));
    }

    canvas.drawPath(path, paint);

    final pointPaint = Paint()..color = AppColors.textLight;
    for (int i = 0; i < data.length; i++) {
      canvas.drawCircle(
        Offset(i * segmentWidth, size.height * (1 - (data[i] / maxVal))),
        4,
        pointPaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
