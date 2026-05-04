class CropVariety {
  CropVariety({
    required this.success,
    required this.data,
    required this.error,
    required this.status,
  });
  late final int success;
  late final List<CropVarietyData> data;
  late final int error;
  late final int status;

  CropVariety.fromJson(Map<String, dynamic> json){
    success = json['success'];
    data = List.from(json['data']).map((e)=>CropVarietyData.fromJson(e)).toList();
    error = json['error'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['success'] = success;
    _data['data'] = data.map((e)=>e.toJson()).toList();
    _data['error'] = error;
    _data['status'] = status;
    return _data;
  }
}

class CropVarietyData {
  CropVarietyData({
    required this.cropVarietyId,
    required this.name,
    required this.nameMr,
    required this.nameHindi,
    required this.cropId,
  });
  late final String cropVarietyId;
  late final String name;
  late final String nameMr;
  late final String nameHindi;
  late final String cropId;

  CropVarietyData.fromJson(Map<String, dynamic> json){
    cropVarietyId = json['crop_variety_id']??"";
    name = json['name']??"";
    nameMr = json['name_mr']??"";
    nameHindi = json['name_hindi']??"";
    cropId = json['crop_id']??"";
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['crop_variety_id'] = cropVarietyId;
    _data['name'] = name;
    _data['name_mr'] = nameMr;
    _data['name_hindi'] = nameHindi;
    _data['crop_id'] = cropId;
    return _data;
  }
}