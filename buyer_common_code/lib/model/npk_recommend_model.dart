class NPKRecommend {
  int? success;
  Data? data;
  int? error;
  int? status;
  String? message;

  NPKRecommend({this.success, this.data, this.error, this.status,this.message});

  NPKRecommend.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
    error = json['error'];
    status = json['status'];
    message=json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['success'] = success;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    data['error'] = error;
    data['status'] = status;
    data['message'] = message;
    return data;
  }
}

class Data {
  NpkStatus? npkStatus;
  NpkHectare? npkHectare;
  NpkHectare? npkAcer;

  Data({this.npkStatus, this.npkHectare, this.npkAcer});

  Data.fromJson(Map<String, dynamic> json) {
    npkStatus = json['npk_status'] != null
        ? NpkStatus.fromJson(json['npk_status'])
        : null;
    npkHectare = json['npk_hectare'] != null
        ? NpkHectare.fromJson(json['npk_hectare'])
        : null;
    npkAcer =
        json['npk_acer'] != null ? NpkHectare.fromJson(json['npk_acer']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (npkStatus != null) {
      data['npk_status'] = npkStatus!.toJson();
    }
    if (npkHectare != null) {
      data['npk_hectare'] = npkHectare!.toJson();
    }
    if (npkAcer != null) {
      data['npk_acer'] = npkAcer!.toJson();
    }
    return data;
  }
}

class NpkStatus {
  String? n;
  String? p;
  String? k;
  String? s;

  NpkStatus({this.n, this.p, this.k, this.s});

  NpkStatus.fromJson(Map<String, dynamic> json) {
    n = json['n'];
    p = json['p'];
    k = json['k'];
    s = json['s'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['n'] = n;
    data['p'] = p;
    data['k'] = k;
    data['s'] = s;
    return data;
  }
}

class NpkHectare {
  dynamic n;
  dynamic p;
  dynamic k;
  dynamic s;

  NpkHectare({this.n, this.p, this.k, this.s});

  NpkHectare.fromJson(Map<String, dynamic> json) {
    n = json['n'];
    p = json['p'];
    k = json['k'];
    s = json['s'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['n'] = n;
    data['p'] = p;
    data['k'] = k;
    data['s'] = s;
    return data;
  }
}
