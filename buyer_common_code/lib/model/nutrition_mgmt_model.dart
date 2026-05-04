class NutritionManagementModel {
  int? status;
  List<Data>? data;
  String? message;

  NutritionManagementModel({this.status, this.data, this.message});

  NutritionManagementModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(Data.fromJson(v));
      });
    }
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['message'] = message;
    return data;
  }
}

class Data {
  String? title;
  TypeData? data;

  Data({this.title, this.data});

  Data.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    data = json['data'] != null ? TypeData.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['title'] = title;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class TypeData {
  String? id;
  String? value;
  String? mapKey;
  List<Option>? option;

  TypeData({this.id, this.value, this.mapKey, this.option});

  TypeData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    value = json['value'];
    mapKey = json['map_key'];
    if (json['option'] != null) {
      option = <Option>[];
      json['option'].forEach((v) {
        option!.add(Option.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['value'] = value;
    data['map_key'] = mapKey;
    if (option != null) {
      data['option'] = option!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Option {
  String? id;
  String? value;
  String? mapKey;

  Option({this.id, this.value, this.mapKey});

  Option.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    value = json['value'];
    mapKey = json['map_key'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['value'] = value;
    data['map_key'] = mapKey;
    return data;
  }
}
