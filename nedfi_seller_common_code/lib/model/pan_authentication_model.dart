class PanAuthentication {
  String? success;
  String? error;
  String? status;
  Data? data;
  String? message;

  PanAuthentication({this.success, this.error, this.status, this.data, this.message});

  PanAuthentication.fromJson(Map<String, dynamic> json) {
    success = json['success'].toString();
    error = json['error'].toString();
    status = json['status'].toString();
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
    requestId = json['request_id'].toString();
    taskId = json['task_id'].toString();
    groupId = json['group_id'].toString();
    success = json['success'];
    responseCode = json['response_code'].toString();
    responseMessage = json['response_message'].toString();
    metadata = json['metadata'] != null ? Metadata.fromJson(json['metadata']) : null;
    result = json['result'] != null ? Result.fromJson(json['result']) : null;
    requestTimestamp = json['request_timestamp'].toString();
    responseTimestamp = json['response_timestamp'].toString();
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

  Metadata({this.billable});

  Metadata.fromJson(Map<String, dynamic> json) {
    billable = json['billable'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['billable'] = billable;
    return data;
  }
}

class Result {
  String? panNumber;
  String? panStatus;
  String? userFullName;
  String? panType;

  Result({this.panNumber, this.panStatus, this.userFullName, this.panType});

  Result.fromJson(Map<String, dynamic> json) {
    panNumber = json['pan_number'].toString();
    panStatus = json['pan_status'].toString();
    userFullName = json['user_full_name'].toString();
    panType = json['pan_type'].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['pan_number'] = panNumber;
    data['pan_status'] = panStatus;
    data['user_full_name'] = userFullName;
    data['pan_type'] = panType;
    return data;
  }
}
