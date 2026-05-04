import 'package:nedfi_seller_common_code/app_imports.dart';
import 'package:get/get.dart';

import '../../model/npk_detail_model.dart';
import '../../providers/npk_provider.dart';

class NPKListScreen extends StatefulWidget {
  String? cropType, landArea, type, n, p, k, s, cropName, season;

  NPKListScreen({super.key, this.cropType, this.landArea, this.type, this.n, this.p, this.k, this.s, this.cropName, this.season});

  @override
  _NPKListScreenState createState() => _NPKListScreenState();
}

class _NPKListScreenState extends State<NPKListScreen> {
  bool? isLoading = false, _serviceEnabled;
  String loadingText = 'Loading..';
  bool? _isLoading, _large, _medium;
  double? _pixelRatio, bottom1;
  Size? size;
  String? _loadingText;
  NPKSDetailsModel? npkResponse;
  final iosAppBarRGBAColor = TextEditingController(text: "#0080FF80");

  @override
  void initState() {
    super.initState();
    _isLoading = false;
    _loadingText = 'Loading . . .';
    fetchFarmer();
  }

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    var scrWidth = MediaQuery.of(context).size.width;
    _pixelRatio = MediaQuery.of(context).devicePixelRatio;
    _large = ResponsiveWidget.isScreenLarge(scrWidth, _pixelRatio!);
    _medium = ResponsiveWidget.isScreenMedium(scrWidth, _pixelRatio!);
    return Consumer<NPKProvider>(builder: (context, nPKModel, child) {
      return SafeArea(
        child: Scaffold(
            backgroundColor: Colors.transparent,
            appBar: AppBar(
              elevation: 0,
              centerTitle: true,
              backgroundColor: Color(int.parse(themeColor.value.barColor!.color!)),
              title: WidgetUtils.appTextWidget(
                  context: context, title: npkResponse != null ? npkResponse!.details!.requiredNpk! : 'NPK List'.tr, color: Colors.white, family: 'Graphik', fontSize: 18, fontWeight: FontWeight.w500),
              iconTheme: const IconThemeData(color: Colors.white),
            ),
            body: CustomProgressHandler(
              isLoading: _isLoading!,
              loadingText: _loadingText!,
              child: SafeArea(
                  child: Scaffold( backgroundColor: Colors.white,
                //  backgroundColor: ColorsConst.backgroundColor,
                body: ListView(
                  children: [
                    const Padding(
                      padding: EdgeInsets.all(5.0),
                      child: Text(
                        "Suggested Dose",
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.black, fontSize: 15.0),
                      ),
                    ),
                    ListView.builder(
                        itemCount: nPKModel.npkList.length,
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          return _farmerItem(nPKModel.npkList[index], index);
                        }),
                  ],
                ),
              )),
            )),
      );
    });
  }

  Widget _farmerItem(NpkValues? npkData, int index) {
    return GestureDetector(
        onTap: () {},
        child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            // decoration: BoxDecoration(borderRadius: BorderRadius.circular(10.0), color: Colors.white, border: Border.all(color: Colors.grey, width: 0.5)),
            // clipBehavior: Clip.antiAliasWithSaveLayer,
            child: Card(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 6),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    npkData!.url != null
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                decoration:
                                    BoxDecoration(color: const Color(0xffCFE7D8), border: Border.all(color: Theme.of(context).primaryColor, width: 1.0), borderRadius: BorderRadius.circular(5)),
                                child: Padding(
                                  padding: const EdgeInsets.all(6.0),
                                  child: WidgetUtils.appTextWidget(
                                      context: context,
                                      title: 'Combination  '.tr + (index + 1).toString(),
                                      fontWeight: FontWeight.w500,
                                      family: 'Graphik',
                                      textAlign: TextAlign.center,
                                      color: Colors.green,
                                      fontSize: 14.0),
                                ),
                              ),
                              SizedBox(
                                height: 30,
                                child: TextButton(
                                  child: Text(
                                    "See Schedule".tr,
                                    style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w400, fontFamily: 'Graphik', color: Colors.green, decoration: TextDecoration.underline),
                                  ),
                                  onPressed: () {
                                    Navigator.push(context, MaterialPageRoute(builder: (ctx) => NPKSDetailsScreen(url: npkData!.url!)));
                                  },
                                ),
                              )
                            ],
                          )
                        : Container(
                            decoration: BoxDecoration(color: const Color(0xffCFE7D8), border: Border.all(color: Theme.of(context).primaryColor, width: 1.0), borderRadius: BorderRadius.circular(5)),
                            child: Padding(
                              padding: const EdgeInsets.all(6.0),
                              child: WidgetUtils.appTextWidget(
                                  context: context,
                                  title: 'Combination  '.tr + (index + 1).toString(),
                                  fontWeight: FontWeight.w500,
                                  family: 'Graphik',
                                  textAlign: TextAlign.center,
                                  color: Colors.green,
                                  fontSize: 14.0),
                            ),
                          ),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.01),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          flex: 1,
                          child: WidgetUtils.appTextWidget(
                              context: context,
                              title: npkData!.line1 == "" ? "" : npkData.line1!.split(",")[0],
                              textAlign: TextAlign.start,
                              color: const Color(0xff0F853B),
                              fontSize: 12.0,
                              family: 'Graphik',
                              fontWeight: FontWeight.w400),
                        ),
                        Flexible(
                          flex: 1,
                          child: Container(
                            child: WidgetUtils.appTextWidget(
                                context: context,
                                title: npkData.line1 == "" ? "" : npkData.line1!.split(",")[1],
                                textAlign: TextAlign.start,
                                color: Colors.black,
                                fontSize: 12.0,
                                family: 'Graphik',
                                fontWeight: FontWeight.w400),
                          ),
                        ),
                        Flexible(
                          flex: 2,
                          child: Container(
                            child: WidgetUtils.appTextWidget(
                                context: context,
                                title: npkData.line1 == "" ? "" : npkData.line1!.split(",")[2],
                                textAlign: TextAlign.start,
                                color: Colors.black,
                                fontSize: 12.0,
                                family: 'Graphik',
                                fontWeight: FontWeight.w400),
                          ),
                        ),
                        Flexible(
                          flex: 1,
                          child: Container(
                            child: WidgetUtils.appTextWidget(
                                context: context,
                                title: npkData.line1 == "" ? "" : npkData.line1!.split(",")[3],
                                textAlign: TextAlign.end,
                                color: Colors.black,
                                fontSize: 12.0,
                                family: 'Graphik',
                                fontWeight: FontWeight.w400),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          flex: 1,
                          child: Container(
                            child: WidgetUtils.appTextWidget(
                                context: context,
                                title: npkData.line2 == "" ? "" : npkData.line2!.split(",")[0],
                                textAlign: TextAlign.start,
                                color: const Color(0xff0F853B),
                                fontSize: 12.0,
                                family: 'Graphik',
                                fontWeight: FontWeight.w400),
                          ),
                        ),
                        Flexible(
                          flex: 1,
                          child: Container(
                            child: WidgetUtils.appTextWidget(
                                context: context,
                                title: npkData.line2! == "" ? "" : npkData.line2!.split(",")[1],
                                textAlign: TextAlign.start,
                                color: Colors.black,
                                fontSize: 12.0,
                                family: 'Graphik',
                                fontWeight: FontWeight.w400),
                          ),
                        ),
                        Flexible(
                          flex: 2,
                          child: Container(
                            child: WidgetUtils.appTextWidget(
                                context: context,
                                title: npkData.line2! == "" ? "" : npkData.line2!.split(",")[2],
                                textAlign: TextAlign.start,
                                color: Colors.black,
                                fontSize: 12.0,
                                family: 'Graphik',
                                fontWeight: FontWeight.w400),
                          ),
                        ),
                        Flexible(
                          flex: 1,
                          child: Container(
                            child: WidgetUtils.appTextWidget(
                                context: context,
                                title: npkData.line2! == "" ? "" : npkData.line2!.split(",")[3],
                                textAlign: TextAlign.end,
                                color: Colors.black,
                                fontSize: 12.0,
                                family: 'Graphik',
                                fontWeight: FontWeight.w400),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          flex: 1,
                          child: Container(
                            child: WidgetUtils.appTextWidget(
                                context: context,
                                title: npkData.line3 == "" ? "" : npkData.line3!.split(",")[0],
                                textAlign: TextAlign.start,
                                color: const Color(0xff0F853B),
                                fontSize: 12.0,
                                family: 'Graphik',
                                fontWeight: FontWeight.w400),
                          ),
                        ),
                        Flexible(
                          flex: 1,
                          child: Container(
                            child: WidgetUtils.appTextWidget(
                                context: context,
                                title: npkData.line3 == "" ? "" : npkData.line3!.split(",")[1],
                                textAlign: TextAlign.start,
                                color: Colors.black,
                                fontSize: 12.0,
                                family: 'Graphik',
                                fontWeight: FontWeight.w400),
                          ),
                        ),
                        Flexible(
                          flex: 2,
                          child: Container(
                            child: WidgetUtils.appTextWidget(
                                context: context,
                                title: npkData.line3 == "" ? "" : npkData.line3!.split(",")[2],
                                textAlign: TextAlign.start,
                                color: Colors.black,
                                fontSize: 12.0,
                                family: 'Graphik',
                                fontWeight: FontWeight.w400),
                          ),
                        ),
                        Flexible(
                          flex: 1,
                          child: Container(
                            child: WidgetUtils.appTextWidget(
                                context: context,
                                title: npkData.line3 == "" ? "" : npkData.line3!.split(",")[3],
                                textAlign: TextAlign.end,
                                color: Colors.black,
                                fontSize: 12.0,
                                family: 'Graphik',
                                fontWeight: FontWeight.w400),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    npkData.line4 != null
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Flexible(
                                flex: 1,
                                child: Container(
                                  child: WidgetUtils.appTextWidget(
                                      context: context,
                                      title: npkData.line4?.split(",")[0] ?? "",
                                      textAlign: TextAlign.start,
                                      color: const Color(0xff0F853B),
                                      fontSize: 12.0,
                                      family: 'Graphik',
                                      fontWeight: FontWeight.w400),
                                ),
                              ),
                              Flexible(
                                flex: 1,
                                child: Container(
                                  child: WidgetUtils.appTextWidget(
                                      context: context,
                                      title: npkData.line4?.split(",")[1] ?? "",
                                      textAlign: TextAlign.start,
                                      color: Colors.black,
                                      fontSize: 12.0,
                                      family: 'Graphik',
                                      fontWeight: FontWeight.w400),
                                ),
                              ),
                              Flexible(
                                flex: 2,
                                child: Container(
                                  child: WidgetUtils.appTextWidget(
                                      context: context,
                                      title: npkData.line4 == "" ? "" : npkData.line4!.split(",")[2],
                                      textAlign: TextAlign.start,
                                      color: Colors.black,
                                      fontSize: 12.0,
                                      family: 'Graphik',
                                      fontWeight: FontWeight.w400),
                                ),
                              ),
                              Flexible(
                                flex: 1,
                                child: Container(
                                  child: WidgetUtils.appTextWidget(
                                      context: context,
                                      title: npkData.line4 == "" ? "" : npkData.line4!.split(",")[3],
                                      textAlign: TextAlign.end,
                                      color: Colors.black,
                                      fontSize: 12.0,
                                      family: 'Graphik',
                                      fontWeight: FontWeight.w400),
                                ),
                              ),
                            ],
                          )
                        : Container(),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 4.0),
                      child: Divider(),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        WidgetUtils.appTextWidget(context: context, title: "Total    ", color: const Color(0xff0F853B), fontSize: 14.0, family: 'Graphik', fontWeight: FontWeight.w500),
                        WidgetUtils.appTextWidget(
                            context: context, title: npkData.total!, textAlign: TextAlign.end, color: Colors.black, fontSize: 14.0, family: 'Graphik', fontWeight: FontWeight.w500),
                      ],
                    ),
                  ],
                ),
              ),
            )));
  }

  Future fetchFarmer() async {
    try {
      setState(() {
        _isLoading = true;
      });
      String connectionServerMsg = NetworkHandler.getServerWorkingUrl();
      if (connectionServerMsg != "key_check_internet") {
        final params = {
          "crop_id": widget.cropType!,
          "n": widget.n ?? "",
          "p": widget.p ?? "",
          "k": widget.k ?? "",
          "s": widget.s ?? "",
          "size": widget.landArea ?? "",
          "unit": widget.type ?? "",
          "season": widget.season
        };
        final response = await APIService.postAPIMethod(url: ApiURL.cropNPKDetails, params: params);
        var data = json.decode(response.body);
        // print(data);
        npkResponse = NPKSDetailsModel.fromJson(data);
        if (npkResponse!.success != 1) {
          WidgetUtils.errorDialog(context, data["msg"]);
        } else {
          var dSSModel = Provider.of<NPKProvider>(context, listen: false);
          dSSModel.setNPKList(npkResponse!.details!.npkValues!);
        }
      }
    } catch (e) {
      // print(e);
      // WidgetUtils.errorDialog(context, e.toString(),backgroundColor: primaryExtraLight1);
    }
    setStateIfMounted(() {
      _isLoading = false;
    });
  }

  // @override
  // void dispose() {
  //   // TODO: implement dispose
  //   var dSSModel = Provider.of<NPKModel>(context, listen: false);
  //   dSSModel.setnpkList([]);
  //   super.dispose();
  // }

  void setStateIfMounted(f) {
    if (mounted) setState(f);
  }
}
