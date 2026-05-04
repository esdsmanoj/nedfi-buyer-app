import 'package:buyer_common_code/model/trade_product_info.dart';

class BuyerInterest {
  int? success;
  BuyerInterestData? data;
  String? message;

  BuyerInterest({this.success, this.data, this.message});

  BuyerInterest.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    data = json['data'] != null ?  BuyerInterestData.fromJson(json['data']) : null;
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data =  Map<String, dynamic>();
    data['success'] = this.success;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    data['message'] = this.message;
    return data;
  }
}

class BuyerInterestData {
  List<ProdInterestData>? prodInterestData;
  int? buyerInterestCount;
  List<BidderInterest>? buyerInterestList;
  String? profileImagePath;

  BuyerInterestData(
      {this.prodInterestData,
        this.buyerInterestCount,
        this.buyerInterestList,
        this.profileImagePath});

  BuyerInterestData.fromJson(Map<String, dynamic> json) {
    if (json['prod_interest_data'] != null) {
      prodInterestData = <ProdInterestData>[];
      json['prod_interest_data'].forEach((v) {
        prodInterestData!.add( ProdInterestData.fromJson(v));
      });
    }
    buyerInterestCount = json['buyer_interest_count'];
    if (json['buyer_interest_list'] != null) {
      buyerInterestList = [];
      json['buyer_interest_list'].forEach((v) {
        buyerInterestList!.add( BidderInterest.fromJson(v));
      });
    }
    profileImagePath = json['profile_image_path'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data =  Map<String, dynamic>();
    if (this.prodInterestData != null) {
      data['prod_interest_data'] =
          this.prodInterestData!.map((v) => v.toJson()).toList();
    }
    data['buyer_interest_count'] = this.buyerInterestCount;
    if (this.buyerInterestList != null) {
      data['buyer_interest_list'] =
          this.buyerInterestList!.map((v) => v.toJson()).toList();
    }
    data['profile_image_path'] = this.profileImagePath;
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
        this.priceUnitTitle});

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
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data =  Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['prod_cat_id'] = this.prodCatId;
    data['prod_type_id'] = this.prodTypeId;
    data['product_type_title'] = this.productTypeTitle;
    data['prod_details'] = this.prodDetails;
    data['prod_id'] = this.prodId;
    data['product_title'] = this.productTitle;
    data['prod_variety_id'] = this.prodVarietyId;
    data['product_variety_title'] = this.productVarietyTitle;
    data['active_till_date'] = this.activeTillDate;
    data['surplus'] = this.surplus;
    data['surplus_unit'] = this.surplusUnit;
    data['other_details'] = this.otherDetails;
    data['sell_qty'] = this.sellQty;
    data['sell_qty_unit'] = this.sellQtyUnit;
    data['price'] = this.price;
    data['price_unit'] = this.priceUnit;
    data['with_logistic_partner'] = this.withLogisticPartner;
    data['with_packging'] = this.withPackging;
    data['packaging_master_id'] = this.packagingMasterId;
    data['packaging_title'] = this.packagingTitle;
    data['storage_type_id'] = this.storageTypeId;
    data['storage_type_title'] = this.storageTypeTitle;
    data['state_id'] = this.stateId;
    data['state_name'] = this.stateName;
    data['city_id'] = this.cityId;
    data['city_name'] = this.cityName;
    data['pickup_location'] = this.pickupLocation;
    data['other_distance'] = this.otherDistance;
    data['produce_to_highway_distance'] = this.produceToHighwayDistance;
    data['advance_payment'] = this.advancePayment;
    data['negotiations'] = this.negotiations;
    data['certifcations'] = this.certifcations;
    data['trade_status'] = this.tradeStatus;
    data['partial_trade'] = this.partialTrade;
    data['status'] = this.status;
    data['reason'] = this.reason;
    data['added_date'] = this.addedDate;
    data['expiry_date'] = this.expiryDate;
    data['approved_date'] = this.approvedDate;
    data['rejected_date'] = this.rejectedDate;
    data['prod_images'] = this.prodImages;
    data['product_category_title'] = this.productCategoryTitle;
    data['surplus_unit_title'] = this.surplusUnitTitle;
    data['sell_qty_unit_title'] = this.sellQtyUnitTitle;
    data['price_unit_title'] = this.priceUnitTitle;
    data['status_title'] = this.status_title;
    return data;
  }
}