import 'package:flutter/material.dart';
import 'dart:ui';
// استيراد ملف الألوان المركزي الخاص بكِ
import 'package:smart_village_for_green_gnergy_optimization/core/theme/app_colors.dart';

class DoorControlPage extends StatefulWidget {
  static const String routeName = '/DoorControlPage';
  const DoorControlPage({Key? key}) : super(key: key);

  @override
  State<DoorControlPage> createState() => _DoorControlPageState();
}

class _DoorControlPageState extends State<DoorControlPage> {
  // حالات الأبواب (true تعني مغلق/Locked بناءً على صورة النظام)
  bool mainDoorLocked = true;
  bool garageAccessLocked = true;
  bool backGardenLocked = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBg, // استخدام اللون الموحد من ملفك
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: AppColors.textLight, size: 22),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Security & Doors",
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
            // كارت الحالة الأمنية الموحد
            _buildSecurityStatusCard(),
            const SizedBox(height: 25),

            _buildDoorActionTile("Main Entrance", mainDoorLocked, () {
              setState(() => mainDoorLocked = !mainDoorLocked);
            }),
            const SizedBox(height: 15),
            _buildDoorActionTile("Garage Access", garageAccessLocked, () {
              setState(() => garageAccessLocked = !garageAccessLocked);
            }),
            const SizedBox(height: 15),
            _buildDoorActionTile("Back Garden Door", backGardenLocked, () {
              setState(() => backGardenLocked = !backGardenLocked);
            }),

            const Spacer(),
            
            // زر قفل الكل بلون النيون الأساسي
            _buildLockAllButton(),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildSecurityStatusCard() {
    bool allLocked = mainDoorLocked && garageAccessLocked && backGardenLocked;
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.cardBg.withOpacity(0.4),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.primaryNeon.withOpacity(0.3)), // استخدام primaryNeon
      ),
      child: Row(
        children: [
          Icon(
            allLocked ? Icons.verified_user_rounded : Icons.gpp_maybe_rounded, 
            color: allLocked ? AppColors.success : AppColors.warning, 
            size: 30,
          ),
          const SizedBox(width: 15),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Secure",
                style: TextStyle(
                  color: AppColors.textLight,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                allLocked ? "All doors are locked" : "Some doors are open",
                style: const TextStyle(color: AppColors.textGrey, fontSize: 13),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDoorActionTile(String title, bool isLocked, VoidCallback onTap) {
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
              Icon(
                Icons.door_sliding_outlined, 
                color: isLocked ? AppColors.textGrey : AppColors.primaryNeon, 
                size: 28,
              ),
              const SizedBox(width: 15),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: AppColors.textLight,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    isLocked ? "Locked" : "Unlocked",
                    style: TextStyle(
                      color: isLocked ? AppColors.textGrey : AppColors.primaryNeon,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ],
          ),
          // زر الفتح/الغلق بتصميم زجاجي (Glassmorphism)
          SizedBox(
            width: 100,
            height: 45,
            child: ElevatedButton(
              onPressed: onTap,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.glassWhite,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                elevation: 0,
              ),
              child: Text(
                isLocked ? "Open" : "Close",
                style: const TextStyle(color: AppColors.textLight, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLockAllButton() {
    return SizedBox(
      width: double.infinity,
      height: 60,
      child: ElevatedButton.icon(
        onPressed: () {
          setState(() {
            mainDoorLocked = garageAccessLocked = backGardenLocked = true;
          });
        },
        icon: const Icon(Icons.lock_rounded, color: AppColors.textDark),
        label: const Text(
          "Lock All Doors",
          style: TextStyle(color: AppColors.textDark, fontWeight: FontWeight.bold, fontSize: 16),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryNeon, // الربط مع الهوية البصرية
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        ),
      ),
    );
  }
}
