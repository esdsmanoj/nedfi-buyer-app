class DiseaseFilterModel {
  int? success;
  int? error;
  int? status;
  List<DiseaseData>? data;
  List<FilterData>? filterData;
  String? selectedFilterData;
  String? message;

  DiseaseFilterModel({this.success, this.error, this.status, this.data, this.filterData, this.selectedFilterData, this.message});

  DiseaseFilterModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    error = json['error'];
    status = json['status'];
    if (json['data'] != null) {
      data = <DiseaseData>[];
      json['data'].forEach((v) {
        data!.add(DiseaseData.fromJson(v));
      });
    }
    if (json['filter_data'] != null) {
      filterData = <FilterData>[];
      json['filter_data'].forEach((v) {
        filterData!.add(FilterData.fromJson(v));
      });
    }
    selectedFilterData = json['selected_filter_data'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['success'] = success;
    data['error'] = error;
    data['status'] = status;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    if (filterData != null) {
      data['filter_data'] = filterData!.map((v) => v.toJson()).toList();
    }
    data['selected_filter_data'] = selectedFilterData;
    data['message'] = message;
    return data;
  }
}

class DiseaseData {
  String? diseaseName;
  String? componentId;
  String? diseaseId;
  String? diseaseType;
  String? iconImg;
  List<String>? images;
  List<TextData>? textData;

  DiseaseData({this.diseaseName, this.componentId, this.diseaseId, this.diseaseType, this.iconImg, this.images, this.textData});

  DiseaseData.fromJson(Map<String, dynamic> json) {
    diseaseName = json['disease_name'];
    componentId = json['component_id'];
    diseaseId = json['disease_id'];
    diseaseType = json['disease_type'];
    iconImg = json['icon_img'];
    images = json['images'].cast<String>();
    if (json['text_data'] != null) {
      textData = <TextData>[];
      json['text_data'].forEach((v) {
        textData!.add(TextData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['disease_name'] = diseaseName;
    data['component_id'] = componentId;
    data['disease_id'] = diseaseId;
    data['disease_type'] = diseaseType;
    data['icon_img'] = iconImg;
    data['images'] = images;
    if (textData != null) {
      data['text_data'] = textData!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class TextData {
  String? title;
  String? details;

  TextData({this.title, this.details});

  TextData.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    details = json['details'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['title'] = title;
    data['details'] = details;
    return data;
  }
}

class FilterData {
  String? title;
  dynamic id;

  FilterData({this.title, this.id});

  FilterData.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['title'] = title;
    data['id'] = id;
    return data;
  }
}
