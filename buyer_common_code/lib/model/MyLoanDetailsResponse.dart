class MyLoanDetailsResponse {
  MyLoanDetailsResponse({
    required this.status,
    required this.data,
    required this.message,
  });
  late final int status;
  late final MyLoanDetailsData data;
  late final String message;

  MyLoanDetailsResponse.fromJson(Map<String, dynamic> json){
    status = json['status'];
    data = MyLoanDetailsData.fromJson(json['data']);
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['status'] = status;
    _data['data'] = data.toJson();
    _data['message'] = message;
    return _data;
  }
}

class MyLoanDetailsData {
  MyLoanDetailsData({
    required this.application,
    required this.banks,
  });
  late final List<MyLoanDetailsApplication> application;
  late final List<MyLoanDetailsBanks> banks;

  MyLoanDetailsData.fromJson(Map<String, dynamic> json){
    application = List.from(json['application']).map((e)=>MyLoanDetailsApplication.fromJson(e)).toList();
    banks = List.from(json['banks']).map((e)=>MyLoanDetailsBanks.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['application'] = application.map((e)=>e.toJson()).toList();
    _data['banks'] = banks.map((e)=>e.toJson()).toList();
    return _data;
  }
}

class MyLoanDetailsApplication {
  MyLoanDetailsApplication({
    required this.id,
    required this.userId,
    required this.firstName,
    this.loanType,
    required this.lastName,
    required this.status,
    required this.createdOn,
    required this.otherDetails,
    required this.updatedOn,
    required this.bankInterested,
    required this.laonAmountSanctioned,
    required this.bankId,
    required this.loanImage,
    required this.loanAmountDisbursed,
    required this.interestRate,
  });
  late final String id;
  late final String userId;
  late final String firstName;
  late final String? loanType;
  late final String lastName;
  late final String status;
  late final String createdOn;
  late final String? otherDetails;
  late final String updatedOn;
  late final String bankInterested;
  late final String laonAmountSanctioned;
  late final String bankId;
  late final String loanImage;
  late final String loanAmountDisbursed;
  late final String interestRate;

  MyLoanDetailsApplication.fromJson(Map<String, dynamic> json){
    id = json['id']??"";
    userId = json['user_id']??"";
    firstName = json['first_name']??"";
    loanType = json['loan_type']??"";
    lastName = json['last_name']??"";
    status = json['status']??"";
    createdOn = json['created_on']??"";
  /*  if(json['other_details'] is String) {
      otherDetails = null;
    }else{*/
      otherDetails = json['other_details']??"";
    //}
    updatedOn = json['updated_on']??"";
    bankInterested = json['bank_interested']??"";
    laonAmountSanctioned = json['laon_amount_sanctioned']??"";
    bankId = json['bank_id']??"";
    loanImage = json['loan_image']??"";
    loanAmountDisbursed = json['loan_amount_disbursed']??"";
    interestRate = json['interest_rate']??"";
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['user_id'] = userId;
    _data['first_name'] = firstName;
    _data['loan_type'] = loanType;
    _data['last_name'] = lastName;
    _data['status'] = status;
    _data['created_on'] = createdOn;
    _data['other_details'] = otherDetails;
    _data['updated_on'] = updatedOn;
    _data['bank_interested'] = bankInterested;
    _data['laon_amount_sanctioned'] = laonAmountSanctioned;
    _data['bank_id'] = bankId;
    _data['loan_image'] = loanImage;
    _data['loan_amount_disbursed'] = loanAmountDisbursed;
    _data['interest_rate'] = interestRate;
    return _data;
  }
}
class OtherLoanDetails {
  OtherLoanDetails({
    this.user_id,
    this.id,
    this.loan_type_id,
    this.annual_agriculture_income,
    this.other_annual_income_if_any
    ,this.total_income
    ,this.Type_of_Crop
    ,this.Tie_Up_Agreement
    ,this.Loan_Amount_Required
    ,this.village_city
    ,this.survey_block_number
    ,this.owned_land_in_acres
    ,this.land_shared_leased_in_acres
    ,this.shared_in_acres
    ,this.total_area_in_acres
    ,this.irrigated_area_in_acres
    ,this.source_of_irrigation
    ,this.encumbrance_if_any
    ,this.first_name
    ,this.last_name
    ,this.email
    ,this.contact_no
    ,this.dob
    ,this.gender
    ,this.father_husband_spouse_name
    ,this.address1
    ,this.address2
    ,this.country
    ,this.state
    ,this.city
    ,this.postcode
    ,this.country_name
    ,this.state_name
    ,this.village
    ,this.aadhar_no
    ,this.pan_no
    ,this.co_applicant_first_name
    ,this.co_applicant_last_name
    ,this.co_applicant_contact_no
    ,this.co_applicant_alternate_contact_no
    ,this.co_applicant_email
    ,this.co_applicant_date_of_birth
    ,this.co_applicant_gender
    ,this.co_applicant_father_or_husband_or_spouse_name
    ,this.co_applicant_postcode
    ,this.co_applicant_address1
    ,this.co_applicant_address2
    ,this.co_applicant_country
    ,this.co_applicant_state
    ,this.co_applicant_city
    ,this.co_applicant_village
    ,this.traactor_company
    ,this.traactor_model
    ,this.ex_showroom_price
    ,this.insurance_charges
    ,this.cost_of_accessories
    ,this.type_of_horse_power
    ,this.Registration_Cost
    ,this.Type_of_Combine_Harvestor
    ,this.Combine_Harvestor_model
    ,this.alternate_contact_no
    ,this.Combine_Harvestor_make
    ,this.Fuel_Energy_Type
    ,this.Cost_of_Project
  });

