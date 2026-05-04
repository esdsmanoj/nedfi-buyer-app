import 'package:get/get.dart';
import 'package:nedfi_seller_common_code/pages/user_details/user_kyc.dart';

import '../../app_imports.dart';
import '../../components/widgets/uppercase_formatter.dart';
import '../../model/CityResponse.dart';
import '../../model/StateResponse.dart';
import '../../model/trade_product_model/master_listing_model.dart';
import '../../model/user_model/user_profile_details.dart';

class BusinessDetails extends StatefulWidget {
  final bool isActive;

  const BusinessDetails(this.isActive, {super.key});

  @override
  State<BusinessDetails> createState() => _BusinessDetailsState();
}

class _BusinessDetailsState extends State<BusinessDetails> {
  static const key = Key('business_details');
  bool isSameInfoStatus = false;
  List<StateData> searchState = [];
  List<CityData> searchCity = [];
  late String userTypeName, businessType, businessScheme;
  late TextEditingController businessNameController,
      businessDesignationController,
      businessAddressController,
      stateController,
      cityController,
      villageController,
      pinCodeController,
      // registrationNumberController,
      panNumberController,
      gstNumberController;
  List<UserType>? userTypeList, businessTypeList;
  String? stateID, cityId;

  TextEditingController controller = TextEditingController(), controllerOne = TextEditingController();

  @override
  void initState() {
    businessAddressController = TextEditingController();
    businessNameController = TextEditingController();
    businessDesignationController = TextEditingController();
    stateController = TextEditingController();
    cityController = TextEditingController();
    pinCodeController = TextEditingController();
    gstNumberController = TextEditingController();
    // registrationNumberController = TextEditingController();
    panNumberController = TextEditingController();
    villageController = TextEditingController();
    userTypeList = masterListing!.data!.userType!.reversed.toList();
    businessTypeList = masterListing!.data!.businessType;
    userTypeName = userTypeList![0].title!;
    businessType = businessTypeList![0].title!;
    businessScheme =  (businessType=="FPC"?(masterListing?.data?.fpcBusinessScheme?[0].title??""): masterListing!.data!.businessScheme![0].title)!;
    HelperUtils().getState((value) {}, context);
    getDetails();
    super.initState();
  }

  Future getUserProfile() async {
    try {
      final response = await APIService.getAPIMethod(url: "${ApiURL.getUserProfile}/$userId");
      final res = UserProfileDetails.fromJson(json.decode(response.body));
      if (res.success == 1 && res.data != null) {
        userTypeName = (res.data![0].appUserType == null)
            ? "business".tr
            : res.data![0].appUserType == '1'
                ? 'individual'.tr
                : res.data![0].appUserType == '2'
                    ? "business".tr
                    : "business".tr;
        businessType = res.data![0].businessType ?? businessTypeList![0].title!;
        businessScheme = (res.data![0].businessScheme ?? (businessType=="FPC"?(masterListing?.data?.fpcBusinessScheme?[0].title??''): masterListing!.data!.businessScheme![0].title))!;
        businessNameController.text = res.data![0].businessName ?? "";
        businessDesignationController.text = res.data![0].businessDesignation ?? "";
        businessAddressController.text = res.data![0].businessAddress ?? "";
        cityId = res.data![0].businessDistrict ?? "";
        stateID = res.data![0].businessState ?? "";
        final loanModel = Provider.of<LoanProvider>(context, listen: false);
        final value = await HelperUtils().getCity(stateID!, (value) {}, context);
        loanModel.setCity(value ?? []);
        for (final stateData in loanModel.stateList) {
          if (stateData.id == stateID) {
            stateController.text = stateData.name ?? "";
            for (final cityData in loanModel.cityList) {
              if (cityData.id == cityId) {
                cityController.text = cityData.name ?? "";
                break;
              }
            }
            break;
          }
        }

        villageController.text = res.data![0].businessCityVillage ?? "";
        pinCodeController.text = res.data![0].businessPincode ?? "";
        gstNumberController.text = res.data![0].businessGstin ?? "";
        // registrationNumberController.text = res.data![0].businessRegNo ?? "";
        // panNumberController.text = res.data![0].businessPan ?? "";
        setState(() {});
        // profileFile = File(decodedMap["image"]);
      }
    } catch (e) {
      rethrow;
    }
  }

