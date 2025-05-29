// import 'dart:convert';
// import 'dart:developer';

// import 'package:http/http.dart' as http;
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:techmart_admin/models/category_model.dart';

// class CategoryService extends ChangeNotifier {
//   final catagoryCollection = FirebaseFirestore.instance.collection("Catagory");

//   Future<void> addCatagory(CategoryModel catagory) async {
//     await catagoryCollection.doc(catagory.categoryuid).set(catagory.toMap());
//   }

//   Future<void> editCatagory(CategoryModel catagory) async {
//     await catagoryCollection.doc(catagory.categoryuid).update(catagory.toMap());
//   }

//   Future<void> deleteCatagory(CategoryModel catagory) async {
//     await catagoryCollection.doc(catagory.categoryuid).delete();
//   }

//   Stream<List<CategoryModel>> fetchCatagories() {
//     return catagoryCollection.snapshots().map(
//       (snapshot) =>
//           snapshot.docs
//               .map((snapshot) => CategoryModel.fromMap(snapshot.data()))
//               .toList(),
//     );
//   }
// }
