import 'package:flutter/material.dart';
import 'dart:async';
import 'package:smart_village_for_green_gnergy_optimization/core/theme/app_colors.dart';
import 'package:smart_village_for_green_gnergy_optimization/features/Parking/data/services/parking_service.dart';
import 'MakeReservationPage.dart';

class ParkingSpacePage extends StatefulWidget {
  static const routeName = '/ParkingSpacePage';
  final int zoneId;

  const ParkingSpacePage({super.key, this.zoneId = 1});

  @override
  State<ParkingSpacePage> createState() => _ParkingSpacePageState();
}

class _ParkingSpacePageState extends State<ParkingSpacePage> {
  final ParkingService _parkingService = ParkingService();
  Timer? _refreshTimer;

  List<dynamic> _spots = [];
  bool _isLoading = true;
  String? _selectedSpotName;
  int? _selectedSpotId;

  @override
  void initState() {
    super.initState();
    _fetchSpots();
    // تحديث حالة المواقف كل 15 ثانية من السيرفر
    _refreshTimer = Timer.periodic(
      const Duration(seconds: 15),
      (_) => _fetchSpots(),
    );
  }

  @override
  void dispose() {
    _refreshTimer?.cancel();
    super.dispose();
  }

  Future<void> _fetchSpots() async {
    final data = await _parkingService.getDashboard(widget.zoneId);
    if (mounted && data != null) {
      setState(() {
        // السيرفر يرجع binsDetails أو spots تحت binsDetails حسب الـ Controller
        _spots = data['binsDetails'] ?? data['spots'] ?? [];
        _isLoading = false;
      });
    } else if (mounted) {
      setState(() => _isLoading = false);
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
                  child: _isLoading
                      ? const Center(
                          child: CircularProgressIndicator(color: AppColors.primaryNeon))
                      : RefreshIndicator(
                          onRefresh: _fetchSpots,
                          color: AppColors.primaryNeon,
                          child: SingleChildScrollView(
                            physics: const AlwaysScrollableScrollPhysics(),
                            padding: const EdgeInsets.fromLTRB(20, 10, 20, 120),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildLegend(),
                                const SizedBox(height: 25),
                                // بانر آخر تحديث من السيرفر
                                _buildServerSyncBadge(),
                                const SizedBox(height: 25),
                                _buildZoneSection('Zone ${widget.zoneId}', _spots),
                                const SizedBox(height: 40),
                                _buildActionFooter(primaryNeon),
                              ],
                            ),
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

  Widget _buildServerSyncBadge() {
    return Row(
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.primaryNeon,
            boxShadow: [
              BoxShadow(
                  color: AppColors.primaryNeon.withValues(alpha: 0.5),
                  blurRadius: 6,
                  spreadRadius: 2)
            ],
          ),
        ),
        const SizedBox(width: 8),
        Text(
          'Live data from server • ${_spots.length} spots found',
          style: const TextStyle(color: AppColors.textGrey, fontSize: 12),
        ),
        const Spacer(),
        GestureDetector(
          onTap: () {
            setState(() => _isLoading = true);
            _fetchSpots();
          },
          child: const Icon(Icons.refresh_rounded,
              color: AppColors.primaryNeon, size: 18),
        ),
      ],
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
            icon: const Icon(Icons.arrow_back_ios_new_rounded,
                color: Colors.white, size: 20),
            onPressed: () => Navigator.of(context).pop(),
          ),
          Expanded(
            child: Text(
              'Zone ${widget.zoneId} • Parking Space',
              textAlign: TextAlign.center,
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(width: 40),
        ],
      ),
    );
  }

  Widget _buildLegend() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _legendItem(AppColors.success, 'Available'),
        _legendItem(Colors.orangeAccent, 'Reserved'),
        _legendItem(Colors.redAccent, 'Occupied'),
        _legendItem(Colors.grey, 'Disabled'),
      ],
    );
  }

  Widget _legendItem(Color color, String label) {
    return Row(
      children: [
        Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(
                color: color, borderRadius: BorderRadius.circular(4))),
        const SizedBox(width: 6),
        Text(label,
            style: const TextStyle(
                color: AppColors.textGrey,
                fontSize: 10,
                fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget _buildZoneSection(String title, List<dynamic> spots) {
    if (spots.isEmpty) {
      return Column(
        children: [
          Text(title,
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold)),
          const SizedBox(height: 20),
          Container(
            height: 120,
            width: double.infinity,
            decoration: BoxDecoration(
              color: AppColors.cardBg.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(30),
            ),
            child: const Center(
              child: Text('No spots data from server',
                  style: TextStyle(color: AppColors.textGrey)),
            ),
          ),
        ],
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(title,
            style: const TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold)),
        const SizedBox(height: 20),
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: AppColors.cardBg.withValues(alpha: 0.3),
            borderRadius: BorderRadius.circular(30),
            border: Border.all(color: AppColors.cardBorder),
          ),
          child: GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 15,
              mainAxisSpacing: 15,
              childAspectRatio: 1.8,
            ),
            itemCount: spots.length,
            itemBuilder: (context, index) {
              final spot = spots[index];
              final spotName = spot['name']?.toString() ?? 'S${index + 1}';
              // السيرفر يرسل نسبة الامتلاء (fillLevel)
              final fillLevel = (spot['fillLevel'] ?? 0.0).toDouble();
              final status = fillLevel >= 80
                  ? 'occupied'
                  : fillLevel >= 40
                      ? 'reserved'
                      : 'available';
              final spotId = spot['id'] as int?;

              return GestureDetector(
                onTap: () {
                  if (status == 'available') {
                    setState(() {
                      _selectedSpotName = spotName;
                      _selectedSpotId = spotId;
                    });
                  }
                },
                child: _buildSlotCard(
                  spotName,
                  status,
                  isSelected: _selectedSpotName == spotName,
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildSlotCard(String name, String status,
      {bool isSelected = false}) {
    Color statusColor;
    switch (status) {
      case 'available':
        statusColor = AppColors.success;
        break;
      case 'occupied':
        statusColor = Colors.redAccent;
        break;
      case 'reserved':
        statusColor = Colors.orangeAccent;
        break;
      default:
        statusColor = Colors.grey.withValues(alpha: 0.5);
    }

    return Container(
      decoration: BoxDecoration(
        color: statusColor,
        borderRadius: BorderRadius.circular(12),
        border: isSelected
            ? Border.all(color: Colors.white, width: 2)
            : null,
        boxShadow: isSelected
            ? [BoxShadow(color: statusColor.withValues(alpha: 0.6), blurRadius: 8)]
            : null,
      ),
      child: Center(
        child: Text(
          name,
          style: const TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
        ),
      ),
    );
  }

  Widget _buildActionFooter(Color accent) {
    return SizedBox(
      width: double.infinity,
      height: 60,
      child: ElevatedButton.icon(
        // الانتقال لصفحة الحجز مع تمرير الـ SpotId المحدد
        onPressed: _selectedSpotId != null
            ? () => Navigator.pushNamed(context, MakeReservationPage.routeName)
            : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: accent,
          foregroundColor: Colors.black,
          disabledBackgroundColor: AppColors.cardBg,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
          elevation: 0,
        ),
        icon: const Icon(Icons.add_task_rounded, size: 22),
        label: Text(
          _selectedSpotId != null
              ? 'Reserve $_selectedSpotName'
              : 'Select a Spot to Reserve',
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
      ),
    );
  }
}
