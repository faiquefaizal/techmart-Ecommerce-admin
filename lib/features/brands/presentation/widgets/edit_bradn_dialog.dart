import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:techmart_admin/core/funtions/image_funtion.dart';
import 'package:techmart_admin/core/widgets/custem_textfield.dart';
import 'package:techmart_admin/providers/pick_image.dart';

Future<void> brandEditDialog({
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
                    label: "Brand",
                    hintText: "Enter you Brand",
                    controller: controller,
                  ),
                ),

                SizedBox(height: 5),
                ElevatedButton(onPressed: onpressed, child: Text("Edit Brand")),
              ],
            ),
          ),
        ),
      );
    },
  );
}
