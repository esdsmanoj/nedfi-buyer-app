class VarietyState{
  VarietyState({
     this.status,
     this.error,
     this.success,
     required this.data,
     required this.irrigationSrc,
     required this.irrigationType,
     required this.soilType,
     required this.cropSeasons,
     this.message,
  });
  late final String? status;
  late final String? error;
  late final String? success;
  late final List<VarietyStateData> data;
  late final List<IrrigationSrc> irrigationSrc;
  late final List<IrrigationType> irrigationType;
  late final List<SoilType> soilType;
  late final List<CropSeasons> cropSeasons;
  late final String? message;

  VarietyState.fromJson(Map<String, dynamic> json){
    status = json['status'].toString();
    error = json['error'].toString();
    success = json['success'].toString();
    data = List.from(json['data']).map((e)=>VarietyStateData.fromJson(e)).toList();
    irrigationSrc = List.from(json['irrigation_src']).map((e)=>IrrigationSrc.fromJson(e)).toList();
    irrigationType = List.from(json['irrigation_type']).map((e)=>IrrigationType.fromJson(e)).toList();
    soilType = List.from(json['soil_type']).map((e)=>SoilType.fromJson(e)).toList();
    cropSeasons = List.from(json['crop_seasons']).map((e)=>CropSeasons.fromJson(e)).toList();
    message = json['message'].toString();
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['status'] = status;
    _data['error'] = error;
    _data['success'] = success;
    _data['data'] = data.map((e)=>e.toJson()).toList();
    _data['irrigation_src'] = irrigationSrc.map((e)=>e.toJson()).toList();
    _data['irrigation_type'] = irrigationType.map((e)=>e.toJson()).toList();
    _data['soil_type'] = soilType.map((e)=>e.toJson()).toList();
    _data['crop_seasons'] = cropSeasons.map((e)=>e.toJson()).toList();
    _data['message'] = message;
    return _data;
  }
}

class VarietyStateData {
  VarietyStateData({
    required this.id,
    required this.name,
  });
  late final String id;
  late final String name;

  VarietyStateData.fromJson(Map<String, dynamic> json){
    id = json['id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['name'] = name;
    return _data;
  }
}

class IrrigationSrc {
  IrrigationSrc({
    required this.id,
    required this.value,
    required this.nameMr,
  });
  late final String id;
  late final String value;
  late final String nameMr;

  IrrigationSrc.fromJson(Map<String, dynamic> json){
    id = json['id'];
    value = json['value'];
    nameMr = json['name_mr'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['value'] = value;
    _data['name_mr'] = nameMr;
    return _data;
  }
}

class IrrigationType {
  IrrigationType({
    required this.id,
    required this.value,
    required this.nameMr,
  });
  late final String id;
  late final String value;
  late final String nameMr;

  IrrigationType.fromJson(Map<String, dynamic> json){
    id = json['id'];
    value = json['value'];
    nameMr = json['name_mr'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['value'] = value;
    _data['name_mr'] = nameMr;
    return _data;
  }
}

class SoilType {
  SoilType({
    required this.id,
    required this.value,
    required this.nameMr,
  });
  late final String id;
  late final String value;
  late final String nameMr;

  SoilType.fromJson(Map<String, dynamic> json){
    id = json['id'];
    value = json['value'];
    nameMr = json['name_mr'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['value'] = value;
    _data['name_mr'] = nameMr;
    return _data;
  }
}

class CropSeasons {
  CropSeasons({
    required this.id,
    required this.name,
    required this.nameMr,
  });
  late final String id;
  late final String name;
  late final String nameMr;

  CropSeasons.fromJson(Map<String, dynamic> json){
    id = json['id'];
    name = json['name'];
    nameMr = json['name_mr'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['name'] = name;
    _data['name_mr'] = nameMr;
    return _data;
  }
}