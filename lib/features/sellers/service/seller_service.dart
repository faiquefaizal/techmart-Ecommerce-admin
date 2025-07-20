import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class SellerService extends ChangeNotifier {
  final _collection = FirebaseFirestore.instance.collection('seller');

  Stream<QuerySnapshot> fetchSellers() {
    return _collection.snapshots();
  }

  Future<void> updateAuthorization(String sellerId, bool status) {
    return _collection.doc(sellerId).update({'is_verfied': status});
  }
}
