import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:techmart_admin/features/orders/presentation/widgets/order_list_widgets.dart';

class AdminOrderScreen extends StatelessWidget {
  const AdminOrderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Admin Orders')),
      body: Padding(
        padding: const EdgeInsets.all(13),
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [buildOrderList(context)],
          ),
        ),
      ),
    );
  }
}
