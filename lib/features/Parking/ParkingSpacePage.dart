import 'package:flutter/material.dart';
import 'dart:ui';
// استيراد ملف الألوان المركزي لضمان الربط المعماري للمشروع
import 'package:smart_village_for_green_gnergy_optimization/core/theme/app_colors.dart';

class ParkingSpacePage extends StatefulWidget {
  // اسم المسار الموحد لضمان عمل الأزرار في الداشبورد
  static const routeName = '/ParkingSpacePage'; 
  const ParkingSpacePage({super.key});

  @override
  State<ParkingSpacePage> createState() => _ParkingSpacePageState();
}

class _ParkingSpacePageState extends State<ParkingSpacePage> {
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
                    // زيادة الـ padding السفلي لمنع تداخل العناصر مع شريط التنقل
                    padding: const EdgeInsets.fromLTRB(20, 10, 20, 120), 
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildLegend(),
                        const SizedBox(height: 35),
                        // تحديث محتوى Zone 1 ليتطابق تماماً مع صورتك المرفقة
                        _buildZoneSection('Zone 1', [
                          _Slot('A1', 'available'), _Slot('A2', 'occupied'), _Slot('A3', 'occupied'),
                          _Slot('B1', 'occupied'), _Slot('B2', 'available'), _Slot('B3', 'occupied'),
                          _Slot('C1', 'available'), _Slot('C2', 'occupied'), _Slot('C3', 'occupied'),
                          _Slot('D1', 'occupied'), _Slot('D2', 'available'), _Slot('D3', 'disabled'),
                        ]),
                        const SizedBox(height: 35),
                        _buildZoneSection('Zone 2', []), // قسم فارغ كما في الصورة
                        const SizedBox(height: 40),
                        _buildActionFooter(primaryNeon),
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

  Widget _buildModernHeader(BuildContext context, Color accent) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 20),
            onPressed: () => Navigator.of(context).pop(),
          ),
          const Expanded(
            child: Text(
              'Parking Space', // العنوان مطابق للصورة
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
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
        _legendItem(AppColors.success, 'Available'), // مطابقة المسميات للصورة
        _legendItem(Colors.orangeAccent, 'Reserved'),
        _legendItem(Colors.redAccent, 'Occupied'),
        _legendItem(Colors.grey, 'Disabled'),
      ],
    );
  }

  Widget _legendItem(Color color, String label) {
    return Row(
      children: [
        Container(width: 12, height: 12, decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(4))),
        const SizedBox(width: 6),
        Text(label, style: const TextStyle(color: AppColors.textGrey, fontSize: 10, fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget _buildZoneSection(String title, List<_Slot> slots) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          title,
          style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 20),
        if (slots.isNotEmpty)
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.cardBg.withOpacity(0.3),
              borderRadius: BorderRadius.circular(30),
              border: Border.all(color: AppColors.cardBorder),
            ),
            child: GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3, crossAxisSpacing: 15, mainAxisSpacing: 15, childAspectRatio: 1.8, 
              ),
              itemCount: slots.length,
              itemBuilder: (context, index) => _buildSlotCard(slots[index]),
            ),
          )
        else
          Container(height: 100, width: double.infinity, decoration: BoxDecoration(color: AppColors.cardBg.withOpacity(0.2), borderRadius: BorderRadius.circular(30))),
      ],
    );
  }

  Widget _buildSlotCard(_Slot slot) {
    Color statusColor;
    switch (slot.status) {
      case 'available': statusColor = AppColors.success; break;
      case 'occupied': statusColor = Colors.redAccent; break;
      case 'reserved': statusColor = Colors.orangeAccent; break;
      default: statusColor = Colors.grey.withOpacity(0.5);
    }

    return Container(
      decoration: BoxDecoration(
        color: statusColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Center(
        child: Text(
          slot.name,
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
        ),
      ),
    );
  }

  Widget _buildActionFooter(Color accent) {
    return SizedBox(
      width: double.infinity, height: 60,
      child: ElevatedButton.icon(
        onPressed: () {},
        style: ElevatedButton.styleFrom(
          backgroundColor: accent, foregroundColor: Colors.black,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
          elevation: 0,
        ),
        icon: const Icon(Icons.add_task_rounded, size: 22),
        label: const Text('Reserve Now', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
      ),
    );
  }
}

class _Slot {
  final String name, status;
  _Slot(this.name, this.status);
}
