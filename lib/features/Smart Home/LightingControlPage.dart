import 'package:flutter/material.dart';
import 'package:smart_village_for_green_gnergy_optimization/core/theme/app_colors.dart';
import 'package:smart_village_for_green_gnergy_optimization/core/services/device_service.dart';
import 'dart:async';



class LightingControlPage extends StatefulWidget {
  static const String routeName = '/LightingControlPage';
  const LightingControlPage({Key? key}) : super(key: key);

  @override
  State<LightingControlPage> createState() => _LightingControlPageState();
}

class _LightingControlPageState extends State<LightingControlPage> {
  final DeviceService _deviceService = DeviceService();
  List<dynamic> _devices = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchDevices();
  }

  Future<void> _fetchDevices() async {
    // نفترض أن الزون الحالي رقم 1 (يمكنك تغييره ديناميكياً لاحقاً)
    final devices = await _deviceService.getDevicesByZone(1);
    if (mounted) {
      setState(() {
        _devices = devices;
        _isLoading = false;
      });
    }
  }

  Future<void> _toggleLight(int deviceId, bool isOn) async {
    final newState = isOn ? "ON" : "OFF";
    final success = await _deviceService.controlDevice(deviceId, newState);
    if (success) {
      _fetchDevices();
    }
  }

  Future<void> _controlAll(bool turnOn) async {
    final newState = turnOn ? "ON" : "OFF";
    if (_devices.isEmpty) return;

    setState(() => _isLoading = true);
    final success = await _deviceService.controlBulk(1, 'Light', newState);
    if (success) {
      _fetchDevices();
    }
    setState(() => _isLoading = false);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBg, // استخدام الخلفية الموحدة
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: AppColors.textLight, size: 22),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Lighting", // مطابق للصورة المرفقة
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24, color: AppColors.textLight),
        ),
      ),
      body: _isLoading 
        ? const Center(child: CircularProgressIndicator(color: AppColors.primaryNeon))
        : Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Control every light in your home",
                  style: TextStyle(color: AppColors.textGrey, fontSize: 14),
                ),
                const SizedBox(height: 25),
                
                Row(
                  children: [
                    Expanded(child: _buildMasterButton("All On", Icons.lightbulb, true, () => _controlAll(true))),
                    const SizedBox(width: 15),
                    Expanded(child: _buildMasterButton("All Off", Icons.lightbulb_outline, false, () => _controlAll(false))),
                  ],
                ),
                const SizedBox(height: 30),
    
                Expanded(
                  child: RefreshIndicator(
                    onRefresh: _fetchDevices,
                    color: AppColors.primaryNeon,
                    child: GridView.builder(
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 15,
                        mainAxisSpacing: 15,
                        childAspectRatio: 1.1,
                      ),
                      itemCount: _devices.length,
                      itemBuilder: (context, index) {
                        final device = _devices[index];
                        final bool isOn = device['currentState'] == "ON" || device['currentState'] == "true";
                        return _buildLightCard(
                          device['name'] ?? "Light", 
                          isOn, 
                          (val) => _toggleLight((device['id'] as num).toInt(), val)
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),

    );
  }

  // أزرار التحكم العلوي بتصميم Stadium
  Widget _buildMasterButton(String label, IconData icon, bool turnOn, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(15),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: AppColors.cardBg.withValues(alpha: 0.3),
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: AppColors.cardBorder),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: AppColors.textLight, size: 20),
            const SizedBox(width: 8),
            Text(label, style: const TextStyle(color: AppColors.textLight, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }


  // كارت الغرفة الذكي بتصميم Glassmorphism المتغير
  Widget _buildLightCard(String room, bool isOn, Function(bool) onChanged) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        // التوهج الأخضر للكارت عند التشغيل مطابق للصورة
        color: isOn ? AppColors.primaryNeon.withValues(alpha: 0.15) : AppColors.cardBg.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(25),
        border: Border.all(
          color: isOn ? AppColors.primaryNeon.withValues(alpha: 0.5) : AppColors.cardBorder,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(Icons.lightbulb, color: isOn ? AppColors.primaryNeon : AppColors.textGrey, size: 28),
              Switch(
                value: isOn,
                activeColor: AppColors.primaryNeon,
                onChanged: onChanged,
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(room, style: const TextStyle(color: AppColors.textLight, fontSize: 16, fontWeight: FontWeight.bold)),
              Text(isOn ? "On" : "Off", style: TextStyle(color: isOn ? AppColors.primaryNeon : AppColors.textGrey, fontSize: 12)),
            ],
          ),
        ],
      ),
    );
  }
}
