import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_village_for_green_gnergy_optimization/core/theme/app_colors.dart';

class SolarSettingsScreen extends StatefulWidget {
  static const String routeName = '/solar_settings';
  const SolarSettingsScreen({super.key});

  @override
  State<SolarSettingsScreen> createState() => _SolarSettingsScreenState();
}

class _SolarSettingsScreenState extends State<SolarSettingsScreen> {
  String selectedUnit = "Kilowatt (KW)";
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    if (mounted) {
      setState(() {
        selectedUnit = prefs.getString('solar_unit') ?? "Kilowatt (KW)";
        _isLoading = false;
      });
    }
  }

  Future<void> _saveUnit(String unit) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('solar_unit', unit);
    if (mounted) {
      setState(() {
        selectedUnit = unit;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Preference updated to $unit'),
          backgroundColor: AppColors.primaryNeon.withValues(alpha: 0.8),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      body: Stack(
        children: [
          _buildBackgroundGradient(),
          SafeArea(
            child: _isLoading 
              ? const Center(child: CircularProgressIndicator(color: AppColors.primaryNeon))
              : Column(
                  children: [
                    _buildModernHeader(context),
                    Expanded(
                      child: SingleChildScrollView(
                        physics: const BouncingScrollPhysics(),
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 10),
                            const Text(
                              "Solar Settings",
                              style: TextStyle(color: AppColors.textLight, fontSize: 28, fontWeight: FontWeight.bold),
                            ),
                            const Text(
                              "Manage your solar energy preferences",
                              style: TextStyle(color: AppColors.textGrey, fontSize: 14),
                            ),
                            const SizedBox(height: 35),

                            _buildSettingsCard(
                              title: "Energy Unit Display",
                              icon: Icons.bolt_rounded,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.black.withValues(alpha: 0.2),
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: ExpansionTile(
                                  shape: const Border(),
                                  collapsedShape: const Border(),
                                  iconColor: AppColors.primaryNeon,
                                  collapsedIconColor: AppColors.textDisabled,
                                  title: Text(
                                    selectedUnit,
                                    style: const TextStyle(color: AppColors.textLight, fontSize: 16, fontWeight: FontWeight.w500),
                                  ),
                                  children: [
                                    _buildUnitTile("Kilowatt (KW)"),
                                    _buildUnitTile("Watt (W)"),
                                    _buildUnitTile("Megawatt (MW)"),
                                  ],
                                ),
                              ),
                            ),

                            const SizedBox(height: 25),
                            _buildSupportButton(context),
                            const SizedBox(height: 50),
                          ],
                        ),
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
          colors: AppColors.mainGradient,
        ),
      ),
    );
  }

  Widget _buildModernHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back_ios_new_rounded, color: AppColors.textLight, size: 22),
            onPressed: () => Navigator.pop(context),
          ),
          const Text(
            "Settings",
            style: TextStyle(color: AppColors.textLight, fontSize: 20, fontWeight: FontWeight.bold),
          ),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.cardBg.withValues(alpha: 0.5),
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.cardBorder),
            ),
            child: const Icon(Icons.settings_suggest_rounded, color: AppColors.primaryNeon, size: 22),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsCard({required String title, required IconData icon, required Widget child}) {
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
          Row(
            children: [
              Icon(icon, color: AppColors.primaryNeon, size: 20),
              const SizedBox(width: 10),
              Text(title, style: const TextStyle(color: AppColors.textLight, fontSize: 16, fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 20),
          child,
        ],
      ),
    );
  }

  Widget _buildUnitTile(String title) {
    bool isSelected = selectedUnit == title;
    return ListTile(
      title: Text(
        title,
        style: TextStyle(color: isSelected ? AppColors.textLight : AppColors.textDisabled, fontSize: 14),
      ),
      onTap: () => _saveUnit(title),
      trailing: isSelected ? const Icon(Icons.check_circle_rounded, color: AppColors.primaryNeon, size: 20) : null,
    );
  }

  Widget _buildSupportButton(BuildContext context) {
    return GestureDetector(
      onTap: () {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Redirecting to Solar Support Hub...'), backgroundColor: AppColors.cardBg),
        );
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 20),
        decoration: BoxDecoration(
          color: AppColors.primaryNeon.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppColors.primaryNeon.withValues(alpha: 0.1)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(Icons.contact_support_rounded, color: AppColors.primaryNeon, size: 20),
            SizedBox(width: 12),
            Text("Support Hub", style: TextStyle(color: AppColors.primaryNeon, fontWeight: FontWeight.bold, fontSize: 15)),
          ],
        ),
      ),
    );
  }
}
