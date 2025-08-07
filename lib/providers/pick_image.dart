import 'package:flutter/foundation.dart';

class ImageProviderModel with ChangeNotifier {
  Uint8List? _pickedImage;

  Uint8List? get pickedImage => _pickedImage;
  List<Uint8List> _pickedImageList = [];
  void setImage(Uint8List? image) {
    _pickedImage = image;
    notifyListeners();
  }

  void clearImage() {
    _pickedImage = null;
    notifyListeners();
  }

  List<Uint8List> get pickedImageList => _pickedImageList;
  void setImageList(List<Uint8List> images) {
    _pickedImageList = images;
    notifyListeners();
  }

  void addImage(Uint8List image) {
    _pickedImageList.add(image);
    notifyListeners();
  }

  void removeImageAt(int index) {
    _pickedImageList.removeAt(index);
    notifyListeners();
  }

  void clearImageList() {
    _pickedImageList = [];
    notifyListeners();
  }
}
