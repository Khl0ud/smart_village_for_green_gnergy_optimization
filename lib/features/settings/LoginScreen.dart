import 'package:flutter/material.dart';
import 'dart:ui';
// استيراد ملف الألوان المركزي
import 'package:smart_village_for_green_gnergy_optimization/core/theme/app_colors.dart';
// استيراد الصفحات الأخرى للربط
import 'SignUpScreen.dart';
import 'ResetPasswordScreen.dart';
// import 'Dashboard.dart';
import 'MainShell.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _obscurePassword = true;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBg, // استخدام اللون الموحد من Core
      body: Stack(
        children: [
          // الدوائر الديكورية باستخدام ألوان الـ AppColors
          _buildBackgroundDecorations(),

          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 30),
                    _buildLogo(),
                    const SizedBox(height: 40),
                    const Text(
                      'Welcome Back',
                      style: TextStyle(
                        fontSize: 34,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textLight,
                        letterSpacing: 1.1,
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'Sign in to your smart village account',
                      style: TextStyle(fontSize: 16, color: AppColors.textGrey),
                    ),
                    const SizedBox(height: 50),

                    // حقول الإدخال المربوطة بملف الألوان
                    _buildLabel('EMAIL ADDRESS'),
                    _buildInputField(
                      controller: _emailController,
                      hint: 'your@email.com',
                      icon: Icons.alternate_email_rounded,
                    ),
                    const SizedBox(height: 25),

                    _buildLabel('PASSWORD'),
                    _buildInputField(
                      controller: _passwordController,
                      hint: '••••••••',
                      icon: Icons.lock_person_rounded,
                      isPassword: true,
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscurePassword
                              ? Icons.visibility_off_rounded
                              : Icons.visibility_rounded,
                          color: AppColors.textGrey,
                          size: 20,
                        ),
                        onPressed: () => setState(
                          () => _obscurePassword = !_obscurePassword,
                        ),
                      ),
                    ),

                    // رابط نسيت كلمة المرور
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const ResetPasswordScreen(),
                            ),
                          );
                        },
                        child: const Text(
                          'Forgot Password?',
                          style: TextStyle(
                            color: AppColors.primaryNeon,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),

                    // زر الدخول المنسق بتوهج نيون
                    _buildLoginButton(),

                    const SizedBox(height: 40),
                    _buildDivider(),
                    const SizedBox(height: 30),

                    // أيقونات التواصل الاجتماعي
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _buildSocialCircle(
                          Icons.g_mobiledata_rounded,
                          Colors.redAccent,
                        ),
                        const SizedBox(width: 25),
                        _buildSocialCircle(
                          Icons.apple_rounded,
                          AppColors.textLight,
                        ),
                        const SizedBox(width: 25),
                        _buildSocialCircle(
                          Icons.facebook_rounded,
                          Colors.blueAccent,
                        ),
                      ],
                    ),
                    const SizedBox(height: 40),

                    // رابط إنشاء حساب
                    _buildSignUpLink(),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBackgroundDecorations() {
    return Stack(
      children: [
        Positioned(
          top: -60,
          right: -60,
          child: Container(
            width: 250,
            height: 250,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.cardBg.withOpacity(0.5),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLogo() {
    return Container(
      width: 55,
      height: 55,
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: const Icon(
        Icons.flash_on_rounded,
        color: AppColors.primaryNeon,
        size: 30,
      ),
    );
  }

  Widget _buildLabel(String label) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 10),
      child: Text(
        label,
        style: const TextStyle(
          color: AppColors.textGrey,
          fontSize: 11,
          fontWeight: FontWeight.w800,
          letterSpacing: 1.2,
        ),
      ),
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    bool isPassword = false,
    Widget? suffixIcon,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.cardBg.withOpacity(0.5),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: TextField(
        controller: controller,
        obscureText: isPassword && _obscurePassword,
        style: const TextStyle(color: AppColors.textLight),
        decoration: InputDecoration(
          prefixIcon: Icon(icon, color: AppColors.primaryNeon, size: 20),
          suffixIcon: suffixIcon,
          hintText: hint,
          hintStyle: const TextStyle(color: Colors.white10, fontSize: 15),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 18),
        ),
      ),
    );
  }

  Widget _buildLoginButton() {
    return Container(
      width: double.infinity,
      height: 60,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryNeon.withOpacity(0.2),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const MainShell()),
          );
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryNeon,
          foregroundColor: AppColors.textDark,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          elevation: 0,
        ),
        child: const Text(
          'LOG IN',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w900,
            letterSpacing: 1.5,
          ),
        ),
      ),
    );
  }

  Widget _buildSocialCircle(IconData icon, Color color) {
    return Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: AppColors.cardBg,
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Icon(icon, color: color, size: 28),
    );
  }

  Widget _buildDivider() {
    return Row(
      children: const [
        Expanded(child: Divider(color: AppColors.cardBorder)),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 15),
          child: Text(
            'OR CONNECT WITH',
            style: TextStyle(
              color: AppColors.textGrey,
              fontSize: 10,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Expanded(child: Divider(color: AppColors.cardBorder)),
      ],
    );
  }

  Widget _buildSignUpLink() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          "Don't have an account? ",
          style: TextStyle(color: AppColors.textGrey),
        ),
        GestureDetector(
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const SignUpScreen()),
          ),
          child: const Text(
            "Sign Up",
            style: TextStyle(
              color: AppColors.primaryNeon,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}
