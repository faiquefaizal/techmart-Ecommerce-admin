import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:techmart_admin/core/utils/generate_id.dart';
import 'package:techmart_admin/features/coupons/model/coupon_model.dart';

class CouponService extends ChangeNotifier {
  final _coupenRef = FirebaseFirestore.instance.collection("AdminCoupouns");

  Future<void> addCoupons(CouponModel coupon) async {
    String id = generateFirebaseId();
    final updatedCoupen = coupon.copyWith(
      id: id,
      coupenName: coupon.coupenName.toLowerCase(),
    );
    final nameList = await getCoupenNameList();
    if (nameList?.contains(coupon.coupenName.toLowerCase()) ?? false) {
      throw Exception("Then Name already Exist");
    }
    await _coupenRef.doc(updatedCoupen.id).set(updatedCoupen.toMap());
  }

  void updateCoupons(CouponModel coupon) {
    _coupenRef.doc(coupon.id).update(coupon.toMap());
  }

  deleteCoupons(String id) {
    _coupenRef.doc(id).delete();
  }

  Future<List<String>?> getCoupenNameList() async {
    try {
      final coupensDocs = await _coupenRef.get();
      if (coupensDocs.docs.isEmpty) {
        return null;
      }
      List<CouponModel> coupensList =
          coupensDocs.docs
              .map((doc) => CouponModel.fromMap(doc.data()))
              .toList();
      return coupensList.map((coupen) => coupen.coupenName).toList();
    } catch (e) {
      log(e.toString());
      return null;
    }
  }

  Stream<List<CouponModel>> fetchCoupens() {
    try {
      final couponDoc = _coupenRef.snapshots();
      log(couponDoc.toString());
      return couponDoc.map(
        (snapshot) =>
            snapshot.docs.map((doc) {
              log(doc.data().toString());
              return (CouponModel.fromMap(doc.data()));
            }).toList(),
      );
    } catch (e) {
      log(e.toString());
      return Stream.value([]);
    }
  }

  Future<void> unListCoupen(String id, bool curret) async {
    await _coupenRef.doc(id).update({"isLive": !curret});
  }
}
