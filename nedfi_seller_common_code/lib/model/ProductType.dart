class ProductType {
  int? success;
  List<ProductTypeData>? data;
  String? message;

  ProductType({this.success, this.data, this.message});

  ProductType.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    if (json['data'] != null) {
      data = <ProductTypeData>[];
      json['data'].forEach((v) {
        data!.add(new ProductTypeData.fromJson(v));
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

class ProductTypeData {
  String? id;
  String? title;
  String? titleEn;
  String? langJson;

  ProductTypeData({this.id, this.title, this.titleEn, this.langJson});

  ProductTypeData.fromJson(Map<String, dynamic> json) {
    id = json['id'].toString();
    title = json['title'];
    titleEn = json['title_en'];
    langJson = json['lang_json'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['title_en'] = this.titleEn;
    data['lang_json'] = this.langJson;
    return data;
  }
}