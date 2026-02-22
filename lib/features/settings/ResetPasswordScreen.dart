import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:ui';
// استيراد ملف الألوان المركزي من مجلد core
import 'package:smart_village_for_green_gnergy_optimization/core/theme/app_colors.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  int _step = 1;
  final TextEditingController _emailPhoneController = TextEditingController();
  final TextEditingController _codeController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      body: Stack(
        children: [
          // الدوائر الخلفية الموحدة للمشروع
          _buildBackgroundDecorations(),

          SafeArea(
            child: Column(
              children: [
                _buildHeader(context),
                Expanded(
                  child: Center(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(horizontal: 24.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _buildIconHeader(),
                          const SizedBox(height: 20),
                          Text(
                            "Account Recovery",
                            style: GoogleFonts.comfortaa(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 35),

                          // حاوية الخطوات بتصميم Glassmorphism
                          _buildGlassContainer(),
                        ],
                      ),
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

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Align(
        alignment: Alignment.centerLeft,
        child: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Colors.white,
            size: 22,
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
    );
  }

  Widget _buildIconHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.cardBg.withOpacity(0.5),
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: const Icon(
        Icons.lock_reset_rounded,
        color: AppColors.primaryNeon,
        size: 40,
      ),
    );
  }

  Widget _buildGlassContainer() {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 400),
      padding: const EdgeInsets.all(25),
      decoration: BoxDecoration(
        color: AppColors.cardBg.withOpacity(0.3),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: _buildStepContent(),
    );
  }

  Widget _buildStepContent() {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 500),
      child: Column(
        key: ValueKey<int>(_step),
        mainAxisSize: MainAxisSize.min,
        children: [
          if (_step == 1) ...[
            _buildInstructionText(
              "Enter your email or phone to receive a reset code",
            ),
            const SizedBox(height: 20),
            _buildField(
              "Contact Info",
              _emailPhoneController,
              Icons.alternate_email_rounded,
            ),
            const SizedBox(height: 25),
            _buildActionButton("SEND CODE", () => setState(() => _step = 2)),
          ] else if (_step == 2) ...[
            _buildInstructionText(
              "Verify the 4-digit code sent to your device",
            ),
            const SizedBox(height: 20),
            _buildField(
              "Verification Code",
              _codeController,
              Icons.vibration_rounded,
            ),
            const SizedBox(height: 25),
            _buildActionButton("VERIFY", () => setState(() => _step = 3)),
          ] else if (_step == 3) ...[
            _buildInstructionText(
              "Ensure your new password is strong and secure",
            ),
            const SizedBox(height: 20),
            _buildField(
              "New Password",
              _newPasswordController,
              Icons.lock_outline_rounded,
              obscure: true,
            ),
            const SizedBox(height: 15),
            _buildField(
              "Confirm Password",
              _confirmPasswordController,
              Icons.lock_person_rounded,
              obscure: true,
            ),
            const SizedBox(height: 25),
            _buildActionButton("SAVE PASSWORD", () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Password updated successfully!'),
                  backgroundColor: AppColors.cardBg,
                ),
              );
              Navigator.pop(context);
            }),
          ],
        ],
      ),
    );
  }

  Widget _buildInstructionText(String text) {
    return Text(
      text,
      textAlign: TextAlign.center,
      style: const TextStyle(
        color: AppColors.textGrey,
        fontSize: 13,
        height: 1.5,
      ),
    );
  }

  Widget _buildField(
    String hint,
    TextEditingController controller,
    IconData icon, {
    bool obscure = false,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.2),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.white.withOpacity(0.02)),
      ),
      child: TextField(
        controller: controller,
        obscureText: obscure,
        style: const TextStyle(color: Colors.white, fontSize: 15),
        decoration: InputDecoration(
          prefixIcon: Icon(icon, color: AppColors.primaryNeon, size: 20),
          hintText: hint,
          hintStyle: const TextStyle(color: Colors.white10, fontSize: 14),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 18),
        ),
      ),
    );
  }

  Widget _buildActionButton(String label, VoidCallback onTap) {
    return Container(
      width: double.infinity,
      height: 55,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30), // Stadium Shape
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryNeon.withOpacity(0.15),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryNeon,
          foregroundColor: AppColors.textDark,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          elevation: 0,
        ),
        child: Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.w900,
            letterSpacing: 1.2,
          ),
        ),
      ),
    );
  }

  Widget _buildBackgroundDecorations() {
    return Stack(
      children: [
        Positioned(
          top: -100,
          left: -100,
          child: Container(
            width: 300,
            height: 300,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.primaryNeon.withOpacity(0.03),
            ),
          ),
        ),
      ],
    );
  }
}
