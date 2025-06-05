import 'package:flutter/material.dart';
import 'package:techmart_admin/models/catagory_varient.dart';

class CatagoryVarientProvider extends ChangeNotifier {
  final List<CatagoryVarient> _catagoryVarientList = [];

  List<CatagoryVarient> get ctagoryVarientList => _catagoryVarientList;

  void addCatagoryVarient(CatagoryVarient catagoryVarient) {
    _catagoryVarientList.add(catagoryVarient);
    notifyListeners();
  }

  void deleteCatagoryVarient(int index) {
    if (index >= 0 && index < _catagoryVarientList.length) {
      _catagoryVarientList.removeAt(index);
      notifyListeners();
    }
  }

  void updateCatagoryVarient(int index, CatagoryVarient newCatagoryVarient) {
    if (index >= 0 && index < _catagoryVarientList.length) {
      _catagoryVarientList[index] = newCatagoryVarient;
      notifyListeners();
    }
  }
}
