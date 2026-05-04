class StateResponse {
  StateResponse({
    required this.status,
    required this.error,
    required this.success,
    required this.data,
    required this.message,
  });
  late final int status;
  late final int error;
  late final int success;
  late final List<StateData> data;
  late final String message;

  StateResponse.fromJson(Map<String, dynamic> json){
    status = json['status'];
    error = json['error']??0;
    success = json['success'];
    data = List.from(json['data']).map((e)=>StateData.fromJson(e)).toList();
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['status'] = status;
    _data['error'] = error;
    _data['success'] = success;
    _data['data'] = data.map((e)=>e.toJson()).toList();
    _data['message'] = message;
    return _data;
  }
}

class StateData {
  StateData({
    required this.id,
    required this.name,
    required this.countryId,
  });
  late final String id;
  late final String name;
  late final String countryId;

  StateData.fromJson(Map<String, dynamic> json){
    id = json['id']??"";
    name = json['name']??"";
    countryId = json['country_id']??"";
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['name'] = name;
    _data['country_id'] = countryId;
    return _data;
  }
}