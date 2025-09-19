import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:techmart_admin/core/funtions/image_funtion.dart';
import 'package:techmart_admin/core/widgets/custem_snackbar.dart';
import 'package:techmart_admin/core/widgets/custem_textfield.dart';
import 'package:techmart_admin/features/brands/presentation/widgets/add_brand_dialog.dart';
import 'package:techmart_admin/features/brands/services/brand_service.dart';

import 'package:techmart_admin/providers/pick_image.dart';

void addBrand(BuildContext context) async {
  final imageProvider = context.read<ImageProviderModel>();
  final brandService = context.read<BrandService>();
  TextEditingController brandNameController = TextEditingController();
  custemAddDialog(
    context: context,
    controller: brandNameController,

    onpressed: () async {
      final image = imageProvider.pickedImage;
      final name = brandNameController.text.trim();

      if (name.isEmpty || image == null) {
        if (Navigator.canPop(context))
          Navigator.pop(context); // Pop dialog first
        custemSnakbar(
          context,
          "Please pick a photo and enter a brand name.",
          Colors.red,
        );
        return;
      }

      try {
        await brandService.addBrand(name, image);
        if (Navigator.canPop(context)) {
          brandNameController.clear();
          imageProvider.clearImage();
          Navigator.pop(context);
        }
        custemSnakbar(context, "Brand added successfully!", Colors.green);
      } catch (e) {
        if (Navigator.canPop(context))
          Navigator.pop(context); // Pop dialog on error
        custemSnakbar(
          context,
          "Failed to add brand: ${e.toString()}",
          Colors.red,
        );
      }
    },
  );
}
