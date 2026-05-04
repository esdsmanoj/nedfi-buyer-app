import 'package:nedfi_seller_common_code/app_imports.dart';
import 'package:nedfi_seller_common_code/model/pan_authentication_model.dart';
import 'package:get/get.dart';

import '../../components/utils/notification_utils.dart';
import '../../model/user_model/authenticate_aadhar_Card.dart';
import '../../model/user_model/bank_verification.dart';
import '../../model/verification_aadhar.dart';

class EKYCScreen extends StatefulWidget {
  String? businessType;
  EKYCScreen({this.businessType});

  @override
  State<EKYCScreen> createState() => _EKYCScreenState();
}

class _EKYCScreenState extends State<EKYCScreen> {
  TextEditingController adharCardController = TextEditingController(),
      panCardController = TextEditingController(),
      businessPanCardController = TextEditingController(),
      otpController = TextEditingController(),
      otpPANController = TextEditingController(),
      bankNameController = TextEditingController(),
      branchNameController = TextEditingController(),
      ifscController = TextEditingController(),
      accNoController = TextEditingController();
  ValueNotifier<bool> isOTPSent = ValueNotifier(false),
      isPanOTPSent = ValueNotifier(false),
      isBusinessPanOTPSent = ValueNotifier(false),
      isAdharExpanded = ValueNotifier(false),
      isPanExpanded = ValueNotifier(false),
      isBusinessPanExpanded = ValueNotifier(false),
      isLoading = ValueNotifier(false),
      isBankExpanded = ValueNotifier(false);

