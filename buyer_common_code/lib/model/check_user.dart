class CheckUser {
  int? success;
  int? error;
  int? status;
  List<Data>? data;
  List<StepList>? stepList;
  String? message;
  int? isRegistered;
  String? appUserType;
  String? showReferral;
  int? isProfileComplete;
  String? registrationLock;
  String? registrationLockMessge;

  CheckUser(
      {this.success,
        this.error,
        this.status,
        this.data,
        this.stepList,
        this.message,
        this.isRegistered,
        this.appUserType,
        this.showReferral,
        this.isProfileComplete,
        this.registrationLock,
        this.registrationLockMessge});

  CheckUser.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    error = json['error'];
    status = json['status'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(Data.fromJson(v));
      });
    }
    if (json['step_list'] != null) {
      stepList = <StepList>[];
      json['step_list'].forEach((v) {
        stepList!.add(StepList.fromJson(v));
      });
    }
    message = json['message'];
    isRegistered = json['is_registered'];
    appUserType = json['app_user_type'];
    showReferral = json['show_referral'];
    isProfileComplete = json['is_profile_complete'];
    registrationLock = json['registration_lock'];
    registrationLockMessge = json['registration_lock_messge'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['success'] = success;
    data['error'] = error;
    data['status'] = status;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    if (stepList != null) {
      data['step_list'] = stepList!.map((v) => v.toJson()).toList();
    }
    data['message'] = message;
    data['is_registered'] = isRegistered;
    data['app_user_type'] = appUserType;
    data['show_referral'] = showReferral;
    data['is_profile_complete'] = isProfileComplete;
    data['registration_lock'] = registrationLock;
    data['registration_lock_messge'] = registrationLockMessge;
    return data;
  }
}

class Data {
  String? id;
  String? firstName;
  dynamic middleName;
  String? lastName;
  dynamic email;
  String? phone;
  dynamic password;
  String? address1;
  dynamic address2;
  String? state;
  String? city;
  String? postcode;
  dynamic company;
  String? emailVerify;
  dynamic invoiceType;
  dynamic country;
  String? profileImage;
  String? isActive;
  String? createdOn;
  String? updatedOn;
  String? isDeleted;
  dynamic deletedOn;
  dynamic paymentMethod;
  dynamic passwordResetToken;
  dynamic passwordResetDate;
  dynamic emailVerifyToken;
  dynamic emailVerifyDate;
  dynamic updatedById;
  String? panNo;
  dynamic gstNo;
  dynamic regOtp;
  dynamic otpGeneratedOn;
  String? isOtpVerified;
  dynamic lastLogin;
  dynamic ip;
  String? village;
  dynamic aadharNo;
  dynamic ifscCode;
  dynamic bankName;
  dynamic accNo;
  dynamic branchName;
  dynamic dob;
  dynamic villageCity;
  String? profileStatus;
  String? documentStatus;
  dynamic gender;
  dynamic aadharNoDoc;
  dynamic panNoDoc;
  dynamic clientMasterKey;
  dynamic iotDeviceUrl;
  dynamic iotPlatformId;
  dynamic iotUsername;
  dynamic iotPassword;
  dynamic tempData;
  dynamic groupId;
  dynamic latitude;
  dynamic longitude;
  String? deviceId;
  dynamic cityName;
  String? loginCount;
  dynamic locPostalCode;
  dynamic locState;
  dynamic locAddresss;
  dynamic locCountry;
  dynamic referralCode;
  String? groupIds;
  dynamic bankMasterId;
  dynamic pacsMasterId;
  dynamic societyMasterId;
  String? optNumber;
  String? isWhitelabeled;
  String? isLogin;
  String? myRefferalCode;
  String? isChatEnable;
  String? isVideoEnable;
  dynamic createdById;
  dynamic regionId;
  String? isOnline;
  dynamic username;
  dynamic authToken;
  dynamic soilHealthcard;
  dynamic ncUserId;
  dynamic ncTokenKey;
  dynamic ncPassword;
  dynamic aadharNoDocBack;
  dynamic accHolderName;
  String? appUserType;
  dynamic doc712;
  String? otherJson;
  String? appUserTypeText;
  String? activeStep;
  dynamic businessType;
  dynamic businessScheme;
  dynamic uuid;
  dynamic aadharVerifiedName;
  String? panVerifiedName;
  String? clientType;

