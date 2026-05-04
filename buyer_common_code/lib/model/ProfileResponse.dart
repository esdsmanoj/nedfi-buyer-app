import 'package:buyer_common_code/model/User.dart';

class ProfileResponse {
  ProfileResponse({
    required this.success,
    required this.error,
    required this.status,
    required this.data,
    required this.message,
    required this.usrData,
    required this.sqlQuery,
    required this.is_registered,
    required this.partner_type_name,
    required this.configUrl,
  });
  late final int success;
  late final int error;
  late final int status;
  late final List<ProfileData> data;
 // late final Data data;
  late  String? message;
  late  List<UsrData>? usrData=null;
  late  String sqlQuery="";
  late  int? is_registered;
  late String? partner_type_name;
  late final UserConfigUrl configUrl;

  ProfileResponse.fromJson(Map<String, dynamic> json){
    configUrl = UserConfigUrl.fromJson(json['config_url']);
    success = json['success'];
    error = json['error'];
    status = json['status'];
    partner_type_name = json['partner_type_name'];
    if (json['data'] != null){
       data = List.from(json['data']).map((e) => ProfileData.fromJson(e)).toList();
      //data = Data.fromJson(json['data']);
    }
    message = json['message'];
    if(json['usr_data']!=null) {
      //  usrData =
      //       List.from(json['usr_data']).map((e) => UsrData.fromJson(e)).toList();
    }
    if(json['sql_query']!=null) {
      sqlQuery = json['sql_query'];
    }
    if(json['is_registered']!=null) {
      is_registered = json['is_registered'];
    }
  }

  get profile_image => null;

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['success'] = success;
    _data['error'] = error;
    _data['status'] = status;
     _data['data'] = data.map((e)=>e.toJson()).toList();
    //_data['data'] = data.toJson();
    _data['message'] = message;
    _data['partner_type_name'] = partner_type_name;
    if(usrData!=null){
      // _data['usr_data'] = usrData?.map((e)=>e.toJson()).toList();
    }
    if(sqlQuery!=null) {
      _data['sql_query'] = sqlQuery;
    }
    /* if(is_registered!=null){
     // _data['is_registered'] = is_registered;
    }*/
    _data['config_url'] = configUrl.toJson();
    return _data;
  }
}

class ProfileData {
  ProfileData({
    this.userId,
    this.firstName,
    this.lastName,
    this.email,
    this.phone,
    this.address1,
    this.address2,
    this.city,
    this.postcode,
    this.countryName,
    this.stateName,
    this.branchName,
    this.bankName,
    this.state,
    this.accNo,
    this.ifscCode,
    this.village,
    this.panNo,
    this.gstNo,
    this.company,
    this.profileStatus,
    this.documentStatus,
    this.userType,
    this.profileImage,
    this.panNoDoc,
    this.aadharNoDoc,
    this.aadharNo,
    this.groupId,
    this.dob,
    this.gender,
    this.loggedIn,
    this.isLogin,
    this.myRefferalCode,
    this.iotDeviceUrl,
    this.ACCESSTOKEN,
    this.isWhitelabeled,
    this.isVideoEnable,
    this.isChatEnable,
    this.pacsMasterId,
    this.societyMasterId,
    this.bankMasterId,
    this.groupIds,
  });
  String? userId;
  String? firstName;
  String? lastName;
  String? email;
  String? phone;
  String? address1;
  String? address2;
  String? city;
  String? postcode;
  String? countryName;
  String? stateName;
  String? branchName;
  String? bankName;
  String? state;
  String? accNo;
  String? ifscCode;
  String? village;
  String? panNo;
  String? gstNo;
  String? company;
  String? profileStatus;
  String? documentStatus;
  String? userType;
  String? profileImage;
  String? panNoDoc;
  String? aadharNoDoc;
  String? aadharNo;
  String? groupId;
  String? dob;
  String? gender;
  bool? loggedIn;
  bool? isLogin;
  String? myRefferalCode;
  String? iotDeviceUrl;
  String? ACCESSTOKEN;
  String? isWhitelabeled;
  String? isVideoEnable;
  String? isChatEnable;
  String? pacsMasterId;
  String? societyMasterId;
  String? bankMasterId;
  String? groupIds;