  @override
  void initState() {
    super.initState();

    final ekyc = HeaderSingleton().ekycStatus.value!;

    if (
    !(ekyc.ekycAadharVerify == "1" ||
        ekyc.ekycBankVerify == "1" ||
        ekyc.ekycPanVerify == "1" ||
        (ekyc.businessPanVerify == "1" && ekyc.appUserType == "0" && widget.businessType != "Proprietor"))
    ) {
      checkDetails();
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: WillPopScope(
        onWillPop: () => HelperUtils().onWillPop(context),
        child: CustomProgressHandler(
          isLoading: isLoading.value,
          loadingText: 'Please wait',
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: MediaQuery.of(context).size.height * 0.024),
                Container(
                  width: MediaQuery.of(context).size.width,
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Container(
                      width: 100,
                      height: 60,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12),
                        child: WidgetUtils.buttonWidget(
                            context: context,
                            radius: 8,
                            title: 'Skip'.tr,
                            size: 18,
                            family: 'Graphik',
                            weight: FontWeight.w500,
                            callback: () async {
                              checkDetails();
                            },
                            textColor: Color(int.parse(themeColor.value.buttonTextColor!.color!)),
                            color: Color(int.parse(themeColor.value.buttonColor!.color!))),
                      ),
                    ),
                  ),
                ),
                HeaderSingleton().ekycStatus.value!.ekycAadharVerify == "1"
                    ? Container(
                        margin: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
                        decoration: BoxDecoration(color: Colors.white, border: Border.all(width: 1, color: const Color(0xFF9F9F9F)), borderRadius: BorderRadius.circular(8)),
                        child: Column(
                          children: [
                            ExpansionTile(
                                collapsedTextColor: const Color(0xff000000),
                                trailing: const Icon(Icons.keyboard_arrow_down, size: 20),
                                iconColor: const Color(0xFF6F6F6F),
                                collapsedIconColor: const Color(0xFF6F6F6F),
                                title: WidgetUtils.appTextWidget(context: context, title: 'Aadhar Card'.tr, fontWeight: FontWeight.w500, family: 'Graphik', fontSize: 16, color: const Color(0xff000000)),
                                children: [(HeaderSingleton().ekycStatus.value!.aadhaarVerifySataus == "1") ? buildAadharDetails() : buildAadhaarCard()],
                                initiallyExpanded: isAdharExpanded.value),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  WidgetUtils.appTextWidget(
                                      context: context,
                                      title: 'Status'.tr + ': ${(HeaderSingleton().ekycStatus.value!.aadhaarVerifySataus == "1") ? 'Verified'.tr : 'Not Verified'.tr}',
                                      fontWeight: FontWeight.w400,
                                      fontSize: 14,
                                      color: const Color(0xFF6F6F6F),
                                      family: 'Graphik'),
                                  SvgPicture.asset((HeaderSingleton().ekycStatus.value!.aadhaarVerifySataus == "1") ? "assets/images/verified.svg" : "assets/images/cross.svg", height: 20)
                                ],
                              ),
                            ),
                            SizedBox(height: MediaQuery.of(context).size.height * 0.01),
                          ],
                        ))
                    : Container(),
                HeaderSingleton().ekycStatus.value!.ekycBankVerify == "1"
                    ? Container(
                        margin: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
                        decoration: BoxDecoration(border: Border.all(width: 1, color: const Color(0xFF9F9F9F)), color: Colors.white, borderRadius: BorderRadius.circular(4)),
                        child: Column(
                          children: [
                            ExpansionTile(
                              collapsedTextColor: const Color(0xff000000),
                              trailing: const Icon(Icons.keyboard_arrow_down, size: 20),
                              iconColor: const Color(0xFF6F6F6F),
                              collapsedIconColor: const Color(0xFF6F6F6F),
                              title: WidgetUtils.appTextWidget(context: context, title: 'Bank Details'.tr, fontWeight: FontWeight.w500, family: 'Graphik', fontSize: 16, color: const Color(0xff000000)),
                              children: [(HeaderSingleton().ekycStatus.value!.bankVerifyStatus == "1") ? buildBankDetails() : buildBank()],
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  WidgetUtils.appTextWidget(
                                      context: context,
                                      title: 'Status'.tr + ': ${(HeaderSingleton().ekycStatus.value!.bankVerifyStatus == "1") ? 'Verified'.tr : 'Not Verified'.tr}',
                                      family: 'Graphik',
                                      color: const Color(0xFF6F6F6F),
                                      fontWeight: FontWeight.w400,
                                      fontSize: 14),
                                  SvgPicture.asset(
                                    HeaderSingleton().ekycStatus.value!.bankVerifyStatus == "1" ? "assets/images/verified.svg" : "assets/images/cross.svg",
                                    height: 20,
                                  )
                                ],
                              ),
                            ),
                            SizedBox(height: MediaQuery.of(context).size.height * 0.01),
                          ],
                        ))
                    : Container(),
                HeaderSingleton().ekycStatus.value!.ekycPanVerify == "1"
                    ? Container(
                        margin: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
                        decoration: BoxDecoration(border: Border.all(width: 1, color: const Color(0xFF9F9F9F)), color: Colors.white, borderRadius: BorderRadius.circular(4)),
                        child: Column(
                          children: [
                            ExpansionTile(
                              collapsedTextColor: const Color(0xff000000),
                              trailing: const Icon(Icons.keyboard_arrow_down, size: 20),
                              iconColor: const Color(0xFF6F6F6F),
                              collapsedIconColor: const Color(0xFF6F6F6F),
                              title: WidgetUtils.appTextWidget(context: context, title: 'PAN number'.tr, fontWeight: FontWeight.w500, family: 'Graphik', fontSize: 16, color: const Color(0xff000000)),
                              children: [(HeaderSingleton().ekycStatus.value!.panVerifySataus == "1") ? buildPanDetails() : buildPanCard()],
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  WidgetUtils.appTextWidget(
                                      context: context,
                                      title: 'Status'.tr + ': ${(HeaderSingleton().ekycStatus.value!.panVerifySataus == "1") ? 'Verified'.tr : 'Not Verified'.tr}',
                                      family: 'Graphik',
                                      color: const Color(0xFF6F6F6F),
                                      fontWeight: FontWeight.w400,
                                      fontSize: 14),
                                  SvgPicture.asset(
                                    HeaderSingleton().ekycStatus.value!.panVerifySataus == "1" ? "assets/images/verified.svg" : "assets/images/cross.svg",
                                    height: 20,
                                  )
                                ],
                              ),
                            ),
                            SizedBox(height: MediaQuery.of(context).size.height * 0.01),
                          ],
                        ))
                    : Container(),
                HeaderSingleton().ekycStatus.value!.businessPanVerify == "1" && HeaderSingleton().ekycStatus.value!.appUserType == "0" && widget.businessType != "Proprietor"
                    ? Container(
                        margin: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
                        decoration: BoxDecoration(border: Border.all(width: 1, color: const Color(0xFF9F9F9F)), color: Colors.white, borderRadius: BorderRadius.circular(4)),
                        child: Column(
                          children: [
                            ExpansionTile(
                              collapsedTextColor: const Color(0xff000000),
                              trailing: const Icon(Icons.keyboard_arrow_down, size: 20),
                              iconColor: const Color(0xFF6F6F6F),
                              collapsedIconColor: const Color(0xFF6F6F6F),
                              title: WidgetUtils.appTextWidget(
                                  context: context, title: 'Business PAN number'.tr, fontWeight: FontWeight.w500, family: 'Graphik', fontSize: 16, color: const Color(0xff000000)),
                              children: [(HeaderSingleton().ekycStatus.value!.businessPanVerifyStatus == "1") ? buildBusinessPanDetails() : buildBusinessPanCard()],
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  WidgetUtils.appTextWidget(
                                      context: context,
                                      title: 'Status'.tr + ': ${(HeaderSingleton().ekycStatus.value!.businessPanVerifyStatus == "1") ? 'Verified'.tr : 'Not Verified'.tr}',
                                      family: 'Graphik',
                                      color: const Color(0xFF6F6F6F),
                                      fontWeight: FontWeight.w400,
                                      fontSize: 14),
                                  SvgPicture.asset(
                                    HeaderSingleton().ekycStatus.value!.businessPanVerifyStatus == "1" ? "assets/images/verified.svg" : "assets/images/cross.svg",
                                    height: 20,
                                  )
                                ],
                              ),
                            ),
                            SizedBox(height: MediaQuery.of(context).size.height * 0.01),
                          ],
                        ))
                    : Container()
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future checkDetails() async {
    try {
      final response = await APIService.postAPIMethod(url: ApiURL.profileStep1, params: {'btn_submit': 'submit', 'step': '3', 'id': userId, "edit_profile": "0"});
      final result = json.decode(response.body);
    //  if (result['success'] == 1) {
        if (!HeaderSingleton().isFirebaseActive) {
          isLoginCompleted = "true";
          await NotificationUtils().handleAllNotification(HeaderSingleton().navigatorKey, context);
          NotificationUtils().listenForegroundMessage(() => setState(() {}));
        }
        await SharePrefsHelper.getInstance(context)?.saveStringValue("step3", "completed");
        await SharePrefsHelper.getInstance(context)?.saveStringValue("step2", "");
        await SharePrefsHelper.getInstance(context)?.saveStringValue("step1", "");
        await SharePrefsHelper.getInstance(context)?.saveBoolValue("isLogin", true);
        WidgetUtils.successDialog(context, result['message']);
        await HelperUtils().getKYCStatus(() => setState(() {}));
        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const NavigationHomeScreen()), (Route<dynamic> route) => false);
    /*  } else {
        WidgetUtils.errorDialog(context, result['message']);
      }*/
    } catch (e) {
      rethrow;
    }
  }

  Widget buildBankDetails() {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.15,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          WidgetUtils.appTextWidget(context: context, title: 'Bank Name: ${HeaderSingleton().ekycStatus.value!.bank!.bank!}', fontWeight: FontWeight.bold, fontSize: 14),
          WidgetUtils.appTextWidget(context: context, title: 'Branch Name: ${HeaderSingleton().ekycStatus.value!.bank!.branchName!}', fontWeight: FontWeight.bold, fontSize: 14),
          WidgetUtils.appTextWidget(context: context, title: 'IFSC Code: ${HeaderSingleton().ekycStatus.value!.bank!.ifscCode ?? ''}', fontWeight: FontWeight.bold, fontSize: 14),
          WidgetUtils.appTextWidget(context: context, title: 'Account Number: ${HeaderSingleton().ekycStatus.value!.bank!.userAccountNumber ?? ''}', fontWeight: FontWeight.bold, fontSize: 14),
        ],
      ),
    );
  }

  Widget buildPanDetails() {
    return HeaderSingleton().ekycStatus.value!.pan != null
        ? SizedBox(
            height: MediaQuery.of(context).size.height * 0.1,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                WidgetUtils.appTextWidget(context: context, title: 'Pan Card: ${HeaderSingleton().ekycStatus.value!.pan!.panNumber!}', fontWeight: FontWeight.w500, family: 'Graphik', fontSize: 14),
                WidgetUtils.appTextWidget(
                    context: context, title: 'CardHolder Name: ${HeaderSingleton().ekycStatus.value!.pan!.userFullName!}', fontWeight: FontWeight.w500, family: 'Graphik', fontSize: 14),
              ],
            ),
          )
        : Container();
  }

  Widget buildBusinessPanDetails() {
    return HeaderSingleton().ekycStatus.value!.businessPan != null
        ? SizedBox(
            height: MediaQuery.of(context).size.height * 0.1,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                WidgetUtils.appTextWidget(
                    context: context, title: 'Business Pan Card: ${HeaderSingleton().ekycStatus.value!.businessPan!.panNumber!}', fontWeight: FontWeight.w500, family: 'Graphik', fontSize: 14),
                WidgetUtils.appTextWidget(
                    context: context, title: 'CardHolder Name: ${HeaderSingleton().ekycStatus.value!.businessPan!.userFullName!}', fontWeight: FontWeight.w500, family: 'Graphik', fontSize: 14),
              ],
            ),
          )
        : Container();
  }

  Widget buildAadharDetails() {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.08,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          WidgetUtils.appTextWidget(
              context: context, title: 'Aadhaar Number: ${HeaderSingleton().ekycStatus.value!.aadhaar!.userAadhaarNumber!}', fontWeight: FontWeight.w500, family: 'Graphik', fontSize: 14),
          WidgetUtils.appTextWidget(
              context: context, title: 'CardHolder Name: ${HeaderSingleton().ekycStatus.value!.aadhaar!.userAadhaarName!}', fontWeight: FontWeight.w500, family: 'Graphik', fontSize: 14),
        ],
      ),
    );
  }

  Widget buildAadhaarCard() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: double.maxFinite,
          height: 50,
          alignment: Alignment.center,
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(border: Border.all(color: Colors.grey, width: 0.5), borderRadius: BorderRadius.circular(8)),
          // margin: const EdgeInsets.only(right: 16),
          child: TextField(
            controller: adharCardController,
            keyboardType: TextInputType.phone,
            maxLength: 12,
            decoration: InputDecoration(
              hintText: 'Enter Aadhar card'.tr,
              border: InputBorder.none,
              counterText: "",
              labelStyle: const TextStyle(fontSize: 14, fontFamily: 'Graphik', fontWeight: FontWeight.w500),
            ),
          ),
        ),
        SizedBox(height: MediaQuery.of(context).size.height * 0.01),
        isOTPSent.value
            ? Container(
                width: 100,
                margin: const EdgeInsets.symmetric(horizontal: 16),
                alignment: Alignment.centerLeft,
                child: WidgetUtils.appTextWidget(context: context, title: 'Enter OTP'.tr, fontWeight: FontWeight.w500, fontSize: 14, family: 'Graphik', textAlign: TextAlign.left))
            : Container(),
        SizedBox(height: isOTPSent.value ? 10 : 0),
        isOTPSent.value
            ? Container(
                width: double.maxFinite,
                height: 50,
                alignment: Alignment.center,
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(border: Border.all(color: Colors.green, width: 0.5), borderRadius: BorderRadius.circular(4)),
                // margin: const EdgeInsets.only(right: 16),
                child: TextField(
                  controller: otpController,
                  keyboardType: TextInputType.phone,
                  maxLength: 6,
                  decoration: const InputDecoration(hintText: 'Enter OTP', border: InputBorder.none, counterText: ""),
                ),
              )
            : Container(),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: () async {
                  isLoading.value = true;
                  setState(() {});
                  await getAadhaarOTP();
                  isLoading.value = false;
                  setState(() {});
                },
                child: Container(
                  alignment: Alignment.center,
                  width: MediaQuery.of(context).size.width * 0.4,
                  height: 58,
                  decoration: BoxDecoration(
                      color: Color(int.parse(themeColor.value.barColor!.color!)),
                      border: Border.all(color: Color(int.parse(themeColor.value.barColor!.color!))),
                      borderRadius: BorderRadius.circular(8)),
                  child: WidgetUtils.appTextWidget(
                      context: context,
                      title: isOTPSent.value ? 'Resend OTP'.tr : 'Send OTP'.tr,
                      fontWeight: FontWeight.w500,
                      family: 'Graphik',
                      fontSize: 14,
                      color: Color(int.parse(themeColor.value.buttonTextColor!.color!))),
                ),
              ),
              isOTPSent.value
                  ? InkWell(
                      onTap: () async {
                        isLoading.value = true;
                        setState(() {});
                        await verifyAadhaarOTP();
                        isLoading.value = false;
                        setState(() {});
                      },
                      child: Container(
                        alignment: Alignment.center,
                        width: MediaQuery.of(context).size.width * 0.4,
                        height: 58,
                        decoration: BoxDecoration(color: Color(int.parse(themeColor.value.barColor!.color!)), border: Border.all(color: Colors.green), borderRadius: BorderRadius.circular(8)),
                        child: WidgetUtils.appTextWidget(
                            context: context, title: 'Verify'.tr, color: Color(int.parse(themeColor.value.buttonTextColor!.color!)), fontWeight: FontWeight.w500, family: 'Graphik', fontSize: 14),
                      ),
                    )
                  : Container(),
            ],
          ),
        )
      ],
    );
  }

  Widget buildPanCard() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: double.maxFinite,
          height: 50,
          alignment: Alignment.center,
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(border: Border.all(color: Colors.grey, width: 0.5), borderRadius: BorderRadius.circular(8)),
          // margin: const EdgeInsets.only(right: 16),
          child: TextField(
            controller: panCardController,
            keyboardType: TextInputType.text,
            maxLength: 10,
            decoration: InputDecoration(
              hintText: 'Enter 10-digit PAN number'.tr,
              border: InputBorder.none,
              counterText: "",
              labelStyle: const TextStyle(fontSize: 14, fontFamily: 'Graphik', fontWeight: FontWeight.w500),
            ),
          ),
        ),
        SizedBox(height: MediaQuery.of(context).size.height * 0.01),
        InkWell(
          onTap: () async {
            isLoading.value = true;
            setState(() {});
            await verifyPAN(panCardController, false);
            isLoading.value = false;
            setState(() {});
          },
          child: Container(
            alignment: Alignment.center,
            margin: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10),
            width: double.maxFinite,
            height: 58,
            decoration: BoxDecoration(color: Color(int.parse(themeColor.value.barColor!.color!)), border: Border.all(color: Colors.green), borderRadius: BorderRadius.circular(8)),
            child: WidgetUtils.appTextWidget(
                context: context, title: 'Verify'.tr, color: Color(int.parse(themeColor.value.buttonTextColor!.color!)), fontWeight: FontWeight.w500, family: 'Graphik', fontSize: 14),
          ),
        ),
        SizedBox(height: MediaQuery.of(context).size.height * 0.01),
      ],
    );
  }

  Widget buildBusinessPanCard() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: double.maxFinite,
          height: 50,
          alignment: Alignment.center,
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(border: Border.all(color: Colors.grey, width: 0.5), borderRadius: BorderRadius.circular(8)),
          // margin: const EdgeInsets.only(right: 16),
          child: TextField(
            controller: businessPanCardController,
            keyboardType: TextInputType.text,
            maxLength: 10,
            decoration: InputDecoration(
              hintText: 'Enter 10-digit Business PAN number'.tr,
              border: InputBorder.none,
              counterText: "",
              labelStyle: const TextStyle(fontSize: 14, fontFamily: 'Graphik', fontWeight: FontWeight.w500),
            ),
          ),
        ),
        SizedBox(height: MediaQuery.of(context).size.height * 0.01),
        InkWell(
          onTap: () async {
            isLoading.value = true;
            setState(() {});
            await verifyPAN(businessPanCardController, true);
            isLoading.value = false;
            setState(() {});
          },
          child: Container(
            alignment: Alignment.center,
            margin: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10),
            width: double.maxFinite,
            height: 58,
            decoration: BoxDecoration(color: Color(int.parse(themeColor.value.barColor!.color!)), border: Border.all(color: Colors.green), borderRadius: BorderRadius.circular(8)),
            child: WidgetUtils.appTextWidget(
                context: context, title: 'Verify'.tr, color: Color(int.parse(themeColor.value.buttonTextColor!.color!)), fontWeight: FontWeight.w500, family: 'Graphik', fontSize: 14),
          ),
        ),
        SizedBox(height: MediaQuery.of(context).size.height * 0.01),
      ],
    );
  }

  Widget buildBank() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: double.maxFinite,
          height: 50,
          alignment: Alignment.center,
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(border: Border.all(color: const Color(0xFFCFCFCF), width: 0.5), borderRadius: BorderRadius.circular(4)),
          // margin: const EdgeInsets.only(right: 16),
          child: TextField(
            controller: accNoController,
            keyboardType: TextInputType.number,
            maxLength: 18,
            decoration: InputDecoration(
                hintText: 'Please Enter account no.'.tr, labelStyle: const TextStyle(fontSize: 14, fontFamily: 'Graphik', fontWeight: FontWeight.w500), border: InputBorder.none, counterText: ""),
          ),
        ),
        Container(
          width: double.maxFinite,
          height: 50,
          alignment: Alignment.center,
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(border: Border.all(color: const Color(0xFFCFCFCF), width: 0.5), borderRadius: BorderRadius.circular(4)),
          // margin: const EdgeInsets.only(right: 16),
          child: TextField(
            controller: ifscController,
            keyboardType: TextInputType.text,
            maxLength: 11,
            decoration: InputDecoration(
              hintText: 'Please Enter IFSC code'.tr,
              border: InputBorder.none,
              counterText: "",
              labelStyle: const TextStyle(fontSize: 14, fontFamily: 'Graphik', fontWeight: FontWeight.w500),
            ),
          ),
        ),
        GestureDetector(
          onTap: () async {
            await verifyBankDetails();
            setState(() {});
          },
          child: Container(
            alignment: Alignment.center,
            width: double.maxFinite,
            height: 58,
            margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
            decoration: BoxDecoration(color: Color(int.parse(themeColor.value.barColor!.color!)), border: Border.all(color: Colors.green), borderRadius: BorderRadius.circular(8)),
            child: WidgetUtils.appTextWidget(
                context: context, title: 'Verify'.tr, color: Color(int.parse(themeColor.value.buttonTextColor!.color!)), fontWeight: FontWeight.w500, family: 'Graphik', fontSize: 14),
          ),
        )
      ],
    );
  }

  Future verifyPAN(TextEditingController controller, bool isBusinessPan) async {
    print(controller.text);
    try {
      if (controller.text.isEmpty) {
        WidgetUtils.errorDialog(context, 'Enter Pan Card'.tr);
      } else if (!panExpression.hasMatch(controller.text)) {
        WidgetUtils.errorDialog(context, 'Enter Valid Pan Card'.tr);
      } else {
        final response = await APIService.postAPIMethod(
            url: ApiURL.verifyPAN, params: {'user_id': userId.isEmpty ? HeaderSingleton().paramsMaps!.userId! : userId, 'pan_no': controller.text, 'business_pan': isBusinessPan.toString()});
        final authenticate = PanAuthentication.fromJson(json.decode(response.body));
        print(response.body);
        if (authenticate.success == "1") {
          if (!isBusinessPan) {
            isPanOTPSent.value = true;
            isPanExpanded.value = true;
          } else {
            isBusinessPanOTPSent.value = true;
            isBusinessPanExpanded.value = true;
          }
          await HelperUtils().getKYCStatus(() => setState(() {}));
          WidgetUtils.successDialog(context, authenticate.message!);
        } else {
          WidgetUtils.errorDialog(context, authenticate.message!);
        }
      }
      setState(() {});
    } catch (e) {
      isLoading.value = false;
      setState(() {});
      rethrow;
    }
  }

  Future getAadhaarOTP() async {
    try {
      RegExp expression = RegExp(r'^[2-9]{1}[0-9]{3}[0-9]{4}[0-9]{4}$');
      if (adharCardController.text.length < 12 || adharCardController.text.isEmpty) {
        WidgetUtils.errorDialog(context, 'Please enter 16 digit card number'.tr);
      } else if (!expression.hasMatch(adharCardController.text)) {
        WidgetUtils.errorDialog(context, 'Please enter valid card number'.tr);
      } else {
        final response =
            await APIService.postAPIMethod(url: ApiURL.getAadhaarOTP, params: {'user_id': userId.isEmpty ? HeaderSingleton().paramsMaps!.userId! : userId, 'aadhar_no': adharCardController.text});
        final authenticate = AuthenticateAadhaar.fromJson(json.decode(response.body));
        if (authenticate.success == 1) {
          isOTPSent.value = true;
          isAdharExpanded.value = true;
          WidgetUtils.successDialog(context, authenticate.message!);
        } else {
          WidgetUtils.errorDialog(context, authenticate.message!);
        }
      }
    } catch (e) {
      isLoading.value = false;
      rethrow;
    }
  }

  Future verifyAadhaarOTP() async {
    try {
      if (otpController.text.isEmpty) {
        WidgetUtils.errorDialog(context, 'Please Enter OTP details'.tr);
      } else {
        final response = await APIService.postAPIMethod(
            url: ApiURL.verifyAadhaarOTP, params: {'user_id': userId.isEmpty ? HeaderSingleton().paramsMaps!.userId! : userId, 'aadhar_no': adharCardController.text, 'otp': otpController.text});
        final authenticate = VerificationAadhaar.fromJson(json.decode(response.body));
        if (authenticate.success == 1) {
          isOTPSent.value = true;
          isAdharExpanded.value = true;
          WidgetUtils.successDialog(context, authenticate.message!);
          await HelperUtils().getKYCStatus(() => setState(() {}));
        } else {
          WidgetUtils.errorDialog(context, authenticate.message!);
        }
      }
    } catch (e) {
      isLoading.value = false;
      rethrow;
    }
  }

  Future verifyBankDetails() async {
    try {
      setState(() {});
      RegExp ifscRegex = RegExp(r"^[A-Z]{4}0[A-Z0-9]{6}$");
      RegExp accountRegExp = RegExp(r"^\d{9,18}$");
      /* if (bankNameController.text.isEmpty) {
        WidgetUtils.errorDialog(context, 'Please Enter Bank name');
      } else if (branchNameController.text.isEmpty) {
        WidgetUtils.errorDialog(context, 'Please Enter Branch name');
      } else*/
      if (accNoController.text.isEmpty) {
        WidgetUtils.errorDialog(context, 'Please Enter account no.'.tr);
      } else if (!accountRegExp.hasMatch(accNoController.text)) {
        WidgetUtils.errorDialog(context, 'Please Enter valid account no.'.tr);
      } else if (ifscController.text.isEmpty) {
        WidgetUtils.errorDialog(context, 'Please Enter IFSC code'.tr);
      } else if (!ifscRegex.hasMatch(ifscController.text)) {
        WidgetUtils.errorDialog(context, "Please Enter valid IFSC code".tr);
      } else {
        isLoading.value = true;
        final response = await APIService.postAPIMethod(
            url: ApiURL.verifyBankDetail, params: {'user_id': userId.isEmpty ? HeaderSingleton().paramsMaps!.userId! : userId, 'acc_no': accNoController.text, 'ifsc_code': ifscController.text});
        final authenticate = BankVerification.fromJson(json.decode(response.body));
        if (authenticate.success == 1) {
          isBankExpanded.value = true;
          WidgetUtils.successDialog(context, authenticate.message!);
          await HelperUtils().getKYCStatus(() => setState(() {}));
        } else {
          WidgetUtils.errorDialog(context, authenticate.message!);
        }
        isLoading.value = false;
      }
    } catch (e) {
      isLoading.value = false;
      rethrow;
    }
  }

