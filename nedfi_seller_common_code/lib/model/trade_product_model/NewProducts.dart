class NewProducts {
  int? success;
  List<NewProductsData>? data;
  String? message;

  NewProducts({this.success, this.data, this.message});

  NewProducts.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    if (json['data'] != null) {
      data = <NewProductsData>[];
      json['data'].forEach((v) {
        data!.add( NewProductsData.fromJson(v));
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

class NewProductsData {
  String? id;
  String? prodDetails;
  String? prodId;
  String? productTitle;
  String? productLogo;
  String? sellQty;
  String? sellQtyUnit;
  String? price;
  String? priceUnit;
  String? prodImages;
  String? status;
  String? prodThumbnail;

  NewProductsData(
      {this.id,
        this.prodDetails,
        this.prodId,
        this.productTitle,
        this.productLogo,
        this.sellQty,
        this.sellQtyUnit,
        this.price,
        this.priceUnit,
        this.prodImages,
        this.status,
        this.prodThumbnail});

  NewProductsData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    prodDetails = json['prod_details'];
    prodId = json['prod_id'];
    productTitle = json['product_title'];
    productLogo = json['product_logo'];
    sellQty = json['sell_qty'];
    sellQtyUnit = json['sell_qty_unit'];
    price = json['price'];
    priceUnit = json['price_unit'];
    prodImages = json['prod_images'];
    status = json['status'];
    prodThumbnail = json['prod_thumbnail'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['prod_details'] = this.prodDetails;
    data['prod_id'] = this.prodId;
    data['product_title'] = this.productTitle;
    data['product_logo'] = this.productLogo;
    data['sell_qty'] = this.sellQty;
    data['sell_qty_unit'] = this.sellQtyUnit;
    data['price'] = this.price;
    data['price_unit'] = this.priceUnit;
    data['prod_images'] = this.prodImages;
    data['status'] = this.status;
    data['prod_thumbnail'] = this.prodThumbnail;
    return data;
  }
}