class ManageChatModel {
  int? success;
  int? error;
  int? status;
  List<ManageChatData>? data;
  String? message;

  ManageChatModel({this.success, this.error, this.status, this.data, this.message});

  ManageChatModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    error = json['error'];
    status = json['status'];
    if (json['data'] != null) {
      data = <ManageChatData>[];
      json['data'].forEach((v) {
        data!.add(new ManageChatData.fromJson(v));
      });
    }
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['success'] = success;
    data['error'] = error;
    data['status'] = status;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['message'] = message;
    return data;
  }
}

class ManageChatData {
  String? id;
  String? sendFromId;
  String? sendToId;
  String? tradeProductBiddingId;
  String? msgText;
  String? sendToUsername;
  String? lastMessageTimestamp;
  String? tradeProductId;
  String? prodCatId;
  String? productTypeTitle;
  String? prodId;
  String? productTitle;
  String? productVarietyTitle;
  String? activeTillDate;
  String? surplus;
  String? surplusUnit;
  String? statusTitle;
  String? sellQty;
  String? sellQtyUnit;
  String? price;
  String? priceUnit;
  String? addedDate;
  String? productCategoryTitle;
  String? surplusUnitTitle;
  String? sellQtyUnitTitle;
  String? priceUnitTitle;
  String? soldTO;
  String? soldOn;

  ManageChatData({
    this.id,
    this.sendFromId,
    this.sendToId,
    this.tradeProductBiddingId,
    this.msgText,
    this.sendToUsername,
    this.lastMessageTimestamp,
    this.tradeProductId,
    this.prodCatId,
    this.productTypeTitle,
    this.prodId,
    this.productTitle,
    this.productVarietyTitle,
    this.activeTillDate,
    this.surplus,
    this.surplusUnit,
    this.sellQty,
    this.sellQtyUnit,
    this.price,
    this.priceUnit,
    this.addedDate,
    this.productCategoryTitle,
    this.surplusUnitTitle,
    this.sellQtyUnitTitle,
    this.priceUnitTitle,
    this.statusTitle,
    this.soldTO,
    this.soldOn,
  });

  ManageChatData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    sendFromId = json['send_from_id'];
    sendToId = json['send_to_id'];
    tradeProductBiddingId = json['trade_product_bidding_id'];
    msgText = json['msg_text'];
    sendToUsername = json['send_to_username'];
    lastMessageTimestamp = json['last_message_timestamp'];
    tradeProductId = json['trade_product_id'];
    prodCatId = json['prod_cat_id'];
    productTypeTitle = json['product_type_title'];
    prodId = json['prod_id'];
    productTitle = json['product_title'];
    productVarietyTitle = json['product_variety_title'];
    activeTillDate = json['active_till_date'];
    surplus = json['surplus'];
    surplusUnit = json['surplus_unit'];
    sellQty = json['sell_qty'];
    sellQtyUnit = json['sell_qty_unit'];
    price = json['price'];
    priceUnit = json['price_unit'];
    addedDate = json['added_date'];
    productCategoryTitle = json['product_category_title'];
    surplusUnitTitle = json['surplus_unit_title'];
    sellQtyUnitTitle = json['sell_qty_unit_title'];
    priceUnitTitle = json['price_unit_title'];
    statusTitle = json['status_title'] ?? "Sold";
    soldTO = json['sold_to'] ?? "";
    soldOn = json['sold_on'] ?? "";
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['send_from_id'] = sendFromId;
    data['send_to_id'] = sendToId;
    data['trade_product_bidding_id'] = tradeProductBiddingId;
    data['msg_text'] = msgText;
    data['send_to_username'] = sendToUsername;
    data['last_message_timestamp'] = lastMessageTimestamp;
    data['trade_product_id'] = tradeProductId;
    data['prod_cat_id'] = prodCatId;
    data['product_type_title'] = productTypeTitle;
    data['prod_id'] = prodId;
    data['product_title'] = productTitle;
    data['product_variety_title'] = productVarietyTitle;
    data['active_till_date'] = activeTillDate;
    data['surplus'] = surplus;
    data['surplus_unit'] = surplusUnit;
    data['sell_qty'] = sellQty;
    data['sell_qty_unit'] = sellQtyUnit;
    data['price'] = price;
    data['price_unit'] = priceUnit;
    data['added_date'] = addedDate;
    data['product_category_title'] = productCategoryTitle;
    data['surplus_unit_title'] = surplusUnitTitle;
    data['sell_qty_unit_title'] = sellQtyUnitTitle;
    data['price_unit_title'] = priceUnitTitle;
    data['status_title'] = statusTitle;
    data['sold_to'] = soldTO;
    data['sold_on'] = soldOn;
    return data;
  }
}