  late final String? user_id;
  late final String? id;

  late final String? loan_type_id;

  late final String? annual_agriculture_income;

  late final String? other_annual_income_if_any;

  late final String? total_income;

  late final String? Type_of_Crop;

  late final String? Tie_Up_Agreement;

  late final String? Loan_Amount_Required;

  late final String? village_city;

  late final String? survey_block_number;

  late final String? owned_land_in_acres;

  late final String? land_shared_leased_in_acres;

  late final String? shared_in_acres;

  late final String? total_area_in_acres;

  late final String? irrigated_area_in_acres;

  late final String? source_of_irrigation;

  late final String? encumbrance_if_any;


  late final String? first_name;

  late final String? last_name;

  late final String? email;

  late final String? contact_no;

  late final String? dob;

  late final String? gender;

  late final String? father_husband_spouse_name;

  late final String? address1;

  late final String? address2;

  late final String? country;

  late final String? state;

  late final String? city;

  late final String?  postcode;

  late final String? country_name;

  late final String? state_name;

  late final String? village;

  late final String?  aadhar_no;

  late final String? pan_no;

  late final String? co_applicant_first_name;
  late final String? co_applicant_last_name;
  late final String? co_applicant_contact_no;
  late final String? co_applicant_alternate_contact_no;
  late final String? co_applicant_email;
  late final String? co_applicant_date_of_birth;
  late final String? co_applicant_gender;
  late final String? co_applicant_father_or_husband_or_spouse_name;
  late final String? co_applicant_postcode;
  late final String? co_applicant_address1;
  late final String? co_applicant_address2;
  late final String? co_applicant_country;
  late final String? co_applicant_state;
  late final String? co_applicant_city;
  late final String? co_applicant_village;

  late final String? traactor_company;
  late final String? traactor_model;
  late final String? ex_showroom_price;
  late final String? insurance_charges;
  late final String? cost_of_accessories;
  late final String? type_of_horse_power;

  late final String?  Registration_Cost;

  late final String? Type_of_Combine_Harvestor;

  late final String? Combine_Harvestor_model;

  late final String? alternate_contact_no;

  late final String? Combine_Harvestor_make;

  late final String? Fuel_Energy_Type;

  late final String? Cost_of_Project;


