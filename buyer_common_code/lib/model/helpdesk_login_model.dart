class HelpDeskLoginModel {
  int? success;
  String? url;
  HpUserId? hpUserId;

  HelpDeskLoginModel({this.success, this.url, this.hpUserId});

  HelpDeskLoginModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    url = json['url'];
    hpUserId = json['hp_user_id'] != null ? HpUserId.fromJson(json['hp_user_id' ]) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['success'] = success;
    data['url'] = url;
    if (hpUserId != null) {
      data['hp_user_id'] = hpUserId!.toJson();
    }
    return data;
  }
}

class HpUserId {
  String? id;
  String? fullname;
  String? email;
  String? phNumber;
  String? password;
  String? registration;
  String? lastLogin;
  String? token;
  dynamic timezone;
  dynamic avatar;
  String? status;
  String? usertype;

  HpUserId({this.id, this.fullname, this.email, this.phNumber, this.password, this.registration, this.lastLogin, this.token, this.timezone, this.avatar, this.status, this.usertype});

  HpUserId.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    fullname = json['fullname'];
    email = json['email'];
    phNumber = json['ph_number'];
    password = json['password'];
    registration = json['registration'];
    lastLogin = json['last_login'];
    token = json['token'];
    timezone = json['timezone'];
    avatar = json['avatar'];
    status = json['status'];
    usertype = json['usertype'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['fullname'] = fullname;
    data['email'] = email;
    data['ph_number'] = phNumber;
    data['password'] = password;
    data['registration'] = registration;
    data['last_login'] = lastLogin;
    data['token'] = token;
    data['timezone'] = timezone;
    data['avatar'] = avatar;
    data['status'] = status;
    data['usertype'] = usertype;
    return data;
  }
}
