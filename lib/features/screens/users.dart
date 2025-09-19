import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class UsersPage extends StatelessWidget {
  const UsersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Users'), centerTitle: true),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('Users').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No users found.'));
          }
          final users = snapshot.data!.docs;
          return SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                columns: const [
                  DataColumn(label: Text('Name')),
                  DataColumn(label: Text('Email')),
                  DataColumn(label: Text("Phone Number")),
                ],
                rows:
                    users.map((user) {
                      final name = user['name'] ?? 'No Name';
                      final email = user['email'] ?? 'No Email';
                      final phone = user['phone'] ?? 'NO phone';

                      return DataRow(
                        cells: [
                          DataCell(Text(name)),
                          DataCell(Text(email)),
                          DataCell(Text(phone)),
                        ],
                      );
                    }).toList(),
              ),
            ),
          );
        },
      ),
    );
  }
}
