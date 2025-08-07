import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:techmart_admin/core/widgets/custem_snackbar.dart';
import 'package:techmart_admin/features/coupons/presentation/widget/edit_coupen_widget.dart';
import 'package:techmart_admin/features/coupons/service/coupon_service.dart';

class CouponsWidget extends StatelessWidget {
  CouponsWidget({super.key});
  final dateFormat = DateFormat('dd MMM yyyy');

  @override
  Widget build(BuildContext context) {
    final coupon = context.read<CouponService>();

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: StreamBuilder(
          stream: coupon.fetchCoupens(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: CircularProgressIndicator(),
                ),
              );
            }

            if (snapshot.hasError) {
              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  "Error: ${snapshot.error}",
                  style: TextStyle(color: Colors.red),
                ),
              );
            }

            final coupens = snapshot.data;

            if (coupens == null || coupens.isEmpty) {
              return Padding(
                padding: const EdgeInsets.all(24.0),
                child: Text(
                  "No coupons added yet.",
                  style: TextStyle(fontSize: 30),
                ),
              );
            }

            return DataTable(
              columnSpacing: 20,

              columns: const [
                DataColumn(
                  label: Text(
                    "Name",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                DataColumn(
                  label: Text(
                    "Start Date",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                DataColumn(
                  label: Text(
                    "End Date",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                DataColumn(
                  label: Text(
                    "Offer Price",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                DataColumn(
                  label: Text(
                    "Minimum Price",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                DataColumn(
                  label: Text(
                    "Status",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                DataColumn(
                  label: Text(
                    "Actions",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
              rows:
                  coupens.map((element) {
                    return DataRow(
                      cells: [
                        DataCell(Text(element.coupenName.toUpperCase())),
                        DataCell(Text(dateFormat.format(element.startTime))),
                        DataCell(Text(dateFormat.format(element.endTime))),
                        DataCell(Text("₹ ${element.dicountPrice}")),
                        DataCell(Text("₹ ${element.minPrice}")),
                        DataCell(
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color:
                                  element.isLive
                                      ? Colors.green.shade100
                                      : Colors.red.shade100,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              element.isLive ? "Active" : "Inactive",
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color:
                                    element.isLive
                                        ? Colors.green.shade800
                                        : Colors.red.shade800,
                              ),
                            ),
                          ),
                        ),
                        DataCell(
                          Row(
                            children: [
                              IconButton(
                                icon: Icon(Icons.edit, color: Colors.blue),
                                tooltip: 'Edit Coupon',
                                onPressed: () async {
                                  await showUpdateCouponDialog(
                                    context,
                                    element,
                                  );
                                },
                              ),
                              IconButton(
                                icon: Icon(
                                  element.isLive
                                      ? Icons.visibility_off
                                      : Icons.visibility,
                                  color:
                                      element.isLive
                                          ? Colors.orange
                                          : Colors.green,
                                ),
                                tooltip: element.isLive ? 'Unlist' : 'List',
                                onPressed: () {
                                  context.read<CouponService>().unListCoupen(
                                    element.id!,
                                    element.isLive,
                                  );
                                },
                              ),
                              IconButton(
                                icon: Icon(Icons.delete, color: Colors.red),
                                tooltip: 'Delete Coupon',
                                onPressed: () async {
                                  await context
                                      .read<CouponService>()
                                      .deleteCoupons(element.id!);
                                  custemSnakbar(
                                    context,
                                    "Deleted successfully",
                                    Colors.red,
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  }).toList(),
            );
          },
        ),
      ),
    );
  }
}