  ProfileData.fromJson(Map<String, dynamic> json){
    userId = json['user_id']??"";
    firstName = json['first_name']??"";
    lastName =json['last_name']??"";
    email =json['user_id']??"";
    phone = json['phone']??"";
    address1 = json['address1']??"";
    address2 = json['address2']??"";
    city =json['city']??"";
    postcode = json['postcode']??"";
    countryName = json['country_name']??"";
    stateName = json['state_name']??"";
    branchName = json['branch_name']??"";
    bankName = json['bank_name']??"";
    state =json['state']??"";
    accNo = json['acc_no']??"";
    ifscCode = json['ifsc_code']??"";
    village = json['village']??"";
    panNo = json['pan_no']??"";
    gstNo = json['gst_no']??"";
    company =json['company']??"";
    profileStatus = json['profile_status']??"";
    documentStatus = json['document_status']??"";
    userType = json['user_type']??"";
    profileImage = json['profile_image']??"";
    panNoDoc = json['pan_no_doc']??"";
    aadharNoDoc = json['aadhar_no_doc']??"";
    aadharNo = json['aadhar_no']??"";
    groupId = json['group_id']??"";
    dob = json['dob']??"";
    gender = json['gender']??"";
    loggedIn = json['logged_in']??false;
    isLogin = /*json['is_login']??*/false;
    myRefferalCode = json['my_refferal_code']??"";
    iotDeviceUrl = json['iotDeviceUrl']??"";
    ACCESSTOKEN = json['ACCESS_TOKEN']??"";
    isWhitelabeled = json['is_whitelabeled']??"";
    isVideoEnable = json['is_video_enable']??"";
    isChatEnable = json['is_chat_enable']??"";
    pacsMasterId =json['pacs_master_id']??"";
    societyMasterId = json['society_master_id']??"";
    bankMasterId = json['bank_master_id']??"";
    groupIds = json['group_ids']??"";
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['user_id'] = userId;
    _data['first_name'] = firstName;
    _data['last_name'] = lastName;
    _data['email'] = email;
    _data['phone'] = phone;
    _data['address1'] = address1;
    _data['address2'] = address2;
    _data['city'] = city;
    _data['postcode'] = postcode;
    _data['country_name'] = countryName;
    _data['state_name'] = stateName;
    _data['branch_name'] = branchName;
    _data['bank_name'] = bankName;
    _data['state'] = state;
    _data['acc_no'] = accNo;
    _data['ifsc_code'] = ifscCode;
    _data['village'] = village;
    _data['pan_no'] = panNo;
    _data['gst_no'] = gstNo;
    _data['company'] = company;
    _data['profile_status'] = profileStatus;
    _data['document_status'] = documentStatus;
    _data['user_type'] = userType;
    _data['profile_image'] = profileImage;
    _data['pan_no_doc'] = panNoDoc;
    _data['aadhar_no_doc'] = aadharNoDoc;
    _data['aadhar_no'] = aadharNo;
    _data['group_id'] = groupId;
    _data['dob'] = dob;
    _data['gender'] = gender;
    _data['logged_in'] = loggedIn;
    _data['is_login'] = isLogin;
    _data['my_refferal_code'] = myRefferalCode;
    _data['iot_device_url'] = iotDeviceUrl;
    _data['ACCESS_TOKEN'] = ACCESSTOKEN;
    _data['is_whitelabeled'] = isWhitelabeled;
    _data['is_video_enable'] = isVideoEnable;
    _data['is_chat_enable'] = isChatEnable;
    _data['pacs_master_id'] = pacsMasterId;
    _data['society_master_id'] = societyMasterId;
    _data['bank_master_id'] = bankMasterId;
    _data['group_ids'] = groupIds;
    return _data;
  }
}

class UsrData {
  UsrData({
    required this.userId,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.password,
    required this.companyName,
    required this.phoneNo,
    required this.address,
    required this.city,
    required this.state,
    required this.country,
    required this.postalCode,
    required this.websiteUrl,
    required this.profileImage,
    required this.updatedOn,
    required this.updatedById,
    required this.createdOn,
    required this.isDeleted,
    required this.deletedOn,
    required this.deletedById,
    required this.passwordResetToken,
    required this.passwordResetDate,
    required this.isActive,
    required this.panNo,
    required this.gstNo,
    required this.emailVerify,
    required this.emailVerifyToken,
    required this.emailVerifyDate,
    required this.lastLogin,
    required this.ip,
    required this.type,
    required this.userType,
    required this.userExperiance,
    required this.businessAddress,
    required this.businessCity,
    required this.businessState,
    required this.businessPostalCode,
    required this.businessDetails,
    required this.businessProfileDoc,
    required this.businessCountry,
    required this.expertise,
    required this.businessMob,
    required this.rating,
    required this.businessSince,
    required this.isExternal,
    required this.createdById,
    required this.referralCode,
    required this.deviceId,
    required this.permissionJson,
    required this.roleId,
    required this.optNumber,
    required this.isApprove,
    required this.isWhitelabeled,
    required this.isLogin,
    required this.myRefferalCode,
    required this.loginCount,
    required this.latitude,
    required this.longitude,
    required this.isVideoEnable,
    required this.isChatEnable,
    required this.cropId,
  });
  late final String userId;
  late final String firstName;
  late final String lastName;
  late final String email;
  late final String password;
  late final String companyName;
  late final String phoneNo;
  late final String address;
  late final String city;
  late final String state;
  late final String country;
  late final String postalCode;
  late final String websiteUrl;
  late final String profileImage;
  late final String updatedOn;
  late final String updatedById;
  late final String createdOn;
  late final String isDeleted;
  late final String deletedOn;
  late final String deletedById;
  late final String passwordResetToken;
  late final String passwordResetDate;
  late final String isActive;
  late final String panNo;
  late final String gstNo;
  late final String emailVerify;
  late final String emailVerifyToken;
  late final String emailVerifyDate;
  late final String lastLogin;
  late final String ip;
  late final String type;
  late final String userType;
  late final String userExperiance;
  late final String businessAddress;
  late final String businessCity;
  late final String businessState;
  late final String businessPostalCode;
  late final String businessDetails;
  late final String businessProfileDoc;
  late final String businessCountry;
  late final String expertise;
  late final String businessMob;
  late final String rating;
  late final String businessSince;
  late final String isExternal;
  late final String createdById;
  late final String referralCode;
  late final String deviceId;
  late final String permissionJson;
  late final String roleId;
  late final String optNumber;
  late final String isApprove;
  late final String isWhitelabeled;
  late final String isLogin;
  late final String myRefferalCode;
  late final String loginCount;
  late final String latitude;
  late final String longitude;
  late final String isVideoEnable;
  late final String isChatEnable;
  late final String cropId;

