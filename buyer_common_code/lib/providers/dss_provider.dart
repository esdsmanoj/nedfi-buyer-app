import 'package:buyer_common_code/model/DSSMenuResponse.dart';
import 'package:buyer_common_code/model/DiseaseFilterResponse.dart';
import 'package:buyer_common_code/model/PestDiseaseResponse.dart';
import 'package:buyer_common_code/model/SoilHealthResponse.dart';
import 'package:buyer_common_code/model/VaritesResponse.dart';
import 'package:flutter/material.dart';

import '../model/DSSCropResponse.dart';
import '../model/VarietyState.dart';

class DSSProvider extends ChangeNotifier {
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
      soilHealthImage: "",
      loanImageUrl: '');

  List<CropData> dSSCropList = [];

  setDSSCatagoryList(List<CropData> list) {
    dSSCropList = List<CropData>.empty();
    dSSCropList = list;
    notifyListeners();
  }

  List<DSSMenuData> dSSMenuList = [];

  setDSSMenuList(List<DSSMenuData> list) {
    dSSMenuList = List<DSSMenuData>.empty();
    dSSMenuList = list;
    notifyListeners();
  }

  setConfigUrl(ConfigUrl list) {
    configUrl = list;
    notifyListeners();
  }

  List<VaritesData> varitesList = [];

  setVaritesList(List<VaritesData> list) {
    varitesList = List<VaritesData>.empty();
    varitesList = list;
    notifyListeners();
  }

  List<SoilHealthData> SoilHealthList = [];

  setSoilHealthList(List<SoilHealthData> list) {
    SoilHealthList = List<SoilHealthData>.empty();
    SoilHealthList = list;
    notifyListeners();
  }

  List<PestDiseaseData> pestDiseaseList = [];

  setPestDiseaseList(List<PestDiseaseData> list) {
    pestDiseaseList = List<PestDiseaseData>.empty();
    pestDiseaseList = list;
    notifyListeners();
  }

  List<FilterData> diseaseFilterList = [];

  setDiseaseFilterList(List<FilterData> list) {
    diseaseFilterList = List<FilterData>.empty();
    diseaseFilterList = list;
    notifyListeners();
  }

  List<DiseaseData> diseaseList = [];

  setDiseaseList(List<DiseaseData> list) {
    diseaseList = List<DiseaseData>.empty();
    diseaseList = list;
    notifyListeners();
  }

  List<VarietyStateData> varietyStateData = [];
  List<IrrigationSrc> irrigationSrc = [];
  List<IrrigationType> irrigationType = [];
  List<SoilType> soilType = [];
  List<CropSeasons> cropSeasons = [];

  setVarietyStateDataList(List<VarietyStateData> list) {
    varietyStateData = [];
    varietyStateData = list;
    notifyListeners();
  }

  setIrrigationSrcList(List<IrrigationSrc> list) {
    irrigationSrc = [];
    irrigationSrc = list;
    notifyListeners();
  }

  setIrrigationTypeList(List<IrrigationType> list) {
    irrigationType = [];
    irrigationType = list;
    notifyListeners();
  }

  setSoilTypeList(List<SoilType> list) {
    soilType = [];
    soilType = list;
    notifyListeners();
  }

  setCropSeasonsList(List<CropSeasons> list) {
    cropSeasons = [];
    cropSeasons = list;
    notifyListeners();
  }
}
