import 'package:nedfi_seller_common_code/model/ProductResponse.dart';

class MarketProductResponse {
  MarketProductResponse({required this.status, required this.data, required this.message});

  late final int status;
  late final List<ProductsList> data;
  List<OrderData>? orderData;
  late final String message;

  MarketProductResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['data'] != null) {
      data = List.from(json['data']).map((e) => ProductsList.fromJson(e)).toList();
    }
    if (json['order_data'] != null) {
      orderData = <OrderData>[];
      json['order_data'].forEach((v) {
        orderData!.add(OrderData.fromJson(v));
      });
    }
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['status'] = status;
    _data['data'] = data.map((e) => e.toJson()).toList();
    _data['order_data'] = orderData!.map((v) => v.toJson()).toList();
    _data['message'] = message;
    return _data;
  }
}

class MarketProductData {
  MarketProductData(
      {required this.id,
      required this.partner_id,
      required this.category_id,
      required this.product_name,
      required this.version,
      required this.logo,
      required this.type,
      required this.product_type,
      required this.price,
      required this.qty,
      required this.cartFlag});

  late final String id;
  late final String partner_id;
  late final String category_id;
  late final String product_name;
  late final String version;
  late final String logo;
  late final String type;
  late final String product_type;
  late final String price;
  String? qty = "1";
  bool cartFlag = true;
  static final columns = ["id", "partner_id", "category_id", "version", "logo", 'type', 'product_type', 'price', 'product_name', 'qty'];

  MarketProductData.fromJson(Map<String, dynamic> json) {
    id = json['id'].toString();
    partner_id = json['partner_id'];
    category_id = json['category_id'];
    version = json['version'] ?? "";
    logo = json['logo'];
    type = json['type'] ?? "";
    product_type = json['product_type'] ?? "";
    price = json['price'];
    product_name = json['product_name'];
    qty = json['qty'] ?? "1";
    cartFlag = json['cartFlag'] ?? false;
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['partner_id'] = partner_id;
    _data['category_id'] = category_id;
    _data['version'] = version;
    _data['logo'] = logo;
    _data['type'] = type;
    _data['product_type'] = product_type;
    _data['price'] = price;
    _data['product_name'] = product_name;
    _data['qty'] = qty;
    _data['cartFlag'] = cartFlag;
    return _data;
  }
}

class OrderData {
  String? id;
  String? clientId;
  String? invoiceId;
  String? orderNum;
  String? planId;
  String? qty;
  dynamic planDetails;
  String? orderDate;
  dynamic nextInvoiceDate;
  String? status;
  dynamic createdById;
  String? createdOn;
  String? updatedById;
  String? updatedOn;
  dynamic deletedById;
  String? isDeleted;
  dynamic deletedOn;
  dynamic minFrequency;
  dynamic orderCompletionDate;
  dynamic ipaddress;
  dynamic promoCode;
  dynamic promoType;
  dynamic promoValue;
  dynamic remark;
  String? billingAddress1;
  String? billingCity;
  String? billingPinCode;
  dynamic shippingAddress1;
  dynamic shippingCity;
  dynamic shippingState;
  dynamic shippingPinCode;
  String? firstName;
  String? lastName;
  String? companyName;
  String? emailId;
  String? billingVillage;
  String? cphone;
  dynamic billingCountry;
  dynamic shippingCountry;
  String? billingState;
  dynamic paymentMethod;
  String? amount;
  dynamic invoiceNumber;
  dynamic invoiceFile;
  String? paidAmount;
  String? isNotificationSent;
  String? partnerId;
  String? pickupLocationId;
  dynamic paymentStatus;
  dynamic deliveryCharges;
  String? payment_status;


  OrderData(
      {this.id,
      this.clientId,
      this.invoiceId,
      this.orderNum,
      this.planId,
      this.qty,
      this.planDetails,
      this.orderDate,
      this.nextInvoiceDate,
      this.status,
      this.createdById,
      this.createdOn,
      this.updatedById,
      this.updatedOn,
      this.deletedById,
      this.isDeleted,
      this.deletedOn,
      this.minFrequency,
      this.orderCompletionDate,
      this.ipaddress,
      this.promoCode,
      this.promoType,
      this.promoValue,
      this.remark,
      this.billingAddress1,
      this.billingCity,
      this.billingPinCode,
      this.shippingAddress1,
      this.shippingCity,
      this.shippingState,
      this.shippingPinCode,
      this.firstName,
      this.lastName,
      this.companyName,
      this.emailId,
      this.billingVillage,
      this.cphone,
      this.billingCountry,
      this.shippingCountry,
      this.billingState,
      this.paymentMethod,
      this.amount,
      this.invoiceNumber,
      this.invoiceFile,
      this.paidAmount,
      this.isNotificationSent,
      this.partnerId,
      this.pickupLocationId,
      this.paymentStatus,
      this.deliveryCharges,this.payment_status});

