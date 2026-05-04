class LoanTypeResponse {
  LoanTypeResponse({
    required this.status,
    required this.data,
    required this.message,
  });
  late final int status;
  late final List<LoanTypeData> data;
  late final String message;

  LoanTypeResponse.fromJson(Map<String, dynamic> json){
    status = json['status'];
    data = List.from(json['data']).map((e)=>LoanTypeData.fromJson(e)).toList();
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

class LoanTypeData {
  LoanTypeData({
    required this.loanTypeId,
    required this.name,
    required this.logo,
    required this.nameMr,
    required this.mobIcon,
  });
  late final String loanTypeId;
  late final String name;
  late final String logo;
  late final String nameMr;
  late final String mobIcon;

  LoanTypeData.fromJson(Map<String, dynamic> json){
    loanTypeId = json['loan_type_id']??"";
    name = json['name']??"";
    logo = json['logo']??"";
    nameMr = json['name_mr']??"";
    mobIcon = json['mob_icon']??"";
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['loan_type_id'] = loanTypeId;
    _data['name'] = name;
    _data['logo'] = logo;
    _data['name_mr'] = nameMr;
    _data['mob_icon'] = mobIcon;
    return _data;
  }
}

