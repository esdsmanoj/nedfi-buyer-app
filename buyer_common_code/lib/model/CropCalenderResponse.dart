class CropCalenderResponse {
  int? success;
  int? error;
  int? status;
  CalendarData? data;
  String? message;
  String? season;
  PostData? postData;
  String? month;
  String? seedingDate;

  CropCalenderResponse({this.success, this.error, this.status, this.data, this.message, this.season, this.postData, this.month, this.seedingDate});

  CropCalenderResponse.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    error = json['error'];
    status = json['status'];
    data = json['data'] != null ? CalendarData.fromJson(json['data']) : null;
    message = json['message'];
    season = json['season'];
    postData = json['post_data'] != null ? PostData.fromJson(json['post_data']) : null;
    month = json['month'];
    seedingDate = json['seeding_date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['success'] = success;
    data['error'] = error;
    data['status'] = status;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    data['message'] = message;
    data['season'] = season;
    if (postData != null) {
      data['post_data'] = postData!.toJson();
    }
    data['month'] = month;
    data['seeding_date'] = seedingDate;
    return data;
  }
}

class CropCal {
  String? id;
  String? cropId;
  String? daysCount;
  String? activities;
  String? details;
  String? chemicalConsertation;
  String? expectedHeight;
  String? isActive;
  String? createdOn;
  String? duration;
  String? activitiesMr;
  String? detailsMr;
  String? season;
  String? extraText;
  String? cropStep;

  CropCal(
      {this.id,
      this.cropId,
      this.daysCount,
      this.activities,
      this.details,
      this.chemicalConsertation,
      this.expectedHeight,
      this.isActive,
      this.createdOn,
      this.duration,
      this.activitiesMr,
      this.detailsMr,
      this.season,
      this.extraText,
      this.cropStep});

  CropCal.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    cropId = json['crop_id'];
    daysCount = json['days_count'];
    activities = json['activities'];
    details = json['details'];
    chemicalConsertation = json['chemical_consertation'];
    expectedHeight = json['expected_height'];
    isActive = json['is_active'];
    createdOn = json['created_on'];
    duration = json['duration'];
    activitiesMr = json['activities_mr'];
    detailsMr = json['details_mr'];
    season = json['season'];
    extraText = json['extra_text'];
    cropStep = json['crop_step'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['crop_id'] = cropId;
    data['days_count'] = daysCount;
    data['activities'] = activities;
    data['details'] = details;
    data['chemical_consertation'] = chemicalConsertation;
    data['expected_height'] = expectedHeight;
    data['is_active'] = isActive;
    data['created_on'] = createdOn;
    data['duration'] = duration;
    data['activities_mr'] = activitiesMr;
    data['details_mr'] = detailsMr;
    data['season'] = season;
    data['extra_text'] = extraText;
    data['crop_step'] = cropStep;
    return data;
  }
}

class CalendarData {
  NewResult? newResult;
  List<CropData>? cropData;
  List<CropCal>? cropCal;

  CalendarData({this.newResult, this.cropData, this.cropCal});

