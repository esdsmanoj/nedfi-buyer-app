class TradeIncentive {
  int? success;
  List<IncentiveData>? data;
  String? message;

  TradeIncentive({this.success, this.data, this.message});

  TradeIncentive.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    if (json['data'] != null) {
      data = <IncentiveData>[];
      json['data'].forEach((v) {
        data!.add(new IncentiveData.fromJson(v));
      });
    }
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['success'] = success;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['message'] = message;
    return data;
  }
}

class IncentiveData {
  String? serviceId;
  String? partnerId;
  dynamic categoryId;
  String? productServicesName;
  dynamic productServicesNameMr;
  String? overview;
  String? brief;
  dynamic highlight;
  dynamic usage;
  dynamic support;
  String? logo;
  dynamic demoUrl;
  String? createdById;
  String? createdOn;
  String? updatedById;
  String? updatedOn;
  String? isDeleted;
  dynamic deletedById;
  dynamic deletedOn;
  dynamic serviceType;
  dynamic productServicesOffered;
  String? status;
  String? isActive;
  dynamic isFeatured;
  dynamic isHome;
  dynamic isSlider;
  String? price;
  String? packageNote;
  String? allowIncentive;
  dynamic state;
  dynamic city;
  String? panIndiaOffering;

  IncentiveData(
      {this.serviceId,
        this.partnerId,
        this.categoryId,
        this.productServicesName,
        this.productServicesNameMr,
        this.overview,
        this.brief,
        this.highlight,
        this.usage,
        this.support,
        this.logo,
        this.demoUrl,
        this.createdById,
        this.createdOn,
        this.updatedById,
        this.updatedOn,
        this.isDeleted,
        this.deletedById,
        this.deletedOn,
        this.serviceType,
        this.productServicesOffered,
        this.status,
        this.isActive,
        this.isFeatured,
        this.isHome,
        this.isSlider,
        this.price,
        this.packageNote,
        this.allowIncentive,
        this.state,
        this.city,
        this.panIndiaOffering});

  IncentiveData.fromJson(Map<String, dynamic> json) {
    serviceId = json['service_id'];
    partnerId = json['partner_id'];
    categoryId = json['category_id'];
    productServicesName = json['product_services_name'];
    productServicesNameMr = json['product_services_name_mr'];
    overview = json['overview'];
    brief = json['brief'];
    highlight = json['highlight'];
    usage = json['usage'];
    support = json['support'];
    logo = json['logo'];
    demoUrl = json['demo_url'];
    createdById = json['created_by_id'];
    createdOn = json['created_on'];
    updatedById = json['updated_by_id'];
    updatedOn = json['updated_on'];
    isDeleted = json['is_deleted'];
    deletedById = json['deleted_by_id'];
    deletedOn = json['deleted_on'];
    serviceType = json['service_type'];
    productServicesOffered = json['product_services_offered'];
    status = json['status'];
    isActive = json['is_active'];
    isFeatured = json['is_featured'];
    isHome = json['is_home'];
    isSlider = json['is_slider'];
    price = json['price'];
    packageNote = json['package_note'];
    allowIncentive = json['allow_incentive'];
    state = json['state'];
    city = json['city'];
    panIndiaOffering = json['pan_india_offering'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['service_id'] = serviceId;
    data['partner_id'] = partnerId;
    data['category_id'] = categoryId;
    data['product_services_name'] = productServicesName;
    data['product_services_name_mr'] = productServicesNameMr;
    data['overview'] = overview;
    data['brief'] = brief;
    data['highlight'] = highlight;
    data['usage'] = usage;
    data['support'] = support;
    data['logo'] = logo;
    data['demo_url'] = demoUrl;
    data['created_by_id'] = createdById;
    data['created_on'] = createdOn;
    data['updated_by_id'] = updatedById;
    data['updated_on'] = updatedOn;
    data['is_deleted'] = isDeleted;
    data['deleted_by_id'] = deletedById;
    data['deleted_on'] = deletedOn;
    data['service_type'] = serviceType;
    data['product_services_offered'] = productServicesOffered;
    data['status'] = status;
    data['is_active'] = isActive;
    data['is_featured'] = isFeatured;
    data['is_home'] = isHome;
    data['is_slider'] = isSlider;
    data['price'] = price;
    data['package_note'] = packageNote;
    data['allow_incentive'] = allowIncentive;
    data['state'] = state;
    data['city'] = city;
    data['pan_india_offering'] = panIndiaOffering;
    return data;
  }
}
