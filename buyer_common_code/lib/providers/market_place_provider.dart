import 'package:buyer_common_code/model/MarketPlaceCatagryResponse.dart';
import 'package:buyer_common_code/model/MarketProductResponse.dart';
import 'package:buyer_common_code/model/MyOrderResponse.dart';
import 'package:flutter/material.dart';

import '../model/AllMenu.dart';
import '../model/PickUpPointResponse.dart';
import '../model/ProductResponse.dart';

class MarketPlaceProvider extends ChangeNotifier {
  List<MarketPlaceCatagryData> marketPlaceCategoryList = [];

  var prise = 0.0;

  setMarketPlaceCategoryList(List<MarketPlaceCatagryData> list) {
    marketPlaceCategoryList = List<MarketPlaceCatagryData>.empty();
    marketPlaceCategoryList = list;
    notifyListeners();
  }

  void clearMyOrderList() {
    myOrderList = [];
    notifyListeners();
  }

  List<MarketProductData> marketProductList = [];

  setMarketProductList(List<MarketProductData> list) {
    marketProductList = List<MarketProductData>.empty();
    marketProductList = list;
    for (int i = 0; i < marketProductList.length; i++) {
      for (int j = 0; j < cartProductList.length; j++) {
        if (marketProductList[i].id == cartProductList[j].id) {
          marketProductList[i].cartFlag = true;
        }
      }
    }
    notifyListeners();
  }

  List<OrderData>? orderData;

  setMarketOrderDetails(final orderList) {
    orderData = orderList;
    notifyListeners();
  }

  List<ProductsList> cartProductList = [];

  setCartProductList(List<ProductsList> list) {
    prise = 0.0;
    cartProductList = List<ProductsList>.empty();
    cartProductList = list;
    if (cartProductList.isNotEmpty) {
      for (int i = 0; i < cartProductList.length; i++) {
        prise = prise + (int.parse(cartProductList[i].qty ?? "1") * double.parse(cartProductList[i].price));
      }
    } else {
      prise = 0.0;
    }

    notifyListeners();
  }

  setUpdateCart(String partner_id, String qty) {
    prise = 0.0;
    if (cartProductList.isNotEmpty) {
      for (int i = 0; i < cartProductList.length; i++) {
        if (partner_id == cartProductList[i].id) {
          cartProductList[i].qty = qty;
        }
        prise = prise + (int.parse(cartProductList[i].qty!) * double.parse(cartProductList[i].price));
      }
    } else {
      prise = 0.0;
    }
    notifyListeners();
  }

  void setDeleteCart(String partner_id) {
    prise = 0.0;
    if (cartProductList.isNotEmpty) {
      for (int i = 0; i < cartProductList.length; i++) {
        if (partner_id == cartProductList[i].id) {
          cartProductList.removeAt(i);
        }
      }
      for (int i = 0; i < cartProductList.length; i++) {
        prise = prise + (int.parse(cartProductList[i].qty!) * double.parse(cartProductList[i].price));
      }
    } else {
      prise = 0.0;
    }
    notifyListeners();
  }

  setClearCart() {
    prise = 0.0;
    cartProductList = [];

    notifyListeners();
  }

  setCartFlag(String partner_id) {
    for (int i = 0; i < marketProductList.length; i++) {
      if (partner_id == marketProductList[i].id) {
        marketProductList[i].cartFlag = true;
      }
    }
    notifyListeners();
  }

  List<MyOrderData> myOrderList = [];

  setMyOrderList(List<MyOrderData> list) {
    // myOrderList = List<MyOrderData>.empty();
    myOrderList.addAll(list);
    notifyListeners();
  }

  List<ProductData> productList = [];

  setProductList(List<ProductData> list) {
    productList = List<ProductData>.empty();
    productList = list;
    notifyListeners();
  }

  List<ProductsList> allProductList = [];

  setAllProductList(List<ProductsList> list) {
    //allProductList=List<ProductsList>.empty();
    allProductList.addAll(list);
    notifyListeners();
  }

  setAllProductClear() {
    allProductList = [];
    notifyListeners();
  }

  List<ProductsList> oderDetailsList = [];

  setOderDetailsList(List<ProductsList> list) {
    oderDetailsList = List<ProductsList>.empty();
    oderDetailsList = list;
    notifyListeners();
  }

  List<PickUpPointData> pickUpPointlist = [];

  setPickUpPointList(List<PickUpPointData> list) {
    pickUpPointlist = List<PickUpPointData>.empty();
    pickUpPointlist = list;
    notifyListeners();
  }

  var ecomPage = 1;

  setEcomPage(int page) {
    ecomPage = page;
    notifyListeners();
  }

  var page = 1;

  setPage(int pages) {
    page = pages;
    notifyListeners();
  }

  List<BottomMenu> deliveryMenulist = [];

  setDeliveryMenuList(List<BottomMenu> list) {
    deliveryMenulist = List<BottomMenu>.empty();
    deliveryMenulist = list;
    notifyListeners();
  }

  List<BottomMenu> marketMenulist = [];

  setMarketMenuList(List<BottomMenu> list) {
    marketMenulist = List<BottomMenu>.empty();
    marketMenulist = list;
    notifyListeners();
  }
}
