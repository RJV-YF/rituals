import 'package:flutter/material.dart';
import 'package:rituals/core/theme/app_colors.dart';

/// Fraunces for display moments, Manrope for everything read at small sizes.
abstract final class AppTypography {
  static const _display = 'Fraunces';
  static const _body = 'Manrope';

  static const pageTitle = TextStyle(
    fontFamily: _display,
    fontSize: 34,
    fontWeight: FontWeight.w700,
    color: AppColors.ink,
  );

  static const sheetTitle = TextStyle(
    fontFamily: _display,
    fontSize: 30,
    fontWeight: FontWeight.w600,
    color: AppColors.ink,
  );

  /// Small uppercase line above a title — used for the date the list belongs to.
  static const eyebrow = TextStyle(
    fontFamily: _body,
    fontSize: 11,
    fontWeight: FontWeight.w700,
    letterSpacing: 1.4,
    color: AppColors.moss,
  );

  /// Fraunces at body size, for the one-line invitation on an empty list.
  static const emptyMessage = TextStyle(
    fontFamily: _display,
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: AppColors.ink,
  );

  static const subtitle = TextStyle(
    fontFamily: _body,
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: AppColors.inkMuted,
  );

  static const taskTitle = TextStyle(
    fontFamily: _body,
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: AppColors.ink,
  );

  static const tag = TextStyle(
    fontFamily: _body,
    fontSize: 11,
    fontWeight: FontWeight.w600,
  );

  static const fieldLabel = TextStyle(
    fontFamily: _body,
    fontSize: 11,
    fontWeight: FontWeight.w700,
    letterSpacing: 1.1,
    color: AppColors.inkMuted,
  );

  static const fieldInput = TextStyle(
    fontFamily: _body,
    fontSize: 16,
    fontWeight: FontWeight.w500,
    color: AppColors.ink,
  );

  static const body = TextStyle(
    fontFamily: _body,
    fontSize: 15,
    fontWeight: FontWeight.w400,
    color: AppColors.ink,
  );

  static const toggleTitle = TextStyle(
    fontFamily: _body,
    fontSize: 15,
    fontWeight: FontWeight.w600,
    color: AppColors.ink,
  );

  static const toggleSubtitle = TextStyle(
    fontFamily: _body,
    fontSize: 12.5,
    fontWeight: FontWeight.w400,
    color: AppColors.inkMuted,
  );

  static const button = TextStyle(
    fontFamily: _body,
    fontSize: 16,
    fontWeight: FontWeight.w600,
  );

  static const textTheme = TextTheme(
    displayLarge: pageTitle,
    headlineMedium: sheetTitle,
    titleMedium: taskTitle,
    bodyMedium: body,
    bodySmall: subtitle,
    labelLarge: button,
  );
}
