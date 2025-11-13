import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:techmart_admin/features/dashboard/service/dash_service.dart';

class OrderStatsChart extends StatelessWidget {
  const OrderStatsChart({super.key});

  @override
  Widget build(BuildContext context) {
    // Access theme colors (Purple, Green, Blue, Red)
    final Color pendingColor =
        Theme.of(context).colorScheme.secondary; // Purple: Pending
    final Color deliveredColor =
        Theme.of(context).colorScheme.primary; // Blue: Delivered
    final Color cancelledColor =
        Theme.of(context).colorScheme.error; // Red: Cancelled

    // Using a derived color for Processing (Teal/Green)
    // NOTE: If you defined tertiary, use it: Theme.of(context).colorScheme.tertiary
    final Color processingColor = const Color(
      0xFF2ECC71,
    ); // Teal/Green: Processing

    final TextTheme textTheme = Theme.of(context).textTheme;

    return Card(
      color: Theme.of(context).colorScheme.surface, // Dark Card Background
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Order Status", style: textTheme.titleLarge),
            const SizedBox(height: 16),

            StreamBuilder<Map<String, int>>(
              stream: DashService.fetchOrderStatusCounts(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const SizedBox(
                    height: 200,
                    child: Center(child: CircularProgressIndicator.adaptive()),
                  );
                }

                final Map<String, int> statusCounts = snapshot.data ?? {};
                final totalOrders = statusCounts.values.fold(
                  0,
                  (sum, count) => sum + count,
                );

                if (totalOrders == 0) {
                  return const SizedBox(
                    height: 200,
                    child: Center(
                      child: Text(
                        "No orders found.",
                        style: TextStyle(color: Colors.white70),
                      ),
                    ),
                  );
                }

                // 1. Build the Donut Chart
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: AspectRatio(
                        aspectRatio: 1,
                        child: PieChart(
                          PieChartData(
                            sectionsSpace: 2,
                            centerSpaceRadius: 60, // Creates the hole
                            startDegreeOffset: 270,
                            sections: _buildChartSections(
                              statusCounts,
                              pendingColor,
                              processingColor,
                              deliveredColor,
                              cancelledColor,
                              totalOrders,
                            ),
                          ),
                        ),
                      ),
                    ),

                    // 2. Build the Legend
                    const SizedBox(width: 24),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildLegendItem('Pending', pendingColor, textTheme),
                        _buildLegendItem(
                          'Processing',
                          processingColor,
                          textTheme,
                        ),
                        _buildLegendItem(
                          'Delivered',
                          deliveredColor,
                          textTheme,
                        ),
                        _buildLegendItem(
                          'Cancelled',
                          cancelledColor,
                          textTheme,
                        ),
                      ],
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  // --- CHART BUILDERS ---

  List<PieChartSectionData> _buildChartSections(
    Map<String, int> counts,
    Color pendingColor,
    Color processingColor,
    Color deliveredColor,
    Color cancelledColor,
    int total,
  ) {
    return [
      _buildSection(counts['Pending'] ?? 0, pendingColor, total),
      _buildSection(counts['Processing'] ?? 0, processingColor, total),
      _buildSection(counts['Delivered'] ?? 0, deliveredColor, total),
      _buildSection(counts['Cancelled'] ?? 0, cancelledColor, total),
    ];
  }

  PieChartSectionData _buildSection(int count, Color color, int total) {
    final double percentage = total > 0 ? (count / total) * 100 : 0;

    // We only show the percentage for slices larger than 5%
    final bool showTitle = percentage > 5;

    return PieChartSectionData(
      color: color,
      value: percentage,
      title: showTitle ? '${percentage.toStringAsFixed(0)}%' : '',
      radius: 25,
      titleStyle: const TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
    );
  }

  // --- LEGEND BUILDER ---

  Widget _buildLegendItem(String title, Color color, TextTheme textTheme) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 10,
            height: 10,
            decoration: BoxDecoration(shape: BoxShape.rectangle, color: color),
          ),
          const SizedBox(width: 8),
          Text(
            title,
            // Use standard text style but override color to white/white70
            style: textTheme.bodyMedium?.copyWith(color: Colors.white70),
          ),
        ],
      ),
    );
  }
}
