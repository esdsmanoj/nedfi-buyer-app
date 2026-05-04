import 'package:buyer_common_code/model/HomeCatagoryResponse.dart';

class AdsResponse {
  AdsResponse({
    required this.success,
    required this.data,
    required this.error,
    required this.status,
    required this.configUrl,
  });

  late final int success;
  late final List<AdsData> data;
  late final int error;
  late final int status;
  ConfigUrl? configUrl;

  AdsResponse.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    data = List.from(json['data']).map((e) => AdsData.fromJson(e)).toList();
    error = json['error'];
    status = json['status'];
    if (json['config_url'] != null) {
      configUrl = ConfigUrl.fromJson(json['config_url']);
    }
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['success'] = success;
    _data['data'] = data.map((e) => e.toJson()).toList();
    _data['error'] = error;
    _data['status'] = status;
    if (configUrl != null) {
      _data['config_url'] = configUrl!.toJson();
    }
    return _data;
  }
}

class AdsData {
  AdsData({
    required this.id,
    this.userId,
    required this.name,
    this.nameMr,
    required this.status,
    required this.linkUrl,
    required this.seq,
    required this.logo,
    required this.mobIcon,
    required this.createdOn,
    required this.updatedOn,
    required this.deletedOn,
    required this.isDeleted,
    this.deletedById,
    required this.isActive,
    required this.isVerify,
    required this.createdById,
    this.updatedById,
    this.addedByUser,
    this.isExternal,
    this.bankId,
  });

  late final String id;
  late final Null userId;
  late final String name;
  late final Null nameMr;
  late final String status;
  late final String linkUrl;
  late final String seq;
  late final String logo;
  late final String mobIcon;
  late final String createdOn;
  late final String updatedOn;
  late final String deletedOn;
  late final String isDeleted;
  late final String? deletedById;
  late final String isActive;
  late final String isVerify;
  late final String createdById;
  late final String? updatedById;
  late final String? addedByUser;
  late final Null isExternal;
  late final String? bankId;

  AdsData.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? "";
    userId = null;
    name = json['name'] ?? "";
    nameMr = null;
    status = json['status'] ?? "";
    linkUrl = json['link_url'] ?? "";
    seq = json['seq'] ?? "";
    logo = json['logo'] ?? "";
    mobIcon = json['mob_icon'] ?? "";
    createdOn = json['created_on'] ?? "";
    updatedOn = json['updated_on'] ?? "";
    deletedOn = json['deleted_on'] ?? "";
    isDeleted = json['is_deleted'] ?? "";
    deletedById = null;
    isActive = json['is_active'] ?? "";
    isVerify = json['is_verify'] ?? "";
    createdById = json['created_by_id'] ?? "";
    updatedById = null;
    addedByUser = null;
    isExternal = null;
    bankId = null;
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['user_id'] = userId;
    _data['name'] = name;
    _data['name_mr'] = nameMr;
    _data['status'] = status;
    _data['link_url'] = linkUrl;
    _data['seq'] = seq;
    _data['logo'] = logo;
    _data['mob_icon'] = mobIcon;
    _data['created_on'] = createdOn;
    _data['updated_on'] = updatedOn;
    _data['deleted_on'] = deletedOn;
    _data['is_deleted'] = isDeleted;
    _data['deleted_by_id'] = deletedById;
    _data['is_active'] = isActive;
    _data['is_verify'] = isVerify;
    _data['created_by_id'] = createdById;
    _data['updated_by_id'] = updatedById;
    _data['added_by_user'] = addedByUser;
    _data['is_external'] = isExternal;
    _data['bank_id'] = bankId;
    return _data;
  }
}
