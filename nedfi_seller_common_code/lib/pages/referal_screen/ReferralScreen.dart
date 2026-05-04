import 'package:nedfi_seller_common_code/app_imports.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../../components/widgets/clipper.dart';
import '../../model/ReferralResponse.dart';

class ReferralScreen extends StatefulWidget {
  String mobileNo, appUserType;

  ReferralScreen(this.mobileNo, this.appUserType, {Key? key}) : super(key: key);

  @override
  _ReferralScreenState createState() => _ReferralScreenState();
}

class _ReferralScreenState extends State<ReferralScreen> {
  ValueNotifier<bool> isLoading = ValueNotifier(false);
  String loadingText = "";
  final GlobalKey<ScaffoldState> phoneVerifyPageGlobalKey = GlobalKey<ScaffoldState>();

  TextEditingController otpController = TextEditingController();
  FocusNode _otpFocusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    var scrWidth = MediaQuery.of(context).size.width;
    var scrHeight = MediaQuery.of(context).size.height;
    return CustomProgressHandler(
      isLoading: isLoading.value,
      loadingText: loadingText,
      child: Scaffold(
          key: phoneVerifyPageGlobalKey,
          backgroundColor: Colors.white,
          body: Stack(
            children: [
              Positioned.fill(
                child: Align(
                  alignment: Alignment.center,
                  child: Container(
                    padding: const EdgeInsets.only(left: 20, right: 20),
                    alignment: Alignment.center,
                    width: scrWidth,
                    height: scrHeight,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.max,
                      children: <Widget>[
                        Container(
                          alignment: Alignment.centerLeft,
                          margin: const EdgeInsets.only(left: 16, top: 32),
                          child: Text(
                            'Referral Code'.tr,
                            style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500,
                                ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        Container(
                          alignment: Alignment.centerLeft,
                          margin: const EdgeInsets.only(left: 16, top: 12),
                          child: RichText(
                            text: TextSpan(children: <TextSpan>[
                              TextSpan(
                                text: 'Enter Referral Code'.tr,
                                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500,
                                    ),
                              ),
                            ]),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: Border.all(
                                    color: Theme.of(context).primaryColor,
                                    width: 1.0,
                                  ),
                                  borderRadius: BorderRadius.circular(14),
                                ),
                                child: TextField(
                                  textAlign: TextAlign.center,
                                  keyboardType: TextInputType.text,
                                  maxLength: 20,
                                  textCapitalization: TextCapitalization.characters,
                                  decoration: InputDecoration(
                                    isCollapsed: false,
                                    counter: Container(),
                                    border: InputBorder.none,
                                    hintStyle: Theme.of(context).textTheme.bodyMedium!.copyWith(
                                          color: Colors.grey,
                                          fontSize: 18,
                                        ),
                                    labelStyle: Theme.of(context).textTheme.bodyMedium!.copyWith(
                                          fontSize: 18,
                                        ),
                                  ),
                                  controller: otpController,
                                  focusNode: _otpFocusNode,
                                ),
                              ),
                              const SizedBox(height: 20),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                mainAxisSize: MainAxisSize.max,
                                children: <Widget>[
                                  Expanded(
                                    child: CustomDarkButton(
                                      caption: 'Submit'.tr,
                                      onPressed: () {
                                        var domain = otpController.text.toString();
                                        if (domain.isEmpty) {
                                          WidgetUtils.errorDialog(context, 'Enter Referral code'.tr);
                                        } else {
                                          _checkReferral();
                                        }
                                      },
                                    ),
                                  ),
                                  Expanded(
                                    child: InkWell(
                                      onTap: () {
                                        _referral();
                                      },
                                      child: Text(
                                        'Generate Referral Code'.tr,
                                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                                              fontSize: 18,
                                              fontWeight: FontWeight.w500,
                                            ),
                                      ),
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              ClipPath(
                clipper: OuterClippedPart(),
                child: Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    gradient: LinearGradient(colors: [
                      Theme.of(context).primaryColor,
                      Theme.of(context).primaryColor,
                    ], begin: Alignment.topLeft, end: Alignment.bottomRight),
                  ),
                  width: scrWidth,
                  height: scrHeight,
                ),
              ),
              ClipPath(
                clipper: InnerClippedPart(),
                child: Container(
                  color: const Color(0xff4b830d),
                  // color: Color(0xff0c2551),
                  width: scrWidth,
                  height: scrHeight,
                ),
              ),
              Positioned.fill(
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    // height: 100,
                    child: Image.asset(
                      "assets/images/bottom_bg.png",
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ],
          )),
    );
  }

  _checkReferral() async {
    if (otpController.text.toString().isEmpty) {
      WidgetUtils.errorDialog(context, 'Enter Referral Code'.tr);
    } else {
      isLoading.value = true;

      try {
        //var headerModel =
        // Provider.of<HeaderModel>(context, listen: false);
        //   Map<String, dynamic> params1 = {"mobile": mobileNo};
        http.Response response = await http.get(Uri.parse(baseURL + ApiURL.checkReferralCode + "/" + otpController.text.toString()), headers: headerParams);
        var data = json.decode(response.body);
        var referralResponse = ReferralResponse.fromJson(data);
        if (referralResponse.success == 1) {
          Navigator.push(context, MaterialPageRoute(builder: (context) => RegistrationScreen(widget.mobileNo, otpController.text.toString(), widget.appUserType, true)));
        } else {
          WidgetUtils.errorDialog(context, referralResponse.msg!);
        }
        isLoading.value = false;
      } on SocketException {
        /* WidgetUtils.errorDialog(context,

           'key_connection_lost'.tr, 1);*/
      } catch (e) {
        // print("login");
        // print(e);
        isLoading.value = false;

        /* WidgetUtils.errorDialog(context,
           'key_connection_lost'.tr, 1);*/
      }
    }
  }

  Future _referral() async {
    var mobileNo = widget.mobileNo;
    if (mobileNo.contains("+91")) {
      mobileNo = mobileNo.substring(3);
    }

    isLoading.value = true;

    try {
      //var headerModel =
      // Provider.of<HeaderModel>(context, listen: false);
      Map<String, dynamic> params1 = {"mobile": mobileNo};
      http.Response response = await http.post(Uri.parse(baseURL + ApiURL.generateReferralCode), headers: headerParams, body: params1);
      var data = json.decode(response.body);
      var referralResponse = ReferralResponse.fromJson(data);
      if (referralResponse.success == 1) {
        setState(() {
          otpController.text = referralResponse.data!.referralCode!;
        });
      } else {
        WidgetUtils.errorDialog(context, referralResponse.msg!);
      }
      isLoading.value = false;
    } catch (e) {
      // print("login");
      // print(e);
      isLoading.value = false;
      /* WidgetUtils.errorDialog(context,
              'key_connection_lost'.tr, 1);*/
    }
  }
}
