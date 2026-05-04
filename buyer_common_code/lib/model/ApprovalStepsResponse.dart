class ApprovalStepsResponse {
  ApprovalStepsResponse({
    required this.success,
    required this.stepMasterData,
    required this.error,
    required this.status,
    required this.data,
  });
  late final int success;
  late final List<StepMasterData> stepMasterData;
  late final int error;
  late final int status;
  late final List<dynamic> data;

  ApprovalStepsResponse.fromJson(Map<String, dynamic> json){
    success = json['success'];
    stepMasterData = List.from(json['step_master_data']).map((e)=>StepMasterData.fromJson(e)).toList();
    error = json['error'];
    status = json['status'];
    data = List.castFrom<dynamic, dynamic>(json['data']);
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['success'] = success;
    _data['step_master_data'] = stepMasterData.map((e)=>e.toJson()).toList();
    _data['error'] = error;
    _data['status'] = status;
    _data['data'] = data;
    return _data;
  }
}

class StepMasterData {
  StepMasterData({
    required this.id,
    this.userId,
    required this.stepTitle,
    required this.stepName,
    required this.status,
    required this.verifiedEntity,
    required this.stepOrder,
    required this.createdOn,
    required this.updatedOn,
    required this.deletedOn,
    required this.isDeleted,
    this.deletedById,
    required this.isActive,
    required this.isVerify,
    required this.createdById,
    required this.updatedById,
    required this.stepNameMr,
    this.isDropdown,
    required this.dropdownVal,
    this.stepNameHi,
  });
  late final String id;
  late final Null userId;
  late final String stepTitle;
  late final String stepName;
  late final String status;
  late final String verifiedEntity;
  late final String stepOrder;
  late final String createdOn;
  late final String updatedOn;
  late final String deletedOn;
  late final String isDeleted;
  late final String? deletedById;
  late final String isActive;
  late final String isVerify;
  late final String createdById;
  late final String updatedById;
  late final String stepNameMr;
  late final String? isDropdown;
  late final String dropdownVal;
  late final Null stepNameHi;

  StepMasterData.fromJson(Map<String, dynamic> json){
    id = json['id']??"";
    userId = null;
    stepTitle = json['step_title']??"";
    stepName = json['step_name']??"";
    status = json['status']??"";
    verifiedEntity = json['verified_entity']??"";
    stepOrder = json['step_order']??"";
    createdOn = json['created_on']??"";
    updatedOn = json['updated_on']??"";
    deletedOn = json['deleted_on']??"";
    isDeleted = json['is_deleted']??"";
    deletedById = null;
    isActive = json['is_active']??"";
    isVerify = json['is_verify']??"";
    createdById = json['created_by_id']??"";
    updatedById = json['updated_by_id']??"";
    stepNameMr = json['step_name_mr']??"";
    isDropdown = null;
    dropdownVal = json['dropdown_val']??"";
    stepNameHi = null;
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['user_id'] = userId;
    _data['step_title'] = stepTitle;
    _data['step_name'] = stepName;
    _data['status'] = status;
    _data['verified_entity'] = verifiedEntity;
    _data['step_order'] = stepOrder;
    _data['created_on'] = createdOn;
    _data['updated_on'] = updatedOn;
    _data['deleted_on'] = deletedOn;
    _data['is_deleted'] = isDeleted;
    _data['deleted_by_id'] = deletedById;
    _data['is_active'] = isActive;
    _data['is_verify'] = isVerify;
    _data['created_by_id'] = createdById;
    _data['updated_by_id'] = updatedById;
    _data['step_name_mr'] = stepNameMr;
    _data['is_dropdown'] = isDropdown;
    _data['dropdown_val'] = dropdownVal;
    _data['step_name_hi'] = stepNameHi;
    return _data;
  }
}