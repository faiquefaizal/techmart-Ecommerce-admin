import 'package:flutter/material.dart';
import 'package:techmart_admin/features/dashboard/presentation/widgets/daily_sales_chart.dart';

class SalesOverviewChartCard extends StatelessWidget {
  const SalesOverviewChartCard({super.key});

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    return Card(
      // The main card that holds the chart and its header
      color:
          colorScheme
              .surface, // Use your theme's surface color (dark card background)
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(
          16.0,
        ), // Padding around the content inside the card
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Section: Title and Dropdown (or placeholder)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Sales Overview", // Main title for the chart section
                  style: textTheme.titleLarge, // Your custom title style
                ),
                // Placeholder for a dropdown or filter button
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: colorScheme.primary.withOpacity(
                      0.1,
                    ), // Light accent background
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Text(
                    "Last 7 Days", // Could be a dropdown value
                    style: textTheme.bodySmall?.copyWith(
                      color: colorScheme.primary,
                    ),
                  ),
                ),
                // If you want a real dropdown, you'd use a DropdownButton here
                // DropdownButton<String>(
                //   value: 'Last 7 Days', // Example selected value
                //   onChanged: (String? newValue) {
                //     // Handle time range change
                //   },
                //   items: <String>['Last 7 Days', 'Last 30 Days', 'Last 90 Days']
                //       .map<DropdownMenuItem<String>>((String value) {
                //         return DropdownMenuItem<String>(
                //           value: value,
                //           child: Text(value),
                //         );
                //   }).toList(),
                // ),
              ],
            ),

            const SizedBox(height: 16.0), // Space between header and chart
            // The actual chart widget
            const DailySalesChart(), // This widget already handles its own StreamBuilder
          ],
        ),
      ),
    );
  }
}
