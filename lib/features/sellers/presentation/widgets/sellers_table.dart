import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:techmart_admin/features/sellers/service/seller_service.dart';

class SellersTable extends StatelessWidget {
  const SellersTable({super.key});

  @override
  Widget build(BuildContext context) {
    final sellerService = context.read<SellerService>();
    final TextTheme textTheme = Theme.of(context).textTheme;

    return StreamBuilder<QuerySnapshot>(
      stream: sellerService.fetchSellers(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(child: Text('No sellers found.'));
        }

        final sellers = snapshot.data!.docs;

        return SizedBox(
          // <--- CHANGE 1: Full-width container
          width: double.infinity,
          child: Card(
            // <--- CHANGE 2: Wrap content in Card (inherits theme styling)
            // Card Theme is automatically applied from ThemeData!
            elevation: 0,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minWidth: MediaQuery.of(context).size.width,
                ),
                child: DataTable(
                  columnSpacing: 15,

                  headingTextStyle: textTheme.titleMedium,
                  dataTextStyle: textTheme.bodyMedium,
                  columns: const [
                    DataColumn(
                      label: Text('Bussiness Name'),
                      columnWidth: IntrinsicColumnWidth(flex: 2),
                    ),
                    DataColumn(
                      label: Text('Seller Name'),
                      columnWidth: IntrinsicColumnWidth(flex: 2),
                    ),
                    DataColumn(
                      label: Text('Contact Number'),
                      columnWidth: IntrinsicColumnWidth(flex: 2),
                    ),
                    DataColumn(
                      label: Text('Status'),
                      columnWidth: IntrinsicColumnWidth(flex: 1),
                    ),
                    DataColumn(
                      label: Text('Actions'),
                      columnWidth: IntrinsicColumnWidth(flex: 4),
                    ),
                  ],
                  rows:
                      sellers.map((seller) {
                        final data = seller.data() as Map<String, dynamic>;
                        final name = data["businessName"] ?? 'Null';
                        final email = data['sellerName'] ?? 'Null ';
                        final phone = data['phoneNumber'] ?? 'Null';
                        final isAuthorized = data['is_verfied'] ?? false;

                        return DataRow(
                          cells: [
                            DataCell(Text(name)),
                            DataCell(Text(email)),
                            DataCell(Text(phone)),
                            DataCell(
                              Text(
                                isAuthorized ? 'Active' : 'Pending',
                                style: TextStyle(
                                  color:
                                      isAuthorized
                                          ? Colors.green
                                          : Colors.orange,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            DataCell(
                              Row(
                                children: [
                                  ElevatedButton(
                                    onPressed:
                                        isAuthorized
                                            ? null
                                            : () => sellerService
                                                .updateAuthorization(
                                                  seller.id,
                                                  true,
                                                ),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.green,
                                      foregroundColor: Colors.white,
                                    ),
                                    child: const Text('Approve'),
                                  ),
                                  const SizedBox(width: 8),
                                  ElevatedButton(
                                    onPressed:
                                        isAuthorized
                                            ? () => sellerService
                                                .updateAuthorization(
                                                  seller.id,
                                                  false,
                                                )
                                            : null,
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.red,
                                      foregroundColor: Colors.white,
                                    ),
                                    child: const Text('Reject'),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        );
                      }).toList(),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
