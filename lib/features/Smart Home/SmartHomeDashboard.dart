import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_village_for_green_gnergy_optimization/core/theme/app_colors.dart';
import 'package:smart_village_for_green_gnergy_optimization/core/api_constants.dart';

import 'HomePage.dart';
import 'LightingControlPage.dart';
import 'DoorControlPage.dart';
import 'FanControlPage.dart';
import 'ValveControlPage.dart';
import 'GasSafetyPage.dart';

class SmartHomeDashboard extends StatefulWidget {
  static const String routeName = '/SmartHomeDashboard';
  const SmartHomeDashboard({super.key});

  @override
  State<SmartHomeDashboard> createState() => _SmartHomeDashboardState();
}

class _SmartHomeDashboardState extends State<SmartHomeDashboard> {
  String _userName = 'Smart Village';

  @override
  void initState() {
    super.initState();
    _fetchUserName();
  }

  Future<void> _fetchUserName() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('jwt_token');
      if (token == null) return;

      final response = await http.get(
        Uri.parse(ApiConstants.profileEndpoint),
        headers: {'accept': '*/*', 'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200 && mounted) {
        final data = jsonDecode(response.body);
        setState(() {
          _userName = data['fullName'] ?? data['userName'] ?? 'Smart Village';
        });
      }
    } catch (_) {}
  }

  void _openPage(BuildContext context, Widget page) {
    Navigator.of(context).push(MaterialPageRoute(builder: (_) => page));
  }

  Widget _buildCategoryTile(BuildContext context, IconData icon, String title, Widget page) {
    return InkWell(
      onTap: () => _openPage(context, page),
      borderRadius: BorderRadius.circular(24),
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: AppColors.cardBg.withValues(alpha: 0.3),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: AppColors.cardBorder),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: AppColors.primaryNeon, size: 38),
            const SizedBox(height: 12),
            Text(title,
                style: const TextStyle(
                    color: AppColors.textLight,
                    fontWeight: FontWeight.bold,
                    fontSize: 15)),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: AppColors.mainGradient,
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(),
                  const SizedBox(height: 30),
                  Expanded(
                    child: GridView.count(
                      crossAxisCount: 2,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      physics: const BouncingScrollPhysics(),
                      children: [
                        _buildCategoryTile(context, Icons.home_max_rounded, 'Overview', const HomePage()),
                        _buildCategoryTile(context, Icons.lightbulb_rounded, 'Lighting', const LightingControlPage()),
                        _buildCategoryTile(context, Icons.sensor_door_rounded, 'Doors', const DoorControlPage()),
                        _buildCategoryTile(context, Icons.air_rounded, 'Fans', const FanControlPage()),
                        _buildCategoryTile(context, Icons.water_drop_rounded, 'Valves', const ValveControlPage()),
                        _buildCategoryTile(context, Icons.shield_rounded, 'Gas Safety', const GasSafetyPage()),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Welcome Home,',
                style: TextStyle(color: AppColors.textGrey, fontSize: 14, letterSpacing: 1)),
            const SizedBox(height: 6),
            Text(
              _userName,
              style: const TextStyle(color: AppColors.textLight, fontSize: 22, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        Container(
          padding: const EdgeInsets.all(2),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: AppColors.primaryNeon, width: 1.5),
          ),
          child: CircleAvatar(
            radius: 22,
            backgroundColor: AppColors.cardBg,
            child: Text(
              _userName.isNotEmpty ? _userName[0].toUpperCase() : 'U',
              style: const TextStyle(color: AppColors.primaryNeon, fontWeight: FontWeight.bold, fontSize: 18),
            ),
          ),
        ),
      ],
    );
  }
}

