import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:techmart_admin/core/funtions/image_funtion.dart';
import 'package:techmart_admin/core/widgets/custem_snackbar.dart';
import 'package:techmart_admin/core/widgets/custem_textfield.dart';
import 'package:techmart_admin/features/brands/models/brand_model.dart';
import 'package:techmart_admin/features/brands/presentation/widgets/edit_bradn_dialog.dart';
import 'package:techmart_admin/features/brands/services/brand_service.dart';

import 'package:techmart_admin/providers/pick_image.dart';

void editBrand(BuildContext context, BrandModel brandToEdit) async {
  final TextEditingController editBrandNameController = TextEditingController(
    text: brandToEdit.name,
  );

  final imageProvider = context.read<ImageProviderModel>();
  final brandService = context.read<BrandService>();

  imageProvider.clearImage();

  brandEditDialog(
    context: context,
    oldimage: brandToEdit.imageUrl,
    controller: editBrandNameController,

    onpressed: () async {
      final newImage = imageProvider.pickedImage;
      String imageUrlToUse = brandToEdit.imageUrl;

      if (newImage != null) {
        try {
          imageUrlToUse =
              await brandService.sendImageToCloudinary(newImage) ??
              brandToEdit.imageUrl;
        } catch (e) {
          if (Navigator.canPop(context)) Navigator.pop(context);
          custemSnakbar(
            context,
            "Failed to upload new image: ${e.toString()}",
            Colors.red,
          );
          return;
        }
      }

      final updatedBrand = BrandModel(
        brandUid: brandToEdit.brandUid,
        name: editBrandNameController.text.trim(),
        imageUrl: imageUrlToUse,
      );

      try {
        await brandService.editBrand(updatedBrand, brandToEdit.imageUrl);
        if (Navigator.canPop(context)) {
          editBrandNameController.clear();
          imageProvider.clearImage();
          Navigator.pop(context);
        }
        custemSnakbar(context, "Brand updated successfully!", Colors.green);
      } catch (e) {
        if (Navigator.canPop(context))
          Navigator.pop(context); // Pop dialog on update error
        custemSnakbar(
          context,
          "Failed to update brand: ${e.toString()}",
          Colors.red,
        );
      }
    },
  );
}
