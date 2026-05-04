class VerificationAadhaar {
  int? success;
  int? error;
  int? status;
  Data? data;
  String? message;

  VerificationAadhaar({this.success, this.error, this.status, this.data, this.message});

  VerificationAadhaar.fromJson(Map<String, dynamic> json) {
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
  dynamic result;
  Metadata? metadata;
  String? requestTimestamp;
  String? responseTimestamp;

  Data({this.requestId, this.taskId, this.groupId, this.success, this.responseCode, this.responseMessage, this.result, this.metadata, this.requestTimestamp, this.responseTimestamp});

  Data.fromJson(Map<String, dynamic> json) {
    requestId = json['request_id'];
    taskId = json['task_id'];
    groupId = json['group_id'];
    success = json['success'];
    responseCode = json['response_code'];
    responseMessage = json['response_message'];
    result = json['result'];
    metadata = json['metadata'] != null ? Metadata.fromJson(json['metadata']) : null;
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
    data['result'] = result;
    if (metadata != null) {
      data['metadata'] = metadata!.toJson();
    }
    data['request_timestamp'] = requestTimestamp;
    data['response_timestamp'] = responseTimestamp;
    return data;
  }
}

class Metadata {
  String? billable;
  String? reasonMessage;

  Metadata({this.billable, this.reasonMessage});

  Metadata.fromJson(Map<String, dynamic> json) {
    billable = json['billable'];
    reasonMessage = json['reason_message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['billable'] = billable;
    data['reason_message'] = reasonMessage;
    return data;
  }
}
