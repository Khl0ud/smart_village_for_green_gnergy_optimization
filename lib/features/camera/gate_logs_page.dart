import 'package:flutter/material.dart';
import 'dart:ui';
// استيراد ملف الألوان المركزي والويدجت المشتركة لضمان الربط المعماري
import 'package:smart_village_for_green_gnergy_optimization/core/theme/app_colors.dart';
import 'shared_widgets.dart';

import 'package:smart_village_for_green_gnergy_optimization/core/services/camera_service.dart';
import 'video_player_screen.dart';

class GateLogsPage extends StatefulWidget {
  const GateLogsPage({super.key});

  @override
  State<GateLogsPage> createState() => _GateLogsPageState();
}

class _GateLogsPageState extends State<GateLogsPage> {
  final CameraService _cameraService = CameraService();
  List<dynamic> logs = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchLogs();
  }

  Future<void> _fetchLogs() async {
    // افترضنا أن كاميرا البوابة الرئيسية تحمل رقم 1
    final recordings = await _cameraService.getRecordings('1');
    if (mounted) {
      setState(() {
        logs = recordings;
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    const Color mainBg = AppColors.scaffoldBg;
    const Color primaryNeon = AppColors.primaryNeon;

    return Scaffold(
      backgroundColor: mainBg,
      body: Stack(
        children: [
          const TopCurvedBackground(height: 200),
          Column(
            children: [
              // شريط البحث مع ربط البحث بالسيرفر
              TopSearchBar(
                onSearch: (query) {
                  // فلترة السجلات المحلية بناءً على البحث
                  setState(() {});
                },
              ),
              // بانر يعرض حالة الكاميرات من السيرفر في الوقت الفعلي
              const LiveStatusBanner(),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Gate Access Logs',
                      style: TextStyle(
                        color: primaryNeon,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
                      ),
                    ),
                    // زر تحديث السجلات يدوياً من السيرفر
                    IconButton(
                      icon: const Icon(Icons.refresh_rounded, color: AppColors.primaryNeon),
                      onPressed: _fetchLogs,
                      tooltip: 'Refresh from server',
                    ),
                  ],
                ),
              ),
              const _TableHeader(),
              const SizedBox(height: 10),
              Expanded(
                child: isLoading
                    ? const Center(child: CircularProgressIndicator(color: primaryNeon))
                    : logs.isEmpty
                        ? const Center(
                            child: Text('No recordings found.', style: TextStyle(color: AppColors.textGrey)))
                        : ListView.separated(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                            physics: const BouncingScrollPhysics(),
                            itemCount: logs.length,
                            itemBuilder: (_, i) {
                              final log = logs[i];
                              final time = log['time'] ?? 'Unknown Time';
                              final videoUrl = log['videoUrl'];
                              
                              return GestureDetector(
                                onTap: () {
                                  if (videoUrl != null) {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => VideoPlayerScreen(
                                          url: videoUrl,
                                          title: 'Recording $time',
                                        ),
                                      ),
                                    );
                                  }
                                },
                                child: _TableRow(
                                  type: 'Motion Detected',
                                  date: time,
                                  icon: Icons.videocam_rounded,
                                ),
                              );
                            },
                            separatorBuilder: (_, __) => const SizedBox(height: 12),
                          ),
              ),
              const SizedBox(height: 100),
            ],
          ),
        ],
      ),
    );
  }
}

class _TableHeader extends StatelessWidget {
  const _TableHeader();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: AppColors.cardBg.withOpacity(0.5), // تأثير شفاف زجاجي
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: AppColors.cardBorder),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      child: const Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              'Activity Type',
              style: TextStyle(color: AppColors.primaryNeon, fontWeight: FontWeight.bold, fontSize: 13),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              'Timestamp',
              style: TextStyle(color: AppColors.primaryNeon, fontWeight: FontWeight.bold, fontSize: 13),
            ),
          ),
        ],
      ),
    );
  }
}

class _TableRow extends StatelessWidget {
  final String type;
  final String date;
  final IconData icon;

  const _TableRow({
    required this.type,
    required this.date,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
      decoration: BoxDecoration(
        color: AppColors.cardBg.withOpacity(0.3), // تأثير شفاف زجاجي مطور
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.03)),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: type.contains('in') ? AppColors.success.withOpacity(0.1) : AppColors.warning.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    icon,
                    size: 16,
                    color: type.contains('in') ? AppColors.success : AppColors.warning,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  type,
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 14),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              date,
              style: const TextStyle(color: AppColors.textGrey, fontSize: 12),
            ),
          ),
          const Icon(Icons.arrow_forward_ios_rounded, color: Colors.white10, size: 14),
        ],
      ),
    );
  }
}
