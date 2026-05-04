class LoanDetailsResponse{
  LoanDetailsResponse({
    required this.status,
    required this.data,
    required this.message,
  });
  late final int status;
  late final List<LoanDetailsData> data;
  late final String message;

  LoanDetailsResponse.fromJson(Map<String, dynamic> json){
    status = json['status'];
    data = List.from(json['data']).map((e)=>LoanDetailsData.fromJson(e)).toList();
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['status'] = status;
    _data['data'] = data.map((e)=>e.toJson()).toList();
    _data['message'] = message;
    return _data;
  }
}

class LoanDetailsData {
  LoanDetailsData({
    required this.Id,
    required this.loan_app_id,
    required this.loan_type_id,
    required this.loan_name,
    required this.status,
    required this.created_on,
  });
  late final String Id;
  late final String loan_app_id;
  late final String loan_type_id;
  late final String loan_name;
  late final String status;
  late final String created_on;

  LoanDetailsData.fromJson(Map<String, dynamic> json){
    Id = json['id']??"";
    loan_app_id=json['loan_app_id']??"";
    loan_type_id = json['loan_type_id']??"";
    loan_name = json['loan_name']??"";
    status = json['status']??"";
    created_on = json['created_on']??"";
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = Id;
    _data['loan_app_id']=loan_app_id;
    _data['loan_type_id'] = loan_type_id;
    _data['loan_name'] = loan_name;
    _data['status'] = status;
    _data['created_on'] = created_on;
    return _data;
  }
}