  Future getDetails() async {
    final userDetails = await SharePrefsHelper.getInstance(context)?.getStringValue("userTypeSelected");
    if (userDetails != null && userDetails.isNotEmpty) {
      Map<String, dynamic> decodedType = json.decode(userDetails);
      if (decodedType['userType'] != 'individual'.tr) {
        userTypeName = decodedType['userType'];
        final address = await SharePrefsHelper.getInstance(context)!.getStringValue("step2_data");
        final isPermanentActive = await SharePrefsHelper.getInstance(context)!.getBoolValue("address_check") ?? false;
        isSameInfoStatus = isPermanentActive;
        HeaderSingleton().setAppUserType(await SharePrefsHelper.getInstance(context)?.getStringValue("userType") ?? "0");
        if (address != null && address.isNotEmpty) {
          Map<String, dynamic> decodedMap = json.decode(address);
          businessType = decodedMap["business_type"] ?? "";
          businessScheme = decodedMap["business_scheme"] ?? "";
          businessNameController.text = decodedMap["business_name"] ?? "";
          businessDesignationController.text = decodedMap["business_designation"] ?? "";
          businessAddressController.text = decodedMap["business_address"] ?? "";
          cityId = decodedMap["business_district"];
          stateID = decodedMap["business_state"];
          final loanModel = Provider.of<LoanProvider>(context, listen: false);
          final value = await HelperUtils().getCity(stateID!, (value) {}, context);
          loanModel.setCity(value ?? []);
          villageController.text = decodedMap["business_city_village"];
          pinCodeController.text = decodedMap["business_pincode"];
          gstNumberController.text = decodedMap["business_gstin"];
          // registrationNumberController.text = decodedMap["business_reg_no"];
          for (final stateData in loanModel.stateList) {
            if (stateData.id == decodedMap["business_state"]) {
              stateController.text = stateData.name ?? "";
              for (final cityData in loanModel.cityList) {
                if (cityData.id == decodedMap["business_district"]) {
                  cityController.text = cityData.name ?? "";
                  setState(() {});
                  break;
                }
              }
              break;
            }
          }

          // panNumberController.text = decodedMap["business_pan"];
        }
      } else {
        userTypeName = decodedType['userType'];
      }
      setState(() {});
    } else {
      await getUserProfile();
    }
  }

