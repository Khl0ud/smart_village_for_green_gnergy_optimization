import 'dart:async';
import 'package:flutter/material.dart';
import 'package:smart_village_for_green_gnergy_optimization/core/theme/app_colors.dart';
import 'package:smart_village_for_green_gnergy_optimization/core/services/device_service.dart';

class ValveControlPage extends StatefulWidget {
  static const String routeName = '/ValveControlPage';
  const ValveControlPage({super.key});

  @override
  State<ValveControlPage> createState() => _ValveControlPageState();
}

class _ValveControlPageState extends State<ValveControlPage> {
  final DeviceService _deviceService = DeviceService();

  List<Map<String, dynamic>> _valves = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchValves();
  }

  Future<void> _fetchValves() async {
    final devices = await _deviceService.getDevicesByZone(1);
    if (mounted) {
      setState(() {
        _valves = devices
            .where((d) =>
                d['type']?.toString().toLowerCase().contains('valve') ?? false)
            .map<Map<String, dynamic>>((d) => {
                  'id': d['id'],
                  'name': d['name'] ?? 'Valve',
                  'isOpen': d['currentState']?.toString().toUpperCase() == 'ON',
                  'icon': Icons.water_drop_rounded,
                })
            .toList();

        if (_valves.isEmpty && devices.isNotEmpty) {
          _valves = devices
              .take(3)
              .map<Map<String, dynamic>>((d) => {
                    'id': d['id'],
                    'name': d['name'] ?? 'Device',
                    'isOpen': d['currentState']?.toString().toUpperCase() == 'ON',
                    'icon': Icons.water_drop_rounded,
                  })
              .toList();
        }
        _isLoading = false;
      });
    }
  }

  Future<void> _toggleValve(int index) async {
    final valve = _valves[index];
    final isOpen = valve['isOpen'] as bool;
    final command = isOpen ? 'OFF' : 'ON';

    setState(() => _valves[index]['isOpen'] = !isOpen);

    final success =
        await _deviceService.controlDevice(valve['id'] as int, command);

    if (!success && mounted) {
      setState(() => _valves[index]['isOpen'] = isOpen);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to control valve. Check connection.'),
          backgroundColor: AppColors.danger,
        ),
      );
    }
  }

  Future<void> _closeAll() async {
    setState(() {
      for (var v in _valves) {
        v['isOpen'] = false;
      }
    });
    await _deviceService.controlBulk(1, 'Valve', 'OFF');
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
        title: const Text('Valve Control',
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
              _fetchValves();
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
                  const SizedBox(height: 10),
                  Expanded(
                    child: _valves.isEmpty
                        ? const Center(
                            child: Text('No valve devices found in zone.',
                                style: TextStyle(color: AppColors.textGrey)))
                        : ListView.separated(
                            itemCount: _valves.length,
                            separatorBuilder: (_, __) =>
                                const SizedBox(height: 15),
                            itemBuilder: (context, i) {
                              final valve = _valves[i];
                              return _buildValveActionTile(
                                valve['name'] as String,
                                valve['isOpen'] as bool,
                                valve['icon'] as IconData,
                                () => _toggleValve(i),
                              );
                            },
                          ),
                  ),
                  const SizedBox(height: 20),
                  _buildCloseAllButton(),
                  const SizedBox(height: 20),
                ],
              ),
            ),
    );
  }

  Widget _buildValveActionTile(
      String title, bool isOpen, IconData icon, VoidCallback onTap) {
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
              Icon(icon,
                  color: isOpen ? AppColors.info : AppColors.textGrey,
                  size: 28),
              const SizedBox(width: 15),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: const TextStyle(
                          color: AppColors.textLight,
                          fontSize: 16,
                          fontWeight: FontWeight.w600)),
                  Text(isOpen ? 'Open' : 'Closed',
                      style: TextStyle(
                          color: isOpen ? AppColors.info : AppColors.textGrey,
                          fontSize: 12)),
                ],
              ),
            ],
          ),
          SizedBox(
            width: 100,
            height: 45,
            child: ElevatedButton(
              onPressed: onTap,
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    isOpen ? AppColors.success : AppColors.danger,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                elevation: 0,
              ),
              child: Text(isOpen ? 'Close' : 'Open',
                  style: const TextStyle(
                      color: AppColors.textDark,
                      fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCloseAllButton() {
    return SizedBox(
      width: double.infinity,
      height: 60,
      child: ElevatedButton.icon(
        onPressed: _closeAll,
        icon: const Icon(Icons.lock_rounded, color: AppColors.textDark),
        label: const Text('Close All Valves',
            style: TextStyle(
                color: AppColors.textDark,
                fontWeight: FontWeight.bold,
                fontSize: 16)),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryNeon,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        ),
      ),
    );
  }
}
