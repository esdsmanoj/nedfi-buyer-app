import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class NetCaretIFrame extends StatefulWidget {
  String netCarretURL;

  NetCaretIFrame(this.netCarretURL, {super.key});

  @override
  _NetCaretIFrameState createState() => _NetCaretIFrameState();
}

class _NetCaretIFrameState extends State<NetCaretIFrame> {
  late InAppWebViewController _webViewController;
  double progress = 0;

  _exitApp(BuildContext context) async {
    if (await _webViewController.canGoBack()) {
      // print("onwill goback");
      _webViewController.goBack();
    } else {
      Navigator.pop(context);
      return Future.value(false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold( backgroundColor: Colors.white,
          appBar: AppBar(elevation:0,
            iconTheme: const IconThemeData(color: Colors.white),
            title: const Text('Rewards', style: TextStyle(color: Colors.white)),
            backgroundColor: const Color(0xff27914F),
          ),
          body: Column(
            children: <Widget>[
              Expanded(
                child: Stack(
                  children: [
                    Container(
                      child: InAppWebView(
                        initialUrlRequest: URLRequest(url: WebUri(widget.netCarretURL)),
                        initialOptions: InAppWebViewGroupOptions(
                          crossPlatform: InAppWebViewOptions(
                            mediaPlaybackRequiresUserGesture: false,
                          ),
                        ),
                        onWebViewCreated: (InAppWebViewController controller) {
                          _webViewController = controller;
                        },
                        androidOnPermissionRequest: (InAppWebViewController controller, String origin, List<String> resources) async {
                          return PermissionRequestResponse(resources: resources, action: PermissionRequestResponseAction.GRANT);
                        },
                        onProgressChanged: (InAppWebViewController controller, int progress) {
                          setState(() {
                            this.progress = progress / 100;
                          });
                        },
                      ),
                    ),
                    Align(alignment: Alignment.center, child: _buildProgressBar()),
                  ],
                ),
              )
            ],
          )),
    );
  }

  Widget _buildProgressBar() {
    if (progress != 1.0) {
      return CircularProgressIndicator();
// You can use LinearProgressIndicator also
//      return LinearProgressIndicator(
//        value: progress,
//        valueColor: new AlwaysStoppedAnimation<Color>(Colors.orange),
//        backgroundColor: Colors.blue,
//      );
    }
    return Container();
  }
}
