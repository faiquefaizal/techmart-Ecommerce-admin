class CouponModel {
  String? id;
  String coupenName;
  DateTime? startTime;
  DateTime? endTime;
  bool isLive;
  bool alwaysEnabeld;
  int minPrice;
  int dicountPrice;
  CouponModel({
    required this.dicountPrice,
    required this.minPrice,
    this.id,
    this.startTime,
    this.endTime,
    required this.coupenName,
    this.isLive = true,
    required this.alwaysEnabeld,
  });
  factory CouponModel.fromMap(Map<String, dynamic> map) {
    return CouponModel(
      minPrice: map["minPrice"],
      dicountPrice: map["dicountPrice"],
      id: map["id"],
      startTime: map["startTime"],
      endTime: map["endTime"],
      isLive: map["isLive"],
      coupenName: map["name"],
      alwaysEnabeld: map["alwaysEnabeld"],
    );
  }
  Map<String, dynamic> toMap() {
    return {
      "minPrice": minPrice,
      "dicountPrice": dicountPrice,
      "id": id,
      "startTime": alwaysEnabeld ? null : startTime,
      "endTime": alwaysEnabeld ? null : endTime,
      "isLive": isLive,
      "name": coupenName,
      "alwaysEnabeld": alwaysEnabeld,
    };
  }
}
