import 'package:nedfi_seller_common_code/model/profile_model.dart';
import 'package:flutter/material.dart';
import '../model/ApprovalStepsResponse.dart';
import '../model/user_model/User.dart';

class UserLoanProfileProvider extends ChangeNotifier {
  List<StepMasterData> approvalStepsList = [];
  List<String> addressList = [];

  setPartnerList(List<StepMasterData> list) {
    approvalStepsList = List<StepMasterData>.empty();
    approvalStepsList = list;
    addressList = list[2].dropdownVal.split(",");
    notifyListeners();
  }

  List<ProfileData> profileData = [];

  void setData(List<ProfileData> data) {
    profileData = [];
    profileData = data;
    notifyListeners();
  }

  UserConfigUrl configUrl = UserConfigUrl(
      categoryImgUrl: '',
      farmerDocumentsUrl: '',
      cropVerityImgUrl: '',
      blogsTagsUrl: '',
      partnerImgUrl: '',
      farmDoc: '',
      cropTypeUrl: '',
      productImageUrl: '',
      mediaThumbnails: '',
      farmImageUrl: '',
      bottomMenuIcon: '',
      loanImageUrl: '',
      notice: '',
      cropHealthPredictApi: '',
      marketCatImageUrl: '',
      createdBlogsUrl: '',
      cropFertiImgUrl: '',
      advertiseImageUrl: '',
      announcement: '',
      dssModuleImageurl: '',
      aadharNoDocUrl: '',
      serviceImageUrl: '',
      insuranceCompany: '',
      soilHealthImage: '',
      cropImage: '',
      cropImageUrl: '',
      termsSheet: '',
      blogsTypesUrl: '',
      whitelabelImageUrl: '',
      panNoDocUrl: '');

  setUserConfigUrl(UserConfigUrl data) {
    configUrl = data;
    notifyListeners();
  }
}
