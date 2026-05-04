import 'package:buyer_common_code/model/AdsResponse.dart';
import 'package:buyer_common_code/model/ComodityResponse.dart';
import 'package:buyer_common_code/model/HomeCatagoryResponse.dart';
import 'package:buyer_common_code/model/WeatherResponse.dart';
import 'package:flutter/material.dart';

import 'package:buyer_common_code/model/home_page_model.dart' as service;

class HomeDashboardProvider extends ChangeNotifier {
  List<service.Services> homeCategoryList = List<service.Services>.empty();
  List<BlogType> blogTypeList = List<BlogType>.empty();
  ConfigUrl configUrl = ConfigUrl(
      categoryImgUrl: "",
      partnerImgUrl: "",
      aadharNoDocUrl: "",
      panNoDocUrl: "",
      farmImageUrl: "",
      ProductImageUrl: "",
      marketCatImageUrl: "",
      serviceImageUrl: "",
      blogsTypesUrl: "",
      blogsTagsUrl: "",
      createdBlogsUrl: "",
      farmerDocumentsUrl: "",
      advertiseImageUrl: "",
      whitelabelImageUrl: "",
      termsSheet: "",
      farmDoc: "",
      insuranceCompany: "",
      cropImageUrl: "",
      cropTypeUrl: "",
      notice: "",
      announcement: "",
      cropHealthPredictApi: "",
      dssModuleImageurl: "",
      bottomMenuIcon: "",
      cropVerityImgUrl: "",
      cropFertiImgUrl: "",
      soilHealthImage: "");
  List<AdsData> adsList = [];

  setHomeCatagoryList(List<service.Services> list) {
    homeCategoryList = [];
    homeCategoryList = list;
    notifyListeners();
  }

  setConfigUrl(ConfigUrl list) {
    configUrl = list;
    notifyListeners();
  }

  setBlogTypeList(List<BlogType> list) {
    blogTypeList = List<BlogType>.empty();
    blogTypeList = list;
    notifyListeners();
  }

  setAdsList(List<AdsData> list) {
    adsList = [];
    adsList = list;
    notifyListeners();
  }

  WeatherModel weatherResponse = WeatherModel();

  setWeather(WeatherModel response) {
    weatherResponse = response;
    notifyListeners();
  }

  List<ComodityData> comodityData = [];

  setComodity(List<ComodityData> comodit) {
    comodityData = comodit;
    notifyListeners();
  }

  String comoditymarqee = "";

  setComodityMarqee(String comoditymar) {
    comoditymarqee = comoditymar;
    notifyListeners();
  }

  String comodityMarket = "";

  setComodityMarket(String comoditymar) {
    comodityMarket = comoditymar;
    notifyListeners();
  }

  String lat = "0.0";
  String log = "0.0";
  String cityName = "";

  setLatLog(String lats, String logs) {
    lat = lats;
    log = logs;
    notifyListeners();
  }

  setCityName(String name) {
    cityName = name;
    notifyListeners();
  }
}
