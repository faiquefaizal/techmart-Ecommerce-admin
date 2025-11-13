import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
// NOTE: Ensure these imports are correct for your project structure!
import 'package:techmart_admin/features/dashboard/model/sale_model.dart';
import 'package:techmart_admin/features/dashboard/service/dash_service.dart';

class DailySalesChart extends StatelessWidget {
  const DailySalesChart({super.key});

  @override
  Widget build(BuildContext context) {
    final Color primaryColor = Theme.of(context).colorScheme.primary;
    final Color lowEmphasisColor =
        Theme.of(context).textTheme.bodySmall!.color!;

    return StreamBuilder<List<DailySalesData>>(
      stream: DashService.fetchDailySalesData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const SizedBox(
            height: 200,
            child: Center(child: CircularProgressIndicator.adaptive()),
          );
        }

        final List<DailySalesData> chartData = snapshot.data ?? [];

        if (snapshot.hasError || chartData.isEmpty) {
          return const SizedBox(
            height: 200,
            child: Center(
              child: Text(
                "No sales data available for chart.",
                style: TextStyle(color: Colors.white70),
              ),
            ),
          );
        }

        // --- CHART CONFIGURATION STARTS HERE ---
        final List<FlSpot> spots = List.generate(
          chartData.length,
          (index) => FlSpot(index.toDouble(), chartData[index].sales),
        );

        final double maxSales = spots.map((spot) => spot.y).reduce(math.max);
        final double maxY = (maxSales > 0 ? maxSales : 1000) * 1.1;

        final LineChartData lineChartData = LineChartData(
          minX: 0,
          maxX: (chartData.length - 1).toDouble(),
          minY: 0,
          maxY: maxY,

          gridData: FlGridData(
            show: true,
            drawVerticalLine: false,
            getDrawingHorizontalLine: (value) {
              return FlLine(
                color: lowEmphasisColor.withOpacity(0.3),
                strokeWidth: 0.5,
              );
            },
          ),
          borderData: FlBorderData(
            show: true,
            border: Border(
              bottom: BorderSide(
                color: lowEmphasisColor.withOpacity(0.5),
                width: 0.5,
              ),
              left: BorderSide.none,
              right: BorderSide.none,
              top: BorderSide.none,
            ),
          ),

          titlesData: FlTitlesData(
            show: true,
            rightTitles: const AxisTitles(sideTitles: SideTitles()),
            topTitles: const AxisTitles(sideTitles: SideTitles()),

            // Bottom Axis (Day Labels)
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                reservedSize: 30,
                interval: 1,
                getTitlesWidget: (value, meta) {
                  final dayIndex = value.toInt();
                  if (dayIndex >= 0 && dayIndex < chartData.length) {
                    return SideTitleWidget(
                      axisSide: meta.axisSide,
                      space: 8.0,
                      child: Text(
                        chartData[dayIndex].day,
                        style: TextStyle(color: lowEmphasisColor, fontSize: 10),
                      ),
                    );
                  }
                  return const SizedBox();
                },
              ),
            ),

            // Left Axis (Sales Values)
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                reservedSize: 40,
                interval: maxY / 3,
                getTitlesWidget: (value, meta) {
                  if (value >= maxY) return const SizedBox();

                  String text =
                      (value >= 1000)
                          ? '${(value / 1000).toStringAsFixed(0)}k'
                          : value.toStringAsFixed(0);

                  return SideTitleWidget(
                    axisSide: meta.axisSide,
                    space: 4.0,
                    child: Text(
                      text,
                      style: TextStyle(color: lowEmphasisColor, fontSize: 10),
                    ),
                  );
                },
              ),
            ),
          ),

          // 🎯 KEY CHANGE: LINE TOUCH DATA FOR TOOLTIP
          lineTouchData: LineTouchData(
            enabled: true,
            touchTooltipData: LineTouchTooltipData(
              getTooltipItems: (List<LineBarSpot> touchedSpots) {
                return touchedSpots.map((LineBarSpot touchedSpot) {
                  final int index = touchedSpot.spotIndex;
                  final String day = chartData[index].day;
                  final double price = touchedSpot.y;
                  final String formattedPrice = '\$${price.toStringAsFixed(2)}';

                  return LineTooltipItem(
                    // Show Day at the top, Price below it
                    '$day\n$formattedPrice',
                    const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  );
                }).toList();
              },
            ),
          ),

          // --- END LINE TOUCH DATA ---
          lineBarsData: [
            LineChartBarData(
              spots: spots,
              isCurved: true,
              color: primaryColor,
              barWidth: 3,
              isStrokeCapRound: true,
              dotData: const FlDotData(show: false),
              belowBarData: BarAreaData(
                show: true,
                gradient: LinearGradient(
                  colors: [
                    primaryColor.withOpacity(0.3),
                    primaryColor.withOpacity(0.05),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
          ],
        );

        // Data is ready, build the chart
        return AspectRatio(
          aspectRatio: 2.2,
          child: Padding(
            padding: const EdgeInsets.only(
              top: 10,
              right: 24,
              bottom: 8,
              left: 10,
            ),
            child: LineChart(lineChartData),
          ),
        );
      },
    );
  }
}
