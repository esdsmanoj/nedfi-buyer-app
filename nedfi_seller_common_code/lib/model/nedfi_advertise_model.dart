class NedfiAdvertiseModel {
  int? success;
  List<NedfiAdvertiseData>? data;
  int? error;
  int? status;

  NedfiAdvertiseModel({this.success, this.data, this.error, this.status});

  NedfiAdvertiseModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    if (json['data'] != null) {
      data = <NedfiAdvertiseData>[];
      json['data'].forEach((v) {
        data!.add(NedfiAdvertiseData.fromJson(v));
      });
    }
    error = json['error'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['success'] = success;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['error'] = error;
    data['status'] = status;
    return data;
  }
}

class NedfiAdvertiseData {
  String? id;
  dynamic userId;
  String? name;
  dynamic nameMr;
  String? status;
  String? linkUrl;
  String? seq;
  String? logo;
  String? mobIcon;
  String? createdOn;
  String? updatedOn;
  String? deletedOn;
  String? isDeleted;
  dynamic deletedById;
  String? isActive;
  String? isVerify;
  String? createdById;
  String? updatedById;
  dynamic addedByUser;
  dynamic isExternal;
  dynamic bankId;

  NedfiAdvertiseData(
      {this.id,
      this.userId,
      this.name,
      this.nameMr,
      this.status,
      this.linkUrl,
      this.seq,
      this.logo,
      this.mobIcon,
      this.createdOn,
      this.updatedOn,
      this.deletedOn,
      this.isDeleted,
      this.deletedById,
      this.isActive,
      this.isVerify,
      this.createdById,
      this.updatedById,
      this.addedByUser,
      this.isExternal,
      this.bankId});

  NedfiAdvertiseData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    name = json['name'];
    nameMr = json['name_mr'];
    status = json['status'];
    linkUrl = json['link_url'];
    seq = json['seq'];
    logo = json['logo'];
    mobIcon = json['mob_icon'];
    createdOn = json['created_on'];
    updatedOn = json['updated_on'];
    deletedOn = json['deleted_on'];
    isDeleted = json['is_deleted'];
    deletedById = json['deleted_by_id'];
    isActive = json['is_active'];
    isVerify = json['is_verify'];
    createdById = json['created_by_id'];
    updatedById = json['updated_by_id'];
    addedByUser = json['added_by_user'];
    isExternal = json['is_external'];
    bankId = json['bank_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['user_id'] = userId;
    data['name'] = name;
    data['name_mr'] = nameMr;
    data['status'] = status;
    data['link_url'] = linkUrl;
    data['seq'] = seq;
    data['logo'] = logo;
    data['mob_icon'] = mobIcon;
    data['created_on'] = createdOn;
    data['updated_on'] = updatedOn;
    data['deleted_on'] = deletedOn;
    data['is_deleted'] = isDeleted;
    data['deleted_by_id'] = deletedById;
    data['is_active'] = isActive;
    data['is_verify'] = isVerify;
    data['created_by_id'] = createdById;
    data['updated_by_id'] = updatedById;
    data['added_by_user'] = addedByUser;
    data['is_external'] = isExternal;
    data['bank_id'] = bankId;
    return data;
  }
}
