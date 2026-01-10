import 'package:flutter/material.dart';

/// Defines the color palette used throughout the application.
///
/// Contains color constants for primary, secondary, neutral, text,
/// and dark mode variants to ensure consistent theming.
class AppColors {
  // ============ Primary Colors ============

  /// Main primary color (Indigo).
  static const Color primary = Color(0xFF6366F1);

  /// Darker shade of primary for pressed states.
  static const Color primaryDark = Color(0xFF4F46E5);

  /// Lighter shade of primary for hover states and highlights.
  static const Color primaryLight = Color(0xFF818CF8);

  // ============ Secondary Colors ============

  /// Main secondary/accent color (Pink).
  static const Color secondary = Color(0xFFEC4899);

  /// Darker shade of secondary for pressed states.
  static const Color secondaryDark = Color(0xFFDB2777);

  /// Lighter shade of secondary for hover states and highlights.
  static const Color secondaryLight = Color(0xFFF472B6);

  // ============ Neutral Colors ============

  /// Main background color for light mode.
  static const Color background = Color(0xFFFAFAFA);

  /// Surface color for cards and elevated elements.
  static const Color surface = Color(0xFFFFFFFF);

  /// Error state color (Red).
  static const Color error = Color(0xFFEF4444);

  /// Success state color (Green).
  static const Color success = Color(0xFF10B981);

  /// Warning state color (Amber).
  static const Color warning = Color(0xFFF59E0B);

  // ============ Text Colors ============

  /// Primary text color for headings and important content.
  static const Color textPrimary = Color(0xFF111827);

  /// Secondary text color for less emphasized content.
  static const Color textSecondary = Color(0xFF6B7280);

  /// Disabled text color for inactive elements.
  static const Color textDisabled = Color(0xFF9CA3AF);

  // ============ Border Colors ============

  /// Standard border color for inputs and cards.
  static const Color border = Color(0xFFE5E7EB);

  /// Divider color for separating content sections.
  static const Color divider = Color(0xFFF3F4F6);

  // ============ Dark Mode Colors ============

  /// Background color for dark mode.
  static const Color backgroundDark = Color(0xFF111827);

  /// Surface color for dark mode.
  static const Color surfaceDark = Color(0xFF1F2937);

  /// Primary text color for dark mode.
  static const Color textPrimaryDark = Color(0xFFF9FAFB);

  /// Secondary text color for dark mode.
  static const Color textSecondaryDark = Color(0xFFD1D5DB);
}
