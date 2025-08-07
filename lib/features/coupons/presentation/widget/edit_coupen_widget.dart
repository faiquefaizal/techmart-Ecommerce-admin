import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:techmart_admin/core/widgets/custem_snackbar.dart';
import 'package:techmart_admin/features/coupons/model/coupon_model.dart';
import 'package:techmart_admin/features/coupons/service/coupon_service.dart';

Future<void> showUpdateCouponDialog(
  BuildContext context,
  CouponModel coupon,
) async {
  final couponService = context.read<CouponService>();
  final nameController = TextEditingController(text: coupon.coupenName);
  final startDateController = TextEditingController(
    text: DateFormat.yMd().format(coupon.startTime),
  );
  final endDateController = TextEditingController(
    text: DateFormat.yMd().format(coupon.endTime),
  );
  final offerController = TextEditingController(
    text: coupon.dicountPrice.toString(),
  );
  final minController = TextEditingController(text: coupon.minPrice.toString());

  DateTime? selectedStartDate = coupon.startTime;
  DateTime? selectedEndDate = coupon.endTime;

  await showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text("Edit Coupon"),
        content: SizedBox(
          width: 400,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  decoration: InputDecoration(labelText: "Coupon Name"),
                ),
                TextField(
                  controller: startDateController,
                  decoration: InputDecoration(labelText: "Start Date"),
                  readOnly: true,
                  onTap: () async {
                    final picked = await showDatePicker(
                      context: context,
                      initialDate: selectedStartDate,
                      firstDate: DateTime(2023),
                      lastDate: DateTime(2100),
                    );
                    if (picked != null) {
                      selectedStartDate = picked;
                      startDateController.text = DateFormat.yMd().format(
                        picked,
                      );
                    }
                  },
                ),
                TextField(
                  controller: endDateController,
                  decoration: InputDecoration(labelText: "End Date"),
                  readOnly: true,
                  onTap: () async {
                    final picked = await showDatePicker(
                      context: context,
                      initialDate: selectedEndDate,
                      firstDate: DateTime(2023),
                      lastDate: DateTime(2100),
                    );
                    if (picked != null) {
                      selectedEndDate = picked;
                      endDateController.text = DateFormat.yMd().format(picked);
                    }
                  },
                ),
                TextField(
                  controller: offerController,
                  decoration: InputDecoration(labelText: "Offer Price"),
                  keyboardType: TextInputType.number,
                ),
                TextField(
                  controller: minController,
                  decoration: InputDecoration(labelText: "Minimum Price"),
                  keyboardType: TextInputType.number,
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () async {
              final updatedCoupon = coupon.copyWith(
                coupenName: nameController.text.trim(),
                startTime: selectedStartDate!,
                endTime: selectedEndDate!,
                dicountPrice: int.tryParse(offerController.text) ?? 0,
                minPrice: int.tryParse(minController.text) ?? 0,
              );

              try {
                couponService.updateCoupons(updatedCoupon);
                Navigator.pop(context);
                custemSnakbar(context, "Coupon updated", Colors.green);
              } catch (e) {
                custemSnakbar(context, e.toString(), Colors.red);
              }
            },
            child: Text("Update"),
          ),
        ],
      );
    },
  );
}
