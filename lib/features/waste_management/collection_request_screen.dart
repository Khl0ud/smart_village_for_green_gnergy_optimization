import 'dart:ui';
import 'package:flutter/material.dart';
// استيراد ملف الألوان المركزي الخاص بمشروعكِ
import 'package:smart_village_for_green_gnergy_optimization/core/theme/app_colors.dart';
// استيراد كلاس Bin من ملف الداشبورد
import 'package:smart_village_for_green_gnergy_optimization/features/waste_management/waste_main.dart';

class CollectionRequestScreen extends StatefulWidget {
  final List<Bin> bins;
  const CollectionRequestScreen({super.key, required this.bins});

  @override
  State<CollectionRequestScreen> createState() =>
      _CollectionRequestScreenState();
}

class _CollectionRequestScreenState extends State<CollectionRequestScreen> {
  Bin? selected;
  DateTime? date;
  TimeOfDay? time;

  // دالة اختيار التاريخ مع ثيم نيون موحد
  Future<void> pickDate() async {
    final now = DateTime.now();
    final p = await showDatePicker(
      context: context,
      initialDate: date ?? now,
      firstDate: now,
      lastDate: DateTime(now.year + 1),
      builder: (context, child) => _buildPickerTheme(child!),
    );
    if (p != null) setState(() => date = p);
  }

  // دالة اختيار الوقت مع ثيم نيون موحد
  Future<void> pickTime() async {
    final t = await showTimePicker(
      context: context,
      initialTime: time ?? TimeOfDay.now(),
      builder: (context, child) => _buildPickerTheme(child!),
    );
    if (t != null) setState(() => time = t);
  }

  Widget _buildPickerTheme(Widget child) {
    return Theme(
      data: Theme.of(context).copyWith(
        colorScheme: const ColorScheme.dark(
          primary: AppColors.primaryNeon,
          onPrimary: AppColors.textDark,
          surface: AppColors.cardBg,
          onSurface: AppColors.textLight,
        ),
      ),
      child: child,
    );
  }

  void sendRequest() {
    if (selected == null || date == null || time == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill all fields'),
          backgroundColor: AppColors.danger,
        ),
      );
      return;
    }
    _showConfirmationDialog();
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
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  IconButton(
                    icon: const Icon(
                      Icons.arrow_back_ios_new_rounded,
                      color: AppColors.textLight,
                      size: 22,
                    ),
                    onPressed: () => Navigator.pop(context),
                  ),
                  const SizedBox(height: 20),
                  _buildHeader(),
                  const SizedBox(height: 30),
                  _buildFormCard(), // بطاقة النموذج الزجاجية
                  const SizedBox(height: 40),
                  _buildSubmitButton(),
                  const SizedBox(height: 50),
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

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        Text(
          'Scheduling',
          style: TextStyle(
            color: AppColors.primaryNeon,
            fontSize: 14,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.5,
          ),
        ),
        Text(
          'Collection Request', // مطابق لعنوان صورتك
          style: TextStyle(
            color: AppColors.textLight,
            fontSize: 28,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildFormCard() {
    return Container(
      padding: const EdgeInsets.all(25),
      decoration: BoxDecoration(
        color: AppColors.cardBg.withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildLabel('TARGET BIN'),
          const SizedBox(height: 12),
          _buildDropdown(),
          const SizedBox(height: 30),
          _buildLabel('PICKUP SCHEDULE'),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildPickerBox(
                  icon: Icons.calendar_month_rounded,
                  text: date == null
                      ? 'Select Date'
                      : date!.toLocal().toString().split(' ')[0],
                  onTap: pickDate,
                ),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: _buildPickerBox(
                  icon: Icons.access_time_filled_rounded,
                  text: time == null ? 'Select Time' : time!.format(context),
                  onTap: pickTime,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDropdown() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(18),
      ),
      child: DropdownButtonFormField<Bin>(
        initialValue: selected,
        dropdownColor: AppColors.cardBg,
        icon: const Icon(
          Icons.keyboard_arrow_down_rounded,
          color: AppColors.primaryNeon,
        ),
        style: const TextStyle(color: AppColors.textLight, fontSize: 15),
        decoration: const InputDecoration(border: InputBorder.none),
        hint: const Text(
          'Choose a Bin',
          style: TextStyle(color: AppColors.textDisabled, fontSize: 14),
        ),
        items: widget.bins
            .map(
              (b) => DropdownMenuItem(
                value: b,
                child: Text('${b.id} • ${b.location}'),
              ),
            )
            .toList(),
        onChanged: (v) => setState(() => selected = v),
      ),
    );
  }

  Widget _buildPickerBox({
    required IconData icon,
    required String text,
    required VoidCallback onTap,
  }) {
    bool isSet = !text.contains('Select');
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 12),
        decoration: BoxDecoration(
          color: Colors.black.withValues(alpha: 0.2),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: isSet
                ? AppColors.primaryNeon.withValues(alpha: 0.2)
                : Colors.white.withValues(alpha: 0.03),
          ),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: isSet ? AppColors.primaryNeon : AppColors.textGrey,
              size: 18,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                text,
                style: TextStyle(
                  color: isSet ? AppColors.textLight : AppColors.textDisabled,
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSubmitButton() {
    return SizedBox(
      width: double.infinity,
      height: 65,
      child: ElevatedButton.icon(
        onPressed: sendRequest,
        icon: const Icon(Icons.send_rounded, size: 20),
        label: const Text(
          'CONFIRM SCHEDULE',
          style: TextStyle(fontWeight: FontWeight.w900, letterSpacing: 1.2),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryNeon,
          foregroundColor: AppColors.textDark,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          elevation: 0,
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Text(
      text,
      style: const TextStyle(
        color: AppColors.textGrey,
        fontSize: 11,
        fontWeight: FontWeight.w800,
        letterSpacing: 1.2,
      ),
    );
  }

  void _showConfirmationDialog() {
    showDialog(
      context: context,
      builder: (context) => BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
        child: AlertDialog(
          backgroundColor: AppColors.cardBg,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          title: const Text(
            'Confirm Schedule',
            style: TextStyle(
              color: AppColors.textLight,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Text(
            'Schedule pickup for ${selected!.id}?',
            style: const TextStyle(color: AppColors.textGrey),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text(
                'CANCEL',
                style: TextStyle(color: AppColors.danger),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(this.context).showSnackBar(
                  const SnackBar(content: Text('Request Sent! ✅')),
                );
              },
              child: const Text(
                'CONFIRM',
                style: TextStyle(color: AppColors.primaryNeon),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
