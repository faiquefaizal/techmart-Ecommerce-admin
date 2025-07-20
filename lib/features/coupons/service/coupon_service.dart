import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:techmart_admin/core/utils/generate_id.dart';
import 'package:techmart_admin/features/coupons/model/coupon_model.dart';

class CouponService {
  final _coupenRef = FirebaseFirestore.instance.collection("AdminCoupouns");

  addCoupons(CouponModel coupon) {
    coupon.id = generateFirebaseId();
    _coupenRef.doc(coupon.id).set(coupon.toMap());
  }

  updateCoupons(CouponModel coupon) {
    _coupenRef.doc(_coupenRef.id).update(coupon.toMap());
  }

  deleteCoupons(String id) {
    _coupenRef.doc(id).delete();
  }
}
