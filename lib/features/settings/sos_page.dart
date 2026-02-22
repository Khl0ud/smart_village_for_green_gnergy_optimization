import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:ui';
// استيراد ملف الألوان المركزي لضمان الربط المعماري
import 'package:smart_village_for_green_gnergy_optimization/core/theme/app_colors.dart';

class SOS extends StatelessWidget {
  const SOS({super.key});

  // دالة الاتصال بالأرقام لضمان سرعة الاستجابة في حالات الطوارئ
  Future<void> _callNumber(String number) async {
    final Uri phoneUri = Uri(scheme: 'tel', path: number);
    try {
      if (await canLaunchUrl(phoneUri)) {
        await launchUrl(phoneUri);
      } else {
        throw 'Could not launch $number';
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    // استخدام الألوان الموحدة من AppColors المعتمد لمشروعك
    const Color mainBg = AppColors.scaffoldBg;
    const Color cardBg = AppColors.cardBg;
    const Color sosRed = AppColors.danger; // اللون الأحمر الموحد للحالات الخطرة

    return Scaffold(
      backgroundColor: mainBg,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Stack(
        children: [
          // خلفية متدرجة لتعزيز الطابع التقني
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xFF1B1B1B), mainBg],
              ),
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                const SizedBox(height: 10),
                _buildHeader(),
                const SizedBox(height: 50),

                // زر SOS الكبير المتوهج (Neon Glow Effect)
                _buildSOSButton(sosRed),

                const SizedBox(height: 60),

                // قائمة أزرار الطوارئ بتصميم Stadium Shape و Glassmorphism
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    physics: const BouncingScrollPhysics(),
                    children: [
                      _buildEmergencyItem(
                        icon: Icons.shield_rounded,
                        label: 'Police',
                        color: Colors.yellowAccent,
                        phone: '122',
                        cardBg: cardBg,
                        sosRed: sosRed,
                      ),
                      _buildEmergencyItem(
                        icon: Icons.medical_services_rounded,
                        label: 'Ambulance',
                        color: Colors.lightBlueAccent,
                        phone: '123',
                        cardBg: cardBg,
                        sosRed: sosRed,
                      ),
                      _buildEmergencyItem(
                        icon: Icons.fire_truck_rounded,
                        label: 'Fire Department',
                        color: Colors.orangeAccent,
                        phone: '180',
                        cardBg: cardBg,
                        sosRed: sosRed,
                      ),
                      _buildEmergencyItem(
                        icon: Icons.pets_rounded,
                        label: 'Animal Control',
                        color: Colors.grey.shade400,
                        phone: '199',
                        cardBg: cardBg,
                        sosRed: sosRed,
                      ),
                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        const Text(
          'Emergency',
          style: TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.w900, letterSpacing: 1.2),
        ),
        Text(
          'Services Hub',
          style: TextStyle(color: AppColors.primaryNeon.withOpacity(0.7), fontSize: 16, fontWeight: FontWeight.bold, letterSpacing: 2),
        ),
      ],
    );
  }

  Widget _buildSOSButton(Color sosRed) {
    return Center(
      child: GestureDetector(
        onTap: () => _callNumber('112'), // رقم الطوارئ العام
        child: Container(
          width: 200,
          height: 200,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: sosRed,
            boxShadow: [
              BoxShadow(color: sosRed.withOpacity(0.5), blurRadius: 50, spreadRadius: 5),
              const BoxShadow(color: Colors.black26, offset: Offset(0, 10), blurRadius: 20),
            ],
            border: Border.all(color: Colors.white.withOpacity(0.2), width: 8),
          ),
          child: const Center(
            child: Text(
              'SOS',
              style: TextStyle(color: Colors.white, fontSize: 56, fontWeight: FontWeight.w900),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmergencyItem({
    required IconData icon,
    required String label,
    required Color color,
    required String phone,
    required Color cardBg,
    required Color sosRed,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(40),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            height: 80,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            decoration: BoxDecoration(
              color: cardBg.withOpacity(0.4), // تأثير شفاف زجاجي مطور
              borderRadius: BorderRadius.circular(40),
              border: Border.all(color: Colors.white.withOpacity(0.05)),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(color: color.withOpacity(0.1), shape: BoxShape.circle),
                  child: Icon(icon, color: color, size: 26),
                ),
                const SizedBox(width: 16),
                Text(
                  label,
                  style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const Spacer(),
                // زر الاتصال الدائري باللون الأحمر الموحد
                GestureDetector(
                  onTap: () => _callNumber(phone),
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: sosRed,
                      shape: BoxShape.circle,
                      boxShadow: [BoxShadow(color: sosRed.withOpacity(0.3), blurRadius: 10, offset: const Offset(0, 4))],
                    ),
                    child: const Icon(Icons.phone_in_talk_rounded, color: Colors.white, size: 20),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
