class MarketableSurplus {
  int? success;
  List<MarketableSurplusData>? data;
  String? message;

  MarketableSurplus({this.success, this.data, this.message});

  MarketableSurplus.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    if (json['data'] != null) {
      data = <MarketableSurplusData>[];
      json['data'].forEach((v) {
        data!.add(new MarketableSurplusData.fromJson(v));
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

class MarketableSurplusData {
  String? id;
  String? userId;
  String? prodCatId;
  String? prodTypeId;
  String? productTypeTitle;
  String? prodId;
  String? productTitle;
  String? prodVarietyId;
  String? productVarietyTitle;
  String? surplus;
  String? surplusUnit;
  String? sellQty;
  String? sellQtyUnit;
  String? price;
  String? priceUnit;
  String? status;
  String? productCategoryTitle;
  String? surplusUnitTitle;
  String? sellQtyUnitTitle;
  String? priceUnitTitle;
  String? statusTitle;
  String? statusClass;
  String? surplusTotal;
  String? sellQtySold;
  String? surplusAvailable;

  MarketableSurplusData(
      {this.id,
        this.userId,
        this.prodCatId,
        this.prodTypeId,
        this.productTypeTitle,
        this.prodId,
        this.productTitle,
        this.prodVarietyId,
        this.productVarietyTitle,
        this.surplus,
        this.surplusUnit,
        this.sellQty,
        this.sellQtyUnit,
        this.price,
        this.priceUnit,
        this.status,
        this.productCategoryTitle,
        this.surplusUnitTitle,
        this.sellQtyUnitTitle,
        this.priceUnitTitle,
        this.statusTitle,
        this.statusClass,
        this.surplusTotal,
        this.sellQtySold,
        this.surplusAvailable});

  MarketableSurplusData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    prodCatId = json['prod_cat_id'];
    prodTypeId = json['prod_type_id'];
    productTypeTitle = json['product_type_title'];
    prodId = json['prod_id'];
    productTitle = json['product_title'];
    prodVarietyId = json['prod_variety_id'];
    productVarietyTitle = json['product_variety_title'];
    surplus = json['surplus'];
    surplusUnit = json['surplus_unit'];
    sellQty = json['sell_qty'];
    sellQtyUnit = json['sell_qty_unit'];
    price = json['price'];
    priceUnit = json['price_unit'];
    status = json['status'];
    productCategoryTitle = json['product_category_title'];
    surplusUnitTitle = json['surplus_unit_title'];
    sellQtyUnitTitle = json['sell_qty_unit_title'];
    priceUnitTitle = json['price_unit_title'];
    statusTitle = json['status_title'];
    statusClass = json['status_class'];
    surplusTotal = json['surplus_total'].toString();
    sellQtySold = json['sell_qty_sold'].toString();
    surplusAvailable = json['surplus_available'].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['prod_cat_id'] = this.prodCatId;
    data['prod_type_id'] = this.prodTypeId;
    data['product_type_title'] = this.productTypeTitle;
    data['prod_id'] = this.prodId;
    data['product_title'] = this.productTitle;
    data['prod_variety_id'] = this.prodVarietyId;
    data['product_variety_title'] = this.productVarietyTitle;
    data['surplus'] = this.surplus;
    data['surplus_unit'] = this.surplusUnit;
    data['sell_qty'] = this.sellQty;
    data['sell_qty_unit'] = this.sellQtyUnit;
    data['price'] = this.price;
    data['price_unit'] = this.priceUnit;
    data['status'] = this.status;
    data['product_category_title'] = this.productCategoryTitle;
    data['surplus_unit_title'] = this.surplusUnitTitle;
    data['sell_qty_unit_title'] = this.sellQtyUnitTitle;
    data['price_unit_title'] = this.priceUnitTitle;
    data['status_title'] = this.statusTitle;
    data['status_class'] = this.statusClass;
    data['surplus_total'] = this.surplusTotal;
    data['sell_qty_sold'] = this.sellQtySold;
    data['surplus_available'] = this.surplusAvailable;
    return data;
  }
}