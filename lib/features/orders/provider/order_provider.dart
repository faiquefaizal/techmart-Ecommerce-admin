import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:techmart_admin/features/orders/models/order_model.dart';

class OrderProvider with ChangeNotifier {
  final List<OrderModel> _orders = [];
  bool _isLoading = true;
  String? _errorMessage;
  StreamSubscription<QuerySnapshot>? _subscription;

  List<OrderModel> get orders => _orders;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  OrderProvider() {
    _startListening();
  }

  void _startListening() {
    _subscription?.cancel();

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    _subscription = FirebaseFirestore.instance
        .collection('Orders')
        .snapshots()
        .listen(
          (snapshot) {
            _orders.clear();
            _orders.addAll(
              snapshot.docs
                  .map((doc) => OrderModel.fromJson(doc.data()))
                  .toList(),
            );
            _isLoading = false;
            _errorMessage = null;
            notifyListeners();
          },
          onError: (error) {
            _errorMessage = 'Error fetching orders: $error';
            _isLoading = false;
            notifyListeners();
          },
        );
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}
