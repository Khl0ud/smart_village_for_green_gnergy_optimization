import 'dart:async';
import 'package:flutter/material.dart';
import 'package:smart_village_for_green_gnergy_optimization/core/theme/app_colors.dart';
import 'package:smart_village_for_green_gnergy_optimization/core/services/device_service.dart';
import 'package:smart_village_for_green_gnergy_optimization/core/services/sensor_service.dart';

class HomePage extends StatefulWidget {
  static const String routeName = '/home_page';
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final DeviceService _deviceService = DeviceService();
  final SensorService _sensorService = SensorService();
  Timer? _refreshTimer;

  bool isSecure = true;
  bool _isLoading = true;

  // قيم الحساسات من السيرفر
  String _gasValue = '--';
  String _smokeValue = '--';
  String _flameValue = '--';
  String _tempValue = '--';

  @override
  void initState() {
    super.initState();
    _fetchData();
    _refreshTimer = Timer.periodic(
      const Duration(seconds: 15),
      (_) => _fetchData(),
    );
  }

  @override
  void dispose() {
    _refreshTimer?.cancel();
    super.dispose();
  }

  Future<void> _fetchData() async {
    // جلب قراءات كل الحساسات في Zone 1 من السيرفر
    final readings = await _sensorService.getLatestReadings(1);

    if (mounted) {
      setState(() {
        for (var r in readings) {
          final type = r['type']?.toString() ?? '';
          final value = (r['value'] ?? 0.0).toDouble();
          if (type == 'GasLevel' || type == '1') {
            _gasValue = value.toStringAsFixed(2);
            // إذا كان الغاز أعلى من 80 فالنظام في خطر
            if (value > 80) isSecure = false;
          } else if (type == 'Smoke' || type == '5') {
            _smokeValue = value > 50 ? 'High' : 'Low';
          } else if (type == 'Flame' || type == '6') {
            _flameValue = value > 0 ? 'Detected' : 'None';
          } else if (type == 'Temperature' || type == '0') {
            _tempValue = value.toInt().toString();
          }
        }
        _isLoading = false;
      });
    }
  }

