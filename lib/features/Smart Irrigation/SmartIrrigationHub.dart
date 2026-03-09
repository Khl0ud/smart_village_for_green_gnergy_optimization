import 'package:flutter/material.dart';
import 'package:smart_village_for_green_gnergy_optimization/core/theme/app_colors.dart';

// استيراد كافة الملفات المطلوبة للربط
import 'AlertsScreen.dart';
import 'SettingsScreen.dart';
import 'WeatherScreen.dart';
import 'irrigation_models.dart';
import 'irrigation_service.dart';
import 'irrigation_pages.dart';

class SmartIrrigationHub extends StatefulWidget {
  const SmartIrrigationHub({super.key});

  @override
  State<SmartIrrigationHub> createState() => _SmartIrrigationHubState();
}

class _SmartIrrigationHubState extends State<SmartIrrigationHub> {
  // متغيرات حالة النظام
  double temp = 23.0;
  double humidity = 35.0;
  int waterLevel = 43;
  bool isPumpOn = false;
  bool gardenLight = false;
  bool emergencyStop = false;
  bool isRaining = false;
  
  // الزونات
  IrrigationZone zone1 = IrrigationZone(
    id: 'zone1',
    name: 'Zone 1',
    soilMoisture: 55.0,
    valveOpen: false,
  );
  
  IrrigationZone zone2 = IrrigationZone(
    id: 'zone2',
    name: 'Zone 2',
    soilMoisture: 48.0,
    valveOpen: false,
  );
  
  // فالف الخزان
  bool tankValveOpen = false;
  
  // نوع النبات المختار
  PlantType? selectedPlant;

