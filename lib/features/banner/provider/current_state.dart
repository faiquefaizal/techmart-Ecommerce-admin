import 'dart:convert';
import 'dart:developer';
import 'dart:typed_data';

import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:techmart_admin/features/banner/models/banner_model.dart';

class BannerService extends ChangeNotifier {
  final bannerCollection = FirebaseFirestore.instance.collection("Banners");

  static const cloudName = "dmkamtddy";
  static const cloudPreset = "flutter_uploads";
  static const cloudApiKey = "956275761217399";
  static const cloudApiSecretKey = "qHxukWJjglp4g3MpP1tPCgf2m0Q";

  Future<void> addBanner(String title, List<Uint8List> imageFiles) async {
    try {
      List<String> imageUrls = [];

      for (var image in imageFiles) {
        final imageUrl = await sendImageToCloudinary(image);
        if (imageUrl != null) imageUrls.add(imageUrl);
      }

      if (imageUrls.isNotEmpty) {
        final docRef = bannerCollection.doc();
        final banner = BannerModel(
          title: title,
          id: docRef.id,
          images: imageUrls,
        );
        await docRef.set(banner.toMap());
      } else {
        throw "No images were uploaded.";
      }
    } catch (e) {
      log("Error adding banner: $e");
      rethrow;
    }
  }

  Future<void> editBanner(
    BannerModel updatedBanner,
    List<String> oldImages,
  ) async {
    try {
      // Delete removed images
      for (String oldUrl in oldImages) {
        if (!(updatedBanner.images?.contains(oldUrl) ?? false)) {
          await deleteImageFromCloudinary(oldUrl);
        }
      }

      await bannerCollection
          .doc(updatedBanner.id)
          .update(updatedBanner.toMap());
    } catch (e) {
      log("Error editing banner: $e");
      rethrow;
    }
  }

  Future<void> deleteBanner(BannerModel banner) async {
    try {
      for (String url in banner.images ?? []) {
        await deleteImageFromCloudinary(url);
      }
      await bannerCollection.doc(banner.id).delete();
    } catch (e) {
      log("Error deleting banner: $e");
      rethrow;
    }
  }

  Stream<List<BannerModel>> fetchBanners() {
    log("called");
    return bannerCollection.snapshots().map((snapshot) {
      log("insided");
      log(
        snapshot.docs
            .map((doc) => BannerModel.fromMap(doc.data()))
            .toList()
            .toString(),
      );
      return snapshot.docs.map((doc) {
        log(doc.data().toString());
        return BannerModel.fromMap(doc.data());
      }).toList();
    });
  }

  Future<String?> sendImageToCloudinary(Uint8List image) async {
    try {
      final url = Uri.parse(
        "https://api.cloudinary.com/v1_1/$cloudName/image/upload",
      );

      final request =
          http.MultipartRequest("POST", url)
            ..fields["upload_preset"] = cloudPreset
            ..files.add(
              http.MultipartFile.fromBytes(
                "file",
                image,
                filename: "banner_${DateTime.now().millisecondsSinceEpoch}",
              ),
            );

      final response = await request.send();

      if (response.statusCode == 200) {
        final resBody = await response.stream.bytesToString();
        return jsonDecode(resBody)["secure_url"];
      } else {
        final resBody = await response.stream.bytesToString();
        log("Cloudinary upload failed: ${response.statusCode}, $resBody");
        return null;
      }
    } catch (e) {
      log("Error uploading to Cloudinary: $e");
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
        log("Image deleted: $publicId");
      } else {
        log("Failed to delete image: ${response.statusCode}, ${response.body}");
        throw "Image delete failed";
      }
    } catch (e) {
      log("Error deleting image from Cloudinary: $e");
    }
  }
}
