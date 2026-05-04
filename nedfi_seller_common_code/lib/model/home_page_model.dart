class HomeConfigurableModel {
  int? success;
  int? error;
  int? status;
  Data? data;
  String? message;
  ConfigUrl? configUrl;
  ConfigFlag? configFlag;

  HomeConfigurableModel({this.success, this.error, this.status, this.data, this.message, this.configUrl, this.configFlag});

  HomeConfigurableModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    error = json['error'];
    status = json['status'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
    message = json['message'];
    configUrl = json['config_url'] != null ? ConfigUrl.fromJson(json['config_url']) : null;
    configFlag = json['config_flag'] != null ? ConfigFlag.fromJson(json['config_flag']) : null;
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
    if (configFlag != null) {
      data['config_flag'] = configFlag!.toJson();
    }
    return data;
  }
}

class ConfigFlag {
  bool? showCart;
  bool? showCrop;
  bool? showQr;

  ConfigFlag({this.showCart, this.showCrop, this.showQr});

  ConfigFlag.fromJson(Map<String, dynamic> json) {
    showCart = json['show_cart'];
    showCrop = json['show_crop'];
    showQr = json['show_qr'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['show_cart'] = showCart!;
    data['show_crop'] = showCrop!;
    data['show_qr'] = showQr!;
    return data;
  }
}

class Data {
  List<MyCrops>? myCrops;
  Weather? weather;
  List<CommodityRateUpdates>? commodityRateUpdates;
  List<Advertise>? advertise;
  List<Recommended>? recommended;
  List<Services>? services;
  List<Blogs>? blogs;
  List<Media>? media;
  List<OtherServices>? otherServices;
  List<DssRecommended>? dssRecommended;

