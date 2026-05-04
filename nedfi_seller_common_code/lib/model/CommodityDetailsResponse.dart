class CommodityDetailsResponse {
  CommodityDetailsResponse({required this.success, required this.data, required this.costArray, required this.graphArray, required this.error, required this.status, required this.graphImage});

  late final int success;
  late final List<CommodityPrediction> data;
  late final List<CommodityPrediction> costArray;
  late final List<CommodityPrediction> graphArray;
  late final int error;
  late final int status;
  late final String graphImage;

  CommodityDetailsResponse.fromJson(Map<String, dynamic> json) {
    success = json['success'] ?? 0;
    data = List.from(json['data']).map((e) => CommodityPrediction.fromJson(e)).toList();
    costArray = List.from(json['cost_array']).map((e) => CommodityPrediction.fromJson(e)).toList();
    graphArray = List.from(json['graph_array']).map((e) => CommodityPrediction.fromJson(e)).toList();
    error = json['error'] ?? 0;
    status = json['status'] ?? 0;
    graphImage = json['graph_image'] ?? "";
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['success'] = success;
    _data['data'] = data.map((e) => e.toJson()).toList();
    _data['cost_array'] = costArray.map((e) => e.toJson()).toList();
    _data['graph_array'] = graphArray.map((e) => e.toJson()).toList();
    _data['error'] = error;
    _data['status'] = status;
    _data['graph_image'] = graphImage;
    return _data;
  }
}

class CommodityPrediction {
  CommodityPrediction(
      {required this.newdateformat,
      required this.commodityname,
      required this.market,
      required this.minimumprices,
      required this.maximumprices,
      required this.modalprices,
      required this.unitofprice,
      required this.unitofarrivals,
      required this.arrivals,
      required this.varity,
      required this.prediction_flag});

  late final String newdateformat;
  late final String commodityname;
  late final String market;
  late final String minimumprices;
  late final String maximumprices;
  late final String modalprices;
  late final String unitofprice;
  late final String unitofarrivals;
  late final String arrivals;
  late final String varity;
  late final String prediction_flag;

  CommodityPrediction.fromJson(Map<String, dynamic> json) {
    newdateformat = json['newdateformat'] ?? "";
    commodityname = json['commodityname'] ?? "";
    market = json['market'] ?? "";
    minimumprices = json['minimumprices'] ?? "0.00";
    maximumprices = json['maximumprices'] ?? "";
    modalprices = json['modalprices'] ?? "";
    unitofprice = json['unitofprice'] ?? "";
    unitofarrivals = json['unitofarrivals'] ?? "";
    arrivals = json['arrivals'] ?? "";
    varity = json['varity'] ?? "";
    prediction_flag = json['prediction_flag'] ?? "";
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['newdateformat'] = newdateformat;
    _data['commodityname'] = commodityname;
    _data['market'] = market;
    _data['minimumprices'] = minimumprices;
    _data['maximumprices'] = maximumprices;
    _data['modalprices'] = modalprices;
    _data['unitofprice'] = unitofprice;
    _data['unitofarrivals'] = unitofarrivals;
    _data['arrivals'] = arrivals;
    _data['varity'] = varity;
    _data['prediction_flag'] = prediction_flag;
    return _data;
  }
}
