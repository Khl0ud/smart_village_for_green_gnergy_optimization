import 'package:flutter/material.dart';
// استيراد ملف الألوان المركزي الخاص بكِ لضمان الربط المعماري
import 'package:smart_village_for_green_gnergy_optimization/core/theme/app_colors.dart';

class HomePage extends StatefulWidget {
  static const String routeName = '/home_page';
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // حالة النظام الأمنية بناءً على تصميمك
  bool isSecure = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBg, // استخدام الخلفية الموحدة
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 30),
              
              // الترويسة (Header)
              _buildHeader(),
              
              const SizedBox(height: 35),

              // كارت الحالة الأمنية المتوهج (Glowing Card)
              _buildSecurityStatusCard(),

              const SizedBox(height: 35),

              const Text(
                'Environment Monitoring',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textLight, // استخدام لون النص الموحد
                ),
              ),
              const SizedBox(height: 16),
              
              // شبكة الحساسات (Sensors Grid) المحسنة
              _buildSensorsGrid(),

              const SizedBox(height: 40),

              // زر التوقف الطارئ (Emergency Stop) بلون الخطر الموحد
              _buildEmergencyButton(context),
              
              const SizedBox(height: 50), 
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              'Welcome, Khulood', // تخصيص الاسم بناءً على بياناتك
              style: TextStyle(color: AppColors.textGrey, fontSize: 15),
            ),
            SizedBox(height: 4),
            Text(
              'Smart Village',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.textLight),
            ),
          ],
        ),
        Container(
          padding: const EdgeInsets.all(2),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: AppColors.primaryNeon.withOpacity(0.3), width: 1.5),
          ),
          child: const CircleAvatar(
            radius: 25,
            backgroundColor: AppColors.cardBg,
            backgroundImage: NetworkImage('https://cdn-icons-png.flaticon.com/512/147/147144.png'),
          ),
        )
      ],
    );
  }

  Widget _buildSecurityStatusCard() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.cardBg.withOpacity(0.4), // تأثير زجاجي معتمد
        borderRadius: BorderRadius.circular(30),
        border: Border.all(
          color: (isSecure ? AppColors.success : AppColors.danger).withOpacity(0.1),
        ),
      ),
      child: Row(
        children: [
          _buildStatusIcon(),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isSecure ? 'System Secure' : 'System Alert',
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textLight),
                ),
                Text(
                  isSecure ? 'All sensors reporting normal' : 'Check security alerts!',
                  style: const TextStyle(color: AppColors.textGrey, fontSize: 13),
                ),
              ],
            ),
          ),
          Switch(
            value: isSecure,
            onChanged: (v) => setState(() => isSecure = v),
            activeColor: AppColors.primaryNeon, // الربط مع الهوية البصرية
            inactiveTrackColor: AppColors.glassWhite,
          )
        ],
      ),
    );
  }

  Widget _buildStatusIcon() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: (isSecure ? AppColors.success : AppColors.danger).withOpacity(0.1),
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: (isSecure ? AppColors.success : AppColors.danger).withOpacity(0.2),
            blurRadius: 20,
            spreadRadius: 2,
          )
        ],
      ),
      child: Icon(
        isSecure ? Icons.shield_rounded : Icons.gpp_bad_rounded,
        color: isSecure ? AppColors.success : AppColors.danger,
        size: 28,
      ),
    );
  }

  Widget _buildSensorsGrid() {
    return Column(
      children: [
        Row(
          children: [
            _SensorBox(icon: Icons.local_gas_station_rounded, label: 'Gas', value: '0.02', unit: 'ppm', color: AppColors.info),
            const SizedBox(width: 16),
            _SensorBox(icon: Icons.smoke_free_rounded, label: 'Smoke', value: 'Low', unit: '', color: AppColors.success),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            _SensorBox(icon: Icons.local_fire_department_rounded, label: 'Flame', value: 'None', unit: '', color: AppColors.warning),
            const SizedBox(width: 16),
            _SensorBox(icon: Icons.thermostat_rounded, label: 'Temp', value: '24', unit: '°C', color: AppColors.danger),
          ],
        ),
      ],
    );
  }

  Widget _buildEmergencyButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('⚠ Emergency Stop Activated!'),
            backgroundColor: AppColors.danger,
            behavior: SnackBarBehavior.floating,
          ),
        );
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.danger.withOpacity(0.05),
        foregroundColor: AppColors.danger,
        minimumSize: const Size.fromHeight(65),
        side: const BorderSide(color: AppColors.danger, width: 1),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      ),
      child: const Text(
        'EMERGENCY STOP',
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, letterSpacing: 2),
      ),
    );
  }
}

// ويدجت صندوق الحساس الموحد
class _SensorBox extends StatelessWidget {
  final IconData icon;
  final String label, value, unit;
  final Color color;

  const _SensorBox({required this.icon, required this.label, required this.value, required this.unit, required this.color});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppColors.cardBg.withOpacity(0.3),
          borderRadius: BorderRadius.circular(25),
          border: Border.all(color: AppColors.cardBorder),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
              child: Icon(icon, color: color, size: 22),
            ),
            const SizedBox(height: 15),
            Text(label, style: const TextStyle(color: AppColors.textGrey, fontSize: 13, fontWeight: FontWeight.w500)),
            const SizedBox(height: 6),
            Row(
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: [
                Text(value, style: const TextStyle(color: AppColors.textLight, fontSize: 22, fontWeight: FontWeight.bold)),
                if (unit.isNotEmpty) ...[
                  const SizedBox(width: 4),
                  Text(unit, style: const TextStyle(color: AppColors.textGrey, fontSize: 13)),
                ]
              ],
            ),
          ],
        ),
      ),
    );
  }
}
