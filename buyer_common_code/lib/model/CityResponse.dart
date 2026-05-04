class CityResponse {
  CityResponse({required this.status, required this.error, required this.success, required this.data, required this.message});

  late final int status;
  late final int error;
  late final int success;
  late final List<CityData> data;
  late final String message;

  CityResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    error = json['error'];
    success = json['success'];
    data = List.from(json['data']).map((e) => CityData.fromJson(e)).toList();
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['status'] = status;
    _data['error'] = error;
    _data['success'] = success;
    _data['data'] = data.map((e) => e.toJson()).toList();
    _data['message'] = message;
    return _data;
  }
}

class CityData {
  CityData({required this.id, required this.name, required this.stateId});

  late final String id;
  late final String name;
  late final String stateId;

  CityData.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? "";
    name = json['name'] ?? "";
    stateId = json['state_id'] ?? "";
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['name'] = name;
    _data['state_id'] = stateId;
    return _data;
  }
}
