class DynamicTheme {
  int? status;
  int? error;
  int? success;
  Data? data;
  String? message;

  DynamicTheme({this.status, this.error, this.success, this.data, this.message});

  DynamicTheme.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    error = json['error'];
    success = json['success'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['error'] = error;
    data['success'] = success;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    data['message'] = message;
    return data;
  }
}

class Data {
  BarColor? barColor;
  BarColor? buttonColor;
  BarColor? iconColor;
  BarColor? textColor;
  BarColor? buttonTextColor;
  BarColor? errorLabelColor;
  BarColor? hintTextColor;
  BarColor? subLabelColor;

  Data({this.barColor, this.buttonColor, this.iconColor, this.textColor, this.buttonTextColor, this.hintTextColor, this.errorLabelColor, this.subLabelColor});

  Data.fromJson(Map<String, dynamic> json) {
    barColor = json['Bar_color'] != null ? BarColor.fromJson(json['Bar_color']) : null;
    buttonColor = json['button_color'] != null ? BarColor.fromJson(json['button_color']) : null;
    iconColor = json['icon_color'] != null ? BarColor.fromJson(json['icon_color']) : null;
    textColor = json['text_color'] != null ? BarColor.fromJson(json['text_color']) : null;
    textColor = json['text_color'] != null ? BarColor.fromJson(json['text_color']) : null;
    subLabelColor = json['sublable_color'] != null ? BarColor.fromJson(json['sublable_color']) : null;
    errorLabelColor = json['Error_label_color'] != null ? BarColor.fromJson(json['Error_label_color']) : null;
    hintTextColor = json['hint_text_color'] != null ? BarColor.fromJson(json['hint_text_color']) : null;
    buttonTextColor = json['button_text_color'] != null ? BarColor.fromJson(json['button_text_color']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (barColor != null) {
      data['Bar_color'] = barColor!.toJson();
    }
    if (buttonColor != null) {
      data['button_color'] = buttonColor!.toJson();
    }
    if (iconColor != null) {
      data['icon_color'] = iconColor!.toJson();
    }
    if (textColor != null) {
      data['text_color'] = textColor!.toJson();
    }
    if (buttonTextColor != null) {
      data['button_text_color'] = buttonTextColor!.toJson();
    }
    if (errorLabelColor != null) {
      data['Error_label_color'] = errorLabelColor!.toJson();
    }
    if (hintTextColor != null) {
      data['hint_text_color'] = hintTextColor!.toJson();
    }
    if (subLabelColor != null) {
      data['sublable_color'] = subLabelColor!.toJson();
    }
    return data;
  }
}

class BarColor {
  String? key;
  String? color;

  BarColor({this.key, this.color});

  BarColor.fromJson(Map<String, dynamic> json) {
    key = json['key'];
    color = json['color'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['key'] = key;
    data['color'] = color;
    return data;
  }
}
