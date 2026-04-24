import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:smart_village_for_green_gnergy_optimization/core/theme/app_colors.dart';
import 'waste_main.dart'; // الوصول لـ Bin class

class MapScreen extends StatefulWidget {
  final List<Bin> bins;
  static const String routeName = '/waste_map';
  const MapScreen({super.key, this.bins = const []});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final MapController _mapController = MapController();
  List<Marker> _markers = [];

  @override
  void initState() {
    super.initState();
    _generateMarkers();
  }

  void _generateMarkers() {
    _markers = widget.bins.map((bin) {
      // استخدام الإحداثيات من السيرفر أو وضع قيم افتراضية قريبة من القاهرة إذا لم توجد
      final lat = bin.lat ?? (30.0444 + (int.parse(bin.id) % 10) * 0.01);
      final lng = bin.lng ?? (31.2357 + (int.parse(bin.id) % 10) * 0.01);
      
      final color = bin.fill >= 0.8 
          ? AppColors.danger 
          : (bin.fill >= 0.5 ? AppColors.warning : AppColors.primaryNeon);

      return Marker(
        width: 60,
        height: 60,
        point: LatLng(lat, lng),
        child: GestureDetector(
          onTap: () => _showBinDetails(bin),
          child: _buildNeonMarker(color),
        ),
      );
    }).toList();
  }

  void _showBinDetails(Bin bin) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: const EdgeInsets.all(25),
        decoration: BoxDecoration(
          color: AppColors.cardBg.withValues(alpha: 0.95),
          borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
          border: Border.all(color: AppColors.cardBorder),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Bin ID: ${bin.id}", style: const TextStyle(color: AppColors.textLight, fontSize: 20, fontWeight: FontWeight.bold)),
                _buildStatusBadge(bin.fill),
              ],
            ),
            const SizedBox(height: 15),
            Row(
              children: [
                const Icon(Icons.location_on_rounded, color: AppColors.primaryNeon, size: 18),
                const SizedBox(width: 10),
                Text(bin.location, style: const TextStyle(color: AppColors.textGrey, fontSize: 16)),
              ],
            ),
            const SizedBox(height: 20),
            const Text("Fill Level", style: TextStyle(color: AppColors.textGrey, fontSize: 14)),
            const SizedBox(height: 8),
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: LinearProgressIndicator(
                value: bin.fill,
                minHeight: 12,
                backgroundColor: Colors.white10,
                color: bin.fill > 0.8 ? AppColors.danger : AppColors.primaryNeon,
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusBadge(double fill) {
    final color = fill >= 0.8 ? AppColors.danger : (fill >= 0.5 ? AppColors.warning : AppColors.primaryNeon);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Text(
        fill >= 0.8 ? "CRITICAL" : (fill >= 0.5 ? "MODERATE" : "GOOD"),
        style: TextStyle(color: color, fontSize: 10, fontWeight: FontWeight.bold),
      ),
    );
  }

  static Widget _buildNeonMarker(Color color) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          width: 18,
          height: 18,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(color: color.withValues(alpha: 0.6), blurRadius: 15, spreadRadius: 5),
            ],
          ),
        ),
        Icon(Icons.location_on_rounded, color: color, size: 38),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
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
          BoxShadow(color: Colors.black.withValues(alpha: 0.4), blurRadius: 30, offset: const Offset(0, 15)),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(35),
        child: FlutterMap(
          mapController: _mapController,
          options: MapOptions(
            initialCenter: _markers.isNotEmpty ? _markers.first.point : const LatLng(30.0444, 31.2357),
            initialZoom: 13,
          ),
          children: [
            TileLayer(
              urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
              subdomains: const ['a', 'b', 'c'],
              userAgentPackageName: 'com.smart_village.app',
              tileBuilder: (context, tileWidget, tile) {
                return ColorFiltered(
                  colorFilter: const ColorFilter.matrix([
                    -0.9, 0, 0, 0, 255,
                    0, -0.9, 0, 0, 255,
                    0, 0, -0.9, 0, 255,
                    0, 0, 0, 1, 0,
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
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: AppColors.textLight, size: 22),
          onPressed: () => Navigator.pop(context),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: const [
            Text('Location Tracking', style: TextStyle(color: AppColors.textGrey, fontSize: 13, letterSpacing: 1.2, fontWeight: FontWeight.w600)),
            Text('Live Bin Map', style: TextStyle(fontSize: 26, color: AppColors.textLight, fontWeight: FontWeight.bold)),
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
              onPressed: () {
                if (_markers.isNotEmpty) {
                  _mapController.move(_markers.first.point, 13);
                }
              },
              icon: const Icon(Icons.my_location_rounded, size: 20),
              label: const Text('RE-CENTER VIEW', style: TextStyle(fontWeight: FontWeight.w900, letterSpacing: 1)),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryNeon,
                foregroundColor: AppColors.textDark,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
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
      child: IconButton(onPressed: () {}, icon: Icon(icon, color: AppColors.primaryNeon)),
    );
  }
}
