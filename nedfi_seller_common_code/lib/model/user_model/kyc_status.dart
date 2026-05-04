class EKYCStatus {
  String? ekyc;
  String? ekycAadharVerify;
  String? ekycBankVerify;
  String? ekycPanVerify;
  String? businessPanVerify;
  Pan? pan;
  Bank? bank;
  Aadhaar? aadhaar;
  Pan? businessPan;
  String? aadhaarVerifySataus;
  String? panVerifySataus;
  String? bankVerifyStatus;
  String? businessPanVerifyStatus;
  String? appUserType;

  EKYCStatus(
      {this.ekyc,
      this.ekycAadharVerify,
      this.ekycBankVerify,
      this.ekycPanVerify,
      this.businessPanVerify,
      this.pan,
      this.bank,
      this.aadhaar,
      this.businessPan,
      this.aadhaarVerifySataus,
      this.panVerifySataus,
      this.bankVerifyStatus,
      this.businessPanVerifyStatus});

  EKYCStatus.fromJson(Map<String, dynamic> json) {
    ekyc = json['ekyc'];
    ekycAadharVerify = json['ekyc_aadhar_verify'];
    ekycBankVerify = json['ekyc_bank_verify'];
    ekycPanVerify = json['ekyc_pan_verify'];
    businessPanVerify = json['ekyc_business_pan_verify'];
    pan = json['Pan'] != null ? Pan.fromJson(json['Pan']) : null;
    businessPan = json['Businesspan'] != null ? Pan.fromJson(json['Businesspan']) : null;
    bank = json['Bank'] != null ? Bank.fromJson(json['Bank']) : null;
    aadhaar = json['Aadhaar'] != null ? Aadhaar.fromJson(json['Aadhaar']) : null;
    aadhaarVerifySataus = json['aadhaar_verify_sataus'];
    panVerifySataus = json['pan_verify_sataus'];
    bankVerifyStatus = json['bank_verify_status'];
    businessPanVerifyStatus = json['business_pan_verify_status'];
    appUserType = json['app_user_type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['ekyc'] = ekyc;
    data['ekyc_aadhar_verify'] = ekycAadharVerify;
    data['ekyc_bank_verify'] = ekycBankVerify;
    data['ekyc_pan_verify'] = ekycPanVerify;
    data['ekyc_business_pan_verify'] = businessPanVerify;
    if (businessPan != null) {
      data['Businesspan'] = businessPan!.toJson();
    }
    if (pan != null) {
      data['Pan'] = pan!.toJson();
    }
    if (bank != null) {
      data['Bank'] = bank!.toJson();
    }
    if (aadhaar != null) {
      data['Aadhaar'] = aadhaar!.toJson();
    }
    data['aadhaar_verify_sataus'] = aadhaarVerifySataus;
    data['pan_verify_sataus'] = panVerifySataus;
    data['bank_verify_status'] = bankVerifyStatus;
    data['business_pan_verify_status'] = businessPanVerifyStatus;
    data['app_user_type'] = appUserType;
    return data;
  }
}

class Pan {
  String? panNumber;
  String? userFullName;

  Pan({this.panNumber, this.userFullName});

  Pan.fromJson(Map<String, dynamic> json) {
    panNumber = json['pan_number'];
    userFullName = json['user_full_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['pan_number'] = panNumber;
    data['user_full_name'] = userFullName;
    return data;
  }
}

class Bank {
  dynamic userAccountNumber;
  dynamic ifscCode;
  String? bank;
  String? branchName;

  Bank({this.userAccountNumber, this.ifscCode, this.bank, this.branchName});

  Bank.fromJson(Map<String, dynamic> json) {
    userAccountNumber = json['user_account_number'];
    ifscCode = json['ifsc_code'];
    bank = json['bank'];
    branchName = json['branch_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['user_account_number'] = userAccountNumber;
    data['ifsc_code'] = ifscCode;
    data['bank'] = bank;
    data['branch_name'] = branchName;
    return data;
  }
}

class Aadhaar {
  String? userAadhaarNumber;
  String? userAadhaarName;

  Aadhaar({this.userAadhaarNumber, this.userAadhaarName});

  Aadhaar.fromJson(Map<String, dynamic> json) {
    userAadhaarNumber = json['user_aadhaar_number'];
    userAadhaarName = json['user_aadhaar_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['user_aadhaar_number'] = userAadhaarNumber;
    data['user_aadhaar_name'] = userAadhaarName;
    return data;
  }
}
