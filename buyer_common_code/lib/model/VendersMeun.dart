class VendersMeun {
  VendersMeun({
    required this.success,
    required this.data,
    required this.msg,
    required this.error,
    required this.status,
    required this.configUrl,
    required this.vendorMenu,
    required this.myRefCode,
  });
  late final int success;
  late final String data;
  late final String msg;
  late final int error;
  late final int status;
  late final ConfigUrl configUrl;
  late final List<VendorMenu> vendorMenu;
  late final String myRefCode;

  VendersMeun.fromJson(Map<String, dynamic> json){
    success = json['success'];
    //data = json['data'];
    //msg = json['msg'];
    error = json['error'];
    status = json['status'];
    configUrl = ConfigUrl.fromJson(json['config_url']);
    vendorMenu = List.from(json['vendor_menu']).map((e)=>VendorMenu.fromJson(e)).toList();
    myRefCode = json['my_ref_code'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['success'] = success;
   // _data['data'] = data;
   // _data['msg'] = msg;
    _data['error'] = error;
    _data['status'] = status;
    _data['config_url'] = configUrl.toJson();
    _data['vendor_menu'] = vendorMenu.map((e)=>e.toJson()).toList();
    _data['my_ref_code'] = myRefCode;
    return _data;
  }
}

class ConfigUrl {
  ConfigUrl({
    required this.categoryImgUrl,
    required this.partnerImgUrl,
    required this.farmerImgUrl,
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
    required this.logo,
  });
  late final String categoryImgUrl;
  late final String partnerImgUrl;
  late final String farmerImgUrl;
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
  late final String logo;

  ConfigUrl.fromJson(Map<String, dynamic> json){
    categoryImgUrl = json['category_img_url'];
    partnerImgUrl = json['partner_img_url'];
    farmerImgUrl = json['farmer_img_url'];
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
    logo = json['logo'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['category_img_url'] = categoryImgUrl;
    _data['partner_img_url'] = partnerImgUrl;
    _data['farmer_img_url'] = farmerImgUrl;
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
    _data['logo'] = logo;
    return _data;
  }
}

class VendorMenu {
  VendorMenu({
    required this.id,
    required this.title,
    required this.icon,
  });
  late final String id;
  late final String title;
  late final String icon;

  VendorMenu.fromJson(Map<String, dynamic> json){
    id = json['id']??"";
    title = json['title']??"";
    icon = json['icon']??"";
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['title'] = title;
    _data['icon'] = icon;
    return _data;
  }
}