import 'package:get/get.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:http/http.dart' as http;
import 'package:nedfi_seller_common_code/app_imports.dart';

import '../../model/Farmer.dart';

class EnquiryScreen extends StatefulWidget {
  const EnquiryScreen({Key? key}) : super(key: key);

  @override
  _EnquiryScreenState createState() => _EnquiryScreenState();
}

class _EnquiryScreenState extends State<EnquiryScreen> {
  bool? isLoading = false, _serviceEnabled;
  String loadingText = 'Loading..';
  bool? _isLoading, _large, _medium;
  double? _pixelRatio, bottom1;
  Size? size;
  String? _loadingText;
  final angle = 180 * pi / 180;
  late final double? elevation = 3.0;
  final GlobalKey<ScaffoldState> _scaffoldProfileKey = new GlobalKey<ScaffoldState>();
  late UserData paramsMaps;
  List<FarmerData> farmer = [];
  final iosAppBarRGBAColor = TextEditingController(text: "#0080FF80");

  @override
  void initState() {
    super.initState();
    _isLoading = false;
    _loadingText = 'Loading . . .';

    paramsMaps = UserData();
    getUserModel(context).then((value) {
      paramsMaps = value;
    });

    fetchFarmer().then((result) {
      setState(() {
        farmer = result;
      });
    });
  }

