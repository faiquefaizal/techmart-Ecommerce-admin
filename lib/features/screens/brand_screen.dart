import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:techmart_admin/features/brands/presentation/widgets/add_brand_widget.dart';
import 'package:techmart_admin/features/brands/presentation/widgets/delete_brand_widget.dart';
import 'package:techmart_admin/features/brands/presentation/widgets/edit_brand_widget.dart';
import 'package:techmart_admin/features/catagories/presentation/widget/add_dialog_widget.dart';
import 'package:techmart_admin/features/catagories/presentation/widget/confirmation_dialog.dart'; // Make sure this path is correct
import 'package:techmart_admin/core/widgets/custem_snackbar.dart';
import 'package:techmart_admin/features/brands/models/brand_model.dart'; // Import your new BrandModel
import 'package:techmart_admin/providers/pick_image.dart'; // Assuming you have a generic ImageProviderModel
import 'package:techmart_admin/features/brands/services/brand_service.dart'; // Import your new BrandService

class BrandScreen extends StatelessWidget {
  // Use a final keyword for TextEditingController in StatelessWidget
  final TextEditingController brandNameController = TextEditingController();

  BrandScreen({super.key});

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
                onPressed: () => addBrand(context),
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
                        stream: context.watch<BrandService>().fetchBrands(),
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
                                                  () =>
                                                      editBrand(context, brand),
                                              child: const Text("Edit"),
                                            ),
                                            TextButton(
                                              onPressed:
                                                  () => deleteBrand(
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
