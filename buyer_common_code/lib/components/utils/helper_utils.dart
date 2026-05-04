import 'package:buyer_common_code/model/User.dart' as data;
import 'package:buyer_common_code/model/home_page_model.dart';
import 'package:buyer_common_code/model/statistics_filter.dart';
import 'package:buyer_common_code/model/statistics_report_model.dart';
import 'package:buyer_common_code/pages/about_us/terms_condition.dart';
import 'package:buyer_common_code/pages/helpdesk/helpdesk_screen.dart';
import 'package:buyer_common_code/pages/marketPlace/demand/AddDemandScreen.dart';
import 'package:buyer_common_code/pages/marketPlace/incentive/MyIncentiveScreen.dart';
import 'package:buyer_common_code/pages/marketPlace/marketable_surplus/MarketableSurplusScreen.dart';
import 'package:buyer_common_code/pages/marketPlace/nedfi_products/MyStatScreen.dart';
import 'package:buyer_common_code/pages/marketPlace/nedfi_products/nedfi_advertisement/nedfi_advertisement.dart';
import 'package:buyer_common_code/pages/marketPlace/product_screen/MarketMainScreen.dart';
import 'package:buyer_common_code/pages/partner/PartnerListingScreen.dart';
import 'package:buyer_common_code/pages/webView/PWAIframe.dart';
// import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart' as p;
import 'package:share_plus/share_plus.dart';

import '../../app_imports.dart';
import '../../model/CityResponse.dart';
import '../../model/CountryResponse.dart';
import '../../model/NewProducts.dart';
import '../../model/StateResponse.dart';
import '../../model/helpdesk_ticket_model.dart';
import '../../model/kyc_status.dart';
import '../../model/master_listing_model.dart';
import '../../model/trade_product_info.dart';
import '../../pages/advisory/AdvisoryCropScreen.dart';
import '../../pages/login_screen/LoginScreen.dart';
import '../../pages/manage_chat/manage_chat_listing.dart';
import '../../pages/marketPlace/demand/BuyerDemandMainScreen.dart';
import '../../pages/marketPlace/nedfi_products/product_list/NedfiProductListScreen.dart';
import '../../pages/marketPlace/product_screen/MarketPlaceScreen.dart';
import '../../pages/marketPlace/seller/SellerHomeScreen.dart';
import '../../pages/webView/net_caret_iframe.dart';

class NotificationTopics {
  static const String video = "eMeeting";
  static const String chat = "chat";
  static const String disconnectCall = "disconnect call";
  static const String notice = "Notice";
  static const String announcement = "Announcement";
  static const String blogs = "Blogs";
}

class HelperUtils {
  var isFarmer = 0;
  late PermissionStatus _permissionGranted;
  String currentLat = "", currentLog = "", city = "", local = "en";
  late bool _serviceEnabled;
  Location location = Location();

  late data.UserData paramsMaps;

  /// Checking whether user is farmer/Customer.
  Future<int?> getIsFarmer(BuildContext context) async {
    isFarmer = (await SharePrefsHelper.getInstance(context)?.getIntValue("Is_farmer")) ?? 0;
    return isFarmer;
  }

  /// Getting Added product list for cart.
  Future<List<ProductsList>> getProductList(BuildContext context) async {
    return SQLiteDbProvider.db.getAllProducts();
  }

  Future getSplashImage() async {
    try {
      final response = await APIService.getAPIMethod(url: ApiURL.splashScreen);
      final data = json.decode(response.body);
      var res = SplashResponse.fromJson(data);
      if (res.success == 1) {
        final filePath = await WidgetUtils.splashFromImageUrl(res.clientLogo);
        final logoFile = await WidgetUtils.logoFromImageUrl(res.clientImage);
        image = filePath.path;
        imgPlaceHolder = logoFile.path;
        networkImageLogo.value = res.clientImage.toString();
        return Tuple2<String, String>(imgPlaceHolder, image);
      }
    } catch (e) {
      rethrow;
    }
  }

  /// Getting User model information data.
  Future getUserModel(BuildContext context) async {
    paramsMaps = (await SharePrefsHelper.getInstance(context)?.getUserModel())!;
    return paramsMaps;
  }

  ///Getting Language Locale for translations.
  Future<String> getLangLocale(BuildContext context) async {
    local = (await SharePrefsHelper.getInstance(context)?.getStringValue("locale")) ?? "en";
    return local;
  }

