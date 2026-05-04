import 'package:flutter/material.dart';

import 'DSSCropResponse.dart';
import 'NPKResponse.dart';
import 'npk_detail_model.dart';
import 'npk_recommend_model.dart';

class NPKModel extends ChangeNotifier {
  List<AllCrops> dSSCropList = [];
  NPKRecommend npkRecommend = NPKRecommend();

  setDSSCatagoryList(List<AllCrops> list) {
    dSSCropList = List<AllCrops>.empty();
    dSSCropList = list;
    notifyListeners();
  }

  List<NpkValues> npkList = [];

  setnpkList(List<NpkValues> list) {
    npkList = List<NpkValues>.empty();
    npkList = list;
    notifyListeners();
  }

  void setNPKDetails(final details) {
    npkRecommend = details;
  }
}
