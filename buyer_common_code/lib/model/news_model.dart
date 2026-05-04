class NewsModel {
  int? status;
  List<Data>? data;
  ConfigUrl? configUrl;
  String? message;

  NewsModel({this.status, this.data, this.configUrl, this.message});

  NewsModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(Data.fromJson(v));
      });
    }
    configUrl = json['config_url'] != null
        ? ConfigUrl.fromJson(json['config_url'])
        : null;
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    if (configUrl != null) {
      data['config_url'] = configUrl!.toJson();
    }
    data['message'] = message;
    return data;
  }
}

class Data {
  String? blogsId;
  String? logo;
  String? blogsTagsId;
  String? blogsTypesId;
  String? id;
  String? blogsTitle;
  String? blogsSubTitle;
  String? blogsSubDescription;
  String? blogsCreatedOn;
  String? blogsTypesLogo;
  String? blogsTypesMobIcon;
  String? blogsTypesName;

  Data(
      {this.blogsId,
        this.logo,
        this.blogsTagsId,
        this.blogsTypesId,
        this.id,
        this.blogsTitle,
        this.blogsSubTitle,
        this.blogsSubDescription,
        this.blogsCreatedOn,
        this.blogsTypesLogo,
        this.blogsTypesMobIcon,
        this.blogsTypesName});

  Data.fromJson(Map<String, dynamic> json) {
    blogsId = json['blogs_id'];
    logo = json['logo'];
    blogsTagsId = json['blogs_tags_id'];
    blogsTypesId = json['blogs_types_id'];
    id = json['id'];
    blogsTitle = json['blogs_title'];
    blogsSubTitle = json['blogs_sub_title'];
    blogsSubDescription = json['blogs_sub_description'];
    blogsCreatedOn = json['blogs_created_on'];
    blogsTypesLogo = json['blogs_types_logo'];
    blogsTypesMobIcon = json['blogs_types_mob_icon'];
    blogsTypesName = json['blogs_types_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['blogs_id'] = blogsId;
    data['logo'] = logo;
    data['blogs_tags_id'] = blogsTagsId;
    data['blogs_types_id'] = blogsTypesId;
    data['id'] = id;
    data['blogs_title'] = blogsTitle;
    data['blogs_sub_title'] = blogsSubTitle;
    data['blogs_sub_description'] = blogsSubDescription;
    data['blogs_created_on'] = blogsCreatedOn;
    data['blogs_types_logo'] = blogsTypesLogo;
    data['blogs_types_mob_icon'] = blogsTypesMobIcon;
    data['blogs_types_name'] = blogsTypesName;
    return data;
  }
}

class ConfigUrl {
  String? categoryImgUrl;
  String? partnerImgUrl;
  String? aadharNoDocUrl;
  String? panNoDocUrl;
  String? farmImageUrl;
  String? productImageUrl;
  String? marketCatImageUrl;
  String? serviceImageUrl;
  String? blogsTypesUrl;
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
  String? loanImageUrl;
  String? cropImage;

  ConfigUrl(
      {this.categoryImgUrl,
        this.partnerImgUrl,
        this.aadharNoDocUrl,
        this.panNoDocUrl,
        this.farmImageUrl,
        this.productImageUrl,
        this.marketCatImageUrl,
        this.serviceImageUrl,
        this.blogsTypesUrl,
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
        this.loanImageUrl,
        this.cropImage});

  ConfigUrl.fromJson(Map<String, dynamic> json) {
    categoryImgUrl = json['category_img_url'];
    partnerImgUrl = json['partner_img_url'];
    aadharNoDocUrl = json['aadhar_no_doc_url'];
    panNoDocUrl = json['pan_no_doc_url'];
    farmImageUrl = json['farm_image_url'];
    productImageUrl = json['Product_image_url'];
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
    mediaThumbnails = json['media_thumbnails'];
    loanImageUrl = json['loan_image_url'];
    cropImage = json['crop_image'];
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
    data['loan_image_url'] = loanImageUrl;
    data['crop_image'] = cropImage;
    return data;
  }
}