  /// Initialising the location permission and getting the weather details.
  Future initLocation(Function(Tuple2<String, String>) refreshState, Function state, {bool? isWeatherActive = false}) async {
    try {
      refreshState.call(Tuple2(HeaderSingleton().lat, HeaderSingleton().lng));
      LocationData _locationData;
      _serviceEnabled = await location.serviceEnabled();
      if (!_serviceEnabled) {
        _serviceEnabled = await location.requestService();
        if (!_serviceEnabled) {
          return;
        }
      }
      _permissionGranted = await location.hasPermission();
      if (_permissionGranted == PermissionStatus.denied) {
        _permissionGranted = await location.requestPermission();
        if (_permissionGranted != PermissionStatus.granted) {
          return;
        }
      }
      _locationData = await location.getLocation();
      if (_locationData != null) {
        currentLat = _locationData.latitude.toString();
        currentLog = _locationData.longitude.toString();
        HeaderSingleton().setLatLog(currentLat, currentLog);
        headerParams['group_id'] = '1';
        headerParams['lat'] = currentLat;
        headerParams['long'] = currentLog;
        refreshState.call(Tuple2(currentLat, currentLog));
      } else {
        if (currentLat.isNotEmpty && currentLog.isNotEmpty) {
          refreshState.call(Tuple2(currentLat, currentLog));
        } else {
          refreshState.call(Tuple2(HeaderSingleton().lat, HeaderSingleton().lng));
        }
      }
    } catch (e) {
      rethrow;
    }
  }

  /// Getting weather details from the openWeather API.
  /// [lat] is used from latitude and [log] is used for the longitude
  /// On the basis of current location the weather details will be fetched from API.
  Future getWeather(String lat, String log, Function refreshState) async {
    try {
      final response = await http.get(Uri.parse("https://nominatim.openstreetmap.org/reverse?format=json&lat=$lat&lon=$log"));
      var datas = json.decode(response.body);
      if (datas["address"]?["city"] == "Nashik") {
        city = 'Nasik';
      } else {
        if (datas["address"]?["city"] != null && datas["address"]?["city"] != "") {
          city = datas["address"]?["city"] ?? "";
        } else if (datas["address"]?["town"] != null && datas["address"]?["town"] != "") {
          city = datas["address"]?["town"] ?? "";
        } else if (datas["address"]?["village"] != null && datas["address"]?["village"] != "") {
          city = datas["address"]?["village"] ?? "";
        } else {
          city = getShortLocationName(datas["display_name"]);
        }
      }
      HeaderSingleton().setCityLocation(city);
      final weatherResponse = await http.post(Uri.parse(
          "https://api.weatherapi.com/v1/forecast.json&current.json?key=9963cb872044467395584248231703&q=${city + "%20" + datas["address"]?["state"] + "%20" + datas["address"]?["country"]}&days=7&aqi=yes"));
      var data = json.decode(weatherResponse.body);
      // // print(data);
      var res = WeatherModel.fromJson(data);
      if (res.location?.name != null) {
        res.location?.name = city;
        res.location?.region = datas["address"]?["state"];
        res.location?.country = datas["address"]?["country"];
        HeaderSingleton().setWeatherDetails(res);
      }
    } catch (e) {
      // // isLoading.value = false;
      refreshState.call();
      rethrow;
    }
  }

  /// function to return the first two names of the string location
  static String getShortLocationName(String s) {
    List<String> wordList = s.split(" ");

    if (wordList.isNotEmpty) {
      if (wordList.length > 1) {
        return wordList[0] + " " + wordList[1];
      } else {
        return wordList[0];
      }
    } else {
      return " ";
    }
  }

