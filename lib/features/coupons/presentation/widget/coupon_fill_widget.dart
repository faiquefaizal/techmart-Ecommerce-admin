import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:techmart_admin/core/widgets/custem_snackbar.dart';
import 'package:techmart_admin/core/widgets/custem_textfield.dart';
import 'package:techmart_admin/core/widgets/show_date_dialog.dart';
import 'package:techmart_admin/features/coupons/model/coupon_model.dart';
import 'package:techmart_admin/features/coupons/service/coupon_service.dart';
import 'package:techmart_admin/providers/date_seleter.dart';

class CouponFillWidget extends StatelessWidget {
  CouponFillWidget({super.key});
  TextEditingController startDatecontroller = TextEditingController();
  TextEditingController endDatecontroller = TextEditingController();
  TextEditingController couponNameController = TextEditingController();
  TextEditingController minPriceController = TextEditingController();
  TextEditingController offerPriceController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final datedProvider = context.watch<DateSelector>();
    final validate = GlobalKey<FormState>();

    return Padding(
      padding: EdgeInsetsGeometry.all(15),
      child: Form(
        key: validate,
        child: Column(
          children: [
            CustemTextFIeld(
              label: "Coupon Name",
              hintText: "Type here",
              controller: couponNameController,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return "Coupon name is required";
                }
                return null;
              },
            ),
            CustemTextFIeld(
              label: "Start Date",
              hintText: "dd-mm-yyyy",
              controller: startDatecontroller,
              textType: TextInputType.datetime,
              ontap: () async {
                final selectedDate = await giveSelectedDate(context);
                if (selectedDate != null) {
                  datedProvider.setStartDate(selectedDate);
                  startDatecontroller.text = DateFormat.yMd().format(
                    datedProvider.startDate!,
                  );
                }
              },
            ),
            CustemTextFIeld(
              label: "End Date",
              hintText: "dd-mm-yyyy",
              controller: endDatecontroller,
              ontap: () async {
                final selectedDate = await giveSelectedDate(context);
                if (selectedDate != null) {
                  datedProvider.setEndDate(selectedDate);
                  endDatecontroller.text = DateFormat.yMd().format(
                    datedProvider.endDate!,
                  );
                }
              },
            ),
            CustemTextFIeld(
              label: "Offer Price",
              hintText: "Type here",
              controller: offerPriceController,
              textType: TextInputType.number,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return "Offer price is required";
                }
                if (int.tryParse(value) == null) {
                  return "Enter a valid number";
                }
                return null;
              },
            ),
            CustemTextFIeld(
              label: "Minimum Price",
              textType: TextInputType.number,
              hintText: "Type here",
              controller: minPriceController,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return "Offer price is required";
                }
                if (int.tryParse(value) == null) {
                  return "Enter a valid number";
                }
                return null;
              },
            ),
            SizedBox(height: 16),
            SizedBox(
              width: 500,
              height: 60,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),

                onPressed: () async {
                  if (validate.currentState!.validate()) {
                    final couponService = context.read<CouponService>();

                    final name = couponNameController.text.trim();
                    final offer = offerPriceController.text.trim();
                    final min = minPriceController.text.trim();

                    final startDate = context.read<DateSelector>().startDate;
                    final endDate = context.read<DateSelector>().endDate;

                    if (startDate == null || endDate == null) {
                      custemSnakbar(
                        context,
                        "Please select both start and end dates",
                        Colors.red,
                      );
                      return;
                    }

                    final coupon = CouponModel(
                      coupenName: name,
                      startTime: startDate,
                      endTime: endDate,
                      dicountPrice: int.tryParse(offer) ?? 0,
                      minPrice: int.tryParse(min) ?? 0,
                    );

                    try {
                      await couponService.addCoupons(coupon);
                      custemSnakbar(
                        context,
                        "Coupon Added Successfully",
                        Colors.green,
                      );
                      context.read<DateSelector>().clear();
                    } catch (e) {
                      custemSnakbar(context, e.toString(), Colors.red);
                    }
                  }
                },
                child: Text("Submit"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
