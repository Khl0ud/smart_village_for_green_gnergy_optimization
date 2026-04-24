import 'dart:async';
import 'package:flutter/material.dart';
import 'package:smart_village_for_green_gnergy_optimization/core/theme/app_colors.dart';
import 'package:smart_village_for_green_gnergy_optimization/core/services/device_service.dart';

class FanControlPage extends StatefulWidget {
  static const String routeName = '/FanControlPage';
  const FanControlPage({super.key});

  @override
  State<FanControlPage> createState() => _FanControlPageState();
}

class _FanControlPageState extends State<FanControlPage> {
  final DeviceService _deviceService = DeviceService();

  List<Map<String, dynamic>> _fans = [];
  bool _isLoading = true;
  double fanSpeed = 2.0;

  @override
  void initState() {
    super.initState();
    _fetchFans();
  }

  Future<void> _fetchFans() async {
    final devices = await _deviceService.getDevicesByZone(1);
    if (mounted) {
      setState(() {
        _fans = devices
            .where((d) =>
                d['type']?.toString().toLowerCase().contains('fan') ?? false)
            .map<Map<String, dynamic>>((d) => {
                  'id': d['id'],
                  'name': d['name'] ?? 'Fan',
                  'isOn': d['currentState']?.toString().toUpperCase() == 'ON',
                })
            .toList();

        if (_fans.isEmpty && devices.isNotEmpty) {
          _fans = devices
              .take(3)
              .map<Map<String, dynamic>>((d) => {
                    'id': d['id'],
                    'name': d['name'] ?? 'Device',
                    'isOn': d['currentState']?.toString().toUpperCase() == 'ON',
                  })
              .toList();
        }
        _isLoading = false;
      });
    }
  }

  Future<void> _toggleFan(int index) async {
    final fan = _fans[index];
    final isOn = fan['isOn'] as bool;
    final command = isOn ? 'OFF' : 'ON';

    setState(() => _fans[index]['isOn'] = !isOn);

    final success =
        await _deviceService.controlDevice(fan['id'] as int, command);

    if (!success && mounted) {
      setState(() => _fans[index]['isOn'] = isOn);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to control fan. Check connection.'),
          backgroundColor: AppColors.danger,
        ),
      );
    }
  }

  Future<void> _turnOffAll() async {
    setState(() {
      for (var f in _fans) {
        f['isOn'] = false;
      }
      fanSpeed = 0;
    });
    await _deviceService.controlBulk(1, 'Fan', 'OFF');
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
          icon: const Icon(Icons.arrow_back_ios,
              color: AppColors.textLight, size: 22),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Fan Control',
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 22,
                color: AppColors.textLight)),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded,
                color: AppColors.primaryNeon),
            onPressed: () {
              setState(() => _isLoading = true);
              _fetchFans();
            },
          ),
        ],
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(color: AppColors.primaryNeon))
          : Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  Expanded(
                    child: _fans.isEmpty
                        ? const Center(
                            child: Text('No fan devices found in zone.',
                                style: TextStyle(color: AppColors.textGrey)))
                        : ListView.separated(
                            itemCount: _fans.length,
                            separatorBuilder: (_, __) =>
                                const SizedBox(height: 15),
                            itemBuilder: (context, i) {
                              final fan = _fans[i];
                              return _buildFanTile(
                                fan['name'] as String,
                                fan['isOn'] as bool,
                                (_) => _toggleFan(i),
                              );
                            },
                          ),
                  ),
                  const SizedBox(height: 20),
                  _buildSpeedControlCard(),
                  const SizedBox(height: 20),
                  _buildTurnOffAllButton(),
                  const SizedBox(height: 20),
                ],
              ),
            ),
    );
  }

  Widget _buildFanTile(String title, bool isOn, Function(bool) onChanged) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: AppColors.cardBg.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(Icons.wind_power,
                  color: isOn ? AppColors.primaryNeon : AppColors.textGrey,
                  size: 28),
              const SizedBox(width: 15),
              Text(title,
                  style: const TextStyle(
                      color: AppColors.textLight,
                      fontSize: 16,
                      fontWeight: FontWeight.w500)),
            ],
          ),
          Switch(
            value: isOn,
            activeColor: AppColors.primaryNeon,
            activeTrackColor: AppColors.primaryNeon.withValues(alpha: 0.3),
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }

  Widget _buildSpeedControlCard() {
    return Container(
      padding: const EdgeInsets.all(25),
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.cardBg.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(25),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Column(
        children: [
          const Text('Fan Speed Control',
              style: TextStyle(
                  color: AppColors.textGrey,
                  fontSize: 18,
                  fontWeight: FontWeight.w500)),
          const SizedBox(height: 10),
          Slider(
            value: fanSpeed,
            min: 0,
            max: 4,
            divisions: 4,
            activeColor: AppColors.primaryNeon,
            inactiveColor: AppColors.glassWhite,
            onChanged: (val) => setState(() => fanSpeed = val),
          ),
          Text('Speed: ${fanSpeed.round()}',
              style: const TextStyle(
                  color: AppColors.textLight,
                  fontSize: 16,
                  fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildTurnOffAllButton() {
    return SizedBox(
      width: double.infinity,
      height: 60,
      child: ElevatedButton.icon(
        onPressed: _turnOffAll,
        icon: const Icon(Icons.power_settings_new,
            color: AppColors.textLight),
        label: const Text('Turn Off All Fans',
            style: TextStyle(
                color: AppColors.textLight,
                fontWeight: FontWeight.bold,
                fontSize: 16)),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.danger,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        ),
      ),
    );
  }
}
