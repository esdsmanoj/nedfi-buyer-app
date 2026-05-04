class ProductInfoModel {
  ProductInfoModel({
    required this.success,
    required this.data,
    required this.msg,
    required this.error,
    required this.status,
  });
  late final int success;
  late final List<ProductData> data;
  late final String msg;
  late final int error;
  late final int status;

  ProductInfoModel.fromJson(Map<String, dynamic> json){
    success = json['success'];
    data = List.from(json['data']).map((e)=>ProductData.fromJson(e)).toList();
    msg = json['msg'];
    error = json['error'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['success'] = success;
    _data['data'] = data.map((e)=>e.toJson()).toList();
    _data['msg'] = msg;
    _data['error'] = error;
    _data['status'] = status;
    return _data;
  }
}

class ProductData {
  ProductData({
    required this.pcatId,
    required this.catName,
    required this.image,
    required this.productsList,
  });
  late final String pcatId;
  late final String catName;
  late final String image;
  late final List<ProductsList> productsList;

  ProductData.fromJson(Map<String, dynamic> json){
    pcatId = json['pcat_id']??"";
    catName = json['cat_name']??"";
    image = json['image']??"";
    productsList = List.from(json['products_list']).map((e)=>ProductsList.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['pcat_id'] = pcatId;
    _data['cat_name'] = catName;
    _data['image'] = image;
    _data['products_list'] = productsList.map((e)=>e.toJson()).toList();
    return _data;
  }
}

class ProductsList {
  ProductsList({
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
    this.updatedById,
    this.updatedOn,
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
    this.isPublish,
    required this.inStock,
    required this.inStockAlert,
    required this.purchaseLimit,
    this.unit,
    required this.deliveryDays,
    required this.qty,
    required this.cartFlag,
    required this.quantity,required this.rating,required this.sub_total
  });
  late final String id;
  late final String partnerId;
  late final String categoryId;
  late final String? subCategoryId;
  late final String productName;
  late final String overview;
  late final String brief;
  late final String highlight;
  late final String usage;
  late final String support;
  late final Null version;
  late final String logo;
  late final Null demoUrl;
  late final String createdById;
  late final String createdOn;
  late final String? updatedById;
  late final String? updatedOn;
  late final String isDeleted;
  late final Null deletedById;
  late final Null deletedOn;
  String? type;
  late final Null productOffered;
  late final String? registerApi;
  late final String? packageNote;
  late final String? programmingLang;
  late final Null otherProgrammingLang;
  late final String? framework;
  late final Null otherFramework;
  late final String userManual;
  late final String? caseStudy;
  late final Null defaultCredentialData;
  late final String? clientLoginUrl;
  late final String status;
  late final Null productScore;
  late final String infraMinCost;
  late final String infraMaxCost;
  late final Null seoUrl;
  late final String productType;
  late final String? productKind;
  late final String price;
  late final Null vendorId;
  late final Null isCod;
  late final String? isPublish;
  late final String inStock;
  late final String inStockAlert;
  late final String purchaseLimit;
  late final String? unit;
  late final String deliveryDays;
  late final String quantity;
  late final String rating;
  late final String sub_total;

  String? qty="1";
  bool cartFlag=true;
  static final columns = ["id", "partner_id", "category_id", "version", "logo",'type','product_type','price','product_name','qty'];
  ProductsList.fromJson(Map<String, dynamic> json){
    id = json['id'].toString();
    partnerId = json['partner_id']??"";
    categoryId = json['category_id']??"";
    subCategoryId = null;
    productName = json['product_name']??"";
    overview = json['overview']??"";
    brief = json['brief']??"";
    highlight = json['highlight']??"";
    usage = json['usage']??"";
    support = json['support']??"";
    version = null;
    logo = json['logo']??"";
    demoUrl = null;
    createdById = json['created_by_id']??"";
    createdOn = json['created_on']??"";
    updatedById = null;
    updatedOn = null;
    isDeleted = json['is_deleted']??"";
    deletedById = null;
    deletedOn = null;
    type = null;
    productOffered = null;
    registerApi = null;
    packageNote = null;
    programmingLang = null;
    otherProgrammingLang = null;
    framework = null;
    otherFramework = null;
    userManual = json['user_manual']??"";
    caseStudy = null;
    defaultCredentialData = null;
    clientLoginUrl = null;
    status = json['status']??"";
    productScore = null;
    infraMinCost = json['infra_min_cost']??"";
    infraMaxCost = json['infra_max_cost']??"";
    seoUrl = null;
    productType = json['product_type']??"";
    productKind = null;
    price = json['price']??"";
    vendorId = null;
    isCod = null;
    isPublish = null;
    inStock = json['in_stock']??"0";
    inStockAlert = json['in_stock_alert']??"0";
    purchaseLimit = json['purchase_limit']??"";
    unit = json['unit']??"";
    deliveryDays = json['delivery_days']??"";
    qty = json['qty']??"1";
    cartFlag = json['cartFlag']??false;
    quantity= json['quantity']??"";
    rating= json['rating']??"4";
    sub_total= json['sub_total']??"";
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
    _data['qty'] = qty;
    _data['cartFlag'] = cartFlag;
    _data['quantity'] =quantity;
    _data['rating'] =rating;
    _data['sub_total'] =sub_total;
    return _data;
  }
}