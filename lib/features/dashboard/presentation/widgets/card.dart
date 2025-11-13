import 'package:flutter/material.dart';

class CustemCard extends StatelessWidget {
  const CustemCard({
    super.key,
    required this.title,
    required this.icon,
    required this.streamData,
  });

  final String title;
  final IconData icon;
  final Stream streamData;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final TextTheme textTheme = theme.textTheme;
    String count;
    return StreamBuilder(
      stream: streamData,
      builder: (context, asyncSnapshot) {
        if (asyncSnapshot.connectionState == ConnectionState.waiting) {
          count = "0";
        } else {
          count = asyncSnapshot.data.toString();
        }
        return SizedBox(
          // Set fixed dimensions based on typical dashboard card sizes
          height: 150,
          width: 310, // Slightly wider to accommodate content better
          child: Card(
            // Card color and shape are inherited from ThemeData.cardTheme
            elevation:
                0, // Dashboard cards often have no elevation in dark mode
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),

            child: Padding(
              padding: const EdgeInsets.all(
                16.0,
              ), // Increased padding for a cleaner look
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start, // Align content to the left
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // 1. Title Row (Title and Icon)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Apply titleLarge for the Card Title
                      Text(
                        title,
                        style:
                            textTheme
                                .titleSmall, // Using Light Gray, Semi-Bold, Size 16
                      ),

                      // Use the Primary/Accent color for the icon for visual pop
                      Icon(
                        icon,
                        size: 30,
                        color: theme.colorScheme.primary, // Vibrant Blue accent
                      ),
                    ],
                  ),

                  // 2. Large Metric Value (Count)
                  // Apply displayMedium for the large, bold number
                  Text(
                    count,
                    style: textTheme.displayMedium!.copyWith(
                      fontSize: 32, // Override font size to make it large
                    ),
                  ),

                  // Note: If you want to add the "+12% this month" text,
                  // you would use textTheme.bodySmall here (not included in original function signature)
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
