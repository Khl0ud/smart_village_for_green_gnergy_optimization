import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:smart_village_for_green_gnergy_optimization/core/theme/app_colors.dart';
import 'package:smart_village_for_green_gnergy_optimization/features/settings/sos_page.dart';
import 'package:smart_village_for_green_gnergy_optimization/features/Smart Irrigation/SmartIrrigationHub.dart';
import 'package:smart_village_for_green_gnergy_optimization/features/Solar Power/SolarDashboard.dart';
import 'package:smart_village_for_green_gnergy_optimization/features/waste_management/waste_main.dart';
import 'package:smart_village_for_green_gnergy_optimization/features/Umbrella/UmbrellaControlPage.dart';
import 'package:smart_village_for_green_gnergy_optimization/features/Camera/camera_screen.dart'; // مثال
import 'package:smart_village_for_green_gnergy_optimization/features/Parking/ParkingDashboardPage.dart';
import 'package:smart_village_for_green_gnergy_optimization/features/Smart Home/SmartHomeDashboard.dart'; // مثال


class DashboardHomePage extends StatelessWidget {
  const DashboardHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBg, // استخدام اللون من core
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        toolbarHeight: 80,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Smart Village",
              style: GoogleFonts.comfortaa(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: AppColors.textLight,
              ),
            ),
            Text(
              "Manage your modern lifestyle",
              style: GoogleFonts.poppins(
                fontSize: 14,
                color: AppColors.textGrey,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () {
              // الانتقال لصفحة الإعدادات العامة في مجلد settings
            },
            icon: const Icon(
              Icons.settings_outlined,
              color: AppColors.textLight,
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              // حقل البحث بتصميم Glassmorphism
              _buildSearchBar(),

              const SizedBox(height: 35),

              // شبكة الخدمات المربوطة بالمجلدات (Grid View)
              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                crossAxisSpacing: 15,
                mainAxisSpacing: 15,
                childAspectRatio: 1.1,
                children: [
                  _buildServiceCard(
                    context,
                    title: "Smart Home",
                    icon: Icons.home_rounded,
                    color: Colors.blueAccent,
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const SmartHomeDashboard()),
                    ),
                  ),
                  _buildServiceCard(
                    context,
                    title: "Agriculture",
                    icon: Icons.eco,
                    color: AppColors.primaryNeon,
                    onTap: () => Navigator.push(
                      context,
                     MaterialPageRoute(builder: (_) => const SmartIrrigationHub()),
                    ),
                  ),
                  _buildServiceCard(
                    context,
                    title: "Parking",
                    icon: Icons.local_parking_rounded,
                    color: Colors.orangeAccent,
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const ParkingDashboardPage(),
                      ),
                    ),
                  ),
                  _buildServiceCard(
                    context,
                    title: "Energy",
                    icon: Icons.solar_power_rounded,
                    color: Colors.yellowAccent,
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const SolarDashboard()),
                    ),
                  ),
                  _buildServiceCard(
                    context,
                    title: "Surveillance",
                    icon: Icons.videocam_rounded,
                    color: Colors.redAccent,
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const CameraMain()),
                    ),
                  ),
                  _buildServiceCard(
                    context,
                    title: "Waste Mgmt",
                    icon: Icons.delete_sweep_rounded,
                    color: Colors.tealAccent,
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const WasteDashboard(),
                      ),
                    ),
                  ),
                  _buildServiceCard(
                    context,
                    title: "Umbrella",
                    icon: Icons.umbrella_rounded,
                    color: Colors.purpleAccent,
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const UmbrellaControlPage()),
                    ),
                  ),
                  _buildServiceCard(
                    context,
                    title: "Emergency",
                    icon: Icons.sos_rounded,
                    color: AppColors.danger,
                   onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const SOS()),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 100),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      decoration: BoxDecoration(
        color: AppColors.cardBg.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: const TextField(
        decoration: InputDecoration(
          hintText: "Search services...",
          hintStyle: TextStyle(color: AppColors.textGrey, fontSize: 14),
          icon: Icon(Icons.search, color: AppColors.primaryNeon),
          border: InputBorder.none,
        ),
      ),
    ).animate().fadeIn().slideY(begin: 0.1);
  }

  Widget _buildServiceCard(
    BuildContext context, {
    required String title,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.cardBg.withValues(alpha: 0.4),
          borderRadius: BorderRadius.circular(25),
          border: Border.all(color: AppColors.cardBorder),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 30),
            ),
            const SizedBox(height: 12),
            Text(
              title,
              style: GoogleFonts.poppins(
                color: AppColors.textLight,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    ).animate().scale(
      delay: 100.ms,
      duration: 400.ms,
      curve: Curves.easeOutBack,
    );
  }
}
