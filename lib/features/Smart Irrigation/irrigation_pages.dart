import 'package:flutter/material.dart';
import 'package:smart_village_for_green_gnergy_optimization/core/theme/app_colors.dart';
import 'package:intl/intl.dart';
import 'irrigation_models.dart';
import 'irrigation_service.dart';

// ==================== Zone Control Page ====================
class ZoneControlPage extends StatefulWidget {
  final IrrigationZone zone;
  final double temperature;
  final bool isRaining;
  final int waterLevel;

  const ZoneControlPage({
    super.key,
    required this.zone,
    required this.temperature,
    required this.isRaining,
    required this.waterLevel,
  });

  @override
  State<ZoneControlPage> createState() => _ZoneControlPageState();
}

class _ZoneControlPageState extends State<ZoneControlPage> {
  late IrrigationZone _zone;
  bool _isIrrigating = false;
  DateTime? _irrigationStartTime;

  @override
  void initState() {
    super.initState();
    _zone = widget.zone;
  }

  void _startIrrigation() {
    final checkResult = IrrigationService.preIrrigationCheck(
      temperature: widget.temperature,
      currentMoisture: _zone.soilMoisture,
      isRaining: widget.isRaining,
      waterLevel: widget.waterLevel,
      lastIrrigation: _zone.lastIrrigation,
    );

    if (!checkResult['passed']) {
      _showCheckDialog(checkResult);
      return;
    }

    setState(() {
      _isIrrigating = true;
      _irrigationStartTime = DateTime.now();
      _zone = IrrigationZone(
        id: _zone.id,
        name: _zone.name,
        soilMoisture: _zone.soilMoisture,
        valveOpen: true,
        lastIrrigation: _zone.lastIrrigation,
      );
    });
  }

  void _stopIrrigation() {
    if (_irrigationStartTime != null) {
      final duration = DateTime.now().difference(_irrigationStartTime!);
      final moistureAfter = (_zone.soilMoisture + 15.0).clamp(0.0, 100.0);

      IrrigationService.logIrrigation(
        IrrigationLog(
          timestamp: DateTime.now(),
          zoneId: _zone.id,
          duration: duration,
          tempBefore: widget.temperature,
          moistureBefore: _zone.soilMoisture,
          moistureAfter: moistureAfter,
          isManual: true,
        ),
      );

      setState(() {
        _isIrrigating = false;
        _irrigationStartTime = null;
        _zone = IrrigationZone(
          id: _zone.id,
          name: _zone.name,
          soilMoisture: moistureAfter,
          valveOpen: false,
          lastIrrigation: DateTime.now(),
        );
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Irrigation completed. Duration: ${duration.inMinutes}m'),
          backgroundColor: AppColors.success,
        ),
      );
    }
  }

