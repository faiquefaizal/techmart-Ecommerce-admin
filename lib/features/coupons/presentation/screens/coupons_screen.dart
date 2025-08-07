import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:techmart_admin/core/widgets/custem_textfield.dart';
import 'package:techmart_admin/features/coupons/presentation/widget/coupon_fill_widget.dart';
import 'package:techmart_admin/features/coupons/presentation/widget/coupons_widget.dart';
import 'package:techmart_admin/providers/date_seleter.dart';

class CouponsScreen extends StatelessWidget {
  CouponsScreen({super.key});
  TextEditingController controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            Text("Coupons", style: TextStyle(fontSize: 40)),
            SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadiusGeometry.circular(20),
                ),
                margin: EdgeInsets.all(20),
                elevation: 10,

                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 1,
                      child: ChangeNotifierProvider(
                        create: (context) => DateSelector(),
                        child: CouponFillWidget(),
                      ),
                    ),
                    SizedBox(width: 20),
                    Expanded(flex: 2, child: CouponsWidget()),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
