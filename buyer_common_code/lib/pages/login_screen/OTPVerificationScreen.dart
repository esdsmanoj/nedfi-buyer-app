import 'package:buyer_common_code/app_imports.dart';
import 'package:buyer_common_code/components/widgets/base_widget.dart';
import 'package:buyer_common_code/pages/onboarding_screen/WhiteLableSplashScreen.dart';
import 'package:buyer_common_code/pages/user_details/business_details.dart';
import 'package:buyer_common_code/pages/user_details/user_kyc.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';
// import 'package:sms_autofill/sms_autofill.dart';

import '../../components/widgets/common_text_field.dart';
import '../../model/check_user.dart';

class OTPVerificationScreen extends StatefulWidget {
  final String mobileNumber;
  String? referralCode;
  List<StepList>? steps;

  OTPVerificationScreen(this.mobileNumber, this.referralCode, this.steps, {Key? key}) : super(key: key);

  @override
  _OTPVerificationScreenState createState() => _OTPVerificationScreenState();
}

class _OTPVerificationScreenState extends State<OTPVerificationScreen> /*with CodeAutoFill*/ {
  bool isCountdown = false, resendOTPVisible = false;
  TextEditingController otpController = TextEditingController();
  Timer? countdownTimer;
  Duration myDuration = const Duration(minutes: 2);
  String? appSignature, _token;
  int timerSec = 180;
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  ValueNotifier<String> timerResendValue = ValueNotifier("");

  // @override
  // void codeUpdated() {
  //   setState(() {
  //     // otpController.text = code!;
  //     verifyOTP();
  //   });
  // }

  void startTimer() {
    countdownTimer = Timer.periodic(const Duration(seconds: 1), (_) => setCountDown());
  }

  void setCountDown() {
    const reduceSecondsBy = 1;
    dynamic seconds;
    setState(() {
      seconds = myDuration.inSeconds - reduceSecondsBy;
      if (seconds < 0) {
        countdownTimer!.cancel();
        resendOTPVisible = true;
      } else {
        myDuration = Duration(seconds: seconds);
        String strDigits(int n) => n.toString().padLeft(2, '0');
        final minutes = strDigits(myDuration.inMinutes.remainder(60));
        final sec = strDigits(myDuration.inSeconds.remainder(60));
        timerResendValue.value = '$minutes:$sec';
        // // //print(timerResendValue.value);
      }
    });
  }

  @override
  void initState() {
    super.initState();
    getToken();
    startTimer();
    // listenForCode();
    // _sendOtp();
  }

  Future getToken() async {
    _token = await _firebaseMessaging.getToken();
  }

  @override
  void dispose() {
    super.dispose();
    // cancel();
  }

  // Future<void> listening() async => SmsAutoFill().listenForCode;

