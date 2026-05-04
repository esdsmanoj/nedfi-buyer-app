import 'AllMenu.dart';

class Services {
  int? success;
  int? status;
  List<ServiceData>? data;
  ConfigUrl? configUrl;
  List<ServiceOptions>? serviceOptions;
  String? message;
  String? defaultImage;

  Services({this.success, this.status, this.data, this.configUrl, this.serviceOptions, this.message, this.defaultImage});

  Services.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    status = json['status'];
    if (json['data'] != null) {
      data = <ServiceData>[];
      json['data'].forEach((v) {
        data!.add(ServiceData.fromJson(v));
      });
    }
    configUrl = json['config_url'] != null ? ConfigUrl.fromJson(json['config_url']) : null;
    if (json['service_options'] != null) {
      serviceOptions = <ServiceOptions>[];
      json['service_options'].forEach((v) {
        serviceOptions!.add(ServiceOptions.fromJson(v));
      });
    }
    message = json['message'];
    defaultImage = json['default_image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['success'] = success;
    data['status'] = status;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    if (configUrl != null) {
      data['config_url'] = configUrl!.toJson();
    }
    if (serviceOptions != null) {
      data['service_options'] = serviceOptions!.map((v) => v.toJson()).toList();
    }
    data['message'] = message;
    data['default_image'] = defaultImage;
    return data;
  }
}

class ServiceData {
  String? userId;
  String? firstName;
  String? lastName;
  String? email;
  String? password;
  String? companyName;
  String? phoneNo;
  String? address;
  String? city;
  String? state;
  String? country;
  String? postalCode;
  String? websiteUrl;
  String? profileImage;
  String? updatedOn;
  String? updatedById;
  String? createdOn;
  String? isDeleted;
  dynamic deletedOn;
  dynamic deletedById;
  dynamic passwordResetToken;
  dynamic passwordResetDate;
  String? isActive;
  String? panNo;
  String? gstNo;
  String? emailVerify;
  dynamic emailVerifyToken;
  dynamic emailVerifyDate;
  String? lastLogin;
  String? ip;
  String? type;
  String? userType;
  String? userExperiance;
  String? businessAddress;
  String? businessCity;
  String? businessState;
  String? businessPostalCode;
  String? businessDetails;
  dynamic businessProfileDoc;
  String? businessCountry;
  String? expertise;
  String? businessMob;
  String? rating;
  String? businessSince;
  String? isExternal;
  String? createdById;
  String? referralCode;
  dynamic deviceId;
  dynamic permissionJson;
  String? roleId;
  dynamic optNumber;
  String? isWhitelabeled;
  dynamic isLogin;
  dynamic myRefferalCode;
  dynamic loginCount;
  String? latitude;
  String? longitude;
  String? isVideoEnable;
  String? isChatEnable;
  dynamic cropId;
  dynamic locAddress;
  dynamic cityName;
  dynamic isApprove;
  String? isOnline;
  String? username;
  dynamic level;
  dynamic sectionJson;
  dynamic uuid;
  dynamic companyRegNo;
  dynamic partnerTypeProvider;

  ServiceData(
      {this.userId,
      this.firstName,
      this.lastName,
      this.email,
      this.password,
      this.companyName,
      this.phoneNo,
      this.address,
      this.city,
      this.state,
      this.country,
      this.postalCode,
      this.websiteUrl,
      this.profileImage,
      this.updatedOn,
      this.updatedById,
      this.createdOn,
      this.isDeleted,
      this.deletedOn,
      this.deletedById,
      this.passwordResetToken,
      this.passwordResetDate,
      this.isActive,
      this.panNo,
      this.gstNo,
      this.emailVerify,
      this.emailVerifyToken,
      this.emailVerifyDate,
      this.lastLogin,
      this.ip,
      this.type,
      this.userType,
      this.userExperiance,
      this.businessAddress,
      this.businessCity,
      this.businessState,
      this.businessPostalCode,
      this.businessDetails,
      this.businessProfileDoc,
      this.businessCountry,
      this.expertise,
      this.businessMob,
      this.rating,
      this.businessSince,
      this.isExternal,
      this.createdById,
      this.referralCode,
      this.deviceId,
      this.permissionJson,
      this.roleId,
      this.optNumber,
      this.isWhitelabeled,
      this.isLogin,
      this.myRefferalCode,
      this.loginCount,
      this.latitude,
      this.longitude,
      this.isVideoEnable,
      this.isChatEnable,
      this.cropId,
      this.locAddress,
      this.cityName,
      this.isApprove,
      this.isOnline,
      this.username,
      this.level,
      this.sectionJson,
      this.uuid,
      this.companyRegNo,
      this.partnerTypeProvider});

