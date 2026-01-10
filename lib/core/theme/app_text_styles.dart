import 'package:flutter/material.dart';
import 'app_colors.dart';

/// Defines the text styles used throughout the application.
///
/// Contains pre-configured [TextStyle] constants for headings, body text,
/// buttons, and captions to ensure consistent typography.
class AppTextStyles {
  // ============ Heading Styles ============

  /// Extra large heading style (32px, bold).
  /// Used for main page titles.
  static const TextStyle h1 = TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.bold,
    height: 1.2,
    color: AppColors.textPrimary,
  );

  /// Large heading style (24px, bold).
  /// Used for section headers.
  static const TextStyle h2 = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    height: 1.3,
    color: AppColors.textPrimary,
  );

  /// Medium heading style (20px, semi-bold).
  /// Used for subsection headers.
  static const TextStyle h3 = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    height: 1.4,
    color: AppColors.textPrimary,
  );

  /// Small heading style (18px, semi-bold).
  /// Used for card titles and list headers.
  static const TextStyle h4 = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    height: 1.4,
    color: AppColors.textPrimary,
  );

  // ============ Body Styles ============

  /// Large body text style (16px).
  /// Used for primary content and paragraphs.
  static const TextStyle bodyLarge = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.normal,
    height: 1.5,
    color: AppColors.textPrimary,
  );

  /// Medium body text style (14px).
  /// Used for secondary content and descriptions.
  static const TextStyle bodyMedium = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.normal,
    height: 1.5,
    color: AppColors.textPrimary,
  );

  /// Small body text style (12px).
  /// Used for supporting text and metadata.
  static const TextStyle bodySmall = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.normal,
    height: 1.5,
    color: AppColors.textSecondary,
  );

  // ============ Button Style ============

  /// Button text style (16px, semi-bold).
  /// Used for all button labels.
  static const TextStyle button = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    height: 1.2,
  );

  // ============ Caption Style ============

  /// Caption text style (12px).
  /// Used for timestamps, labels, and helper text.
  static const TextStyle caption = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.normal,
    height: 1.3,
    color: AppColors.textSecondary,
  );
}