  @override
  Widget build(BuildContext context) {
    final ecoScore = IrrigationService.calculateEcoScore();
    final aiRecommendation = IrrigationService.getAIRecommendation(
      moisture: (zone1.soilMoisture + zone2.soilMoisture) / 2,
      temperature: temp,
      hour: DateTime.now().hour,
      isRaining: isRaining,
    );
    
    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      body: Stack(
        children: [
          _buildGradientBackground(),
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(),
                  const SizedBox(height: 25),

                  // Emergency Stop Banner
                  if (emergencyStop)
                    _buildEmergencyBanner(),

                  // 1. نظام التنبيهات
                  if (waterLevel <= 20 || emergencyStop)
                    GestureDetector(
                      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const AlertsScreen())),
                      child: _buildAlertBanner("System Notifications (Tap to view)", AppColors.danger),
                    ),

                  const SizedBox(height: 20),

                  // Eco Score
                  _buildEcoScoreCard(ecoScore),
                  
                  const SizedBox(height: 15),

                  // AI Recommendation
                  _buildAIRecommendationCard(aiRecommendation),

                  const SizedBox(height: 20),

                  // 2. كارت الإحصائيات الرئيسية
                  _buildMainStatsGrid(),

                  const SizedBox(height: 25),
                  _buildSectionTitle("Irrigation Zones"),
                  const SizedBox(height: 15),

                  // الزونات
                  _buildZonesGrid(),

                  const SizedBox(height: 25),
                  _buildSectionTitle("System Control"),
                  const SizedBox(height: 15),

                  // 3. التحكم بالمضخة والفالفات
                  _buildControlGrid(),

                  const SizedBox(height: 30),

                  // 4. كروت التنقل للصفحات التفصيلية
                  _buildNavigationCards(),
                  const SizedBox(height: 50),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // دالة بناء كروت التنقل المربوطة فعلياً
  Widget _buildNavigationCards() {
    return Column(
      children: [
        // ربط صفحة الطقس
        _buildNavCard(
          "Weather Analysis",
          "Local garden forecast",
          Icons.cloud_queue,
          () => Navigator.push(context, MaterialPageRoute(builder: (context) => const WeatherScreen())),
        ),
        const SizedBox(height: 15),
        // ربط صفحة الإعدادات
        _buildNavCard(
          "System Settings",
          "Moisture & Thresholds",
          Icons.settings_suggest,
          () async {
            final result = await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => SettingsScreen(
                  zone1: zone1,
                  zone2: zone2,
                ),
              ),
            );
            if (result != null) {
              // تطبيق الإعدادات المرجعة
              setState(() {
                // يمكن تحديث الزونات هنا إذا لزم الأمر
              });
            }
          },
        ),
        const SizedBox(height: 15),
        // صفحة السجلات
        _buildNavCard(
          "Irrigation Logs",
          "View history & analytics",
          Icons.history,
          () => Navigator.push(context, MaterialPageRoute(builder: (context) => const IrrigationLogsPage())),
        ),
      ],
    );
  }

  // Emergency Stop Banner
  Widget _buildEmergencyBanner() {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.danger.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.danger, width: 2),
      ),
      child: Column(
        children: [
          Row(
            children: [
              const Icon(Icons.emergency, color: AppColors.danger, size: 24),
              const SizedBox(width: 12),
              const Expanded(
                child: Text(
                  "EMERGENCY STOP ACTIVATED",
                  style: TextStyle(
                    color: AppColors.danger,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                setState(() => emergencyStop = false);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('System Reset - Operations Resumed'),
                    backgroundColor: AppColors.success,
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryNeon,
                foregroundColor: AppColors.textDark,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              ),
              child: const Text('RESET SYSTEM'),
            ),
          ),
        ],
      ),
    );
  }

  // Eco Score Card
  Widget _buildEcoScoreCard(double score) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.cardBg.withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(25),
        border: Border.all(color: AppColors.primaryNeon.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.primaryNeon.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.eco, color: AppColors.primaryNeon, size: 24),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Eco Score',
                  style: TextStyle(color: AppColors.textGrey, fontSize: 12),
                ),
                Text(
                  '${score.toStringAsFixed(1)}% Water Savings',
                  style: const TextStyle(
                    color: AppColors.primaryNeon,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          Text(
            score > 0 ? '🌱' : '💧',
            style: const TextStyle(fontSize: 32),
          ),
        ],
      ),
    );
  }

  // AI Recommendation Card
  Widget _buildAIRecommendationCard(String recommendation) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.cardBg.withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(25),
        border: Border.all(color: AppColors.info.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.info.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.psychology, color: AppColors.info, size: 24),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'AI Recommendation',
                  style: TextStyle(color: AppColors.textGrey, fontSize: 12),
                ),
                const SizedBox(height: 4),
                Text(
                  recommendation,
                  style: const TextStyle(
                    color: AppColors.textLight,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Zones Grid
  Widget _buildZonesGrid() {
    return Row(
      children: [
        Expanded(
          child: _buildZoneTile(zone1),
        ),
        const SizedBox(width: 15),
        Expanded(
          child: _buildZoneTile(zone2),
        ),
      ],
    );
  }

  Widget _buildZoneTile(IrrigationZone zone) {
    return GestureDetector(
      onTap: () async {
        final result = await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ZoneControlPage(
              zone: zone,
              temperature: temp,
              isRaining: isRaining,
              waterLevel: waterLevel,
            ),
          ),
        );
        if (result != null) {
          setState(() {
            if (zone.id == 'zone1') {
              zone1 = result;
            } else {
              zone2 = result;
            }
          });
        }
      },
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppColors.cardBg.withValues(alpha: 0.4),
          borderRadius: BorderRadius.circular(25),
          border: Border.all(
            color: zone.valveOpen
                ? AppColors.primaryNeon.withValues(alpha: 0.5)
                : AppColors.cardBorder,
          ),
        ),
        child: Column(
          children: [
            Icon(
              Icons.grass,
              color: zone.valveOpen ? AppColors.primaryNeon : AppColors.textGrey,
              size: 28,
            ),
            const SizedBox(height: 10),
            Text(
              zone.name,
              style: const TextStyle(
                color: AppColors.textLight,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              '${zone.soilMoisture.toInt()}%',
              style: TextStyle(
                color: zone.valveOpen ? AppColors.primaryNeon : AppColors.textGrey,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              zone.valveOpen ? 'IRRIGATING' : 'IDLE',
              style: TextStyle(
                color: zone.valveOpen ? AppColors.primaryNeon : AppColors.textGrey,
                fontSize: 10,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // دالة التحكم بالمضخة والفالفات
  Widget _buildControlGrid() {
    return Column(
      children: [
        // صف المضخة والطوارئ
        Row(
          children: [
            Expanded(
              child: _buildControlTile(
                "Pump",
                isPumpOn && !emergencyStop,
                Icons.water_drop,
                (v) {
                  if (!emergencyStop) {
                    setState(() => isPumpOn = v);
                  }
                },
              ),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: _buildEmergencyStopTile(),
            ),
          ],
        ),
        const SizedBox(height: 15),
        // صف الإضاءة وفالف الخزان
        Row(
          children: [
            Expanded(
              child: _buildControlTile(
                "Garden Lights",
                gardenLight && !emergencyStop,
                Icons.lightbulb,
                (v) {
                  if (!emergencyStop) {
                    setState(() => gardenLight = v);
                  }
                },
              ),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: _buildControlTile(
                "Tank Valve",
                tankValveOpen && !emergencyStop,
                Icons.settings_input_component,
                (v) {
                  if (!emergencyStop) {
                    setState(() => tankValveOpen = v);
                  }
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildEmergencyStopTile() {
    return GestureDetector(
      onTap: () {
        setState(() {
          emergencyStop = !emergencyStop;
          if (emergencyStop) {
            // إيقاف كل شيء بما فيه Tank Valve
            isPumpOn = false;
            gardenLight = false;
            tankValveOpen = false; // إضافة إيقاف Tank Valve
            zone1 = IrrigationZone(
              id: zone1.id,
              name: zone1.name,
              soilMoisture: zone1.soilMoisture,
              valveOpen: false,
              lastIrrigation: zone1.lastIrrigation,
            );
            zone2 = IrrigationZone(
              id: zone2.id,
              name: zone2.name,
              soilMoisture: zone2.soilMoisture,
              valveOpen: false,
              lastIrrigation: zone2.lastIrrigation,
            );
          }
        });
        
        if (emergencyStop) {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              backgroundColor: AppColors.cardBg,
              title: const Row(
                children: [
                  Icon(Icons.warning, color: AppColors.danger),
                  SizedBox(width: 10),
                  Text('Emergency Stop', style: TextStyle(color: AppColors.textLight)),
                ],
              ),
              content: const Text(
                'All systems stopped:\n• Irrigation (Zone 1 & 2)\n• Pump\n• Tank Valve\n• Lighting',
                style: TextStyle(color: AppColors.textGrey),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('OK', style: TextStyle(color: AppColors.primaryNeon)),
                ),
              ],
            ),
          );
        }
      },
      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: emergencyStop
              ? AppColors.danger.withValues(alpha: 0.2)
              : AppColors.cardBg.withValues(alpha: 0.4),
          borderRadius: BorderRadius.circular(25),
          border: Border.all(
            color: emergencyStop
                ? AppColors.danger
                : AppColors.cardBorder,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.emergency,
              color: emergencyStop ? AppColors.danger : AppColors.textGrey,
              size: 24,
            ),
            const SizedBox(height: 8),
            Text(
              'Emergency',
              style: TextStyle(
                color: emergencyStop ? AppColors.danger : AppColors.textLight,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              emergencyStop ? 'ACTIVE' : 'STANDBY',
              style: TextStyle(
                color: emergencyStop ? AppColors.danger : AppColors.textGrey,
                fontSize: 10,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- دوائر التصميم الأساسية المسؤولة عن المظهر ---

  Widget _buildGradientBackground() => Container(decoration: const BoxDecoration(gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: AppColors.mainGradient)));

  Widget _buildHeader() => Padding(padding: const EdgeInsets.symmetric(vertical: 20), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: const [Text("Welcome Back, Loda", style: TextStyle(color: AppColors.textGrey, fontSize: 16)), Text("Garden Hub", style: TextStyle(color: AppColors.textLight, fontSize: 28, fontWeight: FontWeight.bold))]));

  Widget _buildAlertBanner(String message, Color color) => Container(margin: const EdgeInsets.only(bottom: 15), padding: const EdgeInsets.all(15), decoration: BoxDecoration(color: color.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(20), border: Border.all(color: color.withValues(alpha: 0.3))), child: Row(children: [Icon(Icons.warning_amber_rounded, color: color, size: 20), const SizedBox(width: 12), Text(message, style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 13))]));

  Widget _buildMainStatsGrid() => Row(children: [
    _buildStatTile("Temp", "${temp.toInt()}°C", Icons.thermostat, AppColors.warning),
    const SizedBox(width: 15),
    _buildStatTile("Avg Soil", "${((zone1.soilMoisture + zone2.soilMoisture) / 2).toInt()}%", Icons.grass, AppColors.primaryNeon),
    const SizedBox(width: 15),
    _buildStatTile("Water", "$waterLevel%", Icons.waves, AppColors.info)
  ]);

  Widget _buildStatTile(String label, String val, IconData icon, Color color) => Expanded(child: Container(padding: const EdgeInsets.all(15), decoration: BoxDecoration(color: AppColors.cardBg.withValues(alpha: 0.3), borderRadius: BorderRadius.circular(25), border: Border.all(color: AppColors.cardBorder)), child: Column(children: [Icon(icon, color: color, size: 22), const SizedBox(height: 10), Text(val, style: const TextStyle(color: AppColors.textLight, fontWeight: FontWeight.bold, fontSize: 18)), Text(label, style: const TextStyle(color: AppColors.textGrey, fontSize: 10))])));

  Widget _buildControlTile(String title, bool status, IconData icon, Function(bool) toggle) => Container(
    padding: const EdgeInsets.all(15),
    decoration: BoxDecoration(
      color: AppColors.cardBg.withValues(alpha: 0.4),
      borderRadius: BorderRadius.circular(25),
      border: Border.all(
        color: status
            ? AppColors.primaryNeon.withValues(alpha: 0.3)
            : AppColors.cardBorder,
      ),
    ),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, color: status ? AppColors.primaryNeon : AppColors.textGrey, size: 24),
        const SizedBox(height: 8),
        Text(
          title,
          style: const TextStyle(
            color: AppColors.textLight,
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 4),
        Switch(
          value: status,
          onChanged: toggle,
          activeTrackColor: AppColors.primaryNeon.withValues(alpha: 0.3),
          activeColor: AppColors.primaryNeon,
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
      ],
    ),
  );

  Widget _buildNavCard(String title, String subtitle, IconData icon, VoidCallback tap) => InkWell(onTap: tap, borderRadius: BorderRadius.circular(25), child: Container(padding: const EdgeInsets.all(20), decoration: BoxDecoration(color: Colors.black.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(25)), child: Row(children: [Icon(icon, color: AppColors.primaryNeon), const SizedBox(width: 20), Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(title, style: const TextStyle(color: AppColors.textLight, fontWeight: FontWeight.bold)), Text(subtitle, style: const TextStyle(color: AppColors.textGrey, fontSize: 12))]), const Spacer(), const Icon(Icons.arrow_forward_ios_rounded, color: AppColors.textGrey, size: 14)])));

  Widget _buildSectionTitle(String title) => Text(title, style: const TextStyle(color: AppColors.textLight, fontSize: 18, fontWeight: FontWeight.bold));
}