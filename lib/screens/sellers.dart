import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class SellersPage extends StatelessWidget {
  const SellersPage({super.key});

  void updateAuthorization(String sellerId, bool status) {
    FirebaseFirestore.instance.collection('seller').doc(sellerId).update({
      'is_verfied': status,
    });
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('seller').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(child: Text('No sellers found.'));
        }

        final sellers = snapshot.data!.docs;

        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: DataTable(
            columns: const [
              DataColumn(label: Text('Name')),
              DataColumn(label: Text('Email')),
              DataColumn(label: Text('Phone')),
              DataColumn(label: Text('Status')),
              DataColumn(label: Text('Actions')),
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
                            color: isAuthorized ? Colors.green : Colors.orange,
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
                                      : () =>
                                          updateAuthorization(seller.id, true),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 5,
                                ),
                              ),
                              child: const Text('Approve'),
                            ),
                            const SizedBox(width: 8),
                            ElevatedButton(
                              onPressed:
                                  isAuthorized
                                      ? () =>
                                          updateAuthorization(seller.id, false)
                                      : null,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 5,
                                ),
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
        );
      },
    );
  }
}