  Future<bool> getValue() async {
    currentStep.value = 1;
    return await false;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: WillPopScope(
        onWillPop: () => (!widget.isActive) ? HelperUtils().onWillPop(context) : getValue(),
        child: Scaffold(
          key: key,
          backgroundColor: Colors.white,
          appBar: !widget.isActive
              ? AppBar(
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  iconTheme: const IconThemeData(color: Colors.black),
                  title: Container(
                    width: 226,
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
                      Container(width: 50, height: 5, decoration: BoxDecoration(borderRadius: BorderRadius.circular(4), color: const Color(0xFFFE9CCA4))),
                      Container(width: 50, height: 5, decoration: BoxDecoration(borderRadius: BorderRadius.circular(4), color: const Color(0xFFFDA11E))),
                     // Container(width: 50, height: 5, decoration: BoxDecoration(borderRadius: BorderRadius.circular(4), color: const Color(0xFFFE9CCA4)))
                    ]),
                  ),
                  leading: IconButton(
                    onPressed: () async {
                      String mobileNumber = await SharePrefsHelper.getInstance(context)?.getStringValue("mobile") ?? "";
                      String userType = await SharePrefsHelper.getInstance(context)?.getStringValue("userType") ?? "0";
                      Navigator.pushAndRemoveUntil(
                          context, MaterialPageRoute(builder: (context) => RegistrationScreen(mobileNumber, '', userType, !widget.isActive ? true : false)), (Route<dynamic> route) => false);
                    },
                    icon: const Icon(Icons.keyboard_backspace_sharp),
                  ),
                )
              : null,
          body: SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    !widget.isActive
                        ? Center(child: WidgetUtils.appTextWidget(context: context, title: 'Business Details'.tr, fontWeight: FontWeight.w500, family: 'Graphik', fontSize: 18))
                        : Container(),
                    !widget.isActive ? const SizedBox(height: 14) : Container(),
                    WidgetUtils.appTextWidget(context: context, title: 'User Type'.tr, fontWeight: FontWeight.w500, family: 'Graphik', fontSize: 16),
                    const SizedBox(height: 08),
                    Container(
                      width: double.maxFinite,
                      height: 58,
                      alignment: Alignment.center,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(border: Border.all(color: const Color(0xFFCFCFCF), width: 1.2), borderRadius: BorderRadius.circular(4)),
                      child: userTypeList!.isEmpty
                          ? Container()
                          : DropdownButtonHideUnderline(
                              child: DropdownButton(
                                icon: const Icon(Icons.keyboard_arrow_down, size: 13.33),
                                alignment: AlignmentDirectional.topStart,
                                isDense: false,
                                isExpanded: true,
                                value: userTypeName.tr,
                                items: userTypeList!.map((e) => DropdownMenuItem(child: Text(e.title!), value: e.title)).toList(),
                                onChanged: (value) async {
                                  if (!widget.isActive) {
                                    setState(() {
                                      userTypeName = value!;
                                    });
                                  }
                                },
                              ),
                            ),
                    ),
                    userTypeName == "individual".tr ? Container() : buildBusinessUI(),
                    const SizedBox(height: 16),
                    WidgetUtils.buttonWidget(
                        context: context,
                        radius: 8,
                        title: widget.isActive ? "Update Profile".tr : 'Submit'.tr,
                        size: 18,
                        family: 'Graphik',
                        weight: FontWeight.w500,
                        callback: () async {
                          if (userTypeName != "individual".tr) {
                            if (businessType.isEmpty) {
                              WidgetUtils.errorDialog(context, 'Please Select Business Type'.tr);
                            } else if (businessScheme.isEmpty) {
                              WidgetUtils.errorDialog(context, 'Please Enter Scheme'.tr);
                            } else if (businessNameController.text.trim().isEmpty) {
                              WidgetUtils.errorDialog(context, 'Please Enter Business Name'.tr);
                            } else if (!spacialCharRegexp.hasMatch(businessNameController.text.toString().trim())) {
                              WidgetUtils.errorDialog(context, 'Please Enter Business Name'.tr);
                            } else if (businessDesignationController.text.trim().isEmpty) {
                              WidgetUtils.errorDialog(context, 'Please Enter Business Designation'.tr);
                            }
                            /* else if (!nameWithSpaceRegex.hasMatch(businessDesignationController.text.toString())) {
                              WidgetUtils.errorDialog(context, 'Please Enter Business Designation'.tr);
                            }*/
                            else if (businessAddressController.text.trim().toString().isEmpty) {
                              WidgetUtils.errorDialog(context, 'Please Enter address'.tr);
                            } else if (stateController.text.isEmpty) {
                              WidgetUtils.errorDialog(context, 'Please Enter State'.tr);
                            } else if (cityController.text.isEmpty) {
                              WidgetUtils.errorDialog(context, 'Select District'.tr);
                            } else if (villageController.text.trim().isEmpty) {
                              WidgetUtils.errorDialog(context, 'Enter Village Name'.tr);
                            } else if (!expression.hasMatch(pinCodeController.text.toString())) {
                              WidgetUtils.errorDialog(context, 'Please Enter postal code'.tr);
                            }
                            /*else if (registrationNumberController.text.trim().isEmpty) {
                              WidgetUtils.errorDialog(context, 'Please Enter Business Registration number'.tr);
                            } else if (!brnExpression.hasMatch(registrationNumberController.text)) {
                              WidgetUtils.errorDialog(context, 'Please Enter Valid Business Registration number'.tr);
                            }*/
                            /*else if (panNumberController.text.isEmpty) {
                              WidgetUtils.errorDialog(context, 'Enter Pan Card'.tr);
                            } else if (!panExpression.hasMatch(panNumberController.text)) {
                              WidgetUtils.errorDialog(context, 'Enter Valid Pan Card'.tr);
                            }
                            else if (gstNumberController.text.isEmpty) {
                              WidgetUtils.errorDialog(context, 'Please Enter GSTIN number'.tr);
                            } else if (!gstExpression.hasMatch(gstNumberController.text)) {
                              WidgetUtils.errorDialog(context, 'Please Enter Valid GSTIN number'.tr);
                            }*/ else {
                              isLoading.value = true;
                              setState(() {});
                              await registration();
                              isLoading.value = false;
                              setState(() {});
                            }
                          } else {
                            isLoading.value = true;
                            setState(() {});
                            await registration();
                            isLoading.value = false;
                            setState(() {});
                          }
                          setState(() {});
                        },
                        textColor: Color(int.parse(themeColor.value.buttonTextColor!.color!)),
                        color: Color(int.parse(themeColor.value.buttonColor!.color!))),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future registration() async {
    try {
      Map<String, dynamic> params = {
        'btn_submit': 'submit',
        'app_user_type': userTypeName == 'individual'.tr ? '1' : '0',
        'business_type': userTypeName == 'individual'.tr ? "" : businessType,
        'business_scheme': userTypeName == 'individual'.tr
            ? ""
            : businessScheme.isNotEmpty
                ? businessScheme
                : "",
        'business_name': businessNameController.text.isNotEmpty ? businessNameController.text : "",
        'business_designation': businessDesignationController.text.isNotEmpty ? businessDesignationController.text : "",
        'business_address': businessAddressController.text.isNotEmpty ? businessAddressController.text : "",
        'business_state': stateID != null ? stateID : "",
        'business_district': cityId != null ? cityId : "",
        'business_city_village': villageController.text.isNotEmpty ? villageController.text : "",
        'business_pincode': pinCodeController.text.isNotEmpty ? pinCodeController.text : "",
        'business_gstin': gstNumberController.text.isNotEmpty ? gstNumberController.text : "",
        // 'business_reg_no': registrationNumberController.text.isNotEmpty ? registrationNumberController.text : "",
        // 'business_pan': panNumberController.text,
        'step': '2',
        'id': userId,
        "edit_profile": (widget.isActive) ? "1" : "0"
      };
      final response = await APIService.postAPIMethod(url: ApiURL.profileStep1, params: params);
      final result = json.decode(response.body);
      if (result['success'] == 1) {
        Map<String, dynamic> step2 = {
          'business_type': userTypeName == 'individual'.tr ? "" : businessType,
          'business_scheme': userTypeName == 'individual'.tr
              ? ""
              : businessScheme.isNotEmpty
                  ? businessScheme
                  : "",
          'business_name': businessNameController.text.isNotEmpty ? businessNameController.text : "",
          'business_designation': businessDesignationController.text.isNotEmpty ? businessDesignationController.text : "",
          'business_address': businessAddressController.text.isNotEmpty ? businessAddressController.text : "",
          'business_state': stateID != null ? stateID : "",
          'business_district': cityId != null ? cityId : "",
          'business_city_village': villageController.text.isNotEmpty ? villageController.text : "",
          'business_pincode': pinCodeController.text.isNotEmpty ? pinCodeController.text : "",
          'business_gstin': gstNumberController.text.isNotEmpty ? gstNumberController.text : "",
          // 'business_reg_no': registrationNumberController.text.isNotEmpty ? registrationNumberController.text : "",
          // 'business_pan': panNumberController.text,
          'step': '2',
          'id': userId
        };
HeaderSingleton().businessType.value=userTypeName == 'individual'.tr ? "" : businessType;
        final details = {'userType': userTypeName == 'individual'.tr ? 'individual'.tr : 'business'.tr};
        await SharePrefsHelper.getInstance(context)?.saveStringValue("userTypeSelected", json.encode(details));
        await SharePrefsHelper.getInstance(context)?.saveStringValue("step2_data", json.encode(step2));
        await SharePrefsHelper.getInstance(context)?.saveStringValue("step2", "completed");
        await SharePrefsHelper.getInstance(context)?.saveStringValue("step1", "");
        await SharePrefsHelper.getInstance(context)!.saveBoolValue("address_check", isSameInfoStatus);
        WidgetUtils.successDialog(context, result['message']);
        await HelperUtils().getKYCStatus(() => setState(() {}));
       // if (widget.isActive) {
          currentStep.value = 1;
          Navigator.push(context, MaterialPageRoute(builder: (context) => const NavigationHomeScreen()));
        //} else {
         // Navigator.push(context, MaterialPageRoute(builder: (context) => const UserKYC()));
        //}
      } else {
        WidgetUtils.errorDialog(context, result['message']);
      }
    } catch (e) {
      // print(e.toString());
      rethrow;
    }
  }

  void showStateList(BuildContext context, String title, {bool isStateActive = true}) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Consumer<LoanProvider>(builder: (context, loanModel, child) {
            return StatefulBuilder(builder: (context, StateSetter setState) {
              return Dialog(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: Container(
                    height: 400,
                    width: 328,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 10),
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 16),
                          height: 370,
                          width: 328,
                          child: ListView(shrinkWrap: true, children: <Widget>[
                            Padding(
                                padding: const EdgeInsets.symmetric(vertical: 8.0),
                                child: Container(
                                  alignment: Alignment.topCenter,
                                  height: 48,
                                  padding: const EdgeInsets.only(bottom: 8.0),
                                  width: MediaQuery.of(context).size.width * 0.8,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(
                                        color: Color(int.parse(themeColor.value.barColor!.color!)),
                                      )),
                                  child: ListTile(
                                      dense: true,
                                      leading: const Icon(Icons.search),
                                      title: TextField(
                                        controller: controllerOne,
                                        decoration: InputDecoration(hintText: 'Search'.tr, border: InputBorder.none, hintStyle: TextStyle(fontSize: 16)),
                                        onChanged: (text) {
                                          isStateActive ? searchState.clear() : searchCity.clear();
                                          if (text.isEmpty) {
                                            setState(() {});
                                            return;
                                          }
                                          for (dynamic userDetail in isStateActive ? (loanModel.stateList) : loanModel.cityList) {
                                            if (userDetail.name.toUpperCase().contains(text.toUpperCase()) || userDetail.name.toLowerCase().contains(text.toLowerCase())) {
                                              isStateActive ? searchState.add(userDetail) : searchCity.add(userDetail);
                                            }
                                          }
                                          setState(() {});
                                        },
                                      ),
                                      trailing: InkWell(
                                          child: SvgPicture.asset("assets/images/cross.svg", height: 20),
                                          onTap: () {
                                            controllerOne.clear();
                                            isStateActive ? searchState.clear() : searchCity.clear();
                                            if ("".isEmpty) {
                                              setState(() {});
                                              return;
                                            }
                                            for (dynamic userDetail in isStateActive ? (loanModel.stateList) : loanModel.cityList) {
                                              if (userDetail.name.contains("")) isStateActive ? searchState.add(userDetail) : searchCity.add(userDetail);
                                            }
                                            setState(() {});
                                          })),
                                )),
                            SizedBox(
                              height: 370,
                              width: 550.0,
                              child: (isStateActive ? searchState.isNotEmpty || controller.text.isNotEmpty : searchCity.isNotEmpty || controllerOne.text.isNotEmpty)
                                  ? ListView.builder(
                                      shrinkWrap: true,
                                      itemCount: (isStateActive) ? searchState.length : searchCity.length,
                                      itemBuilder: (BuildContext context, int index) {
                                        return GestureDetector(
                                            onTap: () async {
                                              Navigator.pop(context);
                                              (isStateActive) ? stateController.text = searchState[index].name : cityController.text = searchCity[index].name;
                                              if (isStateActive) {
                                                cityController.text = "";
                                                cityId = "";
                                                final value = await HelperUtils().getCity(searchState[index].id, (value) {}, context);
                                                var loanModel = Provider.of<LoanProvider>(context, listen: false);
                                                loanModel.setCity(value ?? []);
                                              } else {
                                                cityController.text = searchCity[index].name;
                                                cityId = searchCity[index].id;
                                              }
                                              setState(() {});
                                            },
                                            child: Container(
                                                margin: const EdgeInsets.only(bottom: 8),
                                                alignment: Alignment.center,
                                                height: 48,
                                                width: MediaQuery.of(context).size.width * 0.8,
                                                decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.circular(8),
                                                    border: Border.all(
                                                      color: const Color(0xFFB7B7B7),
                                                    )),
                                                child: Text((isStateActive) ? searchState[index].name : searchCity[index].name,
                                                    textAlign: TextAlign.start, maxLines: 2, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 16.0))));
                                      },
                                    )
                                  : ListView.builder(
                                      shrinkWrap: true,
                                      itemCount: (isStateActive) ? loanModel.stateList.length : loanModel.cityList.length,
                                      itemBuilder: (BuildContext context, int index) {
                                        return GestureDetector(
                                            onTap: () async {
                                              Navigator.pop(context);
                                              if (isStateActive) {
                                                var loanModel = Provider.of<LoanProvider>(context, listen: false);
                                                stateController.text = loanModel.stateList[index].name;
                                                cityController.text = "";
                                                cityId = "";
                                                stateID = loanModel.stateList[index].id;
                                                final value = await HelperUtils().getCity(loanModel.stateList[index].id, (value) {}, context);
                                                loanModel.setCity(value ?? []);
                                              } else {
                                                cityController.text = loanModel.cityList[index].name;
                                                cityId = loanModel.cityList[index].id;
                                              }
                                              setState(() {});
                                            },
                                            child: Container(
                                                margin: const EdgeInsets.only(bottom: 8),
                                                alignment: Alignment.center,
                                                height: 48,
                                                width: MediaQuery.of(context).size.width * 0.8,
                                                decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.circular(8),
                                                    border: Border.all(
                                                      color: const Color(0xFFB7B7B7),
                                                    )),
                                                child: Text(
                                                  (isStateActive) ? loanModel.stateList[index].name : loanModel.cityList[index].name,
                                                  textAlign: TextAlign.start,
                                                  maxLines: 2,
                                                  overflow: TextOverflow.ellipsis,
                                                  style: const TextStyle(fontSize: 16.0),
                                                )));
                                      },
                                    ),
                            ),
                          ]),
                        )
                      ],
                    ),
                  ));
            });
          });
        });
  }

  Widget buildBusinessUI() {
    return Column(mainAxisAlignment: MainAxisAlignment.start, crossAxisAlignment: CrossAxisAlignment.start, children: [
      const SizedBox(height: 12),
      WidgetUtils.appTextWidget(context: context, title: 'Business Type'.tr, fontWeight: FontWeight.w500, family: 'Graphik', fontSize: 16),
      const SizedBox(height: 08),
      Container(
        width: double.maxFinite,
        height: 58,
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(border: Border.all(color: const Color(0xFFCFCFCF), width: 1.2), borderRadius: BorderRadius.circular(4)),
        child: masterListing!.data!.businessType!.isEmpty
            ? Container()
            : DropdownButtonHideUnderline(
                child: DropdownButton(
                  alignment: AlignmentDirectional.topStart,
                  isDense: false,
                  icon: const Icon(Icons.keyboard_arrow_down, size: 13.33),
                  isExpanded: true,
                  value: businessType,
                  items: masterListing!.data!.businessType!.map((e) => DropdownMenuItem(child: Text(e.title!), value: e.title)).toList(),
                  onChanged: (value) async {
                    setState(() {
                      businessType = value!;
                     if( businessType=="FPC") {
                       businessScheme= masterListing!.data!.fpcBusinessScheme![0].title!;
                     }else {
                       businessScheme= masterListing!.data!.businessScheme![0].title!;
                     }
                    });
                  },
                ),
              ),
      ),
      const SizedBox(height: 12),
      WidgetUtils.appTextWidget(context: context, title: 'Scheme'.tr, fontWeight: FontWeight.w500, family: 'Graphik', fontSize: 16),
      const SizedBox(height: 08),
      // Container(
      //   width: double.maxFinite,
      //   height: 58,
      //   alignment: Alignment.center,
      //   padding: const EdgeInsets.symmetric(horizontal: 16),
      //   decoration: BoxDecoration(border: Border.all(color: const Color(0xffCFCFCF)), borderRadius: BorderRadius.circular(4)),
      //   // margin: const EdgeInsets.only(right: 16),
      //   child: TextField(
      //     controller: schemeController,
      //     keyboardType: TextInputType.text,
      //     decoration: InputDecoration(
      //         labelStyle: const TextStyle(color: Colors.grey, fontSize: 16, fontFamily: 'Graphik', fontWeight: FontWeight.w400),
      //         hintStyle: const TextStyle(color: Colors.grey, fontSize: 16, fontFamily: 'Graphik', fontWeight: FontWeight.w400),
      //         hintText: 'Enter Scheme'.tr,
      //         border: InputBorder.none,
      //         counterText: ""),
      //     style: const TextStyle(color: Colors.black, fontSize: 16, fontFamily: 'Graphik', fontWeight: FontWeight.w400),
      //   ),
      // ),
      businessType=="FPC"?Container(
        width: double.maxFinite,
        height: 58,
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(border: Border.all(color: const Color(0xFFCFCFCF), width: 1.2), borderRadius: BorderRadius.circular(4)),
        child:masterListing!.data!.fpcBusinessScheme==null||masterListing!.data!.fpcBusinessScheme!.isEmpty
            ? Container()
            :masterListing!.data!.fpcBusinessScheme!=null? DropdownButtonHideUnderline(
          child: DropdownButton(
            icon: const Icon(Icons.keyboard_arrow_down, size: 13.33),
            alignment: AlignmentDirectional.topStart,
            isDense: false,
            isExpanded: true,
            value: businessScheme,
            items:(masterListing!.data!.fpcBusinessScheme??[]).map((e) => DropdownMenuItem(child: Text(e.title??""), value: e.title)).toList(),
            onChanged: (value) async {
              setState(() {
                businessScheme = value!;
              });
            },
          ),
        ):Container(),
      ):
      Container(
        width: double.maxFinite,
        height: 58,
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(border: Border.all(color: const Color(0xFFCFCFCF), width: 1.2), borderRadius: BorderRadius.circular(4)),
        child: masterListing!.data!.businessScheme!.isEmpty
            ? Container()
            : DropdownButtonHideUnderline(
                child: DropdownButton(
                  icon: const Icon(Icons.keyboard_arrow_down, size: 13.33),
                  alignment: AlignmentDirectional.topStart,
                  isDense: false,
                  isExpanded: true,
                  value: businessScheme,
                  items: masterListing!.data!.businessScheme!.map((e) => DropdownMenuItem(child: Text(e.title??""), value: e.title)).toList(),
                  onChanged: (value) async {
                    setState(() {
                      businessScheme = value!;
                    });
                  },
                ),
              ),
      ),
      const SizedBox(height: 12),
      WidgetUtils.appTextWidget(context: context, title: 'Business Name'.tr, fontWeight: FontWeight.w500, family: 'Graphik', fontSize: 16),
      const SizedBox(height: 08),
      Container(
        width: double.maxFinite,
        height: 58,
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(border: Border.all(color: const Color(0xffCFCFCF)), borderRadius: BorderRadius.circular(4)),
        // margin: const EdgeInsets.only(right: 16),
        child: TextField(
          controller: businessNameController,
          keyboardType: TextInputType.text,
          decoration: InputDecoration(
              labelStyle: const TextStyle(color: Colors.grey, fontSize: 16, fontFamily: 'Graphik', fontWeight: FontWeight.w400),
              hintStyle: const TextStyle(color: Colors.grey, fontSize: 16, fontFamily: 'Graphik', fontWeight: FontWeight.w400),
              hintText: 'Enter Business Name'.tr,
              border: InputBorder.none,
              counterText: ""),
          style: const TextStyle(color: Colors.black, fontSize: 16, fontFamily: 'Graphik', fontWeight: FontWeight.w400),
        ),
      ),
      const SizedBox(height: 12),
      WidgetUtils.appTextWidget(context: context, title: 'Business Designation'.tr, fontWeight: FontWeight.w500, family: 'Graphik', fontSize: 16),
      const SizedBox(height: 08),
      Container(
        width: double.maxFinite,
        height: 58,
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(border: Border.all(color: const Color(0xffCFCFCF)), borderRadius: BorderRadius.circular(4)),
        // margin: const EdgeInsets.only(right: 16),
        child: TextField(
          controller: businessDesignationController,
          keyboardType: TextInputType.text,
          // inputFormatters: [FilteringTextInputFormatter.allow(nameWithSpaceRegex)],
          decoration: InputDecoration(
              labelStyle: const TextStyle(color: Colors.grey, fontSize: 16, fontFamily: 'Graphik', fontWeight: FontWeight.w400),
              hintStyle: const TextStyle(color: Colors.grey, fontSize: 16, fontFamily: 'Graphik', fontWeight: FontWeight.w400),
              hintText: 'Enter Business Designation'.tr,
              border: InputBorder.none,
              counterText: ""),
          style: const TextStyle(color: Colors.black, fontSize: 16, fontFamily: 'Graphik', fontWeight: FontWeight.w400),
        ),
      ),
      const SizedBox(height: 12),
      SizedBox(height: MediaQuery.of(context).size.height * 0.012),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          WidgetUtils.appTextWidget(context: context, title: 'Business Address'.tr, fontWeight: FontWeight.w500, family: 'Graphik', fontSize: 16),
          const SizedBox(width: 10),
          SizedBox(
            child: Row(
              children: [
                SizedBox(
                  height: 17,
                  width: 17,
                  child: Checkbox(
                    checkColor: Colors.white,
                    value: isSameInfoStatus,
                    activeColor: Color(int.parse(themeColor.value.barColor!.color!)),
                    onChanged: (bool? value) async {
                      if (value!) {
                        final address = await SharePrefsHelper.getInstance(context)!.getStringValue("addressDetails");
                        isSameInfoStatus = true;
                        if (address != null && address.isNotEmpty) {
                          Map<String, dynamic> decodedMap = json.decode(address);
                          villageController.text = decodedMap["village"];
                          pinCodeController.text = decodedMap["pincode"];
                          businessAddressController.text = decodedMap["address"];
                          cityId = decodedMap["district"];
                          stateID = decodedMap["state"];
                          final loanModel = Provider.of<LoanProvider>(context, listen: false);
                          final value = await HelperUtils().getCity(stateID!, (value) {}, context);
                          loanModel.setCity(value ?? []);
                          for (final stateData in loanModel.stateList) {
                            if (stateData.id == stateID) {
                              stateController.text = stateData.name ?? "";
                              for (final cityData in loanModel.cityList) {
                                if (cityData.id == cityId) {
                                  cityController.text = cityData.name ?? "";
                                  setState(() {});
                                  break;
                                }
                              }
                              break;
                            }
                          }
                        }
                      } else {
                        isSameInfoStatus = false;

                        final address = await SharePrefsHelper.getInstance(context)!.getStringValue("step2_data");
                        if (address != null && address.isNotEmpty) {
                          Map<String, dynamic> decodedMap = json.decode(address);
                          villageController.text = decodedMap["business_city_village"];
                          pinCodeController.text = decodedMap["business_pincode"];
                          businessAddressController.text = decodedMap["business_address"];
                          cityId = decodedMap["business_district"];
                          stateID = decodedMap["business_state"];
                          final loanModel = Provider.of<LoanProvider>(context, listen: false);
                          final value = await HelperUtils().getCity(stateID!, (value) {}, context);
                          loanModel.setCity(value ?? []);

                          for (final stateData in loanModel.stateList) {
                            if (stateData.id == decodedMap["business_state"]) {
                              stateController.text = stateData.name ?? "";
                              for (final cityData in loanModel.cityList) {
                                if (cityData.id == decodedMap["business_district"]) {
                                  cityController.text = cityData.name ?? "";
                                  setState(() {});
                                  break;
                                }
                              }
                              break;
                            }
                          }
                        } else {
                          stateController.clear();
                          cityController.clear();
                          villageController.clear();
                          pinCodeController.clear();
                          businessAddressController.clear();
                        }
                      }
                      setState(() {});
                    },
                  ),
                ),
                const SizedBox(width: 8),
                WidgetUtils.appTextWidget(context: context, title: 'Same as Personal Address'.tr, fontSize: 12, fontWeight: FontWeight.w400, family: 'Graphik', textAlign: TextAlign.start),
              ],
            ),
          ),
        ],
      ),
      const SizedBox(height: 08),
      Container(
        width: double.maxFinite,
        height: 106,
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(border: Border.all(color: const Color(0xffCFCFCF)), borderRadius: BorderRadius.circular(4)),
        // margin: const EdgeInsets.only(right: 16),
        child: TextField(
          controller: businessAddressController,
          keyboardType: TextInputType.text,
          maxLines: 4,
          readOnly: isSameInfoStatus,
          decoration: InputDecoration(
              labelStyle: const TextStyle(color: Colors.grey, fontSize: 16, fontFamily: 'Graphik', fontWeight: FontWeight.w400),
              hintStyle: const TextStyle(color: Colors.grey, fontSize: 16, fontFamily: 'Graphik', fontWeight: FontWeight.w400),
              hintText: 'Enter Business Address'.tr,
              border: InputBorder.none,
              counterText: ""),
          style: const TextStyle(color: Colors.black, fontSize: 16, fontFamily: 'Graphik', fontWeight: FontWeight.w400),
        ),
      ),
      SizedBox(height: MediaQuery.of(context).size.height * 0.012),
      Row(
        // mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          InkWell(
            onTap: () {
              if (!isSameInfoStatus) {
                searchState.clear();
                searchCity.clear();
                controllerOne.clear();
                controller.clear();
                showStateList(context, 'Select State');
              }
            },
            child: Container(
              width: MediaQuery.of(context).size.width / 2.3,
              height: 50,
              alignment: Alignment.center,
              padding: const EdgeInsets.only(left: 16),
              decoration: BoxDecoration(border: Border.all(color: const Color(0xffCFCFCF), width: 1), borderRadius: BorderRadius.circular(4)),
              // margin: const EdgeInsets.only(right: 16),
              child: TextField(
                controller: stateController,
                keyboardType: TextInputType.text,
                enabled: false,
                readOnly: isSameInfoStatus,
                decoration: InputDecoration(suffixIcon: const Icon(Icons.keyboard_arrow_down), hintText: 'State'.tr, border: InputBorder.none, counterText: ""),
              ),
            ),
          ),
          const SizedBox(width: 12),
          InkWell(
            onTap: () {
              if (!isSameInfoStatus) {
                searchState.clear();
                searchCity.clear();
                controllerOne.clear();
                controller.clear();
                showStateList(context, 'Select District', isStateActive: false);
              }
            },
            child: Container(
              width: MediaQuery.of(context).size.width / 2.3,
              height: 50,
              alignment: Alignment.center,
              padding: const EdgeInsets.only(left: 16),
              decoration: BoxDecoration(border: Border.all(color: const Color(0xffCFCFCF), width: 1), borderRadius: BorderRadius.circular(4)),
              // margin: const EdgeInsets.only(right: 16),
              child: TextField(
                controller: cityController,
                keyboardType: TextInputType.text,
                enabled: false,
                readOnly: isSameInfoStatus,
                decoration: InputDecoration(suffixIcon: const Icon(Icons.keyboard_arrow_down), hintText: 'District'.tr, border: InputBorder.none, counterText: ""),
              ),
            ),
          ),
        ],
      ),
      SizedBox(height: MediaQuery.of(context).size.height * 0.012),
      Row(
        children: [
          Container(
            width: MediaQuery.of(context).size.width / 2.3,
            height: 58,
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(border: Border.all(color: const Color(0xffCFCFCF)), borderRadius: BorderRadius.circular(4)),
            // margin: const EdgeInsets.only(right: 16),
            child: TextField(
              controller: villageController,
              keyboardType: TextInputType.text,
              readOnly: isSameInfoStatus,
              decoration: InputDecoration(
                  labelStyle: const TextStyle(color: Colors.grey, fontSize: 16, fontFamily: 'Graphik', fontWeight: FontWeight.w400),
                  hintStyle: const TextStyle(color: Colors.grey, fontSize: 16, fontFamily: 'Graphik', fontWeight: FontWeight.w400),
                  hintText: 'Village/Town'.tr,
                  border: InputBorder.none,
                  counterText: ""),
              style: const TextStyle(color: Colors.black, fontSize: 16, fontFamily: 'Graphik', fontWeight: FontWeight.w400),
            ),
          ),
          const SizedBox(width: 12),
          Container(
            width: MediaQuery.of(context).size.width / 2.3,
            height: 58,
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(border: Border.all(color: const Color(0xffCFCFCF)), borderRadius: BorderRadius.circular(4)),
            // margin: const EdgeInsets.only(right: 16),
            child: TextField(
              controller: pinCodeController,
              keyboardType: TextInputType.number,
              maxLength: 6,
              readOnly: isSameInfoStatus,
              decoration: InputDecoration(
                  labelStyle: const TextStyle(color: Colors.grey, fontSize: 16, fontFamily: 'Graphik', fontWeight: FontWeight.w400),
                  hintStyle: const TextStyle(color: Colors.grey, fontSize: 16, fontFamily: 'Graphik', fontWeight: FontWeight.w400),
                  hintText: 'Postal Code'.tr,
                  border: InputBorder.none,
                  counterText: ""),
              style: const TextStyle(color: Colors.black, fontSize: 16, fontFamily: 'Graphik', fontWeight: FontWeight.w400),
            ),
          ),
        ],
      ),
      /*SizedBox(height: MediaQuery.of(context).size.height * 0.012),
      WidgetUtils.appTextWidget(context: context, title: 'Registration Number'.tr, fontWeight: FontWeight.w500, family: 'Graphik', fontSize: 16),
      const SizedBox(height: 08),
      Container(
        width: double.maxFinite,
        height: 58,
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(border: Border.all(color: const Color(0xffCFCFCF)), borderRadius: BorderRadius.circular(4)),
        // margin: const EdgeInsets.only(right: 16),
        child: TextField(
          controller: registrationNumberController,
          keyboardType: TextInputType.text,
          maxLength: 21,
          inputFormatters: [UpperCaseTextFormatter()],
          decoration: InputDecoration(
              labelStyle: const TextStyle(color: Colors.grey, fontSize: 16, fontFamily: 'Graphik', fontWeight: FontWeight.w400),
              hintStyle: const TextStyle(color: Colors.grey, fontSize: 16, fontFamily: 'Graphik', fontWeight: FontWeight.w400),
              hintText: 'Business Registration number'.tr,
              border: InputBorder.none,
              counterText: ""),
          style: const TextStyle(color: Colors.black, fontSize: 16, fontFamily: 'Graphik', fontWeight: FontWeight.w400),
        ),
      ),*/
      /* SizedBox(height: MediaQuery.of(context).size.height * 0.012),
      WidgetUtils.appTextWidget(context: context, title: 'PAN number'.tr, fontWeight: FontWeight.w500, family: 'Graphik', fontSize: 16),
      const SizedBox(height: 08),
      Container(
        width: double.maxFinite,
        height: 58,
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(border: Border.all(color: const Color(0xffCFCFCF)), borderRadius: BorderRadius.circular(4)),
        // margin: const EdgeInsets.only(right: 16),
        child: TextField(
          controller: panNumberController,
          keyboardType: TextInputType.text,
          maxLength: 10,
          inputFormatters: [UpperCaseTextFormatter()],
          decoration: InputDecoration(
              labelStyle: const TextStyle(color: Colors.grey, fontSize: 16, fontFamily: 'Graphik', fontWeight: FontWeight.w400),
              hintStyle: const TextStyle(color: Colors.grey, fontSize: 16, fontFamily: 'Graphik', fontWeight: FontWeight.w400),
              hintText: 'Pan card'.tr,
              border: InputBorder.none,
              counterText: ""),
          style: const TextStyle(color: Colors.black, fontSize: 16, fontFamily: 'Graphik', fontWeight: FontWeight.w400),
        ),
      ),*/
      SizedBox(height: MediaQuery.of(context).size.height * 0.012),
      WidgetUtils.appTextWidget(context: context, title: 'GSTIN'.tr, fontWeight: FontWeight.w500, family: 'Graphik', fontSize: 16),
      const SizedBox(height: 08),
      Container(
        width: double.maxFinite,
        height: 58,
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(border: Border.all(color: const Color(0xffCFCFCF)), borderRadius: BorderRadius.circular(4)),
        // margin: const EdgeInsets.only(right: 16),
        child: TextField(
          controller: gstNumberController,
          keyboardType: TextInputType.text,
          maxLength: 15,
          inputFormatters: [UpperCaseTextFormatter()],
          decoration: InputDecoration(
              labelStyle: const TextStyle(color: Colors.grey, fontSize: 16, fontFamily: 'Graphik', fontWeight: FontWeight.w400),
              hintStyle: const TextStyle(color: Colors.grey, fontSize: 16, fontFamily: 'Graphik', fontWeight: FontWeight.w400),
              hintText: 'Enter Business GSTIN'.tr,
              border: InputBorder.none,
              counterText: ""),
          style: const TextStyle(color: Colors.black, fontSize: 16, fontFamily: 'Graphik', fontWeight: FontWeight.w400),
        ),
      ),
    ]);
  }
}
