class TradeProductInfo {
  int? success;
  List<TradeProductData>? data;
  dynamic message;
  int? total;
  String? imagePath;
  String? sellerInvoicePath;
  String? clientProfilePath;
  String? prodMasterImagePath;

  TradeProductInfo({this.success, this.data, this.message, this.total, this.imagePath, this.sellerInvoicePath, this.clientProfilePath, this.prodMasterImagePath});

  TradeProductInfo.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    if (json['data'] != null) {
      data = <TradeProductData>[];
      json['data'].forEach((v) {
        data!.add(TradeProductData.fromJson(v));
      });
    }
    message = json['message'].toString();
    total = json['total'];
    imagePath = json['image_path'];
    sellerInvoicePath = json['seller_invoice_path'];
    clientProfilePath = json['client_profile_path'];
    prodMasterImagePath = json['prod_master_image_path'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['success'] = success;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['message'] = message;
    data['total'] = total;
    data['image_path'] = imagePath;
    data['seller_invoice_path'] = sellerInvoicePath;
    data['client_profile_path'] = clientProfilePath;
    data['prod_master_image_path'] = prodMasterImagePath;
    return data;
  }
}

class TradeProductData {
  String? id;
  String? userId;
  String? prodCatId;
  String? prodTypeId;
  String? productTypeTitle;
  String? prodId;
  String? productTitle;
  String? prodVarietyId;
  String? productVarietyTitle;
  String? activeTillDate;
  String? surplus;
  String? surplusUnit;
  OtherDetails? otherDetails;
  String? sellQty;
  String? sellQtyUnit;
  String? price;
  String? priceUnit;
  String? withLogisticPartner;
  String? withPackging;
  dynamic packagingMasterId;
  dynamic packagingTitle;
  dynamic storageTypeId;
  dynamic storageTypeTitle;
  dynamic stateId;
  dynamic stateName;
  dynamic cityId;
  dynamic cityName;
  dynamic pickupLocation;
  OtherDistance? otherDistance;
  dynamic produceToHighwayDistance;
  dynamic advancePayment;
  String? negotiations;
  String? certifcations;
  String? tradeStatus;
  dynamic partialTrade;
  String? prodThumbnail;
  String? status;
  dynamic reason;
  String? addedDate;
  String? expiryDate;
  dynamic approvedDate;
  dynamic rejectedDate;
  String? prodImages;
  List<dynamic>? allProdImages;
  String? productCategoryTitle;
  String? surplusUnitTitle;
  String? sellQtyUnitTitle;
  String? priceUnitTitle;
  String? statusTitle;
  String? tradeStatusTitle;
  String? seasonText;
  String? logisticText;
  String? packagingText;
  String? sold_price;
  int? tradeProductBiddingCount;
  int? buyerInterestCount;
  List<ProductBidder>? tradeProductBidding;
  List<BidderInterest>? buyerInterest;
  String? soldOn;
  String? soldPrice;
  String? soldTO;
  String? prod_details;
  String? prod_images;
  String? bidderId;
  String? soldBidDate;
  String? prod_details_title;
  String? sold_to_buyer_id;
  RatingDetails? ratingDetails;
  bool? revokeExpire;

