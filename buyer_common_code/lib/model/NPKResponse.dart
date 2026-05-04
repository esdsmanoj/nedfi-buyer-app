// class NPKResponse {
//   NPKResponse({
//     required this.success,
//     required this.data,
//     required this.details,
//     required this.error,
//     required this.status,
//   });
//   late final int success;
//   late final List<NPKData> data;
//   late final NPKDetails details;
//   late final int error;
//   late final int status;
//
//   NPKResponse.fromJson(Map<String, dynamic> json){
//     success = json['success'];
//     //data = List.from(json['data']).map((e)=>NPKData.fromJson(e)).toList();
//     details = NPKDetails.fromJson(json['details']);
//     error = json['error'];
//     status = json['status'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final _data = <String, dynamic>{};
//     _data['success'] = success;
//   //  _data['data'] = data.map((e)=>e.toJson()).toList();
//     _data['details'] = details.toJson();
//     _data['error'] = error;
//     _data['status'] = status;
//     return _data;
//   }
// }
//
// class NPKData {
//   NPKData({
//     required this.name,
//     required this.nameMr,
//     required this.nitrogen,
//     required this.phosphorus,
//     required this.potassium,
//   });
//   late final String name;
//   late final String nameMr;
//   late final String nitrogen;
//   late final String phosphorus;
//   late final String potassium;
//
//   NPKData.fromJson(Map<String, dynamic> json){
//     name = json['name']??"";
//     nameMr = json['name_mr']??"";
//     nitrogen = json['nitrogen']??"";
//     phosphorus = json['phosphorus']??"";
//     potassium = json['potassium']??"";
//   }
//
//   Map<String, dynamic> toJson() {
//     final _data = <String, dynamic>{};
//     _data['name'] = name;
//     _data['name_mr'] = nameMr;
//     _data['nitrogen'] = nitrogen;
//     _data['phosphorus'] = phosphorus;
//     _data['potassium'] = potassium;
//     return _data;
//   }
// }
//
// class NPKDetails {
//   NPKDetails({
//     required this.npkValues,
//     required this.RequiredNpk,
//     required this.unitSize,
//   });
//   late final List<NpkValues> npkValues;
//   late final String RequiredNpk;
//   late final String unitSize;
//
//   NPKDetails.fromJson(Map<String, dynamic> json){
//     npkValues = List.from(json['npk_values']).map((e)=>NpkValues.fromJson(e)).toList();
//     RequiredNpk = json['Required_npk']??"";
//     unitSize = json['unit_size']??"";
//   }
//
//   Map<String, dynamic> toJson() {
//     final _data = <String, dynamic>{};
//     _data['npk_values'] = npkValues.map((e)=>e.toJson()).toList();
//     _data['Required_npk'] = RequiredNpk;
//     _data['unit_size'] = unitSize;
//     return _data;
//   }
// }
//
// class NpkValues {
//   NpkValues({
//     required this.line1,
//     required this.line2,
//     required this.line3,
//     required this.line4,
//     required this.Total,
//   });
//   late final String line1;
//   late final String line2;
//   late final String line3;
//   late final String line4;
//   late final String Total;
//
//   NpkValues.fromJson(Map<String, dynamic> json){
//     line1 = json['line1']??"";
//     line2 = json['line2']??"";
//     line3 = json['line3']??"";
//     line4 = json['line4']??"";
//     Total = json['Total']??"";
//   }
//
//   Map<String, dynamic> toJson() {
//     final _data = <String, dynamic>{};
//     _data['line1'] = line1;
//     _data['line2'] = line2;
//     _data['line3'] = line3;
//     _data['line4'] = line4;
//     _data['Total'] = Total;
//     return _data;
//   }
// }