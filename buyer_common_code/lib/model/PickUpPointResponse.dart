class PickUpPointResponse {
  PickUpPointResponse({
    required this.success,
    required this.data,
    required this.productRes,
    required this.msg,
    required this.error,
    required this.status,
  });
  late final int success;
  late final List<PickUpPointData> data;
  late final ProductRes productRes;
  late final String msg;
  late final int error;
  late final int status;

  PickUpPointResponse.fromJson(Map<String, dynamic> json){
    success = json['success'];
    data = List.from(json['data']).map((e)=>PickUpPointData.fromJson(e)).toList();
    if(json['product_res']!=null) {
      productRes = ProductRes.fromJson(json['product_res']);
    }
    msg = json['msg'];
    error = json['error'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['success'] = success;
    _data['data'] = data.map((e)=>e.toJson()).toList();
    _data['product_res'] = productRes.toJson();
    _data['msg'] = msg;
    _data['error'] = error;
    _data['status'] = status;
    return _data;
  }
}

class PickUpPointData {
  PickUpPointData({
    required this.address,
    required this.pincode,
    this.lat,
    this.long,
    required this.id,
  });
  late final String address;
  late final String pincode;
  late final String? lat;
  late final String? long;
  late final String id;

  PickUpPointData.fromJson(Map<String, dynamic> json){
    address = json['address']??"";
    pincode = json['pincode']??"";
    lat = null;
    long = null;
    id = json['id']??"";
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['address'] = address;
    _data['pincode'] = pincode;
    _data['lat'] = lat;
    _data['long'] = long;
    _data['id'] = id;
    return _data;
  }
}

class ProductRes {
  ProductRes({
    required this.id,
    required this.partnerId,
    required this.categoryId,
    this.subCategoryId,
    required this.productName,
    required this.overview,
    required this.brief,
    required this.highlight,
    required this.usage,
    required this.support,
    this.version,
    required this.logo,
    this.demoUrl,
    required this.createdById,
    required this.createdOn,
    required this.updatedById,
    required this.updatedOn,
    required this.isDeleted,
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
    required this.userManual,
    this.caseStudy,
    this.defaultCredentialData,
    this.clientLoginUrl,
    required this.status,
    this.productScore,
    required this.infraMinCost,
    required this.infraMaxCost,
    this.seoUrl,
    required this.productType,
    this.productKind,
    required this.price,
    this.vendorId,
    this.isCod,
    required this.isPublish,
    required this.inStock,
    required this.inStockAlert,
    required this.purchaseLimit,
    required this.unit,
    required this.deliveryDays,
    required this.pickupLocationIds,
    required this.locationType,
  });
  late final String? id;
  late final String? partnerId;
  late final String? categoryId;
  late final String? subCategoryId;
  late final String? productName;
  late final String? overview;
  late final String? brief;
  late final String? highlight;
  late final String? usage;
  late final String? support;
  late final String? version;
  late final String? logo;
  late final String? demoUrl;
  late final String? createdById;
  late final String? createdOn;
  late final String? updatedById;
  late final String? updatedOn;
  late final String? isDeleted;
  late final String? deletedById;
  late final String? deletedOn;
  late final String? type;
  late final String? productOffered;
  late final String? registerApi;
  late final String? packageNote;
  late final String? programmingLang;
  late final String? otherProgrammingLang;
  late final String? framework;
  late final String? otherFramework;
  late final String? userManual;
  late final String? caseStudy;
  late final String? defaultCredentialData;
  late final String? clientLoginUrl;
  late final String? status;
  late final String? productScore;
  late final String? infraMinCost;
  late final String? infraMaxCost;
  late final String? seoUrl;
  late final String? productType;
  late final String? productKind;
  late final String? price;
  late final String? vendorId;
  late final String? isCod;
  late final String? isPublish;
  late final String? inStock;
  late final String? inStockAlert;
  late final String? purchaseLimit;
  late final String? unit;
  late final String? deliveryDays;
  late final String? pickupLocationIds;
  late final String? locationType;

  ProductRes.fromJson(Map<String, dynamic> json){
    id = json['id']??"";
    partnerId = json['partner_id']??"";
    categoryId = json['category_id']??"";
    subCategoryId = json['category_id']??"";
    productName = json['product_name']??"";
    overview = json['overview']??"";
    brief = json['brief']??"";
    highlight = json['highlight']??"";
    usage = json['usage']??"";
    support = json['support']??"";
    version = json['category_id']??"";
    logo = json['logo']??"";
    demoUrl = json['category_id']??"";
    createdById = json['created_by_id'];
    createdOn = json['created_on']??"";
    updatedById = json['updated_by_id']??"";
    updatedOn = json['updated_on']??"";
    isDeleted = json['is_deleted']??"";
    deletedById = json['category_id']??"";
    deletedOn = json['category_id']??"";
    type =json['category_id']??"";
    productOffered = json['category_id']??"";
    registerApi = json['category_id']??"";
    packageNote = json['category_id']??"";
    programmingLang = json['category_id']??"";
    otherProgrammingLang = json['category_id']??"";
    framework = json['category_id']??"";
    otherFramework =json['category_id']??"";
    userManual = json['user_manual']??"";
    caseStudy = json['category_id']??"";
    defaultCredentialData = json['category_id']??"";
    clientLoginUrl = json['category_id']??"";
    status = json['status']??"";
    productScore = json['category_id']??"";
    infraMinCost = json['infra_min_cost']??"";
    infraMaxCost = json['infra_max_cost']??"";
    seoUrl =json['category_id']??"";
    productType = json['product_type']??"";
    productKind =json['category_id']??"";
    price = json['price']??"";
    vendorId = json['category_id']??"";
    isCod = json['category_id']??"";
    isPublish = json['is_publish']??"";
    inStock = json['in_stock']??"";
    inStockAlert = json['in_stock_alert']??"";
    purchaseLimit = json['purchase_limit']??"";
    unit = json['unit']??"";
    deliveryDays = json['delivery_days']??"";
    pickupLocationIds = json['pickup_location_ids']??"";
    locationType = json['location_type']??"";
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['partner_id'] = partnerId;
    _data['category_id'] = categoryId;
    _data['sub_category_id'] = subCategoryId;
    _data['product_name'] = productName;
    _data['overview'] = overview;
    _data['brief'] = brief;
    _data['highlight'] = highlight;
    _data['usage'] = usage;
    _data['support'] = support;
    _data['version'] = version;
    _data['logo'] = logo;
    _data['demo_url'] = demoUrl;
    _data['created_by_id'] = createdById;
    _data['created_on'] = createdOn;
    _data['updated_by_id'] = updatedById;
    _data['updated_on'] = updatedOn;
    _data['is_deleted'] = isDeleted;
    _data['deleted_by_id'] = deletedById;
    _data['deleted_on'] = deletedOn;
    _data['type'] = type;
    _data['product_offered'] = productOffered;
    _data['register_api'] = registerApi;
    _data['package_note'] = packageNote;
    _data['programming_lang'] = programmingLang;
    _data['other_programming_lang'] = otherProgrammingLang;
    _data['framework'] = framework;
    _data['other_framework'] = otherFramework;
    _data['user_manual'] = userManual;
    _data['case_study'] = caseStudy;
    _data['default_credential_data'] = defaultCredentialData;
    _data['client_login_url'] = clientLoginUrl;
    _data['status'] = status;
    _data['product_score'] = productScore;
    _data['infra_min_cost'] = infraMinCost;
    _data['infra_max_cost'] = infraMaxCost;
    _data['seo_url'] = seoUrl;
    _data['product_type'] = productType;
    _data['product_kind'] = productKind;
    _data['price'] = price;
    _data['vendor_id'] = vendorId;
    _data['is_cod'] = isCod;
    _data['is_publish'] = isPublish;
    _data['in_stock'] = inStock;
    _data['in_stock_alert'] = inStockAlert;
    _data['purchase_limit'] = purchaseLimit;
    _data['unit'] = unit;
    _data['delivery_days'] = deliveryDays;
    _data['pickup_location_ids'] = pickupLocationIds;
    _data['location_type'] = locationType;
    return _data;
  }
}