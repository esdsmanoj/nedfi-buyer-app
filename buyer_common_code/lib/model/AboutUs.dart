class AboutUs {
  AboutUs({
    required this.success,
    required this.data,
    required this.msg,
    required this.error,
    required this.status,
  });

  late final int success;
  late final AboutUsData data;
  late final String msg;
  late final int error;
  late final int status;

  AboutUs.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    data = AboutUsData.fromJson(json['data']);
    msg = json['msg'];
    error = json['error'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['success'] = success;
    _data['data'] = data.toJson();
    _data['msg'] = msg;
    _data['error'] = error;
    _data['status'] = status;
    return _data;
  }
}

class AboutUsData {
  AboutUsData({
    required this.phone1,
    required this.aboutBgImage,
    required this.phone2,
    required this.email,
    required this.address,
    required this.aboutUs,
    required this.aboutUsMr,
  });

  late final String phone1;
  late final String aboutBgImage;
  late final String phone2;
  late final String email;
  late final String address;
  late final String aboutUs;
  late final String aboutUsMr;
  dynamic latitude;
  dynamic longitude;

  AboutUsData.fromJson(Map<String, dynamic> json) {
    phone1 = json['phone1'] ?? "";
    aboutBgImage = json['about_bg_image'] ?? "";
    phone2 = json['phone2'] ?? "";
    email = json['email'] ?? "";
    address = json['address'] ?? "";
    aboutUs = json['about_us'] ?? "";
    aboutUsMr = json['about_us_mr'] ?? "";
    latitude = json['lat'] ?? "";
    longitude = json['long'] ?? "";
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['phone1'] = phone1;
    _data['about_bg_image'] = aboutBgImage;
    _data['phone2'] = phone2;
    _data['email'] = email;
    _data['address'] = address;
    _data['about_us'] = aboutUs;
    _data['about_us_mr'] = aboutUsMr;
    _data['lat'] = latitude;
    _data['long'] = longitude;
    return _data;
  }
}
