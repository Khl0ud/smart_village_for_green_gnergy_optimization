import 'dart:async';
import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:smart_village_for_green_gnergy_optimization/core/theme/app_colors.dart';
import 'package:smart_village_for_green_gnergy_optimization/core/services/sensor_service.dart';
import 'package:smart_village_for_green_gnergy_optimization/core/services/device_service.dart';

class FarmingControlScreen extends StatefulWidget {
  const FarmingControlScreen({super.key});

  @override
  State<FarmingControlScreen> createState() => _FarmingControlScreenState();
}

class _FarmingControlScreenState extends State<FarmingControlScreen> {
  final SensorService _sensorService = SensorService();
  final DeviceService _deviceService = DeviceService();
  Timer? _refreshTimer;

  // متغيرات تمثل القراءات القادمة من السيرفر
  double temperature = 0.0; 
  double humidity = 0.0; 
  double soilPercent = 0.0; 
  bool isPumpOn = false; 
  bool isValveOpen = false; 
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchData();
    // تحديث تلقائي كل 10 ثوانٍ
    _refreshTimer = Timer.periodic(const Duration(seconds: 10), (_) => _fetchData());
  }

  @override
  void dispose() {
    _refreshTimer?.cancel();
    super.dispose();
  }

  Future<void> _fetchData() async {
    // جلب البيانات من المنطقة 2 (عادة ما تكون للحديقة) أو 1 حسب توزيع المشروع
    // سأقوم بجلب بيانات المنطقة 1 و 2 لضمان الحصول على البيانات
    final sensorReadings = await _sensorService.getLatestReadings(2);
    final devices = await _deviceService.getDevicesByZone(2);

    if (mounted) {
      setState(() {
        // تحديث الحساسات
        for (var r in sensorReadings) {
          final type = r['type']?.toString() ?? '';
          final value = (r['value'] ?? 0.0).toDouble();
          
          if (type == 'Temperature' || type == '0') temperature = value;
          if (type == 'Humidity' || type == '2') humidity = value;
          if (type == 'SoilMoisture' || type == '3') soilPercent = (value / 100).clamp(0.0, 1.0);
        }

        // تحديث الأجهزة
        for (var d in devices) {
          final type = d['type']?.toString().toLowerCase() ?? '';
          final state = d['currentState']?.toString().toUpperCase() == 'ON';
          
          if (type.contains('pump')) isPumpOn = state;
          if (type.contains('valve')) isValveOpen = state;
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
                  onRefresh: _fetchData,
                  color: AppColors.primaryNeon,
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      children: [
                        const SizedBox(height: 30),
                        _buildHeader(),
                        const SizedBox(height: 30),
                        _buildWeatherStatusCard(),
                        const SizedBox(height: 20),
                        _buildSoilMoistureSection(),
                        const SizedBox(height: 25),
                        _buildSystemStatusGrid(),
                        const SizedBox(height: 40),
                        Text(
                          "Last update: ${DateTime.now().hour}:${DateTime.now().minute}:${DateTime.now().second}",
                          style: const TextStyle(color: AppColors.textGrey, fontSize: 10),
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
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
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: AppColors.mainGradient,
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          "Farming Control",
          style: TextStyle(color: AppColors.textLight, fontSize: 24, fontWeight: FontWeight.bold),
        ),
        IconButton(
          onPressed: _fetchData,
          icon: const Icon(Icons.refresh_rounded, color: AppColors.primaryNeon),
        ),
      ],
    );
  }

  Widget _buildWeatherStatusCard() {
    return Container(
      padding: const EdgeInsets.all(25),
      decoration: BoxDecoration(
        color: AppColors.cardBg.withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "${temperature.toInt()}°C",
                style: const TextStyle(color: AppColors.textLight, fontSize: 32, fontWeight: FontWeight.w900),
              ),
              const Text("Air Temp", style: TextStyle(color: AppColors.textGrey, fontSize: 12)),
            ],
          ),
          Container(height: 40, width: 1, color: Colors.white10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                "${humidity.toInt()}%",
                style: const TextStyle(color: AppColors.info, fontSize: 32, fontWeight: FontWeight.w900),
              ),
              const Text("Air Humidity", style: TextStyle(color: AppColors.textGrey, fontSize: 12)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSoilMoistureSection() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 30),
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.cardBg.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Column(
        children: [
          CircularPercentIndicator(
            radius: 70.0,
            lineWidth: 12.0,
            percent: soilPercent,
            center: Text(
              "${(soilPercent * 100).toInt()}%",
              style: const TextStyle(color: AppColors.textLight, fontSize: 24, fontWeight: FontWeight.bold),
            ),
            progressColor: soilPercent < 0.3 ? AppColors.danger : AppColors.primaryNeon,
            backgroundColor: Colors.white10,
            circularStrokeCap: CircularStrokeCap.round,
            animation: true,
          ),
          const SizedBox(height: 15),
          const Text("Soil Moisture Level", style: TextStyle(color: AppColors.textGrey, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }

  Widget _buildSystemStatusGrid() {
    return Row(
      children: [
        _buildStatusTile(
          "Pump Status",
          isPumpOn ? "RUNNING" : "OFF",
          Icons.water_drop_rounded,
          isPumpOn ? AppColors.primaryNeon : AppColors.textGrey,
        ),
        const SizedBox(width: 15),
        _buildStatusTile(
          "Valve Status",
          isValveOpen ? "OPEN" : "CLOSED",
          Icons.settings_input_component_rounded,
          isValveOpen ? AppColors.warning : AppColors.textGrey,
        ),
      ],
    );
  }

  Widget _buildStatusTile(String title, String status, IconData icon, Color statusColor) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppColors.cardBg.withValues(alpha: 0.4),
          borderRadius: BorderRadius.circular(25),
          border: Border.all(color: AppColors.cardBorder),
        ),
        child: Column(
          children: [
            Icon(icon, color: statusColor, size: 30),
            const SizedBox(height: 12),
            Text(title, style: const TextStyle(color: AppColors.textGrey, fontSize: 11, fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Text(status, style: TextStyle(color: statusColor, fontWeight: FontWeight.w900, fontSize: 14)),
          ],
        ),
      ),
    );
  }
}
