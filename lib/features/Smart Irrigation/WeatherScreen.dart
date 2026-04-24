import 'dart:async';
import 'package:flutter/material.dart';
import 'package:smart_village_for_green_gnergy_optimization/core/theme/app_colors.dart';
import 'package:smart_village_for_green_gnergy_optimization/core/services/sensor_service.dart';

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  final SensorService _sensorService = SensorService();
  Timer? _refreshTimer;

  // بيانات حقيقية قادمة من السيرفر
  int rainPercent = 0; 
  double temp = 0.0;   
  int humidity = 0;    
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchWeatherData();
    _refreshTimer = Timer.periodic(const Duration(seconds: 15), (_) => _fetchWeatherData());
  }

  @override
  void dispose() {
    _refreshTimer?.cancel();
    super.dispose();
  }

  Future<void> _fetchWeatherData() async {
    final readings = await _sensorService.getLatestReadings(1);
    
    if (mounted) {
      setState(() {
        for (var r in readings) {
          final type = r['type']?.toString() ?? '';
          final value = (r['value'] ?? 0.0).toDouble();
          
          if (type == 'Rain' || type == '4') rainPercent = value.toInt().clamp(0, 100);
          if (type == 'Temperature' || type == '0') temp = value;
          if (type == 'Humidity' || type == '2') humidity = value.toInt();
        }
        _isLoading = false;
      });
    }
  }

  String _getRainDescription(int percent) {
    if (percent <= 5) return "Clear Sky";
    if (percent < 30) return "Light Drizzle";
    if (percent < 70) return "Moderate Rain";
    return "Heavy Storm";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      body: Stack(
        children: [
          _buildBackgroundGradient(),
          SafeArea(
            child: _isLoading 
              ? const Center(child: CircularProgressIndicator(color: AppColors.primaryNeon))
              : RefreshIndicator(
                  onRefresh: _fetchWeatherData,
                  color: AppColors.primaryNeon,
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        _buildHeader(context),
                        const SizedBox(height: 10),
                        const Text("Garden Weather Area", style: TextStyle(color: AppColors.textLight, fontSize: 24, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 5),
                        Text("${temp.toInt()}°", style: const TextStyle(color: AppColors.textLight, fontSize: 64, fontWeight: FontWeight.w200)),
                        Text(_getRainDescription(rainPercent), style: const TextStyle(color: AppColors.textGrey, fontSize: 18)),
                        const SizedBox(height: 40),
                        _buildSectionTitle("Live Garden Sensors"),
                        const SizedBox(height: 20),
                        _buildRainIntensityCard(),
                        const SizedBox(height: 25),
                        _buildEnvironmentalGrid(),
                        const SizedBox(height: 50),
                      ],
                    ),
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
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: AppColors.mainGradient,
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: AppColors.textLight, size: 22),
          onPressed: () => Navigator.pop(context),
        ),
        IconButton(
          onPressed: _fetchWeatherData,
          icon: const Icon(Icons.refresh_rounded, color: AppColors.primaryNeon, size: 22),
        ),
      ],
    );
  }

  Widget _buildRainIntensityCard() {
    return Container(
      padding: const EdgeInsets.all(25),
      decoration: BoxDecoration(
        color: AppColors.cardBg.withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("RAIN INTENSITY", style: TextStyle(color: AppColors.textGrey, fontSize: 12, fontWeight: FontWeight.bold)),
              Icon(Icons.umbrella_rounded, color: rainPercent > 10 ? AppColors.info : AppColors.textGrey, size: 20),
            ],
          ),
          const SizedBox(height: 20),
          LinearProgressIndicator(
            value: rainPercent / 100,
            backgroundColor: Colors.white10,
            color: AppColors.info,
            minHeight: 12,
            borderRadius: BorderRadius.circular(10),
          ),
          const SizedBox(height: 10),
          Align(
            alignment: Alignment.centerRight,
            child: Text("$rainPercent%", style: const TextStyle(color: AppColors.textLight, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  Widget _buildEnvironmentalGrid() {
    return Row(
      children: [
        Expanded(child: _buildSmallInfoCard("HUMIDITY", "$humidity%", Icons.water_drop_rounded, AppColors.info)),
        const SizedBox(width: 15),
        Expanded(child: _buildSmallInfoCard("AIR QUALITY", "Optimal", Icons.air_rounded, AppColors.primaryNeon)),
      ],
    );
  }

  Widget _buildSmallInfoCard(String title, String val, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.cardBg.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(25),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 12),
          Text(title, style: const TextStyle(color: AppColors.textGrey, fontSize: 10, fontWeight: FontWeight.bold)),
          const SizedBox(height: 5),
          Text(val, style: const TextStyle(color: AppColors.textLight, fontSize: 14, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(title, style: const TextStyle(color: AppColors.textLight, fontSize: 18, fontWeight: FontWeight.bold)),
    );
  }
}