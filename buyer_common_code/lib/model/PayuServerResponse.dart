class PayuServerResponse {
  PayuServerResponse({
    required this.paymentHash,
    required this.getMerchantIbiboCodesHash,
    required this.vasForMobileSdkHash,
    required this.emiHash,
    required this.paymentRelatedDetailsForMobileSdkHash,
    required this.verifyPaymentHash,
    required this.sendSmsHash,
  });
  late final String paymentHash;
  late final String getMerchantIbiboCodesHash;
  late final String vasForMobileSdkHash;
  late final String emiHash;
  late final String paymentRelatedDetailsForMobileSdkHash;
  late final String verifyPaymentHash;
  late final String sendSmsHash;

  PayuServerResponse.fromJson(Map<String, dynamic> json){
    paymentHash = json['payment_hash']??"";
    getMerchantIbiboCodesHash = json['get_merchant_ibibo_codes_hash']??"";
    vasForMobileSdkHash = json['vas_for_mobile_sdk_hash']??"";
    emiHash = json['emi_hash']??"";
    paymentRelatedDetailsForMobileSdkHash = json['payment_related_details_for_mobile_sdk_hash']??"";
    verifyPaymentHash = json['verify_payment_hash']??"";
    sendSmsHash = json['send_sms_hash']??"";
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['payment_hash'] = paymentHash;
    _data['get_merchant_ibibo_codes_hash'] = getMerchantIbiboCodesHash;
    _data['vas_for_mobile_sdk_hash'] = vasForMobileSdkHash;
    _data['emi_hash'] = emiHash;
    _data['payment_related_details_for_mobile_sdk_hash'] = paymentRelatedDetailsForMobileSdkHash;
    _data['verify_payment_hash'] = verifyPaymentHash;
    _data['send_sms_hash'] = sendSmsHash;
    return _data;
  }
}