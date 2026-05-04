class Products {
  Products({
    required this.success,
    required this.error,
    required this.status,
    required this.data,
    required this.message,
    required this.configUrl,
    required this.crop_product_img,
    required this.vehicleType,
  });
  late final int success;
  late final int error;
  late final int status;
  late final List<ProductsData> data;
  late final String message;
  late final String? crop_product_img;
  late final ConfigUrl configUrl;
  late final List<VehicleType> vehicleType;

  Products.fromJson(Map<String, dynamic> json){
    success = json['success']??0;
    error = json['error']??0;
    status = json['status']??0;
    data = List.from(json['data']).map((e)=>ProductsData.fromJson(e)).toList();
    message = json['message'];
    crop_product_img=json['crop_product_img']??"";
    if(json['config_url']!=null) {
      configUrl = ConfigUrl.fromJson(json['config_url']);
    }
    if(json['vehicle_type']!=null) {
      vehicleType = List.from(json['vehicle_type'])
          .map((e) => VehicleType.fromJson(e))
          .toList();
    }else{
      vehicleType = [];
    }
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['success'] = success;
    _data['error'] = error;
    _data['status'] = status;
    _data['data'] = data.map((e)=>e.toJson()).toList();
    _data['message'] = message;
    _data['crop_product_img']=crop_product_img;
    _data['config_url'] = configUrl.toJson();
    _data['vehicle_type'] = vehicleType.map((e)=>e.toJson()).toList();
    return _data;
  }
}

class ProductsData {
  ProductsData({
     this.id,
     this.cropId,
     this.cropVarietyId,
     this.farmerId,
     this.prodDesc,
    this.price,
    this.priceUnit,
    this.weight,
    this.weightUnit,
    this.producutStatus,
    this.totalAmount,
    this.paymentType,
     this.productAddDate,
    this.payedAmount,
    this.comments,
    this.rejectReason,
    this.actionDate,
    this.paymentDate,
    this.productPrice,
    this.modelPrice,
    this.unit,
    this.marketDate,
     this.createdOn,
     this.updatedOn,
     this.deletedOn,
     this.isDeleted,
    this.deletedById,
     this.isActive,
    this.createdById,
    this.updatedById,
    this.cropImg1,
    this.cropImg2,
     this.name,
     this.nameMr,
     this.mobIcon,
     this.cropVarietyName,
     this.cropVarietyNameMr,
    this.producut_status,
    this.invoiceFile,
    this.market_name,
    this.market_name_mr
  });
   String? id;
   String? cropId;
   String? cropVarietyId;
   String? farmerId;
   String? prodDesc;
   String? price;
  String? priceUnit;
  String? weight;
  String? weightUnit;
  String? producutStatus;
  String? totalAmount;
  String? paymentType;
   String? productAddDate;
  String? payedAmount;
  String? comments;
  String? rejectReason;
  String? actionDate;
  String? paymentDate;
  String? productPrice;
  String? modelPrice;
  String? unit;
  String? marketDate;
  String? createdOn;
  String? updatedOn;
  String? deletedOn;
  String? isDeleted;
  String? deletedById;
  String? isActive;
  String? createdById;
  String? updatedById;
  String? cropImg1;
  String? cropImg2;
  String? name;
  String? nameMr;
  String? mobIcon;
  String? cropVarietyName;
  String? cropVarietyNameMr;
  String? producut_status;
  String? invoiceFile;
  String? market_name;
  String? market_name_mr;


