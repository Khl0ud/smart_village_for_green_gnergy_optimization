import 'package:flutter/material.dart';
import 'dart:ui';
// استيراد ملف الألوان المركزي لضمان الربط المعماري
import 'package:smart_village_for_green_gnergy_optimization/core/theme/app_colors.dart';

class HelpSupportPage extends StatefulWidget {
  const HelpSupportPage({super.key});

  @override
  State<HelpSupportPage> createState() => _HelpSupportPageState();
}

class _HelpSupportPageState extends State<HelpSupportPage> {
  final TextEditingController _searchController = TextEditingController();
  String query = "";

  // قائمة عناصر الدعم المربوطة بصفحاتها الحقيقية
  final List<Map<String, dynamic>> _items = [
    {"icon": Icons.headset_mic_rounded, "title": "Customer Service", "page": const CustomerServicePage()},
    {"icon": Icons.chat_rounded, "title": "WhatsApp Support", "page": const WhatsAppPage()},
    {"icon": Icons.email_rounded, "title": "Official Email", "page": const EmailPage()},
    {"icon": Icons.facebook_rounded, "title": "Facebook Community", "page": const FacebookPage()},
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // تصفية العناصر بناءً على البحث لجعل الصفحة تفاعلية
    final filteredItems = _items.where((item) {
      return item["title"].toLowerCase().contains(query.toLowerCase());
    }).toList();

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
          "Help & Support",
          style: TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.bold,
            color: primaryNeon, // اللون النيون الموحد
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
            _buildSearchBar(primaryNeon),
            
            const SizedBox(height: 30),

            // قائمة عناصر الدعم بتصميم Stadium Shape
            Column(
              children: filteredItems.map((item) {
                return _buildModernSupportItem(
                  context,
                  item["icon"],
                  item["title"],
                  onTap: () {
                    if (item["page"] != null) {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => item["page"]));
                    }
                  },
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar(Color accent) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: AppColors.cardBg.withOpacity(0.5), // تأثير شفاف زجاجي
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Row(
        children: [
          Icon(Icons.search_rounded, color: accent, size: 22),
          const SizedBox(width: 10),
          Expanded(
            child: TextField(
              controller: _searchController,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                hintText: 'How can we help you?',
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

  Widget _buildModernSupportItem(BuildContext context, IconData icon, String title, {VoidCallback? onTap}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(40),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 24),
          decoration: BoxDecoration(
            color: AppColors.cardBg.withOpacity(0.3), 
            borderRadius: BorderRadius.circular(40), 
            border: Border.all(color: Colors.white.withOpacity(0.05)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(icon, color: AppColors.primaryNeon, size: 24),
                  const SizedBox(width: 16),
                  Text(
                    title,
                    style: const TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.w500),
                  ),
                ],
              ),
              const Icon(Icons.arrow_forward_ios_rounded, color: Colors.white24, size: 16),
            ],
          ),
        ),
      ),
    );
  }
}

// =============================================================
// ويدجت القالب الموحد لجميع الصفحات الفرعية (Modern Dark Forest)
// تم ربطه بملف AppColors لضمان وحدة الهوية البصرية
// =============================================================

Widget _buildSupportPageTemplate(BuildContext context, String title, String subtitle, IconData icon) {
  return Scaffold(
    backgroundColor: AppColors.scaffoldBg,
    appBar: AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      centerTitle: true,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 20),
        onPressed: () => Navigator.pop(context),
      ),
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.bold,
          color: AppColors.primaryNeon,
          letterSpacing: 1.1,
        ),
      ),
    ),
    body: Padding(
      padding: const EdgeInsets.all(24.0),
      child: Center(
        child: ClipRRect(
          borderRadius: BorderRadius.circular(30),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(35),
              decoration: BoxDecoration(
                color: AppColors.cardBg.withOpacity(0.3),
                borderRadius: BorderRadius.circular(30),
                border: Border.all(color: AppColors.cardBorder),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // أيقونة الخدمة داخل دائرة نيون جذابة
                  Icon(icon, size: 70, color: AppColors.primaryNeon),
                  const SizedBox(height: 25),
                  Text(
                    subtitle,
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold, height: 1.5),
                  ),
                  const SizedBox(height: 15),
                  const Text(
                    "Our technical support team is ready to assist you with Smart Village systems.",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: AppColors.textGrey, fontSize: 14, height: 1.4),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    ),
  );
}

// ---------------- SUB PAGES ----------------
// الصفحات الفرعية باستخدام القالب الموحد لضمان التناسق

class CustomerServicePage extends StatelessWidget {
  const CustomerServicePage({super.key});
  @override
  Widget build(BuildContext context) => _buildSupportPageTemplate(
    context, "Customer Service", "Start a live chat session with our support team", Icons.headset_mic_rounded);
}

class WhatsAppPage extends StatelessWidget {
  const WhatsAppPage({super.key});
  @override
  Widget build(BuildContext context) => _buildSupportPageTemplate(
    context, "WhatsApp", "Send a message directly to our WhatsApp support", Icons.chat_rounded);
}

class EmailPage extends StatelessWidget {
  const EmailPage({super.key});
  @override
  Widget build(BuildContext context) => _buildSupportPageTemplate(
    context, "Email", "Send your inquiries via official email", Icons.email_rounded);
}

class FacebookPage extends StatelessWidget {
  const FacebookPage({super.key});
  @override
  Widget build(BuildContext context) => _buildSupportPageTemplate(
    context, "Facebook", "Follow our latest Smart Village updates", Icons.facebook_rounded);
}
