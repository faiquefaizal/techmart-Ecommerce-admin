import 'package:flutter/material.dart';
import '../widgets/sellers_table.dart';

class SellersPage extends StatelessWidget {
  const SellersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Sellers")),
      body: const Padding(padding: EdgeInsets.all(16.0), child: SellersTable()),
    );
  }
}
