import 'package:buyer_common_code/model/CountryResponse.dart';
import 'package:buyer_common_code/model/MyLoanDetailsResponse.dart';
import 'package:buyer_common_code/model/StateResponse.dart';
import 'package:flutter/material.dart';

import '../model/CityResponse.dart';

class LoanProvider extends ChangeNotifier {
  String loanTypeID = "";

  setLoanTypeID(String loanTypeId) {
    loanTypeID = loanTypeId;
    notifyListeners();
  }

  List<CountryData> countryList = [];

  setCountry(List<CountryData> list) {
    countryList = list;
    notifyListeners();
  }

  List<StateData> stateList = [];

  setStates(List<StateData> list) {
    stateList = [];
    stateList = list;
    notifyListeners();
  }

  List<CityData> cityList = [];

  setCity(List<CityData> list) {
    cityList = [];
    cityList = list;
    notifyListeners();
  }

  int pageIndex = 1;
  String cropType = "";
  String tieUpAgreeent = "";
  String loanAmount = "";

  String firstName = "";
  String lastName = "";
  String mobile = "";
  String altermobile = "";

  String cofirstName = "";
  String colastName = "";
  String comobile = "";
  String coaltermobile = "";

  String annuleAgriIncome = "";
  String otherIncome = "";
  String totalIncome = "";

  String villageController = "";
  String surveyNumberController = "";
  String landSharedLeasedController = "";
  String sharedAreaController = "";
  String totalAreaController = "";
  String irrigatedAreaController = "";
  String irrigationSourceController = "";
  String encumbrancController = "";

  String mobileNo = "";
  String email = "";
  String dob = "";
  String gender = "";
  String father = "";
  String country = "";
  String state = "";
  String disctric = "";
  String village = "";
  String postal = "";
  String address = "";

  String co_mobileNo = "";
  String co_email = "";
  String co_dob = "";
  String co_gender = "";
  String co_father = "";
  String co_countr = "";
  String co_state = "";
  String co_disctric = "";
  String co_village = "";
  String co_postal = "";
  String co_address = "";

  String aadharCard = "";
  String panCard = "";

  String tractorCompany = "";
  String tractorModel = "";
  String exShowroomPrice = "";
  String insurancecharges = "";
  String costofAccessories = "";
  String loanAmountRequired = "";
  String horsePowertype = "";

  String registionCost = "";
  String combinHarvMake = "";
  String typeofHarvester = "";
  String HarvesterModel = "";

  String costofProjrct = "";
  String fuleEnergyCost = "";
  String groundwater = "";

  setPageIndex(int index) {
    pageIndex = index;
    notifyListeners();
  }

  setCorpDetails(String cropTypes, String tieUpAgreeents, String loanAmounts) {
    cropType = cropTypes;
    tieUpAgreeent = tieUpAgreeents;
    loanAmount = loanAmounts;
    notifyListeners();
  }

  setPersonalDetails(String firstNames, String lastNames, String mobiles, String altermobiles) {
    firstName = firstNames;
    lastName = lastNames;
    mobile = mobiles;
    altermobile = altermobiles;
    notifyListeners();
  }

  setCoApplicantDetails(String firstName, String lastName, String mobile, String altermobile) {
    cofirstName = firstName;
    colastName = lastName;
    comobile = mobile;
    coaltermobile = altermobile;
    notifyListeners();
  }

  setPersonalLoanPageOne(String firstNames, String lastNames, String mobiles, String altermobiles) {
    annuleAgriIncome = firstNames;
    otherIncome = lastNames;
    totalIncome = mobiles;
    loanAmount = altermobiles;
    notifyListeners();
  }

  setPersonalLoanPageTwo(String villageControllers, String surveyNumberControllers, String landSharedLeasedControllers, String sharedAreaControllers, String totalAreaControllers,
      String irrigatedAreaControllers, String irrigationSourceControllers, String encumbrancControllers) {
    villageController = villageControllers;
    surveyNumberController = surveyNumberControllers;
    landSharedLeasedController = landSharedLeasedControllers;
    sharedAreaController = sharedAreaControllers;
    totalAreaController = totalAreaControllers;
    irrigatedAreaController = irrigatedAreaControllers;
    irrigationSourceController = irrigationSourceControllers;
    encumbrancController = encumbrancControllers;
    notifyListeners();
  }

  setPersonalLoanPageThree(String firstNames, String lastNames, String mobileNos, String emails, String dobs, String genders, String fathers, String countrs, String states, String disctrics,
      String villages, String postals, String addresss) {
    firstName = firstNames;
    lastName = lastNames;
    mobileNo = mobileNos;
    email = emails;
    dob = dobs;
    gender = genders;
    father = fathers;
    country = countrs;
    state = states;
    disctric = disctrics;
    village = villages;
    postal = postals;
    address = addresss;
    notifyListeners();
  }

