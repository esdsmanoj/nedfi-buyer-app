class MarketResponse {
  MarketResponse({
    required this.success,
    required this.error,
    required this.status,
    required this.data,
    required this.message,
  });

  late final int success;
  late final int error;
  late final int status;
  late final List<MarketData> data;
  late final String message;

  MarketResponse.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    error = json['error'];
    status = json['status'];
    data = List.from(json['data']).map((e) => MarketData.fromJson(e)).toList();
    message = json['message'] ?? "";
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['success'] = success;
    _data['error'] = error;
    _data['status'] = status;
    _data['data'] = data.map((e) => e.toJson()).toList();
    _data['message'] = message;
    return _data;
  }
}

class MarketData {
  String? id;
  String? distance;
  String? apmcMarket;
  String? latitude;
  String? longitude;

  MarketData({this.id, this.distance, this.apmcMarket, this.latitude, this.longitude});

  MarketData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    distance = json['distance'];
    apmcMarket = json['apmc_market'];
    latitude = json['latitude'];
    longitude = json['longitude'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['distance'] = this.distance;
    data['apmc_market'] = this.apmcMarket;
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    return data;
  }
}
