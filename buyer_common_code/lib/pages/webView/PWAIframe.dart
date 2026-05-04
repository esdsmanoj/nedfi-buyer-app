import 'package:buyer_common_code/app_imports.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class PWAIFrame extends StatefulWidget {
  String? routeName;

  PWAIFrame({super.key, this.routeName = "Home"});

  @override
  _PWAIFrameState createState() => _PWAIFrameState();
}

class _PWAIFrameState extends State<PWAIFrame> {
  var isFarmer = 0;
  bool isWebViewLoaded = false;
  String message = "", profileMessage = "";
  Uri? webUrl;
  late InAppWebViewController webView;

  @override
  void initState() {
    //print("http://115.124.120.147:3004/otpverification/${HeaderSingleton().paramsMaps!.userId!}/${widget.routeName}");
    super.initState();
  }

  InAppWebViewGroupOptions options = InAppWebViewGroupOptions(
    android: AndroidInAppWebViewOptions(useHybridComposition: true),
    crossPlatform: InAppWebViewOptions(supportZoom: false, mediaPlaybackRequiresUserGesture: false, preferredContentMode: UserPreferredContentMode.MOBILE),
  );

  Future<bool> onBackPressed() async {
    final value = await webView.canGoBack();
    if (value) {
      webView.goBack();
      webUrl = await webView.getUrl();
      if (message == 'back' && webUrl == Uri.parse("http://115.124.120.147:3004/Home")) {
        Navigator.pop(context);
      }
      return false;
    } else {
      return true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => onBackPressed(),
      child: SafeArea(
        child: Scaffold( backgroundColor: Colors.white,
            body: Stack(
          children: [
            InAppWebView(
              onWebViewCreated: (InAppWebViewController controller) async {
                webView = controller;
                setState(() {});
              },
              onLoadStart: (controllerFun, uri) => setState(() => isWebViewLoaded = true),
              onLoadError: (controllerFun, uri, code, value) => setState(() => isWebViewLoaded = false),
              initialUrlRequest: URLRequest(url: Uri.parse("http://115.124.120.147:3004/otpverification/${HeaderSingleton().paramsMaps!.userId!}/${widget.routeName}")),
              initialOptions: options,
              onConsoleMessage: (controller, consoleMessage) {
                //print(consoleMessage);
                if (consoleMessage != null) {
                  if (consoleMessage.message.toLowerCase() == "back") {
                    message = consoleMessage.message;
                  }
                  if (consoleMessage.message == "ProfileScreen") {
                    profileMessage = consoleMessage.message;
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (ctx) => const ProfileScreen()));
                  }
                }
              },
              onLoadStop: (controller, url) async => setState(() => isWebViewLoaded = true),
            ),
            isWebViewLoaded ? Container() : const Center(child: CircularProgressIndicator()),
          ],
        )),
      ),
    );
  }
}
