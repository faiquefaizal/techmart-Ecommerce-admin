import 'package:flutter/material.dart';
import 'package:techmart_admin/features/dashboard/presentation/widgets/card.dart';
import 'package:techmart_admin/features/dashboard/presentation/widgets/graph_widget.dart';
import 'package:techmart_admin/features/dashboard/presentation/widgets/status_chart.dart';
import 'package:techmart_admin/features/dashboard/service/dash_service.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            Row(
              children: [
                CustemCard(
                  title: "Active Users",
                  streamData: DashService.userCount(),

                  icon: Icons.supervised_user_circle_outlined,
                ),

                CustemCard(
                  title: "Total  Orders",
                  streamData: DashService.totalOrders(),
                  icon: Icons.shopping_bag,
                ),

                CustemCard(
                  title: "Verified Sellers",
                  streamData: DashService.activeSellerCount(),
                  icon: Icons.store,
                ),
                CustemCard(
                  title: "Unverified Sellers",
                  streamData: DashService.unActiveSellerCount(),
                  icon: Icons.block_outlined,
                ),
              ],
            ),

            const SizedBox(height: 24.0),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  height: 430,
                  width: 500,
                  child: const SalesOverviewChartCard(),
                ),
                SizedBox(width: 500, height: 430, child: OrderStatsChart()),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
