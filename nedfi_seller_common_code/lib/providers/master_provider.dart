import 'package:nedfi_seller_common_code/model/trade_product_model/BuyerDemand.dart';
import 'package:nedfi_seller_common_code/model/NedfiProductType.dart';
import 'package:nedfi_seller_common_code/model/trade_product_model/NedfiProductVariety.dart';

import '../app_imports.dart';
import '../model/ProductType.dart';
import '../model/trade_product_model/UpcomingProduct.dart';
import '../model/trade_product_model/master_listing_model.dart';
import '../model/trade_product_model/trade_product_info.dart';

class MasterProvider extends ChangeNotifier {
  Data? masterData;
  List<ProductTypeData> productTypeList = [];
  List<NedfiProductTypeData> productList = [];
  List<NedfiProductVarietyData> productVarietyList = [];
  List<NedfiProductVarietyData> packagingList = [];
  List<NedfiProductVarietyData> storageList = [];
  dynamic itemId;

  TradeProductData? treadProductCurrent;

  String type = "";

  setType(String id) {
    type = id;
    notifyListeners();
  }

  setCurrentTreadProduct(TradeProductData treadProduct) {
    treadProductCurrent = treadProduct;
    notifyListeners();
  }

  List<TradeProductData> treadProductList = [];

  setTreadProduct(List<TradeProductData> list) {
    treadProductList = [];
    treadProductList = list;
    notifyListeners();
  }

  addTreadProduct(List<TradeProductData> list) {
    treadProductList.addAll(list);
    notifyListeners();
  }

  setItemId(String id) {
    itemId = id;
    notifyListeners();
  }

  setMasterData(Data masterDatas) {
    masterData = masterDatas;
    notifyListeners();
  }

  int productCurrentIndex = 1;

  setProductCurrentIndex(int index) {
    productCurrentIndex = index;
    notifyListeners();
  }

  setProductTypeData(List<ProductTypeData> list) {
    productTypeList = [];
    productTypeList = list;
    notifyListeners();
  }

  setProductData(List<NedfiProductTypeData> list) {
    productList = [];
    productList = list;
    notifyListeners();
  }

  setProductVarietyData(List<NedfiProductVarietyData> list) {
    productVarietyList = [];
    productVarietyList = list;
    notifyListeners();
  }

  setPackagingData(List<NedfiProductVarietyData> list) {
    packagingList = [];
    packagingList = list;
    notifyListeners();
  }

  setStorageData(List<NedfiProductVarietyData> list) {
    storageList = [];
    storageList = list;
    notifyListeners();
  }

  List<UpcomingProductData> upcomingProductList = [];

  setUpcomingProduct(List<UpcomingProductData> list) {
    upcomingProductList = [];
    upcomingProductList = list;
    notifyListeners();
  }

  List<BuyerDemandData> buyerDemandList = [];

  setBuyerDemand(List<BuyerDemandData> list) {
    buyerDemandList = [];
    buyerDemandList = list;
    notifyListeners();
  }
}
