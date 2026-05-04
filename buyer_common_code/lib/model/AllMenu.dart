class AllMenu {
  int? status;
  AllMenuData? data;
  ConfigUrl? configUrl;
  String? message;

  AllMenu({this.status, this.data, this.configUrl, this.message});

  AllMenu.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    data = json['data'] != null ? AllMenuData.fromJson(json['data']) : null;
    configUrl = json['config_url'] != null ? ConfigUrl.fromJson(json['config_url']) : null;
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    if (configUrl != null) {
      data['config_url'] = configUrl!.toJson();
    }
    data['message'] = message;
    return data;
  }
}

class AllMenuData {
  List<BottomMenu>? bottomMenu;
  List<BottomMenu>? sidebarMenu;
  List<BottomMenu>? marketMenu;
  List<BottomMenu>? settingMenu;
  List<BottomMenu>? dssMenu;
  List<BottomMenu>? pickupDeliveryMenu;

  AllMenuData({this.bottomMenu, this.sidebarMenu, this.marketMenu, this.settingMenu, this.dssMenu, this.pickupDeliveryMenu});

  AllMenuData.fromJson(Map<String, dynamic> json) {
    if (json['bottom_menu'] != null) {
      bottomMenu = <BottomMenu>[];
      json['bottom_menu'].forEach((v) {
        bottomMenu!.add(BottomMenu.fromJson(v));
      });
    }
    if (json['sidebar_menu'] != null) {
      sidebarMenu = <BottomMenu>[];
      json['sidebar_menu'].forEach((v) {
        sidebarMenu!.add(BottomMenu.fromJson(v));
      });
    }
    if (json['market_menu'] != null) {
      marketMenu = <BottomMenu>[];
      json['market_menu'].forEach((v) {
        marketMenu!.add(BottomMenu.fromJson(v));
      });
    }
    if (json['setting_menu'] != null) {
      settingMenu = <BottomMenu>[];
      json['setting_menu'].forEach((v) {
        settingMenu!.add(BottomMenu.fromJson(v));
      });
    }
    if (json['dss_menu'] != null) {
      dssMenu = <BottomMenu>[];
      json['dss_menu'].forEach((v) {
        dssMenu!.add(BottomMenu.fromJson(v));
      });
    }

    if (json['pickup_delivery_menu'] != null) {
      pickupDeliveryMenu = <BottomMenu>[];
      json['pickup_delivery_menu'].forEach((v) {
        pickupDeliveryMenu!.add(BottomMenu.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (bottomMenu != null) {
      data['bottom_menu'] = bottomMenu!.map((v) => v.toJson()).toList();
    }
    if (sidebarMenu != null) {
      data['sidebar_menu'] = sidebarMenu!.map((v) => v.toJson()).toList();
    }
    if (marketMenu != null) {
      data['market_menu'] = marketMenu!.map((v) => v.toJson()).toList();
    }
    if (settingMenu != null) {
      data['setting_menu'] = settingMenu!.map((v) => v.toJson()).toList();
    }
    if (dssMenu != null) {
      data['dss_menu'] = dssMenu!.map((v) => v.toJson()).toList();
    }
    if (pickupDeliveryMenu != null) {
      data['pickup_delivery_menu'] = pickupDeliveryMenu!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class BottomMenu {
  String? id;
  String? title;
  String? mapKey;
  String? icon;
  String? menuPosition;

  BottomMenu({this.id, this.title, this.mapKey, this.icon, this.menuPosition});

  BottomMenu.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    mapKey = json['map_key'];
    icon = json['icon'] ?? "";
    menuPosition = json['menu_position'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['map_key'] = mapKey;
    data['icon'] = icon;
    data['menu_position'] = menuPosition;
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
