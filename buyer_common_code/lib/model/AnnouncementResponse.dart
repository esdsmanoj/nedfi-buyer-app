class AnnouncementResponse {
  AnnouncementResponse({required this.success, required this.error, required this.status, required this.data, required this.message});

  late final int success;
  late final int error;
  late final int status;
  late final List<AnnouncementData> data;
  late final String message;

  AnnouncementResponse.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    error = json['error'];
    status = json['status'];
    data = List.from(json['data']).map((e) => AnnouncementData.fromJson(e)).toList();
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['success'] = success;
    _data['error'] = error;
    _data['status'] = status;
    _data['data'] = data.map((e) => e.toJson()).toList();
    _data['message'] = message;
    return _data;
  }
}

class AnnouncementData {
  AnnouncementData({
    required this.id,
    required this.title,
    required this.description,
    required this.isNotificationSent,
    this.addByUser,
    required this.priorityType,
    required this.createdOn,
    required this.updatedOn,
    required this.deletedOn,
    required this.isDeleted,
    this.deletedById,
    required this.isActive,
    required this.createdById,
    this.updatedById,
    this.bankMasterId,
    this.pacsMasterId,
    this.societyMasterId,
    this.groupIds,
    this.attachedDocument,
    this.isWhitelable,
    this.userType,
    this.group,
    this.refferalCode,
  });

  late final String id;
  late final String title;
  late final String description;
  late final String isNotificationSent;
  late final String? addByUser;
  late final String priorityType;
  late final String createdOn;
  late final String updatedOn;
  late final String deletedOn;
  late final String isDeleted;
  late final Null deletedById;
  late final String isActive;
  late final String createdById;
  late final String? updatedById;
  late final String? bankMasterId;
  late final String? pacsMasterId;
  late final String? societyMasterId;
  late final String? groupIds;
  late final String? attachedDocument;
  late final Null isWhitelable;
  late final String? userType;
  late final String? group;
  late final String? refferalCode;

  AnnouncementData.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? "";
    title = json['title'] ?? "";
    description = json['description'] ?? "";
    isNotificationSent = json['is_notification_sent'] ?? "";
    addByUser = null;
    priorityType = json['priority_type'] ?? "";
    createdOn = json['created_on'] ?? "";
    updatedOn = json['updated_on'] ?? "";
    deletedOn = json['deleted_on'] ?? "";
    isDeleted = json['is_deleted'] ?? "";
    deletedById = null;
    isActive = json['is_active'] ?? "";
    createdById = json['created_by_id'] ?? "";
    updatedById = null;
    bankMasterId = null;
    pacsMasterId = null;
    societyMasterId = null;
    groupIds = null;
    attachedDocument = null;
    isWhitelable = null;
    userType = null;
    group = null;
    refferalCode = null;
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['title'] = title;
    _data['description'] = description;
    _data['is_notification_sent'] = isNotificationSent;
    _data['add_by_user'] = addByUser;
    _data['priority_type'] = priorityType;
    _data['created_on'] = createdOn;
    _data['updated_on'] = updatedOn;
    _data['deleted_on'] = deletedOn;
    _data['is_deleted'] = isDeleted;
    _data['deleted_by_id'] = deletedById;
    _data['is_active'] = isActive;
    _data['created_by_id'] = createdById;
    _data['updated_by_id'] = updatedById;
    _data['bank_master_id'] = bankMasterId;
    _data['pacs_master_id'] = pacsMasterId;
    _data['society_master_id'] = societyMasterId;
    _data['group_ids'] = groupIds;
    _data['attached_document'] = attachedDocument;
    _data['is_whitelable'] = isWhitelable;
    _data['user_type'] = userType;
    _data['group'] = group;
    _data['refferal_code'] = refferalCode;
    return _data;
  }
}
