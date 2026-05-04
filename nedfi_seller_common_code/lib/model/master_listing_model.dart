class MasterListing {
  int? success;
  Data? data;
  String? message;

  MasterListing({this.success, this.data, this.message});

  MasterListing.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
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

class Data {
  List<ProductCategory>? productCategory;
  List<Season>? season;
  List<UserType>? productUnit;
  List<ProductPayment>? productPayment;
  List<TradeStatusList>? tradeStatusList;
  List<UserType>? userType;
  List<UserType>? businessType;
  List<UserType>? businessScheme;

  Data({this.productCategory, this.season, this.productUnit, this.productPayment, this.tradeStatusList, this.userType, this.businessType, this.businessScheme});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['product_category'] != null) {
      productCategory = <ProductCategory>[];
      json['product_category'].forEach((v) {
        productCategory!.add(ProductCategory.fromJson(v));
      });
    }
    if (json['season'] != null) {
      season = <Season>[];
      json['season'].forEach((v) {
        season!.add(Season.fromJson(v));
      });
    }
    if (json['product_unit'] != null) {
      productUnit = <UserType>[];
      json['product_unit'].forEach((v) {
        productUnit!.add(UserType.fromJson(v));
      });
    }
    if (json['product_payment'] != null) {
      productPayment = <ProductPayment>[];
      json['product_payment'].forEach((v) {
        productPayment!.add(ProductPayment.fromJson(v));
      });
    }
    if (json['trade_status_list'] != null) {
      tradeStatusList = <TradeStatusList>[];
      json['trade_status_list'].forEach((v) {
        tradeStatusList!.add(TradeStatusList.fromJson(v));
      });
    }
    if (json['user_type'] != null) {
      userType = <UserType>[];
      json['user_type'].forEach((v) {
        userType!.add(UserType.fromJson(v));
      });
    }
    if (json['business_type'] != null) {
      businessType = <UserType>[];
      json['business_type'].forEach((v) {
        businessType!.add(UserType.fromJson(v));
      });
    }
    if (json['business_scheme'] != null) {
      businessScheme = <UserType>[];
      json['business_scheme'].forEach((v) {
        businessScheme!.add(UserType.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (productCategory != null) {
      data['product_category'] = productCategory!.map((v) => v.toJson()).toList();
    }
    if (season != null) {
      data['season'] = season!.map((v) => v.toJson()).toList();
    }
    if (productUnit != null) {
      data['product_unit'] = productUnit!.map((v) => v.toJson()).toList();
    }
    if (productPayment != null) {
      data['product_payment'] = productPayment!.map((v) => v.toJson()).toList();
    }
    if (tradeStatusList != null) {
      data['trade_status_list'] = tradeStatusList!.map((v) => v.toJson()).toList();
    }
    if (userType != null) {
      data['user_type'] = userType!.map((v) => v.toJson()).toList();
    }
    if (businessType != null) {
      data['business_type'] = businessType!.map((v) => v.toJson()).toList();
    }
    if (businessScheme != null) {
      data['business_scheme'] = businessScheme!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ProductCategory {
  int? id;
  String? title;
  String? mapKey;
  int? days;

  ProductCategory({this.id, this.title, this.mapKey, this.days});

  ProductCategory.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    mapKey = json['map_key'];
    days = json['days'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['map_key'] = mapKey;
    data['days'] = days;
    return data;
  }
}

class Season {
  int? id;
  String? title;
  String? mapKey;

  Season({this.id, this.title, this.mapKey});

  Season.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    mapKey = json['map_key'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['map_key'] = mapKey;
    return data;
  }
}

class ProductPayment {
  String? id;
  String? title;

  ProductPayment({this.id, this.title});

  ProductPayment.fromJson(Map<String, dynamic> json) {
    id = json['id'].toString();
    title = json['title'].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    return data;
  }
}

class TradeStatusList {
  int? id;
  String? title;
  String? mapKey;
  String? txtColor;

  TradeStatusList({this.id, this.title, this.mapKey, this.txtColor});

  TradeStatusList.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    mapKey = json['map_key'];
    txtColor = json['txt_color'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['map_key'] = mapKey;
    data['txt_color'] = txtColor;
    return data;
  }
}

class UserType {
  int? id;
  String? title;
  String? mapKey;

  UserType({this.id, this.title, this.mapKey});

  UserType.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    mapKey = json['map_key'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['map_key'] = mapKey;
    return data;
  }
}
