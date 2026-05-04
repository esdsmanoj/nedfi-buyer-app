class BankVerification {
  int? success;
  int? error;
  int? status;
  Data? data;
  String? message;

  BankVerification({this.success, this.error, this.status, this.data, this.message});

  BankVerification.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    error = json['error'];
    status = json['status'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['success'] = success;
    data['error'] = error;
    data['status'] = status;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    data['message'] = message;
    return data;
  }
}

class Data {
  String? requestId;
  String? taskId;
  String? groupId;
  bool? success;
  String? responseCode;
  String? responseMessage;
  Metadata? metadata;
  Result? result;
  String? requestTimestamp;
  String? responseTimestamp;

  Data({this.requestId, this.taskId, this.groupId, this.success, this.responseCode, this.responseMessage, this.metadata, this.result, this.requestTimestamp, this.responseTimestamp});

  Data.fromJson(Map<String, dynamic> json) {
    requestId = json['request_id'];
    taskId = json['task_id'];
    groupId = json['group_id'];
    success = json['success'];
    responseCode = json['response_code'];
    responseMessage = json['response_message'];
    metadata = json['metadata'] != null ? Metadata.fromJson(json['metadata']) : null;
    result = json['result'] != null ? Result.fromJson(json['result']) : null;
    requestTimestamp = json['request_timestamp'];
    responseTimestamp = json['response_timestamp'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['request_id'] = requestId;
    data['task_id'] = taskId;
    data['group_id'] = groupId;
    data['success'] = success;
    data['response_code'] = responseCode;
    data['response_message'] = responseMessage;
    if (metadata != null) {
      data['metadata'] = metadata!.toJson();
    }
    if (result != null) {
      data['result'] = result!.toJson();
    }
    data['request_timestamp'] = requestTimestamp;
    data['response_timestamp'] = responseTimestamp;
    return data;
  }
}

class Metadata {
  String? billable;
  String? reasonCode;
  String? reasonMessage;

  Metadata({this.billable, this.reasonCode, this.reasonMessage});

  Metadata.fromJson(Map<String, dynamic> json) {
    billable = json['billable'];
    reasonCode = json['reason_code'];
    reasonMessage = json['reason_message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['billable'] = billable;
    data['reason_code'] = reasonCode;
    data['reason_message'] = reasonMessage;
    return data;
  }
}

class Result {
  String? bankRefNo;
  String? beneficiaryName;
  String? transactionRemark;
  String? verificationStatus;

  Result({this.bankRefNo, this.beneficiaryName, this.transactionRemark, this.verificationStatus});

  Result.fromJson(Map<String, dynamic> json) {
    bankRefNo = json['bank_ref_no'];
    beneficiaryName = json['beneficiary_name'];
    transactionRemark = json['transaction_remark'];
    verificationStatus = json['verification_status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['bank_ref_no'] = bankRefNo;
    data['beneficiary_name'] = beneficiaryName;
    data['transaction_remark'] = transactionRemark;
    data['verification_status'] = verificationStatus;
    return data;
  }
}
