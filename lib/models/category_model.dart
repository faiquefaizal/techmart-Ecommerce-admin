class CategoryModel {
  String categoryuid;
  String name;
  String imageurl;
  CategoryModel({
    required this.categoryuid,
    required this.imageurl,
    required this.name,
  });

  Map<String, dynamic> toMap() {
    return {"CatagoryUid": categoryuid, "Name": name, "imageurl": imageurl};
  }

  factory CategoryModel.fromMap(Map<String, dynamic> map) {
    return CategoryModel(
      categoryuid: map["CatagoryUid"],
      imageurl: map["imageurl"],
      name: map["Name"],
    );
  }
}
