import 'package:flutter/material.dart';
import 'dart:ui';
import 'dart:async';
import 'package:smart_village_for_green_gnergy_optimization/core/theme/app_colors.dart';
import 'package:smart_village_for_green_gnergy_optimization/core/services/camera_service.dart';

/// الخلفية المنحنية العلوية (Top Curved Background) بتصميم Glassmorphism
class TopCurvedBackground extends StatelessWidget {
  final double height;

  const TopCurvedBackground({super.key, this.height = 200});

  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: CurvedClipper(),
      child: Container(
        height: height,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppColors.cardBg,
              AppColors.scaffoldBg,
            ],
          ),
          border: Border(
            bottom: BorderSide(color: AppColors.primaryNeon.withValues(alpha: 0.1), width: 1),
          ),
        ),
      ),
    );
  }
}

/// المقص المنحني للخلفية
class CurvedClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0, size.height - 50);
    path.quadraticBezierTo(
      size.width / 2,
      size.height,
      size.width,
      size.height - 50,
    );
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CurvedClipper oldClipper) => false;
}

/// شريط البحث الموحد مع callback للبحث في السيرفر
class TopSearchBar extends StatelessWidget {
  final ValueChanged<String>? onSearch; // callback للبحث من السيرفر

  const TopSearchBar({super.key, this.onSearch});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.cardBg.withValues(alpha: 0.4),
              borderRadius: BorderRadius.circular(15),
              border: Border.all(
                color: AppColors.primaryNeon.withValues(alpha: 0.2),
                width: 1,
              ),
            ),
            child: TextField(
              style: const TextStyle(color: Colors.white),
              onChanged: onSearch, // ربط البحث بـ callback من السيرفر
              decoration: InputDecoration(
                hintText: 'Search for devices or logs...',
                hintStyle: TextStyle(color: AppColors.textGrey, fontSize: 14),
                prefixIcon: const Icon(
                  Icons.search_rounded,
                  color: AppColors.primaryNeon,
                  size: 22,
                ),
                border: InputBorder.none,
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// ويدجت يسمع للسيرفر ويعرض حالة الكاميرات في الوقت الفعلي
class LiveStatusBanner extends StatefulWidget {
  const LiveStatusBanner({super.key});

  @override
  State<LiveStatusBanner> createState() => _LiveStatusBannerState();
}

class _LiveStatusBannerState extends State<LiveStatusBanner> {
  final CameraService _cameraService = CameraService();
  Timer? _refreshTimer;

  int _total = 0;
  int _online = 0;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchStatus();
    // تحديث الحالة من السيرفر كل 15 ثانية تلقائياً
    _refreshTimer = Timer.periodic(
      const Duration(seconds: 15),
      (_) => _fetchStatus(),
    );
  }

  @override
  void dispose() {
    _refreshTimer?.cancel();
    super.dispose();
  }

  Future<void> _fetchStatus() async {
    final cameras = await _cameraService.getAllCameras();
    if (mounted) {
      setState(() {
        _total = cameras.length;
        _online = cameras
            .where((c) =>
                (c['status']?.toString().toLowerCase() ?? '') == 'online')
            .length;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const SizedBox(
        height: 40,
        child: Center(
          child: SizedBox(
            width: 18,
            height: 18,
            child: CircularProgressIndicator(
              color: AppColors.primaryNeon,
              strokeWidth: 2,
            ),
          ),
        ),
      );
    }

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.cardBg.withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: _online > 0
              ? AppColors.primaryNeon.withValues(alpha: 0.3)
              : AppColors.danger.withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        children: [
          // مؤشر النبضة الحية
          _PulseDot(color: _online > 0 ? AppColors.primaryNeon : AppColors.danger),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              _total == 0
                  ? 'No cameras connected to server'
                  : '$_online / $_total cameras online',
              style: TextStyle(
                color: _online > 0 ? AppColors.primaryNeon : AppColors.danger,
                fontSize: 13,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          // زر تحديث يدوي من السيرفر
          GestureDetector(
            onTap: () {
              setState(() => _isLoading = true);
              _fetchStatus();
            },
            child: const Icon(Icons.refresh_rounded,
                color: AppColors.textGrey, size: 18),
          ),
        ],
      ),
    );
  }
}

/// نقطة النبض الحية (Pulse Dot) للإشارة للحالة
class _PulseDot extends StatefulWidget {
  final Color color;
  const _PulseDot({required this.color});

  @override
  State<_PulseDot> createState() => _PulseDotState();
}

class _PulseDotState extends State<_PulseDot>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..repeat(reverse: true);
    _animation = Tween<double>(begin: 0.4, end: 1.0).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: widget.color.withValues(alpha: _animation.value),
            boxShadow: [
              BoxShadow(
                color: widget.color.withValues(alpha: _animation.value * 0.5),
                blurRadius: 6,
                spreadRadius: 2,
              ),
            ],
          ),
        );
      },
    );
  }
}
