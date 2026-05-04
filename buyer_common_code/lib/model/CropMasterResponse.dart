class CropMasterResponse {
  CropMasterResponse({
    required this.status,
    required this.data,
    required this.customData,
    required this.crop,
    required this.cropType,
    required this.unit,
    required this.message,
    required this.configUrl,
  });
  late final int status;
   List<CropMasterData> data=[];
   List<CustomData> customData=[];
   List<Crop> crop=[];
  List<CropType> cropType=[];
  List<Unit> unit=[];
  late final String message;
  late final ConfigUrl configUrl;

  CropMasterResponse.fromJson(Map<String, dynamic> json){
    status = json['status'];
    if(json['data']!=null) {
      data = List.from(json['data']).map((e)=>CropMasterData.fromJson(e)).toList();
    }
    if(json['custom_data']!=null) {
      customData = List.from(json['custom_data'])
          .map((e) => CustomData.fromJson(e))
          .toList();
    }
    if(json['crop']!=null) {
      crop = List.from(json['crop']).map((e) => Crop.fromJson(e)).toList();
    }
    if(json['crop_type']!=null) {
      cropType = List.from(json['crop_type'])
          .map((e) => CropType.fromJson(e))
          .toList();
    }
    if(json['unit']!=null) {
      unit = List.from(json['unit']).map((e) => Unit.fromJson(e)).toList();
    }
    message = json['message'];
    if(json['config_url']!=null) {
      configUrl = ConfigUrl.fromJson(json['config_url']);
    }
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['status'] = status;
    _data['data'] = data.map((e)=>e.toJson()).toList();
    _data['custom_data'] = customData.map((e)=>e.toJson()).toList();
    _data['crop'] = crop.map((e)=>e.toJson()).toList();
    _data['crop_type'] = cropType.map((e)=>e.toJson()).toList();
    _data['unit'] = unit.map((e)=>e.toJson()).toList();
    _data['message'] = message;
    _data['config_url'] = configUrl.toJson();
    return _data;
  }
}

class CropMasterData {
  CropMasterData({
    required this.id,
    required this.farmerId,
    required this.clientId,
    required this.landId,
    required this.name,
    required this.nameMr,
    required this.crop,
    this.cropName,
    this.cropImage,
    required this.cropType,
    required this.areaUnderCultivation,
    required this.unit,
    required this.durationFrom,
    required this.durationTo,
    required this.farmName,
    required this.cropId,
    required this.durationDays,
    this.stateId,
    this.citiesId,
    this.doc_7_12,
    this.cityName,
    this.cropTypeIcon,
    required this.cropTypeName,
    required this.cropLogo,
  });
  late final String id;
  late final String farmerId;
  late final String clientId;
  late final String landId;
  late final String name;
  late final String nameMr;
  late final String crop;
  late final String? cropName;
  late final String? cropImage;
  late final String cropType;
  late final String areaUnderCultivation;
  late final String unit;
  late final String durationFrom;
  late final String durationTo;
  late final String farmName;
  late final String cropId;
  late final String durationDays;
  late final String? stateId;
  late final String? citiesId;
  late final String? doc_7_12;
  late final String? cityName;
  late final String? cropTypeIcon;
  late final String cropTypeName;
  late final String cropLogo;

  CropMasterData.fromJson(Map<String, dynamic> json){
    id = json['id']??"";
    farmerId = json['farmer_id']??"";
    clientId = json['client_id']??"";
    landId = json['land_id']??"";
    name = json['name']??"";
    nameMr = json['name_mr']??"";
    crop = json['crop']??"";
    cropName = json['crop_name']??"";
    cropImage = json['crop_image']??"";
    cropType = json['crop_type']??"";
    areaUnderCultivation = json['area_under_cultivation']??"";
    unit = json['unit']??"";
    durationFrom = json['duration_from']??"";
    durationTo = json['duration_to']??"";
    farmName = json['farm_name']??"";
    cropId = json['crop_id']??"";
    durationDays = json['duration_days']??"";
    stateId = json['state_id']??"";
    citiesId = json['cities_id']??"";
    doc_7_12 = json['doc_7_12']??"";
    cityName = json['city_name']??"";
    cropTypeIcon = json['crop_type_icon']??"";
    cropTypeName = json['crop_type_name']??"";
    cropLogo = json['crop_logo']??"";
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['farmer_id'] = farmerId;
    _data['client_id'] = clientId;
    _data['land_id'] = landId;
    _data['name'] = name;
    _data['name_mr'] = nameMr;
    _data['crop'] = crop;
    _data['crop_name'] = cropName;
    _data['crop_image'] = cropImage;
    _data['crop_type'] = cropType;
    _data['area_under_cultivation'] = areaUnderCultivation;
    _data['unit'] = unit;
    _data['duration_from'] = durationFrom;
    _data['duration_to'] = durationTo;
    _data['farm_name'] = farmName;
    _data['crop_id'] = cropId;
    _data['duration_days'] = durationDays;
    _data['state_id'] = stateId;
    _data['cities_id'] = citiesId;
    _data['doc_7_12'] = doc_7_12;
    _data['city_name'] = cityName;
    _data['crop_type_icon'] = cropTypeIcon;
    _data['crop_type_name'] = cropTypeName;
    _data['crop_logo'] = cropLogo;
    return _data;
  }
}