  ServiceData.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    email = json['email'];
    password = json['password'];
    companyName = json['company_name'];
    phoneNo = json['phone_no'];
    address = json['address'];
    city = json['city'];
    state = json['state'];
    country = json['country'];
    postalCode = json['postal_code'];
    websiteUrl = json['website_url'];
    profileImage = json['profile_image'];
    updatedOn = json['updated_on'];
    updatedById = json['updated_by_id'];
    createdOn = json['created_on'];
    isDeleted = json['is_deleted'];
    deletedOn = json['deleted_on'];
    deletedById = json['deleted_by_id'];
    passwordResetToken = json['password_reset_token'];
    passwordResetDate = json['password_reset_date'];
    isActive = json['is_active'];
    panNo = json['pan_no'];
    gstNo = json['gst_no'];
    emailVerify = json['email_verify'];
    emailVerifyToken = json['email_verify_token'];
    emailVerifyDate = json['email_verify_date'];
    lastLogin = json['last_login'];
    ip = json['ip'];
    type = json['type'];
    userType = json['user_type'];
    userExperiance = json['user_experiance'];
    businessAddress = json['business_address'];
    businessCity = json['business_city'];
    businessState = json['business_state'];
    businessPostalCode = json['business_postal_code'];
    businessDetails = json['business_details'];
    businessProfileDoc = json['business_profile_doc'];
    businessCountry = json['business_country'];
    expertise = json['expertise'];
    businessMob = json['business_mob'];
    rating = json['rating'];
    businessSince = json['business_since'];
    isExternal = json['is_external'];
    createdById = json['created_by_id'];
    referralCode = json['referral_code'];
    deviceId = json['device_id'];
    permissionJson = json['permission_json'];
    roleId = json['role_id'];
    optNumber = json['opt_number'];
    isWhitelabeled = json['is_whitelabeled'];
    isLogin = json['is_login'];
    myRefferalCode = json['my_refferal_code'];
    loginCount = json['login_count'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    isVideoEnable = json['is_video_enable'];
    isChatEnable = json['is_chat_enable'];
    cropId = json['crop_id'];
    locAddress = json['loc_address'];
    cityName = json['city_name'];
    isApprove = json['is_approve'];
    isOnline = json['is_online'];
    username = json['username'];
    level = json['level'];
    sectionJson = json['section_json'];
    uuid = json['uuid'];
    companyRegNo = json['company_reg_no'];
    partnerTypeProvider = json['partner_type_provider'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['user_id'] = userId;
    data['first_name'] = firstName;
    data['last_name'] = lastName;
    data['email'] = email;
    data['password'] = password;
    data['company_name'] = companyName;
    data['phone_no'] = phoneNo;
    data['address'] = address;
    data['city'] = city;
    data['state'] = state;
    data['country'] = country;
    data['postal_code'] = postalCode;
    data['website_url'] = websiteUrl;
    data['profile_image'] = profileImage;
    data['updated_on'] = updatedOn;
    data['updated_by_id'] = updatedById;
    data['created_on'] = createdOn;
    data['is_deleted'] = isDeleted;
    data['deleted_on'] = deletedOn;
    data['deleted_by_id'] = deletedById;
    data['password_reset_token'] = passwordResetToken;
    data['password_reset_date'] = passwordResetDate;
    data['is_active'] = isActive;
    data['pan_no'] = panNo;
    data['gst_no'] = gstNo;
    data['email_verify'] = emailVerify;
    data['email_verify_token'] = emailVerifyToken;
    data['email_verify_date'] = emailVerifyDate;
    data['last_login'] = lastLogin;
    data['ip'] = ip;
    data['type'] = type;
    data['user_type'] = userType;
    data['user_experiance'] = userExperiance;
    data['business_address'] = businessAddress;
    data['business_city'] = businessCity;
    data['business_state'] = businessState;
    data['business_postal_code'] = businessPostalCode;
    data['business_details'] = businessDetails;
    data['business_profile_doc'] = businessProfileDoc;
    data['business_country'] = businessCountry;
    data['expertise'] = expertise;
    data['business_mob'] = businessMob;
    data['rating'] = rating;
    data['business_since'] = businessSince;
    data['is_external'] = isExternal;
    data['created_by_id'] = createdById;
    data['referral_code'] = referralCode;
    data['device_id'] = deviceId;
    data['permission_json'] = permissionJson;
    data['role_id'] = roleId;
    data['opt_number'] = optNumber;
    data['is_whitelabeled'] = isWhitelabeled;
    data['is_login'] = isLogin;
    data['my_refferal_code'] = myRefferalCode;
    data['login_count'] = loginCount;
    data['latitude'] = latitude;
    data['longitude'] = longitude;
    data['is_video_enable'] = isVideoEnable;
    data['is_chat_enable'] = isChatEnable;
    data['crop_id'] = cropId;
    data['loc_address'] = locAddress;
    data['city_name'] = cityName;
    data['is_approve'] = isApprove;
    data['is_online'] = isOnline;
    data['username'] = username;
    data['level'] = level;
    data['section_json'] = sectionJson;
    data['uuid'] = uuid;
    data['company_reg_no'] = companyRegNo;
    data['partner_type_provider'] = partnerTypeProvider;
    return data;
  }
}

class ServiceOptions {
  String? serviceId;
  String? partnerId;
  dynamic categoryId;
  String? productServicesName;
  dynamic productServicesNameMr;
  String? overview;
  String? brief;
  dynamic highlight;
  dynamic usage;
  dynamic support;
  String? logo;
  dynamic demoUrl;
  String? createdById;
  String? createdOn;
  dynamic updatedById;
  dynamic updatedOn;
  String? isDeleted;
  dynamic deletedById;
  dynamic deletedOn;
  dynamic serviceType;
  dynamic productServicesOffered;
  String? status;
  String? isActive;
  dynamic isFeatured;
  dynamic isHome;
  dynamic isSlider;
  String? price;
  String? packageNote;
  String? allowIncentive;
  String? state;
  String? city;
  dynamic panIndiaOffering;

