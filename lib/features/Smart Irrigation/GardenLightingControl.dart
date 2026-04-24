import 'dart:async';
import 'package:flutter/material.dart';
import 'package:smart_village_for_green_gnergy_optimization/core/theme/app_colors.dart';
import 'package:smart_village_for_green_gnergy_optimization/core/services/device_service.dart';

class GardenLightingControl extends StatefulWidget {
  const GardenLightingControl({super.key});

  @override
  State<GardenLightingControl> createState() => _GardenLightingControlState();
}

class _GardenLightingControlState extends State<GardenLightingControl> {
  final DeviceService _deviceService = DeviceService();
  bool isGardenLightOn = false;
  int? _deviceId;
  bool _isLoading = true;
  Timer? _refreshTimer;

  @override
  void initState() {
    super.initState();
    _fetchLightStatus();
    _refreshTimer = Timer.periodic(const Duration(seconds: 10), (_) => _fetchLightStatus());
  }

  @override
  void dispose() {
    _refreshTimer?.cancel();
    super.dispose();
  }

  Future<void> _fetchLightStatus() async {
    final devices = await _deviceService.getDevicesByZone(1);
    if (mounted) {
      setState(() {
        for (var d in devices) {
          final type = d['type']?.toString().toLowerCase() ?? '';
          if (type.contains('light') || type.contains('garden')) {
            _deviceId = d['id'];
            isGardenLightOn = d['currentState']?.toString().toUpperCase() == 'ON';
            break;
          }
        }
        _isLoading = false;
      });
    }
  }

  Future<void> _toggleLight(bool value) async {
    if (_deviceId == null) return;
    
    // Optimistic UI update
    setState(() => isGardenLightOn = value);
    
    final success = await _deviceService.controlDevice(_deviceId!, value ? 'ON' : 'OFF');
    if (!success && mounted) {
      setState(() => isGardenLightOn = !value);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to control garden light'), backgroundColor: AppColors.danger),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) return const SizedBox(height: 100, child: Center(child: CircularProgressIndicator(color: AppColors.primaryNeon)));

    return Container(
      padding: const EdgeInsets.all(25),
      decoration: BoxDecoration(
        color: AppColors.cardBg.withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Row(
        children: [
          _buildAnimatedBulb(),
          const SizedBox(width: 25),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "GARDEN LIGHTS",
                  style: TextStyle(color: AppColors.textGrey, fontSize: 12, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 5),
                Text(
                  isGardenLightOn ? "Lights Active" : "Daylight Mode",
                  style: const TextStyle(color: AppColors.textLight, fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 5),
                Text(
                  isGardenLightOn ? "Controlled via Server" : "System in standby",
                  style: const TextStyle(color: AppColors.textGrey, fontSize: 10),
                ),
              ],
            ),
          ),
          Switch(
            value: isGardenLightOn,
            onChanged: _toggleLight,
            activeColor: AppColors.primaryNeon,
          ),
        ],
      ),
    );
  }

  Widget _buildAnimatedBulb() {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 500),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: isGardenLightOn ? AppColors.primaryNeon.withValues(alpha: 0.1) : Colors.white10,
        shape: BoxShape.circle,
        boxShadow: isGardenLightOn 
          ? [BoxShadow(color: AppColors.primaryNeon.withValues(alpha: 0.3), blurRadius: 15, spreadRadius: 2)]
          : [],
      ),
      child: Icon(
        isGardenLightOn ? Icons.lightbulb_rounded : Icons.lightbulb_outline_rounded,
        color: isGardenLightOn ? AppColors.primaryNeon : AppColors.textGrey,
        size: 32,
      ),
    );
  }
}