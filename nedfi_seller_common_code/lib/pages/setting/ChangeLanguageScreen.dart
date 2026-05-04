import 'package:nedfi_seller_common_code/app_imports.dart';
import 'package:get/get.dart';
import 'package:getwidget/getwidget.dart';

import '../../model/language_model.dart';
import '../about_us/terms_condition.dart';

class ChangeLanguageScreen extends StatefulWidget {
  String isFromHome;
  String? route;

  ChangeLanguageScreen({Key? key, required this.isFromHome, this.route}) : super(key: key);

  @override
  _ChangeLanguageScreenState createState() => _ChangeLanguageScreenState();
}

class _ChangeLanguageScreenState extends State<ChangeLanguageScreen> {
  ValueNotifier<LanguageModel?> languageDetails = ValueNotifier(null);
  var isFarmer = 0;
  List<String> languages = [];
  LanguageModel? values;
  int indexs = 0;

  @override
  void initState() {
    super.initState();
    isLoading = ValueNotifier(false);
    // getLanguage();
    /*   getIsFarmer(context).then((value) {
      setState(() {
        isFarmer = value!;
      });
    });*/
    getLanguage();
  }

/*  Future<int?> getIsFarmer(BuildContext context) async {
    isFarmer = (await SharePrefsHelper.getInstance(context)?.getIntValue("Is_farmer")) ?? 0;
    return isFarmer;
  }*/

