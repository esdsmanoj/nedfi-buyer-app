class OrderBeforeTime {
  OrderBeforeTime({
    required this.success,
    required this.error,
    required this.status,
    required this.data,
    required this.message,
  });

  late final int success;
  late final int error;
  late final int status;
  late final OrderBeforeTimeData data;
  late final String message;

  OrderBeforeTime.fromJson(Map<String, dynamic> json) {
    success = json['success'] ?? 0;
    error = json['error'] ?? 0;
    status = json['status'] ?? 0;
    data = OrderBeforeTimeData.fromJson(json['data']);
    message = json['message'] ?? "";
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['success'] = success;
    _data['error'] = error;
    _data['status'] = status;
    _data['data'] = data.toJson();
    _data['message'] = message;
    return _data;
  }
}

class OrderBeforeTimeData {
  OrderBeforeTimeData({
    required this.name,
    required this.keyFields,
    this.logo,
    this.mobIcon,
    required this.createdOn,
    required this.isActive,
    required this.createdById,
    required this.description,
    this.isWhitelablel,
  });

  late final String name;
  late final String keyFields;
  late final String? logo;
  late final String? mobIcon;
  late final String createdOn;
  late final String isActive;
  late final String createdById;
  late final String description;
  late final String? isWhitelablel;

  OrderBeforeTimeData.fromJson(Map<String, dynamic> json) {
    name = json['name'] ?? "";
    keyFields = json['key_fields'] ?? "";
    logo = json['logo'].toString() ?? "";
    mobIcon = json['mobIcon'].toString() ?? "";
    createdOn = json['created_on'] ?? "";
    isActive = json['is_active'] ?? "";
    createdById = json['created_by_id'] ?? "";
    description = json['description'] ?? "";
    isWhitelablel = json['isWhitelablel'].toString() ?? "";
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['name'] = name;
    _data['key_fields'] = keyFields;
    _data['logo'] = logo;
    _data['mob_icon'] = mobIcon;
    _data['created_on'] = createdOn;
    _data['is_active'] = isActive;
    _data['created_by_id'] = createdById;
    _data['description'] = description;
    _data['is_whitelablel'] = isWhitelablel;
    return _data;
  }
}
