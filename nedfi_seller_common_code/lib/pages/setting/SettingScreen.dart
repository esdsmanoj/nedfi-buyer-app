import 'package:nedfi_seller_common_code/app_imports.dart';
import 'package:get/get.dart';
import 'package:nedfi_seller_common_code/pages/setting/DeleteAccountScreen.dart';

import '../login_screen/LoginScreen.dart';

class SettingScreen extends StatefulWidget {
  String isProfile;

  SettingScreen(this.isProfile, {Key? key}) : super(key: key);

  @override
  _SettingScreenState createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  ValueNotifier<bool> isLoading = ValueNotifier(false);
  String? _loadingText;
  late final double? elevation = 3.0;

  @override
  void initState() {
    super.initState();
    _loadingText = 'Loading . . .';
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            elevation: 0,
            centerTitle: true,
            backgroundColor: Color(int.parse(themeColor.value.barColor!.color!)),
            title: WidgetUtils.appTextWidget(context: context, title: 'Settings'.tr, color: Colors.white, fontSize: 18),
            leading: InkWell(onTap: () => Navigator.pop(context), child: const Icon(Icons.arrow_back, color: Colors.white)),
          ),
          body: CustomProgressHandler(
              isLoading: isLoading.value,
              loadingText: _loadingText!,
              child: SafeArea(
                  child: Scaffold( backgroundColor: Colors.white,
                      body: ListView(
                children: [
                  widget.isProfile == "0" ? const SizedBox(height: 15) : Container(),
                  widget.isProfile == "0"
                      ? true
                          ? Container()
                          : Padding(
                              padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                              child: getContactInfoUI(
                                  maxline: 2,
                                  icon: Icons.person,
                                  title: 'Profile'.tr,
                                  tap: () {
                                    Navigator.push(context, MaterialPageRoute(builder: (context) => const ProfileScreen()));
                                  }),
                            )
                      : Container(),
                  const SizedBox(height: 15),
                  Padding(
                    padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                    child: getContactInfoUI(
                      maxline: 2,
                      icon: Icons.g_translate_rounded,
                      title: 'Language'.tr,
                      tap: () async {
                        // showLocaleList();
                        Navigator.push(context, MaterialPageRoute(builder: (context) => ChangeLanguageScreen(isFromHome: "true")));
                      },
                    ),
                  ),
                   SizedBox(
                    height: 15,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 10.0,right: 10.0),
                    child: getContactInfoUI(
                        maxline: 2,
                        icon: Icons.no_accounts_outlined,
                        title: 'Delete Account'.tr,
                        tap: () async {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => Deleteaccountscreen()));

                        }
                    ),
                  ),
                  const SizedBox(height: 15),
                  // domainLink.toLowerCase() == "yltp"
                  //     ? Container()
                  //     : widget.isProfile == "1"
                  //         ? Padding(
                  //             padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                  //             child: getContactInfoUI(
                  //               maxline: 2,
                  //               icon: Icons.compare,
                  //               title: 'Switch user type to farmer'.tr,
                  //               tap: () async {
                  //                 changeTofarmer();
                  //               },
                  //             ),
                  //           )
                  //         : Padding(
                  //             padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                  //             child: getContactInfoUI(
                  //               maxline: 2,
                  //               icon: Icons.compare,
                  //               title: 'Switch user type to Ecommerce User'.tr,
                  //               tap: () async {
                  //                 changeToEcommerce();
                  //               },
                  //             ),
                  //           ),
                  // const SizedBox(
                  //   height: 15
                  // ),
                  true
                      ? Container()
                      : Padding(
                          padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                          child: getContactInfoUI(
                              maxline: 2,
                              icon: Icons.exit_to_app_rounded,
                              title: 'Logout'.tr,
                              tap: () async {
                                HelperUtils().showNormalDialog(
                                    context: context,
                                    title: 'Are_you_sure'.tr,
                                    content: 'Do_you_want_to_Logout_from_App'.tr,
                                    onYesTapped: (value) async {
                                      var marketPlaceModel = Provider.of<MarketPlaceProvider>(context, listen: false);
                                      marketPlaceModel.setClearCart();
                                      SQLiteDbProvider.db.deleteAll();
                                      await SharePrefsHelper.getInstance(context)?.saveStringValue("step1", "");
                                      await SharePrefsHelper.getInstance(context)?.saveStringValue("step2", "");
                                      await SharePrefsHelper.getInstance(context)?.saveStringValue("step3", "");
                                      await SharePrefsHelper.getInstance(context)?.saveStringValue("mobile", "");
                                      await SharePrefsHelper.getInstance(context)?.saveStringValue("step1_data", "");
                                      await SharePrefsHelper.getInstance(context)?.saveStringValue("step2_data", "");
                                      await SharePrefsHelper.getInstance(context)?.saveStringValue("userType", "0");
                                      await SharePrefsHelper.getInstance(context)?.saveBoolValue("is_user_log", false);
                                      await SharePrefsHelper.getInstance(context)?.saveBoolValue("isLogin", false);
                                      Navigator.of(value).pop(false);
                                      isLoading.value = true;
                                      setState(() {});
                                      await _logout();
                                      setState(() {});
                                    });
                              }),
                        ),
                ],
              ))))),
    );
  }

  Widget getContactInfoUI({IconData? icon, String? title, String? subtitle, VoidCallback? tap, int? maxline}) {
    return GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: tap,
        child: ListTile(
          dense: true,
          iconColor: Color(int.parse(themeColor.value.iconColor!.color!)),
          leading: Icon(icon, size: 30),
          title: WidgetUtils.appTextWidget(
              context: context,
              fontSize: 18,
              fontWeight: FontWeight.w400,
              family: 'Graphik',
              title: title ?? "",
              color: Color(int.parse(themeColor.value.textColor!.color!)),
              overflow: TextOverflow.ellipsis),
        ));
  }

  // changeTofarmer() {
  //   /*  showDialog(
  //       context: context,
  //       builder: (context) => AlertDialog(
  //         title: new Text('Are_you_sure'.tr),
  //         content: new Text(
  //             'Do you want to Switch user type'.tr),
  //         actions: <Widget>[
  //           TextButton(
  //             onPressed: () =>
  //                 Navigator.of(context).pop(false),
  //             child: new Text('key_no'.tr),
  //           ),
  //           TextButton(
  //             onPressed: () {
  //               Navigator.of(context).pop(false);
  //               if (int.parse(widget.isprofile) != 0) {
  //                 SharePrefsHelper.getInstance(context)
  //                     ?.saveIntValue("Is_farmer", 0);
  //                 var headerModels =
  //                 Provider.of<HeaderModel>(context, listen: false);
  //                 headerModels.setAppUserType(0.toString());
  //                 Navigator.push(
  //                     context,
  //                     MaterialPageRoute(
  //                         builder: (BuildContext context) =>
  //                             NavigationHomeSceen()));
  //               }
  //             },
  //             child: new Text('key_yes'.tr),
  //           ),
  //         ],
  //       ));*/
  //
  //   if (int.parse(widget.isProfile) != 0) {
  //     SharePrefsHelper.getInstance(context)?.saveIntValue("Is_farmer", 0);
  //     var headerModels = Provider.of<HeaderModel>(context, listen: false);
  //     headerModels.setAppUserType(0.toString());
  //     Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => const NavigationHomeScreen()));
  //   }
  // }

  // changeToEcommerce() {
  //   /* showDialog(
  //       context: context,
  //       builder: (context) => AlertDialog(
  //         title: new Text('Are_you_sure'.tr),
  //         content: new Text(
  //             'Do you want to Switch user type'.tr),
  //         actions: <Widget>[
  //           TextButton(
  //             onPressed: () =>
  //                 Navigator.of(context).pop(false),
  //             child: new Text('key_no'.tr),
  //           ),
  //           TextButton(
  //             onPressed: () {
  //               Navigator.of(context).pop(false);
  //               if (int.parse(widget.isprofile) != 0) {
  //                 SharePrefsHelper.getInstance(context)
  //                     ?.saveIntValue("Is_farmer", 0);
  //                 var headerModels =
  //                 Provider.of<HeaderModel>(context, listen: false);
  //                 headerModels.setAppUserType(0.toString());
  //                 Navigator.push(
  //                     context,
  //                     MaterialPageRoute(
  //                         builder: (BuildContext context) =>
  //                             NavigationHomeSceen()));
  //               }
  //             },
  //             child: new Text('key_yes'.tr),
  //           ),
  //         ],
  //       ));*/
  //
  //   if (int.parse(widget.isProfile) != 1) {
  //     SharePrefsHelper.getInstance(context)?.saveIntValue("Is_farmer", 1);
  //     var headerModels = Provider.of<HeaderModel>(context, listen: false);
  //     headerModels.setAppUserType(1.toString());
  //     Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => const EcommerceHomeScreen()));
  //   }
  // }

  // void changeUserList() async {
  //   /* showDialog(
  //       context: context,
  //       builder: (context) => AlertDialog(
  //         title: new Text(''.tr),
  //         content: new Text( 'Switch user type'.tr),
  //         actions: <Widget>[
  //           TextButton(
  //             onPressed: () {
  //               if (int.parse(widget.isprofile) != 0) {
  //                 SharePrefsHelper.getInstance(context)
  //                     ?.saveIntValue("Is_farmer", 0);
  //                 var headerModels =
  //                 Provider.of<HeaderModel>(context, listen: false);
  //                 headerModels.setAppUserType(0.toString());
  //                 Navigator.push(
  //                     context,
  //                     MaterialPageRoute(
  //                         builder: (BuildContext context) =>
  //                             NavigationHomeSceen()));
  //               }else{
  //                 Navigator.of(context).pop(false);
  //               }
  //             },
  //             child: new Text('Farmer'.tr),
  //           ),
  //           TextButton(
  //             onPressed: ()  {
  //               if (int.parse(widget.isprofile) != 1) {
  //                 SharePrefsHelper.getInstance(context)
  //                     ?.saveIntValue("Is_farmer", 1);
  //                 var headerModels =
  //                 Provider.of<HeaderModel>(context, listen: false);
  //                 headerModels.setAppUserType(1.toString());
  //                 Navigator.push(
  //                     context,
  //                     MaterialPageRoute(
  //                         builder: (BuildContext context) =>
  //                             EcommerceHomeScreen()));
  //               }else{
  //                 Navigator.of(context).pop(false);
  //               }
  //             },
  //             child: new Text('Ecommerce User'.tr),
  //           ),
  //         ],
  //       ));*/
  //   var projectLangss = ['Farmer'.tr, 'Ecommerce User'.tr];
  //   showCupertinoModalPopup(
  //     context: context,
  //     builder: (BuildContext context) => CupertinoActionSheet(
  //       message: CustomCupertinoActionMessage(
  //         message: 'Switch user type'.tr,
  //       ),
  //       actions: List<Widget>.generate(
  //         projectLangss.length,
  //         (index) => CustomCupertinoIconAction(
  //           isImage: true,
  //           actionText: projectLangss[index],
  //           actionIndex: index,
  //           onActionPressed: () {
  //             setState(() {
  //               isLoading = true;
  //               _loadingText = AppTranslations.of(context)?.text("key_applying_changes") ?? 'key_applying_changes'.tr;
  //               if (index == 0) {
  //                 if (int.parse(widget.isProfile) != index) {
  //                   SharePrefsHelper.getInstance(context)?.saveIntValue("Is_farmer", 0);
  //                   var headerModels = Provider.of<HeaderModel>(context, listen: false);
  //                   headerModels.setAppUserType(0.toString());
  //                   Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => const NavigationHomeScreen()));
  //                 }
  //               } else {
  //                 if (int.parse(widget.isProfile) != index) {
  //                   SharePrefsHelper.getInstance(context)?.saveIntValue("Is_farmer", 1);
  //                   var headerModels = Provider.of<HeaderModel>(context, listen: false);
  //                   headerModels.setAppUserType(1.toString());
  //                   Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => const EcommerceHomeScreen()));
  //                 }
  //               }
  //               isLoading = false;
  //             });
  //             // Navigator.pop(context);
  //           },
  //         ),
  //       ),
  //     ),
  //   );
  // }

  Future _logout() async {
    try {
      String connectionServerMsg = NetworkHandler.getServerWorkingUrl();
      if (connectionServerMsg != "key_check_internet") {
        final response = await APIService.getAPIMethod(url: ApiURL.userLogout + "/" + HeaderSingleton().paramsMaps!.phone!);
        var data = json.decode(response.body);
        SharePrefsHelper.getInstance(context)?.saveBoolValue("isLogin", false);
        SharePrefsHelper.getInstance(context)?.saveUserModel(UserData());
        SharePrefsHelper.getInstance(context)?.saveStringValue("Profile", "");
        SharePrefsHelper.getInstance(context)?.saveStringValue("whitelabel", "");
        SharePrefsHelper.getInstance(context)?.saveStringValue("logo", "");
        SharePrefsHelper.getInstance(context)?.saveStringValue("locale", "en");
        SharePrefsHelper.getInstance(context)?.saveStringValue("userTypeSelected", "");
        lang = 'en';
        HeaderSingleton().setLang('en');
        Get.updateLocale(const Locale('en', 'US'));
        if (data["success"] == 1) {
          HeaderSingleton().paramsMaps = null;
          var _start = 1;
          const oneSec = Duration(seconds: 1);
          Timer.periodic(
            oneSec,
            (Timer timer) {
              if (_start == 0) {
                setState(() {
                  timer.cancel();
                  isLoading.value = false;
                  Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const LoginScreen()), (Route<dynamic> route) => false);
                });
              } else {
                setState(() {
                  _start--;
                });
              }
            },
          );
        }
      }
    } catch (e) {
      isLoading.value = false;
      // print(e);
      WidgetUtils.informationDialog(context, e.toString());
    }
  }
}
