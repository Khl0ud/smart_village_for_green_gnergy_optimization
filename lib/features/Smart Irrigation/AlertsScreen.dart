import 'dart:async';
import 'package:flutter/material.dart';
import 'package:smart_village_for_green_gnergy_optimization/core/theme/app_colors.dart';
import 'package:smart_village_for_green_gnergy_optimization/core/services/sensor_service.dart';

class AlertsScreen extends StatefulWidget {
  const AlertsScreen({super.key});

  @override
  State<AlertsScreen> createState() => _AlertsScreenState();
}

class _AlertsScreenState extends State<AlertsScreen> {
  final SensorService _sensorService = SensorService();
  Timer? _refreshTimer;
  
  double soilMoisture = 100.0;
  bool isRaining = false;
  double temperature = 0.0;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchAlertsData();
    _refreshTimer = Timer.periodic(const Duration(seconds: 20), (_) => _fetchAlertsData());
  }

  @override
  void dispose() {
    _refreshTimer?.cancel();
    super.dispose();
  }

  Future<void> _fetchAlertsData() async {
    final readings = await _sensorService.getLatestReadings(1);
    if (mounted) {
      setState(() {
        for (var r in readings) {
          final type = r['type']?.toString() ?? '';
          final value = (r['value'] ?? 0.0).toDouble();
          
          if (type == 'SoilMoisture' || type == '3') soilMoisture = value;
          if (type == 'Rain' || type == '4') isRaining = value > 50;
          if (type == 'Temperature' || type == '0') temperature = value;
        }
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: AppColors.mainGradient,
          ),
        ),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildAppBar(context),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Text(
                  "System Notifications",
                  style: TextStyle(color: AppColors.textLight, fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ),
              Expanded(
                child: _isLoading 
                  ? const Center(child: CircularProgressIndicator(color: AppColors.primaryNeon))
                  : ListView(
                      padding: const EdgeInsets.all(20),
                      children: [
                        if (soilMoisture < 30)
                          _buildAlertCard(
                            title: "Critical Moisture!",
                            message: "Soil moisture is critically low (${soilMoisture.toInt()}%). Plants need water immediately.",
                            time: "Live",
                            icon: Icons.warning_amber_rounded,
                            accentColor: AppColors.danger,
                            isCritical: true,
                          ),
                        
                        if (isRaining)
                          _buildAlertCard(
                            title: "Rain Detected",
                            message: "Natural irrigation in progress. System components are secured.",
                            time: "Live",
                            icon: Icons.umbrella_rounded,
                            accentColor: AppColors.info,
                            isCritical: false,
                          ),

                        if (temperature > 35)
                          _buildAlertCard(
                            title: "Heat Alert",
                            message: "High temperature detected (${temperature.toInt()}°C). Monitoring evaporation rates.",
                            time: "Live",
                            icon: Icons.thermostat_rounded,
                            accentColor: AppColors.warning,
                            isCritical: false,
                          ),

                        if (soilMoisture >= 30 && !isRaining && temperature <= 35)
                          Center(
                            child: Padding(
                              padding: const EdgeInsets.all(40.0),
                              child: Column(
                                children: [
                                  Icon(Icons.check_circle_outline_rounded, color: AppColors.success.withValues(alpha: 0.3), size: 60),
                                  const SizedBox(height: 10),
                                  const Text("System Status Normal", style: TextStyle(color: AppColors.textGrey)),
                                ],
                              ),
                            ),
                          ),
                      ],
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: IconButton(
        icon: const Icon(Icons.arrow_back_ios_new, color: AppColors.textLight),
        onPressed: () => Navigator.pop(context),
      ),
    );
  }

  Widget _buildAlertCard({
    required String title,
    required String message,
    required String time,
    required IconData icon,
    required Color accentColor,
    required bool isCritical,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.cardBg.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(25),
        border: Border.all(
          color: isCritical ? accentColor.withValues(alpha: 0.5) : AppColors.cardBorder,
          width: isCritical ? 2 : 1,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            backgroundColor: accentColor.withValues(alpha: 0.1),
            child: Icon(icon, color: accentColor),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(title, style: TextStyle(color: accentColor, fontWeight: FontWeight.bold, fontSize: 16)),
                    Text(time, style: const TextStyle(color: AppColors.textGrey, fontSize: 12)),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  message,
                  style: const TextStyle(color: AppColors.textGrey, fontSize: 14, height: 1.4),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}