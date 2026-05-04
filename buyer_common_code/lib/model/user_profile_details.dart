class UserProfileDetails {
  int? success;
  int? error;
  int? status;
  List<Data>? data;
  String? message;
  String? imagePath;

  UserProfileDetails({this.success, this.error, this.status, this.data, this.message, this.imagePath});

  UserProfileDetails.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    error = json['error'];
    status = json['status'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(Data.fromJson(v));
      });
    }
    message = json['message'];
    imagePath = json['profile_image_path'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['success'] = success;
    data['error'] = error;
    data['status'] = status;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['message'] = message;
    data['profile_image_path'] = imagePath;
    return data;
  }
}

class Data {
  String? firstName;
  Null? middleName;
  String? lastName;
  String? address1;
  String? profileImage;
  String? state;
  String? city;
  String? village;
  String? postcode;
  String? activeStep;
  String? appUserType;
  String? appUserTypeText;
  String? panNo;
  String? aadharNo;
  String? clientType;
  String? businessType;
  String? businessScheme;
  String? businessName;
  String? businessDesignation;
  String? businessAddress;
  String? businessState;
  String? businessDistrict;
  String? businessCityVillage;
  String? businessPincode;
  String? businessRegNo;
  String? businessPan;
  String? businessGstin;
  List<AadharVerification>? aadharVerification;
  List<AadharVerification>? panVerification;

  Data(
      {this.firstName,
      this.middleName,
      this.lastName,
      this.address1,
      this.profileImage,
      this.state,
      this.city,
      this.village,
      this.postcode,
      this.activeStep,
      this.appUserType,
      this.appUserTypeText,
      this.panNo,
      this.aadharNo,
      this.clientType,
      this.businessType,
      this.businessScheme,
      this.businessName,
      this.businessDesignation,
      this.businessAddress,
      this.businessState,
      this.businessDistrict,
      this.businessCityVillage,
      this.businessPincode,
      this.businessRegNo,
      this.businessPan,
      this.businessGstin,
      this.aadharVerification,
      this.panVerification});

  Data.fromJson(Map<String, dynamic> json) {
    firstName = json['first_name'];
    middleName = json['middle_name'];
    lastName = json['last_name'];
    address1 = json['address1'];
    profileImage = json['profile_image'];
    state = json['state'];
    city = json['city'];
    village = json['village'];
    postcode = json['postcode'];
    activeStep = json['active_step'];
    appUserType = json['app_user_type'];
    appUserTypeText = json['app_user_type_text'];
    panNo = json['pan_no'];
    aadharNo = json['aadhar_no'];
    clientType = json['client-type'];
    businessType = json['business_type'];
    businessScheme = json['business_scheme'];
    businessName = json['business_name'];
    businessAddress = json['business_address'];
    businessState = json['business_state'];
    businessDistrict = json['business_district'];
    businessCityVillage = json['business_city_village'];
    businessPincode = json['business_pincode'];
    businessRegNo = json['business_reg_no'];
    businessPan = json['business_pan'];
    businessGstin = json['business_gstin'];
    businessDesignation = json['business_designation'];
    if (json['aadhar_verification'] != null) {
      aadharVerification = <AadharVerification>[];
      json['aadhar_verification'].forEach((v) {
        aadharVerification!.add(AadharVerification.fromJson(v));
      });
    }
    if (json['pan_verification'] != null) {
      panVerification = <AadharVerification>[];
      json['pan_verification'].forEach((v) {
        panVerification!.add(AadharVerification.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['first_name'] = firstName;
    data['middle_name'] = middleName;
    data['last_name'] = lastName;
    data['address1'] = address1;
    data['profile_image'] = profileImage;
    data['state'] = state;
    data['city'] = city;
    data['village'] = village;
    data['postcode'] = postcode;
    data['active_step'] = activeStep;
    data['app_user_type'] = appUserType;
    data['app_user_type_text'] = appUserTypeText;
    data['pan_no'] = panNo;
    data['aadhar_no'] = aadharNo;
    data['client-type'] = clientType;
    data['business_type'] = businessType;
    data['business_scheme'] = businessScheme;
    data['business_name'] = businessName;
    data['business_designation'] = businessDesignation;
    data['business_address'] = businessAddress;
    data['business_state'] = businessState;
    data['business_district'] = businessDistrict;
    data['business_city_village'] = businessCityVillage;
    data['business_pincode'] = businessPincode;
    data['business_reg_no'] = businessRegNo;
    data['business_pan'] = businessPan;
    data['business_gstin'] = businessGstin;
    if (aadharVerification != null) {
      data['aadhar_verification'] = aadharVerification!.map((v) => v.toJson()).toList();
    }
    if (panVerification != null) {
      data['pan_verification'] = panVerification!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class AadharVerification {
  String? documentType;
  String? isVerify;

  AadharVerification({this.documentType, this.isVerify});

  AadharVerification.fromJson(Map<String, dynamic> json) {
    documentType = json['document_type'];
    isVerify = json['is_verify'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['document_type'] = documentType;
    data['is_verify'] = isVerify;
    return data;
  }
}
