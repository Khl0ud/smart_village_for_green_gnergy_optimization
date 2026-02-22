import 'package:flutter/material.dart';
import 'dart:ui';
// استيراد ملف الألوان المركزي الخاص بكِ لضمان الربط المعماري
import 'package:smart_village_for_green_gnergy_optimization/core/theme/app_colors.dart';

class ValveControlPage extends StatefulWidget {
  // اسم المسار لربطه بالداشبورد لاحقاً
  static const String routeName = '/ValveControlPage';
  const ValveControlPage({Key? key}) : super(key: key);

  @override
  State<ValveControlPage> createState() => _ValveControlPageState();
}

class _ValveControlPageState extends State<ValveControlPage> {
  // الحالات الافتراضية بناءً على تصميم النظام في صورك
  bool mainWaterValveOpen = false;
  bool gardenValveOpen = true;
  bool kitchenValveOpen = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBg, // استخدام الخلفية الموحدة من ملفك
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            color: AppColors.textLight,
            size: 22,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Valve Control", // مطابق للصورة
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 22,
            color: AppColors.textLight,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            const SizedBox(height: 10),

            // التحكم في المحابس الفردية بتصميم مطابق للصورة
            _buildValveActionTile(
              "Main Water Valve",
              mainWaterValveOpen,
              Icons.water_drop_rounded,
              () => setState(() => mainWaterValveOpen = !mainWaterValveOpen),
            ),
            const SizedBox(height: 15),

            _buildValveActionTile(
              "Garden Valve",
              gardenValveOpen,
              Icons.eco_rounded,
              () => setState(() => gardenValveOpen = !gardenValveOpen),
            ),
            const SizedBox(height: 15),

            _buildValveActionTile(
              "Kitchen Valve",
              kitchenValveOpen,
              Icons.opacity_rounded,
              () => setState(() => kitchenValveOpen = !kitchenValveOpen),
            ),

            const Spacer(),

            // زر إغلاق الكل الأخضر بتصميم Stadium
            _buildCloseAllButton(),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildValveActionTile(
    String title,
    bool isOpen,
    IconData icon,
    VoidCallback onTap,
  ) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: AppColors.cardBg.withOpacity(0.3),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              // أيقونة المحبس بلون النيون أو الرمادي حسب الحالة
              Icon(
                icon,
                color: isOpen ? AppColors.info : AppColors.textGrey,
                size: 28,
              ),
              const SizedBox(width: 15),
              Text(
                title,
                style: const TextStyle(
                  color: AppColors.textLight,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          // زر الفتح/الغلق الملون مطابق للصورة
          SizedBox(
            width: 100,
            height: 45,
            child: ElevatedButton(
              onPressed: onTap,
              style: ElevatedButton.styleFrom(
                backgroundColor: isOpen ? AppColors.success : AppColors.danger,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
              ),
              child: Text(
                isOpen ? "Open" : "Close",
                style: const TextStyle(
                  color: AppColors.textDark,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCloseAllButton() {
    return SizedBox(
      width: double.infinity,
      height: 60,
      child: ElevatedButton.icon(
        onPressed: () {
          setState(() {
            mainWaterValveOpen = gardenValveOpen = kitchenValveOpen = false;
          });
        },
        icon: const Icon(Icons.lock_rounded, color: AppColors.textDark),
        label: const Text(
          "Close All Valves", // مطابق للصورة
          style: TextStyle(
            color: AppColors.textDark,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryNeon, // اللون النيون الموحد
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
      ),
    );
  }
}
