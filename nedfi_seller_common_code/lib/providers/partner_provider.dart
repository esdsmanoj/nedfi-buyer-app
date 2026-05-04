import 'package:nedfi_seller_common_code/model/PartnerResponse.dart';
import 'package:flutter/material.dart';

class PartnerProvider extends ChangeNotifier {
  List<PartnerData> partnerList = [];

  setPartnerList(List<PartnerData> list) {
    partnerList = List<PartnerData>.empty();
    partnerList = list;
    notifyListeners();
  }
}