  ProductsData.fromJson(Map<String, dynamic> json){
    id = json['id']??"";
    cropId = json['crop_id']??"";
    cropVarietyId = json['crop_variety_id']??"";
    farmerId = json['farmer_id']??"";
    prodDesc = json['prod_desc'];
    price = json['price'];
    priceUnit = json['price_unit'];
    weight = json['weight'];
    weightUnit = json['weight_unit'];
    producutStatus = json['producut_status']??"";
    totalAmount = json['total_amount'];
    paymentType = json['payment_type']??"";
    productAddDate = json['product_add_date']??"";
    payedAmount = json['payed_amount']??"";
    comments = json['comments']??"";
    rejectReason = json['reject_reason']??"";
    actionDate = json['action_date']??"";
    paymentDate = json['payment_date']??"";
    productPrice = json['product_price']??"";
    modelPrice = json['model_price']??"";
    unit = json['unit']??"";
    marketDate = json['market_date']??"";
    createdOn = json['created_on']??"";
    updatedOn = json['updated_on']??"";
    deletedOn = json['deleted_on']??"";
    isDeleted = json['is_deleted']??"";
    deletedById = json['deletedById']??"";
    isActive = json['is_active']??"";
    createdById = json['createdById']??"";
    updatedById = json['updatedById']??"";
    cropImg1 = json['crop_img1']??"";
    cropImg2 = json['crop_img2']??"";
    name = json['name']??"";
    nameMr = json['name_mr']??"";
    mobIcon = json['mob_icon']??"";
    cropVarietyName = json['crop_variety_name']??"";
    cropVarietyNameMr = json['crop_variety_name_mr']??"";
    producut_status=json['product_status']??"";
    invoiceFile=json['invoice_file'];
    market_name=json['market_name']??"";
    market_name_mr=json['market_name_mr']??"";
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['crop_id'] = cropId;
    _data['crop_variety_id'] = cropVarietyId;
    _data['farmer_id'] = farmerId;
    _data['prod_desc'] = prodDesc;
    _data['price'] = price;
    _data['price_unit'] = priceUnit;
    _data['weight'] = weight;
    _data['weight_unit'] = weightUnit;
    _data['producut_status'] = producutStatus;
    _data['total_amount'] = totalAmount;
    _data['payment_type'] = paymentType;
    _data['product_add_date'] = productAddDate;
    _data['payed_amount'] = payedAmount;
    _data['comments'] = comments;
    _data['reject_reason'] = rejectReason;
    _data['action_date'] = actionDate;
    _data['payment_date'] = paymentDate;
    _data['product_price'] = productPrice;
    _data['model_price'] = modelPrice;
    _data['unit'] = unit;
    _data['market_date'] = marketDate;
    _data['created_on'] = createdOn;
    _data['updated_on'] = updatedOn;
    _data['deleted_on'] = deletedOn;
    _data['is_deleted'] = isDeleted;
    _data['deleted_by_id'] = deletedById;
    _data['is_active'] = isActive;
    _data['created_by_id'] = createdById;
    _data['updated_by_id'] = updatedById;
    _data['crop_img1'] = cropImg1;
    _data['crop_img2'] = cropImg2;
    _data['name'] = name;
    _data['name_mr'] = nameMr;
    _data['mob_icon'] = mobIcon;
    _data['crop_variety_name'] = cropVarietyName;
    _data['crop_variety_name_mr'] = cropVarietyNameMr;
    _data['product_status'] = producut_status;
    _data['invoice_file']=invoiceFile;
    _data['market_name'] = market_name;
    _data['market_name_mr']=market_name_mr;

    return _data;
  }
}

class ConfigUrl {
  ConfigUrl({
    required this.cropProductImg,
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
    required this.cropInvoiceUrl,
    required this.cropHealthPredictApi,
  });
  late final String cropProductImg;
  late final String categoryImgUrl;
  late final String partnerImgUrl;
  late final String aadharNoDocUrl;
  late final String panNoDocUrl;
  late final String? farmImageUrl;
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
  late final String? cropImageUrl;
  late final String cropTypeUrl;
  late final String? cropInvoiceUrl;
  late final String cropHealthPredictApi;

  ConfigUrl.fromJson(Map<String, dynamic> json){
    cropProductImg = json['crop_product_img'];
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
    cropInvoiceUrl = json['crop_invoice_url'];
    cropHealthPredictApi = json['crop_health_predict_api'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['crop_product_img'] = cropProductImg;
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
    _data['crop_invoice_url'] = cropInvoiceUrl;
    _data['crop_health_predict_api'] = cropHealthPredictApi;
    return _data;
  }
}

class VehicleType {
  VehicleType({
    required this.id,
    required this.value,
  });
  late final String id;
  late final String value;

  VehicleType.fromJson(Map<String, dynamic> json){
    id = json['id']??"";
    value = json['value']??"";
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['value'] = value;
    return _data;
  }
}