  void _showCheckDialog(Map<String, dynamic> checkResult) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.cardBg,
        title: const Row(
          children: [
            Icon(Icons.warning, color: AppColors.warning),
            SizedBox(width: 10),
            Text('Pre-Irrigation Check', style: TextStyle(color: AppColors.textLight)),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'System detected issues:',
              style: TextStyle(color: AppColors.textGrey, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            ...((checkResult['warnings'] as List<String>).map((w) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Row(
                children: [
                  const Icon(Icons.error_outline, color: AppColors.warning, size: 16),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(w, style: const TextStyle(color: AppColors.textLight, fontSize: 13)),
                  ),
                ],
              ),
            ))),
            const SizedBox(height: 15),
            const Text(
              'Do you want to proceed anyway?',
              style: TextStyle(color: AppColors.textGrey, fontSize: 12),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel', style: TextStyle(color: AppColors.textGrey)),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                _isIrrigating = true;
                _irrigationStartTime = DateTime.now();
                _zone = IrrigationZone(
                  id: _zone.id,
                  name: _zone.name,
                  soilMoisture: _zone.soilMoisture,
                  valveOpen: true,
                  lastIrrigation: _zone.lastIrrigation,
                );
              });
            },
            child: const Text('Proceed', style: TextStyle(color: AppColors.primaryNeon)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) {
          Navigator.pop(context, _zone);
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.scaffoldBg,
        body: Stack(
          children: [
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: AppColors.mainGradient,
                ),
              ),
            ),
            SafeArea(
              child: Column(
                children: [
                  _buildHeader(),
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        children: [
                          _buildMoistureCard(),
                          const SizedBox(height: 20),
                          _buildStatusCard(),
                          const SizedBox(height: 20),
                          _buildLastIrrigationCard(),
                          const SizedBox(height: 30),
                          _buildControlButton(),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back_ios_new, color: AppColors.textLight),
            onPressed: () => Navigator.pop(context, _zone),
          ),
          const Spacer(),
          Text(
            _zone.name,
            style: const TextStyle(
              color: AppColors.textLight,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Spacer(),
          Icon(
            Icons.grass,
            color: _zone.valveOpen ? AppColors.primaryNeon : AppColors.textGrey,
            size: 28,
          ),
        ],
      ),
    );
  }

  Widget _buildMoistureCard() {
    return Container(
      padding: const EdgeInsets.all(30),
      decoration: BoxDecoration(
        color: AppColors.cardBg.withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Column(
        children: [
          const Text(
            'Soil Moisture',
            style: TextStyle(color: AppColors.textGrey, fontSize: 14),
          ),
          const SizedBox(height: 15),
          Text(
            '${_zone.soilMoisture.toInt()}%',
            style: const TextStyle(
              color: AppColors.primaryNeon,
              fontSize: 64,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          LinearProgressIndicator(
            value: _zone.soilMoisture / 100,
            backgroundColor: Colors.white10,
            color: AppColors.primaryNeon,
            minHeight: 8,
            borderRadius: BorderRadius.circular(10),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.cardBg.withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(25),
        border: Border.all(
          color: _zone.valveOpen
              ? AppColors.primaryNeon.withValues(alpha: 0.5)
              : AppColors.cardBorder,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: (_zone.valveOpen ? AppColors.primaryNeon : AppColors.textGrey)
                  .withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              _zone.valveOpen ? Icons.water_drop : Icons.water_drop_outlined,
              color: _zone.valveOpen ? AppColors.primaryNeon : AppColors.textGrey,
              size: 28,
            ),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Valve Status',
                  style: TextStyle(color: AppColors.textGrey, fontSize: 12),
                ),
                const SizedBox(height: 5),
                Text(
                  _zone.valveOpen ? 'OPEN - Irrigating' : 'CLOSED - Standby',
                  style: TextStyle(
                    color: _zone.valveOpen ? AppColors.primaryNeon : AppColors.textLight,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLastIrrigationCard() {
    final lastIrrigation = _zone.lastIrrigation;
    final timeAgo = lastIrrigation != null
        ? DateTime.now().difference(lastIrrigation)
        : null;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.cardBg.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(25),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Row(
        children: [
          const Icon(Icons.history, color: AppColors.info, size: 24),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Last Irrigation',
                  style: TextStyle(color: AppColors.textGrey, fontSize: 12),
                ),
                const SizedBox(height: 5),
                Text(
                  timeAgo != null
                      ? '${timeAgo.inHours}h ${timeAgo.inMinutes % 60}m ago'
                      : 'Never',
                  style: const TextStyle(
                    color: AppColors.textLight,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildControlButton() {
    return SizedBox(
      width: double.infinity,
      height: 60,
      child: ElevatedButton.icon(
        onPressed: _isIrrigating ? _stopIrrigation : _startIrrigation,
        icon: Icon(_isIrrigating ? Icons.stop : Icons.play_arrow),
        label: Text(
          _isIrrigating ? 'STOP IRRIGATION' : 'START IRRIGATION',
          style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 16),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: _isIrrigating ? AppColors.danger : AppColors.primaryNeon,
          foregroundColor: AppColors.textDark,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
      ),
    );
  }
}

// ==================== Irrigation Logs Page ====================
class IrrigationLogsPage extends StatelessWidget {
  const IrrigationLogsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final logs = IrrigationService.getLogs();
    
    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: AppColors.mainGradient,
              ),
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                _buildHeader(context),
                Expanded(
                  child: logs.isEmpty
                      ? _buildEmptyState()
                      : ListView.builder(
                          padding: const EdgeInsets.all(20),
                          itemCount: logs.length,
                          itemBuilder: (context, index) {
                            final log = logs[logs.length - 1 - index];
                            return _buildLogCard(log);
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

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back_ios_new, color: AppColors.textLight),
            onPressed: () => Navigator.pop(context),
          ),
          const Spacer(),
          const Text(
            'Irrigation Logs',
            style: TextStyle(
              color: AppColors.textLight,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Spacer(),
          const Icon(Icons.history, color: AppColors.primaryNeon, size: 28),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.water_drop_outlined,
            size: 80,
            color: AppColors.textGrey.withValues(alpha: 0.3),
          ),
          const SizedBox(height: 20),
          const Text(
            'No irrigation logs yet',
            style: TextStyle(
              color: AppColors.textGrey,
              fontSize: 18,
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            'Start irrigating to see logs here',
            style: TextStyle(
              color: AppColors.textGrey,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLogCard(IrrigationLog log) {
    final dateFormat = DateFormat('MMM dd, yyyy • HH:mm');
    
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.cardBg.withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(25),
        border: Border.all(
          color: log.isManual
              ? AppColors.warning.withValues(alpha: 0.3)
              : AppColors.primaryNeon.withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: (log.isManual ? AppColors.warning : AppColors.primaryNeon)
                      .withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  log.isManual ? Icons.touch_app : Icons.auto_awesome,
                  color: log.isManual ? AppColors.warning : AppColors.primaryNeon,
                  size: 20,
                ),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      log.zoneId == 'zone1' ? 'Zone 1' : 'Zone 2',
                      style: const TextStyle(
                        color: AppColors.textLight,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      dateFormat.format(log.timestamp),
                      style: const TextStyle(
                        color: AppColors.textGrey,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: (log.isManual ? AppColors.warning : AppColors.primaryNeon)
                      .withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Text(
                  log.isManual ? 'MANUAL' : 'AUTO',
                  style: TextStyle(
                    color: log.isManual ? AppColors.warning : AppColors.primaryNeon,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          const Divider(color: Colors.white10, height: 1),
          const SizedBox(height: 15),
          Row(
            children: [
              Expanded(
                child: _buildLogDetail(
                  'Duration',
                  '${log.duration.inMinutes}m ${log.duration.inSeconds % 60}s',
                  Icons.timer,
                ),
              ),
              Expanded(
                child: _buildLogDetail(
                  'Temperature',
                  '${log.tempBefore.toInt()}°C',
                  Icons.thermostat,
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
          Row(
            children: [
              Expanded(
                child: _buildLogDetail(
                  'Before',
                  '${log.moistureBefore.toInt()}%',
                  Icons.water_drop_outlined,
                ),
              ),
              Expanded(
                child: _buildLogDetail(
                  'After',
                  '${log.moistureAfter.toInt()}%',
                  Icons.water_drop,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLogDetail(String label, String value, IconData icon) {
    return Row(
      children: [
        Icon(icon, color: AppColors.info, size: 16),
        const SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: const TextStyle(
                color: AppColors.textGrey,
                fontSize: 10,
              ),
            ),
            Text(
              value,
              style: const TextStyle(
                color: AppColors.textLight,
                fontSize: 13,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
