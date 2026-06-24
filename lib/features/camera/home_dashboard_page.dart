import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
// استيراد ملف الألوان المركزي والصفحات المطلوبة للربط

import 'package:smart_village_for_green_gnergy_optimization/core/theme/app_colors.dart';
import 'surveillance_grid_page.dart';
import 'gate_logs_page.dart';
import 'reports_page.dart';


import '../settings/SettingsPage.dart';

import 'package:smart_village_for_green_gnergy_optimization/core/services/camera_service.dart';

class HomeDashboardPage extends StatefulWidget {
  const HomeDashboardPage({super.key});

  @override
  State<HomeDashboardPage> createState() => _HomeDashboardPageState();
}

class _HomeDashboardPageState extends State<HomeDashboardPage> {
  final CameraService _cameraService = CameraService();
  List<dynamic> _cameras = [];
  bool _isLoadingCameras = true;

  @override
  void initState() {
    super.initState();
    _fetchCameras();
  }

  Future<void> _fetchCameras() async {
    final cameras = await _cameraService.getAllCameras();
    if (mounted){
      setState(() {
        _cameras = cameras;
        _isLoadingCameras = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    const Color mainBg = AppColors.scaffoldBg;
    const Color primaryNeon = AppColors.primaryNeon;

    return Scaffold(
      backgroundColor: mainBg,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: _buildAppBarTitle(),
        actions: [
          IconButton(
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const SettingsPage()),
            ),
            icon: const Icon(Icons.settings_outlined, color: Colors.white),
          ),
        ],
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSearchBar(primaryNeon),
              const SizedBox(height: 30),

              _buildSectionTitle('Smart Analysis'),
              const SizedBox(height: 12),
              _buildReportsCard(context, primaryNeon),
              const SizedBox(height: 30),

              _buildSectionTitle('Live Surveillance'),
              const SizedBox(height: 12),
              
              _isLoadingCameras 
                ? const Center(child: CircularProgressIndicator(color: primaryNeon))
                : _cameras.isEmpty
                    ? const Text("No cameras connected.", style: TextStyle(color: AppColors.textGrey))
                    : Column(
                        children: _cameras.map((camera) {
                          // عرض الكاميرات القادمة من السيرفر
                          final name = camera['name'] ?? 'Unknown Camera';
                          final status = (camera['status'] ?? 'Offline').toString();
                          
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 16.0),
                            child: _buildCameraHero(
                              context,
                              title: name,
                              // نستخدم صورة افتراضية أو صورة قادمة من السيرفر
                              asset: 'assets/living_room.png', 
                              status: status,
                              onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const SurveillanceGridPage(),
                                ),
                              ),
                            ).animate().fadeIn().slideX(),
                          );
                        }).toList(),
                      ),

              const SizedBox(height: 30),

              _buildRecentActivityHeader(context, primaryNeon),
              const SizedBox(height: 12),

              _buildHistoryTile(
                context,
                title: 'Motion Detected',
                subtitle: 'Gate Access • Check Logs',
                icon: Icons.run_circle_outlined,
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const GateLogsPage()),
                ),
              ),

              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  // --- مساعدات بناء الواجهة (Helper Widgets) ---

  Widget _buildAppBarTitle() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Smart Village',
          style: GoogleFonts.comfortaa(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        Text(
          'Village Control Center',
          style: GoogleFonts.poppins(fontSize: 12, color: Colors.white54),
        ),
      ],
    );
  }

  Widget _buildSearchBar(Color accent) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      decoration: BoxDecoration(
        color: AppColors.cardBg.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: TextField(
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          hintText: 'Search systems...',
          hintStyle: const TextStyle(color: Colors.white24),
          icon: Icon(Icons.search_rounded, color: accent),
          border: InputBorder.none,
        ),
      ),
    ).animate().fadeIn().slideY(begin: 0.1);
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        color: Colors.white,
        fontSize: 18,
        fontWeight: FontWeight.bold,
        letterSpacing: 0.5,
      ),
    );
  }

  Widget _buildReportsCard(BuildContext context, Color accent) {
    return InkWell(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const ReportsPage()),
      ),
      borderRadius: BorderRadius.circular(25),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppColors.cardBg.withValues(alpha: 0.4),
          borderRadius: BorderRadius.circular(25),
          border: Border.all(color: accent.withValues(alpha: 0.2)),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: accent.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.analytics_rounded, color: accent, size: 30),
            ),
            const SizedBox(width: 16),
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'System Reports',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Energy & Irrigation Analytics',
                    style: TextStyle(color: Colors.white38, fontSize: 12),
                  ),
                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios_rounded, color: accent, size: 18),
          ],
        ),
      ),
    ).animate().fadeIn().slideY(begin: 0.2);
  }

  Widget _buildCameraHero(
    BuildContext context, {
    required String title,
    required String asset,
    required String status,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 200,
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          image: DecorationImage(image: AssetImage(asset), fit: BoxFit.cover),
          border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
        ),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.black.withValues(alpha: 0.1),
                Colors.black.withValues(alpha: 0.8),
              ],
            ),
          ),
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildStatusBadge(status),
                  const CircleAvatar(
                    backgroundColor: Colors.white24,
                    child: Icon(Icons.fullscreen_rounded, color: Colors.white),
                  ),
                ],
              ),
              _buildCameraInfo(title),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusBadge(String status) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: status == 'Live' ? Colors.redAccent : Colors.white24,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        status.toUpperCase(),
        style: const TextStyle(
          color: Colors.white,
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildCameraInfo(String title) {
    return Align(
      alignment: Alignment.bottomLeft,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Text(
            'Surveillance Camera Active',
            style: TextStyle(color: Colors.white70, fontSize: 12),
          ),
        ],
      ),
    );
  }

  Widget _buildRecentActivityHeader(BuildContext context, Color accent) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'Recent Activity',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        TextButton(
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const GateLogsPage()),
          ),
          child: Text('See all', style: TextStyle(color: accent)),
        ),
      ],
    );
  }

  Widget _buildHistoryTile(
    BuildContext context, {
    required String title,
    required String subtitle,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.cardBg.withValues(alpha: 0.4),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppColors.cardBorder),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppColors.primaryNeon.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: AppColors.primaryNeon, size: 24),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: const TextStyle(color: Colors.white38, fontSize: 12),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios_rounded,
              color: Colors.white24,
              size: 14,
            ),
          ],
        ),
      ),
    );
  }
}
