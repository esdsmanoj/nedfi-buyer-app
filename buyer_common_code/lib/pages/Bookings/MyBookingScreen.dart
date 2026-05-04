import 'package:buyer_common_code/app_imports.dart';
import 'package:get/get.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:http/http.dart' as http;

import '../../components/widgets/base_widget.dart';

class MyBookingScreen extends StatefulWidget {
  const MyBookingScreen({Key? key}) : super(key: key);

  @override
  _MyBookingScreenState createState() => _MyBookingScreenState();
}

class _MyBookingScreenState extends State<MyBookingScreen> with TickerProviderStateMixin {
  ValueNotifier<List<AdvisoryData>> productList = ValueNotifier([]);
  String? advisoryId, meetingID;
  bool isBackPress = false, joinFlag = false;
  List<String> tabList = ['All'.tr, 'Upcoming'.tr, 'Reschedule'.tr, 'Past'.tr, 'Cancelled'.tr];
  ValueNotifier<int> selectedIndex = ValueNotifier(0);

  @override
  void initState() {
    super.initState();
    fetchProduct();
    smsGatewayFcmKey();

    /*JitsiMeet.addListener(JitsiMeetingListener(
        onConferenceWillJoin: _onConferenceWillJoin,
        onConferenceJoined: _onConferenceJoined,
        onConferenceTerminated: _onConferenceTerminated,
        onError: _onError));*/
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => true,
      child: BaseWidget(
        appBar: AppBar(
          elevation: 0,
          centerTitle: true,
          backgroundColor: Color(int.parse(themeColor.value.barColor!.color!)),
          title: WidgetUtils.appTextWidget(context: context, title: 'My Booking'.tr, color: Colors.white, fontSize: 18, fontWeight: FontWeight.w500, family: 'Graphik'),
          leading: InkWell(onTap: () => Navigator.pop(context), child: const Icon(Icons.arrow_back, color: Colors.white)),
        ),
        child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
            child: RefreshIndicator(
              onRefresh: fetchProduct,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    productList.value.isNotEmpty
                        ? SizedBox(
                            height: 40,
                            child: ListView.builder(
                                itemCount: tabList.length,
                                scrollDirection: Axis.horizontal,
                                itemBuilder: (ctx, index) {
                                  return GestureDetector(
                                    onTap: () {
                                      selectedIndex.value = index;
                                      setState(() {});
                                    },
                                    child: Container(
                                      height: 30,
                                      alignment: Alignment.center,
                                      margin: const EdgeInsets.only(right: 10),
                                      padding: const EdgeInsets.symmetric(horizontal: 8),
                                      child: WidgetUtils.appTextWidget(
                                          context: context,
                                          title: tabList[index],
                                          color: selectedIndex.value == index ? Colors.white : Colors.black,
                                          family: 'Graphik',
                                          fontSize: 14,
                                          fontWeight: selectedIndex.value == index ? FontWeight.w500 : FontWeight.w400,
                                          textAlign: TextAlign.center),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(8),
                                        color: selectedIndex.value == index ? Color(int.parse(themeColor.value.barColor!.color!)) : Colors.white,
                                      ),
                                    ),
                                  );
                                }),
                          )
                        : Container(),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.01),
                    bookingList(selectedIndex.value == 0
                        ? 'All'
                        : selectedIndex.value == 1
                            ? 'Upcoming'
                            : selectedIndex.value == 2
                                ? 'Reschedule'
                                : selectedIndex.value == 3
                                    ? 'Past'
                                    : selectedIndex.value == 4
                                        ? 'Canceled'
                                        : '')
                  ],
                ),
              ),
            )),
      ),
    );
  }

  Widget bookingList(String page) {
    List<AdvisoryData> products = [];
    for (var element in productList.value) {
      products.add(element);
    }
    return products.isNotEmpty
        ? ListView.builder(
            itemCount: products.length,
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              return scheduledItem(products[index], index);
            })
        : Center(
            child: WidgetUtils.appTextWidget(context: context, title: 'No Data Available'.tr, family: 'Graphik', fontSize: 14, fontWeight: FontWeight.w400),
          );
  }

  Widget scheduledItem(AdvisoryData farmerModel, int index) {
    return GestureDetector(
        onTap: () {},
        child: Card(
            elevation: 5,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
            clipBehavior: Clip.antiAliasWithSaveLayer,
            color: const Color(0xffffffff),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        WidgetUtils.appTextWidget(context: context, title: farmerModel.firstName! + " " + farmerModel.lastName!, fontWeight: FontWeight.w500, family: 'Graphik', fontSize: 16),
                        SizedBox(height: MediaQuery.of(context).size.height * 0.01),
                        WidgetUtils.appTextWidget(context: context, title: 'cropSelected'.tr + ":" + " " + farmerModel.name!, fontWeight: FontWeight.w400, fontSize: 12, family: 'Graphik'),
                      ],
                    ),
                    // CachedNetworkImage(
                    //   imageUrl: 'http://115.124.120.147/marketplace/uploads/profile/' + (farmerModel.profileImage ?? 'xyz'),
                    //   imageBuilder: (context, imageProvider) => Container(height: 40, width: 40, decoration: BoxDecoration(image: DecorationImage(image: imageProvider, fit: BoxFit.cover))),
                    //   placeholder: (context, url) => Image.asset(image, fit: BoxFit.cover, height: 40, width: 40),
                    //   errorWidget: (context, url, error) => Image.asset(image, fit: BoxFit.cover, height: 40, width: 40),
                    // )
                    Padding(
                      padding: const EdgeInsets.only(left: 19.0, top: 14, right: 14),
                      child: Image.asset('assets/images/dummyUser.png', height: 55, width: 55),
                    ),
                  ],
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.01),
                const Divider(thickness: 0.5),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        const Icon(Icons.calendar_month, size: 15),
                        const SizedBox(width: 10),
                        WidgetUtils.appTextWidget(context: context, title: farmerModel.callScheduleDate!, family: 'Graphik', fontWeight: FontWeight.w400, fontSize: 12),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        const Icon(Icons.access_time_rounded, size: 15),
                        const SizedBox(width: 10),
                        WidgetUtils.appTextWidget(context: context, title: farmerModel.callScheduleTime!, family: 'Graphik', fontWeight: FontWeight.w400, fontSize: 12),
                      ],
                    ),
                    WidgetUtils.appTextWidget(
                        context: context,
                        title: farmerModel.callStatus!.tr,
                        fontWeight: FontWeight.w500,
                        family: 'Graphik',
                        fontSize: 16,
                        color: farmerModel.callStatus == 'Cancelled'
                            ? Colors.red
                            : farmerModel.callStatus == 'UpComing'
                                ? Colors.green
                                : farmerModel.callStatus == 'Past'
                                    ? Colors.black
                                    : farmerModel.callStatus == 'Reschedule'
                                        ? Colors.orange
                                        : Colors.orange),
                  ],
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.01),
                farmerModel.callDuration != null ? const Divider(thickness: 0.5) : Container(),
                Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                  farmerModel.callDuration != null
                      ? WidgetUtils.appTextWidget(context: context, title: 'Call Duration: ${farmerModel.callDuration!}', fontWeight: FontWeight.w400, fontSize: 12)
                      : Container(),
                ])
              ]),
            )));
  }

  Future fetchProduct() async {
    try {
      isLoading.value = true;
      Map<String, dynamic> params1 = {"farmer_id": HeaderSingleton().paramsMaps!.userId!, "crop_id": "", "status": ""};
      final response = await APIService.postAPIMethod(url: ApiURL.getFarmerBookedSlot, params: params1);
      final data = json.decode(response.body);
      final result = AdvisoryModel.fromJson(data);
      if (result.status != 1) {
        WidgetUtils.errorDialog(context, data["msg"]);
      } else {
        setState(() {
          if (result.data!.isNotEmpty) {
            productList.value = result.data!;
          } else {
            productList.value = [];
          }
        });
        isLoading.value = false;
        setState(() {});
      }
    } catch (e) {
      isLoading.value = false;
      setState(() {});
    }
  }

  Future<void> _startCall(String farmerId) async {
    try {
      String connectionServerMsg = NetworkHandler.getServerWorkingUrl();
      if (connectionServerMsg != "key_check_internet") {
        Uri getUserDetailsUri = Uri.parse(baseURL + ApiURL.startMeetingCall);
        var request = http.MultipartRequest('POST', getUserDetailsUri);
        request.fields['farmer_id'] = farmerId;
        request.fields['user_id'] = HeaderSingleton().paramsMaps!.userId!;
        request.fields['lead_id'] = advisoryId ?? "";
        request.headers["client-type"] = "buyer";
        request.headers["X-API-KEY"] = HeaderSingleton().xAPIKey.value;
        request.headers["domain"] = HeaderSingleton().domain.value;
        request.headers["appname"] = HeaderSingleton().appName.value;
        http.StreamedResponse streamedResponse = await request.send();
        http.Response response = await http.Response.fromStream(streamedResponse);

        var data = json.decode(response.body);
        if (data["success"] != 1) {
          WidgetUtils.errorDialog(context, data["msg"]);
        } else {
          setState(() {
            VideoCall video = VideoCall.fromJson(
              data["data"],
            );
            // _joinMeeting(video, farmerid);
          });
        }
      } else {
        WidgetUtils.informationDialog(context, AppTranslations.of(context)?.text("key_connection_lost") ?? 'key_connection_lost'.tr);
      }
    } on SocketException {
      WidgetUtils.informationDialog(context, AppTranslations.of(context)?.text("key_connection_lost") ?? 'key_connection_lost'.tr);
    } catch (e) {
      // //print(e);
      // WidgetUtils.errorDialog(context, e.toString(),backgroundColor: primaryExtraLight1);
    }
    // setState(() {
    isLoading.value = false;
    // });
  }

  /* _joinMeeting(VideoCall videoCall, String? farmerid) async {
    // String serverUrl = serverText.text.trim().isEmpty ? null : serverText.text;
    String serverUrl = "https://famrutmeet.enlightcloud.com/";
    // String serverUrl = "https://famrutmeet.enlightcloud.com/h";
    // Enable or disable any feature flag here
    // If feature flag are not provided, default values will be used
    // Full list of feature flags (and defaults) available in the README
    Map<FeatureFlagEnum, bool> featureFlags = {
      FeatureFlagEnum.WELCOME_PAGE_ENABLED: false,
      FeatureFlagEnum.ADD_PEOPLE_ENABLED: false,
      FeatureFlagEnum.CALENDAR_ENABLED: false,
      FeatureFlagEnum.CALL_INTEGRATION_ENABLED: false,
      FeatureFlagEnum.CLOSE_CAPTIONS_ENABLED: false,
      FeatureFlagEnum.CHAT_ENABLED: false,
      FeatureFlagEnum.INVITE_ENABLED: false,
      FeatureFlagEnum.IOS_RECORDING_ENABLED: false,
      FeatureFlagEnum.LIVE_STREAMING_ENABLED: false,
      FeatureFlagEnum.MEETING_NAME_ENABLED: false,
      FeatureFlagEnum.MEETING_PASSWORD_ENABLED: false,
      FeatureFlagEnum.PIP_ENABLED: false,
      FeatureFlagEnum.RAISE_HAND_ENABLED: false,
      FeatureFlagEnum.RECORDING_ENABLED: false,
      FeatureFlagEnum.TILE_VIEW_ENABLED: false,
      FeatureFlagEnum.TOOLBOX_ALWAYS_VISIBLE: true,
      FeatureFlagEnum.WELCOME_PAGE_ENABLED: false,
    };
    if (Platform.isAndroid) {
      // Disable ConnectionService usage on Android to avoid issues (see README)
      featureFlags[FeatureFlagEnum.CALL_INTEGRATION_ENABLED] = false;
    } else if (Platform.isIOS) {
      // Disable PIP on iOS as it looks weird
      featureFlags[FeatureFlagEnum.PIP_ENABLED] = false;
    }
    // Define meetings options here
    //  var options = JitsiMeetingOptions(room: videoCall.meeting_link)
    var options = JitsiMeetingOptions(room: videoCall.meeting_link!)
      ..serverURL = serverUrl
      ..subject = videoCall.title
      ..userDisplayName = paramsMaps.firstName
      ..userEmail = paramsMaps.email
      ..iosAppBarRGBAColor = iosAppBarRGBAColor.text
      ..audioOnly = false
      ..audioMuted = false
      ..videoMuted = false
      ..featureFlags.addAll(featureFlags)
      ..webOptions = {
        "roomName": videoCall.meeting_link!,
        "width": "100%",
        "height": "100%",
        "enableWelcomePage": false,
        "chromeExtensionBanner": null,
        "userInfo": {"displayName": paramsMaps.firstName}
      };
    setState(() {
      _isBackPress=true;
      meetingID= videoCall.meeting_link!;
      smsGatewayFcmKey();
    });
    startTimer(videoCall);
    debug// //print("JitsiMeetingOptions: $options");
    await JitsiMeet.joinMeeting(
      options,
      listener: JitsiMeetingListener(
          onConferenceWillJoin: (message) {
            debug// //print("${options.room} will join with message: $message");
          },
          onConferenceJoined: (message) {
            debug// //print("${options.room} joined with message: $message");
            setState(() {
             // joinflag=true;
            });
          },
          onConferenceTerminated: (message) {
            debug// //print("${options.room} terminated with message: $message");
            _disconnectCall(videoCall.farmer_id, videoCall.meeting_link);
          },
          genericListeners: [
            JitsiGenericListener(
                eventName: 'readyToClose',
                callback: (dynamic message) {
                  debug// //print("readyToClose callback");
                }),
          ]),
    );

  }*/
  smsGatewayFcmKey() async {
    final FirebaseApp app = await Firebase.initializeApp();
    final DatabaseReference db = FirebaseDatabase.instanceFor(app: app).ref("jitsiCallLog");
    /*db.once().then((value) { // //print(value);
    // //print("ongingCall121uuy  "+value.snapshot.value.toString());});
    db.child(meetingID!).child('ongoingCall').once().then((value) {
      // //print(value);
      // //print("ongingCall121  "+value.snapshot.value.toString());
      setState(() {
        joinflag = true;
      });
    });*/
    var dbb = FirebaseDatabase.instance.ref("jitsiCallLog").child(meetingID!);
    /*dbb.once().then((snapshot){
      // //print("ongingCall1  ");
      if(snapshot.snapshot.value!=null) {
        Map<dynamic, dynamic> values = snapshot.snapshot.value as Map<dynamic, dynamic>;
        // //print("ongingCall121  ");
        // //print(values["ongoingCall"].toString());
        if (values["ongoingCall"].toString() == "1") {
          setState(() {
            joinflag = true;
          });
        }
      }
    });*/

    dbb.onValue.listen(
      (DatabaseEvent event) {
        setState(() {
          // //print("ongingCall121  event");
          // //print(event);
          Map<dynamic, dynamic> values = event.snapshot.value as Map<dynamic, dynamic>;
          // //print(values);
          // //print(values["ongoingCall"].toString());
          if (values["ongoingCall"].toString() == "1") {
            setState(() {
              joinFlag = true;
            });
          } else if (values["ongoingCall"].toString() == "2") {
            _disconnectCall(HeaderSingleton().paramsMaps!.userId, meetingID);
          }
        });
      },
      onError: (Object o) {
        final error = o as FirebaseException;
        setState(() {});
      },
    );
  }

  Future<void> _disconnectCall(String? farmerId, String? meetLink) async {
    // setState(() {
    isLoading.value = true;
    try {
      String connectionServerMsg = NetworkHandler.getServerWorkingUrl();
      if (connectionServerMsg != "key_check_internet") {
        Uri getUserDetailsUri = Uri.parse(baseURL + ApiURL.disconnectFarmer);
        var request = http.MultipartRequest('POST', getUserDetailsUri);
        request.headers["client-type"] = "buyer";
        request.headers["X-API-KEY"] = HeaderSingleton().xAPIKey.value;
        request.headers["domain"] = HeaderSingleton().domain.value;
        request.headers["appname"] = HeaderSingleton().appName.value;
        request.fields['farmer_id'] = farmerId!;
        request.fields['user_id'] = HeaderSingleton().paramsMaps!.userId!;
        request.fields['meeting_link'] = meetLink!;
        request.fields['call_status_flag'] = "5";
        request.fields['meeting_duration'] = "0";
        request.fields['lead_id'] = advisoryId ?? "";
        http.StreamedResponse streamedResponse = await request.send();
        http.Response response = await http.Response.fromStream(streamedResponse);
        var data = json.decode(response.body);
        if (data["success"] != 1) {
          WidgetUtils.errorDialog(context, data["msg"]);
        } else {
          WidgetUtils.successDialog(context, data["msg"]);
        }
        //fetchProduct();
        setState(() {
          isBackPress = false;
          joinFlag = false;
        });

        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const MyBookingScreen()));
      } else {
        WidgetUtils.informationDialog(context, AppTranslations.of(context)?.text("key_connection_lost") ?? 'key_connection_lost'.tr);
      }
    } on SocketException {
      WidgetUtils.informationDialog(context, AppTranslations.of(context)?.text("key_connection_lost") ?? 'key_connection_lost'.tr);
    } catch (e) {
      // //print(e);
    }
    isLoading.value = false;
  }
}
