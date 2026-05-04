class StateListModel {
  int? success;
  List<StateListModelData>? data;
  String? message;

  StateListModel({this.success, this.data, this.message});

  StateListModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    if (json['data'] != null) {
      data = <StateListModelData>[];
      json['data'].forEach((v) {
        data!.add(StateListModelData.fromJson(v));
      });
    }
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['success'] = success;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['message'] = message;
    return data;
  }
}

class StateListModelData {
  String? stateName;

  StateListModelData({this.stateName});

  StateListModelData.fromJson(Map<String, dynamic> json) {
    stateName = json['state_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['state_name'] = stateName;
    return data;
  }
}
