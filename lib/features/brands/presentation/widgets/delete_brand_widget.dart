import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:techmart_admin/core/widgets/custem_snackbar.dart';
import 'package:techmart_admin/features/brands/models/brand_model.dart';
import 'package:techmart_admin/features/brands/services/brand_service.dart';
import 'package:techmart_admin/features/catagories/presentation/widget/confirmation_dialog.dart';

void deleteBrand(BuildContext context, BrandModel brandToDelete) async {
  custemAlertDialog(context, () async {
    try {
      await context.read<BrandService>().deleteBrand(brandToDelete);
      if (Navigator.canPop(context)) {
        Navigator.pop(context);
      }
      custemSnakbar(context, "Brand deleted successfully!", Colors.green);
    } catch (e) {
      if (Navigator.canPop(context)) Navigator.pop(context);
      custemSnakbar(
        context,
        "Failed to delete brand: ${e.toString()}",
        Colors.red,
      );
    }
  });
}
