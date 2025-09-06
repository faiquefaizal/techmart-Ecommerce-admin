import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:techmart_admin/core/funtions/image_funtion.dart';
import 'package:techmart_admin/features/orders/provider/order_provider.dart';

Widget buildOrderList(BuildContext context) {
  return Consumer<OrderProvider>(
    builder: (context, orderProvider, child) {
      if (orderProvider.isLoading) {
        return const Center(child: CircularProgressIndicator());
      }
      if (orderProvider.errorMessage != null) {
        return Center(child: Text(orderProvider.errorMessage!));
      }
      if (orderProvider.orders.isEmpty) {
        return const Center(child: Text('No Orders found.'));
      }

      return SizedBox(
        width: double.infinity,
        child: Card(
          elevation: 5,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minWidth: MediaQuery.of(context).size.width - (13.0 * 2),
              ),
              child: DataTable(
                columnSpacing: 20,
                columns: const [
                  DataColumn(label: Text("Order ID")),
                  DataColumn(label: Text("Customer")),
                  DataColumn(label: Text("Status")),
                  DataColumn(label: Text("Total")),
                  DataColumn(label: Text("Date")),
                ],
                rows:
                    orderProvider.orders.map((order) {
                      return DataRow(
                        cells: [
                          DataCell(
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  order.orderId,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  order.createTime.ddmmyyyy,
                                  style: const TextStyle(
                                    color: Colors.grey,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          DataCell(
                            FutureBuilder<String>(
                              future: order.fullName,
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return const SizedBox(
                                    width: 60,
                                    height: 20,
                                    child: Center(
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                      ),
                                    ),
                                  );
                                }
                                if (snapshot.hasError) {
                                  log(
                                    snapshot.data ??
                                        "no found error ${order.userId}",
                                  );
                                  return const Text("Error");
                                }
                                return Text(snapshot.data ?? "No Name");
                              },
                            ),
                          ),
                          DataCell(Text(order.status)),
                          DataCell(Text('\$${order.total.toStringAsFixed(2)}')),
                          DataCell(Text(order.createTime.ddmmyyyy)),
                        ],
                      );
                    }).toList(),
              ),
            ),
          ),
        ),
      );
    },
  );
}
