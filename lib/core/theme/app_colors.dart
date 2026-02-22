import 'package:flutter/material.dart';

class AppColors {
  // ==================== الألوان الأساسية للخلفية ====================
  static const Color scaffoldBg = Color(0xFF0D1410); // الخلفية الداكنة الموحدة
  static const Color deepBg = Color(0xFF050A08); // خلفية أغمق للتفاصيل

  // ==================== ألوان النيون (الهوية التقنية) ====================
  static const Color primaryNeon = Color(0xFF00E676); // الأخضر النيون الأساسي
  static const Color accentNeon = Color(0xFF00C853); // تدرج نيون أغمق قليلًا

  // ==================== ألوان النصوص ====================
  static const Color textLight = Colors.white;
  static const Color textGrey = Colors.white38;
  static const Color textDisabled = Colors.white24;
  static const Color textDark = Color(0xFF0D1410);

  // ==================== تصميم الكروت (Glassmorphism) ====================
  static const Color cardBg = Color(0xFF1B2B23); // لون الكروت الشفاف
  static const Color cardBorder = Colors.white10; // حدود رفيعة جداً
  static const Color glassWhite = Color(0x1AFFFFFF); // شفافية زجاجية بيضاء

  // ==================== ألوان الحالات (Status) ====================
  static const Color success = Color(0xFF00E676); // متاح أو يعمل
  static const Color warning = Color(0xFFFFAB40); // تحذير أو محجوز
  static const Color danger = Color(0xFFFF5252); // خطر أو ممتلئ
  static const Color info = Color(0xFF40C4FF); // معلومات عامة

  // ==================== التدرجات اللونية (Gradients) ====================
  static const List<Color> mainGradient = [
    Color(0xFF0D1410),
    Color(0xFF1B2B23),
  ];

  static const List<Color> neonGradient = [
    Color(0xFF00E676),
    Color(0xFF00C853),
  ];

  // ==================== وظائف مساعدة (Helpers) ====================
  static Color getOpacity(Color color, double opacity) {
    return color.withValues(alpha: opacity);
  }
}