  TradeProductData(
      {this.id,
      this.userId,
      this.prodCatId,
      this.prodTypeId,
      this.productTypeTitle,
      this.prodId,
      this.productTitle,
      this.prodVarietyId,
      this.productVarietyTitle,
      this.activeTillDate,
      this.surplus,
      this.surplusUnit,
      this.otherDetails,
      this.sellQty,
      this.sellQtyUnit,
      this.price,
      this.priceUnit,
      this.withLogisticPartner,
      this.withPackging,
      this.packagingMasterId,
      this.packagingTitle,
      this.storageTypeId,
      this.storageTypeTitle,
      this.stateId,
      this.stateName,
      this.cityId,
      this.cityName,
      this.pickupLocation,
      this.otherDistance,
      this.produceToHighwayDistance,
      this.advancePayment,
      this.negotiations,
      this.certifcations,
      this.tradeStatus,
      this.partialTrade,
      this.prodThumbnail,
      this.status,
      this.reason,
      this.addedDate,
      this.expiryDate,
      this.approvedDate,
      this.rejectedDate,
      this.prodImages,
      this.allProdImages,
      this.productCategoryTitle,
      this.surplusUnitTitle,
      this.sellQtyUnitTitle,
      this.priceUnitTitle,
      this.statusTitle,
      this.tradeStatusTitle,
      this.seasonText,
      this.logisticText,
      this.packagingText,
      this.tradeProductBiddingCount,
      this.buyerInterestCount,
      this.soldOn,
      this.soldPrice,
      this.soldTO,
      this.sold_price,
      this.tradeProductBidding,
      this.buyerInterest,
      this.prod_images,
      this.prod_details,
      this.bidderId,
      this.soldBidDate,
      this.prod_details_title,
      this.sold_to_buyer_id,
        this.revokeExpire,
      this.ratingDetails});

