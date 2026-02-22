import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:ui';
// استيراد ملف الألوان المركزي من مجلد core بناءً على هيكلية الملفات
import 'package:smart_village_for_green_gnergy_optimization/core/theme/app_colors.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // محاكاة لبيانات التنبيهات المنسقة لمشاريع الـ IoT
  final List<Map<String, dynamic>> _notifications = [
    {"title": "Irrigation Alert", "subtitle": "Zone A needs watering immediately.", "icon": Icons.water_drop_rounded, "time": "2m ago"},
    {"title": "Energy Update", "subtitle": "Solar panels are operating at 95% efficiency.", "icon": Icons.solar_power_rounded, "time": "15m ago"},
    {"title": "Security Notice", "subtitle": "New motion detected near the Smart Home gate.", "icon": Icons.security_rounded, "time": "1h ago"},
    {"title": "Waste Management", "subtitle": "Bin B-04 is 90% full. Collection requested.", "icon": Icons.delete_sweep_rounded, "time": "3h ago"},
    {"title": "System Update", "subtitle": "Smart Village OS updated to v2.4.0", "icon": Icons.system_update_rounded, "time": "Yesterday"},
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);

    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
    ));
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // تصحيح المسميات بناءً على ملف AppColors الأخير
    const Color mainBg = AppColors.scaffoldBg;
    const Color primaryNeon = AppColors.primaryNeon;

    return Scaffold(
      backgroundColor: mainBg,
      body: Stack(
        children: [
          // الخلفية المتدرجة الموحدة للمشروع
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [AppColors.scaffoldBg, AppColors.cardBg],
              ),
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                _buildHeader(primaryNeon),
                _buildTabBar(primaryNeon),
                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      _buildNotificationList(),
                      _buildNotificationList(filter: "Alerts"),
                      _buildNotificationList(filter: "Updates"),
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

  Widget _buildHeader(Color accent) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 20, 24, 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            "Alert Center",
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: AppColors.textLight,
              letterSpacing: 1.1,
            ),
          ),
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.cardBg.withOpacity(0.5),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.notifications_active_rounded, color: accent, size: 20),
          )
        ],
      ),
    );
  }

  Widget _buildTabBar(Color accent) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      height: 45,
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.2),
        borderRadius: BorderRadius.circular(25),
      ),
      child: TabBar(
        controller: _tabController,
        indicator: BoxDecoration(
          borderRadius: BorderRadius.circular(25),
          color: accent.withOpacity(0.1),
        ),
        indicatorSize: TabBarIndicatorSize.tab,
        dividerColor: Colors.transparent,
        labelColor: accent,
        unselectedLabelColor: AppColors.textGrey,
        labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
        tabs: const [
          Tab(text: "All"),
          Tab(text: "Alerts"),
          Tab(text: "Updates"),
        ],
      ),
    );
  }

  Widget _buildNotificationList({String? filter}) {
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 100),
      physics: const BouncingScrollPhysics(),
      itemCount: _notifications.length,
      itemBuilder: (context, index) {
        final item = _notifications[index];
        return _buildNotificationCard(item);
      },
    );
  }

  Widget _buildNotificationCard(Map<String, dynamic> item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        // تصميم Glassmorphism المعتمد
        color: AppColors.cardBg.withOpacity(0.4),
        borderRadius: BorderRadius.circular(25),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: AppColors.primaryNeon.withOpacity(0.05),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Icon(item["icon"], color: AppColors.primaryNeon, size: 26),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      item["title"]!,
                      style: const TextStyle(color: AppColors.textLight, fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    Text(
                      item["time"]!,
                      style: const TextStyle(color: AppColors.textGrey, fontSize: 10, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                const SizedBox(height: 5),
                Text(
                  item["subtitle"]!,
                  style: const TextStyle(color: Colors.white54, fontSize: 13, height: 1.4),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
