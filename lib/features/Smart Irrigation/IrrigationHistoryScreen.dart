import 'package:flutter/material.dart';
import 'dart:ui';
// استيراد ملف الألوان المركزي الخاص بمشروعكِ
import 'package:smart_village_for_green_gnergy_optimization/core/theme/app_colors.dart';
import 'SmartIrrigationPage.dart';

class IrrigationHistoryScreen extends StatelessWidget {
  // اسم المسار للربط في ملف main.dart
  static const String routeName = '/IrrigationHistoryScreen';

  const IrrigationHistoryScreen({super.key});

  final List<Map<String, String>> history = const [
    {"time": "Now 12:41 PM", "details": "8Min • 8L • Auto", "status": "In Progress"},
    {"time": "Yesterday 12:41 PM", "details": "8Min • 8L • Auto", "status": "Completed"},
    {"time": "23rd Aug 12:41 PM", "details": "8Min • 8L • Auto", "status": "Completed"},
    {"time": "22nd Aug 12:41 PM", "details": "8Min • 8L • Auto", "status": "Completed"},
    {"time": "21st Aug 12:41 PM", "details": "8Min • 8L • Auto", "status": "Completed"},
    {"time": "20 Aug 12:41 PM", "details": "8Min • 8L • Auto", "status": "Completed"},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBg, // استخدام الخلفية الموحدة من ملفك
      body: Stack(
        children: [
          _buildBackgroundGradient(),
          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(context),
                const SizedBox(height: 25),
                _buildLogsList(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBackgroundGradient() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: AppColors.mainGradient,
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back_ios_new_rounded, color: AppColors.textLight, size: 22),
            onPressed: () => Navigator.pop(context),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Irrigation Logs",
                  style: TextStyle(
                    color: AppColors.textLight,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.1,
                  ),
                ),
                Text(
                  "Historical water usage and cycles",
                  style: TextStyle(color: AppColors.textGrey, fontSize: 14),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLogsList() {
    return Expanded(
      child: ListView.builder(
        itemCount: history.length,
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 100),
        physics: const BouncingScrollPhysics(),
        itemBuilder: (context, index) {
          final item = history[index];
          final bool isInProgress = item["status"] == "In Progress";

          return GestureDetector(
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const SmartIrrigationPage()),
            ),
            child: Container(
              margin: const EdgeInsets.only(bottom: 15),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.cardBg.withOpacity(0.4), // تأثير زجاجي معتمد
                borderRadius: BorderRadius.circular(25),
                border: Border.all(
                  color: isInProgress ? AppColors.primaryNeon.withOpacity(0.3) : AppColors.cardBorder,
                ),
              ),
              child: Row(
                children: [
                  _buildStatusIndicator(isInProgress),
                  const SizedBox(width: 16),
                  _buildLogInfo(item),
                  _buildStatusText(isInProgress),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildStatusIndicator(bool isInProgress) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: isInProgress ? AppColors.primaryNeon.withOpacity(0.1) : Colors.white.withOpacity(0.05),
        shape: BoxShape.circle,
      ),
      child: Icon(
        isInProgress ? Icons.sync_rounded : Icons.check_circle_outline_rounded,
        color: isInProgress ? AppColors.primaryNeon : AppColors.textGrey,
        size: 22,
      ),
    );
  }

  Widget _buildLogInfo(Map<String, String> item) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            item["time"]!,
            style: const TextStyle(color: AppColors.textLight, fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 4),
          Text(
            item["details"]!,
            style: const TextStyle(color: AppColors.textGrey, fontSize: 13),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusText(bool isInProgress) {
    return Text(
      isInProgress ? "RUNNING" : "DONE",
      style: TextStyle(
        color: isInProgress ? AppColors.primaryNeon : AppColors.textGrey.withOpacity(0.5),
        fontWeight: FontWeight.w900,
        fontSize: 10,
        letterSpacing: 1,
      ),
    );
  }
}
