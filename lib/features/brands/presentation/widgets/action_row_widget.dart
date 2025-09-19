import 'package:flutter/material.dart';
import 'package:techmart_admin/features/brands/models/brand_model.dart';
import 'package:techmart_admin/features/brands/presentation/widgets/delete_brand_widget.dart';
import 'package:techmart_admin/features/brands/presentation/widgets/edit_brand_widget.dart';

class ActionWidget extends StatelessWidget {
  final BrandModel brand;
  const ActionWidget({super.key, required this.brand});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        TextButton(
          onPressed: () => editBrand(context, brand),
          child: const Text("Edit"),
        ),
        TextButton(
          onPressed: () => deleteBrand(context, brand),
          child: const Text("Delete", style: TextStyle(color: Colors.red)),
        ),
      ],
    );
  }
}
