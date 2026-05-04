import 'package:buyer_common_code/singleton/header_singleton.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../components/utils/widget_utils.dart';

class VideoMeetingIFrame extends StatefulWidget {
  Map<String, String>? params;
  String? farmerId, userId, meetingID, name;

  VideoMeetingIFrame({Key? key, this.params, this.farmerId, this.userId, this.meetingID, this.name}) : super(key: key);

  @override
  _VideoMeetingIFrameState createState() => _VideoMeetingIFrameState();
}

class _VideoMeetingIFrameState extends State<VideoMeetingIFrame> {
  late InAppWebViewController webViewController;
  double progress = 0;

  Future webViewMethod() async {
    // //print('In Microphone permission method');
    //WidgetsFlutterBinding.ensureInitialized();

    await Permission.microphone.request();
    webViewMethodForCamera();
  }

  Future webViewMethodForCamera() async {
    // //print('In Camera permission method');
    //WidgetsFlutterBinding.ensureInitialized();
    await Permission.camera.request();
  }

  @override
  void initState() {
    super.initState();
    webViewMethod();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 0,
          centerTitle: true,
          backgroundColor: const Color(0xff27914F),
          title: WidgetUtils.appTextWidget(context: context, title: 'Calling..', color: Colors.white, fontSize: 18),
          leading: InkWell(onTap: () => Navigator.pop(context), child: const Icon(Icons.arrow_back, color: Colors.white)),
        ),
        body: Column(
          children: <Widget>[
            Expanded(
              child: Stack(
                children: [
                  SizedBox(
                    child: InAppWebView(
                      initialUrlRequest: URLRequest(
                          url: Uri.parse("https://dev.famrut.com/agroemandi_portal/front-end/home/test_meet?partner_id=" +
                              widget.userId! +
                              "&farmer_id=" +
                              widget.farmerId! +
                              "&MeetingId=" +
                              widget.meetingID! +
                              "&call_status_flag=4&txtDispNme=" +
                              widget.name! +
                              "&domain=${HeaderSingleton().domain.value}&appname=${HeaderSingleton().appName.value}")),
                      initialOptions: InAppWebViewGroupOptions(
                        crossPlatform: InAppWebViewOptions(
                          mediaPlaybackRequiresUserGesture: false,
                        ),
                      ),
                      onWebViewCreated: (InAppWebViewController controller) {
                        webViewController = controller;
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
        ));
  }

  Widget _buildProgressBar() {
    if (progress != 1.0) {
      return const CircularProgressIndicator();
    }
    return Container();
  }
}
