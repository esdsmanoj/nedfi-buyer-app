class CropCalenderAction {
  int? success;
  int? status;
  List<CropCalenderActionData>? data;

  CropCalenderAction({this.success, this.status, this.data});

  CropCalenderAction.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    status = json['status'];
    if (json['data'] != null) {
      data = <CropCalenderActionData>[];
      json['data'].forEach((v) {
        data!.add(CropCalenderActionData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['success'] = success;
    data['status'] = status;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class CropCalenderActionData {
  String? title;
  CropCalenderData? data;

  CropCalenderActionData({this.title, this.data});

  CropCalenderActionData.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    data = json['data'] != null ? CropCalenderData.fromJson(json['data']) : null;
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

class CropCalenderData {
  String? id;
  String? value;
  String? mapKey;
  List<CropCalenderOption>? option;

  CropCalenderData({this.id, this.value, this.mapKey, this.option});

  CropCalenderData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    value = json['value'];
    mapKey = json['map_key'];
    if (json['option'] != null) {
      option = <CropCalenderOption>[];
      json['option'].forEach((v) {
        option!.add(CropCalenderOption.fromJson(v));
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

class CropCalenderOption {
  String? id;
  String? value;
  String? mapKey;

  CropCalenderOption({this.id, this.value, this.mapKey});

  CropCalenderOption.fromJson(Map<String, dynamic> json) {
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