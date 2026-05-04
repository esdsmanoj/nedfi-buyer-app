class DomainResopnse {
  DomainResopnse({required this.status, required this.error, required this.data, required this.msg, required this.apiBasePath});

  late final int status;
  late final int error;
  late final DomainData data;
  late final String msg;
  late final String apiBasePath;

  DomainResopnse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    error = json['error'];
    if (json['data'] != null) {
      data = DomainData.fromJson(json['data']);
    }
    msg = json['msg'];
    apiBasePath = json['api_base_path'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['status'] = status;
    _data['error'] = error;
    _data['data'] = data.toJson();
    _data['msg'] = msg;
    _data['api_base_path'] = apiBasePath;
    return _data;
  }
}

class DomainData {
  DomainData({required this.id, required this.appname, required this.urlPath, required this.title, required this.domain, required this.xAPIKey});

  late final String id;
  late final String appname;
  late final String urlPath;
  String? title;
  late final String domain;
  late final String xAPIKey;

  DomainData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    appname = json['appname'];
    urlPath = json['url_path'];
    title = json['title'] ?? "";
    domain = json['domain'];
    xAPIKey = json['x_api_key'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['appname'] = appname;
    _data['url_path'] = urlPath;
    _data['title'] = title;
    _data['domain'] = domain;
    _data['x_api_key'] = xAPIKey;
    return _data;
  }
}
