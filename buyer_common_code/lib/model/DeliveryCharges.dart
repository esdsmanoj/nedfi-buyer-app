class DeliveryCharges {
  int? success;
  int? error;
  int? status;
  DeliveryChargesData? data;
  String? message;

  DeliveryCharges(
      {this.success, this.error, this.status, this.data, this.message});

  DeliveryCharges.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    error = json['error'];
    status = json['status'];
    data = json['data'] != null ? new DeliveryChargesData.fromJson(json['data']) : null;
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['error'] = this.error;
    data['status'] = this.status;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    data['message'] = this.message;
    return data;
  }
}

class DeliveryChargesData {
  String? name;
  String? keyFields;
  Null? logo;
  Null? mobIcon;
  String? createdOn;
  String? isActive;
  String? createdById;
  String? description;
  Null? isWhitelablel;

  DeliveryChargesData(
      {this.name,
        this.keyFields,
        this.logo,
        this.mobIcon,
        this.createdOn,
        this.isActive,
        this.createdById,
        this.description,
        this.isWhitelablel});

  DeliveryChargesData.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    keyFields = json['key_fields'];
    logo = json['logo'];
    mobIcon = json['mob_icon'];
    createdOn = json['created_on'];
    isActive = json['is_active'];
    createdById = json['created_by_id'];
    description = json['description'];
    isWhitelablel = json['is_whitelablel'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['key_fields'] = this.keyFields;
    data['logo'] = this.logo;
    data['mob_icon'] = this.mobIcon;
    data['created_on'] = this.createdOn;
    data['is_active'] = this.isActive;
    data['created_by_id'] = this.createdById;
    data['description'] = this.description;
    data['is_whitelablel'] = this.isWhitelablel;
    return data;
  }
}