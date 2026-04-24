import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
// استيراد ملف الألوان المركزي
import 'package:smart_village_for_green_gnergy_optimization/core/theme/app_colors.dart'; 

import 'package:flutter_bloc/flutter_bloc.dart';
import 'logic/auth_bloc/auth_bloc.dart';
import 'logic/auth_bloc/auth_event.dart';
import 'logic/auth_bloc/auth_state.dart';
import 'MainShell.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  bool _obscurePassword = true;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state.status == AuthStatus.success) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.response?.message ?? 'Account Created!'),
              backgroundColor: Colors.green,
            ),
          );
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const MainShell()),
            (route) => false,
          );
        } else if (state.status == AuthStatus.failure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.errorMessage ?? 'Registration Failed'),
              backgroundColor: Colors.redAccent,
            ),
          );
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.scaffoldBg, // استخدام اللون الموحد من Core
        body: Stack(
          children: [
            // الدوائر الديكورية بتأثير نيون خافت
            Positioned(
              top: -50,
              right: -10,
              child: Container(
                width: 180,
                height: 180,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.primaryNeon.withOpacity(0.05),
                ),
              ),
            ),

            SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 20),
                      // زر الرجوع الموحد
                      IconButton(
                        icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 20),
                        onPressed: () => Navigator.pop(context),
                      ),
                      const SizedBox(height: 10),

                      Text(
                        'Create Account',
                        style: GoogleFonts.comfortaa(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textLight,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Join our smart community today',
                        style: GoogleFonts.poppins(fontSize: 15, color: AppColors.textGrey),
                      ),
                      const SizedBox(height: 35),

                      // حقول الإدخال باستخدام الـ AppColors الموحدة
                      _buildInputField(
                        label: 'Full Name',
                        icon: Icons.person_outline_rounded,
                        controller: _nameController,
                      ),
                      const SizedBox(height: 20),
                      _buildInputField(
                        label: 'Email Address',
                        icon: Icons.alternate_email_rounded,
                        controller: _emailController,
                      ),
                      const SizedBox(height: 20),
                      _buildInputField(
                        label: 'Password',
                        icon: Icons.lock_open_rounded,
                        isPassword: true,
                        controller: _passwordController,
                      ),

                      const SizedBox(height: 40),

                      // زر التسجيل بتصميم Stadium Shape وتوهج نيون
                      _buildSignUpButton(),

                      const SizedBox(height: 30),

                      // رابط العودة للوجين
                      _buildSignInLink(),
                      const SizedBox(height: 30),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // زرار الـ Sign Up المربوط بالـ Bloc
  Widget _buildSignUpButton() {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        return Container(
          width: double.infinity,
          height: 55,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30), // Stadium Shape
            boxShadow: [
              BoxShadow(
                color: AppColors.primaryNeon.withOpacity(0.2),
                blurRadius: 15,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: ElevatedButton(
            onPressed: state.status == AuthStatus.loading
                ? null
                : () {
                    // لم البيانات من الحقول
                    final name = _nameController.text.trim();
                    final email = _emailController.text.trim();
                    final password = _passwordController.text.trim();

                    // تشيك سريع لو في حاجة ناقصة
                    if (name.isEmpty || email.isEmpty || password.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('لازم تملى كل البيانات يا بطل')),
                      );
                      return;
                    }

                    // ابعت للـ Bloc يعمل حسابه
                    context.read<AuthBloc>().add(
                          RegisterSubmitted(
                            email: email,
                            password: password,
                            fullName: name,
                          ),
                        );
                  },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryNeon,
              foregroundColor: Colors.black,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
              elevation: 0,
              disabledBackgroundColor: AppColors.primaryNeon.withOpacity(0.6),
            ),
            child: state.status == AuthStatus.loading
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      color: Colors.black,
                      strokeWidth: 2,
                    ),
                  )
                : const Text(
                    'SIGN UP',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900, letterSpacing: 1.2),
                  ),
          ),
        );
      },
    );
  }

  Widget _buildSignInLink() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text("Already have an account? ", style: TextStyle(color: AppColors.textGrey)),
        GestureDetector(
          onTap: () => Navigator.pop(context),
          child: const Text(
            "Sign In",
            style: TextStyle(color: AppColors.primaryNeon, fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }

  Widget _buildInputField({
    required String label,
    required IconData icon,
    required TextEditingController controller,
    bool isPassword = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 8),
          child: Text(
            label.toUpperCase(),
            style: const TextStyle(color: AppColors.textGrey, fontSize: 10, fontWeight: FontWeight.w800, letterSpacing: 1.1),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: AppColors.cardBg.withOpacity(0.5), // تأثير Glassmorphism
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: AppColors.cardBorder),
          ),
          child: TextField(
            controller: controller,
            obscureText: isPassword && _obscurePassword,
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              prefixIcon: Icon(icon, color: AppColors.primaryNeon, size: 20),
              suffixIcon: isPassword
                  ? IconButton(
                      icon: Icon(_obscurePassword ? Icons.visibility_off_rounded : Icons.visibility_rounded, 
                      color: AppColors.textGrey, size: 20),
                      onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                    )
                  : null,
              hintText: 'Enter your ${label.toLowerCase()}',
              hintStyle: const TextStyle(color: Colors.white10, fontSize: 14),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(vertical: 16),
            ),
          ),
        ),
      ],
    );
  }
}
