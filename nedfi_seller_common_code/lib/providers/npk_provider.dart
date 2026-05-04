import 'package:nedfi_seller_common_code/model/NPKResponse.dart';
import 'package:flutter/material.dart';

import '../model/npk_detail_model.dart';
import '../model/DSSCropResponse.dart';

class NPKProvider extends ChangeNotifier {
  List<CropData> dSSCropList = [];
  List<AllCrops> allCropsList = [];

  setDSSCategoryList(List<CropData> list) {
    dSSCropList = List<CropData>.empty();
    dSSCropList = list;
    notifyListeners();
  }

  void setDSSAllCropsList(List<AllCrops> list) {
    allCropsList = List<AllCrops>.empty();
    allCropsList = list;
    notifyListeners();
  }

  List<NpkValues> npkList = [];

  setNPKList(List<NpkValues> list) {
    npkList = List<NpkValues>.empty();
    npkList = list;
    notifyListeners();
  }
}
