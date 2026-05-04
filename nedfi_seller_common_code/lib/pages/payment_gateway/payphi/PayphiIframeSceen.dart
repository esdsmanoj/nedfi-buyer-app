import 'package:nedfi_seller_common_code/app_imports.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class PayphiIFrameScreen extends StatefulWidget {
  String? orderId, domain, url;

  PayphiIFrameScreen({super.key, this.orderId, this.domain, this.url});

  @override
  _PayphiIFrameScreenState createState() => _PayphiIFrameScreenState();
}

class _PayphiIFrameScreenState extends State<PayphiIFrameScreen> {
  var isFarmer = 0;
  bool isWebViewLoaded = false;

  @override
  void initState() {
    // TODO: implement initState
    HelperUtils().getIsFarmer(context).then((value) {
      setState(() {
        isFarmer = value!;
      });
    });
    super.initState();
  }

  InAppWebViewGroupOptions options = InAppWebViewGroupOptions(
    android: AndroidInAppWebViewOptions(useHybridComposition: true),
    crossPlatform: InAppWebViewOptions(supportZoom: false, mediaPlaybackRequiresUserGesture: false, preferredContentMode: UserPreferredContentMode.MOBILE),
  );

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: SafeArea(
        child: Scaffold( backgroundColor: Colors.white,
            appBar: AppBar(
              elevation: 0,
              titleSpacing: 20,
              backgroundColor: Color(int.parse(themeColor.value.barColor!.color!)),
              title: WidgetUtils.appTextWidget(context: context, title: 'Payment'.tr, color: Colors.white, fontSize: 18),
              iconTheme: const IconThemeData(color: Colors.white),
            ),
            body: SafeArea(
                child: Stack(
              children: [
                Column(children: <Widget>[
                  Expanded(
                    child: InAppWebView(
                      onLoadStart: (controllerFun, uri) {
                        setState(() {
                          isWebViewLoaded = true;
                        });
                      },
                      onLoadError: (controllerFun, uri, code, value) {
                        setState(() {
                          isWebViewLoaded = false;
                        });
                      },
                      initialUrlRequest: URLRequest(url: WebUri(widget.url!)),
                      initialOptions: options,
                      onConsoleMessage: (controller, consoleMessage) {
                        if (consoleMessage.message == "success") {
                          //updateOrder();
                          var marketPlaceModel = Provider.of<MarketPlaceProvider>(context, listen: false);
                          marketPlaceModel.setClearCart();
                          SQLiteDbProvider.db.deleteAll();
                          WidgetUtils.successDialog(context, "Payment Successful");
                          Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => OrderThankYouScreen(massage: "Payment Successful")), (Route<dynamic> route) => false);
                        } else if (consoleMessage.message == "failed") {
                          // failedOrder();
                          WidgetUtils.errorDialog(context, "Payment Failed");
                          Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (BuildContext context) => const NavigationHomeScreen()), (Route<dynamic> route) => false);
                        }
                      },
                      onLoadStop: (controller, url) async {
                        if (!Platform.isAndroid || await AndroidWebViewFeature.isFeatureSupported(AndroidWebViewFeature.CREATE_WEB_MESSAGE_CHANNEL)) {
                          // wait until the page is loaded, and then create the Web Message Channel
                          var webMessageChannel = await controller.createWebMessageChannel();
                          var port1 = webMessageChannel!.port1;
                          var port2 = webMessageChannel.port2;
                          await port1.setWebMessageCallback((message) async {
                            await port1.postMessage(WebMessage(data: message!.data + " and back"));
                          });
                          await controller.postWebMessage(message: WebMessage(data: "capturePort", ports: [port2]), targetOrigin: WebUri("*"));
                        }
                        setState(() {
                          isWebViewLoaded = true;
                        });
                      },
                    ),
                  ),
                ]),
                isWebViewLoaded ? Container() : const Center(child: CircularProgressIndicator()),
              ],
            ))),
      ),
    );
  }

  updateOrder({bool? isStatus = false}) async {
    try {
      Map<String, dynamic> params1 = {"order_id": widget.orderId, "payment_id": "", "signature": ""};
      http.Response response = await http.post(Uri.parse(baseURL + ApiURL.updateClientOrder), body: params1, headers: headerParams);
      var data = json.decode(response.body);
      var res = CommonModel.fromJson(data);
      if (res.status == 1 && !isStatus!) {
        var marketPlaceModel = Provider.of<MarketPlaceProvider>(context, listen: false);
        marketPlaceModel.setClearCart();
        SQLiteDbProvider.db.deleteAll();
        WidgetUtils.successDialog(context, res.message);
        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => OrderThankYouScreen(massage: res.pickupMsg)), (Route<dynamic> route) => false);
      } else {
        WidgetUtils.errorDialog(context, res.message);
      }
    } catch (e) {
      // print(e.toString());
    }
  }

  failedOrder() async {
    setState(() {});
    try {
      var params = {"status": "Failed", "order_id": widget.orderId};

      http.Response response = await http.post(Uri.parse(baseURL + ApiURL.paymentStatus), headers: headerParams, body: params);
      var data = json.decode(response.body);
      var res = CommonModel.fromJson(data);
      if (res.status == 1) {
        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (BuildContext context) => const NavigationHomeScreen()), (Route<dynamic> route) => false);
      }
      setState(() {});
    } catch (e) {
      setState(() {});
    }
  }
}
