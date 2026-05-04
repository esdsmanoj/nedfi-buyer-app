class CountryResponse {
  CountryResponse({
    required this.success,
    required this.error,
    required this.status,
    required this.data,
    required this.message,
  });
  late final int success;
  late final int error;
  late final int status;
  late final List<CountryData> data;
  late final String message;

  CountryResponse.fromJson(Map<String, dynamic> json){
    success = json['success'];
    error = json['error'];
    status = json['status'];
    data = List.from(json['data']).map((e)=>CountryData.fromJson(e)).toList();
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['success'] = success;
    _data['error'] = error;
    _data['status'] = status;
    _data['data'] = data.map((e)=>e.toJson()).toList();
    _data['message'] = message;
    return _data;
  }
}

class CountryData {
  CountryData({
    required this.id,
    required this.code,
    required this.name,
    required this.phonecode,
  });
  late final String id;
  late final String code;
  late final String name;
  late final String phonecode;

  CountryData.fromJson(Map<String, dynamic> json){
    id = json['id']??"";
    code = json['code']??"";
    name = json['name']??"";
    phonecode = json['phonecode']??"";
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['code'] = code;
    _data['name'] = name;
    _data['phonecode'] = phonecode;
    return _data;
  }
}