import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:techmart_admin/core/funtions/image_funtion.dart';
import 'package:techmart_admin/core/widgets/custem_snackbar.dart';
import 'package:techmart_admin/core/widgets/custem_textfield.dart';
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

custemAddDialog({
  required BuildContext context,
  String? oldimage,
  required TextEditingController controller,
  required void Function() onpressed,
  bool varient = false,
  VoidCallback? varientOption,
}) {
  return showDialog(
    context: context,
    builder: (context) {
      final imageProvider = Provider.of<ImageProviderModel>(context);
      return Dialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        insetPadding: EdgeInsets.all(150),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                GestureDetector(
                  onTap: () async {
                    try {
                      final image = await pickImage();
                      imageProvider.setImage(image);
                    } catch (e) {
                      log(e.toString());
                    }
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.blueGrey, width: 2),
                      color: Colors.grey[200],
                    ),
                    height: 250,
                    width: 250,
                    // color: Colors.grey,
                    child:
                        imageProvider.pickedImage != null
                            ? Image.memory(
                              imageProvider.pickedImage!,
                              fit: BoxFit.cover,
                            )
                            : oldimage != null
                            ? Image.network(oldimage, fit: BoxFit.cover)
                            : Center(child: Text("Click here to add image")),
                  ),
                ),
                ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: 400),
                  child: CustemTextFIeld(
                    label: "Brand Name",
                    hintText: "Enter your Brand Name",
                    controller: controller,
                  ),
                ),

                SizedBox(height: 5),
                ElevatedButton(onPressed: onpressed, child: Text("Add Bramd")),
              ],
            ),
          ),
        ),
      );
    },
  );
}
