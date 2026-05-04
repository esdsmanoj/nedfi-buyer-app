import 'package:buyer_common_code/model/product_info.dart';

class MarketProductDetails {
  MarketProductDetails({
    required this.status,
    required this.data,
    required this.message,
  });

  late final int status;

  //late final List<MarketProductData> data;
  late final List<ProductsList> data;
  late final String message;

  MarketProductDetails.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['data'] != null) {
      //  data = List.from(json['data']).map((e)=>MarketProductData.fromJson(e)).toList();
      data =
          List.from(json['data']).map((e) => ProductsList.fromJson(e)).toList();
    }
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['status'] = status;
    _data['data'] = data.map((e) => e.toJson()).toList();
    _data['message'] = message;
    return _data;
  }
}

class MarketProductData {
  MarketProductData(
      {required this.id,
      required this.partner_id,
      required this.category_id,
      required this.product_name,
      required this.version,
      required this.logo,
      required this.type,
      required this.product_type,
      required this.price,
      required this.qty,
      required this.cartFlag});

  late final String id;
  late final String partner_id;
  late final String category_id;
  late final String product_name;
  late final String version;
  late final String logo;
  late final String type;
  late final String product_type;
  late final String price;
  String? qty = "1";
  bool cartFlag = true;
  static final columns = [
    "id",
    "partner_id",
    "category_id",
    "version",
    "logo",
    'type',
    'product_type',
    'price',
    'product_name',
    'qty'
  ];

  MarketProductData.fromJson(Map<String, dynamic> json) {
    id = json['id'].toString();
    partner_id = json['partner_id'];
    category_id = json['category_id'];
    version = json['version'] ?? "";
    logo = json['logo'];
    type = json['type'] ?? "";
    product_type = json['product_type'] ?? "";
    price = json['price'];
    product_name = json['product_name'];
    qty = json['qty'] ?? "1";
    cartFlag = json['cartFlag'] ?? false;
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['partner_id'] = partner_id;
    _data['category_id'] = category_id;
    _data['version'] = version;
    _data['logo'] = logo;
    _data['type'] = type;
    _data['product_type'] = product_type;
    _data['price'] = price;
    _data['product_name'] = product_name;
    _data['qty'] = qty;
    _data['cartFlag'] = cartFlag;
    return _data;
  }
}
