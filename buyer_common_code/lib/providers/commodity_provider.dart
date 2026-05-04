import 'package:buyer_common_code/model/MarketResponse.dart' as mr;
import 'package:flutter/material.dart';

import '../model/CommodityDetailsResponse.dart';
import '../model/home_page_model.dart';
import '../model/state_list_model.dart';

class CommodityProvider extends ChangeNotifier {
  List<CommodityRateUpdates> commodityList = [];

  setCommodityList(List<CommodityRateUpdates> list) {
    //CommodityList=List<CommodityData>.empty();
    commodityList.addAll(list);
    notifyListeners();
  }

  List<StateListModelData> stateList = [];

  setStateDetails(List<StateListModelData>? list) {
    stateList = list ?? [];
    notifyListeners();
  }

  setCommodityListClear(List<CommodityRateUpdates> list) {
    commodityList = [];

    notifyListeners();
  }

  List<mr.MarketData> marketList = [];

  setMarket(List<mr.MarketData> list) {
    marketList = List<mr.MarketData>.empty();
    marketList = list;
    notifyListeners();
  }

  List<CommodityPrediction> commodityDetailList = [];

  setCommodityDetailsData(List<CommodityPrediction> list) {
    commodityDetailList = List<CommodityPrediction>.empty();
    commodityDetailList = list;
    notifyListeners();
  }

  List<CommodityPrediction> CommodityDetailsCostArrayList = [];

  setCommodityDetailsCostArray(List<CommodityPrediction> list) {
    CommodityDetailsCostArrayList = List<CommodityPrediction>.empty();
    CommodityDetailsCostArrayList = list;
    notifyListeners();
  }

  List<CommodityPrediction> CommodityDetailsGraphArrayList = [];

  setCommodityDetailsGraphArray(List<CommodityPrediction> list) {
    CommodityDetailsGraphArrayList = List<CommodityPrediction>.empty();
    CommodityDetailsGraphArrayList = list;
    notifyListeners();
  }

  String graph_image = "";

  setGraph_image(String list) {
    graph_image = list;
    notifyListeners();
  }
}