  OtherLoanDetails.fromJson(Map<String, dynamic> json){

    user_id= json['user_id']??"";
    id= json['id']??"";
    loan_type_id= json['loan_type_id']??"";
    annual_agriculture_income= json['annual_agriculture_income']??"";
   other_annual_income_if_any= json['other_annual_income_if_any']??"";
   total_income= json['total_income']??"";
    Type_of_Crop= json['Type_of_Crop']??"";
    Tie_Up_Agreement= json['Tie_Up_Agreement']??"";
    Loan_Amount_Required= json['Loan_Amount_Required']??"";
    village_city= json['village_city']??"";
   survey_block_number= json['survey_block_number']??"";
    owned_land_in_acres= json['owned_land_in_acres']??"";
    land_shared_leased_in_acres= json['land_shared_leased_in_acres']??"";
    shared_in_acres= json['shared_in_acres']??"";
    total_area_in_acres= json['total_area_in_acres']??"";
    irrigated_area_in_acres= json['irrigated_area_in_acres']??"";
    source_of_irrigation= json['source_of_irrigation']??"";
    encumbrance_if_any= json['encumbrance_if_any']??"";
    first_name= json['first_name']??"";
    last_name= json['last_name']??"";
    email= json['email']??"";
    contact_no= json['contact_no']??"";
    dob= json['dob']??"";
    gender= json['gender']??"";
    father_husband_spouse_name= json['father_husband_spouse_name']??"";
    address1= json['address1']??"";
    address2= json['address2']??"";
    country= json['country']??"";
    state= json['state']??"";
    city= json['city']??"";
    postcode= json['postcode']??"";
    country_name= json['country_name']??"";
    state_name= json['state_name']??"";
    village= json['village']??"";
    aadhar_no= json['aadhar_no']??"";
    pan_no= json['pan_no']??"";
    co_applicant_first_name= json['co_applicant_first_name']??"";
    co_applicant_last_name= json['co_applicant_last_name']??"";
    co_applicant_contact_no= json['co_applicant_contact_no']??"";
    co_applicant_alternate_contact_no= json['co_applicant_alternate_contact_no']??"";
    co_applicant_email= json['co_applicant_email']??"";
    co_applicant_date_of_birth= json['co_applicant_date_of_birth']??"";
    co_applicant_gender= json['co_applicant_gender']??"";
    co_applicant_father_or_husband_or_spouse_name= json['co_applicant_father_or_husband_or_spouse_name']??"";
    co_applicant_postcode= json['co_applicant_postcode']??"";
    co_applicant_address1= json['co_applicant_address1']??"";
    co_applicant_address2= json['co_applicant_address2']??"";
    co_applicant_country= json['co_applicant_country']??"";
    co_applicant_state= json['co_applicant_state']??"";
    co_applicant_city= json['co_applicant_city']??"";
    co_applicant_village= json['co_applicant_village']??"";
    traactor_company= json['traactor_company']??"";
    traactor_model= json['traactor_model']??"";
    ex_showroom_price= json['ex_showroom_price']??"";
    insurance_charges= json['insurance_charges']??"";
   cost_of_accessories= json['cost_of_accessories']??"";
    type_of_horse_power= json['type_of_horse_power']??"";
    Registration_Cost= json['Registration_Cost']??"";
    Type_of_Combine_Harvestor= json['Type_of_Combine_Harvestor']??"";
    Combine_Harvestor_model= json['Combine_Harvestor_model']??"";
   alternate_contact_no= json['alternate_contact_no']??"";
    Combine_Harvestor_make= json['Combine_Harvestor_make']??"";
    Fuel_Energy_Type= json['Fuel_Energy_Type']??"";
    Cost_of_Project= json['Cost_of_Project']??"";
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
     _data['user_id']=user_id;
     _data['id']=id;
     _data['loan_type_id']=loan_type_id;
     _data['annual_agriculture_income']=annual_agriculture_income;
     _data['other_annual_income_if_any']=other_annual_income_if_any;
     _data['total_income']=total_income;
     _data['Type_of_Crop']=Type_of_Crop;
     _data['Tie_Up_Agreement']=Tie_Up_Agreement;
     _data['Loan_Amount_Required']=Loan_Amount_Required;
     _data['village_city']=village_city;
     _data['survey_block_number']=survey_block_number;
     _data['owned_land_in_acres']=owned_land_in_acres;
     _data['land_shared_leased_in_acres']=land_shared_leased_in_acres;
     _data['shared_in_acres']=shared_in_acres;
     _data['total_area_in_acres']=total_area_in_acres;
     _data['irrigated_area_in_acres']=irrigated_area_in_acres;
     _data['source_of_irrigation']=source_of_irrigation;
     _data['encumbrance_if_any']=encumbrance_if_any;
     _data['first_name']=first_name;
     _data['last_name']=last_name;
     _data['email']=email;
     _data['contact_no']=contact_no;
     _data['dob']=dob;
     _data['gender']=gender;
     _data['father_husband_spouse_name']=father_husband_spouse_name;
     _data['address1']=address1;
     _data['address2']=address2;
     _data['country']=country;
     _data['state']=state;
     _data['city']=city;
     _data['postcode']=postcode;
     _data['country_name']=country_name;
     _data['state_name']=state_name;
     _data['village']=village;
     _data['aadhar_no']=aadhar_no;
     _data['pan_no']=pan_no;
     _data['co_applicant_first_name']=co_applicant_first_name;
     _data['co_applicant_last_name']=co_applicant_last_name;
     _data['co_applicant_contact_no']=co_applicant_contact_no;
     _data['co_applicant_alternate_contact_no']=co_applicant_alternate_contact_no;
     _data['co_applicant_email']=co_applicant_email;
     _data['co_applicant_date_of_birth']=co_applicant_date_of_birth;
     _data['co_applicant_gender']=co_applicant_gender;
    _data['co_applicant_father_or_husband_or_spouse_name']=co_applicant_father_or_husband_or_spouse_name;
     _data['co_applicant_postcode']=co_applicant_postcode;
     _data['co_applicant_address1']=co_applicant_address1;
     _data['co_applicant_address2']=co_applicant_address2;
     _data['co_applicant_country']=co_applicant_country;
     _data['co_applicant_state']=co_applicant_state;
     _data['co_applicant_city']=co_applicant_city;
     _data['co_applicant_village']=co_applicant_village;
     _data['traactor_company']=traactor_company;
     _data['traactor_model']=traactor_model;
     _data['ex_showroom_price']=ex_showroom_price;
     _data['insurance_charges']=insurance_charges;
     _data['cost_of_accessories']=cost_of_accessories;
     _data['type_of_horse_power']=type_of_horse_power;
     _data['Registration_Cost']=Registration_Cost;
     _data['Type_of_Combine_Harvestor']=Type_of_Combine_Harvestor;
     _data['Combine_Harvestor_model']=Combine_Harvestor_model;
     _data['alternate_contact_no']=alternate_contact_no;
     _data['Combine_Harvestor_make']=Combine_Harvestor_make;
     _data['Fuel_Energy_Type']=Fuel_Energy_Type;
     _data['Cost_of_Project']=Cost_of_Project;
    return _data;
  }
}

class MyLoanDetailsBanks {
  MyLoanDetailsBanks({
    required this.appInterest,
    required this.companyName,
    required this.bankId,
    required this.loanSanctioned,
    required this.loanDisbursed,
    required this.interestRate,
  });
  late final String appInterest;
  late final String companyName;
  late final String bankId;
  late final String loanSanctioned;
  late final String loanDisbursed;
  late final String interestRate;

  MyLoanDetailsBanks.fromJson(Map<String, dynamic> json){
    appInterest = json['app_interest']??"";
    companyName = json['company_name']??"";
    bankId = json['bank_id']??"";
    loanSanctioned = json['loan_sanctioned']??"";
    loanDisbursed = json['loan_disbursed']??"";
    interestRate = json['interest_rate']??"";
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['app_interest'] = appInterest;
    _data['company_name'] = companyName;
    _data['bank_id'] = bankId;
    _data['loan_sanctioned'] = loanSanctioned;
    _data['loan_disbursed'] = loanDisbursed;
    _data['interest_rate'] = interestRate;
    return _data;
  }
}