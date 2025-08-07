import 'dart:developer';

class BannerModel {
  String title;
  List<String> images;
  String id;
  BannerModel({required this.title, required this.images, required this.id});

  factory BannerModel.fromMap(Map<String, dynamic> map) {
    log("title type: ${map['title'].runtimeType}");
    log("images type: ${map['images'].runtimeType}");
    log("id type: ${map['id'].runtimeType}");

    return BannerModel(
      title: map['title'],
      images: List<String>.from(map['images']),
      id: map["id"],
    );
  }

  Map<String, dynamic> toMap() {
    return {'title': title, 'images': images, "id": id};
  }
}
