import 'package:flutter/material.dart';
import 'package:smart_village_for_green_gnergy_optimization/core/theme/app_colors.dart';
import 'waste_main.dart';
import 'data/services/waste_service.dart';

class BinLevelsScreen extends StatefulWidget {
  final List<Bin>? initialBins;
  const BinLevelsScreen({super.key, this.initialBins});

  @override
  State<BinLevelsScreen> createState() => _BinLevelsScreenState();
}

class _BinLevelsScreenState extends State<BinLevelsScreen> {
  final WasteService _wasteService = WasteService();
  late List<Bin> _bins;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _bins = widget.initialBins ?? [];
    if (_bins.isEmpty) {
      _fetchBins();
    }
  }

  Future<void> _fetchBins() async {
    setState(() => _isLoading = true);
    final data = await _wasteService.getDashboard(1);
    if (mounted && data != null) {
      setState(() {
        _bins = (data['binsDetails'] as List).map((b) => Bin(
          id: b['id']?.toString() ?? '0',
          location: b['name'] ?? 'Unknown',
          fill: (b['fillLevel'] ?? 0.0).toDouble() / 100.0,
          type: 'General',
          lat: b['latitude']?.toDouble(),
          lng: b['longitude']?.toDouble(),
        )).toList();
        _isLoading = false;
      });
    } else {
      setState(() => _isLoading = false);
    }
  }

  Color _getStatusColor(double fill) {
    if (fill >= 0.8) return AppColors.danger;
    if (fill >= 0.5) return AppColors.warning;
    return AppColors.primaryNeon;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      body: Stack(
        children: [
          _buildBackgroundGradient(),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(context),
                  const SizedBox(height: 25),
                  Expanded(
                    child: _isLoading 
                      ? const Center(child: CircularProgressIndicator(color: AppColors.primaryNeon))
                      : RefreshIndicator(
                          onRefresh: _fetchBins,
                          color: AppColors.primaryNeon,
                          child: _bins.isEmpty 
                            ? const Center(child: Text("No bins found", style: TextStyle(color: AppColors.textGrey)))
                            : ListView.separated(
                                physics: const AlwaysScrollableScrollPhysics(),
                                padding: const EdgeInsets.only(bottom: 50),
                                itemCount: _bins.length,
                                separatorBuilder: (_, index) => const SizedBox(height: 16),
                                itemBuilder: (context, i) {
                                  final bin = _bins[i];
                                  final statusColor = _getStatusColor(bin.fill);
                                  return _BinLevelCard(bin: bin, color: statusColor);
                                },
                              ),
                        ),
                  ),
                ],
              ),
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 10),
        IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: AppColors.textLight, size: 22),
          onPressed: () => Navigator.pop(context),
        ),
        const SizedBox(height: 10),
        const Text('Real-time Monitoring', style: TextStyle(color: AppColors.textGrey, fontSize: 14, letterSpacing: 1.2)),
        const Text('Bin Fill Levels', style: TextStyle(fontSize: 28, color: AppColors.textLight, fontWeight: FontWeight.bold)),
      ],
    );
  }
}

class _BinLevelCard extends StatelessWidget {
  final Bin bin;
  final Color color;
  const _BinLevelCard({required this.bin, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.cardBg.withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Row(
        children: [
          _buildAnimatedCircularIndicator(),
          const SizedBox(width: 20),
          Expanded(child: _buildBinDetails()),
        ],
      ),
    );
  }

  Widget _buildAnimatedCircularIndicator() {
    return SizedBox(
      width: 80,
      height: 80,
      child: TweenAnimationBuilder<double>(
        tween: Tween(begin: 0.0, end: bin.fill),
        duration: const Duration(milliseconds: 1500),
        curve: Curves.easeOutQuart,
        builder: (context, v, _) {
          return Stack(
            alignment: Alignment.center,
            children: [
              CircularProgressIndicator(
                value: v.clamp(0.0, 1.0),
                strokeWidth: 8,
                backgroundColor: Colors.white.withValues(alpha: 0.05),
                valueColor: AlwaysStoppedAnimation(color),
              ),
              Text('${(v * 100).toInt()}%', style: const TextStyle(color: AppColors.textLight, fontWeight: FontWeight.w900, fontSize: 16)),
            ],
          );
        },
      ),
    );
  }

  Widget _buildBinDetails() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(bin.id, style: const TextStyle(color: AppColors.textLight, fontWeight: FontWeight.bold, fontSize: 18)),
            _buildStatusBadge(),
          ],
        ),
        const SizedBox(height: 6),
        Row(
          children: [
            const Icon(Icons.location_on_rounded, color: AppColors.textGrey, size: 14),
            const SizedBox(width: 4),
            Text(bin.location, style: const TextStyle(color: AppColors.textGrey, fontSize: 13)),
          ],
        ),
        const SizedBox(height: 15),
        _buildLinearIndicator(),
      ],
    );
  }

  Widget _buildLinearIndicator() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: LinearProgressIndicator(
        value: bin.fill,
        minHeight: 8,
        backgroundColor: Colors.white.withValues(alpha: 0.05),
        valueColor: AlwaysStoppedAnimation(color),
      ),
    );
  }

  Widget _buildStatusBadge() {
    String label = bin.fill >= 0.8 ? 'Critical' : (bin.fill >= 0.5 ? 'Moderate' : 'Good');
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Text(label.toUpperCase(), style: TextStyle(color: color, fontSize: 9, fontWeight: FontWeight.w900, letterSpacing: 0.5)),
    );
  }
}
