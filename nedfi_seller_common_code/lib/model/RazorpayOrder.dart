class RazorpayOrder {
  RazorpayOrder({
    required this.success,
    required this.data,
    required this.msg,
    required this.error,
    required this.status,
  });
  late final String success;
  late final RazorpayOrderData data;
  late final String msg;
  late final String error;
  late final String status;

  RazorpayOrder.fromJson(Map<String, dynamic> json){
    success = json['success'].toString();
    data = RazorpayOrderData.fromJson(json['data']);
    msg = json['msg'].toString();
    error = json['error'].toString();
    status = json['status'].toString();
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['success'] = success;
    _data['data'] = data.toJson();
    _data['msg'] = msg;
    _data['error'] = error;
    _data['status'] = status;
    return _data;
  }
}

class RazorpayOrderData {
  RazorpayOrderData({
    required this.id,
    required this.status,
    required this.createdAt,
    required this.orderId,
  });
  late final String id;
  late final String status;
  late final String createdAt;
  late final String orderId;

  RazorpayOrderData.fromJson(Map<String, dynamic> json){
    id = json['id'].toString();
    status = json['status'].toString();
    createdAt = json['created_at'].toString();
    orderId = json['order_id'].toString();
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['status'] = status;
    _data['created_at'] = createdAt;
    _data['order_id'] = orderId;
    return _data;
  }
}