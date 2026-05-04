class BidChat {
  int? success;
  int? error;
  int? status;
  List<BidChatData>? data;
  String? chatStr;
  String? message;
  TradeProductDetails? tradeProductDetails;
  SendToCilentDetails? sendToCilentDetails;
  SendToCilentDetails? sendFromCilentDetails;
  String? clientProfilePath;

  BidChat({this.success, this.error, this.status, this.data, this.chatStr, this.message, this.tradeProductDetails, this.sendToCilentDetails, this.sendFromCilentDetails, this.clientProfilePath});

  BidChat.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    error = json['error'];
    status = json['status'];
    if (json['data'] != null) {
      data = <BidChatData>[];
      json['data'].forEach((v) {
        data!.add(BidChatData.fromJson(v));
      });
    }
    chatStr = json['chat_str'];
    message = json['message'];
    tradeProductDetails = json['trade_product_details'] != null ? TradeProductDetails.fromJson(json['trade_product_details']) : null;
    sendToCilentDetails = json['send_to_cilent_details'] != null ? SendToCilentDetails.fromJson(json['send_to_cilent_details']) : null;
    sendFromCilentDetails = json['send_from_cilent_details'] != null ? SendToCilentDetails.fromJson(json['send_from_cilent_details']) : null;
    clientProfilePath = json['client_profile_path'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['success'] = success;
    data['error'] = error;
    data['status'] = status;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['chat_str'] = chatStr;
    data['message'] = message;
    if (tradeProductDetails != null) {
      data['trade_product_details'] = tradeProductDetails!.toJson();
    }
    if (sendToCilentDetails != null) {
      data['send_to_cilent_details'] = sendToCilentDetails!.toJson();
    }
    if (sendFromCilentDetails != null) {
      data['send_from_cilent_details'] = sendFromCilentDetails!.toJson();
    }
    data['client_profile_path'] = clientProfilePath;
    return data;
  }
}

class BidChatData {
  String? id;
  String? tradeProductBiddingId;
  String? msgText;
  String? sendFromId;
  String? sendToId;
  String? createdOn;
  dynamic createdById;
  dynamic updatedOn;
  dynamic updatedById;
  dynamic deletedOn;
  dynamic deletedById;
  String? isActive;
  String? isDeleted;

  BidChatData(
      {this.id,
      this.tradeProductBiddingId,
      this.msgText,
      this.sendFromId,
      this.sendToId,
      this.createdOn,
      this.createdById,
      this.updatedOn,
      this.updatedById,
      this.deletedOn,
      this.deletedById,
      this.isActive,
      this.isDeleted});

  BidChatData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    tradeProductBiddingId = json['trade_product_bidding_id'];
    msgText = json['msg_text'];
    sendFromId = json['send_from_id'];
    sendToId = json['send_to_id'];
    createdOn = json['created_on'];
    createdById = json['created_by_id'];
    updatedOn = json['updated_on'];
    updatedById = json['updated_by_id'];
    deletedOn = json['deleted_on'];
    deletedById = json['deleted_by_id'];
    isActive = json['is_active'];
    isDeleted = json['is_deleted'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = id;
    data['trade_product_bidding_id'] = tradeProductBiddingId;
    data['msg_text'] = msgText;
    data['send_from_id'] = sendFromId;
    data['send_to_id'] = sendToId;
    data['created_on'] = createdOn;
    data['created_by_id'] = createdById;
    data['updated_on'] = updatedOn;
    data['updated_by_id'] = updatedById;
    data['deleted_on'] = deletedOn;
    data['deleted_by_id'] = deletedById;
    data['is_active'] = isActive;
    data['is_deleted'] = isDeleted;
    return data;
  }
}

class TradeProductDetails {
  String? tradeProductId;
  String? userId;
  String? prodId;
  String? productTitle;
  String? productLogo;
  String? price;
  String? priceUnit;
  String? status;
  String? bidPrice;

  TradeProductDetails({this.tradeProductId, this.userId, this.prodId, this.productTitle, this.productLogo, this.price, this.priceUnit, this.status, this.bidPrice});

  TradeProductDetails.fromJson(Map<String, dynamic> json) {
    tradeProductId = json['trade_product_id'];
    userId = json['user_id'];
    prodId = json['prod_id'];
    productTitle = json['product_title'];
    productLogo = json['product_logo'];
    price = json['price'];
    priceUnit = json['price_unit'];
    status = json['status'];
    bidPrice = json['bid_price'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['trade_product_id'] = tradeProductId;
    data['user_id'] = userId;
    data['prod_id'] = prodId;
    data['product_title'] = productTitle;
    data['product_logo'] = productLogo;
    data['price'] = price;
    data['price_unit'] = priceUnit;
    data['status'] = status;
    data['bid_price'] = bidPrice;
    return data;
  }
}

class SendToCilentDetails {
  String? id;
  String? firstName;
  String? lastName;
  String? profileImage;

  SendToCilentDetails({this.id, this.firstName, this.lastName, this.profileImage});

  SendToCilentDetails.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    profileImage = json['profile_image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = id;
    data['first_name'] = firstName;
    data['last_name'] = lastName;
    data['profile_image'] = profileImage;
    return data;
  }
}
