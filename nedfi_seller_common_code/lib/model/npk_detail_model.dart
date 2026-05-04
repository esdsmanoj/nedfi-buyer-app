class NPKSDetailsModel {
  int? success;
  Data? data;
  Details? details;
  int? error;
  int? status;

  NPKSDetailsModel({this.success, this.data, this.details, this.error, this.status});

  NPKSDetailsModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
    details = json['details'] != null ? Details.fromJson(json['details']) : null;
    error = json['error'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['success'] = success;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    if (details != null) {
      data['details'] = details!.toJson();
    }
    data['error'] = error;
    data['status'] = status;
    return data;
  }
}

class Data {
  String? name;
  String? nameMr;
  String? nitrogen;
  String? phosphorus;
  String? potassium;

  Data({this.name, this.nameMr, this.nitrogen, this.phosphorus, this.potassium});

  Data.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    nameMr = json['name_mr'];
    nitrogen = json['nitrogen'];
    phosphorus = json['phosphorus'];
    potassium = json['potassium'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['name_mr'] = nameMr;
    data['nitrogen'] = nitrogen;
    data['phosphorus'] = phosphorus;
    data['potassium'] = potassium;
    return data;
  }
}

class Details {
  List<NpkValues>? npkValues;
  String? requiredNpk;
  String? unitSize;

  Details({this.npkValues, this.requiredNpk, this.unitSize});

  Details.fromJson(Map<String, dynamic> json) {
    if (json['npk_values'] != null) {
      npkValues = <NpkValues>[];
      json['npk_values'].forEach((v) {
        npkValues!.add(NpkValues.fromJson(v));
      });
    }
    requiredNpk = json['Required_npk'];
    unitSize = json['unit_size'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (npkValues != null) {
      data['npk_values'] = npkValues!.map((v) => v.toJson()).toList();
    }
    data['Required_npk'] = requiredNpk;
    data['unit_size'] = unitSize;
    return data;
  }
}

class NpkValues {
  String? line1;
  String? line2;
  String? line3;
  String? line4;
  String? total;
  String? url;

  NpkValues({this.line1, this.line2, this.line3, this.line4, this.total, this.url});

  NpkValues.fromJson(Map<String, dynamic> json) {
    line1 = json['line1'];
    line2 = json['line2'];
    line3 = json['line3'];
    line4 = json['line4'];
    total = json['Total'];
    url = json['url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['line1'] = line1;
    data['line2'] = line2;
    data['line3'] = line3;
    data['line4'] = line4;
    data['Total'] = total;
    data['url'] = url;
    return data;
  }
}
