import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:techmart_admin/core/widgets/add_dialog_widget.dart';
import 'package:techmart_admin/core/widgets/confirmation_dialog.dart'; // Make sure this path is correct
import 'package:techmart_admin/core/widgets/custem_snackbar.dart';
import 'package:techmart_admin/models/brand_model.dart'; // Import your new BrandModel
import 'package:techmart_admin/providers/pick_image.dart'; // Assuming you have a generic ImageProviderModel
import 'package:techmart_admin/services/brand_service.dart'; // Import your new BrandService

class BrandScreen extends StatelessWidget {
  // Use a final keyword for TextEditingController in StatelessWidget
  final TextEditingController brandNameController = TextEditingController();

  BrandScreen({super.key});

  void _addBrand(BuildContext context) async {
    final imageProvider = context.read<ImageProviderModel>();
    final brandService = context.read<BrandService>();

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

  // Extracted method for editing brand
  void _editBrand(BuildContext context, BrandModel brandToEdit) async {
    final TextEditingController editBrandNameController = TextEditingController(
      text: brandToEdit.name,
    );

    final imageProvider = context.read<ImageProviderModel>();
    final brandService = context.read<BrandService>();

    // Clear any previously picked image in the provider when opening edit dialog
    imageProvider.clearImage();

    custemAddDialog(
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
            if (Navigator.canPop(context))
              Navigator.pop(context); // Pop dialog on image upload error
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

  // Extracted method for deleting brand
  void _deleteBrand(BuildContext context, BrandModel brandToDelete) async {
    custemAlertDialog(context, () async {
      try {
        await context.read<BrandService>().deleteBrand(brandToDelete);
        if (Navigator.canPop(context)) {
          Navigator.pop(context); // Pop confirmation dialog
        }
        custemSnakbar(context, "Brand deleted successfully!", Colors.green);
      } catch (e) {
        if (Navigator.canPop(context))
          Navigator.pop(context); // Pop confirmation dialog on error
        custemSnakbar(
          context,
          "Failed to delete brand: ${e.toString()}",
          Colors.red,
        );
      }
    });
  }

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
                onPressed: () => _addBrand(context),
                child: const Text("Add Brand"),
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
                      child: StreamBuilder<List<BrandModel>>(
                        stream:
                            context
                                .watch<BrandService>()
                                .fetchBrands(), // Use watch here for rebuilding
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                          if (snapshot.hasError) {
                            return Center(
                              child: Text('Error: ${snapshot.error}'),
                            );
                          }
                          if (!snapshot.hasData || snapshot.data!.isEmpty) {
                            return const Center(
                              child: Text('No brands found.'),
                            );
                          }
                          return DataTable(
                            columnSpacing: 20,
                            columns: const [
                              DataColumn(label: Text("Logo")),
                              DataColumn(label: Text("Brand Name")),
                              DataColumn(label: Text("Actions")),
                            ],
                            rows:
                                snapshot.data!.map((brand) {
                                  return DataRow(
                                    cells: [
                                      DataCell(
                                        Image.network(
                                          brand.imageUrl,
                                          width: 50,
                                          height: 50,
                                          errorBuilder:
                                              (context, error, stackTrace) =>
                                                  const Icon(
                                                    Icons.broken_image,
                                                    size: 50,
                                                  ),
                                        ),
                                      ),
                                      DataCell(Text(brand.name)),
                                      DataCell(
                                        Row(
                                          children: [
                                            TextButton(
                                              onPressed:
                                                  () => _editBrand(
                                                    context,
                                                    brand,
                                                  ),
                                              child: const Text("Edit"),
                                            ),
                                            TextButton(
                                              onPressed:
                                                  () => _deleteBrand(
                                                    context,
                                                    brand,
                                                  ),
                                              child: const Text(
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
