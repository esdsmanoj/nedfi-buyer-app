class ViewReceiptModel {
  int? success;
  List<Data>? data;
  String? message;
  int? numRows;

  ViewReceiptModel({this.success, this.data, this.message, this.numRows});

  ViewReceiptModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(Data.fromJson(v));
      });
    }
    message = json['message'];
    numRows = json['num_rows'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['success'] = success;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['message'] = message;
    data['num_rows'] = numRows;
    return data;
  }
}

class Data {
  String? id;
  String? buyerId;
  String? sellerId;
  String? tradeProductId;
  String? qty;
  String? qtyUnit;
  String? bidPrice;
  String? bidDate;
  String? bidCount;
  dynamic sellerAction;
  dynamic sellerActionDate;
  String? buyerAction;
  String? buyerActionDate;
  String? bidStatus;
  String? sellerInvoice;
  dynamic incentiveId;
  dynamic incentiveStatus;
  dynamic incentiveRedeemedDate;
  String? buyerProfileImage;
  String? buyerName;
  String? bidStatusTitle;
  String? qtyUnitTitle;

  Data(
      {this.id,
      this.buyerId,
      this.sellerId,
      this.tradeProductId,
      this.qty,
      this.qtyUnit,
      this.bidPrice,
      this.bidDate,
      this.bidCount,
      this.sellerAction,
      this.sellerActionDate,
      this.buyerAction,
      this.buyerActionDate,
      this.bidStatus,
      this.sellerInvoice,
      this.incentiveId,
      this.incentiveStatus,
      this.incentiveRedeemedDate,
      this.buyerProfileImage,
      this.buyerName,
      this.bidStatusTitle,
      this.qtyUnitTitle});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    buyerId = json['buyer_id'];
    sellerId = json['seller_id'];
    tradeProductId = json['trade_product_id'];
    qty = json['qty'];
    qtyUnit = json['qty_unit'];
    bidPrice = json['bid_price'];
    bidDate = json['bid_date'];
    bidCount = json['bid_count'];
    sellerAction = json['seller_action'];
    sellerActionDate = json['seller_action_date'];
    buyerAction = json['buyer_action'];
    buyerActionDate = json['buyer_action_date'];
    bidStatus = json['bid_status'];
    sellerInvoice = json['seller_invoice'];
    incentiveId = json['incentive_id'];
    incentiveStatus = json['incentive_status'];
    incentiveRedeemedDate = json['incentive_redeemed_date'];
    buyerProfileImage = json['buyer_profile_image'];
    buyerName = json['buyer_name'];
    bidStatusTitle = json['bid_status_title'];
    qtyUnitTitle = json['qty_unit_title'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['buyer_id'] = buyerId;
    data['seller_id'] = sellerId;
    data['trade_product_id'] = tradeProductId;
    data['qty'] = qty;
    data['qty_unit'] = qtyUnit;
    data['bid_price'] = bidPrice;
    data['bid_date'] = bidDate;
    data['bid_count'] = bidCount;
    data['seller_action'] = sellerAction;
    data['seller_action_date'] = sellerActionDate;
    data['buyer_action'] = buyerAction;
    data['buyer_action_date'] = buyerActionDate;
    data['bid_status'] = bidStatus;
    data['seller_invoice'] = sellerInvoice;
    data['incentive_id'] = incentiveId;
    data['incentive_status'] = incentiveStatus;
    data['incentive_redeemed_date'] = incentiveRedeemedDate;
    data['buyer_profile_image'] = buyerProfileImage;
    data['buyer_name'] = buyerName;
    data['bid_status_title'] = bidStatusTitle;
    data['qty_unit_title'] = qtyUnitTitle;
    return data;
  }
}