// Future getKYCStatus() async {
//   try {
//     final response = await APIService.postAPIMethod(url: ApiURL.getKYCStatus, params: {"user_id": userId.isEmpty ? HeaderSingleton().paramsMaps!.userId! : userId});
//     final res = EKYCStatus.fromJson(json.decode(response.body));
//     if (response.statusCode == 200) {
//       HeaderSingleton().setEKYCStatus(res);
//       // print(HeaderModel().ekycStatus.value.toString());
//       setState(() {});
//     }
//     // isLoading.value=true;
//   } catch (e) {
//     // print(e.toString());
//     isLoading.value = false;
//   }
// }
}

class CardNumberFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue previousValue,
    TextEditingValue nextValue,
  ) {
    var inputText = nextValue.text;

    if (nextValue.selection.baseOffset == 0) {
      return nextValue;
    }

    var bufferString = StringBuffer();
    for (int i = 0; i < inputText.length; i++) {
      bufferString.write(inputText[i]);
      var nonZeroIndexValue = i + 1;
      if (nonZeroIndexValue % 4 == 0 && nonZeroIndexValue != inputText.length) {
        bufferString.write(' ');
      }
    }

    var string = bufferString.toString();
    return nextValue.copyWith(
      text: string,
      selection: TextSelection.collapsed(
        offset: string.length,
      ),
    );
  }
}
