class PaymentGateway {
  PaymentGateway({
    required this.success,
    required this.error,
    required this.status,
    required this.data,
    required this.message,
  });
  late final String success;
  late final String error;
  late final String status;
  late final PaymentGatewayData data;
  late final String message;

  PaymentGateway.fromJson(Map<String, dynamic> json){
    success = json['success'].toString();
    error = json['error'].toString();
    status = json['status'].toString();
    data = PaymentGatewayData.fromJson(json['data']);
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['success'] = success;
    _data['error'] = error;
    _data['status'] = status;
    _data['data'] = data.toJson();
    _data['message'] = message;
    return _data;
  }
}

class PaymentGatewayData {
  PaymentGatewayData({
    required this.id,
    required this.title,
    required this.mode,
    required this.merchantKey,
    required this.merchantId,
    required this.secretKey,
    required this.otherKey,
  });
  late final String id;
  late final String title;
  late final String mode;
  late final String merchantKey;
  late final String merchantId;
  late final String secretKey;
  late final String otherKey;

  PaymentGatewayData.fromJson(Map<String, dynamic> json){
    id = json['id'].toString();
    title = json['title'].toString();
    mode = json['mode'].toString();
    merchantKey = json['merchant_key'].toString();
    merchantId = json['merchant_id'].toString();
    secretKey = json['secret_key'].toString();
    otherKey = json['other_key'].toString();
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['title'] = title;
    _data['mode'] = mode;
    _data['merchant_key'] = merchantKey;
    _data['merchant_id'] = merchantId;
    _data['secret_key'] = secretKey;
    _data['other_key'] = otherKey;
    return _data;
  }
}