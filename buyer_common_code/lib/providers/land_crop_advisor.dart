import 'package:buyer_common_code/model/CropCalenderResponse.dart';
import 'package:buyer_common_code/model/CropMasterResponse.dart' as cmr;
import 'package:buyer_common_code/model/LandResponse.dart';
import 'package:flutter/material.dart';

import '../model/MasterResponse.dart' as mr;

class LandCropProvider extends ChangeNotifier {
  ConfigUrl configUrl = ConfigUrl(
      categoryImgUrl: "",
      partnerImgUrl: "",
      aadharNoDocUrl: "",
      panNoDocUrl: "",
      farmImageUrl: "",
      productImageUrl: "",
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

  List<CustomData> landList = [];

  setLandList(List<CustomData> list) {
    landList = List<CustomData>.empty();
    landList = list;
    notifyListeners();
  }

  deleteFarm(String cropID) {
    for (int i = 0; i < landList.length; i++) {
      if (cropID == landList[i].landId) {
        landList.removeAt(i);
      }
    }
    notifyListeners();
  }

  List<cmr.CustomData> cropMasterList = [];

  setCropMasterList(List<cmr.CustomData> list) {
    cropMasterList = List<cmr.CustomData>.empty();
    cropMasterList = list;
    notifyListeners();
  }

  void clearCropList() {
    cropMasterList.clear();
    notifyListeners();
  }

  deleteCrop(String cropID) {
    for (int i = 0; i < cropMasterList.length; i++) {
      if (cropID == cropMasterList[i].id) {
        cropMasterList.removeAt(i);
      }
    }
    notifyListeners();
  }

  setConfigUrl(ConfigUrl list) {
    configUrl = list;
    notifyListeners();
  }

  List<mr.FarmType> farmType = [];
  List<mr.Topology> topology = [];
  List<mr.SoilType> soilType = [];
  List<mr.Unit> unit = [];
  List<mr.IrriSrc> irriSrc = [];
  List<mr.IrriFaty> irriFaty = [];
  List<mr.Crop> crop = [];
  List<mr.CropType> cropType = [];

  setFarmType(List<mr.FarmType> list) {
    farmType = List<mr.FarmType>.empty();
    farmType = list;
    notifyListeners();
  }

  setTopology(List<mr.Topology> list) {
    topology = List<mr.Topology>.empty();
    topology = list;
    notifyListeners();
  }

  setSoilType(List<mr.SoilType> list) {
    soilType = List<mr.SoilType>.empty();
    soilType = list;
    notifyListeners();
  }

  setUnit(List<mr.Unit> list) {
    unit = List<mr.Unit>.empty();
    unit = list;
    notifyListeners();
  }

  setIrriSrc(List<mr.IrriSrc> list) {
    irriSrc = List<mr.IrriSrc>.empty();
    irriSrc = list;
    notifyListeners();
  }

  setIrriFaty(List<mr.IrriFaty> list) {
    irriFaty = List<mr.IrriFaty>.empty();
    irriFaty = list;
    notifyListeners();
  }

  setCrop(List<mr.Crop> list) {
    crop = List<mr.Crop>.empty();
    crop = list;
    notifyListeners();
  }

  setCropType(List<mr.CropType> list) {
    cropType = List<mr.CropType>.empty();
    cropType = list;
    notifyListeners();
  }

  List<CropCal> cropCalenderList = [];

  setCropCalenderList(List<CropCal> list) {
    cropCalenderList = List<CropCal>.empty();
    cropCalenderList = list;
    notifyListeners();
  }
  NewResult? newResultData;

  void setNewResultData(final list) {
    newResultData = list;
    notifyListeners();
  }
}
