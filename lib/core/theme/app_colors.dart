import 'package:flutter/material.dart';

abstract final class AppColors {
  static const parchment = Color(0xFFEDEAE2);
  static const surface = Color(0xFFFBF9F5);
  static const ink = Color(0xFF2B2823);
  static const inkMuted = Color(0xFF8A8477);
  static const moss = Color(0xFF5F6F52);
  static const clay = Color(0xFFA8602F);

  /// A day on the heatmap with nothing kept on it.
  static const heatmapEmpty = Color(0xFFE0DDD3);

  /// The heatmap ramp, one step per ritual kept: Material green 200 through
  /// 600, written out so the map stays const.
  static const heatmapScale = <int, Color>{
    1: Color(0xFFA5D6A7), // green 200
    2: Color(0xFF81C784), // green 300
    3: Color(0xFF66BB6A), // green 400
    4: Color(0xFF4CAF50), // green 500
    5: Color(0xFF43A047), // green 600
  };
}
