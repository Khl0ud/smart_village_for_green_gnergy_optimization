import 'dart:async';
import 'package:flutter/material.dart';
import 'package:smart_village_for_green_gnergy_optimization/core/theme/app_colors.dart';
import 'package:smart_village_for_green_gnergy_optimization/core/services/sensor_service.dart';
import 'package:smart_village_for_green_gnergy_optimization/core/services/device_service.dart';
import 'package:http/http.dart' as http;
import 'package:smart_village_for_green_gnergy_optimization/core/api_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class GasSafetyPage extends StatefulWidget {
  static const String routeName = '/GasSafetyPage';
  const GasSafetyPage({super.key});

  @override
  State<GasSafetyPage> createState() => _GasSafetyPageState();
}

class _GasSafetyPageState extends State<GasSafetyPage> {
  final SensorService _sensorService = SensorService();
  final DeviceService _deviceService = DeviceService();
  Timer? _refreshTimer;

  bool isSafe = true;
  bool autoProtection = false;
  bool _isLoading = true;
  double _gasLevel = 0.0;
  double _flameDetected = 0.0;

  @override
  void initState() {
    super.initState();
    _fetchGasStatus();
    _refreshTimer = Timer.periodic(const Duration(seconds: 10), (_) => _fetchGasStatus());
  }

  @override
  void dispose() {
    _refreshTimer?.cancel();
    super.dispose();
  }

  Future<void> _fetchGasStatus() async {
    final readings = await _sensorService.getLatestReadings(1);
    if (mounted) {
      setState(() {
        for (var r in readings) {
          final type = r['type']?.toString() ?? '';
          final value = (r['value'] ?? 0.0).toDouble();
          if (type == 'GasLevel' || type == '1') _gasLevel = value;
          if (type == 'Flame' || type == '6') _flameDetected = value;
        }
        isSafe = _gasLevel < 80 && _flameDetected == 0;
        _isLoading = false;
      });
    }
  }

  Future<void> _toggleAutoProtection(bool value) async {
    setState(() => autoProtection = value);
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('jwt_token');
      if (token == null) return;
      await http.post(
        Uri.parse(ApiConstants.automationToggleGasProtection),
        headers: {'accept': '*/*', 'Authorization': 'Bearer $token', 'Content-Type': 'application/json'},
        body: jsonEncode({'enabled': value}),
      );
    } catch (_) {}
  }

  Future<void> _testSystem() async {
    await _sensorService.recordReading(
      deviceId: 1,
      type: 1, // 1 = GasLevel sensor type
      value: 0.0,
    );
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('✅ Gas test reading sent to server'),
        backgroundColor: AppColors.success,
        behavior: SnackBarBehavior.floating,
      ));
    }
  }

  Future<void> _silenceAlarm() async {
    await _deviceService.controlBulk(1, 'Alarm', 'OFF');
    if (mounted) {
      setState(() => isSafe = true);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('🔕 Alarm silenced via server'),
        backgroundColor: AppColors.warning,
        behavior: SnackBarBehavior.floating,
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: AppColors.textLight, size: 22),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Gas Safety System',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22, color: AppColors.textLight)),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded, color: AppColors.primaryNeon),
            onPressed: () { setState(() => _isLoading = true); _fetchGasStatus(); },
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: AppColors.primaryNeon))
          : Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildStatusIndicator(),
                  const SizedBox(height: 20),
                  Text(isSafe ? 'Gas Levels Normal' : 'GAS LEAK DETECTED',
                      style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.textLight)),
                  const SizedBox(height: 8),
                  Text(
                    'Gas: ${_gasLevel.toStringAsFixed(1)} ppm  •  Flame: ${_flameDetected > 0 ? "Detected" : "None"}',
                    style: const TextStyle(color: AppColors.textGrey, fontSize: 13),
                  ),
                  Text('Auto-refresh every 10s from server',
                      style: TextStyle(color: AppColors.primaryNeon.withValues(alpha: 0.6), fontSize: 11)),
                  const SizedBox(height: 40),
                  _buildAutoProtectionCard(),
                  const SizedBox(height: 30),
                  _buildActionButton(),
                ],
              ),
            ),
    );
  }

  Widget _buildStatusIndicator() {
    return Container(
      padding: const EdgeInsets.all(40),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: (isSafe ? AppColors.success : AppColors.danger).withValues(alpha: 0.05),
        border: Border.all(color: (isSafe ? AppColors.success : AppColors.danger).withValues(alpha: 0.3), width: 2),
      ),
      child: Icon(
        isSafe ? Icons.check_circle_outline_rounded : Icons.warning_amber_rounded,
        size: 100,
        color: isSafe ? AppColors.success : AppColors.danger,
      ),
    );
  }

  Widget _buildAutoProtectionCard() {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: AppColors.cardBg.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(25),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: SwitchListTile(
        title: const Text('Enable Auto Protection System',
            style: TextStyle(color: AppColors.textLight, fontWeight: FontWeight.w500, fontSize: 16)),
        subtitle: Text(
          autoProtection ? 'Server will auto-close valves on gas leak' : 'Manual control only',
          style: const TextStyle(color: AppColors.textGrey, fontSize: 12),
        ),
        value: autoProtection,
        activeColor: AppColors.primaryNeon,
        onChanged: _toggleAutoProtection,
      ),
    );
  }

  Widget _buildActionButton() {
    return SizedBox(
      width: double.infinity,
      height: 60,
      child: ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          backgroundColor: isSafe ? AppColors.textLight : AppColors.danger,
          foregroundColor: AppColors.textDark,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          elevation: 0,
        ),
        icon: Icon(isSafe ? Icons.bolt_rounded : Icons.notifications_off_rounded, size: 22),
        label: Text(isSafe ? 'Test Gas System' : 'Silence Alarm',
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        onPressed: isSafe ? _testSystem : _silenceAlarm,
      ),
    );
  }
}
