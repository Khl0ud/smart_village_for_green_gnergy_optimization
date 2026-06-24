import 'package:flutter/material.dart';
import 'package:smart_village_for_green_gnergy_optimization/core/api_constants.dart';
import 'package:smart_village_for_green_gnergy_optimization/core/theme/app_colors.dart';
import 'package:smart_village_for_green_gnergy_optimization/core/services/camera_service.dart';
import 'shared_widgets.dart';
import 'live_screen.dart';


class SurveillanceGridPage extends StatefulWidget {
  const SurveillanceGridPage({super.key});

  @override
  State<SurveillanceGridPage> createState() => _SurveillanceGridPageState();
}

class _SurveillanceGridPageState extends State<SurveillanceGridPage> {
  final CameraService _cameraService = CameraService();
  List<dynamic> _cameras = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchCameras();
  }

  Future<void> _fetchCameras() async {
    setState(() => _isLoading = true);
    final cameras = await _cameraService.getAllCameras();
    if (mounted) {
      setState(() {
        _cameras = cameras;
        _isLoading = false;
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    const Color mainBg = AppColors.scaffoldBg;
    const Color primaryNeon = AppColors.primaryNeon;

    return Scaffold(
      backgroundColor: mainBg,
      body: _isLoading 
        ? const Center(child: CircularProgressIndicator(color: AppColors.primaryNeon))
        : RefreshIndicator(
            onRefresh: _fetchCameras,
            color: AppColors.primaryNeon,
            child: CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                const SliverToBoxAdapter(child: TopSearchBar()),

                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(24, 20, 24, 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Live Surveillance',
                          style: TextStyle(
                            color: primaryNeon,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.5,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.sync_rounded, color: AppColors.primaryNeon),
                          onPressed: () async {
                            final success = await _cameraService.syncRecordings();
                            if (success && mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text("Sync completed!")),
                              );
                              _fetchCameras();
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ),

                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                  sliver: SliverGrid(
                    delegate: SliverChildBuilderDelegate((context, i) {
                      final camera = _cameras[i];
                      final name = camera['name'] ?? 'Camera';
                      final location = camera['location'] ?? 'Public';
                      final streamUrl = camera['streamUrl'] ?? '';

                      return _ImageCard (
                        title: name,
                        subtitle: location,
                        assetPath: 'assets/gate.png', // Default image or use from server if available
                        accentColor: primaryNeon,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => LiveScreen(
                                cameraId: camera['id'] ?? 0,
                                cameraName: name,
                                url: streamUrl,
                              ),
                            ),
                          );
                        },
                      );
                    }, childCount: _cameras.length),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 15,
                      mainAxisSpacing: 15,
                      childAspectRatio: 1.1,
                    ),
                  ),
                ),

                const SliverToBoxAdapter(child: SizedBox(height: 120)),
              ],
            ),
          ),
    );
  }
}


class _ImageCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String assetPath;
  final Color accentColor;
  final VoidCallback onTap;

  const _ImageCard({
    required this.title,
    required this.subtitle,
    required this.assetPath,
    required this.accentColor,
    required this.onTap,
  });


  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(25),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25),
          border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(25),
          child: Stack(
            children: [
              Positioned.fill(
                child: Image.asset(
                  assetPath,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    color: AppColors.cardBg,
                    child: const Icon(
                      Icons.videocam_off_rounded,
                      color: Colors.white24,
                    ),
                  ),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black.withValues(alpha: 0.1),
                      Colors.black.withValues(alpha: 0.8),
                    ],
                  ),
                ),
                padding: const EdgeInsets.all(12),
                child: Stack(
                  children: [
                    Align(
                      alignment: Alignment.bottomLeft,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            title,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                            ),
                          ),
                          Text(
                            subtitle,
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 10,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Container(
                                width: 6,
                                height: 6,
                                decoration: BoxDecoration(
                                  color: accentColor,
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: 4),
                              Text(
                                'LIVE',
                                style: TextStyle(
                                  color: accentColor,
                                  fontSize: 10,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const Align(
                      alignment: Alignment.topRight,
                      child: CircleAvatar(
                        radius: 14,
                        backgroundColor: Colors.white12,
                        child: Icon(
                          Icons.fullscreen_rounded,
                          color: Colors.white,
                          size: 16,
                        ),
                      ),
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
