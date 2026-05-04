class StatisticsReportModel {
  int? success;
  List<StatisticsReportData>? data;
  String? message;

  StatisticsReportModel({this.success, this.data, this.message});

  StatisticsReportModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    if (json['data'] != null) {
      data = <StatisticsReportData>[];
      json['data'].forEach((v) {
        data!.add(StatisticsReportData.fromJson(v));
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

class StatisticsReportData {
  String? status;
  String? rowCount;
  String? statusTitle;
  String? statusClass;

  StatisticsReportData({this.status, this.rowCount, this.statusTitle, this.statusClass});

  StatisticsReportData.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    rowCount = json['row_count'];
    statusTitle = json['status_title'];
    statusClass = json['status_class'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['row_count'] = rowCount;
    data['status_title'] = statusTitle;
    data['status_class'] = statusClass;
    return data;
  }
}