  Future<bool> getValue() async {
    return await true;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => (widget.isFromHome == "true") ? getValue() : HelperUtils().onWillPop(context),
      child: SafeArea(
        child: CustomProgressHandler(
            isLoading: isLoading.value,
            loadingText: "",
            child: Scaffold(
                backgroundColor: Colors.white,
                floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
                floatingActionButton: SizedBox(
                  height: 60,
                  child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: WidgetUtils.buttonWidget(
                          context: context,
                          radius: 8,
                          title: widget.isFromHome == "true" ? "key_change_language".tr : "key_continue".tr,
                          size: 18,
                          family: 'Graphik',
                          weight: FontWeight.w500,
                          callback: () {
                            var headerModels = HeaderSingleton();
                            Locale? locale;
                            // if (values?.data!.lang![indexs].langKey!.toLowerCase() != lang.toLowerCase()) {
                            if (values?.data!.lang![indexs].langKey!.toLowerCase() == 'en') {
                              locale = const Locale('en', 'US');
                            } else if (values?.data!.lang![indexs].langKey!.toLowerCase() == 'hi') {
                              locale = const Locale('hi', 'hi');
                            } else if (values?.data!.lang![indexs].langKey!.toLowerCase() == 'mr') {
                              locale = const Locale('mr', 'MR');
                            } else {}
                            Get.updateLocale(locale!);
                            lang = values!.data!.lang![indexs].langKey!.toLowerCase().toString();
                            SharePrefsHelper.getInstance(context)?.saveStringValue("locale", lang);
                            headerModels.setLang(lang);
                            headerParams = {"appname": HeaderSingleton().appName.value, "X-API-KEY": 'CODEX@123', "domain": HeaderSingleton().domain.value, "lang": lang};
                            setState(() {});
                            //   } else {
                            //     WidgetUtils.informationDialog(context, 'This Language already selected');
                            //   }
                            Provider.of<HomeDashboardProvider>(context, listen: false).setHomeCatagoryList([]);
                            Provider.of<HomeDashboardProvider>(context, listen: false).setAdsList([]);
                            getMasterListing();
                            isLoading.value = false;
                            setState(() {});
                            if (widget.isFromHome == "terms_condition" && widget.route != null) {
                              Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (BuildContext context) => TermsCondition(route: widget.route!)), (Route<dynamic> route) => false);
                            } else {
                              if (isFarmer == 0 && widget.isFromHome == "true") {
                                SharePrefsHelper.getInstance(context)?.saveIntValue("Is_farmer", isFarmer);
                                headerModels.setAppUserType(isFarmer.toString());
                                Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (BuildContext context) => const NavigationHomeScreen()), (Route<dynamic> route) => false);
                              } else {
                                Navigator.pop(context);
                              }
                            }
                          },
                          textColor: Color(int.parse(themeColor.value.buttonTextColor!.color!)),
                          color: Color(int.parse(themeColor.value.buttonColor!.color!)))),
                ),
                body: Container(
                  child: Stack(
                    children: [
                      Column(
                        children: [
                          const SizedBox(height: 62),
                          Center(
                            child: WidgetUtils.appTextWidget(context: context, title: 'Choose Language'.tr, fontWeight: FontWeight.w500, family: 'Graphik', fontSize: 18, color: Colors.black),
                          ),
                          const SizedBox(height: 5),
                          Center(
                            child: WidgetUtils.appTextWidget(
                                context: context, title: 'Please select a language that best suits your need'.tr, fontWeight: FontWeight.w400, family: 'Graphik', fontSize: 12, color: Colors.grey),
                          ),
                          const SizedBox(height: 42),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                            child: ValueListenableBuilder(
                              valueListenable: languageDetails,
                              builder: (BuildContext context, LanguageModel? value, Widget? child) {
                                values = value;
                                return value != null
                                    ? ListView.builder(
                                        shrinkWrap: true,
                                        itemBuilder: (ctx, index) {
                                          return InkWell(
                                            onTap: () async {
                                              // isLoading.value = true;
                                              indexs = index;
                                              lang = values!.data!.lang![indexs].langKey!.toLowerCase().toString();
                                              setState(() {});
                                            },
                                            child: Container(
                                              height: 58,
                                              margin: const EdgeInsets.only(bottom: 12),
                                              padding: const EdgeInsets.symmetric(horizontal: 12),
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                children: [
                                                  WidgetUtils.appTextWidget(
                                                      color: Colors.black, context: context, family: 'Graphik', title: value.data!.lang![index].langVal!, fontSize: 14, fontWeight: FontWeight.w400),
                                                  Padding(
                                                    padding: const EdgeInsets.only(top: 19.0),
                                                    child: GFRadio(
                                                      size: 20,
                                                      value: 0,
                                                      radioColor: Color(int.parse(themeColor.value.barColor!.color!)),
                                                      groupValue: lang.toString().toLowerCase() == value.data!.lang![index].langKey!.toString().toLowerCase() ? 0 : 1,
                                                      onChanged: (value) {},
                                                      inactiveIcon: null,
                                                      activeBorderColor: const Color(0xffCFCFCF),
                                                    ),
                                                  )
                                                ],
                                              ),
                                              decoration: BoxDecoration(
                                                  color:
                                                      lang.toString().toLowerCase() == value.data!.lang![index].langKey!.toString().toLowerCase() ? const Color(0xffFFF6E9) : const Color(0xffFFFFFF),
                                                  borderRadius: BorderRadius.circular(4),
                                                  border: Border.all(
                                                      color: lang.toString().toLowerCase() == value.data!.lang![index].langKey!.toString().toLowerCase()
                                                          ? Color(int.parse(themeColor.value.barColor!.color!)).withOpacity(0.8)
                                                          : const Color(0xffCFCFCF))),
                                            ),
                                          );
                                        },
                                        itemCount: value.data!.lang!.length,
                                      )
                                    : Container();
                              },
                            ),
                          ),
                        ],
                      ),
                      Positioned(
                          left: 20,
                          top: 20,
                          child: widget.isFromHome != "terms_condition"
                              ? InkWell(
                                  onTap: () {
                                    if (widget.isFromHome == "terms_condition" && widget.route != null) {
                                      HelperUtils().onWillPop(context);
                                    } else {
                                      Navigator.pop(context);
                                    }
                                  },
                                  child: const Icon(Icons.arrow_back, color: Colors.black))
                              : Container())
                    ],
                  ),
                ))),
      ),
    );
  }

  /// Getting all language results as per the configurations.
  Future getLanguage() async {
    try {
      isLoading.value = true;
      setState(() {});
      final response = await APIService.getAPIMethod(url: ApiURL.getLanguage);
      final result = LanguageModel.fromJson(json.decode(response.body));
      if (result.success == 1) {
        languageDetails.value = result;
      }
      isLoading.value = false;
      setState(() {});
      // return languageDetails.value;
    } catch (e) {
      rethrow;
    }
  }
}
