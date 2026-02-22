import 'package:flutter/material.dart';
import 'dart:ui';
// استيراد ملف الألوان المركزي من مجلد core لضمان الربط المعماري
import 'package:smart_village_for_green_gnergy_optimization/core/theme/app_colors.dart';
// استيراد الصفحات الفرعية للربط
import 'PreferencesPage.dart';
import 'ProfileScreen.dart';
import 'IntegrationPage.dart';
import 'package:smart_village_for_green_gnergy_optimization/features/security/SecurityPage.dart';
import 'package:smart_village_for_green_gnergy_optimization/features/help_support/help_support_page.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final TextEditingController _searchController = TextEditingController();
  String query = "";

  // قائمة العناصر مع ربطها بالصفحات الحقيقية لضمان عمل الـ Navigator
  final List<Map<String, dynamic>> _items = [
    {
      "icon": Icons.person_outline_rounded,
      "title": "Profile",
      "page": const ProfileScreen(),
    },
    {
      "icon": Icons.villa_outlined,
      "title": "Smart Village Integration",
      "page": const IntegrationPage(),
    },
    {
      "icon": Icons.security_outlined,
      "title": "Security",
      "page": const SecurityPage(),
    },
    {
      "icon": Icons.tune_outlined,
      "title": "Preferences",
      "page": const PreferencesPage(),
    },
    {
      "icon": Icons.help_outline_rounded,
      "title": "Help & Support",
      "page": const HelpSupportPage(),
    },
    {
      "icon": Icons.privacy_tip_outlined,
      "title": "Privacy Policy & Conditions",
      "page": null,
    },
  ];

  @override
  Widget build(BuildContext context) {
    // تصفية العناصر بناءً على البحث
    final filteredItems = _items.where((item) {
      return item["title"].toLowerCase().contains(query.toLowerCase());
    }).toList();

    return Scaffold(
      backgroundColor: AppColors.scaffoldBg, // استخدام اللون الموحد من Core
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(context),
              _buildSearchBar(),
              const SizedBox(height: 30),

              // قائمة الإعدادات (Menu Items) المنسقة بأسلوب Glassmorphism
              Column(
                children: filteredItems.map((item) {
                  return _buildModernMenuItem(
                    context,
                    item["icon"],
                    item["title"],
                    onTap: () {
                      if (item["page"] != null) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => item["page"]),
                        );
                      }
                    },
                  );
                }).toList(),
              ),

              const SizedBox(height: 30),

              // بطاقة تسجيل الخروج (Logins Card) بتصميم متناسق مع صورك
              _buildLoginsCard(),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10, bottom: 20),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(
              Icons.arrow_back_ios_new_rounded,
              color: Colors.white,
              size: 20,
            ),
            onPressed: () => Navigator.pop(context),
          ),
          const Expanded(
            child: Text(
              "Settings",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColors.primaryNeon, // استخدام اللون النيون الموحد
                fontSize: 28,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.2,
              ),
            ),
          ),
          const SizedBox(width: 40),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: AppColors.cardBg.withOpacity(0.5), // تأثير زجاجي
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: TextField(
        controller: _searchController,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          hintText: 'Search settings...',
          hintStyle: TextStyle(color: AppColors.textGrey.withOpacity(0.5)),
          icon: const Icon(
            Icons.search_rounded,
            color: AppColors.primaryNeon,
            size: 22,
          ),
          border: InputBorder.none,
        ),
        onChanged: (value) => setState(() => query = value),
      ),
    );
  }

  Widget _buildModernMenuItem(
    BuildContext context,
    IconData icon,
    String title, {
    VoidCallback? onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
          decoration: BoxDecoration(
            color: AppColors.cardBg.withOpacity(0.3),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: AppColors.cardBorder),
          ),
          child: Row(
            children: [
              Icon(icon, color: AppColors.primaryNeon, size: 24),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 17,
                    fontWeight: FontWeight.w500,
                  ),
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
      ),
    );
  }

  Widget _buildLoginsCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.cardBg.withOpacity(0.4),
        borderRadius: BorderRadius.circular(25),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Logins',
            style: TextStyle(
              color: AppColors.primaryNeon,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          _buildLogoutOption('Log out', Icons.logout_rounded, Colors.redAccent),
          _buildLogoutOption(
            'Switch accounts',
            Icons.switch_account_rounded,
            Colors.white70,
          ),
          _buildLogoutOption(
            'Add account',
            Icons.add_circle_outline_rounded,
            Colors.white70,
          ),
        ],
      ),
    );
  }

  Widget _buildLogoutOption(String title, IconData icon, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(width: 12),
          Text(title, style: TextStyle(color: color, fontSize: 16)),
        ],
      ),
    );
  }
}
