import 'package:flutter/material.dart';
import 'package:techmart_admin/core/widgets/add_dialog_widget.dart';

class CatagoryScreen extends StatelessWidget {
  TextEditingController ctagorynameController = TextEditingController();
  CatagoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(13),
        child: Column(
          children: [
            ElevatedButton(
              onPressed: () {
                custemAddDialog(context, ctagorynameController, () {});
              },
              child: Text("Add Catagory"),
            ),
          ],
        ),
      ),
    );
  }
}
