import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/theme/app_colors.dart';
import '../../core/api_constants.dart';
import 'ParkingScreen.dart';

class ParkingSettingsPage extends StatefulWidget {
  static const routeName = '/ParkingSettingsPage';
  const ParkingSettingsPage({super.key});

  @override
  State<ParkingSettingsPage> createState() => _ParkingSettingsPageState();
}

class _ParkingSettingsPageState extends State<ParkingSettingsPage> {
  bool isNotificationEnabled = true;
  bool _isLoading = true;
  bool _isLoggingOut = false;

  // بيانات المستخدم من السيرفر
  String _userName = '';
  String _userEmail = '';

  @override
  void initState() {
    super.initState();
    _fetchUserProfile();
    _loadNotificationPref();
  }

  // جلب بيانات البروفايل من السيرفر
  Future<void> _fetchUserProfile() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('jwt_token');
    if (token == null) {
      setState(() => _isLoading = false);
      return;
    }

    try {
      final response = await http.get(
        Uri.parse(ApiConstants.profileEndpoint),
        headers: {
          'accept': '*/*',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200 && mounted) {
        final data = jsonDecode(response.body);
        setState(() {
          _userName = data['fullName'] ?? data['userName'] ?? 'User';
          _userEmail = data['email'] ?? '';
          _isLoading = false;
        });
      } else {
        setState(() => _isLoading = false);
      }
    } catch (e) {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  // تحميل تفضيل الإشعارات المحفوظ محلياً
  Future<void> _loadNotificationPref() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      isNotificationEnabled = prefs.getBool('parking_notifications') ?? true;
    });
  }

  // حفظ تفضيل الإشعارات
  Future<void> _saveNotificationPref(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('parking_notifications', value);
  }

  // تسجيل الخروج مع السيرفر
  Future<void> _logout() async {
    setState(() => _isLoggingOut = true);

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('jwt_token');

      // إرسال طلب لوغ أوت للسيرفر
      if (token != null) {
        await http.post(
          Uri.parse(ApiConstants.logoutEndpoint),
          headers: {
            'accept': '*/*',
            'Authorization': 'Bearer $token',
          },
        );
      }

      // مسح التوكن من التخزين المحلي
      await prefs.remove('jwt_token');
    } catch (e) {
      // حتى لو فشل السيرفر، نمسح التوكن ونخرج
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('jwt_token');
    }

    if (mounted) {
      Navigator.of(context).popUntil((route) => route.isFirst);
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildModernHeader(context, primaryNeon),
                Expanded(
                  child: _isLoading
                      ? const Center(
                          child: CircularProgressIndicator(
                              color: AppColors.primaryNeon))
                      : SingleChildScrollView(
                          physics: const BouncingScrollPhysics(),
                          padding:
                              const EdgeInsets.fromLTRB(20, 10, 20, 120),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // كارت بيانات المستخدم من السيرفر
                              _buildUserProfileCard(),
                              const SizedBox(height: 30),

                              _buildSectionLabel('ACCOUNT'),
                              _buildSettingsListCard([
                                _buildSettingTile(
                                    context,
                                    'Profile Settings',
                                    Icons.person_outline_rounded,
                                    primaryNeon,
                                    null),
                                _buildDivider(),
                                _buildSettingTile(
                                    context,
                                    'Payment Methods',
                                    Icons.credit_card_rounded,
                                    primaryNeon,
                                    ParkingScreen.wallet),
                              ]),

                              const SizedBox(height: 35),
                              _buildSectionLabel('PREFERENCES'),
                              _buildSettingsListCard([
                                _buildSwitchTile(
                                    'Parking Notifications',
                                    Icons.notifications_none_rounded,
                                    primaryNeon),
                                _buildDivider(),
                                _buildSettingTile(
                                    context,
                                    'Default Location',
                                    Icons.location_on_outlined,
                                    primaryNeon,
                                    null),
                              ]),

                              const SizedBox(height: 35),
                              _buildSectionLabel('SUPPORT'),
                              _buildSettingsListCard([
                                _buildSettingTile(
                                    context,
                                    'Help Center',
                                    Icons.help_outline_rounded,
                                    primaryNeon,
                                    null),
                                _buildDivider(),
                                _buildSettingTile(
                                    context,
                                    'Privacy & Security',
                                    Icons.shield_outlined,
                                    primaryNeon,
                                    null),
                              ]),

                              const SizedBox(height: 35),
                              _buildLogoutButton(context),
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

  // كارت بيانات المستخدم القادمة من السيرفر
  Widget _buildUserProfileCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.cardBg.withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
            color: AppColors.primaryNeon.withValues(alpha: 0.2)),
      ),
      child: Row(
        children: [
          // أيقونة المستخدم
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.primaryNeon.withValues(alpha: 0.1),
              border: Border.all(
                  color: AppColors.primaryNeon.withValues(alpha: 0.3)),
            ),
            child: const Icon(Icons.person_rounded,
                color: AppColors.primaryNeon, size: 28),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _userName.isEmpty ? 'Loading...' : _userName,
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text(
                  _userEmail.isEmpty ? 'Fetching from server...' : _userEmail,
                  style: const TextStyle(
                      color: AppColors.textGrey, fontSize: 13),
                ),
              ],
            ),
          ),
          // مؤشر الاتصال بالسيرفر
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: AppColors.primaryNeon.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Text(
              '● Online',
              style: TextStyle(
                  color: AppColors.primaryNeon,
                  fontSize: 11,
                  fontWeight: FontWeight.bold),
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
            icon: const Icon(Icons.arrow_back_ios_new_rounded,
                color: Colors.white, size: 20),
            onPressed: () => Navigator.of(context).pop(),
          ),
          const Expanded(
            child: Text(
              'Settings',
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold),
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
      child: Text(label,
          style: const TextStyle(
              color: AppColors.textGrey,
              fontSize: 12,
              fontWeight: FontWeight.w800,
              letterSpacing: 1.5)),
    );
  }

  Widget _buildSettingsListCard(List<Widget> children) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.cardBg.withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Column(children: children),
    );
  }

  Widget _buildSettingTile(BuildContext context, String title, IconData icon,
      Color accent, String? route) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
            color: accent.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12)),
        child: Icon(icon, color: accent, size: 22),
      ),
      title: Text(title,
          style: const TextStyle(
              color: Colors.white,
              fontSize: 15,
              fontWeight: FontWeight.w500)),
      trailing: const Icon(Icons.chevron_right_rounded,
          color: Colors.white24, size: 20),
      onTap: () {
        if (route != null) Navigator.pushNamed(context, route);
      },
    );
  }

  Widget _buildSwitchTile(String title, IconData icon, Color accent) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
            color: accent.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12)),
        child: Icon(icon, color: accent, size: 22),
      ),
      title: Text(title,
          style: const TextStyle(
              color: Colors.white,
              fontSize: 15,
              fontWeight: FontWeight.w500)),
      trailing: Switch(
        value: isNotificationEnabled,
        onChanged: (val) {
          setState(() => isNotificationEnabled = val);
          _saveNotificationPref(val); // حفظ التفضيل محلياً
        },
        activeColor: accent,
      ),
    );
  }

  Widget _buildDivider() {
    return Divider(
        height: 1,
        color: Colors.white.withValues(alpha: 0.05),
        indent: 65);
  }

  Widget _buildLogoutButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 55,
      child: ElevatedButton.icon(
        onPressed: _isLoggingOut ? null : () => _showLogoutDialog(context),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.danger.withValues(alpha: 0.1),
          foregroundColor: AppColors.danger,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
            side: BorderSide(
                color: AppColors.danger.withValues(alpha: 0.3)),
          ),
        ),
        icon: _isLoggingOut
            ? const SizedBox(
                width: 18,
                height: 18,
                child: CircularProgressIndicator(
                    strokeWidth: 2, color: AppColors.danger))
            : const Icon(Icons.logout_rounded, size: 20),
        label: Text(
          _isLoggingOut ? 'LOGGING OUT...' : 'LOGOUT ACCOUNT',
          style: const TextStyle(
              fontWeight: FontWeight.bold, letterSpacing: 1),
        ),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.cardBg,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: const Text('Logout',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        content: const Text('Are you sure you want to logout?',
            style: TextStyle(color: AppColors.textGrey)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel',
                style: TextStyle(color: AppColors.textGrey)),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              _logout();
            },
            child: const Text('Logout',
                style: TextStyle(
                    color: AppColors.danger, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}
