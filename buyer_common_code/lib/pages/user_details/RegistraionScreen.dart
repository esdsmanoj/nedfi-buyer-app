import 'package:buyer_common_code/pages/user_details/business_details.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../../app_imports.dart';
import '../../model/CityResponse.dart';
import '../../model/StateResponse.dart';
import '../../model/user_profile_details.dart';

class RegistrationScreen extends StatefulWidget {
  final String mobileNumber, referral, appUserType;
  final bool isActive;

  const RegistrationScreen(this.mobileNumber, this.referral, this.appUserType, this.isActive, {Key? key}) : super(key: key);

  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  TextEditingController? firstNameController, addressController, villageController, pinCodeController, lastNameController, companyNameController;
  String local = "en";
  TextEditingController genderController = TextEditingController(),
      stateController = TextEditingController(),
      cityController = TextEditingController(),
      dobController = TextEditingController(),
      controller = TextEditingController(),
      controllerOne = TextEditingController();
  int _groupValue = -1;
  String? stateID, cityId;

  List<StateData> searchState = [];
  List<CityData> searchCity = [];
  late double height;
  File? profileFile;
  String? mobileNumber;
  ValueNotifier<String> profileImage = ValueNotifier('');

  // var isFarmer = 0;

  @override
  void initState() {
    isLoading.value = true;
    setState(() {});
    HelperUtils().getState((value) {}, context);
    firstNameController = TextEditingController();
    lastNameController = TextEditingController();
    companyNameController = TextEditingController();
    pinCodeController = TextEditingController();
    addressController = TextEditingController();
    villageController = TextEditingController();
    getLocalise(context);
    if (!widget.isActive) {
      getUserProfile();
    }
    isLoading.value = false;
    setState(() {});
    super.initState();
  }

