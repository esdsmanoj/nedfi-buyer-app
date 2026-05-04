import 'MasterResponse.dart';

class LandResponse {
  int? success;
  int? status;
  List<CustomData>? customData;
  List<FarmType>? farmType;
  List<Topology>? topology;
  List<SoilType>? soilType;
  List<Unit>? unit;
  String? message;
  ConfigUrl? configUrl;

  LandResponse({this.success, this.status, this.customData, this.farmType, this.topology, this.soilType, this.unit, this.message, this.configUrl});

  LandResponse.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    status = json['status'];
    if (json['custom_data'] != null) {
      customData = <CustomData>[];
      json['custom_data'].forEach((v) {
        customData!.add(CustomData.fromJson(v));
      });
    }
    if (json['farm_type'] != null) {
      farmType = <FarmType>[];
      json['farm_type'].forEach((v) {
        farmType!.add(FarmType.fromJson(v));
      });
    }
    if (json['topology'] != null) {
      topology = <Topology>[];
      json['topology'].forEach((v) {
        topology!.add(Topology.fromJson(v));
      });
    }
    if (json['soil_type'] != null) {
      soilType = <SoilType>[];
      json['soil_type'].forEach((v) {
        soilType!.add(SoilType.fromJson(v));
      });
    }
    if (json['unit'] != null) {
      unit = <Unit>[];
      json['unit'].forEach((v) {
        unit!.add(Unit.fromJson(v));
      });
    }
    message = json['message'];
    configUrl = json['config_url'] != null ? ConfigUrl.fromJson(json['config_url']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['success'] = success;
    data['status'] = status;
    if (customData != null) {
      data['custom_data'] = customData!.map((v) => v.toJson()).toList();
    }
    if (farmType != null) {
      data['farm_type'] = farmType!.map((v) => v.toJson()).toList();
    }
    if (topology != null) {
      data['topology'] = topology!.map((v) => v.toJson()).toList();
    }
    if (soilType != null) {
      data['soil_type'] = soilType!.map((v) => v.toJson()).toList();
    }
    if (unit != null) {
      data['unit'] = unit!.map((v) => v.toJson()).toList();
    }
    data['message'] = message;
    if (configUrl != null) {
      data['config_url'] = configUrl!.toJson();
    }
    return data;
  }
}

class CustomData {
  String? landId;
  String? farmerId;
  String? topology;
  String? soilType;
  String? farmType;
  String? farmSize;
  String? soilTypeName;
  String? soilTypeNameMr;
  String? farmTypeName;
  String? farmTypeNameMr;
  String? topologyName;
  String? topologyNameMr;
  String? irriFatyName;
  String? irriFatyNameMr;
  String? irriSrcName;
  String? irriSrcNameMr;
  String? unit;
  String? unitName;
  String? unitNameMr;
  String? irrigationSource;
  String? irrigationFacility;
  dynamic calculatedLandArea;
  String? surveyNo;
  dynamic stateId;
  dynamic citiesId;
  dynamic doc712;
  String? farmName;
  String? farmImage;
  int? isInsured;
  String? farmPolygoanCoordinates;

  CustomData({this.landId,
    this.farmerId,
    this.topology,
    this.soilType,
    this.farmType,
    this.farmSize,
    this.soilTypeName,
    this.soilTypeNameMr,
    this.farmTypeName,
    this.farmTypeNameMr,
    this.topologyName,
    this.topologyNameMr,
    this.irriFatyName,
    this.irriFatyNameMr,
    this.irriSrcName,
    this.irriSrcNameMr,
    this.unit,
    this.unitName,
    this.unitNameMr,
    this.irrigationSource,
    this.irrigationFacility,
    this.calculatedLandArea,
    this.surveyNo,
    this.stateId,
    this.citiesId,
    this.doc712,
    this.farmName,
    this.farmImage,
    this.isInsured,
    this.farmPolygoanCoordinates});

  CustomData.fromJson(Map<String, dynamic> json) {
    landId = json['land_id'];
    farmerId = json['farmer_id'];
    topology = json['topology'];
    soilType = json['soil_type'];
    farmType = json['farm_type'];
    farmSize = json['farm_size'];
    soilTypeName = json['soil_type_name'];
    soilTypeNameMr = json['soil_type_name_mr'];
    farmTypeName = json['farm_type_name'];
    farmTypeNameMr = json['farm_type_name_mr'];
    topologyName = json['topology_name'];
    topologyNameMr = json['topology_name_mr'];
    irriFatyName = json['irri_faty_name'];
    irriFatyNameMr = json['irri_faty_name_mr'];
    irriSrcName = json['irri_src_name'];
    irriSrcNameMr = json['irri_src_name_mr'];
    unit = json['unit'];
    unitName = json['unit_name'];
    unitNameMr = json['unit_name_mr'];
    irrigationSource = json['irrigation_source'];
    irrigationFacility = json['irrigation_facility'];
    calculatedLandArea = json['calculated_land_area'];
    surveyNo = json['survey_no'];
    stateId = json['state_id'];
    citiesId = json['cities_id'];
    doc712 = json['doc_7_12'] ?? "";
    farmName = json['farm_name'];
    farmImage = json['farm_image'];
    isInsured = json['is_insured'];
    farmPolygoanCoordinates = json['farm_polygoan_coordinates'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['land_id'] = landId;
    data['farmer_id'] = farmerId;
    data['topology'] = topology;
    data['soil_type'] = soilType;
    data['farm_type'] = farmType;
    data['farm_size'] = farmSize;
    data['soil_type_name'] = soilTypeName;
    data['soil_type_name_mr'] = soilTypeNameMr;
    data['farm_type_name'] = farmTypeName;
    data['farm_type_name_mr'] = farmTypeNameMr;
    data['topology_name'] = topologyName;
    data['topology_name_mr'] = topologyNameMr;
    data['irri_faty_name'] = irriFatyName;
    data['irri_faty_name_mr'] = irriFatyNameMr;
    data['irri_src_name'] = irriSrcName;
    data['irri_src_name_mr'] = irriSrcNameMr;
    data['unit'] = unit;
    data['unit_name'] = unitName;
    data['unit_name_mr'] = unitNameMr;
    data['irrigation_source'] = irrigationSource;
    data['irrigation_facility'] = irrigationFacility;
    data['calculated_land_area'] = calculatedLandArea;
    data['survey_no'] = surveyNo;
    data['state_id'] = stateId;
    data['cities_id'] = citiesId;
    data['doc_7_12'] = doc712;
    data['farm_name'] = farmName;
    data['farm_image'] = farmImage;
    data['is_insured'] = isInsured;
    data['farm_polygoan_coordinates'] = farmPolygoanCoordinates;
    return data;
  }
}

class FarmType {
  String? id;
  String? value;
  String? nameMr;

  FarmType({this.id, this.value, this.nameMr});

  FarmType.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    value = json['value'];
    nameMr = json['name_mr'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = id;
    data['value'] = value;
    data['name_mr'] = nameMr;
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

  ConfigUrl({this.categoryImgUrl,
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
    final Map<String, dynamic> data = Map<String, dynamic>();
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
