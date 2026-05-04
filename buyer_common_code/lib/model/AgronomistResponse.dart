
class AgronomistResponse{
  AgronomistResponse({
    required this.status,
    required this.data,
    required this.message,
   // required this.videocallprice,
  });
  late final String status;
  late final List<AgronomistData> data;
  late final String message;
 // late final List<Videocallprice> videocallprice;

  AgronomistResponse.fromJson(Map<String, dynamic> json){
    status = json['status'].toString();
    data = List.from(json['data']).map((e)=>AgronomistData.fromJson(e)).toList();
    message = json['message'];
    if(json['Video call price']!=null) {
     // videocallprice = List.from(json['Video call price']).map((e) =>
     //     Videocallprice.fromJson(e)).toList();
    }
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['status'] = status;
    _data['data'] = data.map((e)=>e.toJson()).toList();
    _data['message'] = message;
   // if(videocallprice!=null) {
     // _data['Video call price'] =
      //    videocallprice.map((e) => e.toJson()).toList();
    //}
    return _data;
  }
}

class AgronomistData {
  AgronomistData({
    required this.userId,
    required this.firstName,
    required this.lastName,
    required this.companyName,
    required this.phoneNo,
    required this.city,
    this.profileImage,
    required this.cropId,
    required this.userType,
    required this.type,
    required this.isVideoEnable,
    required this.isChatEnable,
    required this.expertise,
    required this.userExperiance,
    required this.rating,
    required this.price,
    required this.paymentStatus,
    this.availability,
  });
  late final String userId;
  late final String firstName;
  late final String lastName;
  late final String companyName;
  late final String phoneNo;
  late final String city;
  late final String? profileImage;
  late final String cropId;
  late final String userType;
  late final String type;
  late final String isVideoEnable;
  late final String isChatEnable;
  late final String expertise;
  late final String userExperiance;
  late final String rating;
  late final String price;
  late final String paymentStatus;
  late final String? availability;

  AgronomistData.fromJson(Map<String, dynamic> json){
    userId = json['user_id']??"";
    firstName = json['first_name']??"";
    lastName = json['last_name']??"";
    companyName = json['company_name']??"";
    phoneNo = json['phone_no']??"";
    city = json['city']??"";
    profileImage = json['profile_image']??"";
    cropId = json['crop_id']??"";
    userType = json['user_type']??"";
    type = json['type']??"";
    isVideoEnable = json['is_video_enable']??"";
    isChatEnable = json['is_chat_enable']??"";
    expertise = json['expertise']??"";
    userExperiance = json['user_experiance']??"";
    rating = json['rating']??"";
    price = json['price']??"";
    paymentStatus = json['payment_status']??"";
    availability = json['availability']??"";
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['user_id'] = userId;
    _data['first_name'] = firstName;
    _data['last_name'] = lastName;
    _data['company_name'] = companyName;
    _data['phone_no'] = phoneNo;
    _data['city'] = city;
    _data['profile_image'] = profileImage;
    _data['crop_id'] = cropId;
    _data['user_type'] = userType;
    _data['type'] = type;
    _data['is_video_enable'] = isVideoEnable;
    _data['is_chat_enable'] = isChatEnable;
    _data['expertise'] = expertise;
    _data['user_experiance'] = userExperiance;
    _data['rating'] = rating;
    _data['price'] = price;
    _data['payment_status'] = paymentStatus;
    _data['availability'] = availability;
    return _data;
  }
}

