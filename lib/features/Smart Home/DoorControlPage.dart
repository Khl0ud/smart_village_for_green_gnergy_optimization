import 'dart:async';
import 'package:flutter/material.dart';
import 'package:smart_village_for_green_gnergy_optimization/core/theme/app_colors.dart';
import 'package:smart_village_for_green_gnergy_optimization/core/services/device_service.dart';

class DoorControlPage extends StatefulWidget {
  static const String routeName = '/DoorControlPage';
  const DoorControlPage({super.key});

  @override
  State<DoorControlPage> createState() => _DoorControlPageState();
}

class _DoorControlPageState extends State<DoorControlPage> {
  final DeviceService _deviceService = DeviceService();

  // قائمة الأبواب المجلوبة من السيرفر
  List<Map<String, dynamic>> _doors = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchDoors();
  }

  Future<void> _fetchDoors() async {
    final devices = await _deviceService.getDevicesByZone(1);
    if (mounted) {
      setState(() {
        // فلترة الأجهزة من نوع "Door"
        _doors = devices
            .where((d) =>
                d['type']?.toString().toLowerCase().contains('door') ?? false)
            .map<Map<String, dynamic>>((d) => {
                  'id': d['id'],
                  'name': d['name'] ?? 'Door',
                  'isLocked': d['currentState']?.toString().toUpperCase() != 'ON',
                })
            .toList();

        // إذا لم تكن هناك أبواب مصنفة، اعرض كل الأجهزة
        if (_doors.isEmpty && devices.isNotEmpty) {
          _doors = devices
              .take(3)
              .map<Map<String, dynamic>>((d) => {
                    'id': d['id'],
                    'name': d['name'] ?? 'Device',
                    'isLocked': d['currentState']?.toString().toUpperCase() != 'ON',
                  })
              .toList();
        }
        _isLoading = false;
      });
    }
  }

  // فتح/قفل باب عبر السيرفر
  Future<void> _toggleDoor(int index) async {
    final door = _doors[index];
    final isCurrentlyLocked = door['isLocked'] as bool;
    final command = isCurrentlyLocked ? 'ON' : 'OFF';

    // تحديث الواجهة فوراً (Optimistic UI)
    setState(() => _doors[index]['isLocked'] = !isCurrentlyLocked);

    final success =
        await _deviceService.controlDevice(door['id'] as int, command);

    // إذا فشل السيرفر، ارجع للحالة السابقة
    if (!success && mounted) {
      setState(() => _doors[index]['isLocked'] = isCurrentlyLocked);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to control door. Check connection.'),
          backgroundColor: AppColors.danger,
        ),
      );
    }
  }

  // قفل كل الأبواب دفعة واحدة عبر السيرفر
  Future<void> _lockAll() async {
    setState(() {
      for (var d in _doors) {
        d['isLocked'] = true;
      }
    });
    await _deviceService.controlBulk(1, 'Door', 'OFF');
  }

  @override
  Widget build(BuildContext context) {
    final allLocked = _doors.every((d) => d['isLocked'] == true);

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
        title: const Text('Security & Doors',
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 22,
                color: AppColors.textLight)),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded, color: AppColors.primaryNeon),
            onPressed: () {
              setState(() => _isLoading = true);
              _fetchDoors();
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
                  _buildSecurityStatusCard(allLocked),
                  const SizedBox(height: 25),
                  Expanded(
                    child: _doors.isEmpty
                        ? const Center(
                            child: Text('No door devices found in zone.',
                                style: TextStyle(color: AppColors.textGrey)))
                        : ListView.separated(
                            itemCount: _doors.length,
                            separatorBuilder: (_, __) =>
                                const SizedBox(height: 15),
                            itemBuilder: (context, i) {
                              final door = _doors[i];
                              return _buildDoorActionTile(
                                door['name'] as String,
                                door['isLocked'] as bool,
                                () => _toggleDoor(i),
                              );
                            },
                          ),
                  ),
                  const SizedBox(height: 20),
                  _buildLockAllButton(),
                  const SizedBox(height: 20),
                ],
              ),
            ),
    );
  }

  Widget _buildSecurityStatusCard(bool allLocked) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.cardBg.withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
            color: AppColors.primaryNeon.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          Icon(
            allLocked
                ? Icons.verified_user_rounded
                : Icons.gpp_maybe_rounded,
            color: allLocked ? AppColors.success : AppColors.warning,
            size: 30,
          ),
          const SizedBox(width: 15),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                allLocked ? 'All Secured' : 'Some Doors Open',
                style: const TextStyle(
                    color: AppColors.textLight,
                    fontSize: 18,
                    fontWeight: FontWeight.bold),
              ),
              Text(
                '${_doors.length} doors monitored via server',
                style: const TextStyle(
                    color: AppColors.textGrey, fontSize: 13),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDoorActionTile(
      String title, bool isLocked, VoidCallback onTap) {
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
              Icon(Icons.door_sliding_outlined,
                  color: isLocked ? AppColors.textGrey : AppColors.primaryNeon,
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
                  Text(isLocked ? 'Locked' : 'Unlocked',
                      style: TextStyle(
                          color: isLocked
                              ? AppColors.textGrey
                              : AppColors.primaryNeon,
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
                backgroundColor: AppColors.glassWhite,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                elevation: 0,
              ),
              child: Text(isLocked ? 'Open' : 'Lock',
                  style: const TextStyle(
                      color: AppColors.textLight,
                      fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLockAllButton() {
    return SizedBox(
      width: double.infinity,
      height: 60,
      child: ElevatedButton.icon(
        onPressed: _lockAll,
        icon: const Icon(Icons.lock_rounded, color: AppColors.textDark),
        label: const Text('Lock All Doors',
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
