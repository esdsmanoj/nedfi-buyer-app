import 'package:buyer_common_code/app_imports.dart';
import 'package:buyer_common_code/pages/user_details/business_details.dart';
import 'package:buyer_common_code/pages/user_details/user_kyc.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';

import '../../model/DomainResopnse.dart';
import '../../model/check_user.dart';
import '../../model/dynamic_theme.dart';
import '../login_screen/DomainScreen.dart';
import '../login_screen/LoginScreen.dart';
import 'WhiteLableSplashScreen.dart';

class SplashScreen extends StatefulWidget {
  final String route;
  final String splashImagePath, appDetailsName, domainName;

  const SplashScreen({Key? key, required this.route, required this.splashImagePath, required this.appDetailsName, required this.domainName}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool isLoading = false;
  double? bottom1;
  Size? size;
  dynamic isLogin = false;
  String domain = "", appName = "";
  AppUpdateInfo? _updateInfo;

  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();
  dynamic isFarmer = 0;
  bool isImageLoaded = false;

  Future<void> checkForUpdate() async {
    _updateInfo = await InAppUpdate.checkForUpdate();
    _updateInfo?.updateAvailability == UpdateAvailability.updateAvailable ? {startTimeForUpdate()} : null;
  }

  Future startTimeForUpdate() async {
    Future.delayed(const Duration(seconds: 2), () {
      InAppUpdate.performImmediateUpdate().catchError((e) => showSnack(e.toString()));
    });
  }

  void showSnack(String text) {
    if (scaffoldKey.currentContext != null) {
      ScaffoldMessenger.of(scaffoldKey.currentContext!).showSnackBar(SnackBar(content: Text(text)));
    }
  }

  @override
  void initState() {
    super.initState();
    domain = widget.domainName;
    appName = widget.appDetailsName;
    HeaderSingleton().getUserModel(context);
    WidgetUtils.getUserModel(context).then((value) => isLogin = value);
    WidgetUtils.getIsFarmer(context).then((value) => isFarmer = value);
    SharePrefsHelper.getInstance(context)?.getStringValue("whitelable").then((value) {
      if (value != null) {
        imgPlaceHolder = value;
      }
    });
    SharePrefsHelper.getInstance(context)?.getStringValue("logo").then((value) {
      if (value != null) {
        image = value;
      }
    });
    headerParams["client-type"] = "buyer";
    SharePrefsHelper.getInstance(context)?.getStringValue("domain").then((value) {
      if (value != null) {
        domain = value;
        HeaderSingleton().setDomain(value);
        headerParams["domain"] = value;
      }
    });
    SharePrefsHelper.getInstance(context)?.getStringValue("appname").then((value) {
      if (value != null) {
        appName = value;
        HeaderSingleton().setAppName(value);
        headerParams["appname"] = value;
      }
    });
    getDetails();
  }

  Future getDetails() async {
    // walkthroughEnabled = await SharePrefsHelper.getInstance(context)?.getStringValue('walkthrough') ?? '';
    // if (walkthroughEnabled == "" && walkthroughEnabled == null) {
    //   SharePrefsHelper.getInstance(context)?.saveStringValue('walkthrough', "true");
    //   walkthroughEnabled = "true";
    // } else {
    //   walkthroughEnabled = await SharePrefsHelper.getInstance(context)?.getStringValue('walkthrough') ?? '';
    // }
    userId = await SharePrefsHelper.getInstance(context)?.getStringValue("userId") ?? "";
    termsEnabled = await SharePrefsHelper.getInstance(context)?.getStringValue('termsEnabled') ?? '';
    isUserLogged = await SharePrefsHelper.getInstance(context)?.getBoolValue('is_user_log') ?? false;
    if (termsEnabled == "" || termsEnabled == null) {
      SharePrefsHelper.getInstance(context)?.saveStringValue('termsEnabled', "true");
      termsEnabled = "true";
    } else {
      termsEnabled = await SharePrefsHelper.getInstance(context)?.getStringValue('termsEnabled') ?? '';
    }
    lang = await SharePrefsHelper.getInstance(context)?.getStringValue('locale') ?? 'en';
    HeaderSingleton().setLang(lang);
    String countryCode = lang == 'en'
        ? 'US'
        : lang == 'mr'
            ? 'MR'
            : lang == 'hi'
                ? 'HI'
                : '';
    await Get.updateLocale(Locale(lang, countryCode));
    setState(() {
      isLoading = true;
    });
    headerParams["client-type"] = "buyer";
    headerParams["X-API-KEY"] = 'CODEX@123';
    headerParams["appname"] = isLogin == false ? 'nerace' : appName;
    headerParams["domain"] = isLogin == false ? 'nerace' : domain;
    await HeaderSingleton().getLocalize(context);
    fetchDomain().then((value) async {
      getTheme();
      getMasterListing();
      if (userId != null || userId.isNotEmpty) {
        await HelperUtils().getKYCStatus(() => setState(() {}));
      }
    });

    setStateIfMounted(() {
      isLoading = true;
    });
    HeaderSingleton().setAppUserType(isFarmer.toString());
    // await checkForUpdate();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFFFF),
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: Center(child: Image.asset(widget.splashImagePath, alignment: Alignment.center, width: 200)),
      ),
    );
  }

  Future startTime() async {
    String mobileNumber = await SharePrefsHelper.getInstance(context)?.getStringValue("mobile") ?? "";
    String userType = await SharePrefsHelper.getInstance(context)?.getStringValue("userType") ?? "0";
    HeaderSingleton().setAppUserType(userType);
    try {
      Future.delayed(const Duration(seconds: 4), () async {
        final response = await APIService.postAPIMethod(url: ApiURL.isRegistered, params: {"phone": mobileNumber});
        final data = CheckUser.fromJson(json.decode(response.body.toString()));
        if (data.isRegistered == 1) {
          if (data.data == null) {
            WidgetUtils.errorDialog(context, data.message ?? "");
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

            setState(() {});
            await logout(context, () => setState(() {}));
          } else {
            checkUserActive(
                data.data![0].activeStep == "1"
                    ? "1"
                    : data.data![0].activeStep == "2"
                        ? "2"
                        : data.data![0].activeStep == "3"
                            ? "3"
                            : "0",
                mobileNumber,
                userType);
          }
        } else {
          if (isUserLogged) {
            step1 = await SharePrefsHelper.getInstance(context)?.getStringValue("step1") ?? "";
            step2 = await SharePrefsHelper.getInstance(context)?.getStringValue("step2") ?? "";
            step3 = await SharePrefsHelper.getInstance(context)?.getStringValue("step3") ?? "";
            checkUserActive(
                step1.isNotEmpty && step1 == "completed"
                    ? "1"
                    : step2.isNotEmpty && step2 == "completed"
                        ? "2"
                        : step3.isNotEmpty && step3 == "completed"
                            ? "3"
                            : "0",
                mobileNumber,
                userType);
            return;
          }
          if (termsEnabled != '' && termsEnabled == "true") {
            SharePrefsHelper.getInstance(context)?.saveStringValue('termsEnabled', "false");
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (ctx) => ChangeLanguageScreen(route: widget.route, isFromHome: 'terms_condition')));
            return;
          }
          navigateToScreen();
        }
      });
    } catch (e) {
      rethrow;
    }
  }

  void navigateToScreen() {
    if (isLogin == false) {
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (ctx) => (widget.route == 'famrut' || widget.route == 'icar') || widget.route == 'nedfi' ? const LoginScreen() : const DomainScreen()),
          (Route<dynamic> route) => false);
    } else {
      if ((HeaderSingleton().routeName == 'famrut' || HeaderSingleton().routeName == 'icar') && HeaderSingleton().routeName == "nedfi") {
        headerParams['client_id'] = HeaderSingleton().paramsMaps!.userId!;
        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (BuildContext ctx) => const NavigationHomeScreen()), (Route<dynamic> route) => false);
      } else {
        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (ctx) => WhiteLableSplashScreen(image, isFrom: true)), (Route<dynamic> route) => false);
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

  /// Fetch Domain details for the login.
  Future fetchDomain() async {
    try {
      await FirebaseMessaging.instance.getToken().then((value) => null);

      final name = headerParams["appname"]!.isNotEmpty ? headerParams["appname"] : widget.appDetailsName;
      final code = headerParams["domain"]!.isNotEmpty ? headerParams["domain"] : widget.domainName;
      headerParams = {"appname": name!, "X-API-KEY": 'CODEX@123', "domain": code!, "lang": lang, "client-type": "buyer"};
      String connectionServerMsg = NetworkHandler.getServerWorkingUrl();
      if (connectionServerMsg != "key_check_internet") {
        if (HeaderSingleton().paramsMaps!.userId != null) {
          headerParams['client_id'] = HeaderSingleton().paramsMaps!.userId!;
        }

        final response = await APIService.getAPIMethod(url: ApiURL.dynamicDomainDBConnection);
        final data = json.decode(response.body);
        DomainResopnse npkResponse = DomainResopnse.fromJson(data);
        if (npkResponse.status != 1) {
          WidgetUtils.errorDialog(context, npkResponse.msg);
        } else {
          SharePrefsHelper.getInstance(context)?.saveStringValue("domain", npkResponse.data.domain);
          SharePrefsHelper.getInstance(context)?.saveStringValue("appname", npkResponse.data.appname);
          headerParams["appname"] = npkResponse.data.appname;
          HeaderSingleton().setXAPIKEY(npkResponse.data.xAPIKey);
          HeaderSingleton().setDomain(npkResponse.data.domain);
          HeaderSingleton().setAppName(npkResponse.data.appname);
          baseURL = npkResponse.apiBasePath;
          HelperUtils().getSplashImage().then((value) async {
            Tuple2<String, String>? details = value;
            SharePrefsHelper.getInstance(context)?.saveStringValue("whitelable", details!.item1);
            SharePrefsHelper.getInstance(context)?.saveStringValue("logo", details!.item2);
          });
          startTime();
          // await checkForUpdate();
        }
      }
    } catch (e) {
      rethrow;
    }
    setStateIfMounted(() {
      isLoading = false;
    });
  }

  /// Getting the app theme as per the domain..
  Future getTheme() async {
    try {
      final name = headerParams["appname"]!.isNotEmpty ? headerParams["appname"] : widget.appDetailsName;
      final code = headerParams["domain"]!.isNotEmpty ? headerParams["domain"] : widget.domainName;
      headerParams = {"appname": name!, "X-API-KEY": 'CODEX@123', "domain": code!, "lang": lang, "client-type": "buyer"};
      String connectionServerMsg = NetworkHandler.getServerWorkingUrl();
      if (connectionServerMsg != "key_check_internet") {
        if (HeaderSingleton().paramsMaps!.userId != null) {
          headerParams['client_id'] = HeaderSingleton().paramsMaps!.userId!;
        }
        // http.Response response = await http.get(Uri.parse(ApiURL.baseURL + ApiURL.dynamicTheme), headers: headerParams);

        final response = await APIService.getAPIMethod(url: ApiURL.dynamicTheme);
        final data = DynamicTheme.fromJson(json.decode(response.body));
        if (data.success == 1 && data.data != null) {
          themeColor.value = data.data!;
        }
      }
    } catch (e) {
      rethrow;
    }
    setStateIfMounted(() {
      isLoading = false;
    });
  }

  void setStateIfMounted(f) {
    if (mounted) setState(f);
  }
}
