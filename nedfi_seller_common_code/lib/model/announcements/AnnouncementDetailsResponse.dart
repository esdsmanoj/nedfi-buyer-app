class AnnouncementDetailsResponse {
  int? success;
  int? error;
  int? status;
  AnnouncementDetailData? data;
  String? message;

  AnnouncementDetailsResponse({this.success, this.error, this.status, this.data, this.message});

  AnnouncementDetailsResponse.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    error = json['error'];
    status = json['status'];
    data = json['data'] != null ? AnnouncementDetailData.fromJson(json['data']) : null;
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

class AnnouncementDetailData {
  String? title;
  String? description;
  String? priorityType;
  String? createdOn;
  List<String>? attachedDocument;

  AnnouncementDetailData({this.title, this.description, this.priorityType, this.createdOn, this.attachedDocument});

  AnnouncementDetailData.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    description = json['description'];
    priorityType = json['priority_type'];
    createdOn = json['created_on'];
    attachedDocument = json['attached_document'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['title'] = title;
    data['description'] = description;
    data['priority_type'] = priorityType;
    data['created_on'] = createdOn;
    data['attached_document'] = attachedDocument;
    return data;
  }
}
