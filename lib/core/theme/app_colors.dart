// lib/core/theme/color_palette.dart
import 'package:flutter/material.dart';

class AppColors {
  // 🌐 Primary brand colors (Blues)
  static const Color primary = Color(0xFF005AC1);       // Deep Blue
  static const Color primaryLight = Color(0xFF1B98F5);  // Bright Sky Blue
  static const Color primaryDark = Color(0xFF003D7A);   // Darker Blue

  // 🩵 Accent & Secondary
  static const Color secondary = Color(0xFFC3DAFF);     // Light Blue accent
  static const Color accent = Color(0xFF2196F3);        // Material Blue

  // 🧼 Backgrounds & surfaces
  static const Color scaffoldBg = Color(0xFFF2F6FC);    // Very light bluish gray
  static const Color cardBg = Colors.white;             // For cards/sheets/dialogs
  static const Color surface = Color(0xFFF5FAFF);       // Soft surface layer

  // 🖤 Text Colors
  static const Color textPrimary = Color(0xFF111111);   // Near black for contrast
  static const Color textSecondary = Color(0xFF4F5B62); // Muted gray-blue
  static const Color textOnPrimary = Colors.white;      // For buttons/app bars

  // 🚨 States
  static const Color error = Color(0xFFD32F2F);         // Red
  static const Color success = Color(0xFF43A047);       // Green
  static const Color warning = Color(0xFFFFA000);       // Amber

  // 🫥 Border / Divider / Hint
  static const Color border = Color(0xFFE0E0E0);
  static const Color hint = Color(0xFF9E9E9E);
}
