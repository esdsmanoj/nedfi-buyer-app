class MasterResponse {
  MasterResponse({
    required this.success,
    required this.error,
    required this.status,
    required this.configUrl,
    required this.farmType,
    required this.topology,
    required this.soilType,
    required this.unit,
    required this.irriSrc,
    required this.irriFaty,
    required this.crop,
    required this.cropType,
    required this.message,
  });
  late final int success;
  late final int error;
  late final int status;
  late final ConfigUrl configUrl;
  late final List<FarmType> farmType;
  late final List<Topology> topology;
  late final List<SoilType> soilType;
  late final List<Unit> unit;
  late final List<IrriSrc> irriSrc;
  late final List<IrriFaty> irriFaty;
  late final List<Crop> crop;
  late final List<CropType> cropType;
  late final String message;

  MasterResponse.fromJson(Map<String, dynamic> json){
    success = json['success'];
    error = json['error'];
    status = json['status'];
    configUrl = ConfigUrl.fromJson(json['config_url']);
    farmType = List.from(json['farm_type']).map((e)=>FarmType.fromJson(e)).toList();
    topology = List.from(json['topology']).map((e)=>Topology.fromJson(e)).toList();
    soilType = List.from(json['soil_type']).map((e)=>SoilType.fromJson(e)).toList();
    unit = List.from(json['unit']).map((e)=>Unit.fromJson(e)).toList();
    irriSrc = List.from(json['irri_src']).map((e)=>IrriSrc.fromJson(e)).toList();
    irriFaty = List.from(json['irri_faty']).map((e)=>IrriFaty.fromJson(e)).toList();
    crop = List.from(json['crop']).map((e)=>Crop.fromJson(e)).toList();
    cropType = List.from(json['crop_type']).map((e)=>CropType.fromJson(e)).toList();
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['success'] = success;
    _data['error'] = error;
    _data['status'] = status;
    _data['config_url'] = configUrl.toJson();
    _data['farm_type'] = farmType.map((e)=>e.toJson()).toList();
    _data['topology'] = topology.map((e)=>e.toJson()).toList();
    _data['soil_type'] = soilType.map((e)=>e.toJson()).toList();
    _data['unit'] = unit.map((e)=>e.toJson()).toList();
    _data['irri_src'] = irriSrc.map((e)=>e.toJson()).toList();
    _data['irri_faty'] = irriFaty.map((e)=>e.toJson()).toList();
    _data['crop'] = crop.map((e)=>e.toJson()).toList();
    _data['crop_type'] = cropType.map((e)=>e.toJson()).toList();
    _data['message'] = message;
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

class FarmType {
  FarmType({
    required this.id,
    required this.value,
    required this.nameMr,
  });
  late final String id;
  late final String value;
  late final String nameMr;

  FarmType.fromJson(Map<String, dynamic> json){
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

class Topology {
  Topology({
    required this.id,
    required this.value,
    required this.nameMr,
  });
  late final String id;
  late final String value;
  late final String nameMr;

  Topology.fromJson(Map<String, dynamic> json){
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

class SoilType {
  SoilType({
    required this.id,
    required this.value,
    required this.nameMr,
  });
  late final String id;
  late final String value;
  late final String nameMr;

  SoilType.fromJson(Map<String, dynamic> json){
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

class IrriSrc {
  IrriSrc({
    required this.id,
    required this.value,
    required this.nameMr,
  });
  late final String id;
  late final String value;
  late final String nameMr;

  IrriSrc.fromJson(Map<String, dynamic> json){
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

class IrriFaty {
  IrriFaty({
    required this.id,
    required this.value,
    required this.nameMr,
  });
  late final String id;
  late final String value;
  late final String nameMr;

  IrriFaty.fromJson(Map<String, dynamic> json){
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

class Crop {
  Crop({
    required this.name,
    required this.nameMr,
    required this.cropId,
    this.durationDays,
  });
  late final String name;
  late final String nameMr;
  late final String cropId;
  late final String? durationDays;

  Crop.fromJson(Map<String, dynamic> json){
    name = json['name']??"";
    nameMr = json['name_mr']??"";
    cropId = json['crop_id']??"";
    durationDays = null;
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['name'] = name;
    _data['name_mr'] = nameMr;
    _data['crop_id'] = cropId;
    _data['duration_days'] = durationDays;
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