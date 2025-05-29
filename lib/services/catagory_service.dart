import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:techmart_admin/models/category_model.dart';

class CategoryService extends ChangeNotifier {
  final catagoryCollection = FirebaseFirestore.instance.collection("Catagory");

  Future<void> addCatagory(String name, Uint8List image) async {
    String? imageurl = await sendImageToCloidinary(image);
    if (imageurl != null) {
      final docref = catagoryCollection.doc();
      final catagoryModel = CategoryModel(
        categoryuid: docref.id,
        imageurl: imageurl,
        name: name,
      );
      await catagoryCollection
          .doc(catagoryModel.categoryuid)
          .set(catagoryModel.toMap());
    } else {
      throw "Image not avialabe";
    }
  }

  // fetchCatagory() async {
  //   final catagories = await catagoryCollection.get();

  //   catagoryList.clear();
  //   catagoryList.addAll(
  //     catagories.docs
  //         .map((value) => CategoryModel.fromMap(value.data()))
  //         .toList(),
  //   );
  //   notifyListeners();
  // }

  // Future<void> addCatagory(CategoryModel catagory) async {
  //   await catagoryCollection.doc(catagory.categoryuid).set(catagory.toMap());
  // }

  Future<void> editCatagory(CategoryModel catagory) async {
    await catagoryCollection.doc(catagory.categoryuid).update(catagory.toMap());
  }

  Future<void> deleteCatagory(CategoryModel catagory) async {
    await catagoryCollection.doc(catagory.categoryuid).delete();
  }

  Stream<List<CategoryModel>> fetchCatagories() {
    return catagoryCollection.snapshots().map(
      (snapshot) =>
          snapshot.docs
              .map((snapshot) => CategoryModel.fromMap(snapshot.data()))
              .toList(),
    );
  }

  Future<String?> sendImageToCloidinary(Uint8List image) async {
    const cloudName = "dmkamtddy";
    const clouddPresent = "flutter_uploads";
    try {
      final url = Uri.parse(
        "https://api.cloudinary.com/v1_1/$cloudName/image/upload",
      );
      final request =
          http.MultipartRequest("POST", url)
            ..fields["upload_preset"] = clouddPresent
            ..files.add(
              http.MultipartFile.fromBytes(
                "file",
                image,
                filename: "catagoryname",
              ),
            );
      final respond = await request.send();
      if (respond.statusCode == 200) {
        log("requests sended successfully");
        final res = await http.Response.fromStream(respond);

        return jsonDecode(res.body)["secure_url"];
      }
    } catch (e) {
      log(e.toString());
    }
  }
}
