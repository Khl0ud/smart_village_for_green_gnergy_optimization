import 'package:flutter/material.dart';
import 'dart:ui';
// استيراد ملف الألوان المركزي لضمان الربط المعماري للمشروع
import 'package:smart_village_for_green_gnergy_optimization/core/theme/app_colors.dart';

class ShowReservationsPage extends StatefulWidget {
  // اسم المسار الموحد لضمان عمل الأزرار في الداشبورد
  static const routeName = '/ShowReservationsPage';
  const ShowReservationsPage({super.key});

  @override
  State<ShowReservationsPage> createState() => _ShowReservationsPageState();
}

class _ShowReservationsPageState extends State<ShowReservationsPage> {
  // بيانات تجريبية محدثة لمحاكاة محتوى صورك
  final List<Map<String, String>> mockReservations = const [
    {
      'space': 'A4',
      'vehicle': 'XYZ 7890',
      'time': '10:00 AM • Today',
      'status': 'reserved',
    },
    {
      'space': 'A6',
      'vehicle': 'BMW 1234',
      'time': '12:00 PM • Today',
      'status': 'reserved',
    },
    {
      'space': 'B2',
      'vehicle': 'ABC 1234',
      'time': '08:00 AM • Yesterday',
      'status': 'finished',
    },
    {
      'space': 'C1',
      'vehicle': 'LMN 5678',
      'time': '03:00 PM • Tomorrow',
      'status': 'reserved',
    },
  ];

  @override
  Widget build(BuildContext context) {
    const Color primaryNeon = AppColors.primaryNeon;

    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      extendBody: true,
      body: Stack(
        children: [
          _buildBackgroundGradient(),
          SafeArea(
            child: Column(
              children: [
                _buildModernHeader(context, primaryNeon),
                Expanded(
                  child: ListView.builder(
                    // مسافة سفلية كافية لمنع التداخل مع شريط التنقل
                    padding: const EdgeInsets.fromLTRB(20, 10, 20, 120),
                    physics: const BouncingScrollPhysics(),
                    itemCount: mockReservations.length,
                    itemBuilder: (context, index) {
                      final res = mockReservations[index];
                      final bool isFinished = res['status'] == 'finished';
                      return _buildReservationCard(
                        context,
                        res['space']!,
                        res['vehicle']!,
                        res['time']!,
                        isFinished,
                        primaryNeon,
                      );
                    },
                  ),
                ),
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
          colors: [AppColors.scaffoldBg, AppColors.cardBg],
        ),
      ),
    );
  }

  Widget _buildModernHeader(BuildContext context, Color accent) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(
              Icons.arrow_back_ios_new_rounded,
              color: Colors.white,
              size: 20,
            ),
            onPressed: () => Navigator.of(context).pop(),
          ),
          const Expanded(
            child: Text(
              'My Bookings',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.1,
              ),
            ),
          ),
          const SizedBox(width: 40),
        ],
      ),
    );
  }

  Widget _buildReservationCard(
    BuildContext context,
    String space,
    String vehicle,
    String time,
    bool isFinished,
    Color accent,
  ) {
    final statusColor = isFinished ? AppColors.textGrey : accent;
    final statusText = isFinished ? 'COMPLETED' : 'ACTIVE';

    return ClipRRect(
      borderRadius: BorderRadius.circular(28),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          margin: const EdgeInsets.only(bottom: 16),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: AppColors.cardBg.withOpacity(0.4),
            borderRadius: BorderRadius.circular(28),
            border: Border.all(color: AppColors.cardBorder),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.05),
                  shape: BoxShape.circle,
                  border: Border.all(color: statusColor.withOpacity(0.1)),
                ),
                child: Icon(
                  isFinished
                      ? Icons.event_available_rounded
                      : Icons.timer_outlined,
                  color: statusColor,
                  size: 26,
                ),
              ),
              const SizedBox(width: 18),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Parking Spot $space',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'ID: $vehicle', // تم تحديث التسمية لتطابق المحتوى المطلوب
                      style: const TextStyle(
                        color: AppColors.textGrey,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      time,
                      style: TextStyle(
                        color: statusColor.withOpacity(0.6),
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  _buildStatusBadge(statusText, statusColor),
                  const SizedBox(height: 15),
                  _buildActionButtons(isFinished, accent),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusBadge(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.w900,
          fontSize: 9,
          letterSpacing: 1.0,
        ),
      ),
    );
  }

  Widget _buildActionButtons(bool isFinished, Color accent) {
    return Row(
      children: [
        if (!isFinished) _buildSmallIconAction(Icons.edit_note_rounded, accent),
        const SizedBox(width: 8),
        _buildSmallIconAction(
          Icons.delete_sweep_rounded,
          AppColors.danger.withOpacity(0.8),
        ),
      ],
    );
  }

  Widget _buildSmallIconAction(IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.3),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: color.withOpacity(0.1)),
      ),
      child: Icon(icon, color: color, size: 18),
    );
  }
}
