import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:ui';
// استيراد ملف الألوان المركزي لضمان الربط المعماري
import 'package:smart_village_for_green_gnergy_optimization/core/theme/app_colors.dart';

class IntegrationPage extends StatefulWidget {
  const IntegrationPage({super.key});

  @override
  State<IntegrationPage> createState() => _IntegrationPageState();
}

class _IntegrationPageState extends State<IntegrationPage> {
  final TextEditingController _searchController = TextEditingController();

  // قائمة عناصر الربط التقني لمشروع القرية الذكية
  final List<String> _allItems = [
    'Smart Devices Linking',
    'Third-Party Services',
    'App-to-App Connections',
    'Data Sharing',
    'Developer Options',
  ];

  String _query = '';

  @override
  void initState() {
    super.initState();
    // ضبط شفافية شريط الحالة ليتناسب مع هوية المشروع
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
      ),
    );

    _searchController.addListener(() {
      setState(() {
        _query = _searchController.text;
      });
    });
  }

  List<String> get _filteredItems {
    if (_query.isEmpty) return _allItems;
    final lower = _query.toLowerCase();
    return _allItems.where((e) => e.toLowerCase().contains(lower)).toList();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // استخدام الألوان الموحدة من AppColors
    const Color mainBg = AppColors.scaffoldBg;
    const Color primaryNeon = AppColors.primaryNeon;

    return Scaffold(
      backgroundColor: mainBg,
      appBar: AppBar(
        title: const Text(
          "Integration",
          style: TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.bold,
            color: primaryNeon, // استخدام اللون النيون الموحد
            letterSpacing: 1.1,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Column(
          children: [
            // مربع البحث بتصميم Glassmorphism
            _buildSearchBar(primaryNeon),

            const SizedBox(height: 24),

            // قائمة العناصر المنسقة بأسلوب Stadium Shape
            Expanded(
              child: ListView.separated(
                physics: const BouncingScrollPhysics(),
                itemCount: _filteredItems.length,
                separatorBuilder: (_, __) => const SizedBox(height: 16),
                itemBuilder: (context, index) {
                  final item = _filteredItems[index];
                  return _buildIntegrationItem(item, primaryNeon);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar(Color accent) {
    return Container(
      height: 55,
      decoration: BoxDecoration(
        color: AppColors.cardBg.withOpacity(0.5), // تأثير زجاجي شفاف
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: AppColors.cardBorder),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Icon(Icons.search_rounded, color: accent, size: 22),
          const SizedBox(width: 10),
          Expanded(
            child: TextField(
              controller: _searchController,
              style: const TextStyle(color: Colors.white, fontSize: 16),
              decoration: const InputDecoration(
                hintText: 'Search services...',
                hintStyle: TextStyle(color: Colors.white24, fontSize: 14),
                border: InputBorder.none,
              ),
            ),
          ),
          if (_query.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.clear_rounded, color: Colors.white38, size: 20),
              onPressed: () {
                _searchController.clear();
                setState(() => _query = '');
              },
            ),
        ],
      ),
    );
  }

  Widget _buildIntegrationItem(String title, Color accent) {
    return Container(
      height: 65,
      decoration: BoxDecoration(
        color: AppColors.cardBg.withOpacity(0.3),
        borderRadius: BorderRadius.circular(40),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(40),
          onTap: () {
             // منطق الربط مع الحساسات لاحقاً
          },
          splashColor: accent.withOpacity(0.1),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 17,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: Colors.white24,
                  size: 16,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
