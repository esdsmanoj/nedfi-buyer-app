import 'package:get/get.dart';
import 'package:nedfi_seller_common_code/app_imports.dart';

import '../model/bottom_bar_menu.dart' as bottom;
import '../model/home_page_model.dart' as config;
import '../model/profile_model.dart';
import '../model/user_model/User.dart' as data;
import '../model/user_model/kyc_status.dart';

class HeaderSingleton {
  static final HeaderSingleton _instance = HeaderSingleton._internal();

  factory HeaderSingleton() {
    return _instance;
  }

  HeaderSingleton._internal();

  data.UserData? paramsMaps;
  String? image;
  String? privacyPolicy = "https://www.famrut.com/privacy-policy.html";
  String? teamandCon = "https://www.famrut.com/privacy-policy.html";
  bool isFirebaseActive = false;
  int id = 0;
  bool isSameInfoStatus = false;
  ValueNotifier<EKYCStatus?> ekycStatus = ValueNotifier(null);
  ValueNotifier<String?> businessType = ValueNotifier("");
  final GlobalKey<NavigatorState>? navigatorKey = GlobalKey<NavigatorState>();
  ValueNotifier<WeatherModel?> weatherStreamController = ValueNotifier(null);

  // ValueNotifier<HomeConfigurableModel?> homeConfigurableModel = ValueNotifier(null);
  // ValueNotifier<Map<String, String>> headerParam = ValueNotifier({});
  ValueNotifier<String> xAPIKey = ValueNotifier("CODEX@123"), domain = ValueNotifier(""), appName = ValueNotifier("");

  ValueNotifier<MenuResponse?> allMenuIcons = ValueNotifier(null);
  ValueNotifier<bottom.BottomMenuModel?> bottomMenu = ValueNotifier(null);
  ValueNotifier<ProfileModel?> profileDetails = ValueNotifier(null);
  dynamic isUserRegister;
  String appUserType = "0", lat = "19.9975", lng = "73.7898", qrImage = '', cityName = 'Nasik', routeName = '', userAddress = '', splashImage = "";

  // Map<String, String> get params => headerParam.value;

  config.ConfigUrl? configurationDetails;

  String local = "en";
  ValueNotifier<dynamic> imageValue = ValueNotifier('');

  void setPrivacyPolicy(final url) {
    privacyPolicy = url;
  }

  void setTermsAndCondtion(final url) {
    teamandCon = url;
  }

  void setConfigDetails(final details) {
    configurationDetails = details;
  }

  void setUserAddress(final address) {
    userAddress = address;
  }

  void setEKYCStatus(final status) {
    ekycStatus.value = status;
  }

  void setStatusInfo(final status) {
    isSameInfoStatus = status;
  }

  void setProfileImage(final imageData) {
    imageValue.value = imageData;
  }

  void setCityLocation(final city) {
    cityName = city;
  }

  void setRoute(final name) {
    routeName = name;
  }

  void setSplashImage(final name) {
    splashImage = name;
  }

  void setLatLog(String lats, String logs) {
    lat = lats;
    lng = logs;
  }

  void setXAPIKEY(String key) {
    xAPIKey.value = key;
    // headerParam.value["X-API-KEY"] = key;
  }

  setDomain(String dom) {
    domain.value = dom;
    // headerParam.value["domain"] = dom;
  }

  setAppName(String dom) {
    appName.value = dom;
    // headerParam.value["appname"] = dom;
  }

  setLang(String langs) {
    // lang.value = langs;
    local = langs;
    // headerParams["lang"] = langs;
  }

  void setAppUserType(String langs) {
    appUserType = langs;
    // headerParam.value["app_user_type"] = langs;
  }

  void setUserRegistered(final isRegister) {
    isUserRegister = isRegister;
    // headerParam.value["app_user_type"] = langs;
  }

  void setProfileDetails(final details) {
    profileDetails.value = details;
    if (profileDetails.value != null) {
      imageValue.value = profileDetails.value!.data[0].profileImage!;
    }
  }

  void setWeatherDetails(final details) {
    weatherStreamController.value = details;
  }

  Future getUserModel(BuildContext context) async {
    SharePrefsHelper.getInstance(context)?.getUserModel().then((value) => paramsMaps = value);
    if (paramsMaps != null && paramsMaps!.userId != null) {
      qrImage = "https://api.qrserver.com/v1/create-qr-code/?size=250x250&data=${paramsMaps!.userId!}";
    }
    final domainData = await SharePrefsHelper.getInstance(context)?.getStringValue('domain');
    final appData = (await SharePrefsHelper.getInstance(context)?.getStringValue('appname'));
    // if (domainData != null) {
    setDomain(domainData ?? 'famrut');
    // }
    // if (appData != null) {
    //   appName.value = appData;
    setAppName(appData ?? 'famrut');
    // }
    final locales = (await SharePrefsHelper.getInstance(context)?.getStringValue('locale')) ?? "en";
    setLang(locales);
    setXAPIKEY("CODEX@123");
    return paramsMaps;
  }

  Future<String> getLocalize(BuildContext context) async {
    local = (await SharePrefsHelper.getInstance(context)?.getStringValue("locale")) ?? "en";
    dynamic locale;
    if (local == 'en') {
      locale = const Locale('en', 'US');
    } else if (local == 'hi') {
      locale = const Locale('hi', 'hi');
    } else if (local == 'mr') {
      locale = const Locale('mr', 'MR');
    }
    lang = local;
    Get.updateLocale(locale);
    SharePrefsHelper.getInstance(context)?.saveStringValue("locale", local);
    setLang(local);
    return local;
  }

  void setAppDrawerMenu(final menu) {
    allMenuIcons.value = menu;
  }

  void setAppBottomMenu(final menu) {
    bottomMenu.value = menu;
  }
}