  /// Getting images from the gallery.
  Future getFromGallery(BuildContext contexts, int index, {bool isMultiImagePick = false, isDocumentPick = false}) async {
    if (isDocumentPick) {
      List<File> selectedPicture = [];
      List<XFile> image = (await ImagePicker().pickMultipleMedia());
      for (int i = 0; i < image.length; i++) {
        if (i < 3) {
          if (image[i].path.endsWith(".gif")) {
            WidgetUtils.errorDialog(contexts, 'GIF image not allowed'.tr);
          } else {
            File file = File(image[i].path);
            dynamic fileCollected = checkFileSize(contexts, file, image[i]);
            if (fileCollected != null && fileCollected != File('')) {
              selectedPicture.add(File(image[i].path));
            }
          }
        }
      }
      return selectedPicture;
    }
    if (isMultiImagePick) {
      List<File> selectedPicture = [];
      List<XFile> image = (await ImagePicker().pickMultiImage());
      for (int i = 0; i < image.length; i++) {
        if (i < 3) {
          if (image[i].path.endsWith(".gif")) {
            WidgetUtils.errorDialog(contexts, 'GIF image not allowed'.tr);
          } else {
            selectedPicture.add(File(image[i].path));
          }
        }
      }
      return selectedPicture;
    }
    XFile? pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery, imageQuality: 50, maxWidth: 300, maxHeight: 400);
    if (pickedFile != null) {
      return pickedFile;
    }
  }

  File? checkFileSize(BuildContext contexts, File file, XFile image) {
    String size = getFileSize(bytes: file.lengthSync());
    List<String> sizeList = size.split(" ");

    if (image.path.endsWith(".pdf")) {
      if (sizeList[1] == "mb") {
        if (int.parse(sizeList[0]) < 3) {
          return File(image.path);
        } else {
          WidgetUtils.errorDialog(contexts, 'File size should not contain more than 3 mb'.tr);
          return null;
        }
      } else if (sizeList[1] == "kb") {
        return File(image.path);
      } else {
        WidgetUtils.errorDialog(contexts, 'File size should not contain more than 3 mb'.tr);
        return null;
      }
    }
    if (sizeList[1] == "mb") {
      if (int.parse(sizeList[0]) < 10) {
        return File(image.path);
      } else {
        WidgetUtils.errorDialog(contexts, 'File size should not contain more than 10 mb'.tr);
        return null;
      }
    } else if (sizeList[1] == "gb") {
      WidgetUtils.errorDialog(contexts, 'File size should not contain more than 10 mb'.tr);
      return null;
    } else if (sizeList[1] == "tb") {
      WidgetUtils.errorDialog(contexts, 'File size should not contain more than 10 mb'.tr);
      return null;
    } else if (sizeList[1] == "kb" || sizeList[1] == "bytes") {
      return File(image.path);
    }
    return null;
  }

  /// Get from Camera
  Future getFromCamera(BuildContext contexts, int index) async {
    XFile? pickedFile = await ImagePicker().pickImage(source: ImageSource.camera, imageQuality: 50, maxWidth: 300, maxHeight: 400);
    if (pickedFile != null) {
      return pickedFile;
    }
  }

  static String getFileSize({required int bytes, int decimals = 0}) {
    if (bytes <= 0) return "0 bytes";
    const suffixes = [" bytes", "kb", "mb", "gb", "tb"];
    var i = (log(bytes) / log(1024)).floor();
    return ((bytes / pow(1024, i)).toStringAsFixed(decimals)) + " " + suffixes[i];
  }

  /// The Normal dialog box for the Yes/No Button.
  dynamic showNormalDialog(
      {String? imagePath,
      required BuildContext context,
      required String title,
      required String content,
      required Function(BuildContext conetxtValue) onYesTapped,
      Function(BuildContext)? noTapped,
      bool barearFlag = true}) {
    showDialog(
        barrierDismissible: barearFlag,
        context: context,
        builder: (ctx) => Dialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Container(
                height: imagePath == null ? 200 : 300,
                width: 600,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                margin: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    imagePath == null ? Container() : SvgPicture.asset("assets/images/$imagePath", height: 108, width: 108),
                    WidgetUtils.appTextWidget(context: context, title: title, color: Colors.black, fontSize: 18, family: 'Graphik', fontWeight: FontWeight.w500),
                    const SizedBox(height: 20),
                    WidgetUtils.appTextWidget(context: context, title: content, color: Colors.black, fontSize: 14, family: 'Graphik', fontWeight: FontWeight.w400),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: 550,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          InkWell(
                            onTap: () {
                              if (noTapped != null) {
                                noTapped.call(ctx);
                              }
                              if (noTapped != null) {
                                Navigator.of(ctx).pop(false);
                              } else {
                                Navigator.of(ctx).pop(false);
                              }
                            },
                            child: Container(
                              width: 95,
                              height: 45,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                  border: Border.all(width: 1, color: Color(int.parse(themeColor.value.iconColor!.color!))), color: Colors.transparent, borderRadius: BorderRadius.circular(8)),
                              child: WidgetUtils.appTextWidget(
                                  context: context, title: "key_no".tr, fontSize: 18, family: 'Graphik', fontWeight: FontWeight.w500, color: Color(int.parse(themeColor.value.iconColor!.color!))),
                            ),
                          ),
                          const SizedBox(width: 20),
                          InkWell(
                            onTap: () {
                              onYesTapped.call(ctx);
                            },
                            child: Container(
                              width: 95,
                              height: 45,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                  border: Border.all(width: 1, color: Color(int.parse(themeColor.value.iconColor!.color!))),
                                  color: Color(int.parse(themeColor.value.iconColor!.color!)),
                                  borderRadius: BorderRadius.circular(8)),
                              child: WidgetUtils.appTextWidget(context: context, title: "key_yes".tr, fontSize: 18, family: 'Graphik', fontWeight: FontWeight.w500, color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ));
  }

  Future getKYCStatus(Function call) async {
    try {
      final response = await APIService.postAPIMethod(url: ApiURL.getKYCStatus, params: {"user_id": userId});
      final res = EKYCStatus.fromJson(json.decode(response.body));
      if (response.statusCode == 200) {
        HeaderSingleton().setEKYCStatus(res);
        call.call();
      }
      // isLoading.value=true;
    } catch (e) {
      // print(e.toString());
      isLoading.value = false;
      call.call();
    }
  }

  /// Getting Product Report for statistics
  Future getProductReport(Function call, {String? year = ""}) async {
    try {
      final response = await APIService.postAPIMethod(url: ApiURL.getProductReport, params: {"user_id": userId, "year": year});
      final res = StatisticsReportModel.fromJson(json.decode(response.body));
      if (response.statusCode == 200) {
        productReport.value = res.data ?? [];
        call.call();
      }
    } catch (e) {
      isLoading.value = false;
      call.call();
    }
  }

  /// Getting Product Report for statistics
  Future getNewProduct(Function call, {String? year = ""}) async {
    try {
      final response = await APIService.postAPIMethod(url: ApiURL.newProduct, params: {"buyer_id": userId, "prod_cat_id": year});
      final res = NewProducts.fromJson(json.decode(response.body));
      if (response.statusCode == 200) {
        newProduct.value = res.data ?? [];
        call.call();
      }
    } catch (e) {
      isLoading.value = false;
      call.call();
    }
  }

  /// Getting Product Report for statistics
  Future getTrendingProduct(Function call, {String? year = ""}) async {
    try {
      final response = await APIService.postAPIMethod(url: ApiURL.trendingProduct, params: {"buyer_id": userId, "prod_cat_id": year});
      final res = NewProducts.fromJson(json.decode(response.body));
      if (response.statusCode == 200) {
        trendingProduct.value = res.data ?? [];
        call.call();
      }
    } catch (e) {
      isLoading.value = false;
      call.call();
    }
  }

  /// Get statistics filter report.
  Future getStatFilter(Function call) async {
    try {
      final response = await APIService.getAPIMethod(url: ApiURL.getHomeFilter);
      final res = StatisticsFilterModel.fromJson(json.decode(response.body));
      if (response.statusCode == 200) {
        filterData.value = res.data ?? [];
        if (res.data!.isNotEmpty) {
          statType = res.data![0].title!;
        }
        call.call();
      }
    } catch (e) {
      isLoading.value = false;
      call.call();
    }
  }

  Future<bool> onWillPop(BuildContext context) async {
    return (await HelperUtils().showNormalDialog(
            context: context,
            title: 'Are_you_sure'.tr,
            content: 'Do you want to exit an App'.tr,
            onYesTapped: (value) async {
              Navigator.pop(value);
              SystemNavigator.pop();
            })) ??
        false;
  }

  /// Getting the service category.
  Future<List<Services>> getCategory(BuildContext context) async {
    List<Services> result = [];
    try {
      final response = await APIService.getAPIMethod(url: ApiURL.getCategories);
      final res = json.decode(response.body);
      if (res['status'] == 1) {
        for (int i = 0; i < res['data'].length; i++) {
          result.add(Services.fromJson(res['data'][i]));
        }
        final homeDashboardModel = Provider.of<HomeDashboardProvider>(context, listen: false);
        final profileModel = Provider.of<UserLoanProfileProvider>(context, listen: false);
        homeDashboardModel.setHomeCatagoryList(result);
        var navigationModel = Provider.of<NavigationProvider>(context, listen: false);
        if (profileModel.profileData.isNotEmpty) {
          navigationModel.setProfileImage(res['config_url']['partner_img_url'] + profileModel.profileData[0].profileImage!);
          return result;
        }
        result = result;
      }
    } catch (e) {
      rethrow;
    }
    return result ?? [];
  }

  Future getCountry(Function(bool) callBack, BuildContext context) async {
    callBack.call(true);
    try {
      final response = await APIService.getAPIMethod(url: ApiURL.getCountries);
      final data = json.decode(response.body);
      final res = CountryResponse.fromJson(data);
      if (res.status == 1) {
        final loanModel = Provider.of<LoanProvider>(context, listen: false);
        loanModel.setCountry(res.data);
      }
      callBack.call(false);
    } catch (e) {
      // print(e.toString());
      callBack.call(false);
    }
  }

  ///Getting state list in LOS module.
  Future getState(Function(bool) callBack, BuildContext context) async {
    callBack.call(true);
    try {
      Map<String, dynamic> params1 = {"type": "1", "country_id": "101"};
      final response = await APIService.postAPIMethod(url: ApiURL.getStates, params: params1);
      final data = json.decode(response.body);
      var res = StateResponse.fromJson(data);
      if (res.status == 1) {
        final loanModel = Provider.of<LoanProvider>(context, listen: false);
        loanModel.setStates(res.data);
      }
      callBack.call(false);
    } catch (e) {
      // print(e.toString());
      callBack.call(false);
      isLoading.value = false;
    }
  }

  Future<List<CityData>?> getCity(String stateID, Function(bool) callBack, BuildContext context) async {
    callBack.call(true);
    try {
      Map<String, dynamic> params1 = {"type": "1", "state_id": stateID};
      final response = await APIService.postAPIMethod(url: ApiURL.getCities, params: params1);
      final data = json.decode(response.body);
      var res = CityResponse.fromJson(data);
      if (res.status == 1) {
        // final loanModel = Provider.of<LoanProvider>(context, listen: false);
        //loanModel.setCity(res.data);
        return res.data;
      }

      callBack.call(false);
    } catch (e) {
      callBack.call(false);
    }
    return null;
  }

  void chooseFileSelection(int index, BuildContext context, {Function(Tuple2<dynamic, dynamic>)? getResult, String? title = "Camera"}) async {
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
                        final filePath = await HelperUtils().getFromCamera(ctx, index);
                        if (index == 0) {
                          if (getResult != null) {
                            getResult.call(Tuple2(File(filePath.path), ctx));
                          }
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
                        final filePath = await HelperUtils().getFromGallery(ctx, index);
                        String fileExtension = p.extension(filePath.path, 2);
                        if (fileExtension.toString() != ".gif") {
                          if (getResult != null) {
                            getResult.call(Tuple2(File(filePath.path), ctx));
                          }
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

  getColorStatus(String title) {
    Color? statusColors;
    statusColors = const Color(0xffFFFF00);
    switch (title) {
      case "Pending":
        statusColors = const Color(0xffFF0000);
        break;
      case "Paid":
        statusColors = const Color(0xff18541c);
        break;
      case "Complete":
        statusColors = const Color(0xff18541c);
        break;
      default:
        statusColors = const Color(0xff7c7c2a);
        break;
    }
    return statusColors;
  }

  Future navigateToScreens({List<SeasonData>? seasonData, required BuildContext context, required String mapKey, dynamic params, WeatherModel? weather, String? url, Function? call}) async {
    /*if (mapKey.toLowerCase() == "invite") {
      _createDynamicLinkFarmer(false, context);
    } else*/
    if (mapKey.toLowerCase() == 'logout') {
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
            await SharePrefsHelper.getInstance(context)?.saveStringValue("userTypeSelected", "");
            await SharePrefsHelper.getInstance(context)?.saveBoolValue("is_user_log", false);
            await SharePrefsHelper.getInstance(context)?.saveBoolValue("isLogin", false);
            Navigator.of(value).pop(false);
            isLoading.value = true;
            call!.call();
            await logout(context, () => call.call());
            call.call();
          });
    } else if (mapKey.toLowerCase() == 'privacypolicy') {
      return launchURL(url: HeaderSingleton().privacy_policy ?? "");
    } else if (mapKey.toLowerCase() == 'terms_condition') {
      return launchURL(url: HeaderSingleton().teamandCon ?? "");
    } else if (params != null && (mapKey.toString().toLowerCase() != 'banking' && mapKey.toString().toLowerCase() != 'crop_advisory')) {
      return Navigator.push(context, MaterialPageRoute(builder: (ctx) => PartnerListingScreen(params['id'], params['name'])));
    } else {
      return Navigator.push(context, MaterialPageRoute(builder: (ctx) {
        return mapKey.toString().toLowerCase() == 'products_list'
            ? const NedfiProductListScreen(isFrom: "")
            : mapKey.toString().toLowerCase() == 'helpdesk'
                ? const HelpDeskScreen()
                : mapKey.toString().toLowerCase() == 'chat'
                    ? const ManageChatListingScreen()
                    : mapKey.toString().toLowerCase() == 'my-stats'
                        ? const MyStatScreen()
                        : mapKey.toString().toLowerCase() == 'add-demand'
                            ? const AddDemandScreen()
                            : mapKey.toString().toLowerCase() == 'price_discovery'
                                ? const CommodityScreen()
                                : mapKey.toString().toLowerCase() == 'surplus'
                                    ? const MarketableSurplusScreen()
                                    : mapKey.toString().toLowerCase() == 'my_incentive'
                                        ? const MyIncentiveScreen()
                                        : mapKey.toString().toLowerCase() == 'demand_interest'
                                            ? const BuyerDemandMainScreen()
                                            : mapKey.toString().toLowerCase() == 'terms_condition'
                                                ? const TermsCondition(route: "")
                                                : mapKey.toString().toLowerCase() == 'advertisings'
                                                    ? const NedfiAdvertisement()
                                                    : mapKey.toString().toLowerCase() == 'market-pwa'
                                                        ? PWAIFrame(routeName: 'Home')
                                                        : mapKey.toString().toLowerCase() == 'buy_product '
                                                            ? const ProductListScreen()
                                                            : mapKey.toString().toLowerCase() == 'sell_product '
                                                                ? SellerHomeScreen(onAddButtonTap: (value) {})
                                                                : mapKey.toString().toLowerCase() == 'buy_and_sell'
                                                                    ? const MarketMainScreen()
                                                                    : mapKey.toString().toLowerCase() == 'banking'
                                                                        ? const LoanTypeScreen()
                                                                        : mapKey.toString().toLowerCase() == 'rewards'
                                                                            ? NetCaretIFrame(url!)
                                                                            : mapKey.toString().toLowerCase() == 'crop_advisory'
                                                                                ? const AdvisoryCropScreen()
                                                                                : mapKey.toString().toLowerCase() == 'myfarms'
                                                                                    ? FarmListScreen()
                                                                                    : mapKey.toString().toLowerCase() == 'weather-forcast'
                                                                                        ? WeatherForecastScreen(weatherModel: weather!)
                                                                                        : mapKey.toString().toLowerCase() == 'commodity'
                                                                                            ? const CommodityScreen()
                                                                                            : mapKey.toString().toLowerCase() == 'npkcalculator'
                                                                                                ? NPKCalculatorScreen(seasonData: seasonData!)
                                                                                                : mapKey.toString().toLowerCase() == 'aboutus'
                                                                                                    ? const AboutUsScreen()
                                                                                                    : mapKey.toString().toLowerCase() == 'applyforloan'
                                                                                                        ? const LoanTypeScreen()
                                                                                                        : mapKey.toString().toLowerCase() == 'announcement'
                                                                                                            ? const AnnouncementScreen("Announcement")
                                                                                                            : mapKey.toString().toLowerCase() == 'notice'
                                                                                                                ? const AnnouncementScreen("Notice")
                                                                                                                : mapKey.toString().toLowerCase() == 'myorders'
                                                                                                                    ? const MyOrderScreen()
                                                                                                                    : mapKey.toString().toLowerCase() == 'dss'
                                                                                                                        ? const CropListScreen(isStatus: 'DSS')
                                                                                                                        : mapKey.toString().toLowerCase() == 'category'
                                                                                                                            ? const ServicesScreen(services: [])
                                                                                                                            : mapKey.toString().toLowerCase() == 'marketplace'
                                                                                                                                ? const MarketPlaceScreen()
                                                                                                                                : mapKey.toString().toLowerCase() == 'market'
                                                                                                                                    ? const ProductListScreen()
                                                                                                                                    : mapKey.toString().toLowerCase() == 'media'
                                                                                                                                        ? const MediaScreen()
                                                                                                                                        : mapKey.toString().toLowerCase() == 'profile'
                                                                                                                                            ? const ProfileScreen()
                                                                                                                                            : mapKey.toString().toLowerCase() == 'setting'
                                                                                                                                                ? SettingScreen(HeaderSingleton().appUserType)
                                                                                                                                                : const Scaffold(
                                                                                                                                                    backgroundColor: Colors.white,
                                                                                                                                                    body: Center(child: Text("No Screen Found")));
      })).then((value) => isLoading.value = false);
    }
  }
/*
  Future<void> _createDynamicLinkFarmer(bool short, BuildContext context) async {
    FirebaseDynamicLinks dynamicLinks = FirebaseDynamicLinks.instance;
    final DynamicLinkParameters parameters = DynamicLinkParameters(
      uriPrefix: HeaderSingleton().routeName == "famrut" ? 'https://famrut.page.link/reMM/' : 'https://agriecosystem.page.link/hSLQ/',
      link: Uri.parse(HeaderSingleton().routeName == "famrut" ? 'https://famrut.page.link/reMM/?invite=' : 'https://agriecosystem.page.link/hSLQ/?invite=' + HeaderSingleton().domain.value),
      androidParameters: AndroidParameters(packageName: HeaderSingleton().routeName == "famrut" ? 'com.esds.famrut' : 'com.esds.agriecosystem', minimumVersion: 0),
    );
    Uri url;
    String? shareText;
    if (short) {
      final ShortDynamicLink shortLink = await dynamicLinks.buildShortLink(parameters);
      url = shortLink.shortUrl;
      shareText = HeaderSingleton().routeName == "famrut" ? "Famrut" : "Agri Ecosystem" "\n" + url.toString() + "\n" + "Referral Code" + " : " + paramsMaps.myRefferalCode!;
      await Share.share(shareText, subject: HeaderSingleton().routeName == "famrut" ? "Famrut" : "Agri Ecosystem" */ /*, sharePositionOrigin: box.paintBounds*/ /*);
    } else {
      url = await dynamicLinks.buildLink(parameters); //await parameters.buildUrl();
      await Share.share(url.toString(), subject: HeaderSingleton().routeName == "famrut " ? "Famrut" : "Agri Ecosystem" */ /*, sharePositionOrigin:box.paintBounds*/ /*);
    }
  }*/
}

Future launchURL({String? url = 'https://www.famrut.com/privacy-policy.html'}) async {
  if (await canLaunch(url!)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}

Future<void> sendOtp(BuildContext context, String phone, Function onOTPCall, {Function(String)? getCallBack}) async {
  Map<String, dynamic> params1 = {"phone": phone};
  final response = await APIService.postAPIMethod(url: ApiURL.resendOTP, params: params1);
  final res = json.decode(response.body);
  if (res['success'] == 1) {
    WidgetUtils.successDialog(context, HeaderSingleton().local == 'en' ? "otpSent".tr + " $phone " : " $phone " + "otpSent".tr);
    onOTPCall.call();
    if (getCallBack != null) {
      getCallBack.call("active");
    }
  } else {
    WidgetUtils.errorDialog(context, (res['message']));
    if (getCallBack != null) {
      getCallBack.call("notactive");
    }
  }
}

getDateFormatNew(List<String> splitArray) {
  DateTime dateTime = DateTime(int.parse(splitArray[0]), int.parse(splitArray[1]), int.parse(splitArray[2]), int.parse(splitArray[3]), int.parse(splitArray[4]), int.parse(splitArray[5]));
  final value = DateFormat("dd MMM yyyy").add_jms().format(dateTime);
  return value;
}

getDateFormat(String splitArray) {
  // DateTime dateTime = DateTime(int.parse(splitArray[0]), int.parse(splitArray[1]), int.parse(splitArray[2]), int.parse(splitArray[3]), int.parse(splitArray[4]), int.parse(splitArray[5]));
  if (splitArray != "") {
    DateTime dateTime = DateFormat("yyyy-MM-dd HH:mm:ss").parse(splitArray);
    final value = DateFormat("dd MMM yyyy hh:mm a").format(dateTime);
    return value;
  } else {
    return splitArray;
  }
}

getMonthDateFormat(String splitArray) {
  if (splitArray != "") {
    DateTime dateTime = DateFormat("yyyy-MM-dd hh:mm:ss").parse(splitArray);
    final value = DateFormat("MMM yyyy").format(dateTime);
    return value;
  } else {
    return splitArray;
  }
}

Future getProductInformation(BuildContext context, String productId, Function callback, {bool prodCatStatus = false, String? prodCatId}) async {
  try {
    final response = await APIService.postAPIMethod(url: ApiURL.getTradeProducts, params: {'buyer_id': userId, 'start': '1', 'prod_cat_id': prodCatStatus ? prodCatId : '', 'id': productId});
    final result = TradeProductInfo.fromJson(jsonDecode(response.body));
    if (result.success == 1) {
      productData.value = result.data;
      sellerInvoicePath = result.sellerInvoicePath ?? "";
    } else {
      productData.value = result.data;
      WidgetUtils.errorDialog(context, result.message);
    }
    callback.call();
  } catch (e) {
    callback.call();
    isLoading.value = false;
    rethrow;
  }
}

Future getManageProductInformation(BuildContext context, String productId, Function callback) async {
  try {
    final response = await APIService.postAPIMethod(url: ApiURL.getManageProducts, params: {'buyer_id': userId, 'start': '1', 'prod_cat_id': '', 'id': productId});
    final result = TradeProductInfo.fromJson(jsonDecode(response.body));
    if (result.success == 1) {
      productData.value = result.data;
      sellerInvoicePath = result.sellerInvoicePath ?? "";
    } else {
      // WidgetUtils.errorDialog(context, result.message);
    }
    callback.call();
  } catch (e) {
    callback.call();
    // rethrow;
  }
}

Future deleteTradeProduct(BuildContext context, String productId, String isFrom) async {
  try {
    final response = await APIService.getAPIMethod(url: ApiURL.deleteTradeProduct + "/" + productId);
    final result = jsonDecode(response.body);
    if (result["data"]) {
      WidgetUtils.successDialog(context, result["message"]);
      if (isFrom == "details") {
        Future.delayed(const Duration(seconds: 1), () {
          Navigator.pop(context, 'true');
        });
      }
    } else {
      WidgetUtils.errorDialog(context, result["message"]);
    }
  } catch (e) {
    rethrow;
  }
}

Future checkTickets({String? status = '', String? ticketId = "", String userId = ""}) async {
  try {
    List<Tickets> tickets = [];
    List<TicketsCount> ticketsCount = [];
    final params = {'user_id': userId, 'ticket_id': ticketId, 'status': status};
    http.Response response = await http.post(Uri.parse("https://dev.famrut.com/support/api/tickets/getTicket"), body: params, headers: headerParams).timeout(const Duration(minutes: 1));
    if (response.statusCode == 200) {
      HelpDeskTicketModel helpDeskTicketModel = HelpDeskTicketModel.fromJson(json.decode(response.body));
      if (helpDeskTicketModel.success == 1) {
        if (helpDeskTicketModel.tickets!.isNotEmpty) {
          for (final details in helpDeskTicketModel.tickets!) {
            if (details.staffId == "0") {
              tickets.add(details);
            }
          }
          for (final ticketCount in helpDeskTicketModel.ticketsCount!) {
            ticketsCount.add(ticketCount);
          }
        }
      }
      streamController.value = tickets;
      ticketStreamController.value = ticketsCount;
      return helpDeskTicketModel;
    }
  } catch (e) {
    isLoading.value = false;
    rethrow;
  }
}

Future logout(BuildContext context, Function() call) async {
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
      SharePrefsHelper.getInstance(context)?.saveStringValue("address_check", "");

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
              timer.cancel();
              isLoading.value = false;
              Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const LoginScreen()), (Route<dynamic> route) => false);
              call.call();
            } else {
              _start--;
              call.call();
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

/// Getting notification unread count from API.
Future getNotificationsDetails() async {
  try {
    final response = await APIService.postAPIMethod(url: ApiURL.notificationCount, params: {'user_id': userId});
    final result = jsonDecode(response.body);
    if (result['success'].toString() == '1') {
      notificationResult?.value = result;
    }
  } catch (e) {
    rethrow;
  }
}

/// Getting the app master listing as per the domain..
Future getMasterListing() async {
  try {
    String connectionServerMsg = NetworkHandler.getServerWorkingUrl();
    if (connectionServerMsg != "key_check_internet") {
      final response = await APIService.getAPIMethod(url: ApiURL.getMasterListing);
      final data = MasterListing.fromJson(json.decode(response.body));
      if (data.success == 1 && data.data != null) {
        masterListing = data;
        productCategory.value = data.data?.productCategory ?? [];
        productCategoryTitle = data.data?.productCategory?[0].title ?? "";
      }
    }
  } catch (e) {
    rethrow;
  }
  isLoading.value = false;
}

extension CustomList<T> on List<T> {
  List<T> asReversed(bool isReverse) {
    return isReverse ? reversed.toList() : this;
  }

  T? elementAtOrNull(int index) {
    try {
      return this[index];
    } catch (_) {}
    return null;
  }
}