  TradeProductData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    prodCatId = json['prod_cat_id'];
    prodTypeId = json['prod_type_id'];
    productTypeTitle = json['product_type_title'];
    prodId = json['prod_id'];
    productTitle = json['product_title'];
    prodVarietyId = json['prod_variety_id'];
    productVarietyTitle = json['product_variety_title'];
    activeTillDate = json['active_till_date'];
    surplus = json['surplus'];
    surplusUnit = json['surplus_unit'];
    sellQty = json['sell_qty'];
    sellQtyUnit = json['sell_qty_unit'];
    price = json['price'];
    priceUnit = json['price_unit'];
    withLogisticPartner = json['with_logistic_partner'];
    withPackging = json['with_packging'];
    packagingMasterId = json['packaging_master_id'];
    packagingTitle = json['packaging_title'];
    storageTypeId = json['storage_type_id'];
    storageTypeTitle = json['storage_type_title'];
    stateId = json['state_id'];
    stateName = json['state_name'];
    cityId = json['city_id'];
    cityName = json['city_name'];
    pickupLocation = json['pickup_location'];
    otherDetails = json['other_details'] != null ? OtherDetails.fromJson(json['other_details']) : null;
    otherDistance = json['other_distance'] != null ? OtherDistance.fromJson(json['other_distance']) : null;
    produceToHighwayDistance = json['produce_to_highway_distance'];
    advancePayment = json['advance_payment'];
    negotiations = json['negotiations'];
    certifcations = json['certifcations'];
    tradeStatus = json['trade_status'];
    partialTrade = json['partial_trade'];
    status = json['status'];
    reason = json['reason'];
    prodThumbnail = json['prod_thumbnail'];
    addedDate = json['added_date'];
    expiryDate = json['expiry_date'];
    approvedDate = json['approved_date'];
    rejectedDate = json['rejected_date'];
    prodImages = json['prod_images'] ?? "";
    allProdImages = json['all_prod_images'] ?? [];
    productCategoryTitle = json['product_category_title'];
    surplusUnitTitle = json['surplus_unit_title'];
    sellQtyUnitTitle = json['sell_qty_unit_title'];
    priceUnitTitle = json['price_unit_title'];
    statusTitle = json['status_title'];
    tradeStatusTitle = json['trade_status_title'];
    seasonText = json['season_text'];
    logisticText = json['logistic_text'];
    packagingText = json['packaging_text'];
    soldOn = json['sold_on'];
    soldPrice = json['sold_price'];
    soldTO = json['sold_to'];
    bidderId = json['bidding_id'];
    packagingText = json['packaging_text'];
    prod_details = json['prod_details'];
    prod_images = json['prod_images'];
    tradeProductBiddingCount = json['trade_product_bidding_count'];
    buyerInterestCount = json['buyer_intrest_count'];
    prod_details_title = json['prod_details_title'] ?? "";
    soldBidDate = json['sold_bid_date'];
    sold_to_buyer_id = json['sold_to_buyer_id'];
    sold_price = json['sold_price'];
    revokeExpire = json['revoke_expire'];
    ratingDetails = (json['rating_details'] != null ? RatingDetails.fromJson(json['rating_details']) : null);
    if (json['trade_product_bidding'] != null) {
      tradeProductBidding = <ProductBidder>[];
      json['trade_product_bidding'].forEach((v) {
        tradeProductBidding!.add(ProductBidder.fromJson(v));
      });
    }
    if (json['buyer_intrest'] != null) {
      buyerInterest = <BidderInterest>[];
      json['buyer_intrest'].forEach((v) {
        buyerInterest!.add(BidderInterest.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['user_id'] = userId;
    data['prod_cat_id'] = prodCatId;
    data['prod_type_id'] = prodTypeId;
    data['product_type_title'] = productTypeTitle;
    data['prod_id'] = prodId;
    data['product_title'] = productTitle;
    data['prod_variety_id'] = prodVarietyId;
    data['product_variety_title'] = productVarietyTitle;
    data['active_till_date'] = activeTillDate;
    data['surplus'] = surplus;
    data['surplus_unit'] = surplusUnit;
    if (otherDetails != null) {
      data['other_details'] = otherDetails!.toJson();
    }
    data['sell_qty'] = sellQty;
    data['sell_qty_unit'] = sellQtyUnit;
    data['price'] = price;
    data['price_unit'] = priceUnit;
    data['with_logistic_partner'] = withLogisticPartner;
    data['with_packging'] = withPackging;
    data['packaging_master_id'] = packagingMasterId;
    data['packaging_title'] = packagingTitle;
    data['storage_type_id'] = storageTypeId;
    data['storage_type_title'] = storageTypeTitle;
    data['state_id'] = stateId;
    data['state_name'] = stateName;
    data['city_id'] = cityId;
    data['city_name'] = cityName;
    data['pickup_location'] = pickupLocation;
    if (otherDistance != null) {
      data['other_distance'] = otherDistance!.toJson();
    }
    data['produce_to_highway_distance'] = produceToHighwayDistance;
    data['advance_payment'] = advancePayment;
    data['negotiations'] = negotiations;
    data['certifcations'] = certifcations;
    data['trade_status'] = tradeStatus;
    data['partial_trade'] = partialTrade;
    data['status'] = status;
    data['reason'] = reason;
    data['added_date'] = addedDate;
    data['expiry_date'] = expiryDate;
    data['approved_date'] = approvedDate;
    data['rejected_date'] = rejectedDate;
    data['prod_images'] = prodImages;
    data['all_prod_images'] = allProdImages;
    data['product_category_title'] = productCategoryTitle;
    data['surplus_unit_title'] = surplusUnitTitle;
    data['sell_qty_unit_title'] = sellQtyUnitTitle;
    data['price_unit_title'] = priceUnitTitle;
    data['status_title'] = statusTitle;
    data['trade_status_title'] = tradeStatusTitle;
    data['season_text'] = seasonText;
    data['logistic_text'] = logisticText;
    data['prod_thumbnail'] = prodThumbnail;
    data['packaging_text'] = packagingText;
    data['trade_product_bidding_count'] = tradeProductBiddingCount;
    data['sold_to'] = tradeProductBiddingCount;
    data['sold_on'] = tradeProductBiddingCount;
    data['prod_details'] = prod_details;
    data['prod_images'] = prod_images;
    data['sold_to'] = soldTO;
    data['sold_price'] = soldPrice;
    data['sold_on'] = soldOn;
    data['bidding_id'] = bidderId;
    data['sold_price'] = sold_price;
    data['sold_bid_date'] = soldBidDate;
    data['prod_details_title'] = prod_details_title;
    data['sold_to_buyer_id'] = sold_to_buyer_id;
    data['revoke_expire'] = revokeExpire;
    if (ratingDetails != null) {
      data['rating_details'] = ratingDetails!.toJson();
    }
    if (tradeProductBidding != null) {
      data['trade_product_bidding'] = tradeProductBidding!.map((v) => v.toJson()).toList();
    }
    if (buyerInterest != null) {
      data['buyer_intrest'] = buyerInterest!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class RatingDetails {
 dynamic happyCount;
 dynamic averageCount;
 dynamic poorCount;

  RatingDetails({this.happyCount, this.averageCount, this.poorCount});

  RatingDetails.fromJson(Map<String, dynamic> json) {
    happyCount = json['happy_count'];
    averageCount = json['average_count'];
    poorCount = json['poor_count'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['happy_count'] = happyCount;
    data['average_count'] = averageCount;
    data['poor_count'] = poorCount;
    return data;
  }
}

class ProductBidder {
  String? id;
  String? buyerId;
  String? sellerId;
  String? tradeProductId;
  String? qty;
  String? qtyUnit;
  String? bidPrice;
  String? bidDate;
  String? bid_place_date;
  String? bidCount;
  dynamic sellerAction;
  dynamic sellerActionDate;
  String? buyerAction;
  String? buyerActionDate;
  String? bidStatus;
  dynamic incentiveId;
  dynamic incentiveStatus;
  dynamic incentiveRedeemedDate;
  bool? revokeExpire;
  dynamic revokeTimeLeft;
  dynamic revokeTime;
  dynamic buyerProfileImage;
  String? buyerName;
  String? bidStatusTitle;
  String? qtyUnitTitle;
  String? trade_product_status_id;
  String? trade_product_status;
  dynamic incentiveTitle;

  ProductBidder(
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
      this.incentiveId,
      this.incentiveStatus,
      this.incentiveRedeemedDate,
      this.revokeExpire,
      this.revokeTimeLeft,
      this.revokeTime,
      this.buyerProfileImage,
      this.buyerName,
      this.bidStatusTitle,
      this.qtyUnitTitle,
      this.trade_product_status_id,
      this.trade_product_status,
      this.incentiveTitle});

  ProductBidder.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    buyerId = json['buyer_id'];
    sellerId = json['seller_id'];
    tradeProductId = json['trade_product_id'];
    qty = json['qty'];
    qtyUnit = json['qty_unit'];
    bidPrice = json['bid_price'];
    bidDate = json['bid_date'];
    bid_place_date = json['bid_place_date'];
    bidCount = json['bid_count'];
    sellerAction = json['seller_action'];
    sellerActionDate = json['seller_action_date'];
    buyerAction = json['buyer_action'];
    buyerActionDate = json['buyer_action_date'];
    bidStatus = json['bid_status'];
    incentiveId = json['incentive_id'];
    incentiveStatus = json['incentive_status'];
    incentiveRedeemedDate = json['incentive_redeemed_date'];
    revokeExpire = json['revoke_expire'];
    revokeTimeLeft = json['revoke_time_left'];
    revokeTime = json['revoke_time'];
    buyerProfileImage = json['buyer_profile_image'];
    buyerName = json['buyer_name'];
    bidStatusTitle = json['bid_status_title'];
    qtyUnitTitle = json['qty_unit_title'];
    trade_product_status_id = json['trade_product_status_id'].toString();
    trade_product_status= json['trade_product_status'];
    incentiveTitle = json['incentive_title'];
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
    data['bid_place_date'] = bid_place_date;
    data['bid_count'] = bidCount;
    data['seller_action'] = sellerAction;
    data['seller_action_date'] = sellerActionDate;
    data['buyer_action'] = buyerAction;
    data['buyer_action_date'] = buyerActionDate;
    data['bid_status'] = bidStatus;
    data['incentive_id'] = incentiveId;
    data['incentive_status'] = incentiveStatus;
    data['incentive_redeemed_date'] = incentiveRedeemedDate;
    data['revoke_expire'] = revokeExpire;
    data['revoke_time_left'] = revokeTimeLeft;
    data['revoke_time'] = revokeTime;
    data['buyer_profile_image'] = buyerProfileImage;
    data['buyer_name'] = buyerName;
    data['bid_status_title'] = bidStatusTitle;
    data['trade_product_status_id'] = trade_product_status_id;
    data['trade_product_status'] = trade_product_status;
    data['qty_unit_title'] = qtyUnitTitle;
    data['incentive_title'] = incentiveTitle;
    return data;
  }
}

class OtherDetails {
  String? seasonFrom;
  String? seasonTo;
  String? availableFrom;
  String? availableTo;
  String? yieldFrom;
  String? yieldFromUnit;
  String? yieldTo;
  String? yieldToUnit;
  String? yieldFromUnitText;
  String? yieldToUnitText;

  OtherDetails(
      {this.seasonFrom, this.seasonTo, this.availableFrom, this.availableTo, this.yieldFrom, this.yieldFromUnit, this.yieldTo, this.yieldToUnit, this.yieldFromUnitText, this.yieldToUnitText});

  OtherDetails.fromJson(Map<String, dynamic> json) {
    seasonFrom = json['season_from'];
    seasonTo = json['season_to'];
    availableFrom = json['availability_from'];
    availableTo = json['availability_to'];
    yieldFrom = json['yield_from'];
    yieldFromUnit = json['yield_from_unit'];
    yieldTo = json['yield_to'];
    yieldToUnit = json['yield_to_unit'];
    yieldFromUnitText = json['yield_from_unit_text'];
    yieldToUnitText = json['yield_to_unit_text'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['season_from'] = seasonFrom;
    data['season_to'] = seasonTo;
    data['availability_from'] = availableFrom;
    data['availability_to'] = availableTo;
    data['yield_from'] = yieldFrom;
    data['yield_from_unit'] = yieldFromUnit;
    data['yield_to'] = yieldTo;
    data['yield_to_unit'] = yieldToUnit;
    data['yield_from_unit_text'] = yieldFromUnitText;
    data['yield_to_unit_text'] = yieldToUnitText;
    return data;
  }
}

class OtherDistance {
  String? railway;
  String? airport;
  String? postOffice;
  String? godown;
  String? nationalHighway;
  String? stateHighway;

  OtherDistance({this.railway, this.airport, this.postOffice, this.godown, this.nationalHighway, this.stateHighway});

  OtherDistance.fromJson(Map<String, dynamic> json) {
    railway = json['railway'];
    airport = json['airport'];
    postOffice = json['post_office'];
    godown = json['godown'];
    nationalHighway = json['national_highway'];
    stateHighway = json['state_highway'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['railway'] = railway;
    data['airport'] = airport;
    data['post_office'] = postOffice;
    data['godown'] = godown;
    data['national_highway'] = nationalHighway;
    data['state_highway'] = stateHighway;
    return data;
  }
}

class BidderInterest {
  String? productId;
  String? buyerId;
  String? interestShownOn;
  String? firstName;
  dynamic middleName;
  String? lastName;
  String? profileImage;

  BidderInterest({this.productId, this.buyerId, this.interestShownOn, this.firstName, this.middleName, this.lastName, this.profileImage});

  BidderInterest.fromJson(Map<String, dynamic> json) {
    productId = json['product_id'];
    buyerId = json['buyer_id'];
    interestShownOn = json['interest_shown_on'];
    firstName = json['first_name'];
    middleName = json['middle_name'];
    lastName = json['last_name'];
    profileImage = json['profile_image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['product_id'] = productId;
    data['buyer_id'] = buyerId;
    data['interest_shown_on'] = interestShownOn;
    data['first_name'] = firstName;
    data['middle_name'] = middleName;
    data['last_name'] = lastName;
    data['profile_image'] = profileImage;
    return data;
  }
}
