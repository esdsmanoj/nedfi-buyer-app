class PayPhiSuccess {
  String? secureHash;
  String? amount;
  String? respDescription;
  String? paymentMode;
  String? resultCode;
  String? resultType;
  String? responseCode;
  String? paymentSubInstType;
  String? merchantId;
  String? paymentID;
  String? merchantTxnNo;
  String? paymentDateTime;
  String? statusCode;
  String? txnID;

  PayPhiSuccess(
      {this.secureHash,
      this.amount,
      this.respDescription,
      this.paymentMode,
      this.resultCode,
      this.resultType,
      this.responseCode,
      this.paymentSubInstType,
      this.merchantId,
      this.paymentID,
      this.merchantTxnNo,
      this.paymentDateTime,
      this.statusCode,
      this.txnID});

  PayPhiSuccess.fromJson(Map<String, dynamic> json) {
    secureHash = json['secureHash'];
    amount = json['amount'];
    respDescription = json['respDescription'];
    paymentMode = json['paymentMode'];
    resultCode = json['resultCode'];
    resultType = json['ResultType'];
    responseCode = json['responseCode'];
    paymentSubInstType = json['paymentSubInstType'];
    merchantId = json['merchantId'];
    paymentID = json['paymentID'];
    merchantTxnNo = json['merchantTxnNo'];
    paymentDateTime = json['paymentDateTime'];
    statusCode = json['statusCode'];
    txnID = json['txnID'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['secureHash'] = secureHash;
    data['amount'] = amount;
    data['respDescription'] = respDescription;
    data['paymentMode'] = paymentMode;
    data['resultCode'] = resultCode;
    data['ResultType'] = resultType;
    data['responseCode'] = responseCode;
    data['paymentSubInstType'] = paymentSubInstType;
    data['merchantId'] = merchantId;
    data['paymentID'] = paymentID;
    data['merchantTxnNo'] = merchantTxnNo;
    data['paymentDateTime'] = paymentDateTime;
    data['statusCode'] = statusCode;
    data['txnID'] = txnID;
    return data;
  }
}
