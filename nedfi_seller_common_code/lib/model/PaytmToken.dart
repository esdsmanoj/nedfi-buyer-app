class PaytmToken {
  PaytmToken({
    required this.success,
    required this.data,
    required this.msg,
    required this.error,
    required this.status,
  });
  late final String success;
  late final PaytmTokenData data;
  late final String msg;
  late final String error;
  late final String status;

  PaytmToken.fromJson(Map<String, dynamic> json){
    success = json['success'].toString();
    data = PaytmTokenData.fromJson(json['data']);
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

class PaytmTokenData {
  PaytmTokenData({
    required this.head,
    required this.body,
  });
  late final PaytmTokenHead head;
  late final PaytmTokenBody body;

  PaytmTokenData.fromJson(Map<String, dynamic> json){
    head = PaytmTokenHead.fromJson(json['head']);
    body = PaytmTokenBody.fromJson(json['body']);
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['head'] = head.toJson();
    _data['body'] = body.toJson();
    return _data;
  }
}

class PaytmTokenHead {
  PaytmTokenHead({
    required this.responseTimestamp,
    required this.version,
    required this.signature,
  });
  late final String responseTimestamp;
  late final String version;
  late final String signature;

  PaytmTokenHead.fromJson(Map<String, dynamic> json){
    responseTimestamp = json['responseTimestamp'].toString();
    version = json['version'].toString();
    signature = json['signature'].toString();
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['responseTimestamp'] = responseTimestamp;
    _data['version'] = version;
    _data['signature'] = signature;
    return _data;
  }
}

class PaytmTokenBody {
  PaytmTokenBody({
    required this.resultInfo,
    required this.txnToken,
    required this.isPromoCodeValid,
    required this.authenticated,
  });
  late final ResultInfo resultInfo;
  late final String txnToken;
  late final bool isPromoCodeValid;
  late final bool authenticated;

  PaytmTokenBody.fromJson(Map<String, dynamic> json){
    resultInfo = ResultInfo.fromJson(json['resultInfo']);
    txnToken = json['txnToken'].toString();
    isPromoCodeValid = json['isPromoCodeValid'];
    authenticated = json['authenticated'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['resultInfo'] = resultInfo.toJson();
    _data['txnToken'] = txnToken;
    _data['isPromoCodeValid'] = isPromoCodeValid;
    _data['authenticated'] = authenticated;
    return _data;
  }
}

class ResultInfo {
  ResultInfo({
    required this.resultStatus,
    required this.resultCode,
    required this.resultMsg,
  });
  late final String resultStatus;
  late final String resultCode;
  late final String resultMsg;

  ResultInfo.fromJson(Map<String, dynamic> json){
    resultStatus = json['resultStatus'].toString();
    resultCode = json['resultCode'].toString();
    resultMsg = json['resultMsg'].toString();
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['resultStatus'] = resultStatus;
    _data['resultCode'] = resultCode;
    _data['resultMsg'] = resultMsg;
    return _data;
  }
}