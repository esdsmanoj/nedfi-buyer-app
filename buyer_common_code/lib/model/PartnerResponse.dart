import 'AllMenu.dart';

class PartnerModel {
  int? success;
  int? status;
  List<PartnerData>? data;
  ConfigUrl? configUrl;
  String? message;

  PartnerModel({this.success, this.status, this.data, this.configUrl, this.message});

  PartnerModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    status = json['status'];
    if (json['data'] != null) {
      data = <PartnerData>[];
      json['data'].forEach((v) {
        data!.add(PartnerData.fromJson(v));
      });
    }
    configUrl = json['config_url'] != null ? ConfigUrl.fromJson(json['config_url']) : null;
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['success'] = success;
    data['status'] = status;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    if (configUrl != null) {
      data['config_url'] = configUrl!.toJson();
    }
    data['message'] = message;
    return data;
  }
}

class PartnerData {
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
  dynamic lastLogin;
  dynamic ip;
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
  dynamic latitude;
  dynamic longitude;
  String? isVideoEnable;
  String? isChatEnable;
  String? cropId;
  dynamic locAddress;
  dynamic cityName;
  dynamic isApprove;
  String? isOnline;
  String? username;
  dynamic level;
  dynamic sectionJson;
  String? uuid;
  dynamic companyRegNo;
  dynamic partnerTypeProvider;

  PartnerData(
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

  PartnerData.fromJson(Map<String, dynamic> json) {
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
    final Map<String, dynamic> data = <String, dynamic>{};
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
