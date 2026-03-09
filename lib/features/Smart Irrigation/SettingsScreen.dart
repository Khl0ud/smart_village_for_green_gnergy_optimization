import 'package:flutter/material.dart';
// استيراد ملف الألوان المركزي لضمان توحيد الهوية البصرية لمشروعكِ
import 'package:smart_village_for_green_gnergy_optimization/core/theme/app_colors.dart';
import 'irrigation_models.dart';

class SettingsScreen extends StatefulWidget {
  final IrrigationZone zone1;
  final IrrigationZone zone2;

  const SettingsScreen({
    super.key,
    required this.zone1,
    required this.zone2,
  });

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  // Zone 1 Settings
  PlantType? _zone1Plant;
  double _zone1MoistureThreshold = 60.0;
  
  // Zone 2 Settings
  PlantType? _zone2Plant;
  double _zone2MoistureThreshold = 60.0;

  // مفاتيح التشغيل
  bool isAutoModeOn = true;
  bool isManualIrrigationOn = false;

  @override
  void initState() {
    super.initState();
    _zone1MoistureThreshold = widget.zone1.soilMoisture;
    _zone2MoistureThreshold = widget.zone2.soilMoisture;
  }

  void _applyPlantSettings(int zoneNumber, PlantType plant) {
    setState(() {
      if (zoneNumber == 1) {
        _zone1Plant = plant;
        _zone1MoistureThreshold = plant.optimalMoisture;
      } else {
        _zone2Plant = plant;
        _zone2MoistureThreshold = plant.optimalMoisture;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      body: Stack(
        children: [
          _buildBackgroundGradient(),
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(context),
                  const SizedBox(height: 30),

                  // Zone 1 Settings
                  _buildSectionCard(
                    title: "Zone 1 Settings",
                    child: _buildZoneSettings(1, _zone1Plant, _zone1MoistureThreshold),
                  ),

                  const SizedBox(height: 25),

                  // Zone 2 Settings
                  _buildSectionCard(
                    title: "Zone 2 Settings",
                    child: _buildZoneSettings(2, _zone2Plant, _zone2MoistureThreshold),
                  ),

                  const SizedBox(height: 25),

                  // كارت مفاتيح التشغيل (Control Switches)
                  _buildSectionCard(
                    title: "System Control",
                    child: _buildSwitchSection(),
                  ),

                  const SizedBox(height: 30),
                  _buildSyncButton(),
                  const SizedBox(height: 20),
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
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: AppColors.mainGradient,
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: AppColors.textLight,
            size: 22,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        const Text(
          "Settings", // مطابق لعنوان صورتك
          style: TextStyle(
            color: AppColors.textLight,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        const Icon(
          Icons.settings_suggest_rounded,
          color: AppColors.primaryNeon,
        ),
      ],
    );
  }

  Widget _buildSectionCard({required String title, required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.cardBg.withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(25),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: AppColors.textLight,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          child,
        ],
      ),
    );
  }

  // شريط التمرير لتحديث رقم 60 في كود الـ ESP32
  Widget _buildZoneSettings(int zoneNumber, PlantType? selectedPlant, double threshold) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Plant Selection
        const Text(
          "Plant Type",
          style: TextStyle(color: AppColors.textGrey, fontSize: 12, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        _buildPlantSelector(zoneNumber, selectedPlant),
        
        const SizedBox(height: 20),
        
        // Show plant recommendations if plant is selected
        if (selectedPlant != null) ...[
          _buildPlantRecommendations(selectedPlant),
          const SizedBox(height: 20),
        ],
        
        // Moisture Threshold Slider
        const Text(
          "Moisture Threshold",
          style: TextStyle(color: AppColors.textGrey, fontSize: 12, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            activeTrackColor: AppColors.primaryNeon,
            thumbColor: AppColors.textLight,
            overlayColor: AppColors.primaryNeon.withValues(alpha: 0.2),
          ),
          child: Slider(
            value: threshold,
            min: 0,
            max: 100,
            divisions: 100,
            onChanged: (v) => setState(() {
              if (zoneNumber == 1) {
                _zone1MoistureThreshold = v;
              } else {
                _zone2MoistureThreshold = v;
              }
            }),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              "Trigger irrigation at:",
              style: TextStyle(color: AppColors.textGrey, fontSize: 12),
            ),
            Text(
              "${threshold.toInt()}% Soil Moisture",
              style: const TextStyle(
                color: AppColors.primaryNeon,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildPlantSelector(int zoneNumber, PlantType? selectedPlant) {
    return GestureDetector(
      onTap: () => _showPlantPicker(zoneNumber),
      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: AppColors.scaffoldBg.withValues(alpha: 0.5),
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: AppColors.cardBorder),
        ),
        child: Row(
          children: [
            if (selectedPlant != null) ...[
              Text(
                selectedPlant.icon,
                style: const TextStyle(fontSize: 24),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: Text(
                  selectedPlant.name,
                  style: const TextStyle(
                    color: AppColors.textLight,
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ] else ...[
              const Icon(Icons.eco, color: AppColors.textGrey, size: 24),
              const SizedBox(width: 15),
              const Expanded(
                child: Text(
                  "Select Plant Type",
                  style: TextStyle(color: AppColors.textGrey, fontSize: 15),
                ),
              ),
            ],
            const Icon(Icons.arrow_drop_down, color: AppColors.textGrey),
          ],
        ),
      ),
    );
  }

  Widget _buildPlantRecommendations(PlantType plant) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: AppColors.primaryNeon.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: AppColors.primaryNeon.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.lightbulb, color: AppColors.primaryNeon, size: 18),
              const SizedBox(width: 8),
              const Text(
                "AI Recommendations",
                style: TextStyle(
                  color: AppColors.primaryNeon,
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _buildRecommendationRow("Optimal Moisture", "${plant.optimalMoisture.toInt()}%"),
          const SizedBox(height: 8),
          _buildRecommendationRow("Optimal Temp", "${plant.optimalTemp.toInt()}°C"),
          const SizedBox(height: 8),
          _buildRecommendationRow("Best Time", plant.bestTime),
          const SizedBox(height: 8),
          _buildRecommendationRow("Frequency", "${plant.weeklyFrequency}x/week"),
          const SizedBox(height: 8),
          _buildRecommendationRow("Season", plant.season),
        ],
      ),
    );
  }

  Widget _buildRecommendationRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(color: AppColors.textGrey, fontSize: 12),
        ),
        Text(
          value,
          style: const TextStyle(
            color: AppColors.textLight,
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  void _showPlantPicker(int zoneNumber) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: AppColors.cardBg,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
          border: Border.all(color: AppColors.cardBorder),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  const Icon(Icons.eco, color: AppColors.primaryNeon),
                  const SizedBox(width: 10),
                  Text(
                    "Select Plant for Zone $zoneNumber",
                    style: const TextStyle(
                      color: AppColors.textLight,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            const Divider(color: Colors.white10, height: 1),
            Flexible(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: PlantDatabase.plants.length,
                itemBuilder: (context, index) {
                  final plant = PlantDatabase.plants[index];
                  return ListTile(
                    leading: Text(plant.icon, style: const TextStyle(fontSize: 28)),
                    title: Text(
                      plant.name,
                      style: const TextStyle(color: AppColors.textLight, fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      "${plant.optimalMoisture.toInt()}% moisture • ${plant.optimalTemp.toInt()}°C",
                      style: const TextStyle(color: AppColors.textGrey, fontSize: 12),
                    ),
                    trailing: const Icon(Icons.arrow_forward_ios, color: AppColors.textGrey, size: 16),
                    onTap: () {
                      _applyPlantSettings(zoneNumber, plant);
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('${plant.name} settings applied to Zone $zoneNumber'),
                          backgroundColor: AppColors.success,
                        ),
                      );
                    },
                  );
                },
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildSwitchSection() {
    return Column(
      children: [
        _buildCustomSwitch(
          "Auto Mode",
          isAutoModeOn,
          (v) => setState(() {
            isAutoModeOn = v;
            if (v) {
              isManualIrrigationOn = false;
            }
          }),
        ),
        const Divider(color: Colors.white10, height: 30),
        _buildCustomSwitch(
          "Manual Irrigation",
          isManualIrrigationOn,
          (v) => setState(() {
            isManualIrrigationOn = v;
            if (v) {
              isAutoModeOn = false;
            }
          }),
        ),
      ],
    );
  }

  Widget _buildCustomSwitch(String label, bool val, Function(bool) onChanged) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(color: AppColors.textLight, fontSize: 15),
        ),
        Switch(
          value: val,
          onChanged: onChanged,
          activeTrackColor: AppColors.primaryNeon.withValues(alpha: 0.3),
          thumbColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.selected)) {
              return AppColors.primaryNeon;
            }
            return AppColors.textGrey;
          }),
        ),
      ],
    );
  }

  Widget _buildSyncButton() {
    return SizedBox(
      width: double.infinity,
      height: 60,
      child: ElevatedButton.icon(
        onPressed: () {
          // هنا سيتم إرسال القيم للـ ESP32 عبر الـ API
          Navigator.pop(context, {
            'zone1': {
              'plant': _zone1Plant,
              'threshold': _zone1MoistureThreshold,
            },
            'zone2': {
              'plant': _zone2Plant,
              'threshold': _zone2MoistureThreshold,
            },
            'autoMode': isAutoModeOn,
            'manualMode': isManualIrrigationOn,
          });
          
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Settings updated successfully! 🚀"),
              backgroundColor: AppColors.success,
            ),
          );
        },
        icon: const Icon(Icons.sync_rounded),
        label: const Text(
          "SAVE & APPLY SETTINGS",
          style: TextStyle(fontWeight: FontWeight.w900),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryNeon,
          foregroundColor: AppColors.textDark,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
      ),
    );
  }
}