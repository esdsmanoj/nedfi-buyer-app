class MediaListType {
  int? success;
  List<MediaTypeData>? data;
  String? msg;
  int? error;
  int? status;

  MediaListType({this.success, this.data, this.msg, this.error, this.status});

  MediaListType.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    if (json['data'] != null) {
      data = <MediaTypeData>[];
      json['data'].forEach((v) {
        data!.add(MediaTypeData.fromJson(v));
      });
    }
    msg = json['msg'];
    error = json['error'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['success'] = success;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['msg'] = msg;
    data['error'] = error;
    data['status'] = status;
    return data;
  }
}

class MediaTypeData {
  String? mediaTypesId;
  String? name;
  String? isActive;
  dynamic logo;
  String? createdById;
  String? createdOn;
  dynamic updatedOn;
  dynamic updatedById;
  String? isDeleted;
  dynamic deletedById;
  dynamic deletedOn;
  dynamic displayOrder;
  dynamic nameEn;
  String? nameMr;
  dynamic mobIcon;
  dynamic isHome;
  String? seq;
  String? nameHi;

  MediaTypeData(
      {this.mediaTypesId,
      this.name,
      this.isActive,
      this.logo,
      this.createdById,
      this.createdOn,
      this.updatedOn,
      this.updatedById,
      this.isDeleted,
      this.deletedById,
      this.deletedOn,
      this.displayOrder,
      this.nameEn,
      this.nameMr,
      this.mobIcon,
      this.isHome,
      this.seq,
      this.nameHi});

  MediaTypeData.fromJson(Map<String, dynamic> json) {
    mediaTypesId = json['media_types_id'];
    name = json['name'];
    isActive = json['is_active'];
    logo = json['logo'];
    createdById = json['created_by_id'];
    createdOn = json['created_on'];
    updatedOn = json['updated_on'];
    updatedById = json['updated_by_id'];
    isDeleted = json['is_deleted'];
    deletedById = json['deleted_by_id'];
    deletedOn = json['deleted_on'];
    displayOrder = json['display_order'];
    nameEn = json['name_en'];
    nameMr = json['name_mr'];
    mobIcon = json['mob_icon'];
    isHome = json['is_home'];
    seq = json['seq'];
    nameHi = json['name_hi'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['media_types_id'] = mediaTypesId;
    data['name'] = name;
    data['is_active'] = isActive;
    data['logo'] = logo;
    data['created_by_id'] = createdById;
    data['created_on'] = createdOn;
    data['updated_on'] = updatedOn;
    data['updated_by_id'] = updatedById;
    data['is_deleted'] = isDeleted;
    data['deleted_by_id'] = deletedById;
    data['deleted_on'] = deletedOn;
    data['display_order'] = displayOrder;
    data['name_en'] = nameEn;
    data['name_mr'] = nameMr;
    data['mob_icon'] = mobIcon;
    data['is_home'] = isHome;
    data['seq'] = seq;
    data['name_hi'] = nameHi;
    return data;
  }
}
