class CommonModel {
  CommonModel(
      {required this.success,
      required this.error,
      required this.status,
      required this.message,
      required this.msg,
      required this.optionalNumber,
      this.currentTime,
      this.orderBeforeTime,
      this.pickupMsg,
      this.color,
      this.redirectPaymentGatewayUrl,
      this.orderId});

  late final int success;
  late final int error;
  late final int status;
  late final String message;
  late final String msg;
  late String optionalNumber = "";

  String? currentTime;
  String? orderBeforeTime;
  String? pickupMsg;
  String? color;

  String? redirectPaymentGatewayUrl;
  String? orderId;

  CommonModel.fromJson(Map<String, dynamic> json) {
    success = json['success'] ?? 0;
    error = json['error'] ?? 0;
    status = json['status'] ?? 0;
    if (json['data'] != null) {
// data = json['data'];
    }
    message = json['message'] ?? "";
    msg = json['msg'] ?? "";
    if (json['opt_number'] != null) {
      optionalNumber = json['opt_number'].toString();
    }

    currentTime = json['currnet_time'] ?? "";
    orderBeforeTime = json['order_before_time'] ?? "";
    pickupMsg = json['pickup_msg'] ?? "";
    color = json['color'] ?? "";
    redirectPaymentGatewayUrl = json['redirect_payement_gateway_url'] ?? "";
    orderId = json['order_id'] ?? "";
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['success'] = success;
    _data['error'] = error;
    _data['status'] = status;
// _data['data'] = data;
    _data['message'] = message;
    _data['msg'] = msg;
    _data['opt_number'] = optionalNumber;
    _data['currnet_time'] = currentTime;
    _data['order_before_time'] = orderBeforeTime;
    _data['pickup_msg'] = pickupMsg;
    _data['color'] = color;
    _data['redirect_payement_gateway_url'] = redirectPaymentGatewayUrl;
    _data['order_id'] = orderId;
    return _data;
  }
}
