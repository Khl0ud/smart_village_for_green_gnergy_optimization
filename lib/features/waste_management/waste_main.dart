import 'package:flutter/material.dart';
import 'package:smart_village_for_green_gnergy_optimization/core/theme/app_colors.dart';
import 'package:percent_indicator/percent_indicator.dart';

// استيراد الصفحات الأخرى للربط
import 'dashboard_screen.dart';
import 'bin_levels_screen.dart';
import 'map_screen.dart';
import 'collection_request_screen.dart';

class Bin {
  final String id;
  final String location;
  final double fill;
  Bin({required this.id, required this.location, required this.fill});
}

class WasteDashboard extends StatefulWidget {
  static const String routeName = '/WasteDashboard';
  const WasteDashboard({super.key});

  @override
  State<WasteDashboard> createState() => _WasteDashboardState();
}

class _WasteDashboardState extends State<WasteDashboard> {
  final List<Bin> bins = [
    Bin(id: 'B-01', location: 'Zone A', fill: 0.92),
    Bin(id: 'B-02', location: 'Zone B', fill: 0.64),
    Bin(id: 'B-03', location: 'Zone C', fill: 0.38),
    Bin(id: 'B-04', location: 'Zone D', fill: 0.18),
    Bin(id: 'B-05', location: 'Zone E', fill: 0.05),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
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
                        // كارت الحالة يفتح صفحة الداشبورد التفصيلية
                        GestureDetector(
                          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => DashboardScreen(bins: bins))),
                          child: _buildOverallStatusCard(),
                        ),
                        const SizedBox(height: 25),
                        _buildSectionHeader("Bin Levels", Icons.analytics_rounded),
                        // قائمة الصناديق تفتح صفحة المستويات
                        GestureDetector(
                          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => BinLevelsScreen(bins: bins))),
                          child: _buildBinsList(),
                        ),
                        const SizedBox(height: 25),
                        // الأزرار التي كانت لا تعمل (تم تفعيلها الآن)
                        _buildActionButtons(context),
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
          const Text("Waste Management", style: TextStyle(color: AppColors.textLight, fontSize: 22, fontWeight: FontWeight.bold)),
          const CircleAvatar(
            backgroundColor: AppColors.cardBg,
            child: Icon(Icons.delete_sweep_rounded, color: AppColors.primaryNeon),
          ),
        ],
      ),
    );
  }

  Widget _buildOverallStatusCard() {
    return Container(
      padding: const EdgeInsets.all(25),
      decoration: BoxDecoration(
        color: AppColors.cardBg.withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Row(
        children: [
          CircularPercentIndicator(
            radius: 50.0,
            lineWidth: 10.0,
            percent: 0.43,
            center: const Text("43%", style: TextStyle(color: AppColors.textLight, fontWeight: FontWeight.bold, fontSize: 18)),
            progressColor: AppColors.primaryNeon,
            backgroundColor: Colors.white10,
            circularStrokeCap: CircularStrokeCap.round,
          ),
          const SizedBox(width: 25),
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Overall Status", style: TextStyle(color: AppColors.textGrey, fontSize: 14)),
              Text("Moderate Fill", style: TextStyle(color: AppColors.textLight, fontSize: 20, fontWeight: FontWeight.bold)),
            ],
          ),
          const Spacer(),
          const Icon(Icons.arrow_forward_ios_rounded, color: AppColors.textGrey, size: 16),
        ],
      ),
    );
  }

  Widget _buildBinsList() {
    return Column(children: bins.take(2).map((bin) => _buildBinItem(bin)).toList());
  }

  Widget _buildBinItem(Bin bin) {
    Color statusColor = bin.fill > 0.8 ? AppColors.danger : (bin.fill > 0.5 ? AppColors.warning : AppColors.primaryNeon);
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: AppColors.cardBg.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Row(
        children: [
          CircularPercentIndicator(
            radius: 20.0,
            lineWidth: 3.0,
            percent: bin.fill,
            progressColor: statusColor,
            backgroundColor: Colors.white10,
          ),
          const SizedBox(width: 15),
          Text(bin.id, style: const TextStyle(color: AppColors.textLight, fontWeight: FontWeight.bold)),
          const Spacer(),
          const Icon(Icons.arrow_forward_ios_rounded, color: AppColors.textGrey, size: 12),
        ],
      ),
    );
  }

  // تفعيل أزرار التنقل
  Widget _buildActionButtons(BuildContext context) {
    return Row(
      children: [
        _buildActionTile(
          context,
          "Map View",
          Icons.map_rounded,
          AppColors.info,
              () => Navigator.push(context, MaterialPageRoute(builder: (context) => const MapScreen())),
        ),
        const SizedBox(width: 15),
        _buildActionTile(
          context,
          "Schedule",
          Icons.calendar_month_rounded,
          AppColors.primaryNeon,
              () => Navigator.push(context, MaterialPageRoute(builder: (context) => CollectionRequestScreen(bins: bins))),
        ),
      ],
    );
  }

  Widget _buildActionTile(BuildContext context, String title, IconData icon, Color color, VoidCallback onTap) {
    return Expanded(
      child: InkWell(
        onTap: onTap, // تم الربط بالدالة بنجاح
        borderRadius: BorderRadius.circular(25),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(25),
            border: Border.all(color: color.withValues(alpha: 0.2)),
          ),
          child: Column(
            children: [
              Icon(icon, color: color, size: 30),
              const SizedBox(height: 10),
              Text(title, style: TextStyle(color: color, fontWeight: FontWeight.bold)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15),
      child: Row(
        children: [
          Icon(icon, color: AppColors.primaryNeon, size: 20),
          const SizedBox(width: 10),
          Text(title, style: const TextStyle(color: AppColors.textLight, fontSize: 18, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}