  UsrData.fromJson(Map<String, dynamic> json){
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
    websiteUrl = json['websiteUrl'];
    profileImage = json['profile_image'];
    updatedOn = json['updated_on'];
    updatedById = json['updated_by_id'];
    createdOn = json['created_on'];
    isDeleted = json['is_deleted'];
    deletedOn = json['deletedOn'];
    deletedById = json['deletedById'];
    passwordResetToken = json['passwordResetToken'];
    passwordResetDate = json['passwordResetDate'];
    isActive = json['is_active'];
    panNo = json['panNo'];
    gstNo = json['gstNo'];
    emailVerify = json['email_verify'];
    emailVerifyToken = json['emailVerifyToken'];
    emailVerifyDate = json['emailVerifyDate'];
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
    businessProfileDoc = json['businessProfileDoc'];
    businessCountry = json['business_country'];
    expertise = json['expertise'];
    businessMob = json['business_mob'];
    rating = json['rating'];
    businessSince = json['business_since'];
    isExternal = json['is_external'];
    createdById = json['createdById'];
    referralCode = json['referral_code'];
    deviceId = json['deviceId'];
    permissionJson =json['permissionJson'];
    roleId = json['roleId'];
    optNumber = json['opt_number'];
    isApprove = json['is_approve'];
    isWhitelabeled = json['is_whitelabeled'];
    isLogin = json['is_login'];
    myRefferalCode = json['my_refferal_code'];
    loginCount = json['login_count'];
    latitude =json['latitude'];
    longitude = json['longitude'];
    isVideoEnable = json['is_video_enable'];
    isChatEnable = json['is_chat_enable'];
    cropId = json['cropId'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['user_id'] = userId;
    _data['first_name'] = firstName;
    _data['last_name'] = lastName;
    _data['email'] = email;
    _data['password'] = password;
    _data['company_name'] = companyName;
    _data['phone_no'] = phoneNo;
    _data['address'] = address;
    _data['city'] = city;
    _data['state'] = state;
    _data['country'] = country;
    _data['postal_code'] = postalCode;
    _data['website_url'] = websiteUrl;
    _data['profile_image'] = profileImage;
    _data['updated_on'] = updatedOn;
    _data['updated_by_id'] = updatedById;
    _data['created_on'] = createdOn;
    _data['is_deleted'] = isDeleted;
    _data['deleted_on'] = deletedOn;
    _data['deleted_by_id'] = deletedById;
    _data['password_reset_token'] = passwordResetToken;
    _data['password_reset_date'] = passwordResetDate;
    _data['is_active'] = isActive;
    _data['pan_no'] = panNo;
    _data['gst_no'] = gstNo;
    _data['email_verify'] = emailVerify;
    _data['email_verify_token'] = emailVerifyToken;
    _data['email_verify_date'] = emailVerifyDate;
    _data['last_login'] = lastLogin;
    _data['ip'] = ip;
    _data['type'] = type;
    _data['user_type'] = userType;
    _data['user_experiance'] = userExperiance;
    _data['business_address'] = businessAddress;
    _data['business_city'] = businessCity;
    _data['business_state'] = businessState;
    _data['business_postal_code'] = businessPostalCode;
    _data['business_details'] = businessDetails;
    _data['business_profile_doc'] = businessProfileDoc;
    _data['business_country'] = businessCountry;
    _data['expertise'] = expertise;
    _data['business_mob'] = businessMob;
    _data['rating'] = rating;
    _data['business_since'] = businessSince;
    _data['is_external'] = isExternal;
    _data['created_by_id'] = createdById;
    _data['referral_code'] = referralCode;
    _data['device_id'] = deviceId;
    _data['permission_json'] = permissionJson;
    _data['role_id'] = roleId;
    _data['opt_number'] = optNumber;
    _data['is_approve'] = isApprove;
    _data['is_whitelabeled'] = isWhitelabeled;
    _data['is_login'] = isLogin;
    _data['my_refferal_code'] = myRefferalCode;
    _data['login_count'] = loginCount;
    _data['latitude'] = latitude;
    _data['longitude'] = longitude;
    _data['is_video_enable'] = isVideoEnable;
    _data['is_chat_enable'] = isChatEnable;
    _data['crop_id'] = cropId;
    return _data;
  }
}