  // إيقاف الطوارئ - إرسال أمر Bulk OFF لكل الأجهزة
  Future<void> _emergencyStop() async {
    await _deviceService.controlBulk(1, 'All', 'OFF');
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('⚠ Emergency Stop Sent to Server!'),
          backgroundColor: AppColors.danger,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      body: SafeArea(
        child: _isLoading
            ? const Center(
                child: CircularProgressIndicator(color: AppColors.primaryNeon))
            : RefreshIndicator(
                onRefresh: _fetchData,
                color: AppColors.primaryNeon,
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 30),
                      _buildHeader(),
                      const SizedBox(height: 35),
                      _buildSecurityStatusCard(),
                      const SizedBox(height: 35),
                      const Text(
                        'Live Sensor Readings',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textLight,
                        ),
                      ),
                      const SizedBox(height: 8),
                      // بج آخر تحديث من السيرفر
                      Text(
                        'Auto-refresh every 15s from server',
                        style: TextStyle(
                            color: AppColors.primaryNeon.withValues(alpha: 0.7),
                            fontSize: 11),
                      ),
                      const SizedBox(height: 16),
                      _buildSensorsGrid(),
                      const SizedBox(height: 40),
                      _buildEmergencyButton(),
                      const SizedBox(height: 50),
                    ],
                  ),
                ),
              ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Smart Village',
                style: TextStyle(color: AppColors.textGrey, fontSize: 15)),
            SizedBox(height: 4),
            Text('Home Overview',
                style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textLight)),
          ],
        ),
        // زر التحديث اليدوي
        GestureDetector(
          onTap: () {
            setState(() => _isLoading = true);
            _fetchData();
          },
          child: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                  color: AppColors.primaryNeon.withValues(alpha: 0.3),
                  width: 1.5),
              color: AppColors.primaryNeon.withValues(alpha: 0.05),
            ),
            child: const Icon(Icons.refresh_rounded,
                color: AppColors.primaryNeon, size: 22),
          ),
        ),
      ],
    );
  }

  Widget _buildSecurityStatusCard() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.cardBg.withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(
          color: (isSecure ? AppColors.success : AppColors.danger)
              .withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        children: [
          _buildStatusIcon(),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isSecure ? 'System Secure' : 'System Alert',
                  style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textLight),
                ),
                Text(
                  isSecure
                      ? 'All sensors reporting normal'
                      : 'Gas/Flame detected! Check now.',
                  style: const TextStyle(
                      color: AppColors.textGrey, fontSize: 13),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusIcon() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: (isSecure ? AppColors.success : AppColors.danger)
            .withValues(alpha: 0.1),
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: (isSecure ? AppColors.success : AppColors.danger)
                .withValues(alpha: 0.2),
            blurRadius: 20,
            spreadRadius: 2,
          )
        ],
      ),
      child: Icon(
        isSecure ? Icons.shield_rounded : Icons.gpp_bad_rounded,
        color: isSecure ? AppColors.success : AppColors.danger,
        size: 28,
      ),
    );
  }

  Widget _buildSensorsGrid() {
    return Column(
      children: [
        Row(
          children: [
            _SensorBox(
                icon: Icons.local_gas_station_rounded,
                label: 'Gas',
                value: _gasValue,
                unit: 'ppm',
                color: double.tryParse(_gasValue) != null &&
                        (double.tryParse(_gasValue) ?? 0) > 80
                    ? AppColors.danger
                    : AppColors.info),
            const SizedBox(width: 16),
            _SensorBox(
                icon: Icons.smoke_free_rounded,
                label: 'Smoke',
                value: _smokeValue,
                unit: '',
                color: _smokeValue == 'High'
                    ? AppColors.danger
                    : AppColors.success),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            _SensorBox(
                icon: Icons.local_fire_department_rounded,
                label: 'Flame',
                value: _flameValue,
                unit: '',
                color: _flameValue == 'Detected'
                    ? AppColors.danger
                    : AppColors.warning),
            const SizedBox(width: 16),
            _SensorBox(
                icon: Icons.thermostat_rounded,
                label: 'Temp',
                value: _tempValue,
                unit: '°C',
                color: AppColors.danger),
          ],
        ),
      ],
    );
  }

  Widget _buildEmergencyButton() {
    return ElevatedButton(
      onPressed: _emergencyStop,
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.danger.withValues(alpha: 0.05),
        foregroundColor: AppColors.danger,
        minimumSize: const Size.fromHeight(65),
        side: const BorderSide(color: AppColors.danger, width: 1),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      ),
      child: const Text(
        'EMERGENCY STOP',
        style: TextStyle(
            fontSize: 16, fontWeight: FontWeight.bold, letterSpacing: 2),
      ),
    );
  }
}

class _SensorBox extends StatelessWidget {
  final IconData icon;
  final String label, value, unit;
  final Color color;

  const _SensorBox(
      {required this.icon,
      required this.label,
      required this.value,
      required this.unit,
      required this.color});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppColors.cardBg.withValues(alpha: 0.3),
          borderRadius: BorderRadius.circular(25),
          border: Border.all(color: AppColors.cardBorder),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12)),
              child: Icon(icon, color: color, size: 22),
            ),
            const SizedBox(height: 15),
            Text(label,
                style: const TextStyle(
                    color: AppColors.textGrey,
                    fontSize: 13,
                    fontWeight: FontWeight.w500)),
            const SizedBox(height: 6),
            Row(
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: [
                Text(value,
                    style: const TextStyle(
                        color: AppColors.textLight,
                        fontSize: 22,
                        fontWeight: FontWeight.bold)),
                if (unit.isNotEmpty) ...[
                  const SizedBox(width: 4),
                  Text(unit,
                      style: const TextStyle(
                          color: AppColors.textGrey, fontSize: 13)),
                ]
              ],
            ),
          ],
        ),
      ),
    );
  }
}
