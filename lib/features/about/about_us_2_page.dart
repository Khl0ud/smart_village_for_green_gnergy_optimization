import 'package:flutter/material.dart';
import 'dart:ui';
// استيراد ملف الألوان المركزي لضمان الربط المعماري
import 'package:smart_village_for_green_gnergy_optimization/core/theme/app_colors.dart';

class AboutUs2Page extends StatefulWidget {
  const AboutUs2Page({super.key});

  @override
  State<AboutUs2Page> createState() => _AboutUs2PageState();
}

class _AboutUs2PageState extends State<AboutUs2Page> {
  final TextEditingController _searchController = TextEditingController();
  String query = "";

  // بيانات الفريق المحدثة لمشروع القرية الذكية
  final List<Map<String, String>> teamMembers = [
    {
      "name": "John Doe",
      "role": "Project Manager",
      "image": "https://cdn-icons-png.flaticon.com/512/4140/4140048.png",
    },
    {
      "name": "Sarah Johnson",
      "role": "UI/UX Designer",
      "image": "https://cdn-icons-png.flaticon.com/512/4140/4140037.png",
    },
    {
      "name": "Michael Smith",
      "role": "Mobile Developer",
      "image": "https://cdn-icons-png.flaticon.com/512/4140/4140061.png",
    },
    {
      "name": "Emma Davis",
      "role": "Backend Engineer",
      "image": "https://cdn-icons-png.flaticon.com/512/4140/4140051.png",
    },
    {
      "name": "David Wilson",
      "role": "Security Specialist",
      "image": "https://cdn-icons-png.flaticon.com/512/4140/4140077.png",
    },
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<Map<String, String>> get filteredTeam {
    if (query.trim().isEmpty) return teamMembers;
    final q = query.toLowerCase();
    return teamMembers.where((member) {
      final name = member['name']?.toLowerCase() ?? '';
      final role = member['role']?.toLowerCase() ?? '';
      return name.contains(q) || role.contains(q);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    const Color primaryNeon = AppColors.primaryNeon;

    return Scaffold(
      backgroundColor: AppColors.scaffoldBg, // توحيد الخلفية الداكنة
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Our Team",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: primaryNeon, // اللون النيون الموحد
            letterSpacing: 1.1,
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // مربع البحث المودرن بتأثير زجاجي
            _buildSearchBar(primaryNeon),

            const SizedBox(height: 33),

            const Text(
              "Meet the Innovators",
              style: TextStyle(
                color: Colors.white54,
                fontSize: 18,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.5,
              ),
            ),

            const SizedBox(height: 25),

            // قائمة أعضاء الفريق بتصميم Glassmorphism
            Expanded(
              child: ListView.separated(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                itemCount: filteredTeam.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final member = filteredTeam[index];
                  return _buildMemberCard(member, primaryNeon);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar(Color accent) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.cardBg.withOpacity(0.5),
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
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  hintText: 'Search for a member...',
                  hintStyle: TextStyle(color: Colors.white24, fontSize: 14),
                  border: InputBorder.none,
                ),
                onChanged: (v) => setState(() => query = v),
              ),
            ),
            if (query.isNotEmpty)
              IconButton(
                onPressed: () {
                  _searchController.clear();
                  setState(() => query = "");
                },
                icon: const Icon(Icons.close_rounded, color: Colors.white38, size: 18),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildMemberCard(Map<String, String> member, Color accent) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.cardBg.withOpacity(0.3), // تأثير شفاف زجاجي
        borderRadius: BorderRadius.circular(25),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        leading: Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: accent, width: 1.5),
          ),
          child: CircleAvatar(
            radius: 28,
            backgroundColor: Colors.transparent,
            backgroundImage: NetworkImage(member['image']!),
          ),
        ),
        title: Text(
          member['name'] ?? '',
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
        ),
        subtitle: Text(
          member['role'] ?? '',
          style: const TextStyle(color: Colors.white54, fontSize: 13),
        ),
        onTap: () => _showMemberDetails(member, accent),
      ),
    );
  }

  void _showMemberDetails(Map<String, String> member, Color accent) {
    showDialog(
      context: context,
      builder: (_) => BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
        child: AlertDialog(
          backgroundColor: AppColors.cardBg,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
          title: Text(member['name'] ?? '', style: TextStyle(color: accent, fontWeight: FontWeight.bold)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircleAvatar(radius: 40, backgroundImage: NetworkImage(member['image']!)),
              const SizedBox(height: 20),
              Text('Role: ${member['role'] ?? ''}', style: const TextStyle(color: Colors.white70, fontSize: 16)),
              const SizedBox(height: 10),
              const Text('Smart Village Contributor', style: TextStyle(color: Colors.white24, fontSize: 12)),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Close', style: TextStyle(color: accent, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }
}
