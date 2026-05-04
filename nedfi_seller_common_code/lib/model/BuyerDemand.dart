class BuyerDemand {
  int? success;
  List<BuyerDemandData>? data;
  String? message;

  BuyerDemand({this.success, this.data, this.message});

  BuyerDemand.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    if (json['data'] != null) {
      data = <BuyerDemandData>[];
      json['data'].forEach((v) {
        data!.add(new BuyerDemandData.fromJson(v));
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

class BuyerDemandData {
  String? id;
  String? firstName;
  String? middleName;
  String? lastName;
  String? profileImage;
  String? demandType;
  String? prodCatId;
  String? prodTypeId;
  String? prodVarietyId;
  String? prodId;
  String? subType;
  String? postedOn;
  String? priceFrom;
  String? priceTo;
  String? priceUnit;
  String? availableFrom;
  String? availableTo;
  String? productTitle;
  String? productVarietyTitle;
  String? productTypeTitle;
  String? productCategoryTitle;
  String? priceUnitTitle;

  BuyerDemandData(
      {this.id,
        this.firstName,
        this.middleName,
        this.lastName,
        this.profileImage,
        this.demandType,
        this.prodCatId,
        this.prodTypeId,
        this.prodVarietyId,
        this.prodId,
        this.subType,
        this.postedOn,
        this.priceFrom,
        this.priceTo,
        this.priceUnit,
        this.availableFrom,
        this.availableTo,
        this.productTitle,
        this.productVarietyTitle,
        this.productTypeTitle,
        this.productCategoryTitle,
        this.priceUnitTitle});

  BuyerDemandData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    firstName = json['first_name'];
    middleName = json['middle_name'];
    lastName = json['last_name'];
    profileImage = json['profile_image'];
    demandType = json['demand_type'];
    prodCatId = json['prod_cat_id'];
    prodTypeId = json['prod_type_id'];
    prodVarietyId = json['prod_variety_id'];
    prodId = json['prod_id'];
    subType = json['sub_type'];
    postedOn = json['posted_on'];
    priceFrom = json['price_from'];
    priceTo = json['price_to'];
    priceUnit = json['price_unit'];
    availableFrom = json['available_from'];
    availableTo = json['available_to'];
    productTitle = json['product_title'];
    productVarietyTitle = json['product_variety_title'];
    productTypeTitle = json['product_type_title'];
    productCategoryTitle = json['product_category_title'];
    priceUnitTitle = json['price_unit_title'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['first_name'] = this.firstName;
    data['middle_name'] = this.middleName;
    data['last_name'] = this.lastName;
    data['profile_image'] = this.profileImage;
    data['demand_type'] = this.demandType;
    data['prod_cat_id'] = this.prodCatId;
    data['prod_type_id'] = this.prodTypeId;
    data['prod_variety_id'] = this.prodVarietyId;
    data['prod_id'] = this.prodId;
    data['sub_type'] = this.subType;
    data['posted_on'] = this.postedOn;
    data['price_from'] = this.priceFrom;
    data['price_to'] = this.priceTo;
    data['price_unit'] = this.priceUnit;
    data['available_from'] = this.availableFrom;
    data['available_to'] = this.availableTo;
    data['product_title'] = this.productTitle;
    data['product_variety_title'] = this.productVarietyTitle;
    data['product_type_title'] = this.productTypeTitle;
    data['product_category_title'] = this.productCategoryTitle;
    data['price_unit_title'] = this.priceUnitTitle;
    return data;
  }
}