import 'package:techmart_admin/features/catagories/models/catagory_varient.dart';

class CategoryModel {
  String categoryuid;
  String name;
  String imageurl;
  List<CatagoryVarient> varientOptions;
  CategoryModel({
    required this.categoryuid,
    required this.imageurl,
    required this.name,
    required this.varientOptions,
  });

  Map<String, dynamic> toMap() {
    return {
      "CatagoryUid": categoryuid,
      "Name": name,
      "imageurl": imageurl,
      "varientOptions": varientOptions.map((e) => e.toMap()).toList(),
    };
  }

  factory CategoryModel.fromMap(Map<String, dynamic> map) {
    return CategoryModel(
      categoryuid: map["CatagoryUid"],
      imageurl: map["imageurl"],
      name: map["Name"],
      varientOptions:
          (map["varientOptions"] as List<dynamic>)
              .map((e) => CatagoryVarient.fromMap(e as Map<String, dynamic>))
              .toList(),
    );
  }
}
