class Insentive {
  int? success;
  List<Awardeddata>? awardeddata;
  List<Redeemdata>? redeemdata;
  String? message;

  Insentive({this.success, this.awardeddata, this.redeemdata, this.message});

  Insentive.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    if (json['awardeddata'] != null) {
      awardeddata = <Awardeddata>[];
      json['awardeddata'].forEach((v) {
        awardeddata!.add(new Awardeddata.fromJson(v));
      });
    }
    if (json['redeemdata'] != null) {
      redeemdata = <Redeemdata>[];
      json['redeemdata'].forEach((v) {
        redeemdata!.add(new Redeemdata.fromJson(v));
      });
    }
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    if (this.awardeddata != null) {
      data['awardeddata'] = this.awardeddata!.map((v) => v.toJson()).toList();
    }
    if (this.redeemdata != null) {
      data['redeemdata'] = this.redeemdata!.map((v) => v.toJson()).toList();
    }
    data['message'] = this.message;
    return data;
  }
}

class Awardeddata {
  String? incentiveStatus;
  String? incentiveAwardedOn;
  String? incentiveName;
  String? overview;
  String? brief;
  String? logo;
  String? incentiveId;

  Awardeddata(
      {this.incentiveStatus,
        this.incentiveAwardedOn,
        this.incentiveName,
        this.overview,
        this.brief,
        this.logo,
        this.incentiveId});

  Awardeddata.fromJson(Map<String, dynamic> json) {
    incentiveStatus = json['incentive_status'];
    incentiveAwardedOn = json['incentive_awarded_on'];
    incentiveName = json['incentive_name'];
    overview = json['overview'];
    brief = json['brief'];
    logo = json['logo'];
    incentiveId = json['incentive_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['incentive_status'] = this.incentiveStatus;
    data['incentive_awarded_on'] = this.incentiveAwardedOn;
    data['incentive_name'] = this.incentiveName;
    data['overview'] = this.overview;
    data['brief'] = this.brief;
    data['logo'] = this.logo;
    data['incentive_id'] = this.incentiveId;
    return data;
  }
}

class Redeemdata {
  String? incentiveStatus;
  String? incentiveAwardedOn;
  String? incentiveRedeemedDate;
  String? incentiveName;
  String? overview;
  String? brief;
  String? logo;
  String? incentiveId;

  Redeemdata(
      {this.incentiveStatus,
        this.incentiveAwardedOn,
        this.incentiveRedeemedDate,
        this.incentiveName,
        this.overview,
        this.brief,
        this.logo,
        this.incentiveId});

  Redeemdata.fromJson(Map<String, dynamic> json) {
    incentiveStatus = json['incentive_status'];
    incentiveAwardedOn = json['incentive_awarded_on'];
    incentiveRedeemedDate = json['incentive_redeemed_date'];
    incentiveName = json['incentive_name'];
    overview = json['overview'];
    brief = json['brief'];
    logo = json['logo'];
    incentiveId = json['incentive_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['incentive_status'] = this.incentiveStatus;
    data['incentive_awarded_on'] = this.incentiveAwardedOn;
    data['incentive_redeemed_date'] = this.incentiveRedeemedDate;
    data['incentive_name'] = this.incentiveName;
    data['overview'] = this.overview;
    data['brief'] = this.brief;
    data['logo'] = this.logo;
    data['incentive_id'] = this.incentiveId;
    return data;
  }
}