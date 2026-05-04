import 'package:nedfi_seller_common_code/model/blogs/AdvisoryCropResponse.dart';
import 'package:flutter/material.dart';

import '../model/AgronomistResponse.dart';

class AdvisoryProvider extends ChangeNotifier {
  List<AdvisoryCropData> advisoryCropList = List<AdvisoryCropData>.empty();

  setAdvisoryCropList(List<AdvisoryCropData> list) {
    advisoryCropList = List<AdvisoryCropData>.empty();
    advisoryCropList = list;
    notifyListeners();
  }

  List<AgronomistData> advisorList = List<AgronomistData>.empty();

  setAdvisorList(List<AgronomistData> list) {
    advisorList = List<AgronomistData>.empty();
    advisorList = list;
    notifyListeners();
  }
}
