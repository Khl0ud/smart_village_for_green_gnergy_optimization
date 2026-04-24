import 'package:flutter/material.dart';
import 'dart:ui';
// استيراد ملف الألوان المركزي و StatCard لضمان الربط المعماري للمشروع
import '../../core/theme/app_colors.dart';
import 'StatCard.dart';

import 'data/services/parking_service.dart';

class FindMyCarPage extends StatefulWidget {
  static const routeName = '/FindMyCarPageState';
  const FindMyCarPage({super.key});

  @override
  State<FindMyCarPage> createState() => _FindMyCarPageState();
}

class _FindMyCarPageState extends State<FindMyCarPage> {
  final ParkingService _parkingService = ParkingService();
  bool _isLoading = false;
  Map<String, dynamic>? _carLocation;
  final TextEditingController _deviceController = TextEditingController(text: "48484848");

  Future<void> _locateCar() async {
    setState(() => _isLoading = true);
    final result = await _parkingService.findMyCar(_deviceController.text);
    setState(() {
      _carLocation = result;
      _isLoading = false;
    });
    
    if (result == null && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Car not found or error occurred")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    const Color primaryNeon = AppColors.primaryNeon;

    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      extendBody: true,
      body: Stack(
        children: [
          _buildBackgroundGradient(),
          SafeArea(
            child: Column(
              children: [
                _buildModernHeader(context, primaryNeon),
                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    // زيادة المسافة السفلية لمنع تداخل الأزرار مع شريط التنقل
                    padding: const EdgeInsets.fromLTRB(20, 10, 20, 100),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildSearchField(primaryNeon),
                        const SizedBox(height: 20),
                        _buildSectionLabel(
                          _isLoading ? 'Searching...' : 'Your Car is here',
                        ), // النص مطابق للصورة

                        _buildMapDisplay(primaryNeon),
                        const SizedBox(height: 25),
                        _buildLocationDetails(),
                        const SizedBox(height: 25),
                        _buildActionButtons(primaryNeon),
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
          colors: [AppColors.scaffoldBg, AppColors.cardBg],
        ),
      ),
    );
  }

  Widget _buildSectionLabel(String label) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 15),
      child: Text(
        label,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildModernHeader(BuildContext context, Color accent) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(
              Icons.arrow_back_ios_new_rounded,
              color: Colors.white,
              size: 20,
            ),
            onPressed: () => Navigator.of(context).pop(),
          ),
          const Expanded(
            child: Text(
              'Find My Car',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: 40),
        ],
      ),
    );
  }

  Widget _buildMapDisplay(Color accent) {
    return Container(
      height: 280,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: AppColors.cardBorder),
        image: const DecorationImage(
          image: AssetImage('assets/parking_map.png'),
          fit: BoxFit.cover,
        ),
      ),
      child: Center(
        child: Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: accent,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: accent.withOpacity(0.4),
                blurRadius: 25,
                spreadRadius: 5,
              ),
            ],
          ),
          child: const Icon(
            Icons.directions_car_filled_rounded,
            color: Colors.black,
            size: 35,
          ),
        ),
      ),
    );
  }

  Widget _buildLocationDetails() {
    String parkingNo = _carLocation?["parkingNo"]?.toString() ?? "C4";
    String zone = _carLocation?["zone"]?.toString() ?? "2";

    return Row(
      children: [
        // استخدام Expanded مع StatCard المحدث يحل مشكلة الـ Overflow
        Expanded(
          child: StatCard(
            title: 'Parking no', // مطابق للصورة
            value: parkingNo,
            icon: Icons.grid_view_rounded,
          ),
        ),
        SizedBox(width: 15),
        Expanded(
          child: StatCard(
            title: 'Zone', // مطابق للصورة
            value: zone,
            icon: Icons.layers_rounded,
          ),
        ),
      ],
    );
  }


  Widget _buildActionButtons(Color accent) {
    return Row(
      children: [
        Expanded(
          child: _buildSmallAction(
            'Flash Lights',
            Icons.wb_sunny_rounded,
            accent,
            _locateCar,
          ),
        ),
        const SizedBox(width: 15),
        Expanded(
          child: _buildSmallAction(
            'Sound Alarm',
            Icons.volume_up_rounded,
            accent,
            _locateCar,
          ),
        ),
      ],
    );
  }

  Widget _buildSearchField(Color accent) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      decoration: BoxDecoration(
        color: AppColors.cardBg.withOpacity(0.3),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: TextField(
        controller: _deviceController,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          hintText: "Enter Device ID...",
          hintStyle: const TextStyle(color: AppColors.textGrey),
          border: InputBorder.none,
          suffixIcon: _isLoading 
            ? const SizedBox(width: 20, height: 20, child: Padding(padding: EdgeInsets.all(10), child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.primaryNeon)))
            : IconButton(icon: Icon(Icons.search, color: accent), onPressed: _locateCar),
        ),
        onSubmitted: (_) => _locateCar(),
      ),
    );
  }

  Widget _buildSmallAction(String title, IconData icon, Color accent, VoidCallback onTap) {

    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          height: 60,
          decoration: BoxDecoration(
            color: AppColors.cardBg.withOpacity(0.3),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: AppColors.cardBorder),
          ),
          child: InkWell(
            onTap: onTap,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, color: accent, size: 20),
                const SizedBox(width: 10),
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
