import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:ui';
import 'package:smart_village_for_green_gnergy_optimization/core/theme/app_colors.dart';
import 'data/services/auth_service.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final AuthService _authService = AuthService();
  bool _isLoading = true;
  List<dynamic> _realNotifications = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _fetchNotifications();

    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
    ));
  }

  Future<void> _fetchNotifications() async {
    final data = await _authService.getNotifications();
    if (mounted) {
      setState(() {
        _realNotifications = data;
        _isLoading = false;
      });
    }
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
                  child: _isLoading 
                    ? const Center(child: CircularProgressIndicator(color: AppColors.primaryNeon))
                    : TabBarView(
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
          TextButton(
            onPressed: () async {
              final success = await _authService.markAllNotificationsAsRead();
              if (success && mounted) {
                setState(() {
                  for (var item in _realNotifications) {
                    item['isRead'] = true;
                  }
                });
              }
            },
            child: Text(
              "Mark all as read",
              style: TextStyle(color: accent, fontSize: 12, fontWeight: FontWeight.bold),
            ),
          ),
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
    if (_realNotifications.isEmpty) {
      return const Center(
        child: Text("No notifications yet", style: TextStyle(color: AppColors.textGrey)),
      );
    }
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 100),
      physics: const BouncingScrollPhysics(),
      itemCount: _realNotifications.length,
      itemBuilder: (context, index) {
        final item = _realNotifications[index];
        return _buildNotificationCard(item);
      },
    );
  }

  Widget _buildNotificationCard(dynamic item) {
    // تحديد الأيقونة بناءً على النوع أو اختيار أيقونة افتراضية
    IconData icon = Icons.notifications_none_rounded;
    if (item['title']?.toString().contains('Irrigation') ?? false) icon = Icons.water_drop_rounded;
    if (item['title']?.toString().contains('Security') ?? false) icon = Icons.security_rounded;
    
    bool isRead = item['isRead'] ?? false;

    return GestureDetector(
      onTap: () async {
        if (!isRead) {
          final success = await _authService.markNotificationAsRead(item['id'].toString());
          if (success && mounted) {
            setState(() {
              item['isRead'] = true; // تحديث الحالة محلياً فوراً
            });
          }
        }
      },
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 300),
        opacity: isRead ? 0.6 : 1.0,
        child: Container(
          margin: const EdgeInsets.only(bottom: 15),
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: isRead ? AppColors.cardBg.withOpacity(0.2) : AppColors.cardBg.withOpacity(0.4),
            borderRadius: BorderRadius.circular(25),
            border: Border.all(color: isRead ? AppColors.cardBorder.withOpacity(0.5) : AppColors.cardBorder),
          ),
          child: Row(
            children: [
              Stack(
                alignment: Alignment.topRight,
                children: [
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: AppColors.primaryNeon.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Icon(icon, color: AppColors.primaryNeon, size: 26),
                  ),
                  if (!isRead)
                    Container(
                      width: 12,
                      height: 12,
                      decoration: const BoxDecoration(
                        color: AppColors.primaryNeon,
                        shape: BoxShape.circle,
                        boxShadow: [BoxShadow(color: AppColors.primaryNeon, blurRadius: 10)],
                      ),
                    ),
                ],
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
                          item["title"] ?? "Notification",
                          style: TextStyle(
                            color: isRead ? AppColors.textGrey : AppColors.textLight, 
                            fontWeight: isRead ? FontWeight.normal : FontWeight.bold, 
                            fontSize: 16
                          ),
                        ),
                        Text(
                          item["createdAt"]?.toString().substring(0, 10) ?? "",
                          style: const TextStyle(color: AppColors.textGrey, fontSize: 10, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    const SizedBox(height: 5),
                    Text(
                      item["message"] ?? item["body"] ?? "",
                      style: TextStyle(
                        color: isRead ? Colors.white24 : Colors.white54, 
                        fontSize: 13, 
                        height: 1.4
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }


}
