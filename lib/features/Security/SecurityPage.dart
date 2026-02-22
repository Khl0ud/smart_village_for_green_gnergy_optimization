import 'package:flutter/material.dart';
import 'dart:ui';
// استيراد ملف الألوان المركزي لضمان الربط المعماري
import 'package:smart_village_for_green_gnergy_optimization/core/theme/app_colors.dart';
// استيراد الصفحات المرتبطة للربط البرمجي
import 'security_sub_pages.dart'; 
import '../help_support/help_support_page.dart';
import '../about/AboutUsPage .dart';

class SecurityPage extends StatefulWidget {
  const SecurityPage({super.key});

  @override
  State<SecurityPage> createState() => _SecurityPageState();
}

class _SecurityPageState extends State<SecurityPage> {
  final TextEditingController _searchController = TextEditingController();
  String query = "";

  // القائمة الأساسية للعناصر المنسقة
  final List<String> _securityItems = [
    "Change Password",
    "Two-factor authentication (2FA)",
    "App Password",
    "Help & Support",
    "About Us",
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // تصفية العناصر بناءً على البحث لجعل الصفحة تفاعلية
    final filteredItems = _securityItems.where((item) {
      return item.toLowerCase().contains(query.toLowerCase());
    }).toList();

    return Scaffold(
      backgroundColor: AppColors.scaffoldBg, // توحيد الخلفية الداكنة للمشروع
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Security",
          style: TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.bold,
            color: AppColors.primaryNeon, // اللون الأخضر النيون الموحد
            letterSpacing: 1.1,
          ),
        ),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        child: Column(
          children: [
            // تصميم مربع البحث المودرن (Glassmorphism)
            _buildSearchBar(),
            
            const SizedBox(height: 30),

            // عرض العناصر المصفاة بأسلوب Stadium Shape
            if (filteredItems.isEmpty)
              const Padding(
                padding: EdgeInsets.only(top: 50),
                child: Text("No results found", style: TextStyle(color: Colors.white38)),
              )
            else
              Column(
                children: filteredItems.map((title) {
                  return _buildSecurityItem(title, context);
                }).toList(),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: AppColors.cardBg.withOpacity(0.5), // تأثير شفاف زجاجي
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Row(
        children: [
          const Icon(Icons.search_rounded, color: AppColors.primaryNeon, size: 22),
          const SizedBox(width: 10),
          Expanded(
            child: TextField(
              controller: _searchController,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                hintText: 'Search security settings...',
                hintStyle: TextStyle(color: Colors.white24, fontSize: 14),
                border: InputBorder.none,
              ),
              onChanged: (value) => setState(() => query = value),
            ),
          ),
          if (query.isNotEmpty)
            IconButton(
              onPressed: () {
                _searchController.clear();
                setState(() => query = "");
              },
              icon: const Icon(Icons.clear_rounded, color: Colors.white38, size: 18),
            ),
        ],
      ),
    );
  }

  Widget _buildSecurityItem(String title, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () => _handleNavigation(title, context), // الربط مع منطق التنقل
        borderRadius: BorderRadius.circular(40),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 24),
          decoration: BoxDecoration(
            color: AppColors.cardBg.withOpacity(0.3),
            borderRadius: BorderRadius.circular(40),
            border: Border.all(color: Colors.white.withOpacity(0.05)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: const TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.w400),
              ),
              const Icon(Icons.arrow_forward_ios_rounded, color: Colors.white24, size: 16),
            ],
          ),
        ),
      ),
    );
  }

  void _handleNavigation(String title, BuildContext context) {
    // منطق التنقل المكتمل بناءً على اسم العنصر لضمان "الربط"
    switch (title) {
      case "Change Password":
        Navigator.push(context, MaterialPageRoute(builder: (_) => const ChangePasswordPage()));
        break;
      case "Two-factor authentication (2FA)":
        Navigator.push(context, MaterialPageRoute(builder: (_) => const TwoFactorPage()));
        break;
      case "App Password":
        Navigator.push(context, MaterialPageRoute(builder: (_) => const AppPasswordPage()));
        break;
      case "Help & Support":
        Navigator.push(context, MaterialPageRoute(builder: (_) => const HelpSupportPage()));
        break;
      case "About Us":
        Navigator.push(context, MaterialPageRoute(builder: (_) => const AboutUsPage()));
        break;
      default:
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("$title is coming soon!")));
    }
  }
}
