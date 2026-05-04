import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import '../../model/profile_model.dart';
import 'package:nedfi_seller_common_code/app_imports.dart';

class PersonalInfo extends StatefulWidget {
  final List<ProfileData> userDetails;
  Function(bool)? onStateChanged;
  dynamic profileFile;

  PersonalInfo({Key? key, required this.userDetails, this.onStateChanged, this.profileFile}) : super(key: key);

  @override
  State<PersonalInfo> createState() => _PersonalInfoState();
}

class _PersonalInfoState extends State<PersonalInfo> {
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController mobileNoController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController genderController = TextEditingController();
  TextEditingController dobController = TextEditingController();
  TextEditingController postalCodeController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState\
    firstNameController.text = widget.userDetails[0].firstName ?? "";
    lastNameController.text = widget.userDetails[0].lastName ?? "";
    mobileNoController.text = widget.userDetails[0].phone ?? "";
    addressController.text = widget.userDetails[0].address1 ?? "";
    postalCodeController.text = widget.userDetails[0].postcode ?? "";
    genderController.text = widget.userDetails[0].gender ?? "";
    dobController.text = widget.userDetails[0].dob ?? "";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return buildPersonalInfo();
  }

  Widget buildPersonalInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const SizedBox(height: 20),
        Expanded(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.only(left: 21, right: 15, bottom: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  const SizedBox(height: 29),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                          width: MediaQuery.of(context).size.width / 2.3,
                          child: WidgetUtils.appTextWidget(context: context, title: 'First Name'.tr, fontWeight: FontWeight.w500, family: 'Graphik', fontSize: 16)),
                      SizedBox(
                          width: MediaQuery.of(context).size.width / 2.3,
                          child: WidgetUtils.appTextWidget(context: context, title: 'Last Name'.tr, fontWeight: FontWeight.w500, family: 'Graphik', fontSize: 16)),
                    ],
                  ),
                  const SizedBox(height: 14),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width / 2.3,
                        height: 58,
                        alignment: Alignment.center,
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        decoration: BoxDecoration(border: Border.all(color: const Color(0xFFCFCFCF)), borderRadius: BorderRadius.circular(4)),
                        // margin: const EdgeInsets.only(right: 16),
                        child: TextField(
                          controller: firstNameController,
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                            hintText: 'First name'.tr,
                            border: InputBorder.none,
                            counterText: "",
                            labelStyle: const TextStyle(fontSize: 14, fontFamily: 'Graphik', fontWeight: FontWeight.w500), hintStyle: const TextStyle(fontSize: 16, fontFamily: 'Graphik', fontWeight: FontWeight.w500),
                          ),
                        ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width / 2.3,
                        height: 58,
                        alignment: Alignment.center,
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        decoration: BoxDecoration(border: Border.all(color: const Color(0xFFCFCFCF)), borderRadius: BorderRadius.circular(4)),
                        // margin: const EdgeInsets.only(right: 16),
                        child: TextField(
                          controller: lastNameController,
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                            hintText: 'Last name'.tr,
                            border: InputBorder.none,
                            counterText: "",
                            hintStyle: const TextStyle(fontSize: 16, fontFamily: 'Graphik', fontWeight: FontWeight.w500),
                            labelStyle: const TextStyle(fontSize: 14, fontFamily: 'Graphik', fontWeight: FontWeight.w500),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.016),
                  WidgetUtils.appTextWidget(context: context, title: 'Mobile no.'.tr, fontWeight: FontWeight.w500, family: 'Graphik', fontSize: 16),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.016),
                  Container(
                    width: double.maxFinite,
                    height: 58,
                    alignment: Alignment.center,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(border: Border.all(color: const Color(0xFFCFCFCF)), borderRadius: BorderRadius.circular(4)),
                    // margin: const EdgeInsets.only(right: 16),
                    child: TextField(
                      controller: mobileNoController,
                      keyboardType: TextInputType.number,
                      maxLength: 10,
                      enabled: false,
                      decoration: InputDecoration(
                        hintText: 'Mobile no.'.tr,
                        border: InputBorder.none,
                        counterText: "",
                        hintStyle: const TextStyle(fontSize: 16, fontFamily: 'Graphik', fontWeight: FontWeight.w500),
                        labelStyle: const TextStyle(fontSize: 14, fontFamily: 'Graphik', fontWeight: FontWeight.w500),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                          width: MediaQuery.of(context).size.width / 2.3,
                          child: WidgetUtils.appTextWidget(context: context, title: 'Date of birth'.tr, fontWeight: FontWeight.w500, family: 'Graphik', fontSize: 16)),
                      SizedBox(
                          width: MediaQuery.of(context).size.width / 2.3,
                          child: WidgetUtils.appTextWidget(context: context, title: 'Gender'.tr, fontWeight: FontWeight.w500, family: 'Graphik', fontSize: 16)),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      InkWell(
                        onTap: dialogSelectDOB,
                        child: Container(
                          width: MediaQuery.of(context).size.width / 2.3,
                          height: 58,
                          alignment: Alignment.center,
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          decoration: BoxDecoration(border: Border.all(color: const Color(0xFFCFCFCF)), borderRadius: BorderRadius.circular(4)),
                          // margin: const EdgeInsets.only(right: 16),
                          child: TextField(
                            controller: dobController,
                            keyboardType: TextInputType.number,
                            enabled: false,
                            decoration: const InputDecoration(hintStyle: TextStyle(fontSize: 16, fontFamily: 'Graphik', fontWeight: FontWeight.w500),
                                labelStyle: TextStyle(fontSize: 16, fontFamily: 'Graphik', fontWeight: FontWeight.w500),
                                hintText: 'DD/MM/YYYY', border: InputBorder.none, counterText: ""),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Container(
                        width: MediaQuery.of(context).size.width / 2.3,
                        height: 58,
                        alignment: Alignment.center,
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        decoration: BoxDecoration(border: Border.all(color: const Color(0xFFCFCFCF)), borderRadius: BorderRadius.circular(4)),
                        // margin: const EdgeInsets.only(right: 16),
                        child: InkWell(
                          onTap: () {
                            _showDialogGender(context);
                          },
                          child: TextField(
                            controller: genderController,
                            keyboardType: TextInputType.text,
                            enabled: false,
                            decoration: const InputDecoration(
                              suffixIcon: Icon(Icons.keyboard_arrow_down_sharp, size: 20, color: Color(0xFF9F9F9F)),
                              hintText: 'Select Gender',
                              border: InputBorder.none,
                              counterText: "",
                              hintStyle: TextStyle(fontSize: 16, fontFamily: 'Graphik', fontWeight: FontWeight.w500),
                              labelStyle: TextStyle(fontSize: 14, fontFamily: 'Graphik', fontWeight: FontWeight.w500),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.016),
                  WidgetUtils.appTextWidget(context: context, title: 'Address Details'.tr, fontWeight: FontWeight.w500, family: 'Graphik', fontSize: 16),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.016),
                  Container(
                    width: double.maxFinite,
                    height: 100,
                    alignment: Alignment.center,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(border: Border.all(color: const Color(0xFFCFCFCF)), borderRadius: BorderRadius.circular(4)),
                    // margin: const EdgeInsets.only(right: 16),
                    child: TextField(
                      controller: addressController,
                      keyboardType: TextInputType.text,
                      maxLines: 6,
                      decoration: InputDecoration(
                        hintText: 'Address'.tr,
                        border: InputBorder.none,
                        counterText: "",
                        labelStyle: const TextStyle(fontSize: 14, fontFamily: 'Graphik', fontWeight: FontWeight.w500),
                      ),
                    ),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.016),
                  WidgetUtils.appTextWidget(context: context, title: 'Postal Code.'.tr, fontWeight: FontWeight.w500, family: 'Graphik', fontSize: 16),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.016),
                  Container(
                    width: double.maxFinite,
                    height: 58,
                    alignment: Alignment.center,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(border: Border.all(color: const Color(0xFFCFCFCF)), borderRadius: BorderRadius.circular(4)),
                    // margin: const EdgeInsets.only(right: 16),
                    child: TextField(
                      controller: postalCodeController,
                      keyboardType: TextInputType.number,
                      maxLength: 6,
                      decoration: InputDecoration(
                        hintText: 'Postal Code.'.tr,
                        border: InputBorder.none,
                        counterText: "",
                        labelStyle: const TextStyle(fontSize: 14, fontFamily: 'Graphik', fontWeight: FontWeight.w500),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  InkWell(
                    onTap: ()async{
                      RegExp expression = RegExp('^[1-9][0-9]{5}');
                      RegExp nameRegex = RegExp(r"^[a-zA-Z]+$");
                      if (firstNameController.text.toString().isEmpty) {
                        WidgetUtils.errorDialog(context, 'Please Enter FirstName'.tr);
                      } else if (!nameRegex.hasMatch(firstNameController.text.toString())) {
                        WidgetUtils.errorDialog(context, 'Please Enter FirstName'.tr);
                      } else if (lastNameController.text.toString().isEmpty) {
                        WidgetUtils.errorDialog(context, 'Please Enter LastName'.tr);
                      } else if (!nameRegex.hasMatch(lastNameController.text.toString())) {
                        WidgetUtils.errorDialog(context, 'Please Enter LastName'.tr);
                      } else if (mobileNoController.text.toString().isEmpty) {
                        WidgetUtils.errorDialog(context, 'Please Enter Mobile no.'.tr);
                      } else if (dobController.text.toString().isEmpty) {
                        WidgetUtils.errorDialog(context, 'Please Enter date if birth'.tr);
                      } else if (genderController.text.toString().isEmpty) {
                        WidgetUtils.errorDialog(context, 'Please Enter gender'.tr);
                      } else if (postalCodeController.text.toString().isEmpty) {
                        WidgetUtils.errorDialog(context, 'Please Enter postal code'.tr);
                      } else if (addressController.text.toString().isEmpty) {
                        WidgetUtils.errorDialog(context, 'Please Enter address'.tr);
                      } else if (!expression.hasMatch(postalCodeController.text.toString())) {
                        WidgetUtils.errorDialog(context, 'Please Enter postal code'.tr);
                      } else {
                        await updateProfile();
                        getProfile();
                      }
                    },
                    child: Container(
                        width: double.maxFinite,
                        height: 58,
                        decoration: BoxDecoration(color: Color(int.parse(themeColor.value.buttonColor!.color!)), borderRadius: BorderRadius.circular(8)),
                        alignment: Alignment.center,
                        child: WidgetUtils.appTextWidget(context:context,title: "Continue".tr, fontSize: 16,fontWeight: FontWeight.w500, color: Color(int.parse(themeColor.value.buttonTextColor!.color!)),family: 'Graphik')),
                  )
                ],
              ),
            ),
          ),
        )
      ],
    );
  }

  void _showDialogGender(BuildContext buildContext) {
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
                            child:  SvgPicture.asset(
                               "assets/images/cross.svg",
                            height: 20,
                          ))
                      ],
                    ),
                    InkWell(
                        onTap: () {
                          genderController.text = cropType[0];
                          setState(() {});
                          Navigator.pop(ctx);
                        },
                        child: Container(
                          height: 58,
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
                          height: 58,
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

  void dialogSelectDOB() async {
    DateTime? pickedDate = await showDatePicker(
        context: context,
        initialDate: DateTime(DateTime.now().year - 13),
        firstDate: DateTime(1950),
        //DateTime.now() - not to allow to choose before today.
        lastDate: DateTime(DateTime.now().year - 13));

    if (pickedDate != null) {
      String formattedDate = DateFormat('dd-MM-yyyy').format(pickedDate);
      setState(() {
        dobController.text = formattedDate;
      });
    }
  }

  Future updateProfile() async {
    widget.onStateChanged!.call(true);
    try {
      var headerModel = HeaderSingleton();
      var request = http.MultipartRequest('POST', Uri.parse(baseURL + ApiURL.updateProfile));

      if (widget.profileFile?.path != "") {
        if (widget.profileFile?.path != null) {
          request.files.add(await http.MultipartFile.fromPath('profile_image', widget.profileFile!.path));
        }
      }

      request.headers["X-API-KEY"] = headerModel.xAPIKey.value;
      request.headers["domain"] = headerModel.domain.value;
      request.headers["client-type"] = "seller";
      request.headers["appname"] = headerModel.appName.value;
      request.fields["id"] = headerModel.paramsMaps!.userId!;
      request.fields["first_name"] = firstNameController.text.toString();
      request.fields["last_name"] = lastNameController.text.toString();
      request.fields["phone"] = mobileNoController.text.toString();
      request.fields["postcode"] = postalCodeController.text.toString();
      request.fields["address1"] = addressController.text.toString();
      request.fields["dob"] = dobController.text.toString();
      request.fields["gender"] = genderController.text.toString();
      request.fields["btn_submit"] = "submit";

      await request.send().then((response) async {
        response.stream.transform(utf8.decoder).listen((value) {
          var data = json.decode(value);
          var res = CommonModel.fromJson(data);
          if (res.success == 1) {
            WidgetUtils.successDialog(context, res.message);
            HeaderSingleton().setUserAddress(addressController.text.toString());
          } else {
            WidgetUtils.errorDialog(context, res.message);
          }
          widget.onStateChanged!.call(false);
        });
      }).catchError((e) {
        // print(e);
      });
    } catch (e) {
      // print(e.toString());
      widget.onStateChanged!.call(false);
    }
  }

  Future getProfile() async {
    try {
      final response = await APIService.getAPIMethod(url: ApiURL.getProfile + "/" + HeaderSingleton().paramsMaps!.userId!);
      final data = json.decode(response.body);
      final res = ProfileModel.fromJson(data);
      if (res.status == 1) {
        HeaderSingleton().setProfileDetails(res);
        // Provider.of<ProfileProvider>(context,listen: false).setData(res.data);
        setState(() {});
        // Provider.of<ProfileModel>(context, listen: false).setData(res.data);
      }
    } catch (e) {
      // print(e.toString());
      // // isLoading.value = false;
      setState(() {});
    }
  }
}
