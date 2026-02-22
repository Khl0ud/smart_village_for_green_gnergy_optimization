import 'package:flutter/material.dart';
import 'dart:ui';
// استيراد ملف الألوان المركزي لضمان الربط المعماري
import 'package:smart_village_for_green_gnergy_optimization/core/theme/app_colors.dart';

class AboutUs1Page extends StatefulWidget {
  const AboutUs1Page({super.key});

  @override
  State<AboutUs1Page> createState() => _AboutUs1PageState();
}

class _AboutUs1PageState extends State<AboutUs1Page> {
  final TextEditingController _searchController = TextEditingController();
  bool _hasText = false;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      if (mounted) {
        setState(() {
          _hasText = _searchController.text.isNotEmpty;
        });
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // استخدام الألوان الموحدة من ملف AppColors
    const Color primaryNeon = AppColors.primaryNeon;

    return Scaffold(
      backgroundColor: AppColors.scaffoldBg, // توحيد الخلفية الداكنة
      body: SafeArea(
        child: Column(
          children: [
            // Header المنسق مع سهم الرجوع
            _buildHeader(primaryNeon),

            // مربع البحث بتصميم Glassmorphism
            _buildSearchBar(primaryNeon),

            const SizedBox(height: 20),

            // محتوى النص التعريفي داخل بطاقة زجاجية فاخرة
            _buildContentCard(primaryNeon),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(Color accent) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 22),
            onPressed: () => Navigator.pop(context),
          ),
          const Expanded(
            child: Center(
              child: Text(
                'Our Mission',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  letterSpacing: 1.1,
                ),
              ),
            ),
          ),
          const SizedBox(width: 48),
        ],
      ),
    );
  }

  Widget _buildSearchBar(Color accent) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(30),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.cardBg.withOpacity(0.5),
              borderRadius: BorderRadius.circular(30),
              border: Border.all(color: AppColors.cardBorder),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Row(
              children: [
                Icon(Icons.search_rounded, size: 20, color: accent),
                const SizedBox(width: 10),
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    style: const TextStyle(color: Colors.white),
                    decoration: const InputDecoration(
                      hintText: 'Search mission details...',
                      hintStyle: TextStyle(color: Colors.white24, fontSize: 14),
                      border: InputBorder.none,
                    ),
                  ),
                ),
                if (_hasText)
                  GestureDetector(
                    onTap: () => _searchController.clear(),
                    child: const Icon(Icons.clear_rounded, color: Colors.white38, size: 22),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildContentCard(Color accent) {
    return Expanded(
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(25),
          decoration: BoxDecoration(
            color: AppColors.cardBg.withOpacity(0.3), // تأثير شفاف زجاجي
            borderRadius: BorderRadius.circular(30),
            border: Border.all(color: Colors.white.withOpacity(0.05)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Smart Vision',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: accent),
                  ),
                  Icon(Icons.eco_rounded, color: accent, size: 35),
                ],
              ),
              const SizedBox(height: 20),
              const Text(
                'We are a multidisciplinary team of passionate students from the Technology University working on the Smart Village project. Our mission is to design and build sustainable, technology-driven solutions that improve everyday life.',
                style: TextStyle(color: Colors.white, fontSize: 16, height: 1.6),
              ),
              const SizedBox(height: 15),
              const Text(
                'By integrating smart systems such as Home Automation, Smart Irrigation, and Renewable Energy, we aim to create a connected and eco-friendly community that combines innovation with practicality.',
                style: TextStyle(color: Colors.white70, fontSize: 15, height: 1.6),
              ),
              const SizedBox(height: 25),
              _buildFeatureTag("IoT Integration", accent),
              _buildFeatureTag("Sustainability", accent),
              _buildFeatureTag("Modern Lifestyle", accent),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFeatureTag(String label, Color accent) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: accent.withOpacity(0.1),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: accent.withOpacity(0.3)),
      ),
      child: Text(label, style: TextStyle(color: accent, fontSize: 12, fontWeight: FontWeight.bold)),
    );
  }
}
