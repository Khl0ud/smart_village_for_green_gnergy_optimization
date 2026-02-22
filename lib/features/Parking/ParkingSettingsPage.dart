import 'package:flutter/material.dart';
import 'dart:ui';
// استيراد ملف الألوان المركزي ومسارات الموديول لضمان الربط المعماري
import '../../core/theme/app_colors.dart';
import 'ParkingScreen.dart';

class ParkingSettingsPage extends StatefulWidget {
  // اسم المسار الموحد لضمان عمل الأزرار في الداشبورد
  static const routeName = '/ParkingSettingsPage';
  const ParkingSettingsPage({super.key});

  @override
  State<ParkingSettingsPage> createState() => _ParkingSettingsPageState();
}

class _ParkingSettingsPageState extends State<ParkingSettingsPage> {
  bool isNotificationEnabled = true; // محاكاة لمفتاح التبديل في الصورة

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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildModernHeader(context, primaryNeon),
                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    // مسافة سفلية كافية لمنع التداخل مع شريط التنقل
                    padding: const EdgeInsets.fromLTRB(20, 10, 20, 120), 
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildSectionLabel('ACCOUNT'), // مطابق للصورة
                        _buildSettingsListCard([
                          _buildSettingTile(context, 'Profile Settings', Icons.person_outline_rounded, primaryNeon, null),
                          _buildDivider(),
                          _buildSettingTile(context, 'Payment Methods', Icons.credit_card_rounded, primaryNeon, ParkingScreen.wallet),
                        ]),
                        
                        const SizedBox(height: 35),
                        _buildSectionLabel('PREFERENCES'), // مطابق للصورة
                        _buildSettingsListCard([
                          _buildSwitchTile('Notifications', Icons.notifications_none_rounded, primaryNeon),
                          _buildDivider(),
                          _buildSettingTile(context, 'Default Location', Icons.location_on_outlined, primaryNeon, null),
                        ]),

                        const SizedBox(height: 35),
                        _buildSectionLabel('SUPPORT'), // مطابق للصورة
                        _buildSettingsListCard([
                          _buildSettingTile(context, 'Help Center', Icons.help_outline_rounded, primaryNeon, null),
                          _buildDivider(),
                          _buildSettingTile(context, 'Privacy & Security', Icons.shield_outlined, primaryNeon, null),
                        ]),

                        const SizedBox(height: 35),
                        _buildDangerZone(context),
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
              'Settings',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(width: 40),
        ],
      ),
    );
  }

  Widget _buildSectionLabel(String label) {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0, bottom: 12),
      child: Text(
        label,
        style: const TextStyle(color: AppColors.textGrey, fontSize: 12, fontWeight: FontWeight.w800, letterSpacing: 1.5),
      ),
    );
  }

  Widget _buildSettingsListCard(List<Widget> children) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.cardBg.withOpacity(0.4),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Column(children: children),
    );
  }

  Widget _buildSettingTile(BuildContext context, String title, IconData icon, Color accent, String? route) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(color: accent.withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
        child: Icon(icon, color: accent, size: 22),
      ),
      title: Text(title, style: const TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w500)),
      trailing: const Icon(Icons.chevron_right_rounded, color: Colors.white24, size: 20),
      onTap: () {
        if (route != null) Navigator.pushNamed(context, route);
      },
    );
  }

  Widget _buildSwitchTile(String title, IconData icon, Color accent) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(color: accent.withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
        child: Icon(icon, color: accent, size: 22),
      ),
      title: Text(title, style: const TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w500)),
      trailing: Switch(
        value: isNotificationEnabled,
        onChanged: (val) => setState(() => isNotificationEnabled = val),
        activeColor: accent,
      ),
    );
  }

  Widget _buildDivider() {
    return Divider(height: 1, color: Colors.white.withOpacity(0.05), indent: 65);
  }

  Widget _buildDangerZone(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 55,
      child: ElevatedButton.icon(
        onPressed: () => Navigator.of(context).popUntil((route) => route.isFirst),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.danger.withOpacity(0.1),
          foregroundColor: AppColors.danger,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
            side: BorderSide(color: AppColors.danger.withOpacity(0.3)),
          ),
        ),
        icon: const Icon(Icons.logout_rounded, size: 20),
        label: const Text('LOGOUT ACCOUNT', style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1)),
      ),
    );
  }
}
