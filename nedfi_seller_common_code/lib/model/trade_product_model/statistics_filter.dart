class StatisticsFilterModel {
  int? success;
  List<StatisticsFilterData>? data;
  String? message;

  StatisticsFilterModel({this.success, this.data, this.message});

  StatisticsFilterModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    if (json['data'] != null) {
      data = <StatisticsFilterData>[];
      json['data'].forEach((v) {
        data!.add(StatisticsFilterData.fromJson(v));
      });
    }
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['success'] = success;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['message'] = message;
    return data;
  }
}

class StatisticsFilterData {
  int? id;
  String? title;
  String? value;

  StatisticsFilterData({this.id, this.title, this.value});

  StatisticsFilterData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    value = json['value'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['value'] = value;
    return data;
  }
}
