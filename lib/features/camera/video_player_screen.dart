import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';
import 'package:smart_village_for_green_gnergy_optimization/core/services/camera_service.dart';
import 'package:smart_village_for_green_gnergy_optimization/core/theme/app_colors.dart';

class VideoPlayerScreen extends StatefulWidget {
  final String url;
  final String title;
  final String? cameraId; // معرف الكاميرا الاختياري لجلب تفاصيلها من السيرفر

  const VideoPlayerScreen({
    super.key,
    required this.url,
    required this.title,
    this.cameraId,
  });

  @override
  State<VideoPlayerScreen> createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  final CameraService _cameraService = CameraService();

  late VideoPlayerController _videoPlayerController;
  ChewieController? _chewieController;

  bool _isError = false;
  bool _isSyncing = true;
  Map<String, dynamic>? _cameraInfo;
  String _statusMessage = 'Syncing recordings with server...';

  @override
  void initState() {
    super.initState();
    _syncAndPlay();
  }

  // الخطوة 1: مزامنة السيرفر ثم تشغيل الفيديو
  Future<void> _syncAndPlay() async {
    setState(() {
      _isSyncing = true;
      _isError = false;
      _statusMessage = 'Syncing recordings with server...';
    });

    // مزامنة التسجيلات مع السيرفر
    await _cameraService.syncRecordings();

    // جلب معلومات الكاميرا من السيرفر إن كان الـ ID موجود
    if (widget.cameraId != null) {
      _cameraInfo = await _cameraService.getCameraById(widget.cameraId!);
    }

    if (mounted) {
      setState(() {
        _isSyncing = false;
        _statusMessage = 'Initializing player...';
      });
      await _initializePlayer();
    }
  }

  // الخطوة 2: تهيئة مشغل الفيديو بالرابط القادم من السيرفر
  Future<void> _initializePlayer() async {
    try {
      _videoPlayerController =
          VideoPlayerController.networkUrl(Uri.parse(widget.url));
      await _videoPlayerController.initialize();

      _chewieController = ChewieController(
        videoPlayerController: _videoPlayerController,
        autoPlay: true,
        looping: false,
        aspectRatio: _videoPlayerController.value.aspectRatio,
        errorBuilder: (context, errorMessage) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, color: AppColors.danger, size: 48),
                const SizedBox(height: 12),
                Text(errorMessage,
                    style: const TextStyle(color: Colors.white), textAlign: TextAlign.center),
                const SizedBox(height: 16),
                ElevatedButton.icon(
                  onPressed: _syncAndPlay,
                  icon: const Icon(Icons.refresh_rounded),
                  label: const Text('Retry from Server'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryNeon,
                    foregroundColor: AppColors.textDark,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  ),
                ),
              ],
            ),
          );
        },
      );
      if (mounted) setState(() {});
    } catch (e) {
      if (mounted) setState(() => _isError = true);
    }
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    _chewieController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // استخدام بيانات السيرفر إن توفرت أو الاحتياطية
    final cameraName = _cameraInfo?['name'] ?? widget.title;
    final zoneName = _cameraInfo?['zone']?['name'] ?? 'Smart Village';
    final streamUrl = _cameraInfo?['streamUrl'] ?? widget.url;

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              cameraName,
              style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
            ),
            Row(
              children: [
                const Icon(Icons.location_on_rounded, color: AppColors.primaryNeon, size: 12),
                const SizedBox(width: 4),
                Text(
                  zoneName,
                  style: const TextStyle(color: Colors.white54, fontSize: 11),
                ),
              ],
            ),
          ],
        ),
        actions: [
          // زر المزامنة اليدوية مع السيرفر
          if (!_isSyncing)
            IconButton(
              icon: const Icon(Icons.sync_rounded, color: AppColors.primaryNeon),
              onPressed: _syncAndPlay,
              tooltip: 'Re-sync with server',
            ),
        ],
      ),
      body: _isSyncing
          // حالة التحميل (مزامنة مع السيرفر)
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const CircularProgressIndicator(color: AppColors.primaryNeon),
                  const SizedBox(height: 20),
                  Text(
                    _statusMessage,
                    style: const TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    streamUrl,
                    style: const TextStyle(color: Colors.white30, fontSize: 10),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            )
          : _isError
              // حالة الخطأ مع إمكانية إعادة المحاولة من السيرفر
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.videocam_off_rounded,
                          color: AppColors.danger, size: 64),
                      const SizedBox(height: 16),
                      const Text(
                        'Cannot connect to server stream',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Check your network or server status',
                        style: TextStyle(color: Colors.white54, fontSize: 12),
                      ),
                      const SizedBox(height: 24),
                      ElevatedButton.icon(
                        onPressed: _syncAndPlay,
                        icon: const Icon(Icons.refresh_rounded),
                        label: const Text('Retry from Server'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryNeon,
                          foregroundColor: AppColors.textDark,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 24, vertical: 14),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20)),
                        ),
                      ),
                    ],
                  ),
                )
              // حالة التشغيل الفعلي
              : _chewieController != null &&
                      _chewieController!
                          .videoPlayerController.value.isInitialized
                  ? Chewie(controller: _chewieController!)
                  : const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircularProgressIndicator(color: AppColors.primaryNeon),
                          SizedBox(height: 12),
                          Text(
                            'Loading stream from server...',
                            style: TextStyle(color: Colors.white70),
                          ),
                        ],
                      ),
                    ),
    );
  }
}