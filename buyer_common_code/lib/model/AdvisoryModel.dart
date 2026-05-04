class AdvisoryModel {
  int? status;
  List<AdvisoryData>? data;
  String? message;

  AdvisoryModel({this.status, this.data, this.message});

  AdvisoryModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['data'] != null) {
      data = <AdvisoryData>[];
      json['data'].forEach((v) {
        data!.add(AdvisoryData.fromJson(v));
      });
    }
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['message'] = message;
    return data;
  }
}

class AdvisoryData {
  String? id;
  String? clientId;
  String? partnerId;
  String? callScheduleDate;
  String? callScheduleTime;
  String? scheduleCallStatus;
  dynamic callRescheduleDate;
  dynamic callRescheduleTime;
  String? firstName;
  String? lastName;
  String? companyName;
  String? phoneNo;
  String? city;
  String? profileImage;
  String? cropId;
  String? userType;
  String? type;
  String? isVideoEnable;
  String? isChatEnable;
  String? expertise;
  String? userExperiance;
  String? rating;
  String? name;
  String? nameMr;
  dynamic callDuration;
  String? callStatus;
  String? price;

  AdvisoryData(
      {this.id,
      this.clientId,
      this.partnerId,
      this.callScheduleDate,
      this.callScheduleTime,
      this.scheduleCallStatus,
      this.callRescheduleDate,
      this.callRescheduleTime,
      this.firstName,
      this.lastName,
      this.companyName,
      this.phoneNo,
      this.city,
      this.profileImage,
      this.cropId,
      this.userType,
      this.type,
      this.isVideoEnable,
      this.isChatEnable,
      this.expertise,
      this.userExperiance,
      this.rating,
      this.name,
      this.nameMr,
      this.callDuration,
      this.callStatus,
      this.price});

  AdvisoryData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    clientId = json['client_id'];
    partnerId = json['partner_id'];
    callScheduleDate = json['call_schedule_date'];
    callScheduleTime = json['call_schedule_time'];
    scheduleCallStatus = json['schedule_call_status'];
    callRescheduleDate = json['call_reschedule_date'];
    callRescheduleTime = json['call_reschedule_time'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    companyName = json['company_name'];
    phoneNo = json['phone_no'];
    city = json['city'];
    profileImage = json['profile_image'];
    cropId = json['crop_id'];
    userType = json['user_type'];
    type = json['type'];
    isVideoEnable = json['is_video_enable'];
    isChatEnable = json['is_chat_enable'];
    expertise = json['expertise'];
    userExperiance = json['user_experiance'];
    rating = json['rating'];
    name = json['name'];
    nameMr = json['name_mr'];
    callDuration = json['call_duration'];
    callStatus = json['call_status'];
    price = json['price'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['client_id'] = clientId;
    data['partner_id'] = partnerId;
    data['call_schedule_date'] = callScheduleDate;
    data['call_schedule_time'] = callScheduleTime;
    data['schedule_call_status'] = scheduleCallStatus;
    data['call_reschedule_date'] = callRescheduleDate;
    data['call_reschedule_time'] = callRescheduleTime;
    data['first_name'] = firstName;
    data['last_name'] = lastName;
    data['company_name'] = companyName;
    data['phone_no'] = phoneNo;
    data['city'] = city;
    data['profile_image'] = profileImage;
    data['crop_id'] = cropId;
    data['user_type'] = userType;
    data['type'] = type;
    data['is_video_enable'] = isVideoEnable;
    data['is_chat_enable'] = isChatEnable;
    data['expertise'] = expertise;
    data['user_experiance'] = userExperiance;
    data['rating'] = rating;
    data['name'] = name;
    data['name_mr'] = nameMr;
    data['call_duration'] = callDuration;
    data['call_status'] = callStatus;
    data['price'] = price;
    return data;
  }
}
