import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:ui';
// استيراد ملف الألوان المركزي من مجلد core
import 'package:smart_village_for_green_gnergy_optimization/core/theme/app_colors.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _isEditing = false;

  // تعريف المتحكمات ببياناتك الشخصية المحدثة
  final TextEditingController _firstNameController = TextEditingController(text: "Khuloud");
  final TextEditingController _lastNameController = TextEditingController(text: "Osama");
  final TextEditingController _emailController = TextEditingController(text: "khuloud.it@tech.edu");
  final TextEditingController _phoneController = TextEditingController(text: "+20 100 000 0000");
  final TextEditingController _passwordController = TextEditingController(text: "********");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBg, // استخدام اللون الموحد من Core
      body: Stack(
        children: [
          // التصميم المنحني العلوي بتأثير Glassmorphism
          _buildCurvedHeader(),

          SafeArea(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
              child: Column(
                children: [
                  _buildTopBar(context),
                  const SizedBox(height: 30),
                  _buildProfileAvatar(),
                  const SizedBox(height: 16),
                  
                  // اسم المستخدم بناءً على البيانات المحفوظة
                  Text(
                    "Khuloud Osama",
                    style: GoogleFonts.poppins(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textLight,
                    ),
                  ),
                  _buildEditToggleBtn(),
                  const SizedBox(height: 30),

                  // حقول الإدخال المنسقة
                  _buildTextField("FIRST NAME", _firstNameController),
                  _buildTextField("LAST NAME", _lastNameController),
                  _buildTextField("EMAIL ADDRESS", _emailController),
                  _buildTextField("PHONE NUMBER", _phoneController),
                  _buildTextField("PASSWORD", _passwordController, obscure: true),

                  const SizedBox(height: 40),
                  if (_isEditing) _buildSaveButton(),
                  const SizedBox(height: 120), // مساحة للناف بار
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCurvedHeader() {
    return Positioned(
      top: -160,
      left: -50,
      right: -50,
      child: Container(
        height: 380,
        decoration: BoxDecoration(
          color: AppColors.cardBg.withOpacity(0.4),
          borderRadius: const BorderRadius.vertical(bottom: Radius.circular(300)),
          border: Border.all(color: Colors.white.withOpacity(0.05)),
        ),
      ),
    );
  }

  Widget _buildTopBar(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        Text(
          'Account Settings',
          style: GoogleFonts.comfortaa(
            color: AppColors.primaryNeon,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        const SizedBox(width: 45),
      ],
    );
  }

  Widget _buildProfileAvatar() {
    return Stack(
      alignment: Alignment.bottomRight,
      children: [
        Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: AppColors.primaryNeon, width: 2),
            boxShadow: [
              BoxShadow(color: AppColors.primaryNeon.withOpacity(0.2), blurRadius: 20, spreadRadius: 2)
            ],
          ),
          child: const CircleAvatar(
            radius: 60,
            backgroundColor: AppColors.cardBg,
            backgroundImage: NetworkImage("https://cdn-icons-png.flaticon.com/512/147/147144.png"), 
          ),
        ),
        if (_isEditing)
          Container(
            padding: const EdgeInsets.all(8),
            decoration: const BoxDecoration(color: AppColors.primaryNeon, shape: BoxShape.circle),
            child: const Icon(Icons.camera_alt_rounded, size: 18, color: Colors.black),
          ),
      ],
    );
  }

  Widget _buildEditToggleBtn() {
    return TextButton.icon(
      onPressed: () => setState(() => _isEditing = !_isEditing),
      icon: Icon(_isEditing ? Icons.close_rounded : Icons.edit_rounded, size: 16, color: Colors.white54),
      label: Text(
        _isEditing ? "Cancel" : "Edit Profile",
        style: const TextStyle(color: Colors.white54, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildSaveButton() {
    return Container(
      width: double.infinity,
      height: 55,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(color: AppColors.primaryNeon.withOpacity(0.2), blurRadius: 20, offset: const Offset(0, 8)),
        ],
      ),
      child: ElevatedButton(
        onPressed: () {
          setState(() => _isEditing = false);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Profile updated successfully!'), backgroundColor: AppColors.cardBg),
          );
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryNeon,
          foregroundColor: Colors.black,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
          elevation: 0,
        ),
        child: const Text('SAVE CHANGES', style: TextStyle(fontWeight: FontWeight.w900, letterSpacing: 1.2)),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller, {bool obscure = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 8, bottom: 8),
            child: Text(
              label,
              style: const TextStyle(color: AppColors.textGrey, fontSize: 10, fontWeight: FontWeight.w800, letterSpacing: 1.2),
            ),
          ),
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            decoration: BoxDecoration(
              color: _isEditing ? Colors.black.withOpacity(0.2) : AppColors.cardBg.withOpacity(0.3),
              borderRadius: BorderRadius.circular(15),
              border: Border.all(
                color: _isEditing ? AppColors.primaryNeon.withOpacity(0.3) : AppColors.cardBorder,
              ),
            ),
            child: TextFormField(
              controller: controller,
              obscureText: obscure,
              enabled: _isEditing,
              style: TextStyle(color: _isEditing ? Colors.white : Colors.white38, fontSize: 15),
              decoration: const InputDecoration(
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
