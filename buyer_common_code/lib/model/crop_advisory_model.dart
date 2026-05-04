import 'dart:collection';

class CropAdvisoryData {
  CropAdvisoryData({
    required this.status,
    required this.nwKey,
    required this.data,
    required this.message,
  });

  late final int status;
  late final HashMap<String, String> nwKey;
  late final List<AdvisoryCropData> data;
  late final String message;

  CropAdvisoryData.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    nwKey = HashMap.from(json['nw_key']);
    data = List.from(json['data'])
        .map((e) => AdvisoryCropData.fromJson(e))
        .toList();
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['status'] = status;
    _data['nw_key'] = nwKey;
    _data['data'] = data.map((e) => e.toJson()).toList();
    _data['message'] = message;
    return _data;
  }
}

class AdvisoryCropData {
  AdvisoryCropData({
    required this.cropId,
    required this.name,
    required this.nameMr,
    required this.mobIcon,
  });

  late final String cropId;
  late final String name;
  late final String nameMr;
  late final String mobIcon;

  AdvisoryCropData.fromJson(Map<String, dynamic> json) {
    cropId = json['crop_id'] ?? "";
    name = json['name'] ?? "";
    nameMr = json['name_mr'] ?? "";
    mobIcon = json['mob_icon'] ?? "";
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['crop_id'] = cropId;
    _data['name'] = name;
    _data['name_mr'] = nameMr;
    _data['mob_icon'] = mobIcon;
    return _data;
  }
}
