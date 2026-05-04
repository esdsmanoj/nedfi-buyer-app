import 'package:buyer_common_code/app_imports.dart';
import 'package:buyer_common_code/components/widgets/base_widget.dart';
import 'package:get/get.dart';

import '../../components/utils/NotificationUtils.dart';
import '../../components/widgets/common_text_field.dart';
import '../../model/ReferralResponse.dart';
import '../../model/check_user.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late TextEditingController mobileNoController;
  bool isOTPSent = false;
  String? token;
  var isFarmer = 0;
  String dropDownValue = '+91';

  // Locale locale = const Locale("en", 'US');
  final items = ["+91"];
  dynamic headerModel, groupValue;

  @override
  void initState() {
    super.initState();
    mobileNoController = TextEditingController();
    headerModel = HeaderSingleton();
    getDetails();
  }

  Future getDetails() async {
    // if(HeaderModel().routeName=='famrut'){
    if (lang.isNotEmpty) {
      headerModel.setLang(lang);
      String countryCode = lang == 'en'
          ? 'US'
          : lang == 'mr'
              ? 'MR'
              : lang == 'hi'
                  ? 'HI'
                  : '';
      await Get.updateLocale(Locale(lang, countryCode));
    } else {
      final language = await SharePrefsHelper.getInstance(context)?.getStringValue('locale') ?? 'en';
      headerModel.setLang(language);
      String countryCode = language == 'en'
          ? 'US'
          : language == 'mr'
              ? 'MR'
              : language == 'hi'
                  ? 'HI'
                  : '';
      await Get.updateLocale(Locale(language, countryCode));
    }
    final token = await NotificationUtils().firebaseMessaging.getToken();
    groupValue = await WidgetUtils.getIsFarmer(context);
    // //print(groupValue);
  }

  @override
  Widget build(BuildContext context) {
    return BaseWidget(
      // floatingActionButtonLocation: FloatingActionButtonLocation.startTop,
      // floatingButton: Padding(
      //   padding: const EdgeInsets.all(10.0),
      //   child: FloatingActionButton(
      //     backgroundColor: Colors.white,
      //     onPressed: () async {
      //       await Navigator.push(context, MaterialPageRoute(builder: (ctx) => const ChangeLanguageScreen(isFromHome: false)));
      //     },
      //     child: Icon(Icons.language, size: 20, color: Color(int.parse(themeColor.value.iconColor!.color!))),
      //   ),
      // ),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
            SizedBox(height: MediaQuery.of(context).size.height * 0.118),
            Image.file(File(image), fit: BoxFit.contain, width: 204, height: 94, errorBuilder: (ctx, obj, st) {
              return Image.asset(HeaderSingleton().splashImage, fit: BoxFit.contain, width: 204, height: 94);
            }),
            SizedBox(height: MediaQuery.of(context).size.height * 0.01),
            // Align(
            //   alignment: Alignment.center,
            //   child: WidgetUtils.appTextWidget(context: context, title: 'key_login'.tr, fontSize: 22, fontWeight: FontWeight.w500, family: 'Poppins'),
            // ),
            const SizedBox(height: 6),
            Align(
              alignment: Alignment.center,
              child: WidgetUtils.appTextWidget(
                  context: context, title: 'key_login_welcome'.tr, textAlign: TextAlign.center, fontSize: 16, color: Colors.grey, family: 'Graphik', fontWeight: FontWeight.w400),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.04),
            Row(children: [
              WidgetUtils.appTextWidget(
                  context: context, title: 'Country'.tr, fontSize: 16, family: 'Graphik', fontWeight: FontWeight.w400, textAlign: TextAlign.center, color: const Color(0xff111111)),
              SizedBox(width: HeaderSingleton().local == "en" ? MediaQuery.of(context).size.height * 0.015 : MediaQuery.of(context).size.height * 0.06),
              WidgetUtils.appTextWidget(
                  context: context,
                  title: 'key_login_phone'.tr,
                  family: 'Graphik',
                  fontSize: 16,
                  color: Color(int.parse(themeColor.value.iconColor!.color!)),
                  fontWeight: FontWeight.w500,
                  textAlign: TextAlign.center),
            ]),
            SizedBox(height: MediaQuery.of(context).size.height * 0.02),
            Row(children: [
              Container(
                  width: MediaQuery.of(context).size.width * 0.18,
                  height: 58,
                  padding: const EdgeInsets.symmetric(horizontal: 3),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(border: Border.all(color: Colors.grey), borderRadius: const BorderRadius.only(topLeft: Radius.circular(4), bottomLeft: Radius.circular(4))),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Text(
                        "+91",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400, fontFamily: 'Graphik', color: Colors.grey),
                      ),
                      Icon(Icons.keyboard_arrow_down, size: 20, color: Colors.grey)
                    ],
                  )
                  // child: DropdownButtonHideUnderline(
                  //   child: DropdownButton(
                  //     // isExpanded: true,
                  //     isDense: true,
                  //     value: dropDownValue,
                  //     icon: const Icon(Icons.keyboard_arrow_down),
                  //     items: items.map((String items) {
                  //       return DropdownMenuItem(
                  //           value: items,
                  //           child: Text(
                  //             items,
                  //             textAlign: TextAlign.center,
                  //             style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w400, fontFamily: 'Graphik'),
                  //           ));
                  //     }).toList(),
                  //     onChanged: (String? newValue) {
                  //       setState(() {
                  //         dropDownValue = newValue!;
                  //       });
                  //     },
                  //   ),
                  // ),
                  ),
              Expanded(
                child: CommonTextField(
                    isLogin: true,
                    borderWidth: 2.5,
                    hintText: 'key_enter_user_id'.tr,
                    controller: mobileNoController,
                    keyboardType: TextInputType.phone,
                    textSize: 18,
                    maxLength: 10,
                    getController: (controller) => setState(() => mobileNoController.text = controller)),
              ),
            ]),
            const SizedBox(height: 30),
            WidgetUtils.buttonWidget(
                context: context,
                radius: 8,
                title: "Send OTP".tr,
                size: 18,
                family: 'Graphik',
                weight: FontWeight.w500,
                callback: () => login(),
                textColor: Color(int.parse(themeColor.value.buttonTextColor!.color!)),
                color: Color(int.parse(themeColor.value.buttonColor!.color!)))
          ]),
        ),
      ),
    );
  }

  // int _groupValue = -1;

  Future login() async {
    String mobileNo = mobileNoController.text;
    if (mobileNo.contains("+91")) {
      mobileNo = mobileNoController.text.substring(3);
    }
    if (lang == null && lang.isEmpty) {
      lang = await SharePrefsHelper.getInstance(context)?.getStringValue("locale") ?? "en";
      HeaderSingleton().setLang(lang);
    }
    if (mobileNo.isEmpty) {
      WidgetUtils.errorDialog(context, AppTranslations.of(context)?.text("key_enter_user_id") ?? 'key_enter_user_id'.tr);
      setState(() {});
    } else if (mobileNo.length != 10 || mobileNo.length < 10) {
      WidgetUtils.errorDialog(context, AppTranslations.of(context)?.text("key_mobile_no_instruction") ?? 'key_mobile_no_instruction'.tr);
      setState(() {});
    } else if (groupValue == -1) {
      showISFarmer();
    } else {
      String regexPattern = r'^[6-9]\d{9}$';
      final regExp = RegExp(regexPattern);
      if (regExp.hasMatch(mobileNo)) {
        isLoading.value = true;
        try {
          final response = await APIService.postAPIMethod(url: ApiURL.isRegistered, params: {"phone": mobileNo});
          final data = CheckUser.fromJson(json.decode(response.body.toString()));
          int? value;
          if (data.appUserType != 0 && data.appUserType as String != '') {
            value = int.parse(data.appUserType!);
          } else {
            value = 0;
          }
          isLoading.value = false;
          setState(() {});
          if (data.data != null) {
            if (data.data != null && (data.data?.isNotEmpty ?? false)) {
              userId = data.data![0].id!;
              await SharePrefsHelper.getInstance(context)?.saveStringValue("userId", userId.toString());
            } else {
              WidgetUtils.errorDialog(context, data.message!);
              setState(() {});
              return;
            }
          }
          isProfileCompleted = data.isProfileComplete!.toString();
          await SharePrefsHelper.getInstance(context)?.saveIntValue("Is_farmer", value);
          final headerModels = HeaderSingleton();
          headerModels.setAppUserType(data.appUserType.toString().isNotEmpty ? value.toString() : '0');
          headerModels.setUserRegistered(data.isRegistered.toString().isNotEmpty ? data.isRegistered.toString() : 0);
          if (data.isRegistered == 1) {
            var registrationLock = data.registrationLock.toString();
            if (registrationLock == "1") {
              showAlertDialog(data.registrationLockMessge.toString());
            } else {
              isLoading.value = true;
              sendOtp(context, mobileNo, () {}, getCallBack: (value) {
                if (value != null) {
                  if (value == "active") {
                    isLoading.value = false;
                    isOTPSent = false;
                    Navigator.push(context, MaterialPageRoute(builder: (context) => OTPVerificationScreen(mobileNo, "", null)));
                  } else {
                    isLoading.value = false;
                  }
                }
              });
            }
          } else {
            var registrationLock = data.registrationLock.toString();
            if (registrationLock == "1") {
              showAlertDialog(data.registrationLockMessge.toString());
            } else {
              final showRefer = data.showReferral.toString().isNotEmpty ? data.showReferral.toString() : "0";
              String appUserType = data.appUserType.toString().isNotEmpty ? data.appUserType.toString() : "99";
              if (showRefer == "1") {
                Navigator.push(context, MaterialPageRoute(builder: (context) => ReferralScreen(mobileNo, appUserType ?? '0')));
              } else {
                registration(appUserType.isNotEmpty ? appUserType : '0', steps: data.stepList);
                // await referral(appUserType.isNotEmpty ? appUserType : '0');
              }
            }
          }
          isLoading.value = false;
          setState(() {});
        } catch (e) {
          isLoading.value = false;
          setState(() {});
          rethrow;
        }
      } else {
        WidgetUtils.errorDialog(context, AppTranslations.of(context)?.text("key_mobile_no_instruction") ?? 'key_mobile_no_instruction'.tr);
        setState(() {});
      }
    }
  }

  void showISFarmer() {
    HelperUtils().showNormalDialog(
        context: context,
        title: 'Are_you_sure'.tr,
        content: 'Are you a farmer?'.tr,
        noTapped: (value) {
          Navigator.of(value).pop(false);
          setState(() => groupValue = 1);
          login();
        },
        onYesTapped: (value) async {
          setState(() => groupValue = 0);
          login();
        });
  }

  showAlertDialog(String title) {
    return showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: const Text(''),
              content: Text(title),
              actions: <Widget>[TextButton(onPressed: () => Navigator.of(context).pop(false), child: const Text('OK'))],
            ));
  }

  Future referral(String appUserType) async {
    var mobileNo = mobileNoController.text;
    if (mobileNo.contains("+91")) {
      mobileNo = mobileNo.substring(3);
    }

    isLoading.value = true;
    try {
      final response = await APIService.postAPIMethod(url: ApiURL.generateReferralCode, params: {"mobile": mobileNo});
      final data = json.decode(response.body.toString());
      final referralResponse = ReferralResponse.fromJson(data);
      if (referralResponse.success == 1) {
        // Navigator.push(context, MaterialPageRoute(builder: (context) => RegistrationScreen(mobileNo, referralResponse.stepList, referralResponse.data!.referralCode.toString(), appUserType)));
        Navigator.push(context, MaterialPageRoute(builder: (context) => OTPVerificationScreen(mobileNo, referralResponse.data!.referralCode, referralResponse.stepList)));
      } else {
        WidgetUtils.errorDialog(context, referralResponse.msg!);
        // WidgetUtils.errorDialog(context, referralResponse.msg, 3);
      }
      // setState(() => _isLoading = false);
    } on SocketException {
      rethrow;
    } catch (e) {
      isLoading.value = false;
      WidgetUtils.errorDialog(context, AppTranslations.of(context)?.text("key_login_instuction") ?? 'key_login_instuction'.tr);
    }
  }

  Future registration(String referral, {List<StepList>? steps}) async {
    var mobileNo = mobileNoController.text;
    if (mobileNo.contains("+91")) {
      mobileNo = mobileNo.substring(3);
    }
    isLoading.value = true;
    try {
      Map<String, dynamic> params1 = {"phone": mobileNo, "btn_submit": "submit"};
      final response = await APIService.postAPIMethod(url: ApiURL.getRegister, params: params1);
      final data = json.decode(response.body.toString());
      if (data["success"] == 1) {
        if (data['user_id'] != null) {
          userId = data['user_id'].toString();
          await SharePrefsHelper.getInstance(context)?.saveStringValue("userId", userId.toString());
        }
        Navigator.push(context, MaterialPageRoute(builder: (context) => OTPVerificationScreen(mobileNo, referral, steps)));
      } else {
        WidgetUtils.informationDialog(context, data["message"]);
      }
      isLoading.value = false;
    } on SocketException {
      rethrow;
    } catch (e) {
      isLoading.value = false;
      WidgetUtils.errorDialog(context, 'key_login_instuction'.tr);
    }
  }
}
