import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:nedfi_seller_common_code/app_imports.dart';
import 'package:nedfi_seller_common_code/pages/login_screen/LoginScreen.dart';

import '../../components/widgets/base_widget.dart';
import '../../components/widgets/common_text_field.dart';
import '../../model/DomainResopnse.dart';
import '../../model/dynamic_theme.dart';

class DomainScreen extends StatefulWidget {
  const DomainScreen({Key? key}) : super(key: key);

  @override
  _DomainScreenState createState() => _DomainScreenState();
}

class _DomainScreenState extends State<DomainScreen> {
  String? domainName;
  TextEditingController domainCodeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (domainLink != null) {
      domainName = domainLink;
      domainCodeController.text = domainLink ?? '';
    } else {
      getDomain(context).then((value) {
        domainName = value;
        domainCodeController.text = value ?? '';
      });
    }
  }

  @override
  void dispose() {
    isLoading.value = false;
    super.dispose();
  }

  /// Getting domain details from the local storage.
  Future<String?> getDomain(BuildContext context) async {
    domainName = (await SharePrefsHelper.getInstance(context)?.getStringValue("domain"));
    return domainName;
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
      //     child: const Icon(Icons.language, size: 20, color: Colors.green),
      //   ),
      // ),
      resizeInsets: true,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Image.asset("assets/images/logo_agrieco.png", alignment: Alignment.center, width: 200),
          SizedBox(height: MediaQuery.of(context).size.height * 0.01),
          Align(
            alignment: Alignment.centerLeft,
            child: WidgetUtils.appTextWidget(context: context, title: 'enterCode'.tr, fontSize: 20, family: 'Graphik', fontWeight: FontWeight.w500),
          ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.01),
          CommonTextField(
            borderWidth: 2.5,
            hintText: 'enterDomainCode'.tr,
            controller: domainCodeController,
            keyboardType: TextInputType.text,
            getController: (controller) {
              domainCodeController.text = controller;
              setState(() {});
            },
          ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.02),
          WidgetUtils.buttonWidget(
              context: context,
              radius: 8,
              family: 'Graphik',
              weight: FontWeight.w500,
              title: "key_continue".tr,
              callback: () {
                getTheme();
                fetchDomain();
              },
              textColor: Color(int.parse(themeColor.value.buttonTextColor!.color!)),
              color: Color(int.parse(themeColor.value.buttonColor!.color!)))
        ]),
      ),
    );
  }

  /// Getting the app theme as per the domain choosen..
  Future getTheme() async {
    try {
      String connectionServerMsg = NetworkHandler.getServerWorkingUrl();
      if (connectionServerMsg != "key_check_internet") {
        if (HeaderSingleton().paramsMaps!.userId != null) {
          headerParams['client_id'] = HeaderSingleton().paramsMaps!.userId!;
        }
        var domain = domainCodeController.text.toString();
        var param = {"appname": HeaderSingleton().appName.value, "X-API-KEY": HeaderSingleton().xAPIKey.value, "domain": domain};
        Uri fetchSchoolsUri = Uri.parse(baseURL + ApiURL.dynamicTheme);
        http.Response response = await http.get(fetchSchoolsUri, headers: param);
        final data = DynamicTheme.fromJson(json.decode(response.body));
        if (data.success == 1 && data.data != null) {
          themeColor.value = data.data!;
        }
      }
    } catch (e) {
      rethrow;
    }
    setStateIfMounted(() {
      isLoading.value = false;
    });
  }

  /// Fetching domain details from the API.
  Future fetchDomain() async {
    await WidgetUtils.getIsFarmer(context).then((value) => HeaderSingleton().setAppUserType(value!.toString()));
    try {
      isLoading.value = true;
      var domain = domainCodeController.text.toString();
      var param = {"appname": HeaderSingleton().appName.value, "X-API-KEY": HeaderSingleton().xAPIKey.value, "domain": domain};
      String connectionServerMsg = NetworkHandler.getServerWorkingUrl();
      if (domainCodeController.text.isNotEmpty) {
        if (connectionServerMsg != "key_check_internet") {
          Uri fetchSchoolsUri = Uri.parse(baseURL + ApiURL.dynamicDomainDBConnection);
          http.Response response = await http.get(fetchSchoolsUri, headers: param);
          var data = json.decode(response.body);
          DomainResopnse npkResponse = DomainResopnse.fromJson(data);
          if (npkResponse.status != 1) {
            WidgetUtils.errorDialog(context, npkResponse.msg);
          } else {
            SharePrefsHelper.getInstance(context)?.saveStringValue("domain", npkResponse.data.domain);
            SharePrefsHelper.getInstance(context)?.saveStringValue("appname", npkResponse.data.appname);
            final headerModel = HeaderSingleton();
            headerModel.setXAPIKEY(npkResponse.data.xAPIKey);
            headerModel.setDomain(npkResponse.data.domain);
            headerModel.setAppName(npkResponse.data.appname);
            baseURL = npkResponse.apiBasePath;
            headerParams = {"appname": npkResponse.data.appname, "X-API-KEY": npkResponse.data.xAPIKey, "domain": npkResponse.data.domain, "lang": lang};
            SharePrefsHelper.getInstance(context)?.saveStringValue("locale", HeaderSingleton().local);
            // headerModel.getParams();
            await getSplash();
          }
        }
      } else {
        WidgetUtils.errorDialog(context, 'Please enter domain name'.tr);
      }
    } catch (e) {
      rethrow;
    }
    setStateIfMounted(() {
      isLoading.value = false;
    });
  }

  void setStateIfMounted(f) {
    if (mounted) setState(f);
  }

  /// Getting Splash Screen details
  Future getSplash() async {
    try {
      final response = await APIService.getAPIMethod(url: ApiURL.splashScreen);
      final data = json.decode(response.body);
      var res = SplashResponse.fromJson(data);
      if (res.success == 1) {
        isLoading.value = false;
        final filePath = await WidgetUtils.splashFromImageUrl(res.image);
        final logoFile = await WidgetUtils.logoFromImageUrl(res.logo);
        // image = res.image;
        image = filePath.path;
        imgPlaceHolder = logoFile.path;

        SharePrefsHelper.getInstance(context)?.saveStringValue("whitelable", imgPlaceHolder);
        SharePrefsHelper.getInstance(context)?.saveStringValue("logo", image);

        // return Tuple2<String, String>(imgPlaceHolder, image);
        if (imgPlaceHolder.isNotEmpty) {
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => const LoginScreen()));
        }
      }
    } catch (e) {
      rethrow;
    }
  }
}
