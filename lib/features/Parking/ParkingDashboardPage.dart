import 'package:flutter/material.dart';
import 'dart:ui';
// استيراد ملف الألوان المركزي ومكونات الموديول لضمان الربط المعماري
import 'package:smart_village_for_green_gnergy_optimization/core/theme/app_colors.dart';
import 'StatCard.dart';
import 'ParkingScreen.dart';

class ParkingDashboardPage extends StatefulWidget {
  static const routeName = '/ParkingDashboardPage';
  const ParkingDashboardPage({super.key});

  @override
  State<ParkingDashboardPage> createState() => _ParkingDashboardPageState();
}

class _ParkingDashboardPageState extends State<ParkingDashboardPage> {
  @override
  Widget build(BuildContext context) {
    const Color primaryNeon = AppColors.primaryNeon;

    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      body: Stack(
        children: [
          _buildBackgroundGradient(),
          SafeArea(
            child: Column(
              children: [
                _buildModernHeader(primaryNeon),
                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    // زيادة الـ padding السفلي لمنع تداخل الأزرار مع أي عناصر أخرى
                    padding: const EdgeInsets.fromLTRB(20, 10, 20, 120),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildQuickStats(),
                        const SizedBox(height: 35),
                        _buildLocationMapSection(primaryNeon),
                        const SizedBox(height: 35),
                        // قسم الأزرار الذي يجمع كافة الصفحات الستة
                        _buildActionButtons(context),
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

  Widget _buildModernHeader(Color accent) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 22),
            onPressed: () => Navigator.pop(context),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              const Text(
                'SMART VILLAGE',
                style: TextStyle(color: AppColors.textGrey, fontSize: 12, fontWeight: FontWeight.w800, letterSpacing: 2),
              ),
              Text(
                'Parking Dashboard', // مطابق للصورة
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: accent),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQuickStats() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: AppColors.cardBg.withOpacity(0.5),
            borderRadius: BorderRadius.circular(30),
            border: Border.all(color: AppColors.cardBorder),
          ),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _CombinedStatItem(label: 'Total Spaces', value: '30', icon: Icons.local_parking_rounded),
              _VerticalDivider(),
              _CombinedStatItem(label: 'Available', value: '16', icon: Icons.check_circle_outline_rounded, isNeon: true),
            ],
          ),
        ),
        const SizedBox(height: 25),
        const Text(
          'Parking Status',
          style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 15),
        const Row(
          children: [
            Expanded(child: StatCard(title: 'Occupied', value: '10', icon: Icons.directions_car_rounded, color: Colors.redAccent)),
            SizedBox(width: 15),
            Expanded(child: StatCard(title: 'Reserved', value: '4', icon: Icons.bookmark_rounded, color: Colors.orangeAccent)),
          ],
        ),
      ],
    );
  }

  Widget _buildLocationMapSection(Color accent) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Location Map',
          style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 15),
        InkWell(
          onTap: () => Navigator.pushNamed(context, ParkingScreen.map),
          borderRadius: BorderRadius.circular(30),
          child: Container(
            height: 180,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              image: const DecorationImage(image: AssetImage('assets/parking_map.png'), fit: BoxFit.cover),
              border: Border.all(color: AppColors.cardBorder),
            ),
            child: Center(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                decoration: BoxDecoration(color: accent, borderRadius: BorderRadius.circular(15)),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.near_me_rounded, color: Colors.black, size: 20),
                    SizedBox(width: 10),
                    Text('Find My Car', style: TextStyle(color: Colors.black, fontWeight: FontWeight.w900)),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  // دمج كافة الصفحات الستة المطلوبة في أزرار الداشبورد
  Widget _buildActionButtons(BuildContext context) {
    return Column(
      children: [
        // 1. MakeReservationPage
        _buildMenuAction(context, 'New Reservation', 'Book your spot now', Icons.add_location_alt_rounded, ParkingScreen.reservation),
        const SizedBox(height: 15),

        // 2. ParkingSpacePage
        _buildMenuAction(context, 'Parking Layout', 'View Zone 1 & 2 Map', Icons.grid_view_rounded, ParkingScreen.map),
        const SizedBox(height: 15),

        // 3. ShowReservationsPage
        _buildMenuAction(context, 'My Bookings', 'View active reservations', Icons.list_alt_rounded, ParkingScreen.bookings),
        const SizedBox(height: 15),

        // 4. PaymentWalletPage
        _buildMenuAction(context, 'Payment & Wallet', 'Manage credits and cards', Icons.account_balance_wallet_rounded, ParkingScreen.wallet),
        const SizedBox(height: 15),

        // 5. FindMyCarPageState
        _buildMenuAction(context, 'Vehicle Locator', 'Find where you parked', Icons.location_on_rounded, ParkingScreen.findCar),
        const SizedBox(height: 15),

        // 6. ParkingSettingsPage
        _buildMenuAction(context, 'Settings', 'Personalize your experience', Icons.settings_suggest_rounded, ParkingScreen.settings),
      ],
    );
  }

  Widget _buildMenuAction(BuildContext context, String title, String sub, IconData icon, String route) {
    return InkWell(
      onTap: () => Navigator.pushNamed(context, route),
      borderRadius: BorderRadius.circular(24),
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: AppColors.cardBg.withOpacity(0.4),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: AppColors.cardBorder),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(color: AppColors.primaryNeon.withOpacity(0.1), borderRadius: BorderRadius.circular(15)),
              child: Icon(icon, color: AppColors.primaryNeon, size: 24),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                  Text(sub, style: const TextStyle(color: AppColors.textGrey, fontSize: 12)),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios_rounded, color: Colors.white24, size: 16),
          ],
        ),
      ),
    );
  }
}

class _CombinedStatItem extends StatelessWidget {
  final String label, value;
  final IconData icon;
  final bool isNeon;
  const _CombinedStatItem({required this.label, required this.value, required this.icon, this.isNeon = false});

  @override
  Widget build(BuildContext context) {
    final color = isNeon ? AppColors.primaryNeon : AppColors.textGrey;
    return Column(
      children: [
        Icon(icon, color: color, size: 28),
        const SizedBox(height: 8),
        Text(value, style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
        Text(label, style: const TextStyle(color: AppColors.textGrey, fontSize: 12)),
      ],
    );
  }
}

class _VerticalDivider extends StatelessWidget {
  const _VerticalDivider();
  @override
  Widget build(BuildContext context) {
    return Container(height: 50, width: 1, color: Colors.white10);
  }
}
