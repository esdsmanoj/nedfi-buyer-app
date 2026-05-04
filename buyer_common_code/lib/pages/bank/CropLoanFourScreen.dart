import 'package:buyer_common_code/app_imports.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class CropLoanFourScreen extends StatefulWidget {
  const CropLoanFourScreen({Key? key}) : super(key: key);

  @override
  _CropLoanFourScreenState createState() => _CropLoanFourScreenState();
}

class _CropLoanFourScreenState extends State<CropLoanFourScreen> {
  File? imageFileOne;
  ValueNotifier<bool> isLoading = ValueNotifier(false);
  String _loadingText = "Loading details";
  TextEditingController? firstnameController;

  @override
  void initState() {
    super.initState();
    _loadingText = 'Loading . . .';
    firstnameController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return CustomProgressHandler(
        isLoading: isLoading.value,
        loadingText: _loadingText,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: SizedBox(
              child: Column(
                children: [
                  SizedBox(
                    child: Visibility(
                      visible: false,
                      child: Container(
                          decoration: BoxDecoration(color: Colors.white, border: Border.all(color: Theme.of(context).primaryColor, width: 1.0), borderRadius: BorderRadius.circular(14)),
                          child: Row(
                            children: <Widget>[
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.fromLTRB(8.0, 0, 8.0, 0),
                                  child: TextField(
                                    keyboardType: TextInputType.text,
                                    textAlign: TextAlign.start,
                                    controller: firstnameController,
                                    //  focusNode: _firstnameFocusNode,
                                    maxLength: 50,
                                    decoration: InputDecoration(
                                      isCollapsed: false,
                                      counter: Container(),
                                      border: InputBorder.none,
                                      hintText: 'First Name'.tr,
                                      hintStyle: Theme.of(context).textTheme.bodyText2!.copyWith(
                                            color: Colors.grey,
                                            fontSize: 18,
                                          ),
                                      labelStyle: Theme.of(context).textTheme.bodyText1!.copyWith(
                                            fontSize: 18,
                                          ),
                                    ),
                                    style: Theme.of(context).textTheme.bodyText1!.copyWith(),
                                  ),
                                ),
                              )
                            ],
                          )),
                    ),
                  ),
                  Stack(
                    alignment: Alignment.topRight,
                    children: [
                      Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                              color: Colors.white, border: Border.all(color: Colors.grey), borderRadius: BorderRadius.circular(6.0), boxShadow: [const BoxShadow(color: Colors.blueAccent)]),
                          child: imageFileOne != null
                              ? InkWell(
                                  onTap: () {
                                    _showDialogZoomImageOne(context);
                                  },
                                  child: ClipRRect(
                                      borderRadius: BorderRadius.circular(6.0),
                                      child: Image(
                                        image: FileImage(imageFileOne!),
                                        fit: BoxFit.cover,
                                      )),
                                )
                              : IconButton(
                                  icon: const Icon(Icons.camera_alt),
                                  iconSize: 50.0,
                                  onPressed: () {
                                    chooseFileSelection(0);
                                  },
                                ))
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        width: 100,
                        height: 50,
                        child: CustomDarkButton(
                          onPressed: () {
                            back();
                          },
                          caption: 'Back'.tr,
                        ),
                      ),
                      SizedBox(
                        width: 140,
                        height: 50,
                        child: CustomDarkButton(
                          onPressed: () async {
                            await applyLoan();
                          },
                          caption: 'Submit'.tr,
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ));
  }

  void back() {
    var loanModel = Provider.of<LoanProvider>(context, listen: false);
    if (loanModel.pageIndex == 6) {
      loanModel.setPageIndex(5);
      // //print("loanModel.pageIndex11" + loanModel.pageIndex.toString());
    } else {
      loanModel.setPageIndex(3);
      // //print("loanModel.pageIndex22" + loanModel.pageIndex.toString());
    }
//// //print("loanModel.pageIndex"+loanModel.pageIndex.toString());
  }

  void chooseFileSelection(int index) async {
    showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext ctx) {
          return Dialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Container(
              height: 250,
              width: 328,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          WidgetUtils.appTextWidget(context: context, title: 'Camera'.tr, color: Colors.black, fontSize: 18, family: 'Graphik', fontWeight: FontWeight.w500),
                          InkWell(
                              onTap: () {
                                Navigator.pop(ctx);
                              },
                              child: SvgPicture.asset("assets/images/cross.svg", height: 20))
                        ],
                      )),
                  InkWell(
                      onTap: () async {
                        final filePath = await HelperUtils().getFromCamera(ctx, 0);
                        if (filePath != null) {
                          setState(() {
                            imageFileOne = File(filePath.path);
                            Navigator.pop(ctx);
                          });
                        }
                      },
                      child: Container(
                        height: 50,
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Icon(Icons.camera_alt, color: Color(int.parse(themeColor.value.iconColor!.color!))),
                            const SizedBox(width: 20),
                            WidgetUtils.appTextWidget(context: context, title: 'Take A New Picture'.tr, fontSize: 16, family: 'Graphik'),
                          ],
                        ),
                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(4), border: Border.all(width: 1.2, color: Colors.grey)),
                      )),
                  InkWell(
                      onTap: () async {
                        final filePath = await HelperUtils().getFromGallery(ctx, 1);
                        if (filePath != null) {
                          setState(() {
                            imageFileOne = File(filePath.path);
                            Navigator.pop(ctx);
                          });
                        }
                      },
                      child: Container(
                        height: 50,
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Icon(Icons.photo, color: Color(int.parse(themeColor.value.iconColor!.color!))),
                            const SizedBox(width: 20),
                            WidgetUtils.appTextWidget(context: context, title: 'Pick From Gallery'.tr, fontSize: 16, family: 'Graphik'),
                          ],
                        ),
                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(4), border: Border.all(width: 1.2, color: Colors.grey)),
                      )),
                  const SizedBox(height: 10),
                ],
              ),
            ),
          );
        });
  }

  void _showDialogZoomImageOne(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(builder: (context, StateSetter setState) {
            return AlertDialog(
                content: SizedBox(
              height: MediaQuery.of(context).size.height * 0.4,
              width: MediaQuery.of(context).size.width * 0.5,
              child: Image(image: FileImage(imageFileOne!), fit: BoxFit.cover),
            ));
          });
        });
  }

  Future applyLoan() async {
    isLoading.value = true;

    try {
      final loanModel = Provider.of<LoanProvider>(context, listen: false);
      final request = http.MultipartRequest('POST', Uri.parse(baseURL + ApiURL.addLoanDetailsNew));

      if (imageFileOne?.path != "") {
        if (imageFileOne?.path != null) {
          request.files.add(await http.MultipartFile.fromPath('crop_weight_image1', imageFileOne!.path));
        }
      }
      request.headers["client-type"] = "buyer";
      request.headers["X-API-KEY"] = HeaderSingleton().xAPIKey.value;
      request.headers["domain"] = HeaderSingleton().domain.value;
      request.headers["appname"] = HeaderSingleton().appName.value;
      request.fields["user_id"] = HeaderSingleton().paramsMaps!.userId!;
      request.fields["loan_type_id"] = loanModel.loanTypeID;
      request.fields["Type_of_Crop"] = loanModel.cropType; //userUnitController!.text.toString();
      request.fields["Tie_Up_Agreement"] = loanModel.tieUpAgreeent;
      request.fields["Loan_Amount_Required"] = loanModel.loanAmount;
      request.fields["first_name"] = loanModel.firstName;
      request.fields["last_name"] = loanModel.lastName;
      request.fields["contact_no"] = loanModel.mobile;
      request.fields["alternate_contact_no"] = loanModel.altermobile;
      request.fields["co_applicant_first_name"] = loanModel.cofirstName;
      request.fields["co_applicant_last_name"] = loanModel.colastName;
      request.fields["co_applicant_contact_no"] = loanModel.comobile;
      request.fields["co_applicant_alternate_contact_no"] = loanModel.coaltermobile;
      request.fields["btn_submit"] = "submit";

      request.fields["annual_agriculture_income"] = loanModel.annuleAgriIncome;
      request.fields["other_annual_income_if_any"] = loanModel.otherIncome;
      request.fields["total_income"] = loanModel.totalIncome;
      request.fields["Loan_Amount_Required"] = loanModel.loanAmount;
      request.fields["village_city"] = loanModel.village;
      request.fields["survey_block_number"] = loanModel.surveyNumberController;
      request.fields["owned_land_in_acres"] = loanModel.landSharedLeasedController;
      request.fields["land_shared_leased_in_acres"] = loanModel.landSharedLeasedController;

      request.fields["shared_in_acres"] = loanModel.sharedAreaController;
      request.fields["total_area_in_acres"] = loanModel.totalAreaController;
      request.fields["irrigated_area_in_acres"] = loanModel.irrigatedAreaController;
      request.fields["source_of_irrigation"] = loanModel.irrigationSourceController;
      request.fields["encumbrance_if_any"] = loanModel.encumbrancController;
      request.fields["email"] = loanModel.email;
      request.fields["dob"] = loanModel.dob;
      request.fields["gender"] = loanModel.gender;

      request.fields["father_husband_spouse_name"] = loanModel.father;
      request.fields["postcode"] = loanModel.postal;
      request.fields["address1"] = loanModel.address;
      request.fields["address2"] = loanModel.co_address;
      request.fields["country"] = loanModel.country;
      request.fields["state"] = loanModel.state;
      request.fields["city"] = loanModel.village;
      request.fields["village"] = loanModel.villageController;

      request.fields["co_applicant_email"] = loanModel.co_email;
      request.fields["co_applicant_date_of_birth"] = loanModel.co_dob;
      request.fields["co_applicant_gender"] = loanModel.co_gender;
      request.fields["co_applicant_father_or_husband_or_spouse_name"] = loanModel.co_father;
      request.fields["co_applicant_postcode"] = loanModel.co_postal;
      request.fields["co_applicant_address1"] = loanModel.co_address;
      request.fields["co_applicant_address2"] = loanModel.co_address;
      request.fields["co_applicant_country"] = loanModel.co_countr;
      request.fields["co_applicant_state"] = loanModel.co_state;
      request.fields["co_applicant_city"] = loanModel.co_village;
      request.fields["co_applicant_village"] = loanModel.co_village;
      request.fields["aadhar_no"] = loanModel.aadharCard;
      request.fields["pan_no"] = loanModel.panCard;
      request.fields["Loan_Amount_Required"] = loanModel.loanAmountRequired;
      request.fields["Registration_Cost"] = loanModel.registionCost;
      request.fields["Combine_Harvestor_make"] = loanModel.combinHarvMake;
      request.fields["ex_showroom_price"] = loanModel.exShowroomPrice;
      request.fields["cost_of_accessories"] = loanModel.costofAccessories;
      request.fields["Type_of_Combine_Harvestor"] = loanModel.typeofHarvester;
      request.fields["Combine_Harvestor_model"] = loanModel.tractorModel;
      request.fields["Fuel_Energy_Type"] = loanModel.fuleEnergyCost;
      request.fields["Tie_Up_Agreement"] = loanModel.tieUpAgreeent;
      request.fields["Loan_Amount_Required"] = loanModel.loanAmountRequired;
      request.fields["Cost_of_Project"] = loanModel.costofProjrct;
      request.fields["cost_of_accessories"] = loanModel.costofAccessories;
      request.fields["Type_of_Combine_Harvestor"] = loanModel.typeofHarvester;
      request.fields["Combine_Harvestor_model"] = loanModel.tractorModel;
      request.fields["traactor_company"] = loanModel.tractorCompany;
      request.fields["traactor_model"] = loanModel.tractorModel;
      request.fields["ex_showroom_price"] = loanModel.exShowroomPrice;
      request.fields["insurance_charges"] = loanModel.insurancecharges;
      request.fields["cost_of_accessories"] = loanModel.costofAccessories;
      request.fields["Loan_Amount_Required"] = loanModel.loanAmountRequired;
      request.fields["type_of_horse_power"] = loanModel.horsePowertype;

      // //print(request.fields);
      await request.send().then((response) async {
        // listen for response
        response.stream.transform(utf8.decoder).listen((value) {
          // //print(value);
          var data = json.decode(value);
          // //print(Commen.fromJson(data).toJson());
          var res = CommonModel.fromJson(data);
          if (res.success == 1) {
            HeaderSingleton().setStatusInfo(false);
            WidgetUtils.successDialog(context, res.message);
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const NavigationHomeScreen()));
          } else {
            WidgetUtils.errorDialog(context, res.message);
          }
        });
      }).catchError((e) {
        isLoading.value = false;
        // //print(e);
      });
      isLoading.value = false;
    } catch (e) {
      // //print(e.toString());
      isLoading.value = false;
      //   }
    }
  }
}
