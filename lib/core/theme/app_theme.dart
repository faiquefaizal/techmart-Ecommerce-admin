import 'package:flutter/material.dart';
import 'package:techmart_admin/core/theme/color_theme.dart';

final ThemeData appTheme = ThemeData(
  // Global settings
  brightness: Brightness.dark,
  useMaterial3: true,

  // Scaffold/Main Background
  scaffoldBackgroundColor: AppColors.darkScaffoldColor,

  // Card & Surface (The elevated background for data blocks)
  cardColor: AppColors.darkCardColor,
  canvasColor: AppColors.darkScaffoldColor, // For drawers/popups
  // ColorScheme (Maps colors to standard Material roles)
  // OLD CODE (with deprecated properties)
  /*
    // Surface & Background - These define the main background and card colors
    background: AppColors.darkScaffoldColor, // DEPRECATED - Use surface
    onBackground: AppColors.mediumEmphasisText, // DEPRECATED - Use onSurface
    surface: AppColors.darkCardColor,           // Card/Widget surfaces
    onSurface: AppColors.mediumEmphasisText,
*/

  // CORRECTED CODE (Material 3 compliant)
  colorScheme: const ColorScheme.dark(
    brightness: Brightness.dark,

    // Primary Colors (Active links, buttons)
    primary: AppColors.primaryBlue,
    onPrimary: AppColors.highEmphasisText,

    // Surface Tones
    // 'surface' is used for Cards, Dialogs, and elevated Widgets (0xFF1F2134)
    surface: AppColors.darkCardColor,
    onSurface: AppColors.mediumEmphasisText, // Text on the surface
    // 'background' (The old deprecated one) is implicitly covered by scaffoldBackgroundColor now.

    // Secondary/Tertiary (Other accent colors)
    secondary: AppColors.pendingPurple,
    onSecondary: AppColors.highEmphasisText,
    tertiary: AppColors.processingTeal,

    // Error
    error: AppColors.dangerRed,
    onError: AppColors.highEmphasisText,
  ),
  // Customize Card/Data Block Appearance
  cardTheme: CardThemeData(
    color: AppColors.darkCardColor,
    elevation: 0, // Flat look in the image
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8.0), // Slight rounding
    ),
  ),

  // Custom Text Styling
  // Custom Text Styling
  textTheme: const TextTheme(
    // 1. Large Metrics (e.g., 24,521)
    displayMedium: TextStyle(
      color: AppColors.highEmphasisText,
      fontWeight: FontWeight.bold,
      fontSize: 28,
    ),
    // 2. Card Titles (e.g., "Active Users", "Revenue Overview")
    titleLarge: TextStyle(
      color: AppColors.mediumEmphasisText,
      fontWeight: FontWeight.w600,
      fontSize: 16,
    ),

    // 3. 🎯 NEW: Table/Column Headers (Bold text, medium size)
    titleMedium: TextStyle(
      color: AppColors.highEmphasisText, // Use white for high visibility
      fontWeight: FontWeight.bold,
      fontSize: 14, // Standard size for table headers
    ),

    // 4. Small Body Text / Supporting Text (e.g., +12% this month, footnotes)
    bodySmall: TextStyle(color: AppColors.lowEmphasisText, fontSize: 12),

    // 5. Standard Body/Sidebar Menu Items
    bodyMedium: TextStyle(color: AppColors.highEmphasisText, fontSize: 14),
  ),

  // ... (Rest of ThemeData)
  // Icon Theme
  iconTheme: const IconThemeData(
    color: AppColors.lowEmphasisText, // Default icon color for sidebar/inactive
  ),

  // Customizing ListTile for the Sidebar (Active state)
  listTileTheme: ListTileThemeData(
    iconColor: AppColors.lowEmphasisText,
    textColor: AppColors.lowEmphasisText,
    selectedColor: AppColors.highEmphasisText, // White text for selected
    selectedTileColor: AppColors.primaryBlue.withOpacity(
      0.2,
    ), // Light blue highlight
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
  ),
);



































// ... (ThemeData start)