  ServiceOptions(
      {this.serviceId,
      this.partnerId,
      this.categoryId,
      this.productServicesName,
      this.productServicesNameMr,
      this.overview,
      this.brief,
      this.highlight,
      this.usage,
      this.support,
      this.logo,
      this.demoUrl,
      this.createdById,
      this.createdOn,
      this.updatedById,
      this.updatedOn,
      this.isDeleted,
      this.deletedById,
      this.deletedOn,
      this.serviceType,
      this.productServicesOffered,
      this.status,
      this.isActive,
      this.isFeatured,
      this.isHome,
      this.isSlider,
      this.price,
      this.packageNote,
      this.allowIncentive,
      this.state,
      this.city,
      this.panIndiaOffering});

  ServiceOptions.fromJson(Map<String, dynamic> json) {
    serviceId = json['service_id'];
    partnerId = json['partner_id'];
    categoryId = json['category_id'];
    productServicesName = json['product_services_name'];
    productServicesNameMr = json['product_services_name_mr'];
    overview = json['overview'];
    brief = json['brief'];
    highlight = json['highlight'];
    usage = json['usage'];
    support = json['support'];
    logo = json['logo'];
    demoUrl = json['demo_url'];
    createdById = json['created_by_id'];
    createdOn = json['created_on'];
    updatedById = json['updated_by_id'];
    updatedOn = json['updated_on'];
    isDeleted = json['is_deleted'];
    deletedById = json['deleted_by_id'];
    deletedOn = json['deleted_on'];
    serviceType = json['service_type'];
    productServicesOffered = json['product_services_offered'];
    status = json['status'];
    isActive = json['is_active'];
    isFeatured = json['is_featured'];
    isHome = json['is_home'];
    isSlider = json['is_slider'];
    price = json['price'];
    packageNote = json['package_note'];
    allowIncentive = json['allow_incentive'];
    state = json['state'];
    city = json['city'];
    panIndiaOffering = json['pan_india_offering'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['service_id'] = serviceId;
    data['partner_id'] = partnerId;
    data['category_id'] = categoryId;
    data['product_services_name'] = productServicesName;
    data['product_services_name_mr'] = productServicesNameMr;
    data['overview'] = overview;
    data['brief'] = brief;
    data['highlight'] = highlight;
    data['usage'] = usage;
    data['support'] = support;
    data['logo'] = logo;
    data['demo_url'] = demoUrl;
    data['created_by_id'] = createdById;
    data['created_on'] = createdOn;
    data['updated_by_id'] = updatedById;
    data['updated_on'] = updatedOn;
    data['is_deleted'] = isDeleted;
    data['deleted_by_id'] = deletedById;
    data['deleted_on'] = deletedOn;
    data['service_type'] = serviceType;
    data['product_services_offered'] = productServicesOffered;
    data['status'] = status;
    data['is_active'] = isActive;
    data['is_featured'] = isFeatured;
    data['is_home'] = isHome;
    data['is_slider'] = isSlider;
    data['price'] = price;
    data['package_note'] = packageNote;
    data['allow_incentive'] = allowIncentive;
    data['state'] = state;
    data['city'] = city;
    data['pan_india_offering'] = panIndiaOffering;
    return data;
  }
}
