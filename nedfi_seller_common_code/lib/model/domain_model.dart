class DomainModel {
  DomainModel({
    required this.status,
    required this.error,
    required this.data,
    required this.msg,
  });

  late final int status;
  late final int error;
  late final DomainData data;
  late final String msg;

  DomainModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    error = json['error'];
    if (json['data'] != null) {
      data = DomainData.fromJson(json['data']);
    }
    msg = json['msg'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['status'] = status;
    _data['error'] = error;
    _data['data'] = data.toJson();
    _data['msg'] = msg;
    return _data;
  }
}

class DomainData {
  DomainData({
    required this.id,
    required this.appname,
    required this.urlPath,
    required this.title,
    required this.domain,
  });

  late final String id;
  late final String appname;
  late final String urlPath;
  late final String title;
  late final String domain;

  DomainData.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? "";
    appname = json['appname'] ?? "";
    urlPath = json['url_path'] ?? "";
    title = json['title'] ?? "";
    domain = json['domain'] ?? "";
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['appname'] = appname;
    _data['url_path'] = urlPath;
    _data['title'] = title;
    _data['domain'] = domain;
    return _data;
  }
}