  setPersonalLoanPageFour(String firstNames, String lastNames, String mobileNos, String emails, String dobs, String genders, String fathers, String countrs, String states, String disctrics,
      String villages, String postals, String addresss) {
    cofirstName = firstNames;
    colastName = lastNames;
    co_mobileNo = mobileNos;
    co_email = emails;
    co_dob = dobs;
    co_gender = genders;
    co_father = fathers;
    co_countr = countrs;
    co_state = states;
    co_disctric = disctrics;
    co_village = villages;
    co_postal = postals;
    co_address = addresss;
    notifyListeners();
  }

  setCardDetails(String aadhar, String pan) {
    aadharCard = aadhar;
    panCard = pan;
    notifyListeners();
  }

  setTractorDetails(
    String tractorCompanys,
    String tractorModels,
    String exShowroomPrices,
    String insurancechargess,
    String costofAccessoriess,
    String loanAmountRequireds,
    String horsePowertypes,
  ) {
    tractorCompany = tractorCompanys;
    tractorModel = tractorModels;
    exShowroomPrice = exShowroomPrices;
    insurancecharges = insurancechargess;
    costofAccessories = costofAccessoriess;
    loanAmountRequired = loanAmountRequireds;
    horsePowertype = horsePowertypes;
    notifyListeners();
  }

  setHarvesterDetails(
    String loanAmountRequireds,
    String registionCosts,
    String exShowroomPrices,
    String combinHarvMakes,
    String costofAccessoriess,
    String typeofHarvesters,
    String HarvesterModels,
  ) {
    loanAmountRequired = loanAmountRequireds;
    registionCost = registionCosts;
    exShowroomPrice = exShowroomPrices;
    combinHarvMake = combinHarvMakes;
    costofAccessories = costofAccessoriess;
    typeofHarvester = typeofHarvesters;
    HarvesterModel = HarvesterModels;
    notifyListeners();
  }

  setPumpSetDetails(String loanAmounts, String costofProjrcts, String fuleEnergyCosts, String groundwaters) {
    loanAmountRequired = loanAmounts;
    costofProjrct = costofProjrcts;
    fuleEnergyCost = fuleEnergyCosts;
    groundwater = groundwaters;
    notifyListeners();
  }

  List<MyLoanDetailsApplication> myLoanDetailsDatalist = [];

  setMyLoanDetails(List<MyLoanDetailsApplication> list) {
    myLoanDetailsDatalist = [];
    myLoanDetailsDatalist = list;
    notifyListeners();
  }

  List<MyLoanDetailsBanks> myLoanDetailsBanklist = [];

  setMyLoanDetailsBanks(List<MyLoanDetailsBanks> list) {
    myLoanDetailsBanklist = [];
    myLoanDetailsBanklist = list;
    notifyListeners();
  }

  OtherLoanDetails otherLoanDetails = OtherLoanDetails();

  setOtherLoanDetails(OtherLoanDetails otherLoanDetail) {
    otherLoanDetails = otherLoanDetail;
    notifyListeners();
  }

  setClearAll() {
    pageIndex = 1;
    cropType = "";
    tieUpAgreeent = "";
    loanAmount = "";
    firstName = "";
    lastName = "";
    mobile = "";
    altermobile = "";
    cofirstName = "";
    colastName = "";
    comobile = "";
    coaltermobile = "";
    annuleAgriIncome = "";
    otherIncome = "";
    totalIncome = "";
    villageController = "";
    surveyNumberController = "";
    landSharedLeasedController = "";
    sharedAreaController = "";
    totalAreaController = "";
    irrigatedAreaController = "";
    irrigationSourceController = "";
    encumbrancController = "";
    mobileNo = "";
    email = "";
    dob = "";
    gender = "";
    father = "";
    country = "";
    state = "";
    disctric = "";
    village = "";
    postal = "";
    address = "";
    co_mobileNo = "";
    co_email = "";
    co_dob = "";
    co_gender = "";
    co_father = "";
    co_countr = "";
    co_state = "";
    co_disctric = "";
    co_village = "";
    co_postal = "";
    co_address = "";
    aadharCard = "";
    panCard = "";
    tractorCompany = "";
    tractorModel = "";
    exShowroomPrice = "";
    insurancecharges = "";
    costofAccessories = "";
    loanAmountRequired = "";
    horsePowertype = "";
    registionCost = "";
    combinHarvMake = "";
    typeofHarvester = "";
    HarvesterModel = "";
    costofProjrct = "";
    fuleEnergyCost = "";
    groundwater = "";
    notifyListeners();
  }


}
