import 'package:flutter/material.dart';
import 'package:smart_village_for_green_gnergy_optimization/core/theme/app_colors.dart';
import 'package:smart_village_for_green_gnergy_optimization/core/services/sensor_service.dart';
import 'SolarSettingsScreen.dart';
import 'SolarHistoryScreen.dart';


class SolarDashboard extends StatefulWidget {
  static const String routeName = '/SolarDashboard';

  const SolarDashboard({super.key});

  @override
  State<SolarDashboard> createState() => _SolarDashboardState();
}

class _SolarDashboardState extends State<SolarDashboard> {
  final SensorService _sensorService = SensorService();
  bool _isLoading = true;
  Map<String, dynamic>? _latestData;
  List<dynamic> _history = [];

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    // جلب أحدث القراءات في الزون المخصص للطاقة الشمسية (مثلاً Zone 1)
    final latestList = await _sensorService.getLatestReadings(1);
    // جلب سجل قراءات حساس الطاقة (مثلاً DeviceId = 100)
    final history = await _sensorService.getSensorHistory(100, hours: 24);
    
    Map<String, dynamic>? solarData;
    if (latestList.isNotEmpty) {
      // البحث عن حساس الطاقة الشمسية في القائمة، أو أخذ أول قراءة كافتراضي
      solarData = latestList.firstWhere(
        (sensor) => sensor['deviceName']?.toString().contains('Solar') ?? false,
        orElse: () => latestList.first,
      );
    }

    if (mounted) {
      setState(() {
        _latestData = solarData;
        _history = history;
        _isLoading = false;
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    String totalGen = _latestData?['value']?.toString() ?? "12.4";
    String battery = _latestData?['battery']?.toString() ?? "85";
    String yieldValue = _latestData?['yield']?.toString() ?? "4.2";

    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      body: Stack(
        children: [
          _buildBackgroundGradient(),
          SafeArea(
            child: _isLoading 
              ? const Center(child: CircularProgressIndicator(color: AppColors.primaryNeon))
              : RefreshIndicator(
                  onRefresh: _fetchData,
                  color: AppColors.primaryNeon,
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
                              _buildMainEnergyCard(totalGen),
                              const SizedBox(height: 30),
                              
                              const Text(
                                "System Statistics",
                                style: TextStyle(color: AppColors.textLight, fontSize: 20, fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 15),
                              
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  _StatCard(icon: Icons.battery_charging_full_rounded, title: "Battery", value: "$battery%", color: AppColors.success),
                                  _StatCard(icon: Icons.bolt_rounded, title: "Yield", value: "$yieldValue kW", color: AppColors.warning),
                                  const _StatCard(icon: Icons.grid_view_rounded, title: "Grid", value: "0.0 kW", color: AppColors.info),
                                ],
                              ),
                              const SizedBox(height: 35),
            
                              _buildSectionHeader(context, "Generation History"),
                              const SizedBox(height: 15),
            
                              _buildPowerGraph(),
                              const SizedBox(height: 40),
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

  Widget _buildMainEnergyCard(String value) {
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
        children: [
          const Icon(Icons.solar_power_rounded, color: AppColors.textDark, size: 40),
          const SizedBox(height: 15),
          const Text("Total Generation", style: TextStyle(color: AppColors.textDark, fontSize: 16, fontWeight: FontWeight.w500)),
          const SizedBox(height: 8),
          Text("$value kWh", style: const TextStyle(color: AppColors.textDark, fontSize: 48, fontWeight: FontWeight.w900)), // مطابق للصورة
          const SizedBox(height: 10),
          const Text("Optimal Performance", style: TextStyle(color: AppColors.textDark, fontSize: 14, fontWeight: FontWeight.bold)),
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
    // تحويل البيانات التاريخية إلى نقاط للرسم البياني
    List<Offset> points = [];
    if (_history.isNotEmpty) {
      for (int i = 0; i < _history.length && i < 6; i++) {
        double x = i * 60.0;
        double val = (_history[i]['value'] ?? 0.0).toDouble();
        double y = 150 - (val * 10); // تحويل القيمة لارتفاع يناسب الرسم
        points.add(Offset(x, y.clamp(20, 180)));
      }
    } else {
      points = [
        const Offset(0, 140), const Offset(60, 120), const Offset(120, 130),
        const Offset(180, 40), const Offset(240, 90), const Offset(300, 20),
      ];
    }

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
        painter: PowerGraphPainter(points: points),
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
