class MyStat {
  String? success;
  List<MyStatData>? data;
  String? message;

  MyStat({this.success, this.data, this.message});

  MyStat.fromJson(Map<String, dynamic> json) {
    success = json['success'].toString();
    if (json['data'] != null) {
      data = <MyStatData>[];
      json['data'].forEach((v) {
        data!.add( MyStatData.fromJson(v));
      });
    }
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data =  Map<String, dynamic>();
    data['success'] = this.success;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['message'] = this.message;
    return data;
  }
}

class MyStatData {
  String? status;
  String? rowCount;
  String? prodCatId;
  String? statusTitle;
  String? statusClass;

  MyStatData(
      {this.status,
        this.rowCount,
        this.prodCatId,
        this.statusTitle,
        this.statusClass});

  MyStatData.fromJson(Map<String, dynamic> json) {
    status = json['status'].toString();
    rowCount = json['row_count'].toString();
    prodCatId = json['prod_cat_id'].toString();
    statusTitle = json['status_title'].toString();
    statusClass = json['status_class'].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['row_count'] = this.rowCount;
    data['prod_cat_id'] = this.prodCatId;
    data['status_title'] = this.statusTitle;
    data['status_class'] = this.statusClass;
    return data;
  }
}