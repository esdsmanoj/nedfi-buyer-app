class Crops {
  Crops({
    required this.success,
    required this.data,
    required this.error,
    required this.status,
  });
  late final int success;
  late final List<CropData> data;
  late final int error;
  late final int status;

  Crops.fromJson(Map<String, dynamic> json){
    success = json['success'];
    data = List.from(json['data']).map((e)=>CropData.fromJson(e)).toList();
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

class CropData {
  CropData({
    required this.cropId,
    required this.name,
    required this.nameMr,
    required this.isActive,
    required this.isDeleted,
    required this.createdOn,
    required this.createdById,
    this.logo,
    this.mobIcon,
    this.updatedOn,
    this.updatedById,
    this.variety ,
    required this.durationDays,
    required this.nitrogen,
    required this.phosphorus,
    required this.potassium,
    this.deletedOn,
    this.deletedById,
    this.cropTypeId,
    this.nameHindi,
  });
  late final String? cropId;
  late final String? name;
  late final String? nameMr;
  late final String? isActive;
  late final String? isDeleted;
  late final String? createdOn;
  late final String? createdById;
  late final String? logo;
  late final String? mobIcon;
  late final String? updatedOn;
  late final String? updatedById;
  late final String? variety ;
  late final String? durationDays;
  late final String? nitrogen;
  late final String? phosphorus;
  late final String? potassium;
  late final String? deletedOn;
  late final String? deletedById;
  late final String? cropTypeId;
  late final String? nameHindi;

  CropData.fromJson(Map<String, dynamic> json){
    cropId = json['crop_id']??"";
    name = json['name']??"";
    nameMr = json['name_mr']??"";
    isActive = json['is_active']??"";
    isDeleted = json['is_deleted']??"";
    createdOn = json['created_on']??"";
    createdById = json['created_by_id']??"";
    logo = null;
    mobIcon = null;
    updatedOn = null;
    updatedById = null;
    variety  = null;
    durationDays = json['duration_days']??"";
    nitrogen = json['nitrogen']??"";
    phosphorus = json['phosphorus']??"";
    potassium = json['potassium']??"";
    deletedOn = null;
    deletedById = null;
    cropTypeId = null;
    nameHindi = null;
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['crop_id'] = cropId;
    _data['name'] = name;
    _data['name_mr'] = nameMr;
    _data['is_active'] = isActive;
    _data['is_deleted'] = isDeleted;
    _data['created_on'] = createdOn;
    _data['created_by_id'] = createdById;
    _data['logo'] = logo;
    _data['mob_icon'] = mobIcon;
    _data['updated_on'] = updatedOn;
    _data['updated_by_id'] = updatedById;
    _data['variety '] = variety ;
    _data['duration_days'] = durationDays;
    _data['nitrogen'] = nitrogen;
    _data['phosphorus'] = phosphorus;
    _data['potassium'] = potassium;
    _data['deleted_on'] = deletedOn;
    _data['deleted_by_id'] = deletedById;
    _data['crop_type_id'] = cropTypeId;
    _data['name_hindi'] = nameHindi;
    return _data;
  }
}