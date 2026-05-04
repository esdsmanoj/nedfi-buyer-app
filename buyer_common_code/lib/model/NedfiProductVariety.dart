class NedfiProductVariety {
  int? success;
  List<NedfiProductVarietyData>? data;
  String? message;

  NedfiProductVariety({this.success, this.data, this.message});

  NedfiProductVariety.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    if (json['data'] != null) {
      data = <NedfiProductVarietyData>[];
      json['data'].forEach((v) {
        data!.add(new NedfiProductVarietyData.fromJson(v));
      });
    }
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['message'] = this.message;
    return data;
  }
}

class NedfiProductVarietyData {
  String? id;
  String? title;
  String? titleEn;
  String? langJson;
  String? prodMasterId;

  NedfiProductVarietyData({this.id, this.title, this.titleEn, this.langJson, this.prodMasterId});

  NedfiProductVarietyData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    titleEn = json['title_en'];
    langJson = json['lang_json'];
    prodMasterId = json['prod_master_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['title_en'] = this.titleEn;
    data['lang_json'] = this.langJson;
    data['prod_master_id'] = this.prodMasterId;
    return data;
  }
}