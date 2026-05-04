import 'package:buyer_common_code/model/MenuResponse.dart';
class User {
  int? success;
  int? error;
  int? status;
  UserData? data;
  String? message;
  UserConfigUrl? configUrl;
  List<dynamic>? whitelabelData;
  List<Menu>? menu;

  User(
      {this.success,
        this.error,
        this.status,
        this.data,
        this.message,
        this.configUrl,
        this.whitelabelData,
        this.menu});

  User.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    error = json['error'];
    status = json['status'];
    data = json['data'] != null ? UserData.fromJson(json['data']) : null;
    message = json['message'];
    configUrl = json['config_url'] != null
        ? UserConfigUrl.fromJson(json['config_url'])
        : null;
    // if (json['whitelabel_data'] != null) {
    //   whitelabelData = [];
    //   json['whitelabel_data'].forEach((v) {
    //     whitelabelData!.add(Null.fromJson(v));
    //   });
    // }
    if (json['menu'] != null) {
      menu = <Menu>[];
      json['menu'].forEach((v) {
        menu!.add(Menu.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['success'] = success;
    data['error'] = error;
    data['status'] = status;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    data['message'] = message;
    if (configUrl != null) {
      data['config_url'] = configUrl!.toJson();
    }
    if (whitelabelData != null) {
      data['whitelabel_data'] =
          whitelabelData!.map((v) => v.toJson()).toList();
    }
    if (menu != null) {
      data['menu'] = menu!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class UserData {
  String? userId;
  dynamic firstName;
  dynamic lastName;
  dynamic email;
  String? phone;
  dynamic address1;
  dynamic address2;
  dynamic city;
  dynamic postcode;
  dynamic countryName;
  dynamic stateName;
  dynamic branchName;
  dynamic bankName;
  dynamic state;
  dynamic accNo;
  dynamic ifscCode;
  dynamic village;
  dynamic panNo;
  dynamic gstNo;
  dynamic company;
  String? profileStatus;
  String? documentStatus;
  String? userType;
  dynamic profileImage;
  dynamic panNoDoc;
  dynamic aadharNoDoc;
  dynamic aadharNo;
  dynamic groupId;
  dynamic dob;
  dynamic gender;
  bool? loggedIn;
  bool? isLogin;
  String? myRefferalCode;
  dynamic iotDeviceUrl;
  String? aCCESSTOKEN;
  List<Countries>? countries;
  String? isWhitelabeled;
  String? isVideoEnable;
  String? isChatEnable;
  dynamic pacsMasterId;
  dynamic societyMasterId;
  dynamic bankMasterId;
  String? groupIds;
  String? appUserType;
  String? activeStep;

  UserData(
      {this.userId,
        this.firstName,
        this.lastName,
        this.email,
        this.phone,
        this.address1,
        this.address2,
        this.city,
        this.postcode,
        this.countryName,
        this.stateName,
        this.branchName,
        this.bankName,
        this.state,
        this.accNo,
        this.ifscCode,
        this.village,
        this.panNo,
        this.gstNo,
        this.company,
        this.profileStatus,
        this.documentStatus,
        this.userType,
        this.profileImage,
        this.panNoDoc,
        this.aadharNoDoc,
        this.aadharNo,
        this.groupId,
        this.dob,
        this.gender,
        this.loggedIn,
        this.isLogin,
        this.myRefferalCode,
        this.iotDeviceUrl,
        this.aCCESSTOKEN,
        this.countries,
        this.isWhitelabeled,
        this.isVideoEnable,
        this.isChatEnable,
        this.pacsMasterId,
        this.societyMasterId,
        this.bankMasterId,
        this.groupIds,
        this.appUserType,
        this.activeStep});

  UserData.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    email = json['email'];
    phone = json['phone'];
    address1 = json['address1'];
    address2 = json['address2'];
    city = json['city'];
    postcode = json['postcode'];
    countryName = json['country_name'];
    stateName = json['state_name'];
    branchName = json['branch_name'];
    bankName = json['bank_name'];
    state = json['state'];
    accNo = json['acc_no'];
    ifscCode = json['ifsc_code'];
    village = json['village'];
    panNo = json['pan_no'];
    gstNo = json['gst_no'];
    company = json['company'];
    profileStatus = json['profile_status'];
    documentStatus = json['document_status'];
    userType = json['user_type'];
    profileImage = json['profile_image'];
    panNoDoc = json['pan_no_doc'];
    aadharNoDoc = json['aadhar_no_doc'];
    aadharNo = json['aadhar_no'];
    groupId = json['group_id'];
    dob = json['dob'];
    gender = json['gender'];
    loggedIn = json['logged_in'];
    isLogin = json['is_login'];
    myRefferalCode = json['my_refferal_code'];
    iotDeviceUrl = json['iot_device_url'];
    aCCESSTOKEN = json['ACCESS_TOKEN'];
    if (json['countries'] != null) {
      countries = <Countries>[];
      json['countries'].forEach((v) {
        countries!.add(Countries.fromJson(v));
      });
    }
    isWhitelabeled = json['is_whitelabeled'];
    isVideoEnable = json['is_video_enable'];
    isChatEnable = json['is_chat_enable'];
    pacsMasterId = json['pacs_master_id'];
    societyMasterId = json['society_master_id'];
    bankMasterId = json['bank_master_id'];
    groupIds = json['group_ids'];
    appUserType = json['app_user_type'];
    activeStep = json['active_step'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['user_id'] = userId;
    data['first_name'] = firstName;
    data['last_name'] = lastName;
    data['email'] = email;
    data['phone'] = phone;
    data['address1'] = address1;
    data['address2'] = address2;
    data['city'] = city;
    data['postcode'] = postcode;
    data['country_name'] = countryName;
    data['state_name'] = stateName;
    data['branch_name'] = branchName;
    data['bank_name'] = bankName;
    data['state'] = state;
    data['acc_no'] = accNo;
    data['ifsc_code'] = ifscCode;
    data['village'] = village;
    data['pan_no'] = panNo;
    data['gst_no'] = gstNo;
    data['company'] = company;
    data['profile_status'] = profileStatus;
    data['document_status'] = documentStatus;
    data['user_type'] = userType;
    data['profile_image'] = profileImage;
    data['pan_no_doc'] = panNoDoc;
    data['aadhar_no_doc'] = aadharNoDoc;
    data['aadhar_no'] = aadharNo;
    data['group_id'] = groupId;
    data['dob'] = dob;
    data['gender'] = gender;
    data['logged_in'] = loggedIn;
    data['is_login'] = isLogin;
    data['my_refferal_code'] = myRefferalCode;
    data['iot_device_url'] = iotDeviceUrl;
    data['ACCESS_TOKEN'] = aCCESSTOKEN;
    if (countries != null) {
      data['countries'] = countries!.map((v) => v.toJson()).toList();
    }
    data['is_whitelabeled'] = isWhitelabeled;
    data['is_video_enable'] = isVideoEnable;
    data['is_chat_enable'] = isChatEnable;
    data['pacs_master_id'] = pacsMasterId;
    data['society_master_id'] = societyMasterId;
    data['bank_master_id'] = bankMasterId;
    data['group_ids'] = groupIds;
    data['app_user_type'] = appUserType;
    data['active_step'] = activeStep;
    return data;
  }
}

class Countries {
  String? code;
  String? name;
  String? regions;
  String? isDeleted;

  Countries({this.code, this.name, this.regions, this.isDeleted});

  Countries.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    name = json['name'];
    regions = json['regions'];
    isDeleted = json['is_deleted'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['code'] = code;
    data['name'] = name;
    data['regions'] = regions;
    data['is_deleted'] = isDeleted;
    return data;
  }
}

class UserConfigUrl {
  String? categoryImgUrl;
  String? partnerImgUrl;
  String? aadharNoDocUrl;
  String? panNoDocUrl;
  String? farmImageUrl;
  String? productImageUrl;
  String? marketCatImageUrl;
  String? serviceImageUrl;
  String? blogsTypesUrl;
  String? mediaTypes;
  String? blogsTagsUrl;
  String? createdBlogsUrl;
  String? farmerDocumentsUrl;
  String? advertiseImageUrl;
  String? whitelabelImageUrl;
  String? termsSheet;
  String? farmDoc;
  String? insuranceCompany;
  String? cropImageUrl;
  String? cropTypeUrl;
  String? notice;
  String? announcement;
  String? cropHealthPredictApi;
  String? dssModuleImageurl;
  String? bottomMenuIcon;
  String? cropVerityImgUrl;
  String? cropFertiImgUrl;
  String? soilHealthImage;
  String? mediaThumbnails;
  String? loanTypeUrl;
  String? loanImageUrl;
  String? cropImage;
  String? introScreenImgUrl;

  UserConfigUrl(
      {this.categoryImgUrl,
        this.partnerImgUrl,
        this.aadharNoDocUrl,
        this.panNoDocUrl,
        this.farmImageUrl,
        this.productImageUrl,
        this.marketCatImageUrl,
        this.serviceImageUrl,
        this.blogsTypesUrl,
        this.mediaTypes,
        this.blogsTagsUrl,
        this.createdBlogsUrl,
        this.farmerDocumentsUrl,
        this.advertiseImageUrl,
        this.whitelabelImageUrl,
        this.termsSheet,
        this.farmDoc,
        this.insuranceCompany,
        this.cropImageUrl,
        this.cropTypeUrl,
        this.notice,
        this.announcement,
        this.cropHealthPredictApi,
        this.dssModuleImageurl,
        this.bottomMenuIcon,
        this.cropVerityImgUrl,
        this.cropFertiImgUrl,
        this.soilHealthImage,
        this.mediaThumbnails,
        this.loanTypeUrl,
        this.loanImageUrl,
        this.cropImage,
        this.introScreenImgUrl});

  UserConfigUrl.fromJson(Map<String, dynamic> json) {
    categoryImgUrl = json['category_img_url'];
    partnerImgUrl = json['partner_img_url'];
    aadharNoDocUrl = json['aadhar_no_doc_url'];
    panNoDocUrl = json['pan_no_doc_url'];
    farmImageUrl = json['farm_image_url'];
    productImageUrl = json['Product_image_url'];
    marketCatImageUrl = json['market_cat_image_url'];
    serviceImageUrl = json['service_image_url'];
    blogsTypesUrl = json['blogs_types_url'];
    mediaTypes = json['media_types'];
    blogsTagsUrl = json['blogs_tags_url'];
    createdBlogsUrl = json['created_blogs_url'];
    farmerDocumentsUrl = json['farmer_documents_url'];
    advertiseImageUrl = json['advertise_image_url'];
    whitelabelImageUrl = json['whitelabel_image_url'];
    termsSheet = json['terms_sheet'];
    farmDoc = json['farm_doc'];
    insuranceCompany = json['insurance_company'];
    cropImageUrl = json['crop_image_url'];
    cropTypeUrl = json['crop_type_url'];
    notice = json['notice'];
    announcement = json['announcement'];
    cropHealthPredictApi = json['crop_health_predict_api'];
    dssModuleImageurl = json['dss_module_imageurl'];
    bottomMenuIcon = json['bottom_menu_icon'];
    cropVerityImgUrl = json['crop_verity_img_url'];
    cropFertiImgUrl = json['crop_ferti_img_url'];
    soilHealthImage = json['soil_health_image'];
    mediaThumbnails = json['media_thumbnails'];
    loanTypeUrl = json['loan_type_url'];
    loanImageUrl = json['loan_image_url'];
    cropImage = json['crop_image'];
    introScreenImgUrl = json['intro_screen_img_url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['category_img_url'] = categoryImgUrl;
    data['partner_img_url'] = partnerImgUrl;
    data['aadhar_no_doc_url'] = aadharNoDocUrl;
    data['pan_no_doc_url'] = panNoDocUrl;
    data['farm_image_url'] = farmImageUrl;
    data['Product_image_url'] = productImageUrl;
    data['market_cat_image_url'] = marketCatImageUrl;
    data['service_image_url'] = serviceImageUrl;
    data['blogs_types_url'] = blogsTypesUrl;
    data['media_types'] = mediaTypes;
    data['blogs_tags_url'] = blogsTagsUrl;
    data['created_blogs_url'] = createdBlogsUrl;
    data['farmer_documents_url'] = farmerDocumentsUrl;
    data['advertise_image_url'] = advertiseImageUrl;
    data['whitelabel_image_url'] = whitelabelImageUrl;
    data['terms_sheet'] = termsSheet;
    data['farm_doc'] = farmDoc;
    data['insurance_company'] = insuranceCompany;
    data['crop_image_url'] = cropImageUrl;
    data['crop_type_url'] = cropTypeUrl;
    data['notice'] = notice;
    data['announcement'] = announcement;
    data['crop_health_predict_api'] = cropHealthPredictApi;
    data['dss_module_imageurl'] = dssModuleImageurl;
    data['bottom_menu_icon'] = bottomMenuIcon;
    data['crop_verity_img_url'] = cropVerityImgUrl;
    data['crop_ferti_img_url'] = cropFertiImgUrl;
    data['soil_health_image'] = soilHealthImage;
    data['media_thumbnails'] = mediaThumbnails;
    data['loan_type_url'] = loanTypeUrl;
    data['loan_image_url'] = loanImageUrl;
    data['crop_image'] = cropImage;
    data['intro_screen_img_url'] = introScreenImgUrl;
    return data;
  }
}
