class MarketPlaceCatagryResponse {
  MarketPlaceCatagryResponse({
    required this.status,
    required this.data,
    required this.message,
  });
  late final int status;
  late final List<MarketPlaceCatagryData> data;
  late final String message;

  MarketPlaceCatagryResponse.fromJson(Map<String, dynamic> json){
    status = json['status'];
    data = List.from(json['data']).map((e)=>MarketPlaceCatagryData.fromJson(e)).toList();
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['status'] = status;
    _data['data'] = data.map((e)=>e.toJson()).toList();
    _data['message'] = message;
    return _data;
  }
}

class MarketPlaceCatagryData {
  MarketPlaceCatagryData({
    required this.pcatId,
    required this.name,
    required this.logo,
    required this.nameMr,
    required this.mobIcon,
  });
  late final String pcatId;
  late final String name;
  late final String logo;
  late final String nameMr;
  late final String mobIcon;

  MarketPlaceCatagryData.fromJson(Map<String, dynamic> json){
    pcatId = json['pcat_id']??"";
    name = json['name']??"";
    logo = json['logo']??"";
    nameMr = json['name_mr']??"";
    mobIcon = json['mob_icon']??"";
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['pcat_id'] = pcatId;
    _data['name'] = name;
    _data['logo'] = logo;
    _data['name_mr'] = nameMr;
    _data['mob_icon'] = mobIcon;
    return _data;
  }
}