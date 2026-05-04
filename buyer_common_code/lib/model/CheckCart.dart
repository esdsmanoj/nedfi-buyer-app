class CheckCart {
  CheckCart({required this.status, required this.data, required this.message, required this.stockDetails});

  late final String status;
  late final List<CheckCartData> data;
  late final String message;
  late final String stockDetails;

  CheckCart.fromJson(Map<String, dynamic> json) {
    status = json['status'].toString();
    data = List.from(json['data']).map((e) => CheckCartData.fromJson(e)).toList();
    message = json['message'];
    stockDetails = json['stock_details'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['status'] = status;
    _data['data'] = data.map((e) => e.toJson()).toList();
    _data['message'] = message;
    _data['stock_details'] = stockDetails;
    return _data;
  }
}

class CheckCartData {
  CheckCartData({
    required this.productId,
    required this.stock,
  });

  late final String productId;
  late final int stock;

  CheckCartData.fromJson(Map<String, dynamic> json) {
    productId = json['product_id'] ?? "";
    stock = json['stock'] ?? "";
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['product_id'] = productId;
    _data['stock'] = stock;
    return _data;
  }
}
