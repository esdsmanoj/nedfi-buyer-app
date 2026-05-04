class LanguageModel {
  int? success;
  int? error;
  int? status;
  LanguageData? data;
  String? message;

  LanguageModel({this.success, this.error, this.status, this.data, this.message});

  LanguageModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    error = json['error'];
    status = json['status'];
    data = json['data'] != null ? LanguageData.fromJson(json['data']) : null;
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

class LanguageData {
  List<Lang>? lang;

  LanguageData({this.lang});

  LanguageData.fromJson(Map<String, dynamic> json) {
    if (json['lang'] != null) {
      lang = <Lang>[];
      json['lang'].forEach((v) {
        lang!.add(Lang.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (lang != null) {
      data['lang'] = lang!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Lang {
  String? langKey;
  String? langVal;

  Lang({this.langKey, this.langVal});

  Lang.fromJson(Map<String, dynamic> json) {
    langKey = json['lang_key'];
    langVal = json['lang_val'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['lang_key'] = langKey;
    data['lang_val'] = langVal;
    return data;
  }
}
