import 'package:flutter/material.dart';

class AppColors {
  // Main Backgrounds and Surfaces
  static const Color darkScaffoldColor = Color(
    0xFF141628,
  ); // Deep Navy/Background
  static const Color darkCardColor = Color(
    0xFF1F2134,
  ); // Card/Surface background

  // Primary Accent Color (The main blue used for active elements/lines)
  static const Color primaryBlue = Color(0xFF377DFF);

  // Status Colors (from the Order Status chart and metrics)
  static const Color successGreen = Color(
    0xFF2ECC71,
  ); // Delivered, Positive Growth
  static const Color dangerRed = Color(0xFFE74C3C); // Canceled, Negative Growth
  static const Color pendingPurple = Color(0xFFA366FF); // Pending Orders
  static const Color processingTeal = Color(
    0xFF03DAC6,
  ); // Processing (Teal/Cyan)

  // Text Colors
  static const Color highEmphasisText = Color(
    0xFFFFFFFF,
  ); // White for main values
  static const Color mediumEmphasisText = Color(
    0xFFE0E0E0,
  ); // Headers, main text
  static const Color lowEmphasisText = Color(0xFF999999); // Inactive/Hint text

  // List of colors for the Donut Chart (Order Status)
  static const List<Color> orderStatusColors = [
    pendingPurple,
    processingTeal, // Assuming processing is the second color (Green is 3rd, Red is 4th)
    successGreen,
    dangerRed,
  ];
}
