import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:techmart_admin/features/catagories/presentation/widget/add_dialog_widget.dart';
import 'package:techmart_admin/features/catagories/presentation/widget/confirmation_dialog.dart';
import 'package:techmart_admin/features/catagories/models/category_model.dart';
import 'package:techmart_admin/features/catagories/providers/catagory_varient_provider.dart';
import 'package:techmart_admin/providers/pick_image.dart';
import 'package:techmart_admin/features/catagories/service/catagory_service.dart';

class BodyWidget extends StatelessWidget {
  TextEditingController ctagorynameController = TextEditingController();
  BodyWidget({super.key, required this.ctagorynameController});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Card(
        elevation: 5,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minWidth: MediaQuery.of(context).size.width - (13.0 * 2),
            ),
            child: StreamBuilder(
              stream: context.read<CategoryService>().fetchCatagories(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  log(snapshot.error.toString());
                  return Center(child: Text('Error: ${snapshot.error}'));
                }
                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('No Catagories found.'));
                }

                return DataTable(
                  columnSpacing: 20,
                  columns: [
                    DataColumn(label: Text("Logo")),
                    DataColumn(label: Text("Catagory Name")),
                    // DataColumn(label: Text("Variebts")),
                    DataColumn(label: Text("Actions")),
                  ],
                  rows:
                      snapshot.data!.map((value) {
                        return DataRow(
                          cells: [
                            DataCell(
                              Image.network(
                                width: 50,
                                height: 50,
                                value.imageurl,
                                // fit: BoxFit.contain,
                              ),
                            ),
                            DataCell(Text(value.name)),
                            // DataCell(value.),
                            DataCell(
                              Row(
                                children: [
                                  TextButton(
                                    onPressed: () {
                                      ctagorynameController =
                                          TextEditingController(
                                            text: value.name,
                                          );

                                      custemAddDialog(
                                        context: context,
                                        oldimage: value.imageurl,
                                        controller: ctagorynameController,

                                        onpressed: () async {
                                          final newImage =
                                              context
                                                  .read<ImageProviderModel>()
                                                  .pickedImage;
                                          final varientProvider =
                                              context
                                                  .read<
                                                    CatagoryVarientProvider
                                                  >();

                                          final updatedCatagory = CategoryModel(
                                            varientOptions:
                                                varientProvider
                                                    .ctagoryVarientList,
                                            categoryuid: value.categoryuid,
                                            imageurl:
                                                newImage != null
                                                    ? await context
                                                            .read<
                                                              CategoryService
                                                            >()
                                                            .sendImageToCloidinary(
                                                              newImage,
                                                            ) ??
                                                        value.imageurl
                                                    : value.imageurl,
                                            name: ctagorynameController.text,
                                          );
                                          context
                                              .read<CategoryService>()
                                              .editCatagory(
                                                updatedCatagory,
                                                value.imageurl,
                                              );
                                          if (Navigator.canPop(context)) {
                                            ctagorynameController.clear();
                                            context
                                                .read<ImageProviderModel>()
                                                .clearImage();
                                            Navigator.pop(context);
                                          }
                                        },
                                      );
                                    },
                                    child: Text("Edit"),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      custemAlertDialog(context, () {
                                        context
                                            .read<CategoryService>()
                                            .deleteCatagory(value);
                                        Navigator.pop(context);
                                      });
                                    },
                                    child: Text(
                                      "Delete",
                                      style: TextStyle(color: Colors.red),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        );
                      }).toList(),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
