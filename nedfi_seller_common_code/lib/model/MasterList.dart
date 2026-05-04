class MasterList {
  int? success;
  MasterData? data;
  String? message;

  MasterList({this.success, this.data, this.message});

  MasterList.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    data = json['data'] != null ? new MasterData.fromJson(json['data']) : null;
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    data['message'] = this.message;
    return data;
  }
}

class MasterData {
  List<ProductCategory>? productCategory;
  List<Season>? season;
  List<TradeStatusList>? productUnit;
  List<ProductPayment>? productPayment;
  List<TradeStatusList>? tradeStatusList;
  List<TradeStatusList>? userType;
  List<TradeStatusList>? businessType;

  MasterData(
      {this.productCategory,
        this.season,
        this.productUnit,
        this.productPayment,
        this.tradeStatusList,
        this.userType,
        this.businessType});

  MasterData.fromJson(Map<String, dynamic> json) {
    if (json['product_category'] != null) {
      productCategory = <ProductCategory>[];
      json['product_category'].forEach((v) {
        productCategory!.add(new ProductCategory.fromJson(v));
      });
    }
    if (json['season'] != null) {
      season = <Season>[];
      json['season'].forEach((v) {
        season!.add(new Season.fromJson(v));
      });
    }
    if (json['product_unit'] != null) {
      productUnit = <TradeStatusList>[];
      json['product_unit'].forEach((v) {
        productUnit!.add(new TradeStatusList.fromJson(v));
      });
    }
    if (json['product_payment'] != null) {
      productPayment = <ProductPayment>[];
      json['product_payment'].forEach((v) {
        productPayment!.add(new ProductPayment.fromJson(v));
      });
    }
    if (json['trade_status_list'] != null) {
      tradeStatusList = <TradeStatusList>[];
      json['trade_status_list'].forEach((v) {
        tradeStatusList!.add(new TradeStatusList.fromJson(v));
      });
    }
    if (json['user_type'] != null) {
      userType = <TradeStatusList>[];
      json['user_type'].forEach((v) {
        userType!.add(new TradeStatusList.fromJson(v));
      });
    }
    if (json['business_type'] != null) {
      businessType = <TradeStatusList>[];
      json['business_type'].forEach((v) {
        businessType!.add(new TradeStatusList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.productCategory != null) {
      data['product_category'] =
          this.productCategory!.map((v) => v.toJson()).toList();
    }
    if (this.season != null) {
      data['season'] = this.season!.map((v) => v.toJson()).toList();
    }
    if (this.productUnit != null) {
      data['product_unit'] = this.productUnit!.map((v) => v.toJson()).toList();
    }
    if (this.productPayment != null) {
      data['product_payment'] =
          this.productPayment!.map((v) => v.toJson()).toList();
    }
    if (this.tradeStatusList != null) {
      data['trade_status_list'] =
          this.tradeStatusList!.map((v) => v.toJson()).toList();
    }
    if (this.userType != null) {
      data['user_type'] = this.userType!.map((v) => v.toJson()).toList();
    }
    if (this.businessType != null) {
      data['business_type'] =
          this.businessType!.map((v) => v.toJson()).toList();
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
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['map_key'] = this.mapKey;
    data['days'] = this.days;
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
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['map_key'] = this.mapKey;
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
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
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
    txtColor = json['txt_color']??"";
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['map_key'] = this.mapKey;
    data['txt_color'] = this.txtColor;
    return data;
  }
}