class CropDetails {
  int? success;
  CropData? data;
  int? error;
  int? status;
  String? sqlChk;

  CropDetails({this.success, this.data, this.error, this.status, this.sqlChk});

  CropDetails.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    data = json['data'] != null ? CropData.fromJson(json['data']) : null;
    error = json['error'];
    status = json['status'];
    sqlChk = json['sql_chk'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['success'] = success;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    data['error'] = error;
    data['status'] = status;
    data['sql_chk'] = sqlChk;
    return data;
  }
}

class CropData {
  List<AllCrops>? allCrops;
  List<MyCrops>? myCrops;

  CropData({this.allCrops, this.myCrops});

  CropData.fromJson(Map<String, dynamic> json) {
    if (json['all_crops'] != null) {
      allCrops = <AllCrops>[];
      json['all_crops'].forEach((v) {
        allCrops!.add(AllCrops.fromJson(v));
      });
    }
    if (json['my_crops'] != null) {
      myCrops = <MyCrops>[];
      json['my_crops'].forEach((v) {
        myCrops!.add(MyCrops.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (allCrops != null) {
      data['all_crops'] = allCrops!.map((v) => v.toJson()).toList();
    }
    if (myCrops != null) {
      data['my_crops'] = myCrops!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class AllCrops {
  String? cropId;
  String? name;
  String? mobIcon;
  String? n;
  String? p;
  String? k;
  String? s;

  AllCrops({this.cropId, this.name, this.mobIcon, this.n, this.p, this.k,this.s});

  AllCrops.fromJson(Map<String, dynamic> json) {
    cropId = json['crop_id'];
    name = json['name'];
    mobIcon = json['mob_icon'];
    n = json['n'];
    p = json['p'];
    k = json['k'];
    s = json['s'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['crop_id'] = cropId;
    data['name'] = name;
    data['mob_icon'] = mobIcon;
    data['n'] = n;
    data['p'] = p;
    data['k'] = k;
    data['s'] = s;
    return data;
  }
}

class MyCrops {
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
  String? updatedOn;
  String? updatedById;
  String? isDeleted;
  String? deletedById;
  String? deletedOn;
  String? durationFrom;
  String? durationTo;
  dynamic cropName;
  dynamic name;
  dynamic cropNameMr;
  String? cropImage;
  String? logo;
  String? cropId;
  String? n;
  String? p;
  String? k;
  String? s;

  MyCrops(
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
      this.name,
      this.cropId,
      this.n,
      this.p,
      this.k,
        this.s,
      this.logo});

  MyCrops.fromJson(Map<String, dynamic> json) {
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
    n = json['n'];
    p = json['p'];
    k = json['k'];
    s = json['s'].toString();
    cropId = json['crop_id'];
    name = json['name'];
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
    data['logo'] = logo;
    data['name'] = name;
    data['crop_id'] = cropId;
    data['n'] = n;
    data['p'] = p;
    data['k'] = k;
    data['s'] = s;
    return data;
  }
}
