class SplashModelDetail {
  SplashModelDetail({
    required this.success,
    required this.error,
    required this.status,
    this.logoUrl,
    required this.data,
    required this.message,
    required this.image,
    required this.logo,
  });
  late final int success;
  late final int error;
  late final int status;
  late final Null logoUrl;
  late final List<SplashData> data;
  late final String message;
  late final String image;
  late final String logo;

  SplashModelDetail.fromJson(Map<String, dynamic> json){
    success = json['success']??0;
    error = json['error'];
    status = json['status'];
    logoUrl = null;
    data = List.from(json['data']).map((e)=>SplashData.fromJson(e)).toList();
    message = json['message'];
    image = json['image']??"";
    logo = json['logo']??"";
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['success'] = success;
    _data['error'] = error;
    _data['status'] = status;
    _data['logo_url'] = logoUrl;
    _data['data'] = data.map((e)=>e.toJson()).toList();
    _data['message'] = message;
    _data['image'] = image;
    _data['logo'] = logo;
    return _data;
  }
}

class SplashData {
  SplashData({
    required this.id,
    required this.logo,
    required this.mobIcon,
    required this.keyFields,
  });
  late final String id;
  late final String logo;
  late final String mobIcon;
  late final String keyFields;

  SplashData.fromJson(Map<String, dynamic> json){
    id = json['id']??"";
    logo = json['logo']??"";
    mobIcon = json['mob_icon']??"";
    keyFields = json['key_fields']??"";
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['logo'] = logo;
    _data['mob_icon'] = mobIcon;
    _data['key_fields'] = keyFields;
    return _data;
  }
}