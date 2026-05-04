class Chat {
  Chat({required this.success, required this.error, required this.status, required this.data, required this.msg});

  late final int success;
  late final int error;
  late final int status;
  late final List<ChatData> data;
  late final String msg;

  Chat.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    error = json['error'];
    status = json['status'];
    data = List.from(json['data']).map((e) => ChatData.fromJson(e)).toList();
    msg = json['msg'] ?? "";
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['success'] = success;
    _data['error'] = error;
    _data['status'] = status;
    _data['data'] = data.map((e) => e.toJson()).toList();
    _data['msg'] = msg;
    return _data;
  }
}

class ChatData {
  ChatData({
    required this.msgId,
    required this.incomingMsgId,
    required this.outgoingMsgId,
    required this.msg,
    required this.isActive,
    required this.isDeleted,
    this.createdById,
    required this.createdOn,
    this.updatedById,
    this.updatedOn,
    this.deletedById,
    this.deletedOn,
    this.uniqueId,
    required this.userType,
  });

  late final String msgId;
  late final String incomingMsgId;
  late final String outgoingMsgId;
  late final String msg;
  late final String isActive;
  late final String isDeleted;
  late final String? createdById;
  late final String createdOn;
  late final String? updatedById;
  late final String? updatedOn;
  late final String? deletedById;
  late final String? deletedOn;
  late final String? uniqueId;
  late final String userType;

  ChatData.fromJson(Map<String, dynamic> json) {
    msgId = json['msg_id'] ?? "";
    incomingMsgId = json['incoming_msg_id'] ?? "";
    outgoingMsgId = json['outgoing_msg_id'] ?? "";
    msg = json['msg'] ?? "";
    isActive = json['is_active'] ?? "";
    isDeleted = json['is_deleted'] ?? "";
    createdById = json['createdById'] ?? "";
    createdOn = json['created_on'] ?? "";
    updatedById = json['updatedById'] ?? "";
    updatedOn = json['updatedOn'] ?? "";
    deletedById = json['deletedById'] ?? "";
    deletedOn = json['deletedOn'] ?? "";
    uniqueId = json['uniqueId'] ?? "";
    userType = json['user_type'] ?? "";
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['msg_id'] = msgId;
    _data['incoming_msg_id'] = incomingMsgId;
    _data['outgoing_msg_id'] = outgoingMsgId;
    _data['msg'] = msg;
    _data['is_active'] = isActive;
    _data['is_deleted'] = isDeleted;
    _data['created_by_id'] = createdById;
    _data['created_on'] = createdOn;
    _data['updated_by_id'] = updatedById;
    _data['updated_on'] = updatedOn;
    _data['deleted_by_id'] = deletedById;
    _data['deleted_on'] = deletedOn;
    _data['unique_id'] = uniqueId;
    _data['user_type'] = userType;
    return _data;
  }
}
