class MyOrderResponse {
  MyOrderResponse({
    required this.status,
    required this.data,
    required this.message,
  });
  late final int status;
  late final List<MyOrderData> data;
  late final String message;

  MyOrderResponse.fromJson(Map<String, dynamic> json){
    status = json['status'];
    if(json['data']!=null) {
      data = List.from(json['data']).map((e) => MyOrderData.fromJson(e)).toList();
    }
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['status'] = status;
    _data['data'] = data.map((e)=>e.toJson()).toList();
    _data['message'] = message;
    return _data;
  }
}

class MyOrderData {
  MyOrderData({
    required this.id,
    required this.clientId,
    this.invoiceId,
    required this.orderNum,
    required this.planId,
    required this.qty,
    this.planDetails,
    required this.orderDate,
    this.nextInvoiceDate,
    required this.status,
    this.createdById,
    required this.createdOn,
    this.updatedById,
    this.updatedOn,
    this.deletedById,
    required this.isDeleted,
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
    this.payment_status,
    this.amount,
  });
  late final String id;
  late final String clientId;
  late final String? invoiceId;
  late final String orderNum;
  late final String planId;
  late final String qty;
  late final String? planDetails;
  late final String orderDate;
  late final String? nextInvoiceDate;
  late final String status;
  late final String? createdById;
  late final String createdOn;
  late final String? updatedById;
  late final String? updatedOn;
  late final String? deletedById;
  late final String isDeleted;
  late final String? deletedOn;
  late final String? minFrequency;
  late final String? orderCompletionDate;
  late final String? ipaddress;
  late final String? promoCode;
  late final String? promoType;
  late final String? promoValue;
  late final String? remark;
  late final String? billingAddress1;
  late final String? billingCity;
  late final String? billingPinCode;
  late final String? shippingAddress1;
  late final String? shippingCity;
  late final String? shippingState;
  late final String? shippingPinCode;
  late final String? firstName;
  late final String? lastName;
  late final String? companyName;
  late final String? emailId;
  late final String? billingVillage;
  late final String? cphone;
  late final String? billingCountry;
  late final String? shippingCountry;
  late final String? billingState;
  late final String? paymentMethod;
  late final String? payment_status;
  late final String? amount;

  MyOrderData.fromJson(Map<String, dynamic> json){
    id = json['id']??"";
    clientId = json['client_id']??"";
    invoiceId = json['invoice_id']??"";
    orderNum = json['order_num']??"";
    planId = json['plan_id']??"";
    qty = json['qty']??"";
    planDetails = json['plan_details']??"";
    orderDate = json['order_date']??"";
    nextInvoiceDate = json['next_invoice_date']??"";
    status = json['status']??"";
    createdById = json['created_by_id']??"";
    createdOn = json['created_on']??"";
    updatedById = json['updated_by_id']??"";
    updatedOn =json['updated_on']??"";
    deletedById = json['deleted_by_id']??"";
    isDeleted = json['is_deleted'];
    deletedOn = json['deleted_on']??"";
    minFrequency = json['min_frequency']??"";
    orderCompletionDate = json['order_completion_date']??"";
    ipaddress = json['ipaddress']??"";
    promoCode = json['promo_code']??"";
    promoType =json['promo_type']??"";
    promoValue =json['promo_value']??"";
    remark =json['remark']??"";
    billingAddress1 = json['billing_address1']??"";
    billingCity = json['billing_city']??"";
    billingPinCode =json['billing_pin_code']??"";
    shippingAddress1 = json['shipping_address1']??"";
    shippingCity = json['shipping_city']??"";
    shippingState = json['shipping_state']??"";
    shippingPinCode = json['shipping_pin_code']??"";
    firstName = json['first_name']??"";
    lastName = json['last_name']??"";
    companyName = json['company_name']??"";
    emailId = json['email_id']??"";
    billingVillage =json['billing_village']??"";
    cphone = json['cphone']??"";
    billingCountry = json['billing_country']??"";
    shippingCountry = json['shipping_country']??"";
    billingState = json['billing_state']??"";
    paymentMethod =  json['payment_method']??"";
    payment_status=json['payment_status']??"";
    amount = json['amount']??"";
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['client_id'] = clientId;
    _data['invoice_id'] = invoiceId;
    _data['order_num'] = orderNum;
    _data['plan_id'] = planId;
    _data['qty'] = qty;
    _data['plan_details'] = planDetails;
    _data['order_date'] = orderDate;
    _data['next_invoice_date'] = nextInvoiceDate;
    _data['status'] = status;
    _data['created_by_id'] = createdById;
    _data['created_on'] = createdOn;
    _data['updated_by_id'] = updatedById;
    _data['updated_on'] = updatedOn;
    _data['deleted_by_id'] = deletedById;
    _data['is_deleted'] = isDeleted;
    _data['deleted_on'] = deletedOn;
    _data['min_frequency'] = minFrequency;
    _data['order_completion_date'] = orderCompletionDate;
    _data['ipaddress'] = ipaddress;
    _data['promo_code'] = promoCode;
    _data['promo_type'] = promoType;
    _data['promo_value'] = promoValue;
    _data['remark'] = remark;
    _data['billing_address1'] = billingAddress1;
    _data['billing_city'] = billingCity;
    _data['billing_pin_code'] = billingPinCode;
    _data['shipping_address1'] = shippingAddress1;
    _data['shipping_city'] = shippingCity;
    _data['shipping_state'] = shippingState;
    _data['shipping_pin_code'] = shippingPinCode;
    _data['first_name'] = firstName;
    _data['last_name'] = lastName;
    _data['company_name'] = companyName;
    _data['email_id'] = emailId;
    _data['billing_village'] = billingVillage;
    _data['cphone'] = cphone;
    _data['billing_country'] = billingCountry;
    _data['shipping_country'] = shippingCountry;
    _data['billing_state'] = billingState;
    _data['payment_method'] = paymentMethod;
    _data['payment_status']=payment_status;
    _data['amount'] = amount;
    return _data;
  }
}