  OrderData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    clientId = json['client_id'];
    invoiceId = json['invoice_id'];
    orderNum = json['order_num'];
    planId = json['plan_id'];
    qty = json['qty'];
    planDetails = json['plan_details'];
    orderDate = json['order_date'];
    nextInvoiceDate = json['next_invoice_date'];
    status = json['status'];
    createdById = json['created_by_id'];
    createdOn = json['created_on'];
    updatedById = json['updated_by_id'];
    updatedOn = json['updated_on'];
    deletedById = json['deleted_by_id'];
    isDeleted = json['is_deleted'];
    deletedOn = json['deleted_on'];
    minFrequency = json['min_frequency'];
    orderCompletionDate = json['order_completion_date'];
    ipaddress = json['ipaddress'];
    promoCode = json['promo_code'];
    promoType = json['promo_type'];
    promoValue = json['promo_value'];
    remark = json['remark'];
    billingAddress1 = json['billing_address1'];
    billingCity = json['billing_city'];
    billingPinCode = json['billing_pin_code'];
    shippingAddress1 = json['shipping_address1'];
    shippingCity = json['shipping_city'];
    shippingState = json['shipping_state'];
    shippingPinCode = json['shipping_pin_code'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    companyName = json['company_name'];
    emailId = json['email_id'];
    billingVillage = json['billing_village'];
    cphone = json['cphone'];
    billingCountry = json['billing_country'];
    shippingCountry = json['shipping_country'];
    billingState = json['billing_state'];
    paymentMethod = json['payment_method'];
    amount = json['amount'];
    invoiceNumber = json['invoice_number'];
    invoiceFile = json['invoice_file'];
    paidAmount = json['paid_amount'];
    isNotificationSent = json['is_notification_sent'];
    partnerId = json['partner_id'];
    pickupLocationId = json['pickup_location_id'];
    paymentStatus = json['payment_status'];
    deliveryCharges = json['delivery_charges'];
    payment_status=json['payment_status']??"";
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = id;
    data['client_id'] = clientId;
    data['invoice_id'] = invoiceId;
    data['order_num'] = orderNum;
    data['plan_id'] = planId;
    data['qty'] = qty;
    data['plan_details'] = planDetails;
    data['order_date'] = orderDate;
    data['next_invoice_date'] = nextInvoiceDate;
    data['status'] = status;
    data['created_by_id'] = createdById;
    data['created_on'] = createdOn;
    data['updated_by_id'] = updatedById;
    data['updated_on'] = updatedOn;
    data['deleted_by_id'] = deletedById;
    data['is_deleted'] = isDeleted;
    data['deleted_on'] = deletedOn;
    data['min_frequency'] = minFrequency;
    data['order_completion_date'] = orderCompletionDate;
    data['ipaddress'] = ipaddress;
    data['promo_code'] = promoCode;
    data['promo_type'] = promoType;
    data['promo_value'] = promoValue;
    data['remark'] = remark;
    data['billing_address1'] = billingAddress1;
    data['billing_city'] = billingCity;
    data['billing_pin_code'] = billingPinCode;
    data['shipping_address1'] = shippingAddress1;
    data['shipping_city'] = shippingCity;
    data['shipping_state'] = shippingState;
    data['shipping_pin_code'] = shippingPinCode;
    data['first_name'] = firstName;
    data['last_name'] = lastName;
    data['company_name'] = companyName;
    data['email_id'] = emailId;
    data['billing_village'] = billingVillage;
    data['cphone'] = cphone;
    data['billing_country'] = billingCountry;
    data['shipping_country'] = shippingCountry;
    data['billing_state'] = billingState;
    data['payment_method'] = paymentMethod;
    data['amount'] = amount;
    data['invoice_number'] = invoiceNumber;
    data['invoice_file'] = invoiceFile;
    data['paid_amount'] = paidAmount;
    data['is_notification_sent'] = isNotificationSent;
    data['partner_id'] = partnerId;
    data['pickup_location_id'] = pickupLocationId;
    data['payment_status'] = paymentStatus;
    data['delivery_charges'] = deliveryCharges;
    data['payment_status']=payment_status;
    return data;
  }
}
