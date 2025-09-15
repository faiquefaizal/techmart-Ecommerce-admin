import 'dart:convert';
import 'dart:developer';
import 'dart:typed_data';

import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:techmart_admin/features/brands/models/brand_model.dart';

class BrandService extends ChangeNotifier {
  final brandCollection = FirebaseFirestore.instance.collection("Brands");

  static const cloudName = "dmkamtddy";
  static const cloudPreset = "flutter_uploads";
  static const cloudApiKey = "956275761217399";
  static const cloudApiSecretKey = "qHxukWJjglp4g3MpP1tPCgf2m0Q";

  Future<void> addBrand(String name, Uint8List image) async {
    try {
      String? imageUrl = await sendImageToCloudinary(image);
      final normalizeName = name.toLowerCase();
      final existing =
          await brandCollection.where("name", isEqualTo: normalizeName).get();
      if (existing.docs.isNotEmpty) {
        throw Exception("Brand Already Exists");
      }
      if (imageUrl != null) {
        final docRef = brandCollection.doc();
        final brandModel = BrandModel(
          brandUid: docRef.id,
          name: normalizeName,
          imageUrl: imageUrl,
        );
        await docRef.set(brandModel.toMap());
      } else {
        throw "Image not available from Cloudinary.";
      }
    } catch (e) {
      log("Error adding brand: $e");
      rethrow;
    }
  }

  Future<void> editBrand(BrandModel brand, String? oldImageUrl) async {
    try {
      if (oldImageUrl != null && oldImageUrl != brand.imageUrl) {
        await deleteImageFromCloudinary(oldImageUrl);
      }
      await brandCollection.doc(brand.brandUid).update(brand.toMap());
    } catch (e) {
      log("Error editing brand: $e");
      rethrow;
    }
  }

  Future<void> deleteBrand(BrandModel brand) async {
    try {
      await deleteImageFromCloudinary(brand.imageUrl);
      await brandCollection.doc(brand.brandUid).delete();
    } catch (e) {
      log("Error deleting brand: $e");
      rethrow;
    }
  }

  Stream<List<BrandModel>> fetchBrands() {
    return brandCollection.snapshots().map(
      (snapshot) =>
          snapshot.docs.map((doc) => BrandModel.fromMap(doc.data())).toList(),
    );
  }

  Future<String?> sendImageToCloudinary(Uint8List image) async {
    try {
      final url = Uri.parse(
        "https://api.cloudinary.com/v1_1/$cloudName/image/upload",
      );
      final request =
          http.MultipartRequest("POST", url)
            ..fields["upload_preset"] =
                cloudPreset // Use correct variable name
            ..files.add(
              http.MultipartFile.fromBytes(
                "file",
                image,
                filename:
                    "brand_image_${DateTime.now().millisecondsSinceEpoch}", // More unique filename
              ),
            );
      final response = await request.send();
      if (response.statusCode == 200) {
        final resBody = await response.stream.bytesToString();
        return jsonDecode(resBody)["secure_url"];
      } else {
        log("Cloudinary upload failed with status: ${response.statusCode}");
        final resBody = await response.stream.bytesToString();
        log("Cloudinary error response: $resBody");
        return null;
      }
    } catch (e) {
      log("Error sending image to Cloudinary: $e");
      return null;
    }
  }

  Future<void> deleteImageFromCloudinary(String imageUrl) async {
    try {
      final uri = Uri.parse(imageUrl);
      final pathSegments = uri.pathSegments;

      String publicId = '';
      final uploadIndex = pathSegments.indexOf(cloudPreset);
      if (uploadIndex != -1 && uploadIndex + 1 < pathSegments.length) {
        publicId =
            pathSegments.sublist(uploadIndex + 1).join('/').split('.').first;
      } else {
        publicId = pathSegments.last.split('.').first;
      }

      if (publicId.isEmpty) {
        log("Could not extract publicId from URL: $imageUrl");
        return;
      }

      final deleteUrl = Uri.parse(
        "https://api.cloudinary.com/v1_1/$cloudName/resources/image/destroy",
      );

      final response = await http.post(
        deleteUrl,
        headers: {
          "Authorization":
              "Basic ${base64Encode(utf8.encode('$cloudApiKey:$cloudApiSecretKey'))}",
          "Content-Type": "application/json",
        },
        body: jsonEncode({"public_id": publicId, "invalidate": true}),
      );

      if (response.statusCode == 200) {
        log("Image deleted from Cloudinary: $publicId");
      } else {
        log(
          "Failed to delete image from Cloudinary: ${response.statusCode} - ${response.body}",
        );
        throw "Failed to delete image from Cloudinary: ${response.statusCode}";
      }
    } catch (e) {
      log("Error deleting image from Cloudinary: $e");
    }
  }
}