  Data({this.myCrops, this.weather, this.otherServices, this.commodityRateUpdates, this.advertise, this.recommended, this.services, this.blogs, this.media, this.dssRecommended});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['my_crops'] != null) {
      myCrops = <MyCrops>[];
      json['my_crops'].forEach((v) {
        myCrops!.add(MyCrops.fromJson(v));
      });
    }
    weather = json['weather'] != null ? Weather.fromJson(json['weather']) : null;
    if (json['commodity_rate_updates'] != null) {
      commodityRateUpdates = <CommodityRateUpdates>[];
      json['commodity_rate_updates'].forEach((v) {
        commodityRateUpdates!.add(CommodityRateUpdates.fromJson(v));
      });
    }
    if (json['advertise'] != null) {
      advertise = <Advertise>[];
      json['advertise'].forEach((v) {
        advertise!.add(Advertise.fromJson(v));
      });
    }
    if (json['recommended'] != null) {
      recommended = <Recommended>[];
      json['recommended'].forEach((v) {
        recommended!.add(Recommended.fromJson(v));
      });
    }
    if (json['services'] != null) {
      services = <Services>[];
      json['services'].forEach((v) {
        services!.add(Services.fromJson(v));
      });
    }
    if (json['other_services'] != null) {
      otherServices = <OtherServices>[];
      json['other_services'].forEach((v) {
        otherServices!.add(OtherServices.fromJson(v));
      });
    }
    if (json['blogs'] != null) {
      blogs = <Blogs>[];
      json['blogs'].forEach((v) {
        blogs!.add(Blogs.fromJson(v));
      });
    }
    if (json['media'] != null) {
      media = <Media>[];
      json['media'].forEach((v) {
        media!.add(Media.fromJson(v));
      });
    }
    if (json['dss_recommended'] != null) {
      dssRecommended = <DssRecommended>[];
      json['dss_recommended'].forEach((v) {
        dssRecommended!.add(DssRecommended.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (myCrops != null) {
      data['my_crops'] = myCrops!.map((v) => v.toJson()).toList();
    }
    if (weather != null) {
      data['weather'] = weather!.toJson();
    }
    if (commodityRateUpdates != null) {
      data['commodity_rate_updates'] = commodityRateUpdates!.map((v) => v.toJson()).toList();
    }
    if (advertise != null) {
      data['advertise'] = advertise!.map((v) => v.toJson()).toList();
    }
    if (recommended != null) {
      data['recommended'] = recommended!.map((v) => v.toJson()).toList();
    }
    if (services != null) {
      data['services'] = services!.map((v) => v.toJson()).toList();
    }
    if (otherServices != null) {
      data['other_services'] = otherServices!.map((v) => v.toJson()).toList();
    }
    if (blogs != null) {
      data['blogs'] = blogs!.map((v) => v.toJson()).toList();
    }
    if (media != null) {
      data['media'] = media!.map((v) => v.toJson()).toList();
    }
    if (dssRecommended != null) {
      data['dss_recommended'] = dssRecommended!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class MyCrops {
  String? id;
  String? clientId;
  String? landId;
  String? crop;
  String? cropType;
  String? areaUnderCultivation;
  String? unit;
  dynamic calculatedArea;
  dynamic createdById;
  String? createdOn;
  String? updatedOn;
  String? updatedById;
  String? isDeleted;
  String? deletedById;
  String? deletedOn;
  String? durationFrom;
  String? durationTo;
  dynamic cropName;
  dynamic cropNameMr;
  String? cropImage;
  String? name;
  String? logo;
  String? n;
  String? p;
  String? k;
  String? s;
  String? cropId;

  MyCrops(
      {this.id,
      this.clientId,
      this.landId,
      this.crop,
      this.cropType,
      this.areaUnderCultivation,
      this.unit,
      this.calculatedArea,
      this.createdById,
      this.createdOn,
      this.updatedOn,
      this.updatedById,
      this.isDeleted,
      this.deletedById,
      this.deletedOn,
      this.durationFrom,
      this.durationTo,
      this.cropName,
      this.cropNameMr,
      this.cropImage,
      this.name,
      this.logo,
      this.n,
      this.p,
      this.k,
      this.s,
      this.cropId});

  MyCrops.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    clientId = json['client_id'];
    landId = json['land_id'];
    crop = json['crop'];
    cropType = json['crop_type'];
    areaUnderCultivation = json['area_under_cultivation'];
    unit = json['unit'];
    calculatedArea = json['calculated_area'];
    createdById = json['created_by_id'];
    createdOn = json['created_on'];
    updatedOn = json['updated_on'];
    updatedById = json['updated_by_id'];
    isDeleted = json['is_deleted'];
    deletedById = json['deleted_by_id'];
    deletedOn = json['deleted_on'];
    durationFrom = json['duration_from'];
    durationTo = json['duration_to'];
    cropName = json['crop_name'];
    cropNameMr = json['crop_name_mr'];
    cropImage = json['crop_image'];
    name = json['name'];
    logo = json['logo'];
    n = json['n'];
    p = json['p'];
    k = json['k'];
    s = json['s'].toString();
    cropId = json['crop_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['client_id'] = clientId;
    data['land_id'] = landId;
    data['crop'] = crop;
    data['crop_type'] = cropType;
    data['area_under_cultivation'] = areaUnderCultivation;
    data['unit'] = unit;
    data['calculated_area'] = calculatedArea;
    data['created_by_id'] = createdById;
    data['created_on'] = createdOn;
    data['updated_on'] = updatedOn;
    data['updated_by_id'] = updatedById;
    data['is_deleted'] = isDeleted;
    data['deleted_by_id'] = deletedById;
    data['deleted_on'] = deletedOn;
    data['duration_from'] = durationFrom;
    data['duration_to'] = durationTo;
    data['crop_name'] = cropName;
    data['crop_name_mr'] = cropNameMr;
    data['crop_image'] = cropImage;
    data['name'] = name;
    data['logo'] = logo;
    data['n'] = n;
    data['p'] = p;
    data['k'] = k;
    data['s'] = s;
    data['crop_id'] = cropId;
    return data;
  }
}

class OtherServices {
  String? blogsId;
  String? logo;
  String? blogsTagsId;
  String? blogsTypesId;
  String? id;
  String? blogsTitle;
  String? blogsSubTitle;
  String? blogsDescription;
  String? blogsSubDescription;
  String? blogsCreatedOn;
  String? blogsTypesName;
  String? blogsTypesLogo;
  String? blogsTypesMobIcon;
  String? blogsTypesNameMr;

  OtherServices(
      {this.blogsId,
      this.logo,
      this.blogsTagsId,
      this.blogsTypesId,
      this.id,
      this.blogsTitle,
      this.blogsSubTitle,
      this.blogsDescription,
      this.blogsSubDescription,
      this.blogsCreatedOn,
      this.blogsTypesName,
      this.blogsTypesLogo,
      this.blogsTypesMobIcon,
      this.blogsTypesNameMr});

  OtherServices.fromJson(Map<String, dynamic> json) {
    blogsId = json['blogs_id'];
    logo = json['logo'];
    blogsTagsId = json['blogs_tags_id'];
    blogsTypesId = json['blogs_types_id'];
    id = json['id'];
    blogsTitle = json['blogs_title'];
    blogsSubTitle = json['blogs_sub_title'];
    blogsDescription = json['blogs_description'];
    blogsSubDescription = json['blogs_sub_description'];
    blogsCreatedOn = json['blogs_created_on'];
    blogsTypesName = json['blogs_types_name'];
    blogsTypesLogo = json['blogs_types_logo'];
    blogsTypesMobIcon = json['blogs_types_mob_icon'];
    blogsTypesNameMr = json['blogs_types_name_mr'];
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
    data['blogs_description'] = blogsDescription;
    data['blogs_sub_description'] = blogsSubDescription;
    data['blogs_created_on'] = blogsCreatedOn;
    data['blogs_types_name'] = blogsTypesName;
    data['blogs_types_logo'] = blogsTypesLogo;
    data['blogs_types_mob_icon'] = blogsTypesMobIcon;
    data['blogs_types_name_mr'] = blogsTypesNameMr;
    return data;
  }
}

class DssRecommended {
  String? blogsId;
  String? logo;
  String? blogsTagsId;
  String? blogsTypesId;
  String? id;
  String? blogsTitle;
  String? blogsSubTitle;
  String? blogsDescription;
  String? blogsSubDescription;
  String? blogsCreatedOn;
  String? blogsTypesName;
  String? blogsTypesLogo;
  String? blogsTypesMobIcon;
  String? blogsTypesNameMr;

  DssRecommended(
      {this.blogsId,
      this.logo,
      this.blogsTagsId,
      this.blogsTypesId,
      this.id,
      this.blogsTitle,
      this.blogsSubTitle,
      this.blogsDescription,
      this.blogsSubDescription,
      this.blogsCreatedOn,
      this.blogsTypesName,
      this.blogsTypesLogo,
      this.blogsTypesMobIcon,
      this.blogsTypesNameMr});

  DssRecommended.fromJson(Map<String, dynamic> json) {
    blogsId = json['blogs_id'];
    logo = json['logo'];
    blogsTagsId = json['blogs_tags_id'];
    blogsTypesId = json['blogs_types_id'];
    id = json['id'];
    blogsTitle = json['blogs_title'];
    blogsSubTitle = json['blogs_sub_title'];
    blogsDescription = json['blogs_description'];
    blogsSubDescription = json['blogs_sub_description'];
    blogsCreatedOn = json['blogs_created_on'];
    blogsTypesName = json['blogs_types_name'];
    blogsTypesLogo = json['blogs_types_logo'];
    blogsTypesMobIcon = json['blogs_types_mob_icon'];
    blogsTypesNameMr = json['blogs_types_name_mr'];
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
    data['blogs_description'] = blogsDescription;
    data['blogs_sub_description'] = blogsSubDescription;
    data['blogs_created_on'] = blogsCreatedOn;
    data['blogs_types_name'] = blogsTypesName;
    data['blogs_types_logo'] = blogsTypesLogo;
    data['blogs_types_mob_icon'] = blogsTypesMobIcon;
    data['blogs_types_name_mr'] = blogsTypesNameMr;
    return data;
  }
}

class Weather {
  bool? display;

  Weather({this.display});

  Weather.fromJson(Map<String, dynamic> json) {
    display = json['display'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['display'] = display;
    return data;
  }
}

class CommodityRateUpdates {
  String? market;
  String? commodityTitle;
  String? commodity;
  String? variety;
  String? minPrice;
  String? maxPrice;
  String? arrivalDate;
  String? newdateformat;
  String? arrivals;
  String? unitofarrivals;
  String? modalprices;
  String? unitofprice;
  String? logo;
  String? mapKey;

  CommodityRateUpdates(
      {this.market,
      this.commodityTitle,
      this.commodity,
      this.variety,
      this.minPrice,
      this.maxPrice,
      this.arrivalDate,
      this.newdateformat,
      this.arrivals,
      this.mapKey,
      this.unitofarrivals,
      this.modalprices,
      this.unitofprice,
      this.logo});

  CommodityRateUpdates.fromJson(Map<String, dynamic> json) {
    market = json['market'];
    commodityTitle = json['commodity_title'];
    commodity = json['commodity'];
    variety = json['variety'];
    minPrice = json['min_price'];
    maxPrice = json['max_price'];
    arrivalDate = json['arrival_date'];
    newdateformat = json['newdateformat'];
    arrivals = json['arrivals'];
    unitofarrivals = json['unitofarrivals'];
    modalprices = json['modalprices'];
    unitofprice = json['unitofprice'];
    logo = json['logo'];
    mapKey = json['map_key'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['market'] = market;
    data['commodity_title'] = commodityTitle;
    data['commodity'] = commodity;
    data['variety'] = variety;
    data['min_price'] = minPrice;
    data['max_price'] = maxPrice;
    data['arrival_date'] = arrivalDate;
    data['newdateformat'] = newdateformat;
    data['arrivals'] = arrivals;
    data['unitofarrivals'] = unitofarrivals;
    data['modalprices'] = modalprices;
    data['unitofprice'] = unitofprice;
    data['logo'] = logo;
    data['map_key'] = mapKey;
    return data;
  }
}

class Advertise {
  String? id;
  dynamic userId;
  String? name;
  dynamic nameMr;
  String? status;
  String? linkUrl;
  String? seq;
  String? logo;
  String? mobIcon;
  String? createdOn;
  String? updatedOn;
  String? deletedOn;
  String? isDeleted;
  String? deletedById;
  String? isActive;
  String? isVerify;
  String? createdById;
  String? updatedById;
  String? addedByUser;
  dynamic isExternal;
  String? bankId;

  Advertise(
      {this.id,
      this.userId,
      this.name,
      this.nameMr,
      this.status,
      this.linkUrl,
      this.seq,
      this.logo,
      this.mobIcon,
      this.createdOn,
      this.updatedOn,
      this.deletedOn,
      this.isDeleted,
      this.deletedById,
      this.isActive,
      this.isVerify,
      this.createdById,
      this.updatedById,
      this.addedByUser,
      this.isExternal,
      this.bankId});

  Advertise.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    name = json['name'];
    nameMr = json['name_mr'];
    status = json['status'];
    linkUrl = json['link_url'];
    seq = json['seq'];
    logo = json['logo'];
    mobIcon = json['mob_icon'];
    createdOn = json['created_on'];
    updatedOn = json['updated_on'];
    deletedOn = json['deleted_on'];
    isDeleted = json['is_deleted'];
    deletedById = json['deleted_by_id'];
    isActive = json['is_active'];
    isVerify = json['is_verify'];
    createdById = json['created_by_id'];
    updatedById = json['updated_by_id'];
    addedByUser = json['added_by_user'];
    isExternal = json['is_external'];
    bankId = json['bank_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['user_id'] = userId;
    data['name'] = name;
    data['name_mr'] = nameMr;
    data['status'] = status;
    data['link_url'] = linkUrl;
    data['seq'] = seq;
    data['logo'] = logo;
    data['mob_icon'] = mobIcon;
    data['created_on'] = createdOn;
    data['updated_on'] = updatedOn;
    data['deleted_on'] = deletedOn;
    data['is_deleted'] = isDeleted;
    data['deleted_by_id'] = deletedById;
    data['is_active'] = isActive;
    data['is_verify'] = isVerify;
    data['created_by_id'] = createdById;
    data['updated_by_id'] = updatedById;
    data['added_by_user'] = addedByUser;
    data['is_external'] = isExternal;
    data['bank_id'] = bankId;
    return data;
  }
}

class Recommended {
  String? id;
  String? partnerId;
  String? categoryId;
  dynamic subCategoryId;
  String? productName;
  String? overview;
  String? brief;
  String? highlight;
  dynamic usage;
  dynamic support;
  dynamic version;
  String? logo;
  dynamic demoUrl;
  String? createdById;
  String? createdOn;
  String? updatedById;
  String? updatedOn;
  String? isDeleted;
  dynamic deletedById;
  dynamic deletedOn;
  dynamic type;
  dynamic productOffered;
  dynamic registerApi;
  dynamic packageNote;
  dynamic programmingLang;
  dynamic otherProgrammingLang;
  dynamic framework;
  dynamic otherFramework;
  String? userManual;
  dynamic caseStudy;
  dynamic defaultCredentialData;
  dynamic clientLoginUrl;
  String? status;
  dynamic productScore;
  String? infraMinCost;
  String? infraMaxCost;
  dynamic seoUrl;
  String? productType;
  dynamic productKind;
  String? price;
  dynamic vendorId;
  dynamic isCod;
  String? isPublish;
  String? inStock;
  String? inStockAlert;
  String? purchaseLimit;
  String? unit;
  String? deliveryDays;
  String? locationType;
  String? pickupLocationIds;
  String? isActive;
  dynamic images;
  dynamic mrp;
  dynamic discount;
  String? flatRate;
  String? unitDesc;

  Recommended(
      {this.id,
      this.partnerId,
      this.categoryId,
      this.subCategoryId,
      this.productName,
      this.overview,
      this.brief,
      this.highlight,
      this.usage,
      this.support,
      this.version,
      this.logo,
      this.demoUrl,
      this.createdById,
      this.createdOn,
      this.updatedById,
      this.updatedOn,
      this.isDeleted,
      this.deletedById,
      this.deletedOn,
      this.type,
      this.productOffered,
      this.registerApi,
      this.packageNote,
      this.programmingLang,
      this.otherProgrammingLang,
      this.framework,
      this.otherFramework,
      this.userManual,
      this.caseStudy,
      this.defaultCredentialData,
      this.clientLoginUrl,
      this.status,
      this.productScore,
      this.infraMinCost,
      this.infraMaxCost,
      this.seoUrl,
      this.productType,
      this.productKind,
      this.price,
      this.vendorId,
      this.isCod,
      this.isPublish,
      this.inStock,
      this.inStockAlert,
      this.purchaseLimit,
      this.unit,
      this.deliveryDays,
      this.locationType,
      this.pickupLocationIds,
      this.isActive,
      this.images,
      this.mrp,
      this.discount,
      this.flatRate,
      this.unitDesc});

  Recommended.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    partnerId = json['partner_id'];
    categoryId = json['category_id'];
    subCategoryId = json['sub_category_id'];
    productName = json['product_name'];
    overview = json['overview'];
    brief = json['brief'];
    highlight = json['highlight'];
    usage = json['usage'];
    support = json['support'];
    version = json['version'];
    logo = json['logo'];
    demoUrl = json['demo_url'];
    createdById = json['created_by_id'];
    createdOn = json['created_on'];
    updatedById = json['updated_by_id'];
    updatedOn = json['updated_on'];
    isDeleted = json['is_deleted'];
    deletedById = json['deleted_by_id'];
    deletedOn = json['deleted_on'];
    type = json['type'];
    productOffered = json['product_offered'];
    registerApi = json['register_api'];
    packageNote = json['package_note'];
    programmingLang = json['programming_lang'];
    otherProgrammingLang = json['other_programming_lang'];
    framework = json['framework'];
    otherFramework = json['other_framework'];
    userManual = json['user_manual'];
    caseStudy = json['case_study'];
    defaultCredentialData = json['default_credential_data'];
    clientLoginUrl = json['client_login_url'];
    status = json['status'];
    productScore = json['product_score'];
    infraMinCost = json['infra_min_cost'];
    infraMaxCost = json['infra_max_cost'];
    seoUrl = json['seo_url'];
    productType = json['product_type'];
    productKind = json['product_kind'];
    price = json['price'];
    vendorId = json['vendor_id'];
    isCod = json['is_cod'];
    isPublish = json['is_publish'];
    inStock = json['in_stock'] ?? "0";
    inStockAlert = json['in_stock_alert'];
    purchaseLimit = json['purchase_limit'];
    unit = json['unit'];
    deliveryDays = json['delivery_days'];
    locationType = json['location_type'];
    pickupLocationIds = json['pickup_location_ids'];
    isActive = json['is_active'];
    images = json['images'];
    mrp = json['mrp'];
    discount = json['discount'];
    flatRate = json['flat_rate'];
    unitDesc = json['unit_desc'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = id;
    data['partner_id'] = partnerId;
    data['category_id'] = categoryId;
    data['sub_category_id'] = subCategoryId;
    data['product_name'] = productName;
    data['overview'] = overview;
    data['brief'] = brief;
    data['highlight'] = highlight;
    data['usage'] = usage;
    data['support'] = support;
    data['version'] = version;
    data['logo'] = logo;
    data['demo_url'] = demoUrl;
    data['created_by_id'] = createdById;
    data['created_on'] = createdOn;
    data['updated_by_id'] = updatedById;
    data['updated_on'] = updatedOn;
    data['is_deleted'] = isDeleted;
    data['deleted_by_id'] = deletedById;
    data['deleted_on'] = deletedOn;
    data['type'] = type;
    data['product_offered'] = productOffered;
    data['register_api'] = registerApi;
    data['package_note'] = packageNote;
    data['programming_lang'] = programmingLang;
    data['other_programming_lang'] = otherProgrammingLang;
    data['framework'] = framework;
    data['other_framework'] = otherFramework;
    data['user_manual'] = userManual;
    data['case_study'] = caseStudy;
    data['default_credential_data'] = defaultCredentialData;
    data['client_login_url'] = clientLoginUrl;
    data['status'] = status;
    data['product_score'] = productScore;
    data['infra_min_cost'] = infraMinCost;
    data['infra_max_cost'] = infraMaxCost;
    data['seo_url'] = seoUrl;
    data['product_type'] = productType;
    data['product_kind'] = productKind;
    data['price'] = price;
    data['vendor_id'] = vendorId;
    data['is_cod'] = isCod;
    data['is_publish'] = isPublish;
    data['in_stock'] = inStock;
    data['in_stock_alert'] = inStockAlert;
    data['purchase_limit'] = purchaseLimit;
    data['unit'] = unit;
    data['delivery_days'] = deliveryDays;
    data['location_type'] = locationType;
    data['pickup_location_ids'] = pickupLocationIds;
    data['is_active'] = isActive;
    data['images'] = images;
    data['mrp'] = mrp;
    data['discount'] = discount;
    data['flat_rate'] = flatRate;
    data['unit_desc'] = unitDesc;
    return data;
  }
}

class Services {
  String? catId;
  String? nameMr;
  String? logo;
  String? mobIcon;
  String? name;
  String? mapKey;

  Services({this.catId, this.nameMr, this.logo, this.mobIcon, this.name, this.mapKey});

  Services.fromJson(Map<String, dynamic> json) {
    catId = json['cat_id'];
    nameMr = json['name_mr'];
    logo = json['logo'];
    mobIcon = json['mob_icon'];
    name = json['name'];
    mapKey = json['map_key'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['cat_id'] = catId;
    data['name_mr'] = nameMr;
    data['logo'] = logo;
    data['mob_icon'] = mobIcon;
    data['name'] = name;
    data['map_key'] = mapKey;
    return data;
  }
}

class Blogs {
  String? blogsId;
  String? logo;
  String? blogsTagsId;
  String? blogsTypesId;
  String? id;
  String? blogsTitle;
  String? blogsSubTitle;
  String? blogsDescription;
  String? blogsSubDescription;
  String? blogsCreatedOn;
  String? blogsTypesName;
  String? blogsTypesLogo;
  String? blogsTypesMobIcon;
  String? blogsTypesNameMr;

  Blogs(
      {this.blogsId,
      this.logo,
      this.blogsTagsId,
      this.blogsTypesId,
      this.id,
      this.blogsTitle,
      this.blogsSubTitle,
      this.blogsDescription,
      this.blogsSubDescription,
      this.blogsCreatedOn,
      this.blogsTypesName,
      this.blogsTypesLogo,
      this.blogsTypesMobIcon,
      this.blogsTypesNameMr});

  Blogs.fromJson(Map<String, dynamic> json) {
    blogsId = json['blogs_id'];
    logo = json['logo'];
    blogsTagsId = json['blogs_tags_id'];
    blogsTypesId = json['blogs_types_id'];
    id = json['id'];
    blogsTitle = json['blogs_title'];
    blogsSubTitle = json['blogs_sub_title'];
    blogsDescription = json['blogs_description'];
    blogsSubDescription = json['blogs_sub_description'];
    blogsCreatedOn = json['blogs_created_on'];
    blogsTypesName = json['blogs_types_name'];
    blogsTypesLogo = json['blogs_types_logo'];
    blogsTypesMobIcon = json['blogs_types_mob_icon'];
    blogsTypesNameMr = json['blogs_types_name_mr'];
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
    data['blogs_description'] = blogsDescription;
    data['blogs_sub_description'] = blogsSubDescription;
    data['blogs_created_on'] = blogsCreatedOn;
    data['blogs_types_name'] = blogsTypesName;
    data['blogs_types_logo'] = blogsTypesLogo;
    data['blogs_types_mob_icon'] = blogsTypesMobIcon;
    data['blogs_types_name_mr'] = blogsTypesNameMr;
    return data;
  }
}

class Media {
  String? mediaId;
  String? url;
  String? urlType;
  String? title;
  String? description;
  String? partnerId;
  String? category;
  String? publishedOn;
  String? thumbnails;
  dynamic viewCount;
  String? isHome;
  String? isFeatured;

  Media({this.mediaId, this.url, this.urlType, this.title, this.description, this.partnerId, this.category, this.publishedOn, this.thumbnails, this.viewCount, this.isHome, this.isFeatured});

  Media.fromJson(Map<String, dynamic> json) {
    mediaId = json['media_id'];
    url = json['url'];
    urlType = json['url_type'];
    title = json['title'];
    description = json['description'];
    partnerId = json['partner_id'];
    category = json['category'];
    publishedOn = json['published_on'];
    thumbnails = json['thumbnails'];
    viewCount = json['view_count'];
    isHome = json['is_home'];
    isFeatured = json['is_featured'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['media_id'] = mediaId;
    data['url'] = url;
    data['url_type'] = urlType;
    data['title'] = title;
    data['description'] = description;
    data['partner_id'] = partnerId;
    data['category'] = category;
    data['published_on'] = publishedOn;
    data['thumbnails'] = thumbnails;
    data['view_count'] = viewCount;
    data['is_home'] = isHome;
    data['is_featured'] = isFeatured;
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
  String? mediaTypesUrl;
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
  String? loanTypeUrl;
  String? tradeProducts;
  String? partner_business_logo;

  ConfigUrl({
    this.categoryImgUrl,
    this.partnerImgUrl,
    this.aadharNoDocUrl,
    this.panNoDocUrl,
    this.farmImageUrl,
    this.productImageUrl,
    this.marketCatImageUrl,
    this.serviceImageUrl,
    this.blogsTypesUrl,
    this.mediaTypesUrl,
    this.loanTypeUrl,
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
    this.cropImage,
    this.tradeProducts,
    this.partner_business_logo
  });

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
    mediaTypesUrl = json['media_types'];
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
    loanTypeUrl = json['loan_type_url'];
    tradeProducts = json['trade_products'];
    partner_business_logo = json['partner_business_logo'];
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
    data['media_types'] = mediaTypesUrl;
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
    data['loan_type_url'] = loanTypeUrl;
    data['trade_products'] = tradeProducts;
    data['partner_business_logo'] = partner_business_logo;
    return data;
  }
}

class NewCommoditydata {
  String? id;
  String? marketId;
  String? marketName;
  String? productName;
  String? variety;
  String? marketwiseapmcpricedate;
  String? minimumprices;
  String? maximumprices;
  String? modalprices;
  String? unitofprice;
  String? arrivals;
  String? isActive;
  String? latitude;
  String? longitude;
  String? logo;
  bool isLocationPermissionItem=false;



  NewCommoditydata(
      {this.id,
        this.marketId,
        this.marketName,
        this.productName,
        this.variety,
        this.marketwiseapmcpricedate,
        this.minimumprices,
        this.maximumprices,
        this.modalprices,
        this.unitofprice,
        this.arrivals,
        this.isActive,
        this.latitude,
        this.logo,
        this.longitude,this.isLocationPermissionItem = false,});

  NewCommoditydata.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    marketId = json['market_id'];
    marketName = json['market_name'];
    productName = json['product_name'];
    variety = json['variety'];
    marketwiseapmcpricedate = json['marketwiseapmcpricedate'];
    minimumprices = json['minimumprices'];
    maximumprices = json['maximumprices'];
    modalprices = json['modalprices'];
    unitofprice = json['unitofprice'];
    arrivals = json['arrivals'];
    isActive = json['is_active'];
    latitude = json['latitude'];
    logo = json['logo'];
    longitude = json['longitude'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['market_id'] = this.marketId;
    data['market_name'] = this.marketName;
    data['product_name'] = this.productName;
    data['variety'] = this.variety;
    data['marketwiseapmcpricedate'] = this.marketwiseapmcpricedate;
    data['minimumprices'] = this.minimumprices;
    data['maximumprices'] = this.maximumprices;
    data['modalprices'] = this.modalprices;
    data['unitofprice'] = this.unitofprice;
    data['arrivals'] = this.arrivals;
    data['is_active'] = this.isActive;
    data['latitude'] = this.latitude;
    data['logo'] = this.logo;
    data['longitude'] = this.longitude;
    return data;
  }
}