class ConfigUrl {
  ConfigUrl({
    required this.categoryImgUrl,
    required this.partnerImgUrl,
    required this.aadharNoDocUrl,
    required this.panNoDocUrl,
    required this.farmImageUrl,
    required this.ProductImageUrl,
    required this.marketCatImageUrl,
    required this.serviceImageUrl,
    required this.blogsTypesUrl,
    required this.blogsTagsUrl,
    required this.createdBlogsUrl,
    required this.farmerDocumentsUrl,
    required this.advertiseImageUrl,
    required this.whitelabelImageUrl,
    required this.termsSheet,
    required this.farmDoc,
    required this.insuranceCompany,
    required this.cropImageUrl,
    required this.cropTypeUrl,
    required this.notice,
    required this.announcement,
    required this.cropHealthPredictApi,
    required this.dssModuleImageurl,
    required this.bottomMenuIcon,
    required this.cropVerityImgUrl,
    required this.cropFertiImgUrl,
    required this.soilHealthImage,
    required this.loanImageUrl,
  });
  late final String categoryImgUrl;
  late final String partnerImgUrl;
  late final String aadharNoDocUrl;
  late final String panNoDocUrl;
  late final String farmImageUrl;
  late final String ProductImageUrl;
  late final String marketCatImageUrl;
  late final String serviceImageUrl;
  late final String blogsTypesUrl;
  late final String blogsTagsUrl;
  late final String createdBlogsUrl;
  late final String farmerDocumentsUrl;
  late final String advertiseImageUrl;
  late final String whitelabelImageUrl;
  late final String termsSheet;
  late final String farmDoc;
  late final String insuranceCompany;
  late final String cropImageUrl;
  late final String cropTypeUrl;
  late final String notice;
  late final String announcement;
  late final String cropHealthPredictApi;
  late final String dssModuleImageurl;
  late final String bottomMenuIcon;
  late final String cropVerityImgUrl;
  late final String cropFertiImgUrl;
  late final String soilHealthImage;
  late final String loanImageUrl;

  ConfigUrl.fromJson(Map<String, dynamic> json){
    categoryImgUrl = json['category_img_url'];
    partnerImgUrl = json['partner_img_url'];
    aadharNoDocUrl = json['aadhar_no_doc_url'];
    panNoDocUrl = json['pan_no_doc_url'];
    farmImageUrl = json['farm_image_url'];
    ProductImageUrl = json['Product_image_url'];
    marketCatImageUrl = json['market_cat_image_url'];
    serviceImageUrl = json['service_image_url'];
    blogsTypesUrl = json['blogs_types_url'];
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
    loanImageUrl = json['loan_image_url'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['category_img_url'] = categoryImgUrl;
    _data['partner_img_url'] = partnerImgUrl;
    _data['aadhar_no_doc_url'] = aadharNoDocUrl;
    _data['pan_no_doc_url'] = panNoDocUrl;
    _data['farm_image_url'] = farmImageUrl;
    _data['Product_image_url'] = ProductImageUrl;
    _data['market_cat_image_url'] = marketCatImageUrl;
    _data['service_image_url'] = serviceImageUrl;
    _data['blogs_types_url'] = blogsTypesUrl;
    _data['blogs_tags_url'] = blogsTagsUrl;
    _data['created_blogs_url'] = createdBlogsUrl;
    _data['farmer_documents_url'] = farmerDocumentsUrl;
    _data['advertise_image_url'] = advertiseImageUrl;
    _data['whitelabel_image_url'] = whitelabelImageUrl;
    _data['terms_sheet'] = termsSheet;
    _data['farm_doc'] = farmDoc;
    _data['insurance_company'] = insuranceCompany;
    _data['crop_image_url'] = cropImageUrl;
    _data['crop_type_url'] = cropTypeUrl;
    _data['notice'] = notice;
    _data['announcement'] = announcement;
    _data['crop_health_predict_api'] = cropHealthPredictApi;
    _data['dss_module_imageurl'] = dssModuleImageurl;
    _data['bottom_menu_icon'] = bottomMenuIcon;
    _data['crop_verity_img_url'] = cropVerityImgUrl;
    _data['crop_ferti_img_url'] = cropFertiImgUrl;
    _data['soil_health_image'] = soilHealthImage;
    _data['loan_image_url'] = loanImageUrl;
    return _data;
  }
}

class Videocallprice {
  Videocallprice({
  required this.id,
  this.logo,
  this.mobIcon,
  required this.description,
  required this.keyFields,
});
late final String id;
late final Null logo;
late final Null mobIcon;
late final String description;
late final String keyFields;

  Videocallprice.fromJson(Map<String, dynamic> json){
id = json['id'];
logo = null;
mobIcon = null;
description = json['description'];
keyFields = json['key_fields'];
}

Map<String, dynamic> toJson() {
  final _data = <String, dynamic>{};
  _data['id'] = id;
  _data['logo'] = logo;
  _data['mob_icon'] = mobIcon;
  _data['description'] = description;
  _data['key_fields'] = keyFields;
  return _data;
}
}

