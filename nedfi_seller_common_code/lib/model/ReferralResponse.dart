import 'user_model/check_user.dart';

class ReferralResponse {
  int? success;
  Data? data;
  List<StepList>? stepList;
  String? msg;
  int? error;
  int? status;
  int? validated;

  ReferralResponse(
      {this.success,
        this.data,
        this.stepList,
        this.msg,
        this.error,
        this.status,
        this.validated});

  ReferralResponse.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
    if (json['step_list'] != null) {
      stepList = <StepList>[];
      json['step_list'].forEach((v) {
        stepList!.add(StepList.fromJson(v));
      });
    }
    msg = json['msg'];
    error = json['error'];
    status = json['status'];
    validated = json['validated'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['success'] = success;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    if (stepList != null) {
      data['step_list'] = stepList!.map((v) => v.toJson()).toList();
    }
    data['msg'] = msg;
    data['error'] = error;
    data['status'] = status;
    data['validated'] = validated;
    return data;
  }
}

class Data {
  String? referralCode;

  Data({this.referralCode});

  Data.fromJson(Map<String, dynamic> json) {
    referralCode = json['referral_code'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['referral_code'] = referralCode;
    return data;
  }
}

