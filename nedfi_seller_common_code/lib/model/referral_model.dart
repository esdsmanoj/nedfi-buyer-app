class ReferralModel {
  ReferralModel({
    required this.success,
    required this.data,
    required this.msg,
    required this.error,
    required this.status,
    required this.validated,
  });

  late final int success;
  late final ReferralData data;
  late final String msg;
  late final int error;
  late final int status;
  late final int validated;

  ReferralModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    data = ReferralData.fromJson(json['data']);
    msg = json['msg'];
    error = json['error'];
    status = json['status'];
    validated = json['validated'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['success'] = success;
    _data['data'] = data.toJson();
    _data['msg'] = msg;
    _data['error'] = error;
    _data['status'] = status;
    _data['validated'] = validated;
    return _data;
  }
}

class ReferralData {
  ReferralData({
    required this.referralCode,
  });

  late final String referralCode;

  ReferralData.fromJson(Map<String, dynamic> json) {
    referralCode = json['referral_code'] ?? "";
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['referral_code'] = referralCode;
    return _data;
  }
}
