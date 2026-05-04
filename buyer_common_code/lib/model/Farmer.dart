
class Farmer {
  Farmer({
    required this.success,
    required this.status,
    required this.data,
   // required this.configUrl,
    required this.message,
  });
  late final int success;
  late final int status;
  late final List<FarmerData> data;
 // late final ConfigUrl configUrl;
  late final String message;

  Farmer.fromJson(Map<String, dynamic> json){
    success = json['success'];
    status = json['status'];
    data = List.from(json['data']).map((e)=>FarmerData.fromJson(e)).toList();
   // configUrl = ConfigUrl.fromJson(json['config_url']);
    message = json['msg'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['success'] = success;
    _data['status'] = status;
    _data['data'] = data.map((e)=>e.toJson()).toList();
    //_data['config_url'] = configUrl.toJson();
    _data['msg'] = message;
    return _data;
  }
}

class FarmerData {
  late final String? id;
  late final String? firstName;
 // late final String? middleName;
  late final String? lastName;
  late final String? email;
  late final String? phone;
  late final String? profileImage;
  late final String? createdOn;
  //late final String? isLogin;
  late final String? address1;
 // late final String? address2;
  late final String? city;
  late final String? postcode;
  late final String? latitude;
  late final String? longitude;
 // late final String? scheduleCallStatus;
 // late final String? productType;
 // late final String? callScheduleTimestamp;
 // late final String? callScheduleTime;

  FarmerData({
    required this.id,
    required this.firstName,
   // this.middleName,
    required this.lastName,
    required this.email,
    required this.phone,
    required this.profileImage,
    required this.createdOn,
   // this.isLogin,
    required this.address1,
   // this.address2,
    required this.city,
    required this.postcode,
    required this.latitude,
    required this.longitude,
   // this.scheduleCallStatus,
  //  this.productType,
   // this.callScheduleTimestamp,
   // this.callScheduleTime,
  });

  FarmerData.fromJson(Map<String, dynamic> json) {
    id = json['id']??'';
    firstName = json['first_name'];
    //middleName =  json['middleName']??'';
    lastName = json['last_name']??'';
    email = json['email']??'';
    phone = json['phone']??'';
    profileImage = json['profile_image']??'';
    createdOn = json['created_on']??'';
  //  isLogin = json['isLogin']??'';
    address1 = json['address1']??'';
 //   address2 = json['address2']??'';
    city = json['city']??'';
    postcode = json['postcode']??'';
    latitude = json['latitude']??'';
    longitude = json['longitude']??'';
   // scheduleCallStatus = json['scheduleCallStatus']??'';
   // productType = json['productType']??'';
  //  callScheduleTimestamp = json['callScheduleTimestamp']??'';
   // callScheduleTime = json['callScheduleTime']??'';

  }


  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['first_name'] = firstName;
   // _data['middle_name'] = middleName;
    _data['last_name'] = lastName;
    _data['email'] = email;
    _data['phone'] = phone;
    _data['profile_image'] = profileImage;
    _data['created_on'] = createdOn;
   // _data['is_login'] = isLogin;
    _data['address1'] = address1;
    //_data['address2'] = address2;
    _data['city'] = city;
    _data['postcode'] = postcode;
    _data['latitude'] = latitude;
    _data['longitude'] = longitude;
   // _data['schedule_call_status'] = scheduleCallStatus;
   // _data['product_type'] = productType;
    //_data['call_schedule_timestamp'] = callScheduleTimestamp;
   // _data['call_schedule_time'] = callScheduleTime;
    return _data;
  }

}
class FarmerFieldfirst_names {
  static const String id = "id";
  static const String first_name = "first_name";
  static const String middle_name = "middle_name";
  static const String email = "email";
  static const String phone = "phone";
  static const String profile_image = "profile_image";
  static const String last_name = "last_name";
  static const String address1 = "address1";
  static const String city = "city";
  static const String postcode = "postcode";
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