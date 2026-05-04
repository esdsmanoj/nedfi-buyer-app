class NedfiProduct {
  int? success;
  List<NedfiProductData>? data;
  String? message;

  NedfiProduct({this.success, this.data, this.message});

  NedfiProduct.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    if (json['data'] != null) {
      data = <NedfiProductData>[];
      json['data'].forEach((v) {
        data!.add(new NedfiProductData.fromJson(v));
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

class NedfiProductData {
  String? id;
  String? title;
  String? commodityTitle;
  String? titleEn;
  String? langJson;
  String? prodCat;
  String? prodTypeId;

  NedfiProductData(
      {this.id,
        this.title,
        this.commodityTitle,
        this.titleEn,
        this.langJson,
        this.prodCat,
        this.prodTypeId});

  NedfiProductData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    commodityTitle = json['commodity_title'];
    titleEn = json['title_en'];
    langJson = json['lang_json'];
    prodCat = json['prod_cat'];
    prodTypeId = json['prod_type_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['commodity_title'] = this.commodityTitle;
    data['title_en'] = this.titleEn;
    data['lang_json'] = this.langJson;
    data['prod_cat'] = this.prodCat;
    data['prod_type_id'] = this.prodTypeId;
    return data;
  }
}