  Future<String> getLocalise(BuildContext context) async {
    local = (await SharePrefsHelper.getInstance(context)?.getStringValue("locale"))!;
    final address = await SharePrefsHelper.getInstance(context)!.getStringValue("step1_data");
    mobileNumber = await SharePrefsHelper.getInstance(context)?.getStringValue("mobile") ?? "";
    HeaderSingleton().setAppUserType(await SharePrefsHelper.getInstance(context)?.getStringValue("userType") ?? "0");
    if (address != null && address.isNotEmpty) {
      Map<String, dynamic> decodedMap = json.decode(address);
      firstNameController!.text = decodedMap["firstName"];
      lastNameController!.text = decodedMap["last_name"];
      mobileNumber = decodedMap["phone"];
      stateID = decodedMap["state"];
      //print(stateID! + ":State");
      final loanModel = Provider.of<LoanProvider>(context, listen: false);
      final value = await HelperUtils().getCity(stateID!, (value) {}, context);
      loanModel.setCity(value!);
      cityId = decodedMap["district"];
      cityController.text = decodedMap["district"];
      villageController!.text = decodedMap["village"];
      pinCodeController!.text = decodedMap["pincode"];
      addressController!.text = decodedMap['address'];
      profileImage.value = decodedMap["image"];

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
    return local;
  }

  Future getUserProfile() async {
    try {
      final response = await APIService.getAPIMethod(url: "${ApiURL.getUserProfile}/$userId");
      final res = UserProfileDetails.fromJson(json.decode(response.body));
      if (res.success == 1 && res.data != null) {
        final address = await SharePrefsHelper.getInstance(context)!.getStringValue("step1_data");
        if (address != null && address.isNotEmpty) {
          Map<String, dynamic> decodedMap = json.decode(address);
          decodedMap['image'] = res.imagePath! + (res.data![0].profileImage ?? "");
          await SharePrefsHelper.getInstance(context)?.saveStringValue("step1_data", json.encode(decodedMap));
        }
        stateID = res.data![0].state ?? "";
        cityId = res.data![0].city ?? "";
        final loanModel = Provider.of<LoanProvider>(context, listen: false);
        final value = await HelperUtils().getCity(stateID!, (value) {}, context);
        loanModel.setCity(value!);
        firstNameController!.text = res.data![0].firstName ?? "";
        lastNameController!.text = res.data![0].lastName ?? "";
        mobileNumber = widget.mobileNumber.isNotEmpty ? widget.mobileNumber : mobileNumber;
        cityController.text = res.data![0].city ?? "";
        villageController!.text = res.data![0].village ?? "";
        pinCodeController!.text = res.data![0].postcode ?? "";
        addressController!.text = res.data![0].address1 ?? "";
        profileImage.value = res.imagePath! + (res.data![0].profileImage ?? "");
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
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> getValue(BuildContext ctx) async {
    return (await HelperUtils().showNormalDialog(
            context: ctx,
            title: 'Are_you_sure'.tr,
            content: 'Do you want to abort'.tr,
            onYesTapped: (value) async {
              currentStep.value = 1;
              Navigator.pop(value);
              Navigator.pop(ctx);
            })) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    return WillPopScope(
        onWillPop: () {
          return widget.isActive ? HelperUtils().onWillPop(context) : getValue(context);
        },
        child: CustomProgressHandler(
            isLoading: isLoading.value,
            loadingText: "",
            child: Scaffold(
                key: const Key('registration_screen'),
                backgroundColor: Colors.white,
                resizeToAvoidBottomInset: true,
                appBar: widget.isActive
                    ? AppBar(
                        elevation: 0,
                        backgroundColor: Colors.white,
                        title: Container(
                          width: 226,
                          padding: const EdgeInsets.symmetric(horizontal: 24),
                          child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
                            Container(width: 50, height: 5, decoration: BoxDecoration(borderRadius: BorderRadius.circular(4), color: const Color(0xFFFDA11E))),
                            Container(width: 50, height: 5, decoration: BoxDecoration(borderRadius: BorderRadius.circular(4), color: const Color(0xFFFE9CCA4))),
                            Container(width: 50, height: 5, decoration: BoxDecoration(borderRadius: BorderRadius.circular(4), color: const Color(0xFFFE9CCA4)))
                          ]),
                        ),
                        leading: IconButton(
                          onPressed: () async {
                            String mobileNumber = await SharePrefsHelper.getInstance(context)?.getStringValue("mobile") ?? "";
                            String userType = await SharePrefsHelper.getInstance(context)?.getStringValue("userType") ?? "0";
                            HelperUtils().onWillPop(context);
                          },
                          icon: const Icon(Icons.keyboard_backspace_sharp),
                        ),
                        iconTheme: const IconThemeData(color: Colors.black),
                      )
                    : null,
                body: SafeArea(child: SingleChildScrollView(child: stepFirst())))));
  }

  Widget stepFirst() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
              child: GestureDetector(
            onTap: () {
              if (profileFile == null) {
                HelperUtils().chooseFileSelection(0, context, getResult: (value) {
                  profileImage.value = "";
                  profileFile = value.item1;
                  setState(() {});
                  Navigator.pop(value.item2);
                });
              }
            },
            child: Container(
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(100), border: Border.all(color: const Color(0xffCFCFCF))),
                alignment: Alignment.center,
                height: 80,
                width: 80,
                child: profileFile != null || profileImage.value != null
                    ? Stack(
                        // clipBehavior: Clip.none,
                        fit: StackFit.expand,
                        children: [
                          ClipOval(
                            child: profileFile != null && profileFile!.path.isNotEmpty
                                ? Image(image: FileImage(profileFile!), fit: BoxFit.cover)
                                : ValueListenableBuilder(
                                    valueListenable: profileImage,
                                    builder: (ctx, imageName, child) {
                                      return imageName.isNotEmpty
                                          ? CachedNetworkImage(
                                              imageUrl: imageName,
                                              imageBuilder: (context, imageProvider) => Container(
                                                height: 110,
                                                width: 110,
                                                decoration: BoxDecoration(image: DecorationImage(image: imageProvider, fit: BoxFit.fill)),
                                              ),
                                              placeholder: (context, url) => Image.file(File(image), fit: BoxFit.fill),
                                              errorWidget: (context, url, error) => Image.asset("assets/images/user.png", fit: BoxFit.fill),
                                            )
                                          : Container();
                                    }),
                          ),
                          Positioned(
                              bottom: -2,
                              right: 4,
                              child: InkWell(
                                  onTap: () => HelperUtils().chooseFileSelection(0, context, getResult: (value) {
                                        profileImage.value = "";
                                        profileFile = value.item1;
                                        setState(() {});
                                        Navigator.pop(value.item2);
                                      }),
                                  child: SizedBox(height: 34, child: CircleAvatar(backgroundColor: Colors.white, child: SvgPicture.asset("assets/images/camera.svg", height: 12))))),
                        ],
                      )
                    : SvgPicture.asset("assets/images/camera.svg", height: 21.4)),
          )),
          const SizedBox(height: 10),
          Center(child: WidgetUtils.appTextWidget(context: context, title: 'Upload Profile picture'.tr, fontWeight: FontWeight.w500, family: 'Graphik', fontSize: 15)),
          const SizedBox(height: 10),
          Center(
              child: WidgetUtils.appTextWidget(context: context, title: 'jpg,png,jpeg | limit 2MB'.tr, fontWeight: FontWeight.w400, family: 'Graphik', fontSize: 12, color: const Color(0xFFA0A0A0))),
          SizedBox(height: height * 0.012),
          buildPersonalInfo(),
          const SizedBox(height: 50),
          WidgetUtils.buttonWidget(
              context: context,
              radius: 8,
              title: 'Next'.tr,
              size: 18,
              family: 'Graphik',
              weight: FontWeight.w500,
              callback: () async {
                if (profileImage.value.isEmpty) {
                  if (profileFile == null) {
                    WidgetUtils.errorDialog(context, 'Please select image'.tr);
                  } else if (profileFile!.path.isEmpty) {
                    WidgetUtils.errorDialog(context, 'Please select image'.tr);
                  } else {
                    otherValidation();
                  }
                } else {
                  otherValidation();
                }
                setState(() {});
              },
              textColor: Color(int.parse(themeColor.value.buttonTextColor!.color!)),
              color: Color(int.parse(themeColor.value.buttonColor!.color!)))
        ],
      ),
    );
  }

  otherValidation() async {
    if (firstNameController!.text.toString().trim().toString().isEmpty) {
      WidgetUtils.errorDialog(context, 'Please Enter FirstName'.tr);
    } else if (!nameRegex.hasMatch(firstNameController!.text.toString().trim())) {
      WidgetUtils.errorDialog(context, 'Please Enter FirstName'.tr);
    } else if (lastNameController!.text.trim().toString().isEmpty) {
      WidgetUtils.errorDialog(context, 'Please Enter LastName'.tr);
    } else if (!nameRegex.hasMatch(lastNameController!.text.toString().trim())) {
      WidgetUtils.errorDialog(context, 'Please Enter LastName'.tr);
    } else if (addressController!.text.toString().isEmpty) {
      WidgetUtils.errorDialog(context, 'Please Enter address'.tr);
    } else if (stateController.text.isEmpty) {
      WidgetUtils.errorDialog(context, 'Please Select State'.tr);
    } else if (cityController.text.isEmpty) {
      WidgetUtils.errorDialog(context, 'Select District'.tr);
    } else if (villageController!.text.trim().isEmpty) {
      WidgetUtils.errorDialog(context, 'Enter Village Name'.tr);
    } else if (pinCodeController!.text.toString().isEmpty) {
      WidgetUtils.errorDialog(context, 'Please Enter postal code'.tr);
    } else if (!expression.hasMatch(pinCodeController!.text.toString())) {
      WidgetUtils.errorDialog(context, 'Please Enter postal code'.tr);
    } else {
      isLoading.value = true;
      await HelperUtils().getKYCStatus(() => setState(() {}));
      await _registration();
      isLoading.value = false;
    }
  }

  Widget buildPersonalInfo() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        WidgetUtils.appTextWidget(context: context, title: 'key_name'.tr, fontWeight: FontWeight.w500, family: 'Graphik', fontSize: 16),
        const SizedBox(height: 08),
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
                controller: firstNameController,
                keyboardType: TextInputType.text,
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.allow(RegExp("[a-zA-Z]")),
                ],
                decoration: InputDecoration(
                    labelStyle: const TextStyle(color: Colors.grey, fontSize: 16, fontFamily: 'Graphik', fontWeight: FontWeight.w400),
                    hintStyle: const TextStyle(color: Colors.grey, fontSize: 16, fontFamily: 'Graphik', fontWeight: FontWeight.w400),
                    hintText: 'key_first_name'.tr,
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
                controller: lastNameController,
                keyboardType: TextInputType.text,
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.allow(RegExp("[a-zA-Z]")),
                ],
                decoration: InputDecoration(
                    labelStyle: const TextStyle(color: Colors.grey, fontSize: 16, fontFamily: 'Graphik', fontWeight: FontWeight.w400),
                    hintStyle: const TextStyle(color: Colors.grey, fontSize: 16, fontFamily: 'Graphik', fontWeight: FontWeight.w400),
                    hintText: 'Last name'.tr,
                    border: InputBorder.none,
                    counterText: ""),
                style: const TextStyle(color: Colors.black, fontSize: 16, fontFamily: 'Graphik', fontWeight: FontWeight.w400),
              ),
            ),
          ],
        ),
        SizedBox(height: height * 0.012),
        WidgetUtils.appTextWidget(context: context, title: 'Address'.tr, fontWeight: FontWeight.w500, family: 'Graphik', fontSize: 16),
        const SizedBox(height: 08),
        Container(
          width: double.maxFinite,
          height: 106,
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(border: Border.all(color: const Color(0xffCFCFCF)), borderRadius: BorderRadius.circular(4)),
          // margin: const EdgeInsets.only(right: 16),
          child: TextField(
            controller: addressController,
            keyboardType: TextInputType.text,
            maxLines: 4,
            decoration: InputDecoration(
                labelStyle: const TextStyle(color: Colors.grey, fontSize: 16, fontFamily: 'Graphik', fontWeight: FontWeight.w400),
                hintStyle: const TextStyle(color: Colors.grey, fontSize: 16, fontFamily: 'Graphik', fontWeight: FontWeight.w400),
                hintText: 'Enter Address'.tr,
                border: InputBorder.none,
                counterText: ""),
            style: const TextStyle(color: Colors.black, fontSize: 16, fontFamily: 'Graphik', fontWeight: FontWeight.w400),
          ),
        ),
        SizedBox(height: height * 0.012),
        Row(
          // mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            InkWell(
              onTap: () {
                searchState.clear();
                searchCity.clear();
                controllerOne.clear();
                controller.clear();
                showStateList(context, 'Select State');
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
                  decoration: InputDecoration(suffixIcon: const Icon(Icons.keyboard_arrow_down), hintText: 'State'.tr, border: InputBorder.none, counterText: ""),
                ),
              ),
            ),
            const SizedBox(width: 12),
            InkWell(
              onTap: () {
                if (stateController.text.isEmpty) {
                  WidgetUtils.errorDialog(context, "Please select state first");
                  setState(() {});
                } else {
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
                  decoration: InputDecoration(suffixIcon: const Icon(Icons.keyboard_arrow_down), hintText: 'District'.tr, border: InputBorder.none, counterText: ""),
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: height * 0.012),
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
                maxLength: 20,
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.allow(RegExp("[a-zA-Z]")),
                ],
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
        SizedBox(height: height * 0.012),
      ],
    );
  }

  Widget buildRadioButton({String? title, int? value, Function(int?)? onChanged}) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.35,
      height: 30,
      child: RadioListTile(
        value: value!,
        activeColor: const Color(0xff27914F),
        groupValue: _groupValue,
        onChanged: onChanged,
        title: WidgetUtils.appTextWidget(context: context, title: title!, color: Colors.black, fontSize: 16, family: 'Graphik', fontWeight: FontWeight.w400),
      ),
    );
  }

  Future _registration() async {
    try {
      var headerModel = HeaderSingleton();
      var request = http.MultipartRequest('POST', Uri.parse(baseURL + ApiURL.profileStep1));
      if (profileFile?.path != "") {
        if (profileFile?.path != null) {
          request.files.add(await http.MultipartFile.fromPath('profile_image', profileFile!.path));
        }
      }
      request.headers["client-type"] = "buyer";
      request.headers["X-API-KEY"] = headerModel.xAPIKey.value;
      request.headers["domain"] = headerModel.domain.value;
      request.headers["appname"] = headerModel.appName.value;
      request.headers["lang"] = headerModel.local;
      request.fields["first_name"] = firstNameController!.text.toString();
      request.fields["last_name"] = lastNameController!.text.toString();
      request.fields["phone"] = widget.mobileNumber.isEmpty ? mobileNumber! : widget.mobileNumber.toString();
      request.fields["state"] = stateID!;
      request.fields["district"] = cityId!;
      request.fields["village"] = villageController!.text.toString();
      request.fields["pincode"] = pinCodeController!.text.toString();
      request.fields["address"] = addressController!.text.toString();
      request.fields["step"] = "1";
      request.fields["id"] = userId;
      if (!widget.isActive) {
        request.fields["edit_profile"] = "1";
      }
      request.fields["btn_submit"] = "submit";

      Map<String, dynamic> step1 = {
        "firstName": firstNameController!.text,
        "last_name": lastNameController!.text,
        "phone": widget.mobileNumber.isEmpty ? mobileNumber! : widget.mobileNumber.toString(),
        "address": addressController!.text,
        "state": stateID!,
        "district": cityId!,
        "village": villageController!.text,
        "pincode": pinCodeController!.text,
        // "image": profileImage.value != null ? profileImage.value : profileFile!.path
      };
      await request.send().then((response) async {
        response.stream.transform(utf8.decoder).listen((value) async {
          var data = json.decode(value);
          var res = CommonModel.fromJson(data);
          if (res.success == 1) {
            String value = json.encode(step1);
            await SharePrefsHelper.getInstance(context)?.saveStringValue("step1_data", value);
            await SharePrefsHelper.getInstance(context)?.saveStringValue("step1", "completed");
            Map<String, dynamic> addressValues = {"address": addressController!.text, "state": stateID!, "district": cityId!, "village": villageController!.text, "pincode": pinCodeController!.text};
            String encodedMap = json.encode(addressValues);
            SharePrefsHelper.getInstance(context)?.saveStringValue("addressDetails", encodedMap);
            WidgetUtils.successDialog(context, res.message);
            HeaderSingleton().setUserAddress(addressController!.text.toString());
            await getUserProfile();
            if (!widget.isActive) {
              currentStep.value = 2;
            } else {
              Navigator.push(context, MaterialPageRoute(builder: (context) => const BusinessDetails(false)));
            }
          } else {
            WidgetUtils.errorDialog(context, res.message);
          }
          isLoading.value = false;
        });
      }).catchError((e) {
        // rethrow;
      });
    } catch (e) {
      // //print(e.toString());
      rethrow;
    }
  }

  void showDialogGender(BuildContext buildContext) {
    final cropType = ['Male'.tr, 'Female'.tr];
    showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext ctx) {
          return StatefulBuilder(builder: (context, StateSetter setState) {
            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              child: Container(
                height: 200,
                width: 328,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        WidgetUtils.appTextWidget(context: context, title: 'Select Gender'.tr, color: Colors.black, fontSize: 18),
                        InkWell(
                            onTap: () {
                              Navigator.pop(ctx);
                            },
                            child: SvgPicture.asset("assets/images/cross.svg", height: 20))
                      ],
                    ),
                    InkWell(
                        onTap: () {
                          genderController.text = cropType[0];
                          setState(() {});
                          Navigator.pop(ctx);
                        },
                        child: Container(
                          height: 50,
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              const Icon(Icons.male),
                              const SizedBox(width: 20),
                              WidgetUtils.appTextWidget(context: context, title: cropType[0], fontSize: 16, family: 'Graphik'),
                            ],
                          ),
                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(4), border: Border.all(width: 1.2, color: Colors.grey)),
                        )),
                    InkWell(
                        onTap: () {
                          genderController.text = cropType[1];
                          setState(() {});
                          Navigator.pop(ctx);
                        },
                        child: Container(
                          height: 50,
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              const Icon(Icons.female),
                              const SizedBox(width: 20),
                              WidgetUtils.appTextWidget(context: context, title: cropType[1], fontSize: 16, family: 'Graphik'),
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
        });
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
                    height: 420,
                    width: 328,
                    padding: const EdgeInsets.only(right: 5, left: 5, bottom: 15, top: 5),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 10),
                        Align(
                            alignment: Alignment.topRight,
                            child: Padding(
                              padding: const EdgeInsets.only(right: 16.0),
                              child: InkWell(child: SvgPicture.asset("assets/images/cross.svg", height: 20), onTap: () => Navigator.pop(context)),
                            )),
                        const SizedBox(height: 10),
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 16),
                          height: 330,
                          width: 328,
                          child: ListView(shrinkWrap: true, children: <Widget>[
                            Padding(
                                padding: const EdgeInsets.symmetric(vertical: 8.0),
                                child: Container(
                                  alignment: Alignment.center,
                                  padding: const EdgeInsets.only(bottom: 8),
                                  height: 48,
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
                                        decoration: InputDecoration(hintText: 'Search'.tr, border: InputBorder.none, hintStyle: const TextStyle(fontSize: 16)),
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
                              height: 330,
                              width: 550.0,
                              child: (isStateActive ? searchState.isNotEmpty || controller.text.isNotEmpty : searchCity.isNotEmpty || controllerOne.text.isNotEmpty)
                                  ? ListView.builder(
                                      padding: const EdgeInsets.only(bottom: 60),
                                      shrinkWrap: true,
                                      itemCount: (isStateActive) ? searchState.length : searchCity.length,
                                      itemBuilder: (BuildContext context, int index) {
                                        return GestureDetector(
                                            onTap: () async {
                                              Navigator.pop(context);
                                              (isStateActive) ? stateController.text = searchState[index].name : cityController.text = searchCity[index].name;
                                              if (isStateActive) {
                                                final value = await HelperUtils().getCity(searchState[index].id, (value) {}, context);
                                                var loanModel = Provider.of<LoanProvider>(context, listen: false);
                                                loanModel.setCity(value ?? []);
                                                stateID = searchState[index].id;
                                                cityController.clear();
                                              } else {
                                                cityId = searchCity[index].id;
                                              }
                                              setState(() {});
                                            },
                                            child: Container(
                                                margin: const EdgeInsets.only(bottom: 8),
                                                alignment: Alignment.center,
                                                height: 48,
                                                width: MediaQuery.of(context).size.width * 0.8,
                                                decoration: BoxDecoration(borderRadius: BorderRadius.circular(8), border: Border.all(color: const Color(0xFFB7B7B7))),
                                                child: Text((isStateActive) ? searchState[index].name : searchCity[index].name,
                                                    textAlign: TextAlign.start, maxLines: 2, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 16.0))));
                                      },
                                    )
                                  : ListView.builder(
                                      padding: const EdgeInsets.only(bottom: 60),
                                      shrinkWrap: true,
                                      itemCount: (isStateActive) ? loanModel.stateList.length : loanModel.cityList.length,
                                      itemBuilder: (BuildContext context, int index) {
                                        return GestureDetector(
                                            onTap: () async {
                                              Navigator.pop(context);
                                              if (isStateActive) {
                                                var loanModel = Provider.of<LoanProvider>(context, listen: false);
                                                stateController.text = loanModel.stateList[index].name;
                                                final value = await HelperUtils().getCity(loanModel.stateList[index].id, (value) {}, context);
                                                loanModel.setCity(value!);
                                                stateID = loanModel.stateList[index].id;
                                                cityController.clear();
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
}
