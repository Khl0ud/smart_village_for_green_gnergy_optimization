import 'package:flutter/material.dart';
import 'dart:ui';
// استيراد ملف الألوان المركزي لضمان الربط المعماري للمشروع
import 'package:smart_village_for_green_gnergy_optimization/core/theme/app_colors.dart';

class PaymentWalletPage extends StatefulWidget {
  // اسم المسار الموحد لضمان عمل الأزرار في الداشبورد
  static const routeName = '/PaymentWalletPage'; 
  const PaymentWalletPage({super.key});

  @override
  State<PaymentWalletPage> createState() => _PaymentWalletPageState();
}

class _PaymentWalletPageState extends State<PaymentWalletPage> {
  int _selectedTabIndex = 0;

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
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    // زيادة المسافة السفلية لمنع تداخل العناصر مع شريط التنقل
                    padding: const EdgeInsets.fromLTRB(20, 10, 20, 120), 
                    child: Column(
                      children: [
                        _buildTabToggle(primaryNeon),
                        const SizedBox(height: 35),
                        // التبديل بين محتوى الرصيد وحفظ البطاقات بناءً على التبويب المختار
                        _selectedTabIndex == 0
                            ? _buildWalletTab(primaryNeon)
                            : _buildBankCardTab(primaryNeon),
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
          colors: [AppColors.scaffoldBg, AppColors.cardBg],
        ),
      ),
    );
  }

  Widget _buildModernHeader(BuildContext context, Color accent) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 20),
            onPressed: () => Navigator.of(context).pop(),
          ),
          const Expanded(
            child: Text(
              'My Wallet',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white, letterSpacing: 1.1),
            ),
          ),
          const SizedBox(width: 40),
        ],
      ),
    );
  }

  Widget _buildTabToggle(Color accent) {
    return Container(
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: AppColors.cardBg.withOpacity(0.4),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Row(
        children: [_tabButton('Balance', 0, accent), _tabButton('Methods', 1, accent)],
      ),
    );
  }

  Widget _tabButton(String title, int index, Color accent) {
    final isSelected = _selectedTabIndex == index;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _selectedTabIndex = index),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected ? accent : Colors.transparent,
            borderRadius: BorderRadius.circular(15),
          ),
          child: Center(
            child: Text(
              title,
              style: TextStyle(
                color: isSelected ? Colors.black : AppColors.textGrey,
                fontWeight: FontWeight.w900,
                fontSize: 14,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildWalletTab(Color accent) {
    return Container(
      padding: const EdgeInsets.all(35),
      decoration: BoxDecoration(
        color: AppColors.cardBg.withOpacity(0.4),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Column(
        children: [
          Icon(Icons.account_balance_wallet_rounded, size: 80, color: accent),
          const SizedBox(height: 20),
          const Text(
            '\$250.00', // الرصيد مطابق للمحتوى المطلوب
            style: TextStyle(color: Colors.white, fontSize: 42, fontWeight: FontWeight.w900),
          ),
          const Text(
            'AVAILABLE CREDITS',
            style: TextStyle(color: AppColors.textGrey, fontSize: 12, fontWeight: FontWeight.w800, letterSpacing: 2),
          ),
          const SizedBox(height: 40),
          _buildActionButton('ADD FUNDS', Icons.add_circle_rounded, accent),
        ],
      ),
    );
  }

  Widget _buildBankCardTab(Color accent) {
    return Container(
      padding: const EdgeInsets.all(25),
      decoration: BoxDecoration(
        color: AppColors.cardBg.withOpacity(0.4),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildFormLabel('CREDIT CARD NUMBER'),
          _buildModernTextField('XXXX XXXX XXXX 4521', Icons.credit_card_rounded, accent),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildFormLabel('EXPIRY'),
                    _buildModernTextField('08/28', Icons.calendar_month_rounded, accent),
                  ],
                ),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildFormLabel('CVV'),
                    _buildModernTextField('***', Icons.lock_person_rounded, accent),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 35),
          _buildActionButton('SAVE CARD', Icons.shield_rounded, accent),
        ],
      ),
    );
  }

  Widget _buildFormLabel(String label) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 8),
      child: Text(
        label,
        style: const TextStyle(color: AppColors.textGrey, fontSize: 11, fontWeight: FontWeight.w800, letterSpacing: 1.5),
      ),
    );
  }

  Widget _buildModernTextField(String hint, IconData icon, Color accent) {
    return TextField(
      style: const TextStyle(color: Colors.white, fontSize: 14),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.white10, fontSize: 14),
        prefixIcon: Icon(icon, color: accent, size: 20),
        filled: true,
        fillColor: Colors.black.withOpacity(0.2),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(18), borderSide: BorderSide.none),
        contentPadding: const EdgeInsets.symmetric(vertical: 16),
      ),
    );
  }

  Widget _buildActionButton(String text, IconData icon, Color accent) {
    return SizedBox(
      width: double.infinity,
      height: 55,
      child: ElevatedButton.icon(
        onPressed: () {},
        style: ElevatedButton.styleFrom(
          backgroundColor: accent,
          foregroundColor: Colors.black,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        ),
        icon: Icon(icon, size: 20),
        label: Text(text, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w900)),
      ),
    );
  }
}