class CustomData {
  CustomData({
    required this.landId,
    required this.id,
    required this.crop,
    required this.cropId,
    required this.cropName,
    required this.cropNameMr,
    required this.cropType,
    required this.cropTypeName,
    required this.cropTypeNameMr,
    required this.unit,
    required this.unitName,
    required this.unitNameMr,
    required this.areaUnderCultivation,
    required this.durationFrom,
    required this.durationTo,
    required this.cropImage,
    required this.farmName,
    this.stateId,
    this.citiesId,
    this.doc_7_12,
    this.farmNameMr,
    required this.durationDays,
    this.cityName,
    required this.isInsured,
    required this.insuranceId,
    this.insuranceStatus,
    required this.isInsurancePlan,
    this.cropTypeIcon,
  });
  late final String landId;
  late final String id;
  late final String crop;
  late final String cropId;
  late final String cropName;
  late final String cropNameMr;
  late final String cropType;
  late final String cropTypeName;
  late final String cropTypeNameMr;
  late final String unit;
  late final String unitName;
  late final String unitNameMr;
  late final String areaUnderCultivation;
  late final String durationFrom;
  late final String durationTo;
  late final String cropImage;
  late final String farmName;
  late final Null stateId;
  late final Null citiesId;
  late final Null doc_7_12;
  late final Null farmNameMr;
  late final String durationDays;
  late final Null cityName;
  late final int isInsured;
  late final int insuranceId;
  late final Null insuranceStatus;
  late final int isInsurancePlan;
  late final String? cropTypeIcon;

  CustomData.fromJson(Map<String, dynamic> json){
    landId = json['land_id']??"";
    id = json['id']??"";
    crop = json['crop']??"";
    cropId = json['crop_id']??"";
    cropName = json['crop_name']??"";
    cropNameMr = json['crop_name_mr']??"";
    cropType = json['crop_type']??"";
    cropTypeName = json['crop_type_name']??"";
    cropTypeNameMr = json['crop_type_name_mr']??"";
    unit = json['unit']??"";
    unitName = json['unit_name']??"";
    unitNameMr = json['unit_name_mr']??"";
    areaUnderCultivation = json['area_under_cultivation']??"";
    durationFrom = json['duration_from']??"";
    durationTo = json['duration_to']??"";
    cropImage = json['crop_image']??"";
    farmName = json['farm_name']??"";
    stateId = null;
    citiesId = null;
    doc_7_12 = null;
    farmNameMr = null;
    durationDays = json['duration_days']??"";
    cityName = null;
    isInsured = json['is_insured']??"";
    insuranceId = json['insurance_id']??"";
    insuranceStatus = null;
    isInsurancePlan = json['is_insurance_plan']??"";
    cropTypeIcon = null;
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['land_id'] = landId;
    _data['id'] = id;
    _data['crop'] = crop;
    _data['crop_id'] = cropId;
    _data['crop_name'] = cropName;
    _data['crop_name_mr'] = cropNameMr;
    _data['crop_type'] = cropType;
    _data['crop_type_name'] = cropTypeName;
    _data['crop_type_name_mr'] = cropTypeNameMr;
    _data['unit'] = unit;
    _data['unit_name'] = unitName;
    _data['unit_name_mr'] = unitNameMr;
    _data['area_under_cultivation'] = areaUnderCultivation;
    _data['duration_from'] = durationFrom;
    _data['duration_to'] = durationTo;
    _data['crop_image'] = cropImage;
    _data['farm_name'] = farmName;
    _data['state_id'] = stateId;
    _data['cities_id'] = citiesId;
    _data['doc_7_12'] = doc_7_12;
    _data['farm_name_mr'] = farmNameMr;
    _data['duration_days'] = durationDays;
    _data['city_name'] = cityName;
    _data['is_insured'] = isInsured;
    _data['insurance_id'] = insuranceId;
    _data['insurance_status'] = insuranceStatus;
    _data['is_insurance_plan'] = isInsurancePlan;
    _data['crop_type_icon'] = cropTypeIcon;
    return _data;
  }
}

class Crop {
  Crop({
    required this.id,
    required this.farmerId,
    required this.clientId,
    required this.landId,
    required this.name,
    required this.nameMr,
    required this.crop,
    this.cropName,
    this.cropImage,
    required this.cropType,
    required this.areaUnderCultivation,
    required this.unit,
    required this.durationFrom,
    required this.durationTo,
    required this.farmName,
    required this.cropId,
    required this.durationDays,
    this.stateId,
    this.citiesId,
    this.doc_7_12,
    this.cityName,
    this.cropTypeIcon,
    required this.cropTypeName,
    required this.cropLogo,
  });
  late final String id;
  late final String farmerId;
  late final String clientId;
  late final String landId;
  late final String name;
  late final String nameMr;
  late final String crop;
  late final Null cropName;
  late final Null cropImage;
  late final String cropType;
  late final String areaUnderCultivation;
  late final String unit;
  late final String durationFrom;
  late final String durationTo;
  late final String farmName;
  late final String cropId;
  late final String durationDays;
  late final Null stateId;
  late final Null citiesId;
  late final Null doc_7_12;
  late final Null cityName;
  late final String? cropTypeIcon;
  late final String cropTypeName;
  late final String cropLogo;

