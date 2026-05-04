class SoilHealthResponse {
  SoilHealthResponse({
    required this.success,
    required this.error,
    required this.status,
    required this.data,
    required this.message,
  });
  late final int success;
  late final int error;
  late final int status;
  late final List<SoilHealthData> data;
  late final String message;

  SoilHealthResponse.fromJson(Map<String, dynamic> json){
    success = json['success'];
    error = json['error'];
    status = json['status'];
    if(json['data']!=null) {
      data = List.from(json['data'])
          .map((e) => SoilHealthData.fromJson(e))
          .toList();
    }
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['success'] = success;
    _data['error'] = error;
    _data['status'] = status;
    _data['data'] = data.map((e)=>e.toJson()).toList();
    _data['message'] = message;
    return _data;
  }
}

class SoilHealthData {
  SoilHealthData({
    required this.defciency,
    required this.pictures,
    required this.information,
    required this.recommendations,
  });
  late final String defciency;
  late final List<String> pictures;
  late final String information;
  late final String recommendations;

  SoilHealthData.fromJson(Map<String, dynamic> json){
    defciency = json['defciency']??"";
    pictures = List.castFrom<dynamic, String>(json['pictures']);
    information = json['information']??"";
    recommendations = json['recommendations']??"";
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['defciency'] = defciency;
    _data['pictures'] = pictures;
    _data['information'] = information;
    _data['recommendations'] = recommendations;
    return _data;
  }
}
