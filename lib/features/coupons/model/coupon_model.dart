import 'package:cloud_firestore/cloud_firestore.dart';

class CouponModel {
  String? id;
  String coupenName;
  DateTime startTime;
  DateTime endTime;
  bool isLive;
  int minPrice;
  int dicountPrice;
  CouponModel({
    required this.dicountPrice,
    required this.minPrice,
    this.id,
    required this.startTime,
    required this.endTime,
    required this.coupenName,
    this.isLive = true,
  });
  factory CouponModel.fromMap(Map<String, dynamic> map) {
    return CouponModel(
      minPrice: map["minPrice"],
      dicountPrice: map["dicountPrice"],
      id: map["id"],
      startTime: (map["startTime"] as Timestamp).toDate(),
      endTime: (map["endTime"] as Timestamp).toDate(),
      isLive: map["isLive"],
      coupenName: map["name"],
    );
  }
  Map<String, dynamic> toMap() {
    return {
      "minPrice": minPrice,
      "dicountPrice": dicountPrice,
      "id": id,
      "startTime": startTime,
      "endTime": endTime,
      "isLive": isLive,
      "name": coupenName,
    };
  }

  CouponModel copyWith({
    String? id,
    String? coupenName,
    DateTime? startTime,
    DateTime? endTime,
    bool? isLive,
    bool? alwaysEnabeld,
    int? minPrice,
    int? dicountPrice,
  }) {
    return CouponModel(
      id: id ?? this.id,
      coupenName: coupenName ?? this.coupenName,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      isLive: isLive ?? this.isLive,
      minPrice: minPrice ?? this.minPrice,
      dicountPrice: dicountPrice ?? this.dicountPrice,
    );
  }
}
