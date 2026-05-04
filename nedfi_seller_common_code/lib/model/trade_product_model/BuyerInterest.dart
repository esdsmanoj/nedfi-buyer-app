import 'package:nedfi_seller_common_code/model/trade_product_model/trade_product_info.dart';

class BuyerInterest {
  int? success;
  BuyerInterestData? data;
  String? message;

  BuyerInterest({this.success, this.data, this.message});

  BuyerInterest.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    data = json['data'] != null ? BuyerInterestData.fromJson(json['data']) : null;
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['success'] = success;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    data['message'] = message;
    return data;
  }
}

class BuyerInterestData {
  List<ProdInterestData>? prodInterestData;
  int? buyerInterestCount;
  List<BidderInterest>? buyerInterestList;
  String? profileImagePath;


  BuyerInterestData({this.prodInterestData, this.buyerInterestCount, this.buyerInterestList, this.profileImagePath});

  BuyerInterestData.fromJson(Map<String, dynamic> json) {
    if (json['prod_interest_data'] != null) {
      prodInterestData = <ProdInterestData>[];
      json['prod_interest_data'].forEach((v) {
        prodInterestData!.add(ProdInterestData.fromJson(v));
      });
    }
    buyerInterestCount = json['buyer_interest_count'];
    if (json['buyer_interest_list'] != null) {
      buyerInterestList = [];
      json['buyer_interest_list'].forEach((v) {
        buyerInterestList!.add(BidderInterest.fromJson(v));
      });
    }

    profileImagePath = json['profile_image_path'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (prodInterestData != null) {
      data['prod_interest_data'] = prodInterestData!.map((v) => v.toJson()).toList();
    }
    data['buyer_interest_count'] = buyerInterestCount;
    if (buyerInterestList != null) {
      data['buyer_interest_list'] = buyerInterestList!.map((v) => v.toJson()).toList();
    }

    data['profile_image_path'] = profileImagePath;
    return data;
  }
}

class ProdInterestData {
  String? id;
  String? userId;
  String? prodCatId;
  String? prodTypeId;
  String? productTypeTitle;
  dynamic prodDetails;
  String? prodId;
  String? productTitle;
  String? prodVarietyId;
  String? productVarietyTitle;
  String? activeTillDate;
  String? surplus;
  String? surplusUnit;
  String? otherDetails;
  String? sellQty;
  String? sellQtyUnit;
  String? price;
  String? priceUnit;
  String? withLogisticPartner;
  String? withPackging;
  String? packagingMasterId;
  String? packagingTitle;
  dynamic storageTypeId;
  dynamic storageTypeTitle;
  dynamic stateId;
  dynamic stateName;
  dynamic cityId;
  dynamic cityName;
  dynamic pickupLocation;
  dynamic otherDistance;
  dynamic produceToHighwayDistance;
  dynamic advancePayment;
  String? negotiations;
  String? certifcations;
  String? tradeStatus;
  dynamic partialTrade;
  String? status;
  dynamic reason;
  String? addedDate;
  String? expiryDate;
  dynamic approvedDate;
  dynamic rejectedDate;
  dynamic prodImages;
  String? productCategoryTitle;
  String? surplusUnitTitle;
  String? sellQtyUnitTitle;
  String? priceUnitTitle;
  String? status_title;
  String? prod_details_title;

  ProdInterestData(
      {this.id,
      this.userId,
      this.prodCatId,
      this.prodTypeId,
      this.productTypeTitle,
      this.prodDetails,
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
      this.status,
      this.reason,
      this.addedDate,
      this.expiryDate,
      this.approvedDate,
      this.rejectedDate,
      this.prodImages,
      this.productCategoryTitle,
      this.surplusUnitTitle,
      this.sellQtyUnitTitle,
      this.status_title,
      this.priceUnitTitle,
      this.prod_details_title});

  ProdInterestData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    prodCatId = json['prod_cat_id'];
    prodTypeId = json['prod_type_id'];
    productTypeTitle = json['product_type_title'];
    prodDetails = json['prod_details'];
    prodId = json['prod_id'];
    productTitle = json['product_title'];
    prodVarietyId = json['prod_variety_id'];
    productVarietyTitle = json['product_variety_title'];
    activeTillDate = json['active_till_date'];
    surplus = json['surplus'];
    surplusUnit = json['surplus_unit'];
    otherDetails = json['other_details'];
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
    otherDistance = json['other_distance'];
    produceToHighwayDistance = json['produce_to_highway_distance'];
    advancePayment = json['advance_payment'];
    negotiations = json['negotiations'];
    certifcations = json['certifcations'];
    tradeStatus = json['trade_status'];
    partialTrade = json['partial_trade'];
    status = json['status'];
    reason = json['reason'];
    addedDate = json['added_date'];
    expiryDate = json['expiry_date'];
    approvedDate = json['approved_date'];
    rejectedDate = json['rejected_date'];
    prodImages = json['prod_images'];
    productCategoryTitle = json['product_category_title'];
    surplusUnitTitle = json['surplus_unit_title'];
    sellQtyUnitTitle = json['sell_qty_unit_title'];
    priceUnitTitle = json['price_unit_title'];
    status_title = json['status_title'];
    prod_details_title = json['prod_details_title'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['user_id'] = userId;
    data['prod_cat_id'] = prodCatId;
    data['prod_type_id'] = prodTypeId;
    data['product_type_title'] = productTypeTitle;
    data['prod_details'] = prodDetails;
    data['prod_id'] = prodId;
    data['product_title'] = productTitle;
    data['prod_variety_id'] = prodVarietyId;
    data['product_variety_title'] = productVarietyTitle;
    data['active_till_date'] = activeTillDate;
    data['surplus'] = surplus;
    data['surplus_unit'] = surplusUnit;
    data['other_details'] = otherDetails;
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
    data['other_distance'] = otherDistance;
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
    data['product_category_title'] = productCategoryTitle;
    data['surplus_unit_title'] = surplusUnitTitle;
    data['sell_qty_unit_title'] = sellQtyUnitTitle;
    data['price_unit_title'] = priceUnitTitle;
    data['status_title'] = status_title;
    data['prod_details_title'] = prod_details_title;

    return data;
  }
}

class BuyerInterestList {
  String? prodId;
  String? prodCatId;
  String? buyerId;
  String? interestShownOn;
  String? firstName;
  Null? middleName;
  String? lastName;
  String? profileImage;
  RatingDetails? ratingDetails;

  BuyerInterestList({this.prodId, this.prodCatId, this.buyerId, this.interestShownOn, this.firstName, this.middleName, this.lastName, this.profileImage, this.ratingDetails});

  BuyerInterestList.fromJson(Map<String, dynamic> json) {
    prodId = json['prod_id'];
    prodCatId = json['prod_cat_id'];
    buyerId = json['buyer_id'];
    interestShownOn = json['interest_shown_on'];
    firstName = json['first_name'];
    middleName = json['middle_name'];
    lastName = json['last_name'];
    profileImage = json['profile_image'];
    ratingDetails = json['rating_details'] != null ? new RatingDetails.fromJson(json['rating_details']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['prod_id'] = prodId;
    data['prod_cat_id'] = prodCatId;
    data['buyer_id'] = buyerId;
    data['interest_shown_on'] = interestShownOn;
    data['first_name'] = firstName;
    data['middle_name'] = middleName;
    data['last_name'] = lastName;
    data['profile_image'] = profileImage;
    if (ratingDetails != null) {
      data['rating_details'] = ratingDetails!.toJson();
    }
    return data;
  }
}

class RatingDetails {
  int? happyCount;
  int? averageCount;
  int? poorCount;

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