  Crop.fromJson(Map<String, dynamic> json){
    id = json['id']??"";
    farmerId = json['farmer_id']??"";
    clientId = json['client_id']??"";
    landId = json['land_id']??"";
    name = json['name']??"";
    nameMr = json['name_mr']??"";
    crop = json['crop']??"";
    cropName = null;
    cropImage = null;
    cropType = json['crop_type']??"";
    areaUnderCultivation = json['area_under_cultivation']??"";
    unit = json['unit']??"";
    durationFrom = json['duration_from']??"";
    durationTo = json['duration_to']??"";
    farmName = json['farm_name']??"";
    cropId = json['crop_id']??"";
    durationDays = json['duration_days']??"";
    stateId = null;
    citiesId = null;
    doc_7_12 = null;
    cityName = null;
    cropTypeIcon = null;
    cropTypeName = json['crop_type_name']??"";
    cropLogo = json['crop_logo']??"";
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['farmer_id'] = farmerId;
    _data['client_id'] = clientId;
    _data['land_id'] = landId;
    _data['name'] = name;
    _data['name_mr'] = nameMr;
    _data['crop'] = crop;
    _data['crop_name'] = cropName;
    _data['crop_image'] = cropImage;
    _data['crop_type'] = cropType;
    _data['area_under_cultivation'] = areaUnderCultivation;
    _data['unit'] = unit;
    _data['duration_from'] = durationFrom;
    _data['duration_to'] = durationTo;
    _data['farm_name'] = farmName;
    _data['crop_id'] = cropId;
    _data['duration_days'] = durationDays;
    _data['state_id'] = stateId;
    _data['cities_id'] = citiesId;
    _data['doc_7_12'] = doc_7_12;
    _data['city_name'] = cityName;
    _data['crop_type_icon'] = cropTypeIcon;
    _data['crop_type_name'] = cropTypeName;
    _data['crop_logo'] = cropLogo;
    return _data;
  }
}

class CropType {
  CropType({
    required this.id,
    required this.value,
    required this.nameMr,
  });
  late final String id;
  late final String value;
  late final String nameMr;

  CropType.fromJson(Map<String, dynamic> json){
    id = json['id']??"";
    value = json['value']??"";
    nameMr = json['name_mr']??"";
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['value'] = value;
    _data['name_mr'] = nameMr;
    return _data;
  }
}

class Unit {
  Unit({
    required this.id,
    required this.value,
    required this.nameMr,
  });
  late final String id;
  late final String value;
  late final String nameMr;

  Unit.fromJson(Map<String, dynamic> json){
    id = json['id']??"";
    value = json['value']??"";
    nameMr = json['name_mr']??"";
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['value'] = value;
    _data['name_mr'] = nameMr;
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
    categoryImgUrl = json['category_img_url']??"";
    partnerImgUrl = json['partner_img_url']??"";
    aadharNoDocUrl = json['aadhar_no_doc_url']??"";
    panNoDocUrl = json['pan_no_doc_url']??"";
    farmImageUrl = json['farm_image_url']??"";
    ProductImageUrl = json['Product_image_url']??"";
    marketCatImageUrl = json['market_cat_image_url']??"";
    serviceImageUrl = json['service_image_url']??"";
    blogsTypesUrl = json['blogs_types_url']??"";
    blogsTagsUrl = json['blogs_tags_url']??"";
    createdBlogsUrl = json['created_blogs_url']??"";
    farmerDocumentsUrl = json['farmer_documents_url']??"";
    advertiseImageUrl = json['advertise_image_url']??"";
    whitelabelImageUrl = json['whitelabel_image_url']??"";
    termsSheet = json['terms_sheet']??"";
    farmDoc = json['farm_doc']??"";
    insuranceCompany = json['insurance_company']??"";
    cropImageUrl = json['crop_image_url']??"";
    cropTypeUrl = json['crop_type_url']??"";
    notice = json['notice']??"";
    announcement = json['announcement']??"";
    cropHealthPredictApi = json['crop_health_predict_api']??"";
    dssModuleImageurl = json['dss_module_imageurl']??"";
    bottomMenuIcon = json['bottom_menu_icon']??"";
    cropVerityImgUrl = json['crop_verity_img_url']??"";
    cropFertiImgUrl = json['crop_ferti_img_url']??"";
    soilHealthImage = json['soil_health_image']??"";
    loanImageUrl = json['loan_image_url']??"";
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