import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:ui';
import 'package:smart_village_for_green_gnergy_optimization/core/theme/app_colors.dart';
import 'data/services/auth_service.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _isEditing = false;
  bool _isLoading = true;
  final AuthService _authService = AuthService();

  // تعريف المتحكمات
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController(text: "********");

  @override
  void initState() {
    super.initState();
    _fetchProfile();
  }

  Future<void> _fetchProfile() async {
    final data = await _authService.getProfile();
    if (data != null && mounted) {
      setState(() {
        // لو السيرفر بيبعت fullName بنقسمه، ولو بيبعتهم منفصلين بناخدهم
        String fullName = data['fullName'] ?? '';
        if (fullName.isNotEmpty) {
          var parts = fullName.split(' ');
          _firstNameController.text = parts.isNotEmpty ? parts[0] : '';
          _lastNameController.text = parts.length > 1 ? parts.sublist(1).join(' ') : '';
        } else {
          _firstNameController.text = data['firstName'] ?? '';
          _lastNameController.text = data['lastName'] ?? '';
        }
        
        _emailController.text = data['email'] ?? '';
        _phoneController.text = data['phoneNumber'] ?? '';
        _isLoading = false;

      });
    } else {
      setState(() => _isLoading = false);
    }
  }


  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        backgroundColor: AppColors.scaffoldBg,
        body: Center(child: CircularProgressIndicator(color: AppColors.primaryNeon)),
      );
    }

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
                  
                  // اسم المستخدم بناءً على البيانات المستلمة
                  Text(
                    "${_firstNameController.text} ${_lastNameController.text}",
                    style: GoogleFonts.poppins(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textLight,
                    ),
                  ),

                  // حقول الإدخال المنسقة
                  _buildTextField("FIRST NAME", _firstNameController),
                  _buildTextField("LAST NAME", _lastNameController),
                  _buildTextField("EMAIL ADDRESS", _emailController, isReadOnly: true),
                  _buildTextField("PHONE NUMBER", _phoneController),
                  const SizedBox(height: 15),
                  _buildChangePasswordBtn(),




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
        TextButton(
          onPressed: () => setState(() => _isEditing = !_isEditing),
          child: Text(
            _isEditing ? "Done" : "Edit",
            style: const TextStyle(color: AppColors.primaryNeon, fontWeight: FontWeight.bold),
          ),
        ),
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
          child: CircleAvatar(
            radius: 60,
            backgroundColor: AppColors.primaryNeon.withOpacity(0.1),
            child: Text(
              _firstNameController.text.isNotEmpty ? _firstNameController.text[0].toUpperCase() : '?',
              style: GoogleFonts.poppins(
                fontSize: 45,
                fontWeight: FontWeight.bold,
                color: AppColors.primaryNeon,
              ),
            ),
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

  Widget _buildChangePasswordBtn() {
    return Container(
      width: double.infinity,
      child: TextButton.icon(
        onPressed: () => _showChangePasswordDialog(context),
        icon: const Icon(Icons.lock_reset_rounded, color: AppColors.primaryNeon),
        label: const Text(
          "CHANGE PASSWORD",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, letterSpacing: 1.1),
        ),
        style: TextButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 16),
          backgroundColor: AppColors.cardBg.withOpacity(0.5),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        ),
      ),
    );
  }

  void _showChangePasswordDialog(BuildContext context) {
    final TextEditingController currentPassController = TextEditingController();
    final TextEditingController newPassController = TextEditingController();
    final TextEditingController confirmPassController = TextEditingController();
    
    bool obscureCurrent = true;
    bool obscureNew = true;
    bool obscureConfirm = true;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
          child: AlertDialog(
            backgroundColor: AppColors.cardBg,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25), 
              side: const BorderSide(color: AppColors.cardBorder),
            ),
            title: Text(
              "Change Password",
              style: GoogleFonts.poppins(color: AppColors.primaryNeon, fontWeight: FontWeight.bold),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildDialogTextField(
                  "Current Password", 
                  currentPassController, 
                  obscureCurrent,
                  onToggle: () => setDialogState(() => obscureCurrent = !obscureCurrent),
                ),
                const SizedBox(height: 15),
                _buildDialogTextField(
                  "New Password", 
                  newPassController, 
                  obscureNew,
                  onToggle: () => setDialogState(() => obscureNew = !obscureNew),
                ),
                const SizedBox(height: 15),
                _buildDialogTextField(
                  "Confirm New Password", 
                  confirmPassController, 
                  obscureConfirm,
                  onToggle: () => setDialogState(() => obscureConfirm = !obscureConfirm),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("CANCEL", style: TextStyle(color: AppColors.textGrey)),
              ),
              ElevatedButton(
                onPressed: () async {
                  if (newPassController.text != confirmPassController.text) {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Passwords don't match!")));
                    return;
                  }
                  
                  final success = await _authService.changePassword(
                    currentPassController.text,
                    newPassController.text,
                  );

                  if (mounted) {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(success ? "Password changed successfully!" : "Failed to change password"),
                        backgroundColor: success ? Colors.green : Colors.red,
                      ),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryNeon,
                  foregroundColor: Colors.black,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                ),
                child: const Text("UPDATE", style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDialogTextField(String label, TextEditingController controller, bool obscure, {VoidCallback? onToggle}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: AppColors.textGrey, fontSize: 12)),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: Colors.black26,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.cardBorder),
          ),
          child: TextField(
            controller: controller,
            obscureText: obscure,
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              suffixIcon: IconButton(
                icon: Icon(
                  obscure ? Icons.visibility_off_rounded : Icons.visibility_rounded,
                  color: AppColors.textGrey,
                  size: 18,
                ),
                onPressed: onToggle,
              ),
            ),
          ),
        ),
      ],
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
        onPressed: () async {
          setState(() => _isLoading = true);
          
          final fullName = "${_firstNameController.text} ${_lastNameController.text}";
          final success = await _authService.updateProfile(fullName, _phoneController.text);

          if (mounted) {
            setState(() {
              _isLoading = false;
              if (success) _isEditing = false;
            });

            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(success ? 'Profile updated successfully!' : 'Failed to update profile'),
                backgroundColor: success ? Colors.green : Colors.red,
              ),
            );
          }
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


  Widget _buildTextField(String label, TextEditingController controller, {bool obscure = false, bool isReadOnly = false}) {
    bool canEdit = _isEditing && !isReadOnly;
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
              color: canEdit ? Colors.black.withOpacity(0.2) : AppColors.cardBg.withOpacity(0.3),
              borderRadius: BorderRadius.circular(15),
              border: Border.all(
                color: canEdit ? AppColors.primaryNeon.withOpacity(0.3) : AppColors.cardBorder,
              ),
            ),
            child: TextFormField(
              controller: controller,
              obscureText: obscure,
              enabled: canEdit,
              style: TextStyle(color: canEdit ? Colors.white : (isReadOnly ? Colors.white24 : Colors.white38), fontSize: 15),
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

