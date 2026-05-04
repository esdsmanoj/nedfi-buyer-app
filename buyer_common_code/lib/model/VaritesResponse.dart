class VaritesResponse {
  VaritesResponse({
    required this.success,
    required this.error,
    required this.status,
    required this.data,
    required this.message,
  });
  late final int success;
  late final int error;
  late final int status;
  late final List<VaritesData> data;
  late final String message;

  VaritesResponse.fromJson(Map<String, dynamic> json){
    success = json['success'];
    error = json['error'];
    status = json['status'];
    data = List.from(json['data']).map((e)=>VaritesData.fromJson(e)).toList();
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

class VaritesData {
  VaritesData({
    required this.cropVarietyId,
    required this.cropId,
    required this.cropVarietyIcon,
    required this.nameEn,
    required this.nameMr,
    required this.nameHi,
    required this.varietyState,
    required this.varietyDistrict,
    required this.varietyTaluka,
    required this.varietyVillage,
    required this.createdOn,
    required this.updatedOn,
    required this.deletedOn,
    required this.isDeleted,
    this.deletedById,
    required this.isActive,
    this.createdById,
    required this.updatedById,
    this.daysToMaturity,
    this.yieldPotential,
    this.storability,
    required this.season,
    required this.traits,
    required this.otherInformantion,
    required this.characteristics,

  });
  late final String cropVarietyId;
  late final String cropId;
  late final String cropVarietyIcon;
  late final String nameEn;
  late final String nameMr;
  late final String nameHi;
  late final String varietyState;
  late final String varietyDistrict;
  late final String varietyTaluka;
  late final String varietyVillage;
  late final String createdOn;
  late final String updatedOn;
  late final String deletedOn;
  late final String isDeleted;
  late final String? deletedById;
  late final String isActive;
  late final String? createdById;
  late final String updatedById;
  late final String? daysToMaturity;
  late final String? yieldPotential;
  late final String? storability;
  late final String season;
  late final String traits;
  late final String otherInformantion;
  late final String characteristics;


  VaritesData.fromJson(Map<String, dynamic> json){
    cropVarietyId = json['crop_variety_id']??"";
    cropId = json['crop_id']??"";
    cropVarietyIcon = json['crop_variety_icon']??"";
    nameEn = json['name_en']??"";
    nameMr = json['name_mr']??"";
    nameHi = json['name_hi']??"";
    varietyState = json['variety_state']??"";
    varietyDistrict = json['variety_district']??"";
    varietyTaluka = json['variety_taluka']??"";
    varietyVillage = json['variety_village']??"";
    createdOn = json['created_on']??"";
    updatedOn = json['updated_on']??"";
    deletedOn = json['deleted_on']??"";
    isDeleted = json['is_deleted']??"";
    deletedById = json['deleted_by_id']??"";
    isActive = json['is_active']??"";
    createdById = json['created_by_id']??"";
    updatedById = json['updated_by_id']??"";
    daysToMaturity =json['days_to_maturity']??"";
    yieldPotential =json['yield_potential']??"";
    storability = json['storability']??"";
    season = json['season']??"";
    traits = json['traits']??"";
    otherInformantion = json['other_informantion']??"";
    characteristics = json['characteristics']??"";
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['crop_variety_id'] = cropVarietyId;
    _data['crop_id'] = cropId;
    _data['crop_variety_icon'] = cropVarietyIcon;
    _data['name_en'] = nameEn;
    _data['name_mr'] = nameMr;
    _data['name_hi'] = nameHi;
    _data['variety_state'] = varietyState;
    _data['variety_district'] = varietyDistrict;
    _data['variety_taluka'] = varietyTaluka;
    _data['variety_village'] = varietyVillage;
    _data['created_on'] = createdOn;
    _data['updated_on'] = updatedOn;
    _data['deleted_on'] = deletedOn;
    _data['is_deleted'] = isDeleted;
    _data['deleted_by_id'] = deletedById;
    _data['is_active'] = isActive;
    _data['created_by_id'] = createdById;
    _data['updated_by_id'] = updatedById;
    _data['days_to_maturity'] = daysToMaturity;
    _data['yield_potential'] = yieldPotential;
    _data['storability'] = storability;
    _data['season'] = season;
    _data['traits'] = traits;
    _data['other_informantion'] = otherInformantion;
    _data['characteristics'] = characteristics;
    return _data;
  }
}

