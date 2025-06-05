import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:techmart_admin/models/catagory_varient.dart';
import 'package:techmart_admin/models/category_model.dart';

class CategoryService extends ChangeNotifier {
  final catagoryCollection = FirebaseFirestore.instance.collection("Catagory");
  static const cloudName = "dmkamtddy";
  static const clouddPresent = "flutter_uploads";
  static const cloudApiKey = "956275761217399";

  static const cloudApiSecretKey = "qHxukWJjglp4g3MpP1tPCgf2m0Q";

  Future<void> addCatagory(
    String name,
    Uint8List image,
    List<CatagoryVarient> varients,
  ) async {
    try {
      String? imageurl = await sendImageToCloidinary(image);
      if (imageurl != null) {
        final docref = catagoryCollection.doc();
        final catagoryModel = CategoryModel(
          varientOptions: varients,
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
    } catch (e) {
      log(e.toString());
    }
  }

  Future<void> editCatagory(CategoryModel catagory, String? oldImage) async {
    try {
      if (oldImage != null && oldImage != catagory.imageurl) {
        await deleteImageFromCloudinary(oldImage);
      }
      await catagoryCollection
          .doc(catagory.categoryuid)
          .update(catagory.toMap());
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  Future<void> deleteCatagory(CategoryModel catagory) async {
    try {
      await deleteImageFromCloudinary(catagory.categoryuid);
      await catagoryCollection.doc(catagory.categoryuid).delete();
    } catch (e) {
      log(e.toString());
      rethrow;
    }
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

  Future<void> deleteImageFromCloudinary(String imageUrl) async {
    try {
      // Extract the public_id from the image URL
      final uri = Uri.parse(imageUrl);
      final pathSegments = uri.pathSegments;
      final publicId =
          pathSegments
              .sublist(pathSegments.indexOf(clouddPresent))
              .join('/')
              .split('.')
              .first;

      final url = Uri.parse(
        "https://api.cloudinary.com/v1_1/$cloudName/resources/image/upload",
      );
      final response = await http.delete(
        url,
        headers: {
          "Authorization":
              "Basic ${base64Encode(utf8.encode('$cloudApiKey:$cloudApiSecretKey'))}",
        },
        body: jsonEncode({"public_id": publicId}),
      );

      if (response.statusCode == 200) {
        log("Image deleted from Cloudinary: $publicId");
      } else {
        throw "Failed to delete image from Cloudinary: ${response.statusCode}";
      }
    } catch (e) {
      log("Error deleting image from Cloudinary: $e");
    }
  }
}