  CalendarData.fromJson(Map<String, dynamic> json) {
    newResult = json['new_result'] != null  ? NewResult.fromJson(json['new_result']) : null;
    if (json['crop_data'] != null) {
      cropData = <CropData>[];
      json['crop_data'].forEach((v) {
        cropData!.add(CropData.fromJson(v));
      });
    }
    if (json['crop_cal'] != null) {
      cropCal = <CropCal>[];
      json['crop_cal'].forEach((v) {
        cropCal!.add(CropCal.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (newResult != null) {
      data['new_result'] = newResult!.toJson();
    }
    if (cropData != null) {
      data['crop_data'] = cropData!.map((v) => v.toJson()).toList();
    }
    if (cropCal != null) {
      data['crop_cal'] = cropCal!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class NewResult {
  List<Nursery>? nursery;
  List<Transplanting>? transplanting;
  List<FieldPreparation>? fieldPreparation;

  NewResult({this.nursery, this.transplanting, this.fieldPreparation});

  NewResult.fromJson(Map<String, dynamic> json) {
    if (json['Nursery'] != null) {
      nursery = <Nursery>[];
      json['Nursery'].forEach((v) {
        nursery!.add(Nursery.fromJson(v));
      });
    }
    if (json['Transplanting'] != null) {
      transplanting = <Transplanting>[];
      json['Transplanting'].forEach((v) {
        transplanting!.add(Transplanting.fromJson(v));
      });
    }
    if (json['Field Preparation'] != null) {
      fieldPreparation = <FieldPreparation>[];
      json['Field Preparation'].forEach((v) {
        fieldPreparation!.add(FieldPreparation.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (nursery != null) {
      data['Nursery'] = nursery!.map((v) => v.toJson()).toList();
    }
    if (transplanting != null) {
      data['Transplanting'] = transplanting!.map((v) => v.toJson()).toList();
    }
    if (fieldPreparation != null) {
      data['Field Preparation'] = fieldPreparation!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Nursery {
  String? id;
  String? cropId;
  String? daysCount;
  String? activities;
  String? details;
  String? chemicalConsertation;
  String? expectedHeight;
  String? isActive;
  String? createdOn;
  String? duration;
  String? activitiesMr;
  String? detailsMr;
  String? season;
  String? extraText;
  String? cropStep;

  Nursery(
      {this.id,
      this.cropId,
      this.daysCount,
      this.activities,
      this.details,
      this.chemicalConsertation,
      this.expectedHeight,
      this.isActive,
      this.createdOn,
      this.duration,
      this.activitiesMr,
      this.detailsMr,
      this.season,
      this.extraText,
      this.cropStep});

  Nursery.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    cropId = json['crop_id'];
    daysCount = json['days_count'];
    activities = json['activities'];
    details = json['details'];
    chemicalConsertation = json['chemical_consertation'];
    expectedHeight = json['expected_height'];
    isActive = json['is_active'];
    createdOn = json['created_on'];
    duration = json['duration'];
    activitiesMr = json['activities_mr'];
    detailsMr = json['details_mr'];
    season = json['season'];
    extraText = json['extra_text'];
    cropStep = json['crop_step'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['crop_id'] = cropId;
    data['days_count'] = daysCount;
    data['activities'] = activities;
    data['details'] = details;
    data['chemical_consertation'] = chemicalConsertation;
    data['expected_height'] = expectedHeight;
    data['is_active'] = isActive;
    data['created_on'] = createdOn;
    data['duration'] = duration;
    data['activities_mr'] = activitiesMr;
    data['details_mr'] = detailsMr;
    data['season'] = season;
    data['extra_text'] = extraText;
    data['crop_step'] = cropStep;
    return data;
  }
}

class Transplanting {
  String? id;
  String? cropId;
  String? daysCount;
  String? activities;
  String? details;
  String? chemicalConsertation;
  String? expectedHeight;
  String? isActive;
  String? createdOn;
  String? duration;
  String? activitiesMr;
  String? detailsMr;
  String? season;
  String? extraText;
  String? cropStep;

  Transplanting(
      {this.id,
      this.cropId,
      this.daysCount,
      this.activities,
      this.details,
      this.chemicalConsertation,
      this.expectedHeight,
      this.isActive,
      this.createdOn,
      this.duration,
      this.activitiesMr,
      this.detailsMr,
      this.season,
      this.extraText,
      this.cropStep});

  Transplanting.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    cropId = json['crop_id'];
    daysCount = json['days_count'];
    activities = json['activities'];
    details = json['details'];
    chemicalConsertation = json['chemical_consertation'];
    expectedHeight = json['expected_height'];
    isActive = json['is_active'];
    createdOn = json['created_on'];
    duration = json['duration'];
    activitiesMr = json['activities_mr'];
    detailsMr = json['details_mr'];
    season = json['season'];
    extraText = json['extra_text'];
    cropStep = json['crop_step'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['crop_id'] = cropId;
    data['days_count'] = daysCount;
    data['activities'] = activities;
    data['details'] = details;
    data['chemical_consertation'] = chemicalConsertation;
    data['expected_height'] = expectedHeight;
    data['is_active'] = isActive;
    data['created_on'] = createdOn;
    data['duration'] = duration;
    data['activities_mr'] = activitiesMr;
    data['details_mr'] = detailsMr;
    data['season'] = season;
    data['extra_text'] = extraText;
    data['crop_step'] = cropStep;
    return data;
  }
}

class FieldPreparation {
  String? id;
  String? cropId;
  String? daysCount;
  String? activities;
  String? details;
  String? chemicalConsertation;
  String? expectedHeight;
  String? isActive;
  String? createdOn;
  String? duration;
  String? activitiesMr;
  String? detailsMr;
  String? season;
  String? extraText;
  String? cropStep;

  FieldPreparation(
      {this.id,
      this.cropId,
      this.daysCount,
      this.activities,
      this.details,
      this.chemicalConsertation,
      this.expectedHeight,
      this.isActive,
      this.createdOn,
      this.duration,
      this.activitiesMr,
      this.detailsMr,
      this.season,
      this.extraText,
      this.cropStep});

  FieldPreparation.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    cropId = json['crop_id'];
    daysCount = json['days_count'];
    activities = json['activities'];
    details = json['details'];
    chemicalConsertation = json['chemical_consertation'];
    expectedHeight = json['expected_height'];
    isActive = json['is_active'];
    createdOn = json['created_on'];
    duration = json['duration'];
    activitiesMr = json['activities_mr'];
    detailsMr = json['details_mr'];
    season = json['season'];
    extraText = json['extra_text'];
    cropStep = json['crop_step'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['crop_id'] = cropId;
    data['days_count'] = daysCount;
    data['activities'] = activities;
    data['details'] = details;
    data['chemical_consertation'] = chemicalConsertation;
    data['expected_height'] = expectedHeight;
    data['is_active'] = isActive;
    data['created_on'] = createdOn;
    data['duration'] = duration;
    data['activities_mr'] = activitiesMr;
    data['details_mr'] = detailsMr;
    data['season'] = season;
    data['extra_text'] = extraText;
    data['crop_step'] = cropStep;
    return data;
  }
}

class CropData {
  String? id;
  String? clientId;
  String? landId;
  String? crop;
  String? cropType;
  String? areaUnderCultivation;
  String? unit;
  dynamic calculatedArea;
  dynamic createdById;
  String? createdOn;
  dynamic updatedOn;
  dynamic updatedById;
  String? isDeleted;
  dynamic deletedById;
  dynamic deletedOn;
  String? durationFrom;
  String? durationTo;
  String? cropName;
  String? cropNameMr;
  String? cropImage;
  String? isActive;
  String? logo;

  CropData(
      {this.id,
      this.clientId,
      this.landId,
      this.crop,
      this.cropType,
      this.areaUnderCultivation,
      this.unit,
      this.calculatedArea,
      this.createdById,
      this.createdOn,
      this.updatedOn,
      this.updatedById,
      this.isDeleted,
      this.deletedById,
      this.deletedOn,
      this.durationFrom,
      this.durationTo,
      this.cropName,
      this.cropNameMr,
      this.cropImage,
      this.isActive,
      this.logo});

  CropData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    clientId = json['client_id'];
    landId = json['land_id'];
    crop = json['crop'];
    cropType = json['crop_type'];
    areaUnderCultivation = json['area_under_cultivation'];
    unit = json['unit'];
    calculatedArea = json['calculated_area'];
    createdById = json['created_by_id'];
    createdOn = json['created_on'];
    updatedOn = json['updated_on'];
    updatedById = json['updated_by_id'];
    isDeleted = json['is_deleted'];
    deletedById = json['deleted_by_id'];
    deletedOn = json['deleted_on'];
    durationFrom = json['duration_from'];
    durationTo = json['duration_to'];
    cropName = json['crop_name'];
    cropNameMr = json['crop_name_mr'];
    cropImage = json['crop_image'];
    isActive = json['is_active'];
    logo = json['logo'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['client_id'] = clientId;
    data['land_id'] = landId;
    data['crop'] = crop;
    data['crop_type'] = cropType;
    data['area_under_cultivation'] = areaUnderCultivation;
    data['unit'] = unit;
    data['calculated_area'] = calculatedArea;
    data['created_by_id'] = createdById;
    data['created_on'] = createdOn;
    data['updated_on'] = updatedOn;
    data['updated_by_id'] = updatedById;
    data['is_deleted'] = isDeleted;
    data['deleted_by_id'] = deletedById;
    data['deleted_on'] = deletedOn;
    data['duration_from'] = durationFrom;
    data['duration_to'] = durationTo;
    data['crop_name'] = cropName;
    data['crop_name_mr'] = cropNameMr;
    data['crop_image'] = cropImage;
    data['is_active'] = isActive;
    data['logo'] = logo;
    return data;
  }
}

class PostData {
  String? cropId;
  String? calenderAction;
  String? seedingDate;
  String? userId;

  PostData({this.cropId, this.calenderAction, this.seedingDate, this.userId});

  PostData.fromJson(Map<String, dynamic> json) {
    cropId = json['crop_id'];
    calenderAction = json['calender_action'];
    seedingDate = json['seeding_date'];
    userId = json['user_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['crop_id'] = cropId;
    data['calender_action'] = calenderAction;
    data['seeding_date'] = seedingDate;
    data['user_id'] = userId;
    return data;
  }
}