  Future<UserData> getUserModel(BuildContext context) async {
    paramsMaps = (await SharePrefsHelper.getInstance(context)?.getUserModel())!;
    return paramsMaps;
  }

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    var scrWidth = MediaQuery.of(context).size.width;
    _pixelRatio = MediaQuery.of(context).devicePixelRatio;
    _large = ResponsiveWidget.isScreenLarge(scrWidth, _pixelRatio!);
    _medium = ResponsiveWidget.isScreenMedium(scrWidth, _pixelRatio!);
    return Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text('key_enquiry'.tr),
          leading: Transform.rotate(
            angle: 0, //angle,
            child: IconButton(
              icon: const Icon(Icons.arrow_back_rounded),
              onPressed: () {
                // ZoomDrawer.of(context)!.toggle.call();
                Navigator.pop(context);
              },
            ),
          ),
        ),
        body: CustomProgressHandler(
          isLoading: this._isLoading!,
          loadingText: this._loadingText!,
          child: SafeArea(
              child: Scaffold(
            backgroundColor: Colors.white,
            //  backgroundColor: ColorsConst.backgroundColor,
            key: _scaffoldProfileKey,
            body: ListView(
              children: [
                ListView.builder(
                    itemCount: farmer.length,
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      return _farmerItem(farmer[index], index);
                    }),
              ],
            ),
          )),
        ));
  }

  _farmerItem(FarmerData? farmerModel, int index) {
    return Padding(
        padding: const EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 5.0),
        child: GestureDetector(
            onTap: () {},
            child: Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                clipBehavior: Clip.antiAliasWithSaveLayer,
                color: const Color(0xfff5f5f5),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Stack(
                          children: [
                            const Padding(
                              padding: EdgeInsets.all(20.0),
                              child: Icon(Icons.face_rounded, size: 30, color: Colors.orange),
                            ),
                          ],
                        ),
                        Expanded(
                          flex: 1,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                (farmerModel?.firstName ?? hidePhoneNumber(farmerModel!.phone!)) + " " + farmerModel!.lastName!,
                                style: const TextStyle(color: Colors.black, fontSize: 15.0),
                              ),
                              Padding(
                                padding: const EdgeInsets.fromLTRB(0, 0, 8.0, 0),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Icon(
                                      Icons.location_on,
                                      size: 10,
                                    ),
                                    Expanded(
                                      child: Text(
                                        farmerModel.address1!,
                                        maxLines: 3,
                                        overflow: TextOverflow.ellipsis,
                                        textAlign: TextAlign.start,
                                        style: const TextStyle(color: Colors.black, fontSize: 12.0),
                                      ),
                                    )
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(60, 0, 10, 5),
                      child: Row(mainAxisAlignment: MainAxisAlignment.end, mainAxisSize: MainAxisSize.max, children: [
                        Expanded(
                            child: ElevatedButton.icon(
                          onPressed: () {
                            Navigator.push(
                                context, MaterialPageRoute(builder: (context) => ChatScreen(buyerId: farmerModel.id!, farmerName: farmerModel.firstName! + " " + farmerModel.lastName!, from: "chat")));
                          },
                          label: Text('key_chat'.tr, style: const TextStyle(color: Colors.white)),
                          icon: const Icon(
                            Icons.chat,
                            color: Colors.white,
                          ),
                          style: ElevatedButton.styleFrom(backgroundColor: Colors.orangeAccent),
                        )),
                        const SizedBox(width: 10),
                        Visibility(
                          visible: false,
                          child: Expanded(
                              child: ElevatedButton.icon(
                            onPressed: () {
                              _startCall(farmerModel.id!);
                            },
                            label: Text(
                              'key_video'.tr,
                              style: const TextStyle(color: Colors.white),
                            ),
                            icon: const Icon(Icons.videocam_rounded, color: Colors.white),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                            ),
                          )),
                        ),
                      ]),
                    )
                  ],
                ))));
  }

  Future<List<FarmerData>> fetchFarmer() async {
    try {
      setState(() {
        _isLoading = true;
      });
      //var headerModel =
      //    Provider.of<HeaderModel>(context, listen: false);
      String connectionServerMsg = await NetworkHandler.getServerWorkingUrl();
      if (connectionServerMsg != "key_check_internet") {
        Uri fetchSchoolsUri = Uri.parse(baseURL + ApiURL.farmerList + "/" + paramsMaps.userId!);

        // print(fetchSchoolsUri);

        http.Response response = await http.get(fetchSchoolsUri, headers: headerParams);
        var data = json.decode(response.body);
        Farmer farmerss = Farmer.fromJson(data);
        if (farmerss.success != 1) {
          WidgetUtils.errorDialog(context, data["msg"]);
        } else {
          setState(() {
            List<FarmerData> farmerData = farmerss.data;
            if (farmerData != null) {
              farmer = farmerss.data;
            }
          });
        }
      } else {
        /*WidgetUtils.errorDialog(context,
            AppTranslations.of(context)?.text("key_connection_lost") ??
                'key_connection_lost'.tr,2);*/
      }
    } on SocketException {
      /*WidgetUtils.errorDialog(context,
          AppTranslations.of(context)?.text("key_connection_lost") ??
              'key_connection_lost'.tr,2);*/
    } catch (e) {
      // print(e);
      // WidgetUtils.errorDialog(context, e.toString(),backgroundColor: primaryExtraLight1);
    }
    setStateIfMounted(() {
      _isLoading = false;
    });

    return farmer;
  }

  void setStateIfMounted(f) {
    if (mounted) setState(f);
  }

  Future<void> _startCall(String farmerid) async {
    setState(() {
      _isLoading = true;
      _loadingText = "";
    });
    try {
      //var headerModel =
      //    Provider.of<HeaderModel>(context, listen: false);
      String connectionServerMsg = await NetworkHandler.getServerWorkingUrl();
      if (connectionServerMsg != "key_check_internet") {
        Uri getUserDetailsUri = Uri.parse(baseURL + ApiURL.startMeetingCall);
        var request = http.MultipartRequest('POST', getUserDetailsUri);
        request.fields['farmer_id'] = farmerid;
        request.fields['user_id'] = paramsMaps.userId!;
        request.headers["client-type"] = "seller";
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
            //  _joinMeeting(video, farmerid);
          });
        }
      } else {
        /*WidgetUtils.errorDialog(context,
            AppTranslations.of(context)?.text("key_connection_lost") ??
                'key_connection_lost'.tr,2);*/
      }
    } on SocketException {
      /* WidgetUtils.errorDialog(context,
          AppTranslations.of(context)?.text("key_connection_lost") ??
              'key_connection_lost'.tr,2);*/
    } catch (e) {
      // print(e);
      WidgetUtils.informationDialog(context, e.toString());
    }
    setState(() {
      _isLoading = false;
    });
  }

  hidePhoneNumber(String number) {
    String newNumber = number;
    String replaceCharAt(String oldString, int index, String newChar) {
      return oldString.substring(0, index) + newChar + oldString.substring(index + 1);
    }

    for (int i = 2; i < number.length; i++) {
      newNumber = replaceCharAt(newNumber, i, "*");
      // print("PHONE_NUMBER_LOOP:$newNumber");
    }
    // print("FinalNumber:$newNumber");
    return newNumber;
  }
}
