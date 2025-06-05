import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';
import 'package:techmart_admin/core/widgets/add_dialog_widget.dart';
import 'package:techmart_admin/core/widgets/confirmation_dialog.dart';
import 'package:techmart_admin/core/widgets/custem_snackbar.dart';
import 'package:techmart_admin/features/catagories/ui/widgets';
import 'package:techmart_admin/models/category_model.dart';
import 'package:techmart_admin/providers/catagory_varient_provider.dart';
import 'package:techmart_admin/providers/pick_image.dart';
import 'package:techmart_admin/services/catagory_service.dart';

class CatagoryScreen extends StatelessWidget {
  TextEditingController ctagorynameController = TextEditingController();
  CatagoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(13),
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              ElevatedButton(
                onPressed: () {
                  custemAddDialog(
                    varient: true,
                    varientOption: () => showAddVariantDialog(context),
                    context: context,
                    controller: ctagorynameController,
                    onpressed: () async {
                      final catargoryVarientProvider =
                          context.read<CatagoryVarientProvider>();
                      final imageProvider = context.read<ImageProviderModel>();
                      final image = imageProvider.pickedImage;
                      final name = ctagorynameController.text.trim();
                      if (name.isEmpty || image == null) {
                        return custemSnakbar(
                          context,
                          "Pick a photo ",
                          Colors.red,
                        );
                      }

                      await context.read<CategoryService>().addCatagory(
                        name,
                        image,
                        catargoryVarientProvider.ctagoryVarientList,
                      );

                      if (Navigator.canPop(context)) {
                        ctagorynameController.clear();
                        imageProvider.clearImage();
                        Navigator.pop(context);
                      }
                    },
                  );
                },
                child: Text("Add Catagory"),
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: double.infinity,
                child: Card(
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        minWidth:
                            MediaQuery.of(context).size.width - (13.0 * 2),
                      ),
                      child: StreamBuilder(
                        stream:
                            context.read<CategoryService>().fetchCatagories(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return CircularProgressIndicator();
                          }
                          return DataTable(
                            columnSpacing: 20,
                            columns: [
                              DataColumn(label: Text("Logo")),
                              DataColumn(label: Text("Catagory Name")),
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
                                                  controller:
                                                      ctagorynameController,

                                                  onpressed: () async {
                                                    final newImage =
                                                        context
                                                            .read<
                                                              ImageProviderModel
                                                            >()
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
                                                      categoryuid:
                                                          value.categoryuid,
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
                                                      name:
                                                          ctagorynameController
                                                              .text,
                                                    );
                                                    context
                                                        .read<CategoryService>()
                                                        .editCatagory(
                                                          updatedCatagory,
                                                          value.imageurl,
                                                        );
                                                    if (Navigator.canPop(
                                                      context,
                                                    )) {
                                                      ctagorynameController
                                                          .clear();
                                                      context
                                                          .read<
                                                            ImageProviderModel
                                                          >()
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
                                                style: TextStyle(
                                                  color: Colors.red,
                                                ),
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}
