class UpcomingProduct {
  int? success;
  List<UpcomingProductData>? data;
  String? message;

  UpcomingProduct({this.success, this.data, this.message});

  UpcomingProduct.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    if (json['data'] != null) {
      data = <UpcomingProductData>[];
      json['data'].forEach((v) {
        data!.add(new UpcomingProductData.fromJson(v));
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

class UpcomingProductData {
  String? id;
  String? productTitle;
  String? productVarietyTitle;

  UpcomingProductData({this.id, this.productTitle, this.productVarietyTitle});

  UpcomingProductData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    productTitle = json['product_title'];
    productVarietyTitle = json['product_variety_title'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['product_title'] = this.productTitle;
    data['product_variety_title'] = this.productVarietyTitle;
    return data;
  }
}