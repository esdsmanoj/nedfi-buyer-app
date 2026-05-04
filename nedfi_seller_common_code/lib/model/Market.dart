class Market {
  Market({
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

  Market.fromJson(Map<String, dynamic> json){
    success = json['success']??0;
    error = json['error']??0;
    status = json['status']??0;
    data = List.from(json['data']).map((e)=>MarketData.fromJson(e)).toList();
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

class MarketData {
  MarketData({
     this.marketId,
     this.name,
     this.nameMr,
     this.createdOn,
     this.updatedOn,
     this.deletedOn,
     this.isDeleted,
    this.deletedById,
     this.isActive,
     this.createdById,
    this.updatedById,
     this.address, this.id,this.apmc_market,this.state_name,this.market,this.apmc_address,this.latitude,this.longitude
  });
  late final String? marketId;
  late final String? name;
  late final String? nameMr;
  late final String? createdOn;
  late final String? updatedOn;
  late final String? deletedOn;
  late final String? isDeleted;
  late final String? deletedById;
  late final String? isActive;
  late final String? createdById;
  late final String? updatedById;
  late final String? address;
  late final String? id;
  late final String? apmc_market;
  late final String? state_name;
  late final String? market;
  late final String? apmc_address;
  late final String? latitude;
  late final String? longitude;

  MarketData.fromJson(Map<String, dynamic> json){
    marketId = json['market_id']??"";
    name = json['name']??"";
    nameMr = json['name_mr']??"";
    createdOn = json['created_on']??"";
    updatedOn = json['updated_on']??"";
    deletedOn = json['deleted_on']??"";
    isDeleted = json['is_deleted']??"";
    deletedById = json['deletedById']??"";
    isActive = json['is_active']??"";
    createdById = json['created_by_id']??"";
    updatedById = json['updatedById']??"";
    address = json['address']??"";

    id= json['id']??"";
   apmc_market= json['apmc_market']??"";
     state_name= json['state_name']??"";
    market= json['market']??"";
     apmc_address= json['apmc_address']??"";
   latitude= json['latitude']??"";
   longitude= json['longitude']??"";
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['market_id'] = marketId;
    _data['name'] = name;
    _data['name_mr'] = nameMr;
    _data['created_on'] = createdOn;
    _data['updated_on'] = updatedOn;
    _data['deleted_on'] = deletedOn;
    _data['is_deleted'] = isDeleted;
    _data['deleted_by_id'] = deletedById;
    _data['is_active'] = isActive;
    _data['created_by_id'] = createdById;
    _data['updated_by_id'] = updatedById;
    _data['address'] = address;

    _data['id'] = id;
    _data['apmc_market'] = apmc_market;
    _data['state_name'] = state_name;
    _data['market'] = market;
    _data['apmc_address'] = apmc_address;
    _data['latitude'] = latitude;
    _data['longitude'] = longitude;
    return _data;
  }
}