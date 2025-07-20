import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:techmart_admin/core/funtions/image_funtion.dart';
import 'package:techmart_admin/core/widgets/custem_textfield.dart';
import 'package:techmart_admin/features/catagories/presentation/widget/widget.dart';
import 'package:techmart_admin/features/catagories/providers/catagory_varient_provider.dart';
import 'package:techmart_admin/providers/pick_image.dart';

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
                    label: "Catagory Name",
                    hintText: "CatagoryName",
                    controller: controller,
                  ),
                ),
                // ElevatedButton(
                //   onPressed: () {},
                //   child: Text("Add Category varient"),
                // ),
                if (varient)
                  Column(
                    children: [
                      ConstrainedBox(
                        constraints: BoxConstraints(maxHeight: 300),
                        child: Consumer<CatagoryVarientProvider>(
                          builder: (context, varientList, child) {
                            return ListView.builder(
                              shrinkWrap: true,
                              itemCount: varientList.ctagoryVarientList.length,
                              itemBuilder: (context, index) {
                                final data =
                                    varientList.ctagoryVarientList[index];
                                return ListTile(
                                  title: Text(data.name),
                                  subtitle: Text(
                                    "Options :${data.options.join(",")}",
                                  ),
                                  trailing: Wrap(
                                    spacing: 5,
                                    children: [
                                      TextButton(
                                        onPressed:
                                            () => showEditVariantDialog(
                                              context,
                                              data.name,
                                              data.options.join(","),
                                              index,
                                            ),
                                        child: Text("Edit"),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          context
                                              .read<CatagoryVarientProvider>()
                                              .deleteCatagoryVarient(index);
                                        },
                                        child: Text("Delete"),
                                      ),
                                    ],
                                  ),
                                );
                                //  return Row(
                                //   children: [
                                //     SizedBox(width: 50),
                                //     Text(
                                //       data.name,
                                //       style: TextStyle(
                                //         color: Colors.black,
                                //         fontWeight: FontWeight.bold,
                                //       ),
                                //     ),
                                //     SizedBox(width: 20),
                                //     Text("Options :${data.options.join(",")}"),
                                //   ],
                                //);
                              },
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                SizedBox(height: 5),
                ElevatedButton.icon(
                  onPressed: varientOption,
                  label: Text("Add varients"),
                ),
                SizedBox(height: 5),
                ElevatedButton(
                  onPressed: onpressed,
                  child: Text("Add Catagory"),
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}
