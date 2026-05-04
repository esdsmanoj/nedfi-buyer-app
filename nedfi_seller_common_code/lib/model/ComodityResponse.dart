class ComodityResponse {
  ComodityResponse({
    required this.success,
    required this.lcoationsData,
    required this.data,
    required this.error,
    required this.status,
    required this.apmcMarket,
  });

  late final int success;
  late final List<LcoationsData> lcoationsData;
  late final List<ComodityData> data;
  late final int error;
  late final int status;
  late final String apmcMarket;

  ComodityResponse.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    lcoationsData = List.from(json['lcoations_data']).map((e) => LcoationsData.fromJson(e)).toList();
    data = List.from(json['data']).map((e) => ComodityData.fromJson(e)).toList();
    error = json['error'];
    status = json['status'];
    apmcMarket = json['apmc_market'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['success'] = success;
    _data['lcoations_data'] = lcoationsData.map((e) => e.toJson()).toList();
    _data['data'] = data.map((e) => e.toJson()).toList();
    _data['error'] = error;
    _data['status'] = status;
    _data['apmc_market'] = apmcMarket;
    return _data;
  }
}

class LcoationsData {
  LcoationsData({
    required this.distance,
    required this.apmcMarket,
    required this.latitude,
    required this.longitude,
  });

  late final String distance;
  late final String apmcMarket;
  late final String latitude;
  late final String longitude;

  LcoationsData.fromJson(Map<String, dynamic> json) {
    distance = json['distance'] ?? "";
    apmcMarket = json['apmc_market'] ?? "";
    latitude = json['latitude'] ?? "";
    longitude = json['longitude'] ?? "";
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['distance'] = distance;
    _data['apmc_market'] = apmcMarket;
    _data['latitude'] = latitude;
    _data['longitude'] = longitude;
    return _data;
  }
}

class ComodityData {
  ComodityData({
    this.market,
    this.commodity,
    this.variety,
    this.minPrice,
    this.maxPrice,
    this.arrivalDate,
    this.arrivals,
    this.unitofarrivals,
  });

  String? market;
  String? commodity;
  String? variety;
  String? minPrice;
  String? maxPrice;
  String? arrivalDate;
  String? arrivals;
  String? unitofarrivals;

  ComodityData.fromJson(Map<String, dynamic> json) {
    market = json['market'] ?? "";
    commodity = json['commodity'] ?? "";
    variety = json['variety'] ?? "";
    minPrice = json['min_price'] ?? "";
    maxPrice = json['max_price'] ?? "";
    arrivalDate = json['arrival_date'] ?? "";
    arrivals = json['arrivals'] ?? "";
    unitofarrivals = json['unitofarrivals'] ?? "";
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['market'] = market;
    _data['commodity'] = commodity;
    _data['variety'] = variety;
    _data['min_price'] = minPrice;
    _data['max_price'] = maxPrice;
    _data['arrival_date'] = arrivalDate;
    _data['arrivals'] = arrivals;
    _data['unitofarrivals'] = unitofarrivals;
    return _data;
  }
}