  @override
  Widget build(BuildContext context) {
    return BaseWidget(
        resizeInsets: true,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
              SizedBox(height: MediaQuery.of(context).size.height * 0.088),
              Center(
                child: Image.asset('assets/images/otp.png', fit: BoxFit.contain, width: 120, height: 120, alignment: Alignment.center),
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.02),
              Align(
                child: WidgetUtils.appTextWidget(context: context, title: 'key_authenticate_code'.tr, fontSize: 16, fontWeight: FontWeight.w500, family: 'Poppins'),
                alignment: Alignment.center,
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.006),
              Align(
                child: WidgetUtils.appTextWidget(
                    context: context, title: 'key_send_otp_label'.tr, textAlign: TextAlign.center, fontSize: 16, color: Colors.grey, family: 'Graphik', fontWeight: FontWeight.w400),
                alignment: Alignment.center,
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.04),
              Align(
                alignment: Alignment.centerLeft,
                child: WidgetUtils.appTextWidget(
                    context: context,
                    title: 'code_label'.tr,
                    family: 'Graphik',
                    fontSize: 16,
                    color: Color(int.parse(themeColor.value.iconColor!.color!)),
                    fontWeight: FontWeight.w500,
                    textAlign: TextAlign.center),
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.01),
              CommonTextField(
                  hintText: "Please enter OTP code".tr,
                  controller: otpController,
                  keyboardType: TextInputType.number,
                  maxLength: 6,
                  getController: (controller) => setState(() => otpController.text = controller)),
              SizedBox(height: MediaQuery.of(context).size.height * 0.02),
              WidgetUtils.buttonWidget(
                  context: context,
                  radius: 8,
                  family: 'Graphik',
                  weight: FontWeight.w500,
                  title: "key_continue".tr,
                  callback: () async {
                    await verifyOTP();
                  },
                  textColor: Color(int.parse(themeColor.value.buttonTextColor!.color!)),
                  color: Color(int.parse(themeColor.value.buttonColor!.color!))),
              SizedBox(height: MediaQuery.of(context).size.height * 0.016),
              resendOTPVisible
                  ? WidgetUtils.buttonWidget(
                      context: context,
                      radius: 8,
                      family: 'Graphik',
                      weight: FontWeight.w500,
                      title: "key_resend".tr,
                      callback: () async {
                        // appSignature = await SmsAutoFill().getAppSignature;
                        _token = await _firebaseMessaging.getToken();
                        isLoading.value = true;
                        await sendOtp(context, widget.mobileNumber, () {
                          resendOTPVisible = false;
                          countdownTimer = null;
                          myDuration = const Duration(minutes: 2);
                          setState(() {});
                          startTimer();
                        }, getCallBack: (value) {});
                        isLoading.value = false;
                        // await _sendOtp();
                      },
                      textColor: Colors.black,
                      color: Colors.white)
                  : Container(),
              SizedBox(height: MediaQuery.of(context).size.height * 0.02),
              Container(
                child: ValueListenableBuilder(
                    valueListenable: timerResendValue,
                    builder: (ctx, String value, child) {
                      return (value.isNotEmpty && value != "") && value != "00:00"
                          ? Align(
                              alignment: Alignment.center,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  WidgetUtils.appTextWidget(
                                    context: context,
                                    title: 'Resend OTP after'.tr,
                                    family: 'Graphik',
                                    fontSize: 16,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w400,
                                    textAlign: TextAlign.center,
                                  ),
                                  const SizedBox(width: 20),
                                  const Icon(Icons.timer, color: Colors.grey, size: 20),
                                  const SizedBox(width: 10),
                                  WidgetUtils.appTextWidget(
                                      context: context,
                                      title: timerResendValue.value,
                                      family: 'Graphik',
                                      fontSize: 14,
                                      color: Color(int.parse(themeColor.value.iconColor!.color!)),
                                      fontWeight: FontWeight.w400,
                                      textAlign: TextAlign.center)
                                ],
                              ),
                            )
                          : Container();
                    }),
              ),
            ]),
          ),
        ));
  }

  Future<void> verifyOTP() async {
    if (otpController.text.length < 6) {
      WidgetUtils.errorDialog(context, 'Please_Enter_OTP'.tr);
      setState(() {});
    } else {
      isLoading.value = true;
      try {
        Map<String, dynamic> params1 = {"btn_submit": "submit", "phone": widget.mobileNumber, "otp": otpController.text, "device_id": _token};
        final response = await APIService.postAPIMethod(url: ApiURL.getLoginOTP, params: params1);
        final data = User.fromJson(json.decode(response.body));
        if (data.success == 1) {
          await SharePrefsHelper.getInstance(context)?.saveStringValue("mobile", widget.mobileNumber);
          await SharePrefsHelper.getInstance(context)?.saveStringValue("userType", data.data!.appUserType ?? "0");
          WidgetUtils.successDialog(context, 'Verify_Successfully'.tr);
          await SharePrefsHelper.getInstance(context)?.saveIntValue("Is_farmer", int.parse(data.data!.appUserType ?? "0"));
          // await SharePrefsHelper.getInstance(context)?.saveBoolValue("isLogin", true);
          await SharePrefsHelper.getInstance(context)?.saveUserModel(data.data!);
          await SharePrefsHelper.getInstance(context)?.saveUserModel(data.data!);
          await SharePrefsHelper.getInstance(context)?.saveStringValue("Profile", data.data!.profileImage ?? "");
          final locales = (await SharePrefsHelper.getInstance(context)?.getStringValue('locale')) ?? "en";
          HeaderSingleton().setLang(locales);
          countdownTimer!.cancel();
          await SharePrefsHelper.getInstance(context)?.saveBoolValue("is_user_log", true);
          if (HeaderSingleton().isUserRegister == "1" && isProfileCompleted == "1") {
            await SharePrefsHelper.getInstance(context)?.saveBoolValue("isLogin", true);
            if (HeaderSingleton().routeName == 'famrut' || HeaderSingleton().routeName == 'icar' || HeaderSingleton().routeName == 'icar' || HeaderSingleton().routeName == 'nedfi') {
              Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (BuildContext context) => const NavigationHomeScreen()), (Route<dynamic> route) => false);
            } else {
              Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => WhiteLableSplashScreen(image, isFrom: true)), (Route<dynamic> route) => false);
            }
          } else {
            await HelperUtils().getKYCStatus(() => setState(() {}));
            // }
            // Navigator.pushAndRemoveUntil(
            //     context,
            //     MaterialPageRoute(
            //         builder: (context) => data.data!.activeStep == "0"
            //             ? RegistrationScreen(widget.mobileNumber, widget.referralCode ?? '', HeaderSingleton().appUserType)
            //             : data.data!.activeStep == "1"
            //                 ? const BusinessDetails()
            //                 : const UserKYC()),
            //     (Route<dynamic> route) => false);
            checkUserActive(data.data!.activeStep ?? "0", widget.mobileNumber, HeaderSingleton().appUserType);
          }
        } else {
          WidgetUtils.errorDialog(context, data.message ?? 'Failed_Verification'.tr);
          setState(() {});
        }
        isLoading.value = false;
        setState(() {});
      } catch (e) {
        isLoading.value = false;
        setState(() {});
      }
    }
  }

  checkUserActive(String step, String mobileNumber, String userType) {
    if (step == "1") {
      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const BusinessDetails(false)), (Route<dynamic> route) => false);
    } else if (step == "2") {
      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const UserKYC()), (Route<dynamic> route) => false);
    } else if (step == "3") {
      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const NavigationHomeScreen()), (Route<dynamic> route) => false);
    } else {
      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => RegistrationScreen(mobileNumber, '', userType, true)), (Route<dynamic> route) => false);
    }
  }
}
