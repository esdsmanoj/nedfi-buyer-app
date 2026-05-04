class SeasonModel {
  int? success;
  int? error;
  int? status;
  List<SeasonData>? data;

  SeasonModel({this.success, this.error, this.status, this.data});

  SeasonModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    error = json['error'];
    status = json['status'];
    if (json['data'] != null) {
      data = <SeasonData>[];
      json['data'].forEach((v) {
        data!.add(SeasonData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['success'] = success;
    data['error'] = error;
    data['status'] = status;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class SeasonData {
  String? id;
  String? value;
 dynamic n;
 dynamic p;
 dynamic k;
 dynamic s;

  SeasonData({this.id, this.value, this.n, this.p, this.k, this.s});

  SeasonData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    value = json['value'];
    n = json['n'];
    p = json['p'];
    k = json['k'];
    s = json['s'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['value'] = value;
    data['n'] = n;
    data['p'] = p;
    data['k'] = k;
    data['s'] = s;
    return data;
  }
}
