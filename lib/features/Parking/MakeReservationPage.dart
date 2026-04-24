import 'package:flutter/material.dart';
import 'dart:ui';
// استيراد ملف الألوان المركزي لضمان الربط المعماري
import 'package:smart_village_for_green_gnergy_optimization/core/theme/app_colors.dart';
import 'ParkingScreen.dart';

import 'data/services/parking_service.dart';

class MakeReservationPage extends StatefulWidget {
  static const routeName = '/MakeReservationPage';
  const MakeReservationPage({super.key});

  @override
  State<MakeReservationPage> createState() => _MakeReservationPageState();
}

class _MakeReservationPageState extends State<MakeReservationPage> {
  final ParkingService _parkingService = ParkingService();
  String? selectedZoneId;
  final TextEditingController _plateController = TextEditingController();
  final TextEditingController _startTimeController = TextEditingController(text: DateTime.now().toIso8601String());
  final TextEditingController _endTimeController = TextEditingController(text: DateTime.now().add(const Duration(hours: 2)).toIso8601String());
  bool _isSubmitting = false;

  final Map<String, String> zones = {
    'Spot A1 - Floor 1': '1',
    'Spot A2 - Floor 1': '2',
    'Spot B1 - Floor 2': '3',
  };

  Future<void> _confirmReservation() async {
    if (selectedZoneId == null || _plateController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Please fill all fields")));
      return;
    }

    setState(() => _isSubmitting = true);
    final success = await _parkingService.reserveParking(
      deviceId: selectedZoneId!,
      plateNumber: _plateController.text,
      startTime: _startTimeController.text,
      endTime: _endTimeController.text,
    );
    setState(() => _isSubmitting = false);

    if (success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Reservation successful!")));
      Navigator.pushNamed(context, ParkingScreen.bookings);
    } else if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Failed to confirm reservation")));
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
                    // مسافة سفلية كافية لمنع تداخل الحقول مع شريط التنقل
                    padding: const EdgeInsets.fromLTRB(20, 10, 20, 120),
                    child: _buildModernReservationForm(context, primaryNeon),
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
              'Reservation',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.1,
              ),
            ),
          ),
          const SizedBox(width: 40),
        ],
      ),
    );
  }

  Widget _buildModernReservationForm(BuildContext context, Color accent) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(30),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          padding: const EdgeInsets.all(25),
          decoration: BoxDecoration(
            color: AppColors.cardBg.withOpacity(0.4),
            borderRadius: BorderRadius.circular(30),
            border: Border.all(color: AppColors.cardBorder),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildFormLabel('PARKING ZONE'),
              _buildModernDropdown(accent),
              const SizedBox(height: 25),

              _buildFormLabel('VEHICLE PLATE NUMBER'),
              _buildModernTextField(
                'e.g. ABC 1234',
                Icons.directions_car_filled_rounded,
                accent,
                _plateController,
              ),

              const SizedBox(height: 25),

              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildFormLabel('START TIME'),
                        _buildModernTextField(
                          'ISO Date Format',
                          Icons.access_time_filled_rounded,
                          accent,
                          _startTimeController,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildFormLabel('END TIME'),
                        _buildModernTextField(
                          'ISO Date Format',
                          Icons.update_rounded,
                          accent,
                          _endTimeController,
                        ),
                      ],

                    ),
                  ),
                ],
              ),
              const SizedBox(height: 45),

              _buildPrimaryButton(
                _isSubmitting ? 'CONFIRMING...' : 'CONFIRM RESERVATION',
                Icons.verified_user_rounded,
                accent,
                _isSubmitting ? () {} : _confirmReservation,
              ),

              const SizedBox(height: 20),

              _buildSecondaryButton(
                'VIEW ALL BOOKINGS',
                Icons.calendar_today_rounded,
                accent,
                () {
                  Navigator.pushNamed(context, ParkingScreen.bookings);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFormLabel(String label) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 8),
      child: Text(
        label,
        style: const TextStyle(
          color: AppColors.textGrey,
          fontSize: 11,
          fontWeight: FontWeight.w800,
          letterSpacing: 1.5,
        ),
      ),
    );
  }

  Widget _buildModernTextField(String hint, IconData icon, Color accent, TextEditingController controller) {
    return TextField(
      controller: controller,
      style: const TextStyle(color: Colors.white, fontSize: 14),
      decoration: InputDecoration(

        hintText: hint,
        hintStyle: TextStyle(
          color: Colors.white.withOpacity(0.2),
          fontSize: 14,
        ),
        prefixIcon: Icon(icon, color: accent, size: 20),
        filled: true,
        fillColor: Colors.black.withOpacity(0.2),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(vertical: 16),
      ),
    );
  }

  Widget _buildModernDropdown(Color accent) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.2),
        borderRadius: BorderRadius.circular(18),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          isExpanded: true,
          value: selectedZoneId,
          hint: const Text(
            'Choose Area',
            style: TextStyle(color: Colors.white24, fontSize: 14),
          ),
          dropdownColor: AppColors.cardBg,
          icon: Icon(Icons.keyboard_arrow_down_rounded, color: accent),
          items: zones.entries
              .map(
                (entry) => DropdownMenuItem<String>(
                  value: entry.value,
                  child: Text(
                    entry.key,
                    style: const TextStyle(color: Colors.white, fontSize: 15),
                  ),
                ),
              )
              .toList(),
          onChanged: (val) => setState(() => selectedZoneId = val),
        ),
      ),
    );
  }


  Widget _buildPrimaryButton(
    String text,
    IconData icon,
    Color accent,
    VoidCallback onTap,
  ) {
    return SizedBox(
      width: double.infinity,
      height: 55,
      child: ElevatedButton.icon(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: accent,
          foregroundColor: Colors.black,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          elevation: 0,
        ),
        icon: Icon(icon, size: 20),
        label: Text(
          text,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w900,
            letterSpacing: 0.5,
          ),
        ),
      ),
    );
  }

  Widget _buildSecondaryButton(
    String text,
    IconData icon,
    Color accent,
    VoidCallback onTap,
  ) {
    return SizedBox(
      width: double.infinity,
      height: 55,
      child: OutlinedButton.icon(
        onPressed: onTap,
        style: OutlinedButton.styleFrom(
          foregroundColor: accent,
          side: BorderSide(color: accent, width: 1.5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        icon: Icon(icon, size: 18),
        label: Text(
          text,
          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
