/**
 * @Author: Ajinkya Aher, Bhushan Lambole
 * @Date: 22-12-2023
 */

class NotificationListModel {
  int? success;
  List<NotificationData>? notificationData;
  String? message;

  NotificationListModel({this.success, this.notificationData, this.message});

  NotificationListModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    if (json['notification_data'] != null) {
      notificationData = <NotificationData>[];
      json['notification_data'].forEach((v) {
        notificationData!.add(NotificationData.fromJson(v));
      });
    }
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['success'] = success;
    if (notificationData != null) {
      data['notification_data'] =
          notificationData!.map((v) => v.toJson()).toList();
    }
    data['message'] = message;
    return data;
  }
}

class NotificationData {
  String? userId;
  String? notificationId;
  String? isRead;
  String? title;
  String? message;
  String? createdOn;
  OtherDetails? otherDetails;

  NotificationData(
      {this.userId,
        this.notificationId,
        this.isRead,
        this.title,
        this.message,
        this.createdOn,
        this.otherDetails});

  NotificationData.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    notificationId = json['notification_id'];
    isRead = json['is_read'];
    title = json['title'];
    message = json['message'];
    createdOn = json['created_on'];
    otherDetails = json['other_details'] != null
        ? OtherDetails.fromJson(json['other_details'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['user_id'] = userId;
    data['notification_id'] = notificationId;
    data['is_read'] = isRead;
    data['title'] = title;
    data['message'] = message;
    data['created_on'] = createdOn;
    if (otherDetails != null) {
      data['other_details'] = otherDetails!.toJson();
    }
    return data;
  }
}

class OtherDetails {
  String? type;
  String? mapKey;
  List<String>? userId;
  String? redirectId;
  String? referenceId;

  OtherDetails(
      {this.type, this.mapKey, this.userId, this.redirectId, this.referenceId});

  OtherDetails.fromJson(Map<String, dynamic> json) {
    type = json['type'].toString();
    mapKey = json['map_key'];
    userId = json['user_id'].cast<String>();
    redirectId = json['redirect_id'];
    referenceId = json['reference_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['type'] = type;
    data['map_key'] = mapKey;
    data['user_id'] = userId;
    data['redirect_id'] = redirectId;
    data['reference_id'] = referenceId;
    return data;
  }
}
