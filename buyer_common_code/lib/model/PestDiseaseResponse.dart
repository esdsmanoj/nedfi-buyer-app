class PestDiseaseResponse {
  PestDiseaseResponse({
    required this.success,
    required this.error,
    required this.status,
    required this.data,
    required this.baseUrl,
    required this.message,
  });
  late final int success;
  late final int error;
  late final int status;
  late final List<PestDiseaseData> data;
  late final String baseUrl;
  late final String message;

  PestDiseaseResponse.fromJson(Map<String, dynamic> json){
    success = json['success'];
    error = json['error'];
    status = json['status'];
    if(json['data']!=null) {
      data = List.from(json['data'])
          .map((e) => PestDiseaseData.fromJson(e))
          .toList();
    }
    baseUrl = json['base_url'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['success'] = success;
    _data['error'] = error;
    _data['status'] = status;
    _data['data'] = data.map((e)=>e.toJson()).toList();
    _data['base_url'] = baseUrl;
    _data['message'] = message;
    return _data;
  }
}

class PestDiseaseData {
  PestDiseaseData({
    required this.title,
    required this.componentImg,
    required this.componentId,
    required this.cropComponent,
  });
  late final String title;
  late final String componentImg;
  late final String componentId;
  late final String cropComponent;

  PestDiseaseData.fromJson(Map<String, dynamic> json){
    title = json['title']??"";
    componentImg = json['component_img']??"";
    componentId = json['component_id']??"";
    cropComponent = json['crop_component']??"";
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['title'] = title;
    _data['component_img'] = componentImg;
    _data['component_id'] = componentId;
    _data['crop_component'] = cropComponent;
    return _data;
  }
}