import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class NPKSDetailsScreen extends StatefulWidget {
  final String url;

  const NPKSDetailsScreen({super.key, required this.url});

  @override
  _NPKSDetailsScreenState createState() => _NPKSDetailsScreenState();
}

class _NPKSDetailsScreenState extends State<NPKSDetailsScreen> {
  bool isWebViewLoaded = false;

  InAppWebViewGroupOptions options = InAppWebViewGroupOptions(
    android: AndroidInAppWebViewOptions(useHybridComposition: true),
    crossPlatform: InAppWebViewOptions(supportZoom: false, mediaPlaybackRequiresUserGesture: false, preferredContentMode: UserPreferredContentMode.MOBILE),
  );

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold( backgroundColor: Colors.white,
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
                initialUrlRequest: URLRequest(url: Uri.parse(widget.url)),
                initialOptions: options,
                onConsoleMessage: (controller, consoleMessage) {},
                onWebViewCreated: (controller) async {
                  if (!Platform.isAndroid || await AndroidWebViewFeature.isFeatureSupported(AndroidWebViewFeature.CREATE_WEB_MESSAGE_CHANNEL)) {
                    // wait until the page is loaded, and then create the Web Message Channel
                    var webMessageChannel = await controller.createWebMessageChannel();
                    var port1 = webMessageChannel!.port1;
                    var port2 = webMessageChannel.port2;
                    await port1.setWebMessageCallback((message) async {
                      await port1.postMessage(WebMessage(data: message! + " and back"));
                    });
                    await controller.postWebMessage(message: WebMessage(data: "capturePort", ports: [port2]), targetOrigin: Uri.parse("*"));
                  }
                },
                onLoadStop: (controller, url) async {
                  setState(() {
                    isWebViewLoaded = true;
                  });
                },
              ),
            )
          ]),
          isWebViewLoaded ? Container() : const Center(child: CircularProgressIndicator()),
          Positioned(
            left: 10.0,
            top: 15.0,
            child: InkWell(
                child: const CircleAvatar(
                    backgroundColor: Colors.white,
                    child: Icon(
                      Icons.arrow_back,
                      color: Colors.black,
                    )),
                onTap: () => Navigator.pop(context)),
          ),
        ],
      ))),
    );
  }
}
