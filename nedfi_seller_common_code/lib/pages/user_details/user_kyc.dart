import 'package:get/get.dart';
import 'package:nedfi_seller_common_code/pages/user_details/business_details.dart';

import '../../app_imports.dart';
import '../../components/utils/notification_utils.dart';
import 'e_kyc_screen.dart';

class UserKYC extends StatefulWidget {
  const UserKYC({super.key});

  @override
  State<UserKYC> createState() => _UserKYCState();
}

class _UserKYCState extends State<UserKYC> {
  String? businessType = "";
  @override
  void initState() {
    super.initState();
    getDetails();
  }

  Future getDetails() async {
    final address = await SharePrefsHelper.getInstance(context)!.getStringValue("step2_data");
    if (address != null && address.isNotEmpty) {
      Map<String, dynamic> decodedMap = json.decode(address);
      businessType = decodedMap["business_type"] ?? "";
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: WillPopScope(
        onWillPop: () => HelperUtils().onWillPop(context),
        child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            title: Container(
              width: 226,
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
                Container(width: 50, height: 5, decoration: BoxDecoration(borderRadius: BorderRadius.circular(4), color: const Color(0xFFFE9CCA4))),
                Container(width: 50, height: 5, decoration: BoxDecoration(borderRadius: BorderRadius.circular(4), color: const Color(0xFFFE9CCA4))),
                Container(width: 50, height: 5, decoration: BoxDecoration(borderRadius: BorderRadius.circular(4), color: const Color(0xFFFDA11E))),
              ]),
            ),
            leading: IconButton(
              onPressed: () async {
                Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const BusinessDetails(false)), (Route<dynamic> route) => false);
              },
              icon: const Icon(Icons.keyboard_backspace_sharp),
            ),
            iconTheme: const IconThemeData(color: Colors.black),
          ),
          body: EKYCScreen(businessType: businessType),
          bottomNavigationBar: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12),
            child: WidgetUtils.buttonWidget(
                context: context,
                radius: 8,
                title: 'Next'.tr,
                size: 18,
                family: 'Graphik',
                weight: FontWeight.w500,
                callback: () async {
                  if (HeaderSingleton().ekycStatus.value!.businessPanVerifyStatus == "1" && HeaderSingleton().ekycStatus.value!.aadhaarVerifySataus == "1") {
                    if (HeaderSingleton().ekycStatus.value!.businessPanVerifyStatus == "1" && HeaderSingleton().ekycStatus.value!.appUserType == "0") {
                      checkDetails();
                    } else {
                      checkDetails();
                    }
                  } else if (HeaderSingleton().ekycStatus.value!.businessPanVerifyStatus != "1") {
                    if (HeaderSingleton().ekycStatus.value!.aadhaarVerifySataus == "1") {
                      checkDetails();
                    } else {
                      WidgetUtils.errorDialog(context, "Please verify aadhar".tr);
                    }
                  }
                },
                textColor: Color(int.parse(themeColor.value.buttonTextColor!.color!)),
                color: Color(int.parse(themeColor.value.buttonColor!.color!))),
          ),
        ),
      ),
    );
  }

  Future checkDetails() async {
    try {
      final response = await APIService.postAPIMethod(url: ApiURL.profileStep1, params: {'btn_submit': 'submit', 'step': '3', 'id': userId, "edit_profile": "0"});
      final result = json.decode(response.body);
      if (result['success'] == 1) {
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
      } else {
        WidgetUtils.errorDialog(context, result['message']);
      }
    } catch (e) {
      rethrow;
    }
  }
}
