import 'package:get/get.dart';

import '../../app_imports.dart';
import '../walkthrough_screen/walkthrough.dart';

class TermsCondition extends StatefulWidget {
  final String route;

  const TermsCondition({super.key, required this.route});

  @override
  State<TermsCondition> createState() => _TermsConditionState();
}

class _TermsConditionState extends State<TermsCondition> {
  var unescape = HtmlUnescape();
  dynamic data;
  bool isTermsRead = false;

  @override
  void initState() {
    isLoading.value = true;
    getTermsCondition();
    isLoading.value = false;
    super.initState();
  }

  Future getTermsCondition() async {
    isTermsRead = await SharePrefsHelper.getInstance(context)?.getBoolValue("terms") ?? false;
    try {
      final response = await APIService.getAPIMethod(url: ApiURL.getTermsCondition);
      final result = json.decode(response.body);
      if (result["success"] == 1) {
        data = result;
        setState(() {});
      }
    } catch (e) {
      isLoading.value = false;
      rethrow;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: CustomProgressHandler(
        isLoading: isLoading.value,
        loadingText: "",
        child: Scaffold(
            backgroundColor: Colors.white,
            appBar: widget.route == ""
                ? AppBar(
                    backgroundColor: Colors.white,
                    elevation: 0,
                    iconTheme: IconThemeData(color: Color(int.parse(themeColor.value.barColor!.color!))),
                  )
                : null,
            body: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: SingleChildScrollView(
                child: data != null
                    ? Column(
                        children: [
                          const SizedBox(height: 18),
                          CachedNetworkImage(
                            placeholder: (context, url) =>Image.asset(HeaderSingleton().splashImage, fit: BoxFit.contain, width: 275, height: 180),
                            errorWidget: (context, url, error) => Image.asset(HeaderSingleton().splashImage, fit: BoxFit.contain, width: 275, height: 180),
                            imageUrl: (data['logo_path'] ?? "") + data['data']['logo'],
                            imageBuilder: (context, imageProvider) => Container(
                              height: 280,
                              width: 275,
                              decoration: BoxDecoration(image: DecorationImage(image: imageProvider, fit: BoxFit.cover)),
                            ),
                          ),
                          const SizedBox(height: 32),
                          WidgetUtils.appTextWidget(
                              context: context, title: 'Terms and Conditions'.tr, textAlign: TextAlign.center, fontSize: 18, color: Colors.black, family: 'Graphik', fontWeight: FontWeight.w500),
                          const SizedBox(height: 12),
                          data['data']['description'] != null
                              ? Html(
                                  data: unescape.convert(data['data']['description']),
                                  style: {
                                    'h1': Style(fontFamily: 'Graphik', color: const Color(0xFF707070), fontWeight: FontWeight.w400, fontSize: FontSize(16), letterSpacing: 0.2),
                                    'h2': Style(fontFamily: 'Graphik', color: const Color(0xFF707070), fontWeight: FontWeight.w400, fontSize: FontSize(16), letterSpacing: 0.2),
                                    'h3': Style(fontFamily: 'Graphik', color: const Color(0xFF707070), fontWeight: FontWeight.w400, fontSize:  FontSize(16), letterSpacing: 0.2),
                                    "body": Style(fontFamily: 'Graphik', color: const Color(0xFF707070), fontWeight: FontWeight.w400, fontSize:  FontSize(16), letterSpacing: 0.2),
                                    "table": Style(backgroundColor: const Color(0xFF707070), fontFamily: 'Graphik'),
                                  },
                                )
                              : Container()
                        ],
                      )
                    : Container(),
              ),
            ),
            bottomNavigationBar: widget.route != ""
                ? Container(
                    height: 120,
                    color: Colors.white,
                    child: Align(
                        alignment: Alignment.bottomCenter,
                        child: data != null
                            ? Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
                                child: Align(
                                  alignment: Alignment.bottomCenter,
                                  child: Container(
                                    height: 120,
                                    color: Colors.white,
                                    child: Column(
                                      children: [
                                        Row(
                                          children: [
                                            SizedBox(
                                              height: 17,
                                              width: 17,
                                              child: Checkbox(
                                                checkColor: Colors.white,
                                                value: isTermsRead,
                                                activeColor: Color(int.parse(themeColor.value.barColor!.color!)),
                                                onChanged: (bool? value) async {
                                                  isTermsRead = !isTermsRead;
                                                  await SharePrefsHelper.getInstance(context)?.saveBoolValue("terms", isTermsRead);
                                                  setState(() {});
                                                },
                                              ),
                                            ),
                                            const SizedBox(width: 8),
                                            WidgetUtils.appTextWidget(
                                                context: context,
                                                title: 'I agree with the terms and conditions'.tr,
                                                fontSize: 16,
                                                fontWeight: FontWeight.w500,
                                                family: 'Graphik',
                                                textAlign: TextAlign.start),
                                          ],
                                        ),
                                        const SizedBox(height: 18),
                                        WidgetUtils.buttonWidget(
                                            context: context,
                                            radius: 8,
                                            title: "key_continue".tr,
                                            size: 18,
                                            family: 'Graphik',
                                            weight: FontWeight.w500,
                                            callback: () {
                                              if (isTermsRead) {
                                                SharePrefsHelper.getInstance(context)?.saveStringValue('walkthrough', "true");
                                                walkthroughEnabled = 'true';
                                                if (widget.route == "") {
                                                  Navigator.pop(context);
                                                } else {
                                                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (ctx) => OnBoardingPage(route: widget.route)));
                                                }
                                              } else {
                                                WidgetUtils.errorDialog(context, 'Please accept terms and condition for using app'.tr);
                                                setState(() {});
                                              }
                                            },
                                            textColor: Color(int.parse(themeColor.value.buttonTextColor!.color!)),
                                            color: Color(int.parse(themeColor.value.buttonColor!.color!)))
                                      ],
                                    ),
                                  ),
                                ),
                              )
                            : Container(height: 20)),
                  )
                : Container(height:10)),
      ),
    );
  }
}
