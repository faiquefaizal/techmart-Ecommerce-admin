import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

Future<List<Uint8List>> pickMultiImages(BuildContext context) async {
  final picker = ImagePicker();
  final files = await picker.pickMultiImage();
  // if (files == null) return [];
  if (files == null || files.isEmpty) return [];
  final List<Uint8List> croppedImageList = [];
  for (var element in files) {
    if (!context.mounted) return [];
    final cropImaged = await ImageCropper().cropImage(
      sourcePath: element.path,
      aspectRatio: CropAspectRatio(ratioX: 16, ratioY: 9),

      uiSettings: [
        AndroidUiSettings(lockAspectRatio: true, hideBottomControls: true),

        WebUiSettings(
          initialAspectRatio: 16 / 9,
          viewwMode: WebViewMode.mode_1,
          dragMode: WebDragMode.crop,
          cropBoxResizable: false,
          zoomable: false,
          movable: false,
          scalable: false,
          rotatable: false,

          center: true,
          context: context,
          presentStyle: WebPresentStyle.page,
        ),
      ],
    );
    if (!context.mounted) return [];
    if (cropImaged != null) {
      croppedImageList.add(await cropImaged.readAsBytes());
    }
  }
  return croppedImageList;
  // return Future.wait(files.map((f) => f.readAsBytes()));
}

Future<Uint8List?> pickImage() async {
  final picker = ImagePicker();
  final XFile? image = await picker.pickImage(source: ImageSource.gallery);
  if (image != null) {
    return image.readAsBytes();
  }
  return null;
}

Future<Uint8List?> pickImagewithCrop() async {
  final picker = ImagePicker();
  final XFile? image = await picker.pickImage(source: ImageSource.gallery);
  if (image != null) {
    CroppedFile? croppedFile = await ImageCropper().cropImage(
      sourcePath: image.path,
      aspectRatio: CropAspectRatio(ratioX: 16, ratioY: 9),
      uiSettings: [AndroidUiSettings(lockAspectRatio: true)],
    );
    if (croppedFile != null) {
      return croppedFile.readAsBytes();
    }
  }
  return null;
}

extension DateTimeFormat on DateTime {
  String get ddmmyyyy {
    final d = day.toString().padLeft(2, "0");
    final m = month.toString().padLeft(2, "0");
    final y = year.toString();
    return "$d/$m/$y";
  }
}
