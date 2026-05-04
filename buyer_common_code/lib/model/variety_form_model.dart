class VarietyFormDetails {
  int? status;
  int? error;
  int? success;
  List<DynamicFormDetails>? data;
  String? message;

  VarietyFormDetails({this.status, this.error, this.success, this.data, this.message});

  VarietyFormDetails.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    error = json['error'];
    success = json['success'];
    if (json['data'] != null) {
      data = <DynamicFormDetails>[];
      json['data'].forEach((v) {
        data!.add(DynamicFormDetails.fromJson(v));
      });
    }
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['error'] = error;
    data['success'] = success;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['message'] = message;
    return data;
  }
}

class DynamicFormDetails {
  String? name;
  String? id;
  String? title;
  String? type;
  String? dataType;
  List<dynamic>? value;

  DynamicFormDetails({this.name, this.id, this.title, this.type, this.dataType, this.value});

  DynamicFormDetails.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    id = json['id'];
    title = json['title'];
    type = json['type'];
    dataType = json['data_type'];
    value = json['value'].toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['id'] = id;
    data['title'] = title;
    data['type'] = type;
    data['data_type'] = dataType;
    data['value'] = value;
    return data;
  }
}
