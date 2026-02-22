import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
// استيراد ملف الألوان المركزي لضمان توحيد الهوية البصرية
import 'package:smart_village_for_green_gnergy_optimization/core/theme/app_colors.dart';

class MapScreen extends StatefulWidget {
  static const String routeName = '/waste_map';
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final MapController _mapController = MapController();

  // تحديث الماركرز لتبدو متوهجة نيون بناءً على مستويات الامتلاء
  final List<Marker> _markers = [
    Marker(
      width: 60,
      height: 60,
      point: const LatLng(30.0444, 31.2357),
      child: _buildNeonMarker(AppColors.primaryNeon), // صندوق فارغ
    ),
    Marker(
      width: 60,
      height: 60,
      point: const LatLng(30.05, 31.24),
      child: _buildNeonMarker(AppColors.warning), // صندوق متوسط
    ),
    Marker(
      width: 60,
      height: 60,
      point: const LatLng(30.06, 31.25),
      child: _buildNeonMarker(AppColors.danger), // صندوق ممتلئ
    ),
  ];

  static Widget _buildNeonMarker(Color color) {
    return Stack(
      alignment: Alignment.center,
      children: [
        // هالة ضوئية نيون خلف العلامة
        Container(
          width: 20,
          height: 20,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: color.withValues(alpha: 0.6),
                blurRadius: 20,
                spreadRadius: 8,
              ),
            ],
          ),
        ),
        Icon(Icons.location_on_rounded, color: color, size: 40),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBg, // استخدام الخلفية الموحدة
      body: Stack(
        children: [
          _buildBackgroundGradient(),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                children: [
                  const SizedBox(height: 30),
                  _buildHeader(),
                  const SizedBox(height: 25),

                  // حاوية الخريطة بتصميم Glassmorphism
                  Expanded(child: _buildMapContainer()),

                  const SizedBox(height: 25),
                  _buildActionButtons(),
                  const SizedBox(height: 50),
                ],
              ),
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
          colors: AppColors.mainGradient,
        ),
      ),
    );
  }

  Widget _buildMapContainer() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(35),
        border: Border.all(color: AppColors.cardBorder),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.4),
            blurRadius: 30,
            offset: const Offset(0, 15),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(35),
        child: FlutterMap(
          mapController: _mapController,
          options: const MapOptions(
            initialCenter: LatLng(30.0444, 31.2357),
            initialZoom: 13,
          ),
          children: [
            TileLayer(
              urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
              subdomains: const ['a', 'b', 'c'],
              // تحسين: إضافة User-Agent لحل مشكلة Access Blocked
              userAgentPackageName: 'com.smart_village.app',
              tileBuilder: (context, tileWidget, tile) {
                return ColorFiltered(
                  // فلتر الخريطة الداكنة ليتناسب مع الهوية البصرية للقرية الذكية
                  colorFilter: const ColorFilter.matrix([
                    -0.9,
                    0,
                    0,
                    0,
                    255,
                    0,
                    -0.9,
                    0,
                    0,
                    255,
                    0,
                    0,
                    -0.9,
                    0,
                    255,
                    0,
                    0,
                    0,
                    1,
                    0,
                  ]),
                  child: tileWidget,
                );
              },
            ),
            MarkerLayer(markers: _markers),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: AppColors.textLight,
            size: 22,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: const [
            Text(
              'Location Tracking',
              style: TextStyle(
                color: AppColors.textGrey,
                fontSize: 13,
                letterSpacing: 1.2,
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              'Live Bin Map', // مطابق لعنوان صورتك
              style: TextStyle(
                fontSize: 26,
                color: AppColors.textLight,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildActionButtons() {
    return Row(
      children: [
        Expanded(
          child: SizedBox(
            height: 60,
            child: ElevatedButton.icon(
              onPressed: () =>
                  _mapController.move(const LatLng(30.0444, 31.2357), 13),
              icon: const Icon(Icons.my_location_rounded, size: 20),
              label: const Text(
                'RE-CENTER VIEW',
                style: TextStyle(fontWeight: FontWeight.w900, letterSpacing: 1),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryNeon,
                foregroundColor: AppColors.textDark,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                elevation: 0,
              ),
            ),
          ),
        ),
        const SizedBox(width: 15),
        _buildCircleActionButton(Icons.layers_rounded),
      ],
    );
  }

  Widget _buildCircleActionButton(IconData icon) {
    return Container(
      height: 60,
      width: 60,
      decoration: BoxDecoration(
        color: AppColors.cardBg.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: IconButton(
        onPressed: () {},
        icon: Icon(icon, color: AppColors.primaryNeon),
      ),
    );
  }
}
