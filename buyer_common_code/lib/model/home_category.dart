class HomeCategoryModel {
  HomeCategoryModel({
    required this.status,
    required this.data,
    required this.blogType,
    required this.configUrl,
    required this.homeMessage,
    required this.message,
  });

  late int? status;
  late List<HomeCategoryData>? data;
  late List<BlogType>? blogType;
  late ConfigUrl? configUrl;
  late HomeMessage? homeMessage;
  late String? message;

  HomeCategoryModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    data = List.from(json['data'])
        .map((e) => HomeCategoryData.fromJson(e))
        .toList();
    blogType =
        List.from(json['blog_type']).map((e) => BlogType.fromJson(e)).toList();
    configUrl = ConfigUrl.fromJson(json['config_url']);
    homeMessage = HomeMessage.fromJson(json['home_message']);
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['status'] = status;
    _data['data'] = data!.map((e) => e.toJson()).toList();
    _data['blog_type'] = blogType!.map((e) => e.toJson()).toList();
    _data['config_url'] = configUrl!.toJson();
    _data['home_message'] = homeMessage!.toJson();
    _data['message'] = message;
    return _data;
  }
}

class HomeCategoryData {
  HomeCategoryData({
    required this.catId,
    required this.name,
    required this.logo,
    required this.nameMr,
    required this.mobIcon,
  });

  late final String catId;
  late final String name;
  late final String logo;
  late final String nameMr;
  late final String mobIcon;

  HomeCategoryData.fromJson(Map<String, dynamic> json) {
    catId = json['cat_id'] ?? "";
    name = json['name'] ?? "";
    logo = json['logo'] ?? "";
    nameMr = json['name_mr'] ?? "";
    mobIcon = json['mob_icon'] ?? "";
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['cat_id'] = catId;
    _data['name'] = name;
    _data['logo'] = logo;
    _data['name_mr'] = nameMr;
    _data['mob_icon'] = mobIcon;
    return _data;
  }
}

class BlogType {
  BlogType({
    required this.blogsTypesId,
    required this.name,
    required this.logo,
    required this.nameMr,
    required this.mobIcon,
  });

  late final String blogsTypesId;
  late final String name;
  late final String logo;
  late final String nameMr;
  late final String mobIcon;

  BlogType.fromJson(Map<String, dynamic> json) {
    blogsTypesId = json['blogs_types_id'] ?? "";
    name = json['name'] ?? "";
    logo = json['logo'] ?? "";
    nameMr = json['name_mr'] ?? "";
    mobIcon = json['mob_icon'] ?? "";
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['blogs_types_id'] = blogsTypesId;
    _data['name'] = name;
    _data['logo'] = logo;
    _data['name_mr'] = nameMr;
    _data['mob_icon'] = mobIcon;
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

  ConfigUrl.fromJson(Map<String, dynamic> json) {
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
    advertiseImageUrl = json['advertise_image_url'] ?? "";
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
    return _data;
  }
}

class HomeMessage {
  HomeMessage({
    required this.message,
  });

  late final String message;

  HomeMessage.fromJson(Map<String, dynamic> json) {
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['message'] = message;
    return _data;
  }
}