  Data(
      {this.id,
        this.firstName,
        this.middleName,
        this.lastName,
        this.email,
        this.phone,
        this.password,
        this.address1,
        this.address2,
        this.state,
        this.city,
        this.postcode,
        this.company,
        this.emailVerify,
        this.invoiceType,
        this.country,
        this.profileImage,
        this.isActive,
        this.createdOn,
        this.updatedOn,
        this.isDeleted,
        this.deletedOn,
        this.paymentMethod,
        this.passwordResetToken,
        this.passwordResetDate,
        this.emailVerifyToken,
        this.emailVerifyDate,
        this.updatedById,
        this.panNo,
        this.gstNo,
        this.regOtp,
        this.otpGeneratedOn,
        this.isOtpVerified,
        this.lastLogin,
        this.ip,
        this.village,
        this.aadharNo,
        this.ifscCode,
        this.bankName,
        this.accNo,
        this.branchName,
        this.dob,
        this.villageCity,
        this.profileStatus,
        this.documentStatus,
        this.gender,
        this.aadharNoDoc,
        this.panNoDoc,
        this.clientMasterKey,
        this.iotDeviceUrl,
        this.iotPlatformId,
        this.iotUsername,
        this.iotPassword,
        this.tempData,
        this.groupId,
        this.latitude,
        this.longitude,
        this.deviceId,
        this.cityName,
        this.loginCount,
        this.locPostalCode,
        this.locState,
        this.locAddresss,
        this.locCountry,
        this.referralCode,
        this.groupIds,
        this.bankMasterId,
        this.pacsMasterId,
        this.societyMasterId,
        this.optNumber,
        this.isWhitelabeled,
        this.isLogin,
        this.myRefferalCode,
        this.isChatEnable,
        this.isVideoEnable,
        this.createdById,
        this.regionId,
        this.isOnline,
        this.username,
        this.authToken,
        this.soilHealthcard,
        this.ncUserId,
        this.ncTokenKey,
        this.ncPassword,
        this.aadharNoDocBack,
        this.accHolderName,
        this.appUserType,
        this.doc712,
        this.otherJson,
        this.appUserTypeText,
        this.activeStep,
        this.businessType,
        this.businessScheme,
        this.uuid,
        this.aadharVerifiedName,
        this.panVerifiedName,
        this.clientType});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    firstName = json['first_name'];
    middleName = json['middle_name'];
    lastName = json['last_name'];
    email = json['email'];
    phone = json['phone'];
    password = json['password'];
    address1 = json['address1'];
    address2 = json['address2'];
    state = json['state'];
    city = json['city'];
    postcode = json['postcode'];
    company = json['company'];
    emailVerify = json['email_verify'];
    invoiceType = json['invoice_type'];
    country = json['country'];
    profileImage = json['profile_image'];
    isActive = json['is_active'];
    createdOn = json['created_on'];
    updatedOn = json['updated_on'];
    isDeleted = json['is_deleted'];
    deletedOn = json['deleted_on'];
    paymentMethod = json['payment_method'];
    passwordResetToken = json['password_reset_token'];
    passwordResetDate = json['password_reset_date'];
    emailVerifyToken = json['email_verify_token'];
    emailVerifyDate = json['email_verify_date'];
    updatedById = json['updated_by_id'];
    panNo = json['pan_no'];
    gstNo = json['gst_no'];
    regOtp = json['reg_otp'];
    otpGeneratedOn = json['otp_generated_on'];
    isOtpVerified = json['is_otp_verified'];
    lastLogin = json['last_login'];
    ip = json['ip'];
    village = json['village'];
    aadharNo = json['aadhar_no'];
    ifscCode = json['ifsc_code'];
    bankName = json['bank_name'];
    accNo = json['acc_no'];
    branchName = json['branch_name'];
    dob = json['dob'];
    villageCity = json['village_city'];
    profileStatus = json['profile_status'];
    documentStatus = json['document_status'];
    gender = json['gender'];
    aadharNoDoc = json['aadhar_no_doc'];
    panNoDoc = json['pan_no_doc'];
    clientMasterKey = json['client_master_key'];
    iotDeviceUrl = json['iot_device_url '];
    iotPlatformId = json['iot_platform_id'];
    iotUsername = json['iot_username'];
    iotPassword = json['iot_password'];
    tempData = json['temp_data'];
    groupId = json['group_id'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    deviceId = json['device_id'];
    cityName = json['city_name'];
    loginCount = json['login_count'];
    locPostalCode = json['loc_postal_code'];
    locState = json['loc_state'];
    locAddresss = json['loc_addresss'];
    locCountry = json['loc_country'];
    referralCode = json['referral_code'];
    groupIds = json['group_ids'];
    bankMasterId = json['bank_master_id'];
    pacsMasterId = json['pacs_master_id'];
    societyMasterId = json['society_master_id'];
    optNumber = json['opt_number'];
    isWhitelabeled = json['is_whitelabeled'];
    isLogin = json['is_login'];
    myRefferalCode = json['my_refferal_code'];
    isChatEnable = json['is_chat_enable'];
    isVideoEnable = json['is_video_enable'];
    createdById = json['created_by_id'];
    regionId = json['region_id'];
    isOnline = json['is_online'];
    username = json['username'];
    authToken = json['auth_token'];
    soilHealthcard = json['soil_healthcard'];
    ncUserId = json['nc_user_id'];
    ncTokenKey = json['nc_token_key'];
    ncPassword = json['nc_password'];
    aadharNoDocBack = json['aadhar_no_doc_back'];
    accHolderName = json['acc_holder_name'];
    appUserType = json['app_user_type'];
    doc712 = json['doc_7_12'];
    otherJson = json['other_json'];
    appUserTypeText = json['app_user_type_text'];
    activeStep = json['active_step'];
    businessType = json['business_type'];
    businessScheme = json['business_scheme'];
    uuid = json['uuid'];
    aadharVerifiedName = json['aadhar_verified_name'];
    panVerifiedName = json['pan_verified_name'];
    clientType = json['client-type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = id;
    data['first_name'] = firstName;
    data['middle_name'] = middleName;
    data['last_name'] = lastName;
    data['email'] = email;
    data['phone'] = phone;
    data['password'] = password;
    data['address1'] = address1;
    data['address2'] = address2;
    data['state'] = state;
    data['city'] = city;
    data['postcode'] = postcode;
    data['company'] = company;
    data['email_verify'] = emailVerify;
    data['invoice_type'] = invoiceType;
    data['country'] = country;
    data['profile_image'] = profileImage;
    data['is_active'] = isActive;
    data['created_on'] = createdOn;
    data['updated_on'] = updatedOn;
    data['is_deleted'] = isDeleted;
    data['deleted_on'] = deletedOn;
    data['payment_method'] = paymentMethod;
    data['password_reset_token'] = passwordResetToken;
    data['password_reset_date'] = passwordResetDate;
    data['email_verify_token'] = emailVerifyToken;
    data['email_verify_date'] = emailVerifyDate;
    data['updated_by_id'] = updatedById;
    data['pan_no'] = panNo;
    data['gst_no'] = gstNo;
    data['reg_otp'] = regOtp;
    data['otp_generated_on'] = otpGeneratedOn;
    data['is_otp_verified'] = isOtpVerified;
    data['last_login'] = lastLogin;
    data['ip'] = ip;
    data['village'] = village;
    data['aadhar_no'] = aadharNo;
    data['ifsc_code'] = ifscCode;
    data['bank_name'] = bankName;
    data['acc_no'] = accNo;
    data['branch_name'] = branchName;
    data['dob'] = dob;
    data['village_city'] = villageCity;
    data['profile_status'] = profileStatus;
    data['document_status'] = documentStatus;
    data['gender'] = gender;
    data['aadhar_no_doc'] = aadharNoDoc;
    data['pan_no_doc'] = panNoDoc;
    data['client_master_key'] = clientMasterKey;
    data['iot_device_url '] = iotDeviceUrl;
    data['iot_platform_id'] = iotPlatformId;
    data['iot_username'] = iotUsername;
    data['iot_password'] = iotPassword;
    data['temp_data'] = tempData;
    data['group_id'] = groupId;
    data['latitude'] = latitude;
    data['longitude'] = longitude;
    data['device_id'] = deviceId;
    data['city_name'] = cityName;
    data['login_count'] = loginCount;
    data['loc_postal_code'] = locPostalCode;
    data['loc_state'] = locState;
    data['loc_addresss'] = locAddresss;
    data['loc_country'] = locCountry;
    data['referral_code'] = referralCode;
    data['group_ids'] = groupIds;
    data['bank_master_id'] = bankMasterId;
    data['pacs_master_id'] = pacsMasterId;
    data['society_master_id'] = societyMasterId;
    data['opt_number'] = optNumber;
    data['is_whitelabeled'] = isWhitelabeled;
    data['is_login'] = isLogin;
    data['my_refferal_code'] = myRefferalCode;
    data['is_chat_enable'] = isChatEnable;
    data['is_video_enable'] = isVideoEnable;
    data['created_by_id'] = createdById;
    data['region_id'] = regionId;
    data['is_online'] = isOnline;
    data['username'] = username;
    data['auth_token'] = authToken;
    data['soil_healthcard'] = soilHealthcard;
    data['nc_user_id'] = ncUserId;
    data['nc_token_key'] = ncTokenKey;
    data['nc_password'] = ncPassword;
    data['aadhar_no_doc_back'] = aadharNoDocBack;
    data['acc_holder_name'] = accHolderName;
    data['app_user_type'] = appUserType;
    data['doc_7_12'] = doc712;
    data['other_json'] = otherJson;
    data['app_user_type_text'] = appUserTypeText;
    data['active_step'] = activeStep;
    data['business_type'] = businessType;
    data['business_scheme'] = businessScheme;
    data['uuid'] = uuid;
    data['aadhar_verified_name'] = aadharVerifiedName;
    data['pan_verified_name'] = panVerifiedName;
    data['client-type'] = clientType;
    return data;
  }
}

class StepList {
  int? id;
  String? title;
  String? mapKey;

  StepList({this.id, this.title, this.mapKey});

  StepList.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    mapKey = json['map_key'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = id;
    data['title'] = title;
    data['map_key'] = mapKey;
    return data;
  }
}
